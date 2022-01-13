//
//  CBWtNetWorkingManager.m
//  PowerBank
//
//  Created by 麦鱼科技 on 2017/7/11.
//  Copyright © 2017年 麦鱼科技. All rights reserved.
//

#import "CBWtNetWorkingManager.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

static CBWtNetWorkingManager *manager = nil;

static AFHTTPSessionManager *afManager = nil;

@implementation CBWtNetWorkingManager

+ (CBWtNetWorkingManager *)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CBWtNetWorkingManager alloc]init];
        afManager = [AFHTTPSessionManager manager];
        afManager.responseSerializer = [AFJSONResponseSerializer serializer];
        afManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/JavaScript",@"text/html",@"text/plain",@"image/jpeg",
                                                               @"image/png", @"application/octet-stream",  nil];
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
- (void)postWithUrl:(NSString *)url params:(NSDictionary *)params succeed:(Succeed)succeed failed:(Failed)failed{
    //CBWtUserLoginModel *userInfoModel = [CBWtUserLoginModel CBaccount];
    CBPetLoginModel *userInfoModel = [CBPetLoginModelTool getUser];
    afManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [afManager.requestSerializer setValue:userInfoModel.token forHTTPHeaderField:@"token"];
    [afManager.requestSerializer setValue:[NSString stringWithFormat:@"%d",userInfoModel.uid] forHTTPHeaderField:@"uid"];
    NSString *newUrl = [BASE_URL stringByAppendingString:url];
    NSLog(@"--------地址：%@",newUrl);
    NSLog(@"--------参数：%@",params);
    [afManager POST:newUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            [HUD hideHud];
            //NSLog(@"---------结果：%@",responseObject);
            if([responseObject[@"status"]integerValue] == 0) {//成功
                succeed(responseObject,YES);
            } else if([responseObject[@"status"]integerValue] == 105 || [responseObject[@"status"]integerValue] == 106 || [responseObject[@"status"]integerValue] == 107) {
                succeed(responseObject,NO);
                [HUD showHUDWithText: @"登 录 已 过 期\n请 重 新 登 录!"];
                [self loginOut];
            } else if ([responseObject[@"status"]integerValue] == 602) {
                succeed(responseObject,NO);
                [MBProgressHUD showMessage:Localized(@"设备不在线") withDelay:1.5];
            } else if([responseObject[@"status"]integerValue] == 205) {
                succeed(responseObject,NO);
                //状态205，代码联系人达到上限12个。。app这边有这样错误时提示“联系人已达上限”
                [MBProgressHUD showMessage:Localized(@"联系人列表已满") withDelay:1.5];
            } else {
                succeed(responseObject,NO);
                //int wrongCode = [responseObject[@"status"] intValue];
                [MBProgressHUD showMessage:responseObject[@"resmsg"] withDelay:1.5];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BOOL isFailed = [self loginResult:task];
        failed(error);
        if (isFailed) {
            [MBProgressHUD showMessage:Localized(@"请求超时") withDelay:1.5];
        }
    }];
}

/**
 登录失效
 */
- (void)loginOut{
    //[[AppDelegate shareInstance]loginout];
    CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
    userModel.token = nil;
    [CBPetLoginModelTool saveUser:userModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"K_SwitchLoginViewController" object:nil];
}

- (void)getWithUrl:(NSString *)url params:(NSDictionary *)params succeed:(Succeed)succeed failed:(Failed)failed{
    //CBWtUserLoginModel *userInfoModel = [CBWtUserLoginModel CBaccount];
    CBPetLoginModel *userInfoModel = [CBPetLoginModelTool getUser];
    afManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [afManager.requestSerializer setValue:userInfoModel.token forHTTPHeaderField:@"token"];
    [afManager.requestSerializer setValue:[NSString stringWithFormat:@"%@",userInfoModel.uid] forHTTPHeaderField:@"uid"];
    NSString *newUrl = [BASE_URL stringByAppendingString:url];
    NSLog(@"--------地址：%@",newUrl);
    NSLog(@"--------参数：%@",params);
    [afManager GET:newUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"---------结果：%@",responseObject);
        if (responseObject) {
            if([responseObject[@"status"]integerValue] == 0) {//成功
                succeed(responseObject,YES);
            }else if([responseObject[@"status"]integerValue] == 105 || [responseObject[@"status"]integerValue] == 106 || [responseObject[@"status"]integerValue] == 107){
                succeed(responseObject,NO);
//                [HUD showHUDWithText: Localized(@"HUD_LoginExpiry")];
                [HUD showHUDWithText: @"登 录 已 过 期\n请 重 新 登 录!"];
                [self loginOut];
            } else if ([responseObject[@"status"]integerValue] == 602) {
                succeed(responseObject,NO);
                [HUD showHUDWithText: Localized(@"设备不在线")];
            } else {
                succeed(responseObject,NO);
                [HUD showHUDWithText: responseObject[@"resmsg"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BOOL isFailed = [self loginResult:task];
        failed(error);
        if (isFailed) {
            [MBProgressHUD showMessage:Localized(@"请求超时") withDelay:1.5];
        }
    }];
}
- (BOOL)loginResult:(NSURLSessionDataTask *)task {
    NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
    if (responses.statusCode == 401) { // // 401 token 失效// 404 服务器连接失败，网络异常// 500 服务器出错
        // 清除本地选中的设备token
//        CBWtUserLoginModel *userModel = [CBWtUserLoginModel CBaccount];
//        userModel.token = nil;
//        [CBWtUserLoginModel saveCBAccount:userModel];
        
        CBPetLoginModel *userInfoModel = [CBPetLoginModelTool getUser];
        userInfoModel.token = nil;
        [CBPetLoginModelTool saveUser:userInfoModel];
        
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
