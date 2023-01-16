//
//  _CBMsgCenterModel.m
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/16.
//  Copyright © 2023 coban. All rights reserved.
//

#import "_CBMsgCenterModel.h"

@implementation _CBMsgCenterModel

- (NSString *)descVehicleStatus {
    
    NSDictionary *dic = @{
        @"31": @"碰撞",
        @"19": @"急加速",
        @"20": @"急刹车",
        @"21": @"急转弯",
    };
    
    NSArray *status = [self.vehicleStatus componentsSeparatedByString:@","];
    NSMutableArray *descArr = [NSMutableArray new];
    for (NSString *s in status) {
        NSString *desc = dic[s];
        if (!kStringIsEmpty(desc)) {
            [descArr addObject:desc];
        }
    }
    return [descArr componentsJoinedByString:@","];
}

@end
