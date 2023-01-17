//
//  CBJiaShiXingWeiModel.m
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/16.
//  Copyright © 2023 coban. All rights reserved.
//

#import "CBJiaShiXingWeiModel.h"

@implementation CBJiaShiXingWeiModel

- (NSString *)descTime {
    return [Utils convertTimeWithTimeIntervalString:_ts timeZone:@""];
}


- (NSMutableArray *)getIdingOrStayModelArr
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"设备名称:"),self.dno]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"时间:"),self.descTime?:@""]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"地址:"),self.address?:@""]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"消息类型:"),self.descVehicleStatus?:@""]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"经度:"),self.lng?:@""]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"纬度:"),self.lat?:@""]];
    return array;
}


- (NSString *)descVehicleStatus {
    
    NSDictionary *dic = @{
        @"31": Localized(@"碰撞"),
        @"19": Localized(@"急加速"),
        @"20": Localized(@"急刹车"),
        @"21": Localized(@"急转弯"),
    };
    
    NSArray *status = [self.vehicle_status componentsSeparatedByString:@","];
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
