//
//  MINControlListDataModel.h
//  Telematics
//
//  Created by lym on 2017/12/14.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MINControlListDataModel : NSObject <YYModel>
@property (nonatomic, assign) NSInteger cfbf;         //  0-撤防，1-布防
@property (nonatomic, assign) NSInteger dcdd;         //  多次定位，0-关闭；1-打开
@property (nonatomic, assign) NSInteger dydd;         // 断油断电，1-断开油电；0-恢复油电
@property (nonatomic, copy) NSString *controlID;
@property (nonatomic, assign) NSInteger obd;          // OBD消息，0-关闭，1-开启
@property (nonatomic, assign) NSInteger obdMsg;       // 0-跟随单次定位，1-跟随多次定位
@property (nonatomic, assign) NSInteger oil;          // 0-立即断油断电，1-延时断油断电
@property (nonatomic, copy) NSString *phone;          // "18328811563",   备注：回拨电话
@property (nonatomic, assign) NSInteger photo;        // 立即拍照，0-关闭；1-开启
@property (nonatomic, assign) NSInteger restMod;    // 备注：休眠模式；0-长在线，1-时间休眠，2-振动休眠，3-深度振动休眠，4-定时报告，5-深度振动+定时报告休眠
@property (nonatomic, assign) NSInteger voice;        // 0-关闭录音；1-开启录音
@property (nonatomic, assign) NSInteger warmDidian;   // 低电报警，0-关闭；1-开启
@property (nonatomic, assign) NSInteger warmDiaodan;  // 掉电报警，0-关闭；1-开启
@property (nonatomic, assign) NSInteger warmWy;       // 位移报警，0-关闭；1-开启
@property (nonatomic, assign) NSInteger warmZd;       // 震动报警，0-关闭；1-开
@property (nonatomic, assign) NSInteger warmSpeed;    // 超速报警 0-关闭；1-开
@property (nonatomic, assign) NSInteger monitorMode ; // 听听 1-听听模式；0-定位模式
@property (nonatomic, assign) NSInteger sdj;          // 锁电机
@property (nonatomic, assign) NSInteger ycqd;          // 远程控制

/** 盲区报警 */
@property (nonatomic, assign) NSInteger warnBlind;
/** 紧急报警 */
@property (nonatomic, assign) NSInteger urgentWarn;
/** 油量检测报警 */
@property (nonatomic, assign) NSInteger oilCheckWarn;
/** 温度报警参数 */
@property (nonatomic, assign) NSInteger warmWd;
/** 拆除报警参数 */
@property (nonatomic, assign) NSInteger warmCc;
/** 保养通知 */
@property (nonatomic, assign) NSInteger serviceFlag;
/** 振动灵敏度 */
@property (nonatomic, assign) NSInteger sensitivity;
/** gps漂移抑制，0： 关闭GPS漂移抑制，1：开启GPS漂移抑制 */
@property (nonatomic, assign) NSInteger gpsFloat;
/** CC工作通知：1：开启此功能，0：关闭此功能 */
@property (nonatomic, assign) NSInteger accNotice;
/** 时区设置：+8 -8.5 */
@property (nonatomic, copy) NSString *timeZone;

@property (nonatomic, copy) NSString *agentId;
@property (nonatomic, copy) NSString *authNum;
@property (nonatomic, copy) NSString *carNum;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *devIccid;
@property (nonatomic, copy) NSString *dno;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *online;
@property (nonatomic, copy) NSString *protocol;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *vin;
@property (nonatomic, copy) NSString *warmCollision;
@property (nonatomic, copy) NSString *warmFenin;
@property (nonatomic, copy) NSString *warmFenout;
@property (nonatomic, copy) NSString *warmFire;
@property (nonatomic, copy) NSString *warmOil;
@property (nonatomic, copy) NSString *warmOpen;
@property (nonatomic, copy) NSString *warmSos;
//@property (nonatomic, copy) NSString *warmSpeed;
@property (nonatomic, copy) NSString *warmTired;
@property (nonatomic, copy) NSString *warmed;

@property (nonatomic, copy) NSString *moveWarm;
@property (nonatomic, copy) NSString *overWarm; //超速报警

@property (nonatomic, copy) NSString *serviceInterval;
@property (nonatomic, copy) NSString *serviceMileage;
/** 静音布防 */
@property (nonatomic, copy) NSString *silentArm;

@end
