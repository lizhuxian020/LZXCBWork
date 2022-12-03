//
//  NetWorkingManager.h
//  PowerBank
//
//  Created by 麦鱼科技 on 2017/7/11.
//  Copyright © 2017年 麦鱼科技. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFNetworking.h"
#import <AFNetworking/AFHTTPSessionManager.h>


/**
 成功的block

 @param response 返回数据
 */
typedef void(^Succeed)(id response,BOOL isSucceed);


/**
 失败的block

 @param error 错误信息
 */
typedef void(^Failed)(NSError *error);

@interface NetWorkingManager : NSObject


+ (NetWorkingManager *)shared;

/**
 post请求

 @param url url
 @param params 参数
 @param succeed 成功返回
 @param failed 失败返回
 */
- (void)postWithUrl:(NSString *)url params:(NSDictionary*)params succeed:(Succeed)succeed failed:(Failed)failed;

- (void)postJSONWithUrl:(NSString *)url params:(NSDictionary *)params succeed:(Succeed)succeed failed:(Failed)failed;
/**
 get请求

 @param url url
 @param params 参数
 @param succeed 成功
 @param failed 失败
 */
- (void)getWithUrl:(NSString *)url params:(NSDictionary*)params succeed:(Succeed)succeed failed:(Failed)failed;


@end
