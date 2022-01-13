//
//  MINControlListDataModel.m
//  Telematics
//
//  Created by lym on 2017/12/14.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MINControlListDataModel.h"

@implementation MINControlListDataModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"controlID" : @"id"};
}
@end
