//
//  NetWorkingManager.m
//  PowerBank
//
//  Created by 麦鱼科技 on 2017/7/11.
//  Copyright © 2017年 麦鱼科技. All rights reserved.
//

#import "NetWorkingManager.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"
#import "NSString+LBExtension.h"

static NetWorkingManager *manager = nil;

static AFHTTPSessionManager *afManager = nil;

@implementation NetWorkingManager

+ (NetWorkingManager *)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NetWorkingManager alloc]init];
        afManager = [AFHTTPSessionManager manager];
        afManager.responseSerializer = [AFJSONResponseSerializer serializer];
        afManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        afManager.responseSerializer.acceptableContentTypes =
        [NSSet setWithObjects:
         @"application/json",
         @"text/json",
         @"text/JavaScript",
         @"text/html",
         @"text/plain",
         @"image/jpeg",
         @"image/png",
         @"application/x-www-form-urlencoded",
         @"application/octet-stream",  nil];
    });
    return manager;
}
/*
 0		    ：成功
 100		：参数错误
 101		：用户不存在
 102		：密码不正确
 103		：验证码不正确
 104		：码过期
 105		：无权限(需登录)
 106		：token过期
 107		：token不存在
 
 201		：券已过期
 202		：优惠券领取失败
 203		：不可重复领取
 
 501		：押金不足
 502		：余额不足
 503		：暂无设备可用
 504		：暂无可用仓位
 505		：支付金额有误
 
 600		: 未知逻辑错误
 601		：请求数据有误(空指针异常)
 602		：系统异常
 */
- (void)postWithUrl:(NSString *)url params:(NSDictionary *)params succeed:(Succeed)succeed failed:(Failed)failed {
    afManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self __postWithUrl:url params:params succeed:succeed failed:failed];
}

- (void)postJSONWithUrl:(NSString *)url params:(NSDictionary *)params succeed:(Succeed)succeed failed:(Failed)failed {
    afManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self __postWithUrl:url params:params succeed:succeed failed:failed];
}

- (void)__postWithUrl:(NSString *)url params:(NSDictionary *)params succeed:(Succeed)succeed failed:(Failed)failed {
    //NSLog(@"----uid:%d -----",[UserLoginModelManager shareManager].userInfoModel.uid);
    afManager.requestSerializer.timeoutInterval = 20;
    CBPetLoginModel *userInfoModel = [CBPetLoginModelTool getUser];
    [afManager.requestSerializer setValue:userInfoModel.token?:@"" forHTTPHeaderField:@"token"];
    [afManager.requestSerializer setValue:[NSString stringWithFormat:@"%@",userInfoModel.uid] forHTTPHeaderField:@"uid"];
    NSString *newUrl = [BASE_URL_CarNet stringByAppendingString:[NSString stringWithFormat:@"%@",[url hasStringInPrefix:@"/"]]];
    NSLog(@"--------地址：%@",newUrl);
    NSLog(@"--------参数：%@",params);
    [afManager POST:newUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            [HUD hideHud];
            //NSLog(@"---------结果：%@",responseObject);
            if([responseObject[@"status"]integerValue] == 0) {//成功
                succeed(responseObject,YES);
            } else if([responseObject[@"status"]integerValue] == 105 ||
                      [responseObject[@"status"]integerValue] == 106 ||
                      [responseObject[@"status"]integerValue] == 107) {
                succeed(responseObject,NO);
                [HUD showHUDWithText: @"登 录 已 过 期\n请 重 新 登 录!" withDelay:1.2];
                
                // 清除本地选中的设备信息
                [CBCommonTools deleteCBDeviceInfo];
                // 登录超时，请重新登录
                CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
                userModel.token = nil;
                [CBPetLoginModelTool saveUser:userModel];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"K_SwitchLoginViewController" object:nil];
                
            } else if ([responseObject[@"status"]integerValue] == 602) {
                succeed(responseObject,NO);
                [CBTopAlertView alertFail:Localized(@"设备不在线")];
            } else if ([responseObject[@"status"]integerValue] == 1) {
                succeed(responseObject,NO);
                [HUD showHUDWithText:[Utils getSafeString:Localized(@"授权号码已存在")] withDelay:2.0];
            } else if ([responseObject[@"status"]integerValue] == 205) { //从CBWtNetworkingServers移植过来的逻辑
                succeed(responseObject,NO);
                //状态205，代码联系人达到上限12个。。app这边有这样错误时提示“联系人已达上限”
                [MBProgressHUD showMessage:Localized(@"联系人列表已满") withDelay:1.5];
            } else if ([responseObject[@"status"]integerValue] == 402) {
                succeed(responseObject,NO);
                [CBTopAlertView alertFail:Localized(@"设备号不存在或者重复绑定")];
            }
            else {
                succeed(responseObject,NO);
                //int wrongCode = [responseObject[@"status"] intValue];
                // 多语言用
//                NSArray *array = @[@100,@101,@102,@103,@104,@105,@106,@107,@108,@109,@110,@111,@112,@113,
//                                   @201,@202,@203,@210,@211,@223,@224,@225,@226,@227,@228,
//                                   @301,
//                                   @501,@502,@503,@504,@505,@506,@507,@508,@509,@510,@511,@512,@513,@514,
//                                   @401,@402,
//                                   @600,@601];
//                if ([array containsObject: [NSNumber numberWithInt: wrongCode]]) {
//                    NSString *wrongCodeString = [NSString stringWithFormat: @"wrong_code_%ld", [responseObject[@"status"]integerValue]];
//                    [HUD showHUDWithText:[Utils getSafeString: Localized(wrongCodeString)]];
//                }else {
                    //[HUD showHUDWithText:[Utils getSafeString: responseObject[@"resmsg"]] withDelay:1.2];
//                }
                
                [CBTopAlertView alertFail:[Utils getSafeString: responseObject[@"resmsg"]]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BOOL isFailed = [self login:task];
        failed(error);
        if (isFailed) {
            [MBProgressHUD showMessage:Localized(@"请求超时") withDelay:1.5];
        }
    }];
}

