//
//  CBMQTTCarDeviceModel.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/19.
//  Copyright © 2022 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBMQTTCarDeviceStateModel : NSObject


@property(nonatomic, copy) NSString *acc;
@property(nonatomic, copy) NSString *accHandelTime;
@property(nonatomic, copy) NSString *cfbf;
@property(nonatomic, copy) NSString *door;
@property(nonatomic, copy) NSString *oil;
@property(nonatomic, copy) NSString *oilProp;
@property(nonatomic, copy) NSString *stopTime;
@property(nonatomic, copy) NSString *stop_num;
@property(nonatomic, copy) NSString *warnType;
@end

@interface CBMQTTCarDeviceLocationModel : NSObject

@property(nonatomic, copy) NSString *altitude;
@property(nonatomic, copy) NSString *battery;
@property(nonatomic, copy) NSString *direct;
@property(nonatomic, copy) NSString *gps;
@property(nonatomic, copy) NSString *gsm;
@property(nonatomic, copy) NSString *lat;
@property(nonatomic, copy) NSString *lng;
@property(nonatomic, copy) NSString *speed;
@property(nonatomic, copy) NSString *timeZone;
@property(nonatomic, copy) NSString *updateTime;

@end

@interface CBMQTTCarDeviceModel : NSObject
/*
"code":1 设备离线     //此时需改设备状态为绿色
"code": 2 下发指令应答
"code":6设备上线    //此时需改设备状态为蓝色
"code":21设备推送定位数据，当code为21根据对象内容获取结果定位数据，更新到地图上
 */
@property (nonatomic, assign) int code;
//设备状态    0：未启用 1静止 2行驶 3报警 4停留（各状态对应不同图标）
@property (nonatomic, copy) NSString *devStatus;
@property(nonatomic, copy) NSString *dno;
@property (nonatomic, strong) CBMQTTCarDeviceLocationModel *location;
@property (nonatomic, strong) CBMQTTCarDeviceStateModel *state;
@property (nonatomic, copy) NSString *wifi_name;
@property (nonatomic, copy) NSString *wifi_password;
//{
//    answerResult = 0;
//    code = 21;
//    data =     {
//        devStatus = 4;
//        dno = 863584040008426;
//        location =         {
//            altitude = "-5";
//            battery = 0;
//            direct = 0;
//            gps = 10;
//            gsm = 31;
//            lat = "22.55135960634198";
//            lng = "113.9087665933012";
//            speed = "0.3";
//            timeZone = "8.0";
//            updateTime = 1671457023000;
//        };
//        state =         {

//            acc = 0;
//            accHandelTime = 0;
//            cfbf = 0;
//            door = 0;
//            oil = 0;
//            oilProp = 0;
//            stopTime = 1671443348000;
//            "stop_num" = 5;
//            warnType = "";
//        };
//    };
//    dno = 863584040008426;
//}

@end

NS_ASSUME_NONNULL_END
