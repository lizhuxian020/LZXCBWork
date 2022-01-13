//
//  FormProtocalModel.h
//  Telematics
//
//  Created by lym on 2017/11/14.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface FormProtocalModel : NSObject <YYModel>
@property (nonatomic, assign) long createTime; // 创建时间
@property (nonatomic, assign) int curvesSpeed; // 速度曲线
@property (nonatomic, assign) int curvesTemp; // 温度曲线
@property (nonatomic, assign) int formID; // 主键
@property (nonatomic, copy) NSString *name; // 协议名称
@property (nonatomic, copy) NSString *proto; // 协议代码
@property (nonatomic, assign) int reportFence; // 围栏报表
@property (nonatomic, assign) int reportDispatch; // 调度报表
@property (nonatomic, assign) int reportIdle; // 怠速报表
@property (nonatomic, assign) int reportIgnition; // 点火报表
@property (nonatomic, assign) int reportMedia; // 多媒体报表
@property (nonatomic, assign) int reportMiles; // 里程报表
@property (nonatomic, assign) int reportObd; // OBD报表
@property (nonatomic, assign) int reportOil; // 油量报表
@property (nonatomic, assign) int reportStop; // 停留报表
@property (nonatomic, assign) int warmAll; // 所有报警报表
@property (nonatomic, assign) int warmChaosu; // 超速报警报表
@property (nonatomic, assign) int warmDianhuo; // 点火报警报表
@property (nonatomic, assign) int warmDiaodian; // 掉电报警报表
@property (nonatomic, assign) int warmKaimen; // 开门报警报表
@property (nonatomic, assign) int warmPz; // 碰撞报警报表
@property (nonatomic, assign) int warmQianya; // 欠压报警报表
@property (nonatomic, assign) int warmSos; // sos报警报表
@property (nonatomic, assign) int warmTemp; // 温度报警报表
@property (nonatomic, assign) int warmTired; // 疲劳报警报表
@property (nonatomic, assign) int warmTouyou; // 偷油报警报表
@property (nonatomic, assign) int warmWeiyi; // 位移报警报表
@property (nonatomic, assign) int warmZhendong; // 振动报警报表
- (NSArray *)getSectionArr;
- (NSArray *)getWarmArr;
@end
