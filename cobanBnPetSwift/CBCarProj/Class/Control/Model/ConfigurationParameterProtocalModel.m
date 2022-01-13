//
//  ConfigurationParameterProtocalModel.m
//  Telematics
//
//  Created by lym on 2017/12/25.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "ConfigurationParameterProtocalModel.h"

@implementation ConfigurationParameterProtocalModel

- (NSArray *)getStateArr
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1]];
    if (self.restoreFactory == 0) { // 恢复出厂设置
        [arr replaceObjectAtIndex: 0 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.settingMsg == 0) { // 设置短信控制密码
        [arr replaceObjectAtIndex: 1 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.settingNumber == 0) { // 设置授权号码
        [arr replaceObjectAtIndex: 2 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.settingZhuanwan == 0) { // 设置转弯补角
        [arr replaceObjectAtIndex: 3 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.settingMileage == 0) { // 设置里程初始值
        [arr replaceObjectAtIndex: 4 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.settingWarm == 0) { // 设置低电压报警值
        [arr replaceObjectAtIndex: 5 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.settingTank == 0) { // 设置油箱容积
        [arr replaceObjectAtIndex: 6 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.validateOil == 0) { // 油量校准
        [arr replaceObjectAtIndex: 7 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.dianqiExchange == 0) { // 电气锁转换
        [arr replaceObjectAtIndex: 8 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.sendmsgCount == 0) { // 设置报警短信发送次数
        [arr replaceObjectAtIndex: 9 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmSpeed == 0) { // 超速报警预警差值
        [arr replaceObjectAtIndex: 10 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.responseMsg == 0) { // 消息应答超时机制
        [arr replaceObjectAtIndex: 11 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.tiredDrive == 0) { // 疲劳驾驶参数设置
        [arr replaceObjectAtIndex: 12 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.warmPengzhuang == 0) { // 碰撞报警参数设置
        [arr replaceObjectAtIndex: 13 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.settingNetwork == 0) { // 网络设置
        [arr replaceObjectAtIndex: 14 withObject: [NSNumber numberWithInt: 0]];
    }
    if (self.restartDevice == 0) { // 设备重启
        [arr replaceObjectAtIndex: 15 withObject: [NSNumber numberWithInt: 0]];
    }
    return arr;
}

@end
