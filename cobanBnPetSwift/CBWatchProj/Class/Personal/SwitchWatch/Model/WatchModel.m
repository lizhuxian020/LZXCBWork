//
//  WatchModel.m
//  Watch
//
//  Created by lym on 2018/4/16.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "WatchModel.h"

@implementation WatchModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"watchID" : @"id" };
}
@end
