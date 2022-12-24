//
//  CBHomeLeftMenuModel.h
//  Telematics
//
//  Created by coban on 2019/7/18.
//  Copyright © 2019 coban. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CBHomeLeftMenuDeviceInfoModel;
@class CBHomeLeftMenuDeviceNoGroupModel;

NS_ASSUME_NONNULL_BEGIN

@interface CBHomeLeftMenuModel : NSObject
@end

@interface CBHomeLeftMenuSliderModel : NSObject
/** 标题  */
@property (nonatomic, copy) NSString *title;
/** 在线状态：0-离线，1-在线 不传查询全部  */
@property (nonatomic, copy) NSString *status;
/**   */
@property (nonatomic, copy) NSString *KeyWord;
@end

@interface CBHomeLeftMenuDeviceGroupModel : NSObject
/**   */
@property (nonatomic, copy) NSArray *device;
/**   */
@property (nonatomic, copy) NSString *groupId;
/**   */
@property (nonatomic, copy) NSString *groupName;
/**   */
@property (nonatomic, copy) NSArray *noGroup;
/**   */
@property (nonatomic, copy) NSString *offline;
/**   */
@property (nonatomic, copy) NSString *online;
/**   */
@property (nonatomic, assign) BOOL isShow;
/**   */
@property (nonatomic, assign) BOOL isCheck;
@end


@class CBHomeLeftMenuDeviceInfoModelFenceModel;
@interface CBHomeLeftMenuDeviceInfoModel : NSObject
/**  车牌号 */
@property (nonatomic, copy) NSString *carNum;
/**  车牌颜色,0-蓝色，1-黄色，2-白色 */
@property (nonatomic, copy) NSString *color;
/**   */
@property (nonatomic, copy) NSString *createTime;
/**   */
@property (nonatomic, copy) NSString *dno;
/**   */
@property (nonatomic, copy) NSString *expireTime;
/**   */
@property (nonatomic, copy) NSString *groupId;
/** 定位图标,0-默认 1-人物 2-宠物 3-自行车 4-摩托车 5-小汽车 6-货车 7-行李  */
@property (nonatomic, copy) NSString *icon;
/**   */
@property (nonatomic, copy) NSString *ids;
/**   */
@property (nonatomic, copy) NSString *lat;
/**   */
@property (nonatomic, copy) NSString *lng;
/**   */
@property (nonatomic, copy) NSString *name;
/** 在线状态：0-离线，1-在线  */
@property (nonatomic, copy) NSString *online;
/**   */
@property (nonatomic, copy) NSString *phone;
/**   */
@property (nonatomic, copy) NSString *speed;
/**   */
@property (nonatomic, copy) NSString *protocol;
/**   */
@property (nonatomic, copy) NSString *remainTime;
/** 使用状态：0-未启用，1-行驶，2-静止 */
@property (nonatomic, copy) NSString *status;
/**   */
@property (nonatomic, copy) NSString *uid;
/** 报警状态 0 未报警 1 报警  */
@property (nonatomic, copy) NSString *warmed;

//设备列表接口里的 status 0：离线 其他：静止(来自设备列表, 如果MQTT没有值, 就判断这个)
@property (nonatomic, copy) NSString *devStatus;
//设备状态    0：未启用 1静止 2行驶 3报警 4停留（各状态对应不同图标）
@property (nonatomic, copy) NSString *devStatusInMQTT;
/**   */
@property (nonatomic, copy) NSString *devPhone;
/** 地图比例  */
@property (nonatomic, copy) NSString *zoomLevel;
/** 选中设备的时区  */
@property (nonatomic, copy) NSString *timeZone;
/**   */
@property (nonatomic, assign) BOOL isCheck;
/**   */
@property (nonatomic, copy) NSArray<CBHomeLeftMenuDeviceInfoModelFenceModel *> *listFence;
@property (nonatomic, copy) NSString *productSpecId;
@property (nonatomic, copy) NSString *proto;


//--------------------paopaoView相关
//--------------------paopaoViewUI相关
@property (nonatomic, assign) BOOL isTracking; //这个是UI相关, 决定是否显示跟踪中
//--------------------paopaoView接口数据
/* Acc状态*/
@property (nonatomic, copy) NSString *acc;
/* 门状态*/
@property (nonatomic, copy) NSString *door;
/* 撤防，布防*/
@property (nonatomic, copy) NSString *cfbf;
/* 油量*/
@property (nonatomic, copy) NSString *oil;
/* 油量百分比 */
@property (nonatomic, copy) NSString *oil_prop;
/* 休眠模式 */
@property (nonatomic, copy) NSString *restMod;
@property(nonatomic, copy) NSString *battery;
@property (nonatomic, copy) NSString *gps;
@property (nonatomic, copy) NSString *gsm;
@property (nonatomic, copy) NSString *warmType;
@property (nonatomic, copy) NSString *address;
/** 停止时间 **/
@property (nonatomic, copy) NSString *stopTime ;

@property (nonatomic, copy) NSString *disQs;//运动汇报时间间隔
@property (nonatomic, copy) NSString *disRest;
@property (nonatomic, copy) NSString *disSos;
@property (nonatomic, copy) NSString *reportWay; //定位策略  0：定时汇报 1定距汇报 2定时定距汇报
@property (nonatomic, copy) NSString *timeQs; //运动汇报时间间隔   
@property (nonatomic, copy) NSString *timeRest; //静止汇报时间间隔
@property (nonatomic, copy) NSString *timeSos;

/// 详见CBMQTTCarDeviceModel的code
@property (nonatomic, assign) int mqttCode ;

/// 来自getMyDeviceLIst
@property(nonatomic, copy) NSString *devModel;
@end

@interface CBHomeLeftMenuDeviceInfoModelFenceModel : NSObject
/**   */
@property (nonatomic, copy) NSString *centerPoint;
/**   */
@property (nonatomic, copy) NSString *comment;
/**   */
@property (nonatomic, copy) NSString *createTime;
/**   */
@property (nonatomic, copy) NSString *data;
/**   */
@property (nonatomic, copy) NSString *dno;
/**   */
@property (nonatomic, copy) NSString *from;
/**   */
@property (nonatomic, copy) NSString *ids;
/**   */
@property (nonatomic, copy) NSString *kind;
/**   */
@property (nonatomic, copy) NSString *name;
/**   */
@property (nonatomic, copy) NSString *rad;
/**   */
@property (nonatomic, copy) NSString *shape;
/**   */
@property (nonatomic, copy) NSString *sn;
/**   */
@property (nonatomic, copy) NSString *speed;
/**   */
@property (nonatomic, copy) NSString *updateTime;
/**   */
@property (nonatomic, copy) NSString *userid;
/**   */
@property(nonatomic, copy) NSString *warmType;

@end
NS_ASSUME_NONNULL_END
