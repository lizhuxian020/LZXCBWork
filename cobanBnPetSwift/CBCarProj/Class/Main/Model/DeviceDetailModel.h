//
//  DeviceDetailModel.h
//  Telematics
//
//  Created by lym on 2018/3/21.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceDetailModel : NSObject
@property (nonatomic, copy) NSString *dno;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *altitude;
@property (nonatomic, copy) NSString *carNum;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *direct;
@property (nonatomic, copy) NSString *gps;
@property (nonatomic, copy) NSString *gsm;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
/* 里程*/
@property (nonatomic, copy) NSString *mileage;
@property (nonatomic, copy) NSString *name;
/* 油量*/
@property (nonatomic, copy) NSString *oil;
/* 油量百分比 */
@property (nonatomic, copy) NSString *oil_prop;
@property (nonatomic, copy) NSString *online;
@property (nonatomic, copy) NSString *power;
@property (nonatomic, copy) NSString *remainCount;
@property (nonatomic, copy) NSString *remainTime;
@property (nonatomic, copy) NSString *speed;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *warm;
/* 报警类型 */
@property (nonatomic, copy) NSString *warmType;
@property (nonatomic, copy) NSString *warmed;
@property (nonatomic, copy) NSString *timeZone;

/* Acc状态*/
@property (nonatomic, copy) NSString *acc;
/* 门状态*/
@property (nonatomic, copy) NSString *door;
/* Acc工作通知*/
@property (nonatomic, copy) NSString *accNotice;
/* 撤防，布防*/
@property (nonatomic, copy) NSString *cfbf;
/* */
@property (nonatomic, copy) NSString *gprsOil;
/* */
@property (nonatomic, copy) NSString *gprsProp;
/* GPS漂移抑制*/
@property (nonatomic, copy) NSString *gpsFloat;
/* 油量检测报警 */
@property (nonatomic, copy) NSString *oilCheckWarn;
/* 油电控制,0断开油点，1恢复油电 */
@property (nonatomic, copy) NSString *dydd;
/* 内电外电 */
@property (nonatomic, copy) NSString *powerType;
/* 休眠模式 */
@property (nonatomic, copy) NSString *restMod;
/* 振动灵敏度 */
@property (nonatomic, copy) NSString *sensitivity;

/* 低电报警 */
@property (nonatomic, copy) NSString *warmDiDian;
/* 掉电报警 */
@property (nonatomic, copy) NSString *warmDiaoDian;
/* 超速报警 */
@property (nonatomic, copy) NSString *warmSpeed;
/* 振动报警 */
@property (nonatomic, copy) NSString *warmZD;
/* 盲区报警 */
@property (nonatomic, copy) NSString *warnBlind;

//acc = 0;
//accNotice = "";
//altitude = 16;
//carNum = 403;
//cfbf = ""; // 0布防 撤防
//createTime = 1590371004000;
//direct = N;
//dno = 864180032876083;
//door = 1;
//gprsOil = 69;
//gprsProp = "41.8";
//gps = 14;
//gpsFloat = "";  //1 gps漂移抑制开
//gsm = 27;
//icon = 5;
//lat = "22.551338";
//listFence =         (
//);
//lng = "113.908852";
//mileage = 0;
//name = 403;
//oil = 69; //油量
//oilCheckWarn = "";
//"oil_prop" = "41.8"; //油量百分比
//online = 1;
//power = 100;
//powerType = "";  //0内电 1外电
//remainCount = 0;
//remainTime = "0-0:0";
//restMod = "";
//sensitivity = ""; //振动灵敏度
//speed = 0;
//timeZone = "";
//warmDiDian = "";
//warmDiaoDian = "";
//warmSpeed = "";
//warmType = "";
//warmZD = "";
//warmed = 0;
//warnBlind = ""; // 盲区

@end
