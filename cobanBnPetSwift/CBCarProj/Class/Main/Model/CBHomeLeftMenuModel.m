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
- (instancetype)mj_setKeyValues:(id)keyValues {
    [super mj_setKeyValues:keyValues];
    if ([_productSpecId isEqualToString:@"70"] && [_proto isEqualToString:@"0"]) {
        _devModel = Localized(@"其他");
    }
    return self;
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
