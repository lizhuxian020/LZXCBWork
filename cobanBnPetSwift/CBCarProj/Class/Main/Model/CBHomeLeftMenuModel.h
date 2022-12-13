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
/**  使用状态：0-未启用，1-行驶，2-静止 */
@property (nonatomic, copy) NSString *devStatus;
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
