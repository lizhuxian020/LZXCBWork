//
//  CBWtHomeLeftMenuModel.m
//  Telematics
//
//  Created by coban on 2019/7/18.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBWtHomeLeftMenuModel.h"

@implementation CBWtHomeLeftMenuModel

@end

@implementation CBWtHomeLeftMenuSliderModel

@end

@implementation CBWtHomeLeftMenuDeviceGroupModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"device":[CBWtHomeLeftMenuDeviceInfoModel class],
             @"noGroup":[CBWtHomeLeftMenuDeviceInfoModel class]
             };
}
@end

@implementation CBWtHomeLeftMenuDeviceInfoModel
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ids":@"id"
             };
}
@end
