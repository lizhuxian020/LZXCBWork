//
//  LineDoubleChartModel.m
//  Telematics
//
//  Created by lym on 2017/12/27.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "LineDoubleChartModel.h"

@implementation LineDoubleChartModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"lineId" : @"id",
             @"use_oil":@"useOil"
             };
}
//+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
//{
//    return @{@"controlID" : @"id"};
//}
@end
