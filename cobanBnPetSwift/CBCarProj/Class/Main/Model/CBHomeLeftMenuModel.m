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
    if ([_createTime containsString:@"-"]) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:_createTime];
        NSTimeInterval timeInt = [date timeIntervalSince1970];
        _createTime = [NSString stringWithFormat:@"%lf", timeInt*1000];
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
