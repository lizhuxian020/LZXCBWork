//
//  MINControlModel.m
//  Telematics
//
//  Created by lym on 2017/12/14.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MINControlModel.h"

@implementation MINControlModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"controlID" : @"id"};
}

- (NSArray *)getStateArr
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1]];
    if (self.localize == 0) { // 定位
        [arr replaceObjectAtIndex: 0 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.fence == 0) { // 电子围栏
        [arr replaceObjectAtIndex: 2 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.dydd == 0) { // 断油断电
        [arr replaceObjectAtIndex: 3 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.cfbf == 0) { // 撤防/布防
        [arr replaceObjectAtIndex: 4 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmZhendong == 0) { // 振动报警
        [arr replaceObjectAtIndex: 5 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmDidian == 0) { // 低电报警
        [arr replaceObjectAtIndex: 6 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmDiaodian == 0) { // 掉电报警
        [arr replaceObjectAtIndex: 7 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmYiwei == 0) { // 位移报警
        [arr replaceObjectAtIndex: 8 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.voice == 0) { // 录音
        [arr replaceObjectAtIndex: 9 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.takePhoto == 0) { // 立即拍照
        [arr replaceObjectAtIndex: 10 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.obd == 0) { // OBD消息
        [arr replaceObjectAtIndex: 11 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.backTel == 0) { // 电话回拨
        [arr replaceObjectAtIndex: 12 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmSpeed == 0) { // 超速报警
        [arr replaceObjectAtIndex: 13 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.sendMsg == 0) { // 消息下发
        [arr replaceObjectAtIndex: 14 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.yuntai == 0) { // 振动报警
        [arr replaceObjectAtIndex: 15 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.morePhoto == 0) { // 多次拍照
        [arr replaceObjectAtIndex: 16 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.rest == 0) { // 休眠模式
        [arr replaceObjectAtIndex: 17 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.setParam == 0) { // 设置参数
        [arr replaceObjectAtIndex: 18 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.online == 0) { // 在线统计 首页的
        //        [arr replaceObjectAtIndex: 4 withObject: [NSNumber numberWithInt: 4]];
    }
    if (self.luggage == 0) { // 三维行李箱 UI设计没这项，先不管 首页
        //        [arr replaceObjectAtIndex: 4 withObject: [NSNumber numberWithInt: 4]];
    }
    if (self.track == 0) { // 轨迹回放 首页的
        //        [arr replaceObjectAtIndex: 4 withObject: [NSNumber numberWithInt: 4]];
    }
    return arr;
}
@end
