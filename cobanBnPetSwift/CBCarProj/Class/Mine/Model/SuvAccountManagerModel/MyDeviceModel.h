//
//  MyDeviceModel.h
//  Telematics
//
//  Created by lym on 2018/1/2.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDeviceModel : NSObject
@property (nonatomic, copy) NSString *address;      //  地址
@property (nonatomic, copy) NSString *carNum;       //  车牌号
@property (nonatomic, assign) int color;            //  车牌颜色,0-蓝色，1-黄色，2-白色
@property (nonatomic, copy) NSString *devPhone;     //  设备电话号码
@property (nonatomic, copy) NSString *dno;          //
@property (nonatomic, copy) NSString *groupId;      //  设备分组id
@property (nonatomic, assign) int icon;             //  定位图标,0-车，1-人物，2-宠物
@property (nonatomic, copy) NSString *deviceId;     //  主键
@property (nonatomic, copy) NSString *imei;         //  车辆VIN号(当设备为车辆时有效)
@property (nonatomic, copy) NSString *name;         //  设备型号名称
@property (nonatomic, assign) int online;           //  在线状态：0-离线，1-在线
@property (nonatomic, copy) NSString *phone;        //  回拨电话
@property (nonatomic, copy) NSString *protocol;         //  协议类型
@property (nonatomic, assign) int status;           //  使用状态：0-未启用，1-行驶，2-静止
@property (nonatomic, assign) double lat;           //
@property (nonatomic, assign) double lng;           //
@property (nonatomic, assign) int warmed;           // 1 报警 0 未报警
@property (nonatomic, copy) NSString *uid;          //
@property (nonatomic, copy) NSString *version;      //  设备版本号
@property (nonatomic, copy) NSString *vin;          //  车辆VIN号(当设备为车辆时有效
@property (nonatomic, copy) NSString *updateTime;   //  redis获取  暂时没有数据
@property (nonatomic, copy) NSString *speed;        //   redis获取 暂时没有数据
@property (nonatomic, copy) NSString *createTime;        //   注册时间
@property (nonatomic, copy) NSString *registerTime;        //   注册时间
@property (nonatomic, copy) NSString *expireTime;        //   有效时间
@property (nonatomic, copy) NSString *devModel; //产品类型
@property(nonatomic, copy) NSString *productSpecId;
@property (nonatomic, copy) NSString *leftTitle;        //   左侧标题
@property (nonatomic, copy) NSString *groupNameStr;     //   分组名称
@end
