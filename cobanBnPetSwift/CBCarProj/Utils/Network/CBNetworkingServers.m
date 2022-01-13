//
//  CBNetworkingServers.m
//  Telematics
//
//  Created by coban on 2019/7/17.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBNetworkingServers.h"
//#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "NSString+LBExtension.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

// v2.0
//static NSString *baseUrl = @"http://120.76.63.241/BNCLW_Server/";              // 测试环境
//static NSString *baseUrl = @"http://47.107.57.114/BNCLW_Server";              // 测试环境
//static NSString *baseUrl = @"http://192.168.1.138:8080/BNCLW_Server";        // 开发环境
//static NSString *baseUrl = @"http://156.231.38.158/BNCLW_Server";            // 正式环境(ip)
//static NSString *baseUrl = @"http://www.baanool.net:8089/BNCLW_Server";            // 正式环境(域名)


static NSString *requestRounting = @"";//@"/api";

@implementation CBNetworkingServers

static BDTRequestSucceedBlock _requestSucceedBlock;

+ (void)setRequestSucceedBlock:(BDTRequestSucceedBlock)requestSucceedBlock {
    if (_requestSucceedBlock != requestSucceedBlock) {
        _requestSucceedBlock = requestSucceedBlock;
    }
}
+ (BDTRequestSucceedBlock)requestSucceedBlock {
    return _requestSucceedBlock;
}

//通用网络请求
+ (NSURLSessionDataTask *)networkRequestType:(CBNetworkRequestType)type path:(NSString *)path param:(NSMutableDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPSessionManager *manager = [self sessionManagerWithToken:@"loginModel.token" parameters:param];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",[CBNetworkingServers requestUrl], [CBNetworkingServers requestRounting],[path hasStringInPrefix:@"/"]];
    NSLog(@"%s 请求url :%@",__FUNCTION__,url);
    NSLog(@"%s 请求paramters :%@",__FUNCTION__,param);
    NSURLSessionDataTask *dataTask = nil;
    switch (type) {
        case CBNetworkRequestTypePost: {
            dataTask = [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //NSLog(@"%s  \n %@",__FUNCTION__, responseObject);
                if (kStringIsEmpty([CBPetLoginModelTool getUser].token)) {
                    // 清除本地选中的设备信息
                    [CBCommonTools deleteCBDeviceInfo];
                    // 登录超时，请重新登录
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"K_SwitchLoginViewController" object:nil];
                }
                CBBaseNetworkModel *baseModel = [CBBaseNetworkModel mj_objectWithKeyValues:responseObject];
                if ([responseObject[@"status"]integerValue] == 602) {
                    [HUD showHUDWithText:[Utils getSafeString:Localized(@"设备不在线")] withDelay:2.0];
                }
                if (baseModel) {
                    success(baseModel);
                } else {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                BOOL isFailed = [self login:task];
                failure(error);
                if (isFailed) {
                    [MINUtils showProgressHudToView:[AppDelegate shareInstance].window withText:Localized(@"请求超时")];
                }
            }];
        }
            break;
        case CBNetworkRequestTypeGet: {
            dataTask = [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //NSLog(@"%s  \n %@",__FUNCTION__, responseObject);
                //if (kStringIsEmpty([UserLoginModelManager shareManager].userInfoModel.token)) {
                if ([responseObject[@"status"]integerValue] == 602) {
                    [HUD showHUDWithText:[Utils getSafeString:Localized(@"设备不在线")] withDelay:2.0];
                }
                if (kStringIsEmpty([CBPetLoginModelTool getUser].token)) {
                    // 清除本地选中的设备信息
                    [CBCommonTools deleteCBDeviceInfo];
                    // 登录超时，请重新登录
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"K_SwitchLoginViewController" object:nil];
                }
                CBBaseNetworkModel *baseModel = [CBBaseNetworkModel mj_objectWithKeyValues:responseObject];
                if (baseModel) {
                    success(baseModel);
                } else {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                BOOL isFailed = [self login:task];
                failure(error);
                if (isFailed) {
                    [MINUtils showProgressHudToView:[AppDelegate shareInstance].window withText:Localized(@"请求超时")];
                }
            }];
        }
            break;
        case CBNetworkRequestTypePut:
        {
            dataTask = [manager PUT:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //NSLog(@"%s  \n %@",__FUNCTION__, responseObject);
                if ([responseObject[@"status"]integerValue] == 602) {
                    [HUD showHUDWithText:[Utils getSafeString:Localized(@"设备不在线")] withDelay:2.0];
                }
                CBBaseNetworkModel *baseModel = [CBBaseNetworkModel mj_objectWithKeyValues:responseObject];
                if (baseModel) {
                    success(baseModel);
                } else {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
        case CBNetworkRequestTypeDELETE:
        {
            dataTask = [manager DELETE:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //NSLog(@"%s  \n %@",__FUNCTION__, responseObject);
                if ([responseObject[@"status"]integerValue] == 602) {
                    [HUD showHUDWithText:[Utils getSafeString:Localized(@"设备不在线")] withDelay:2.0];
                }
                CBBaseNetworkModel *baseModel = [CBBaseNetworkModel mj_objectWithKeyValues:responseObject];
                if (baseModel) {
                    success(baseModel);
                } else {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
        default: {
            dataTask = [NSURLSessionDataTask new];
        }
            break;
    }
    return  dataTask;
    
}


//调试用网络请求
//绝对url 网络请求
+ (NSURLSessionDataTask *)networkOriginRequestType:(CBNetworkRequestType)type url:(NSString *)url param:(NSMutableDictionary *)param success:(originSuccessBlock)success failure:(originFailureBlock)failure
{
    //BDTLoginModel *loginModel = [BDTAccountTool BDTaccount];//HYUserDefault.loginToken
    AFHTTPSessionManager *manager = [self sessionManagerWithToken:@"loginModel.token" parameters:param];
    NSURLSessionDataTask *dataTask = nil;
    switch (type) {
        case CBNetworkRequestTypePost: {
            dataTask = [manager POST:url parameters:param progress:nil success:success failure:failure];
        }
            break;
        case CBNetworkRequestTypeGet: {
            dataTask = [manager GET:url parameters:param progress:nil success:success failure:failure];
        }
            break;
            
        default: {
            dataTask = [NSURLSessionDataTask new];
        }
            break;
    }
    return dataTask;
}

//绝对url 网络请求，返回经过处理的数据
+ (NSURLSessionDataTask *)networkRequestType:(CBNetworkRequestType)type url:(NSString *)url param:(NSMutableDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    return [CBNetworkingServers networkOriginRequestType:type url:url param:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CBBaseNetworkModel *baseModel = [CBBaseNetworkModel mj_objectWithKeyValues:responseObject];
        if ([responseObject[@"status"]integerValue] == 602) {
            [HUD showHUDWithText:[Utils getSafeString:Localized(@"设备不在线")] withDelay:2.0];
        }
        if (baseModel) {
            success(baseModel);
        } else {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BOOL isFailed = [self login:task];
        failure(error);
        if (isFailed) {
            [MINUtils showProgressHudToView:[AppDelegate shareInstance].window withText:Localized(@"请求超时")];
        }
    }];
}


+ (AFHTTPSessionManager *)shareManager {
    static AFHTTPSessionManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:[CBNetworkingServers requestUrl]]];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    });
    return _manager;
}


