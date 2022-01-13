//
//  PhoneBookModel.m
//  Telematics
//
//  Created by lym on 2017/12/23.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "PhoneBookModel.h"

@implementation PhoneBookModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"phoneId" : @"id"};
}
@end
