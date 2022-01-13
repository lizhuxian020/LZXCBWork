//
//  ConfigurationParameterModel.h
//  Telematics
//
//  Created by lym on 2017/12/23.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigurationParameterModel : NSObject
@property (nonatomic, copy) NSString *dno;
@property (nonatomic, assign) int angle;        // 转弯补传角度
@property (nonatomic, assign) int change;       // 电气锁转换；0-电锁，1-气锁
@property (nonatomic, assign) int lowWarm;      // 低压报警值
@property (nonatomic, assign) int mileage;      // 里程初始值
@property (nonatomic, assign) int oilValidate;  // 油量校准；0-零值，1-满值
@property (nonatomic, assign) int overWarm;     // 超速报警预警差值
@property (nonatomic, copy) NSString *password; // 明文返回。。。短信控制密码
@property (nonatomic, copy) NSString *pzCfbj;       // 侧翻角度
@property (nonatomic, assign) int pzSpeed;      // 碰撞报警加速度（g）
@property (nonatomic, assign) int pzTime;       // 碰撞报警时间（ms）
@property (nonatomic, assign) int sendMsgLimit; // 设置报警短信发送次数
@property (nonatomic, copy) NSString *heartbeatInterval; // 设置心跳间隔
@property (nonatomic, assign) int volume;       // 油箱容积

@end