#pragma mark - 私有方法 3
+ (AFHTTPSessionManager *)sessionManagerWithToken:(NSString *)token parameters:(NSMutableDictionary *)parameters {
    
    AFHTTPSessionManager *sessionManager =  [self shareManager];
    if (parameters[@"timeoutInterval"]) {
        sessionManager.requestSerializer.timeoutInterval = [parameters[@"timeoutInterval"] doubleValue];
        [parameters removeObjectForKey:@"timeoutInterval"];
    } else {
        sessionManager.requestSerializer.timeoutInterval = 25;//15;//默认15秒超时
    }
    //5;
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html",@"application/x-www-form-urlencoded",@"image/jpeg",@"image/png",@"application/octet-stream", nil];
    /** token  */
    
    /** token: 加密token,用户登录成功后可以获取
     hash : 数字签名，请看 签名算法
     ver  : 版本*/
    //[sessionManager.requestSerializer setValue:[UserLoginModelManager shareManager].userInfoModel.token?:@"" forHTTPHeaderField:@"token"];
    //[sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"%d",[UserLoginModelManager shareManager].userInfoModel.uid] forHTTPHeaderField:@"uid"];
    [sessionManager.requestSerializer setValue:[CBPetLoginModelTool getUser].token forHTTPHeaderField:@"token"];
    [sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[CBPetLoginModelTool getUser].uid] forHTTPHeaderField:@"uid"];
    
    return sessionManager;
}
/** 升序排序字典的key，并转为字符串  */
+ (NSString *)getDictsortWithDict:(NSDictionary*)dict {
    
    NSArray *allKeyArray = [dict allKeys];
    NSMutableDictionary *TransferDic = [NSMutableDictionary dictionary];
    NSMutableArray *TransferArr = [NSMutableArray array];
    NSMutableArray *finallyArr = [NSMutableArray array];
    for (NSString *str in allKeyArray) {
        
        [TransferDic setObject:str forKey:[str lowercaseString]];
        [TransferArr addObject:[str lowercaseString]];
    }
    NSArray *afterSortKeyArray = [TransferArr sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    
    for (NSString *str in afterSortKeyArray) {
        
        NSString *finallyArrStr  = [TransferDic objectForKey:str];
        [finallyArr addObject:finallyArrStr];
    }
    
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in finallyArr) {
        NSString *valueString = [dict objectForKey:sortsing];
        [valueArray addObject:valueString];
    }
    
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0 ; i < afterSortKeyArray.count; i++) {
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@",finallyArr[i],valueArray[i]];
        [signArray addObject:keyValue];
    }
    
    //signString用于签名的原始参数集合
    NSString *signString = [signArray componentsJoinedByString:@"&"];
    
    return signString;
}
/** 请求的ip  */
+ (NSString *)requestUrl {
    return BASE_URL_CarNet;//baseUrl;
}
/** 请求的路由  */
+ (NSString *)requestRounting {
    return requestRounting;
}
+ (NSString *)fetchIpUrl {
    NSString *ipUrl = [CBNetworkingServers requestUrl];
    NSRange rang = [ipUrl rangeOfString:@"/api"];
    ipUrl = [ipUrl substringWithRange:NSMakeRange(0, rang.location)];
    return ipUrl;
}
+ (BOOL)login:(NSURLSessionDataTask *)task {
    NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
    if (responses.statusCode == 401) { // // 401 token 失效// 404 服务器连接失败，网络异常// 500 服务器出错
        // 清除本地选中的设备token
        CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
        userModel.token = nil;
        [CBPetLoginModelTool saveUser:userModel];
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:Localized(@"用户信息异常，请重新登录") preferredStyle:UIAlertControllerStyleAlert];
        // 知道了
        [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"重新登录") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 登录超时，请重新登录
                [[NSNotificationCenter defaultCenter] postNotificationName:@"K_SwitchLoginViewController" object:nil];
            });
        }]];
        [[CBCommonTools getCurrentVC] presentViewController:alertControl animated:YES completion:nil];
        return NO;
    }
    else {
        return YES;
    }
}
@end
