//
//  CBNetworkRequestManager.h
//  Telematics
//
//  Created by coban on 2019/7/17.
//  Copyright © 2019 coban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBNetworkingServers.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^requestReuslt)(id objc);

@interface CBNetworkRequestManager : NSObject

+ (instancetype)sharedInstance;

/** 获取我的设备列表  */
- (void)getMyDeviceListDataParamters:(NSMutableDictionary *)paramters
                             success:(SuccessBlock)success
                           failure:(FailureBlock)failure;
/** 获取单个设备数据  */
- (void)getSingeDeviceInfoDataParamters:(NSMutableDictionary *)paramters
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure;
/** 处理设备报警  */
- (void)dealWithWarmedParamters:(NSMutableDictionary *)paramters
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure;
/** 终端设备参数设置  */
- (void)terminalSettingParamters:(NSMutableDictionary *)paramters
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure;
/** 获取话费列表  */
- (void)getCallChargeParamters:(NSMutableDictionary *)paramters
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure;
@end

NS_ASSUME_NONNULL_END
