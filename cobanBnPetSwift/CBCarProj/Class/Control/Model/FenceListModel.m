//
//  FenceListModel.m
//  Telematics
//
//  Created by lym on 2017/12/18.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "FenceListModel.h"

@implementation FenceListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"fid":@"id"
             };
}
@end
