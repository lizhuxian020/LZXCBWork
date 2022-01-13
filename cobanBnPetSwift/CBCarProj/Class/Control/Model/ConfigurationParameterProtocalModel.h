//
//  ConfigurationParameterProtocalModel.h
//  Telematics
//
//  Created by lym on 2017/12/25.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigurationParameterProtocalModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *proto;
@property (nonatomic, assign) int dianqiExchange;   // 电气锁转换
@property (nonatomic, assign) int responseMsg;      // 消息应答超时机制
@property (nonatomic, assign) int restartDevice;    // 设备重启
@property (nonatomic, assign) int restoreFactory;   // 恢复出厂设置
@property (nonatomic, assign) int sendmsgCount;     // 设置报警短信发送次数
@property (nonatomic, assign) int settingMileage;   // 设置里程初始值
@property (nonatomic, assign) int settingMsg;       // 设置短信控制密码
@property (nonatomic, assign) int settingNetwork;   // 网络设置
@property (nonatomic, assign) int settingNumber;    // 设置授权号码
@property (nonatomic, assign) int settingTank;      // 设置油箱容积
@property (nonatomic, assign) int settingWarm;      // 设置低电压报警值
@property (nonatomic, assign) int settingZhuanwan;  // 设置转弯补传角度
@property (nonatomic, assign) int tiredDrive;       // 疲劳驾驶参数设置
@property (nonatomic, assign) int validateOil;      // 油量校准
@property (nonatomic, assign) int warmPengzhuang;   // 碰撞报警参数设置
@property (nonatomic, assign) int warmSpeed;        // 超速报警预警差值
- (NSArray *)getStateArr;
@end
