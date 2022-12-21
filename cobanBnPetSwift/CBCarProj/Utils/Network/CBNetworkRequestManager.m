//
//  CBNetworkRequestManager.m
//  Telematics
//
//  Created by coban on 2019/7/17.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBNetworkRequestManager.h"

@implementation CBNetworkRequestManager

/** 获取我的设备列表  */
const NSString *bdtGetMyDeviceList                = @"/personController/getMyDeviceList";
/** 获取单个设备数据  */
const NSString *bdtGetMySingeDeviceInfo           = @"/personController/getDevData";
/** 处理报警  */
const NSString *bdtDealWithDeviceWarmed           = @"/personController/updateDevWarnStatus";
/** 终端设备参数设置  */
const NSString *cbTerminalSettingParamters         = @"/devControlController/updateDeviceStatus";
/** 获取话费列表  */
const NSString *cbGetCallChargeParamters           = @"/personController/getDeviceMsgList";

+ (instancetype)sharedInstance {
    static id obj = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        obj = [[self alloc] init];
    });
    return  obj;
}

/** 获取我的设备列表  */
- (void)getMyDeviceListDataParamters:(NSMutableDictionary *)paramters
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",bdtGetMyDeviceList];
    [[NetWorkingManager shared] getWithUrl:url params:paramters succeed:^(id response, BOOL isSucceed) {
        CBBaseNetworkModel *baseModel = [CBBaseNetworkModel mj_objectWithKeyValues:response];
        !success?:success(baseModel);
        } failed:^(NSError *error) {
            !failure?:failure(error);
        }];
}
/** 获取单个设备数据  */
- (void)getSingeDeviceInfoDataParamters:(NSMutableDictionary *)paramters
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",bdtGetMySingeDeviceInfo];
    [[NetWorkingManager shared] getWithUrl:url params:paramters succeed:^(id response, BOOL isSucceed) {
        if (isSucceed) {
            CBBaseNetworkModel *baseModel = [CBBaseNetworkModel mj_objectWithKeyValues:response];
            !success?:success(baseModel);
        }
        } failed:^(NSError *error) {
            !failure?:failure(error);
        }];
}
/** 处理设备报警  */
- (void)dealWithWarmedParamters:(NSMutableDictionary *)paramters
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",bdtDealWithDeviceWarmed];
    [[NetWorkingManager shared] getWithUrl:url params:paramters succeed:^(id response, BOOL isSucceed) {
        if (isSucceed) {
            CBBaseNetworkModel *baseModel = [CBBaseNetworkModel mj_objectWithKeyValues:response];
            !success?:success(baseModel);
        }
        } failed:^(NSError *error) {
            !failure?:failure(error);
        }];
}
/** 终端设备参数设置  */
- (void)terminalSettingParamters:(NSMutableDictionary *)paramters
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",cbTerminalSettingParamters];
    [[NetWorkingManager shared] postWithUrl:url params:paramters succeed:^(id response, BOOL isSucceed) {
        if (isSucceed) {
            CBBaseNetworkModel *baseModel = [CBBaseNetworkModel mj_objectWithKeyValues:response];
            !success?:success(baseModel);
        }
        } failed:^(NSError *error) {
            !failure?:failure(error);
        }];
}
/** 获取话费列表  */
- (void)getCallChargeParamters:(NSMutableDictionary *)paramters
                       success:(SuccessBlock)success
                       failure:(FailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",cbGetCallChargeParamters];
    [[NetWorkingManager shared] getWithUrl:url params:paramters succeed:^(id response, BOOL isSucceed) {
        if (isSucceed) {
            CBBaseNetworkModel *baseModel = [CBBaseNetworkModel mj_objectWithKeyValues:response];
            !success?:success(baseModel);
        }
        } failed:^(NSError *error) {
            !failure?:failure(error);
        }];
}
@end
