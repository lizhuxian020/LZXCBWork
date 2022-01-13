//
//  CBHomeLeftMenuModel.m
//  Telematics
//
//  Created by coban on 2019/7/18.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBHomeLeftMenuModel.h"

@implementation CBHomeLeftMenuModel

@end

@implementation CBHomeLeftMenuSliderModel

@end

@implementation CBHomeLeftMenuDeviceGroupModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"device":[CBHomeLeftMenuDeviceInfoModel class],
             @"noGroup":[CBHomeLeftMenuDeviceInfoModel class]
             };
}
@end

@implementation CBHomeLeftMenuDeviceInfoModel
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ids":@"id"
             };
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"listFence":[CBHomeLeftMenuDeviceInfoModelFenceModel class]
             };
}
@end

@implementation CBHomeLeftMenuDeviceInfoModelFenceModel
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ids":@"id"
             };
}
@end
