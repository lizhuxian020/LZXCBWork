//
//  AddressBookModel.m
//  Watch
//
//  Created by lym on 2018/3/30.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "AddressBookModel.h"

@implementation AddressBookModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"relationId" : @"id"};
}
@end

@implementation AddressBookEditModel
@end
