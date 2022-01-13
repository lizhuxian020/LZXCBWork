//
//  MessageModel.m
//  Watch
//
//  Created by lym on 2018/4/16.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"messageId" : @"id" };
}
@end
