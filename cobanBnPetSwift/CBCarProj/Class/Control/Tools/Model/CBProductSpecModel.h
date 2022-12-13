//
//  CBProductSpecModel.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/13.
//  Copyright © 2022 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBProductSpecModel : NSObject

@property(nonatomic, copy) NSString *pId;
@property(nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL singlePosition;
@property (nonatomic, assign) BOOL autoPosition;
@property (nonatomic, assign) BOOL callChargeInquiry;
@property (nonatomic, assign) BOOL oilElectricityControl;
@property (nonatomic, assign) BOOL fuelSensorCalibration;
@property (nonatomic, assign) BOOL disarm; //撤防
@property (nonatomic, assign) BOOL remoteStart; //远程启动
@property(nonatomic, copy) NSString *proto;
@property(nonatomic, copy) NSString *tbDevModelId;
@end

//"singlePosition":1,
//            "autoPosition":1,
//            "callChargeInquiry":1,
//            "oilElectricityControl":0,
//            "fuelSensorCalibration":0,
//            "arm":0,
//            "silentArm":0,
//            "disarm":0,
//            "motorControl":0,
//            "remoteStart":0,
//            "electricFence":1,
//            "callBack":1,
//            "alarmSwitch":"8,3,4,6,5,1",
//            "hibernates":"0,1,2,3,4,5",
//            "setGprsHeartbeat":1,
//            "timeSet":1,
//            "initializeSet":1,
//            "hardwareReboot":1,
//            "authCode":1,
//            "turnSupplement":1,
//            "gpsDriftSuppression":1,
//            "passwordSet":1,
//            "accWorkNotice":0,
//            "sensitivitySet":1,
//            "tankVolume":0,
//            "mileageInitialValue":1,

NS_ASSUME_NONNULL_END
