//
//  HomeModel.h
//  Watch
//
//  Created by lym on 2018/3/29.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HomeInfoDetailModel;

@interface HomeModel : NSObject

//@property (nonatomic, copy) NSString *accuracy;
//@property (nonatomic, copy) NSString *createTime;
//@property (nonatomic, copy) NSString *electric;
//@property (nonatomic, copy) NSString *head;
//@property (nonatomic, copy) NSString *ids;
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *phone;
//@property (nonatomic, copy) NSString *sno;
//@property (nonatomic, copy) NSString *stepSport;
//@property (nonatomic, copy) NSString *updateTime;
//@property (nonatomic, assign) int flag; //定位方式：0-GPS定位，1-WIFI定位
//@property (nonatomic, assign) BOOL isLink; //连接状态：0-未连接，1-已连接
//@property (nonatomic, assign) double lat;
//@property (nonatomic, assign) double lng;
//@property (nonatomic, copy) NSString *status; //状态：2-欠压报警，3-拆除报警，4-进/出区域，1-迟到，0-未按时到家
/** 地址 */
@property (nonatomic, copy) NSString *address;

/** 语聊未读条数 */
@property (nonatomic, copy) NSString *allChatCount;
/** 是否有未读消息 */
@property (nonatomic, copy) NSString *hasMessage;
/** 0, 当前帐号是否是管理员 */
@property (nonatomic, copy) NSString *isFlag;
/** 0, 当前帐号是否是管理员 */
@property (nonatomic, strong) HomeInfoDetailModel *tbWatchMain;




/***  存储首页设备信息  */
+ (BOOL)saveCBDevice:(HomeModel *)device;

/** 返回存储的设备信息 */
+ (HomeModel *)CBDevice;

/***  删除本地设备信息 */
+ (BOOL)deleteCBdevice;

@end


@interface HomeInfoDetailModel : NSObject

@property (nonatomic, copy) NSString *accuracy;
@property (nonatomic, copy) NSString *authNum;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *electric;
/** 定位方式：0-GPS定位，1-WIFI定位 */
@property (nonatomic, assign) int flag;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *ids;
/** 连接状态：0-未连接，1-已连接 */
@property (nonatomic, assign) BOOL isLink;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *sno;
/** 状态：2-欠压报警，3-拆除报警，4-进/出区域，1-迟到，0-未按时到家 */
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *stepSport;
@property (nonatomic, copy) NSString *updateTime;

@end
