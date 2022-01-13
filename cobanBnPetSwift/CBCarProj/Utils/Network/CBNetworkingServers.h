//
//  CBNetworkingServers.h
//  Telematics
//
//  Created by coban on 2019/7/17.
//  Copyright © 2019 coban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBBaseNetworkModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CBNetworkRequestTypePost = 3,
    CBNetworkRequestTypeGet,
    CBNetworkRequestTypePut,
    CBNetworkRequestTypeDELETE,
} CBNetworkRequestType;

typedef  void(^SuccessBlock)(CBBaseNetworkModel *baseModel);
typedef  void(^FailureBlock)(NSError *error);

//
typedef void (^originSuccessBlock)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject);
typedef void (^originFailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

typedef void (^BDTRequestSucceedBlock)(CBNetworkingStatus status, NSError *error);

@interface CBNetworkingServers : NSObject

/** 通用网络请求 */
+ (NSURLSessionDataTask *)networkRequestType:(CBNetworkRequestType)type path:(NSString *)path param:(NSMutableDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/** 绝对url 网络请求，返回未经处理的数据 */
+ (NSURLSessionDataTask *)networkOriginRequestType:(CBNetworkRequestType)type url:(NSString *)url param:(NSMutableDictionary *)param success:(originSuccessBlock)success failure:(originFailureBlock)failure;

/** 绝对url 网络请求，返回经过处理的数据 */
+ (NSURLSessionDataTask *)networkRequestType:(CBNetworkRequestType)type url:(NSString *)url param:(NSMutableDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;


@end

NS_ASSUME_NONNULL_END
