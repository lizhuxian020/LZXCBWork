//
//  PlaceModel.m
//  Telematics
//
//  Created by lym on 2017/12/29.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "PlaceModel.h"

@implementation PlaceModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"placeId" : @"id"};
}
@end
