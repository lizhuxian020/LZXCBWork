//
//  ForbiddenInClassModel.m
//  Watch
//
//  Created by lym on 2018/4/3.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "ForbiddenInClassModel.h"

@implementation ForbiddenInClassModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"forbiddenId" : @"id"};
}
@end
