//
//  SubAccountModel.m
//  Telematics
//
//  Created by lym on 2017/12/28.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "SubAccountModel.h"

@implementation SubAccountModel
//+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
//{
//    return @{@"accountId" : @"id"};
//}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"accountId":@"id"
             };
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"subDevice":[SubAccountSubDeviceModel class],
             };
}
@end

@implementation SubAccountSubDeviceModel
//+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
//{
//    return @{@"ids" : @"id"};
//}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ids":@"id"
             };
}
@end


@implementation SubAccountAddModel

@end
