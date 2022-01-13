//
//  FormProtocalModel.m
//  Telematics
//
//  Created by lym on 2017/11/14.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "FormProtocalModel.h"

@implementation FormProtocalModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"formID" : @"id"};
}

- (NSArray *)getSectionArr
{
    NSMutableArray *array = [NSMutableArray arrayWithArray: @[@1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1]];
    if (self.curvesSpeed == 0) { // 速度报表
        [array replaceObjectAtIndex: 0 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.reportIdle == 0) { // 怠速报表
        [array replaceObjectAtIndex: 1 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.reportStop == 0) { // 停留报表
        [array replaceObjectAtIndex: 2 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.reportIgnition == 0) { // 点火报表
        [array replaceObjectAtIndex: 3 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.reportMiles == 0) { // 里程报表
        [array replaceObjectAtIndex: 4 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.reportOil == 0) { // 油量报表
        [array replaceObjectAtIndex: 5 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmAll == 0 && self.warmSos == 0 && self.warmChaosu == 0 && self.warmTired == 0 && self.warmQianya == 0 && self.warmDiaodian == 0 && self.warmZhendong == 0 && self.warmKaimen == 0 && self.warmDianhuo == 0 && self.warmWeiyi == 0 && self.warmTouyou == 0 && self.warmPz == 0) { // 报警报表
        [array replaceObjectAtIndex: 6 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.reportObd == 0) { // OBD报表
        [array replaceObjectAtIndex: 7 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.reportFence == 0) { // 围栏报表
        [array replaceObjectAtIndex: 8 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.reportMedia == 0) { // 多媒体报表
        [array replaceObjectAtIndex: 9 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.reportDispatch == 0) { // 调度报表
        [array replaceObjectAtIndex: 10 withObject: [NSNumber numberWithInt: 0]];
    }
    return array;
}

- (NSArray *)getWarmArr
{
    NSMutableArray *array = [NSMutableArray arrayWithArray: @[@1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1]];
    // 分别是 所有报警，sos报警，超速报警，疲劳驾驶，欠压报警，掉电报警，振动报警，开门报警，点火报警，位移报警，偷油漏油报警，碰撞报警统计报表
    if (self.warmAll == 0) { // 所有报警
        [array replaceObjectAtIndex: 0 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmSos == 0) { // sos报警
        [array replaceObjectAtIndex: 1 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmChaosu == 0) { // 超速报警
        [array replaceObjectAtIndex: 2 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmTired == 0) { // 疲劳驾驶
        [array replaceObjectAtIndex: 3 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmQianya == 0) { // 欠压报警
        [array replaceObjectAtIndex: 4 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmDiaodian == 0) { // 掉电报警
        [array replaceObjectAtIndex: 5 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmZhendong == 0) { // 振动报警
        [array replaceObjectAtIndex: 6 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmKaimen == 0) { // 开门报警
        [array replaceObjectAtIndex: 7 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmDianhuo == 0) { // 点火报警
        [array replaceObjectAtIndex: 8 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmWeiyi == 0) { // 位移报警
        [array replaceObjectAtIndex: 9 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmTouyou == 0) { // 偷油漏油报警
        [array replaceObjectAtIndex: 10 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmPz == 0) { // 碰撞报警统计报表
        [array replaceObjectAtIndex: 11 withObject: [NSNumber numberWithInt: 0]];
    }
    return array;
}

@end
