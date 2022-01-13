//
//  CBWtNetworkingServers.h
//  Telematics
//
//  Created by coban on 2019/7/17.
//  Copyright © 2019 coban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBWtBaseNetworkModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CBWtNetworkRequestTypePost = 3,
    CBWtNetworkRequestTypeGet,
    CBWtNetworkRequestTypePut,
    CBWtNetworkRequestTypeDELETE,
    CBWtNetworkRequestTypeDownload,
} CBWtNetworkRequestType;

typedef  void(^CBWtSuccessBlock)(CBWtBaseNetworkModel *baseModel);
typedef  void(^CBWtFailureBlock)(NSError *error);

// 下载音频block
typedef void(^CBWtVoiceFinishBlock)(NSString *filePath);
typedef void(^CBWtVoiceFailed)(void);

//
typedef void (^CBWtoriginSuccessBlock)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject);
typedef void (^CBWtoriginFailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

typedef void (^CBWtRequestSucceedBlock)(CBWtNetworkingStatus status, NSError *error);

@interface CBWtNetworkingServers : NSObject

/** 通用网络请求 */
+ (NSURLSessionDataTask *)networkRequestType:(CBWtNetworkRequestType)type path:(NSString *)path param:(NSMutableDictionary *)param success:(CBWtSuccessBlock)success failure:(CBWtFailureBlock)failure;

/** 绝对url 网络请求，返回未经处理的数据 */
+ (NSURLSessionDataTask *)networkOriginRequestType:(CBWtNetworkRequestType)type url:(NSString *)url param:(NSMutableDictionary *)param success:(CBWtoriginSuccessBlock)success failure:(CBWtoriginFailureBlock)failure;

/** 绝对url 网络请求，返回经过处理的数据 */
+ (NSURLSessionDataTask *)networkRequestType:(CBWtNetworkRequestType)type url:(NSString *)url param:(NSMutableDictionary *)param success:(CBWtSuccessBlock)success failure:(CBWtFailureBlock)failure;

+ (NSString *)requestUrl;
/** 请求的路由  */
+ (NSString *)requestRounting;

@end

NS_ASSUME_NONNULL_END