/**
 登录失效
 */
- (void)loginOut {
//    [[AppDelegate shareInstance]loginout];
//    [kNotifyCenter postNotificationName:kLeftSeletedNotify object:nil userInfo:@{@"index":@9}];
    CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
    userModel.token = nil;
    [CBPetLoginModelTool saveUser:userModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"K_SwitchLoginViewController" object:nil];
}

- (void)getWithUrl:(NSString *)url params:(NSDictionary *)params succeed:(Succeed)succeed failed:(Failed)failed {
    afManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //NSLog(@"----uid:%d -----",[UserLoginModelManager shareManager].userInfoModel.uid);
    CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
    afManager.requestSerializer.timeoutInterval = 20;
    [afManager.requestSerializer setValue:userModel.token?:@"" forHTTPHeaderField:@"token"];
    [afManager.requestSerializer setValue:[NSString stringWithFormat:@"%@",userModel.uid] forHTTPHeaderField:@"uid"];
    NSString *newUrl = [BASE_URL_CarNet stringByAppendingString:[NSString stringWithFormat:@"%@",[url hasStringInPrefix:@"/"]]];
    NSLog(@"--------地址：%@",newUrl);
    NSLog(@"--------参数：%@",params);
    [afManager GET:newUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"---------结果：%@",responseObject);
        if (responseObject) {
            if([responseObject[@"status"]integerValue] == 0) {//成功
                succeed(responseObject,YES);
            } else if ([responseObject[@"status"]integerValue] == 105 || [responseObject[@"status"]integerValue] == 106 || [responseObject[@"status"]integerValue] == 107){
                succeed(responseObject,NO);
                [HUD showHUDWithText: @"登 录 已 过 期\n请 重 新 登 录!" withDelay:1.2];
                [self loginOut];
                
                // 清除本地选中的设备信息
                [CBCommonTools deleteCBDeviceInfo];
                // 登录超时，请重新登录
                CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
                userModel.token = nil;
                [CBPetLoginModelTool saveUser:userModel];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"K_SwitchLoginViewController" object:nil];
                
            } else if ([responseObject[@"status"]integerValue] == 602) {
                succeed(responseObject,NO);
                [HUD showHUDWithText:[Utils getSafeString:Localized(@"设备不在线")] withDelay:2.0];
            }
            else {
                succeed(responseObject,NO);
                //int wrongCode = [responseObject[@"status"] intValue];
                // 多语言用
//                NSArray *array = @[@100,@101,@102,@103,@104,@105,@106,@107,@108,@109,@110,@111,@112,@113,
//                                   @201,@202,@203,@210,@211,@223,@224,@225,@226,@227,@228,
//                                   @301,
//                                   @501,@502,@503,@504,@505,@506,@507,@508,@509,@510,@511,@512,@513,@514,
//                                   @401,@402,
//                                   @600,@601];
//                if ([array containsObject: [NSNumber numberWithInt: wrongCode]]) {
//                    NSString *wrongCodeString = [NSString stringWithFormat: @"wrong_code_%ld", [responseObject[@"status"]integerValue]];
//                    [HUD showHUDWithText:[Utils getSafeString: Localized(wrongCodeString)]];
//                }else {
                    //[HUD showHUDWithText:[Utils getSafeString: responseObject[@"resmsg"]] withDelay:1.2];
//                }
                
                [HUD showHUDWithText:[Utils getSafeString: responseObject[@"resmsg"]] withDelay:1.2];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BOOL isFailed = [self login:task];
        failed(error);
        if (isFailed) {
            [MBProgressHUD showMessage:Localized(@"请求超时") withDelay:1.5];
        }
    }];
}

//从CBWtNetworkingServers移植过来的逻辑
- (BOOL)login:(NSURLSessionDataTask *)task {
    NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
    if (responses.statusCode == 401) { // // 401 token 失效// 404 服务器连接失败，网络异常// 500 服务器出错
        // 清除本地选中的设备token
//        CBWtUserLoginModel *userModel = [CBWtUserLoginModel CBaccount];
//        userModel.token = nil;
//        [CBWtUserLoginModel saveCBAccount:userModel];
        
        CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
        userModel.token = nil;
        [CBPetLoginModelTool saveUser:userModel];
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:Localized(@"用户信息异常，请重新登录") preferredStyle:UIAlertControllerStyleAlert];
        // 知道了
        [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"重新登录") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 登录超时，请重新登录
                [[NSNotificationCenter defaultCenter] postNotificationName:KCBWt_SwitchCBWtLoginViewController object:nil];
            });
        }]];
        //[[CBWtCommonTools getCurrentVC] presentViewController:alertControl animated:YES completion:nil];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControl animated:YES completion:nil];
        return NO;
    } else {
        return YES;
    }
}

@end
