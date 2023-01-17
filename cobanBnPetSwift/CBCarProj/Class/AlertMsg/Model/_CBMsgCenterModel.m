//
//  _CBMsgCenterModel.m
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/16.
//  Copyright © 2023 coban. All rights reserved.
//

#import "_CBMsgCenterModel.h"

@implementation _CBMsgCenterModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"iid":@"id"
             };
}

- (NSString *)descVehicleStatus {
    
    NSDictionary *dic = @{
        @"31": Localized(@"碰撞"),
        @"19": Localized(@"急加速"),
        @"20": Localized(@"急刹车"),
        @"21": Localized(@"急转弯"),
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
