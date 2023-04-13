//
//  CBCarDeviceManager.m
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/19.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBCarDeviceManager.h"

@interface CBCarDeviceManager ()

/** 选中的设备  */
@property (nonatomic, strong) CBHomeLeftMenuDeviceInfoModel *deviceInfoModelSelect;

@end

@implementation CBCarDeviceManager

+ (instancetype)shared {
    static CBCarDeviceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [CBCarDeviceManager new];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.deviceInfoModelSelect = [CBCommonTools CBdeviceInfo];
        [self didSetCurrentDeviceModel];
    }
    return self;
}

- (void)refreashData:(void(^)(void))finishBlk {
    [self generalInitData:self.deviceDatas finishBlk:^(NSArray *deviceArrResult){
        [self requestDeviceDataBlk:deviceArrResult finishBlk:^(NSArray *deviceArrResult2) {
            [self updateAllDeviceParamList:deviceArrResult2 finishBlk:^(NSArray *deviceArrResult3) {
                self.deviceDatas = deviceArrResult3;
                if (self.didUpdateDeviceData) {
                    self.didUpdateDeviceData(self.deviceDatas);
                }
                [NSNotificationCenter.defaultCenter postNotificationName:@"CBCAR_NOTFICIATION_GETMQTT" object:nil userInfo:nil];
            }];
        }];
    }];
}

- (void)generalInitData:(NSArray *)deviceArr finishBlk:(void(^)(NSArray *))finishBlk {
    [[NetWorkingManager shared] getWithUrl:@"/personController/getMyDeviceList" params:@{} succeed:^(id response, BOOL isSucceed) {
        if (!isSucceed || !response || !response[@"data"]) {
            return;
        }
        NSArray<CBHomeLeftMenuDeviceGroupModel *> *groupArr = [CBHomeLeftMenuDeviceGroupModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        NSMutableArray<CBHomeLeftMenuDeviceInfoModel *> *deviceList = [NSMutableArray new];
        for (CBHomeLeftMenuDeviceGroupModel *groupModel in groupArr) {
            if (groupModel.noGroup) {
                [deviceList addObjectsFromArray:groupModel.noGroup];
            } else {
                [deviceList addObjectsFromArray:groupModel.device];
            }
        }
//        self.deviceDatas = deviceList;
        finishBlk(deviceList);
    } failed:^(NSError *error) {
        
    }];
}

- (void)requestDeviceData {
    [self requestDeviceDataBlk:self.deviceDatas finishBlk:^(NSArray *deviceArrResult2) {
        [self updateAllDeviceParamList:deviceArrResult2 finishBlk:^(NSArray *deviceArrResult3) {
            self.deviceDatas = deviceArrResult3;
            if (self.didUpdateDeviceData) {
                self.didUpdateDeviceData(self.deviceDatas);
            }
        }];
    }];
}

- (void)requestDeviceDataBlk:(NSArray *)deviceArr finishBlk:(void(^)(NSArray *))finishBlk {
    if (!deviceArr) {
        [self generalInitData:deviceArr finishBlk:^(NSArray *deviceArrResult){
            [self requestDeviceDataBlk:deviceArrResult finishBlk:finishBlk];
        }];
        return;
    }
    [[NetWorkingManager shared] getWithUrl:@"/personController/getDevData" params:@{} succeed:^(id response, BOOL isSucceed) {
        if (!isSucceed || !response || !response[@"data"]) {
            return;
        }
        //把接口DeviceList的devStatus, online数据, 更新到getDevData之后的模型里
        NSArray<CBHomeLeftMenuDeviceInfoModel*> *modelArr = [CBHomeLeftMenuDeviceInfoModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        for (CBHomeLeftMenuDeviceInfoModel *modelInDevice in deviceArr) {
            for (CBHomeLeftMenuDeviceInfoModel *model in modelArr) {
                if ([modelInDevice.dno isEqualToString:model.dno]) {
                    model.devStatus = modelInDevice.devStatus;
                    model.online = modelInDevice.online;
                    model.devModel = modelInDevice.devModel;
                    //记得要加这个, 因为只有DeviceList里才有这个字段
                    model.productSpecId = modelInDevice.productSpecId;
                    model.proto = modelInDevice.proto;
                }
            }
        }
        
//        self.deviceDatas = modelArr;
//        [self updateAllDeviceParamList:^{
//            NSLog(@"%s", __FUNCTION__);
//        }];
//        if (self.didUpdateDeviceData) {
//            self.didUpdateDeviceData(self.deviceDatas);
//        }
        if (finishBlk) {
            finishBlk(modelArr);
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)updateAllDeviceParamList:(NSArray *)deviceArr finishBlk:(void(^)(NSArray *))finishBlk {
    __block int time = 0;
    for (CBHomeLeftMenuDeviceInfoModel *deviceModel in deviceArr) {
        [self updateParamList:deviceModel finish:^(CBHomeLeftMenuDeviceInfoModel *resultModel){
            if (finishBlk) {
                time++;
                if (time == deviceArr.count) {
                    finishBlk(deviceArr);
                }
            }
        }];
    }
}

- (void)updateParamList:(CBHomeLeftMenuDeviceInfoModel *)model finish:(void(^)(CBHomeLeftMenuDeviceInfoModel *))finishBLk {
    if (kStringIsEmpty(model.dno)) {
        return;
    }
    [[NetWorkingManager shared] getWithUrl:@"/devControlController/getParamList" params:@{
        @"dno": model.dno
    } succeed:^(id response, BOOL isSucceed) {
        if (!isSucceed || !response || !response[@"data"]) {
            return;
        }
        CBHomeLeftMenuDeviceInfoModel *deviceModel = [CBHomeLeftMenuDeviceInfoModel mj_objectWithKeyValues:response[@"data"]];
        model.disQs = deviceModel.disQs;
        model.disRest = deviceModel.disRest;
        model.disSos = deviceModel.disSos;
        model.reportWay = deviceModel.reportWay;
        model.timeQs = deviceModel.timeQs;
        model.timeRest = deviceModel.timeRest;
        model.timeSos = deviceModel.timeSos;
        if (finishBLk) {
            finishBLk(model);
        }
    } failed:^(NSError *error) {
        if (finishBLk) {
            finishBLk(model);
        }
    }];
}

- (void)didGetMQTTDeviceModel:(CBMQTTCarDeviceModel *)model {
    if (model.devStatus.intValue == 3) { //收到报警时, 更新首页的报警数量
        [NSNotificationCenter.defaultCenter postNotificationName:@"CBCAR_NOTFICIATION_UPDATE_ALARM_NUM" object:nil userInfo:nil];
    }
    /*
     "code":73 下发wifi名和密码

     {
         "code": 73,
         "data": {
             "wifi_name ": "cobanxxx",
             "wifi_password": "123456"
         },
         "answerResult": 0,
         "dno": "863584040008426"
     }
     */
    if (model.code == 73) {
        
        [NSNotificationCenter.defaultCenter postNotificationName:@"CBCAR_NOTFICIATION_GET_WIFI_INFO" object:nil userInfo:@{
            @"wifi_name": model.wifi_name ?: @"",
            @"wifi_password": model.wifi_password ?: @"",
        }];
        return;
    } else if (model.code == 64) {
        /*
         "code": 64 设备主动上报报警图片/用户下发拍照指令上报

         备注:863584040008426
         1.主动上报和报警的区分标识：
                   warn_type:字段为空用户下发拍照上报,不为空触发报警主动上报
          触发报警主动上报类型：直接弹个大图出来，存在 查看、忽略 两个按钮 点查看跳到消息列表，点忽略消失
          用户下发拍照上报类型：直接弹个大图出来，存在   保存、忽略两个按钮 点保存存到手机相册，点忽略消失
         2.消息列表：消息列表有图就图文展示 没图就和之前一样

         {
             "code": 64,
             "data": {
                 "lat":22.115,//纬度
                 "lng":113.5555,//经度
                 "image_paths":"a.jpg,b.jpg",//报警图片
                 "warn_type":1,2,3 //报警类型
                 "ts":1678417609 //报警时间
             }
             "answerResult": 0, //0 成功  其他： 下发失败
             "dno": "863584040008426"

         }
         */
        return;
    } else if (model.code == 1 || model.code == 6) {
//        主题内容 topic/car-pc/188/863584040008426
//
//        上线推送数据：
//        {
//            "code": 6,
//            "data": {
//                "dno": "863584040008426",
//                "devStatus": 1
//            },
//            "answerResult": 0,
//            "dno": "863584040008426"
//        }
//
//        离线推送数据
//        {
//            "code": 1,
//            "data": {
//                "dno": "863584040008426",
//                "devStatus": 5
//            },
//            "answerResult": 0,
//            "dno": "863584040008426"
//        }
        for (CBHomeLeftMenuDeviceInfoModel *deviceModel in self.deviceDatas) {
            if ([deviceModel.dno isEqualToString:model.dno]) {
                deviceModel.devStatusInMQTT = model.devStatus;
                deviceModel.mqttCode = model.code;
            }
        }
        if (self.didUpdateDeviceData) {
            self.didUpdateDeviceData(self.deviceDatas);
        }
        [NSNotificationCenter.defaultCenter postNotificationName:@"CBCAR_NOTFICIATION_GETMQTT" object:nil userInfo:nil];
        return;
    } else if (model.code != 21) { //2时, 更新围栏.
        /*
         {
             answerResult = 0;
             code = 2;
         }
         */
        [self updateFence:^{
            [self updateAllDeviceParamList:self.deviceDatas finishBlk:^(NSArray *deviceArr) {
                self.deviceDatas = deviceArr;
                if (self.didUpdateDeviceData) {
                    self.didUpdateDeviceData(self.deviceDatas);
                }
            }];
        }];
        [NSNotificationCenter.defaultCenter postNotificationName:@"CBCAR_NOTFICIATION_GETMQTT" object:nil userInfo:nil];
        [NSNotificationCenter.defaultCenter postNotificationName:@"CBCAR_NOTFICIATION_GETMQTT_CODE2" object:nil userInfo:nil];
        return;
    } else if (model.code == 21) {
        CBHomeLeftMenuDeviceInfoModel *targetDeviceModel = nil;
        //    static int i = 1;
        //    static double lat = 22.55143761870045;
        //    static double lng = 113.9088315586976;
        //
        //    if (i++ % 2 == 0) {
        //        static int k = 1;
        //        lat = lat + k++ * 0.00100000070045;
        //        model.dno = @"864180032876083";
        //    } else {
        //        static int j = 1;
        //        lng = lng + j++ * 0.0010000006976;
        //        model.dno = @"863584040008426";
        //    }
        //    model.location.lng = @(lng).description;
        //    model.location.lat = @(lat).description;
        for (CBHomeLeftMenuDeviceInfoModel *deviceModel in self.deviceDatas) {
            if ([deviceModel.dno isEqualToString:model.dno]) {
                targetDeviceModel = deviceModel;
                deviceModel.lat = model.location.lat;
                deviceModel.lng = model.location.lng;
                deviceModel.devStatusInMQTT = model.devStatus;
                deviceModel.cfbf = model.state.cfbf;
                deviceModel.acc = model.state.acc;
                deviceModel.door = model.state.door;
                deviceModel.battery = model.location.battery;
                deviceModel.warmType = model.state.warnType;
                deviceModel.stopTime = model.state.stopTime;
                
                deviceModel.oil = model.state.oil;
                deviceModel.temp = model.state.temp;
                deviceModel.humidity = model.state.humidity;
                deviceModel.gps = model.location.gps;
                deviceModel.gsm = model.location.gsm;
                
                deviceModel.mqttCode = model.code;
                
                deviceModel.timeZone = model.location.timeZone;
                deviceModel.createTime = model.location.updateTime;
                
                deviceModel.speedInMqtt = model.location.speed;
                deviceModel.directInMqtt = model.location.direct;
            }
        }
        if (self.didUpdateDeviceData) {
            self.didUpdateDeviceData(self.deviceDatas);
        }
        [NSNotificationCenter.defaultCenter postNotificationName:@"CBCAR_NOTFICIATION_GETMQTT" object:nil userInfo:nil];
    }
}

- (void)updateFence:(void(^)(void))finishBlk {
    [[NetWorkingManager shared] getWithUrl:@"/personController/getDevData" params:@{} succeed:^(id response, BOOL isSucceed) {
        if (!isSucceed || !response || !response[@"data"]) {
            return;
        }
        
        //把getDevData里fence的数据更新到当前模型
        NSArray<CBHomeLeftMenuDeviceInfoModel*> *modelArr = [CBHomeLeftMenuDeviceInfoModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        for (CBHomeLeftMenuDeviceInfoModel *modelInDevice in self.deviceDatas) {
            for (CBHomeLeftMenuDeviceInfoModel *model in modelArr) {
                if ([modelInDevice.dno isEqualToString:model.dno]) {
                    modelInDevice.listFence = model.listFence;
                }
            }
        }
        
        finishBlk();
        
        } failed:^(NSError *error) {
            finishBlk();
        }];
}

- (void)setCurrentChooseDevice:(CBHomeLeftMenuDeviceInfoModel *)model {
    for (CBHomeLeftMenuDeviceInfoModel *_model in self.deviceDatas) {
        if ([model.dno isEqualToString:_model.dno]) {
            
            _deviceInfoModelSelect = _model;
            //保存这里的model, 因为这里model比较全
            [CBCommonTools saveCBdeviceInfo:_deviceInfoModelSelect];
        }
    }
    [self didSetCurrentDeviceModel];
}


- (void)didSetCurrentDeviceModel {
    if (_deviceInfoModelSelect) {
        [CBDeviceTool.shareInstance didChooseDevice:_deviceInfoModelSelect];
        [self requestDeviceData];
    }
}

- (CBHomeLeftMenuDeviceInfoModel *)deviceInfoModelSelect {
    for (CBHomeLeftMenuDeviceInfoModel *deviceSelect in self.deviceDatas) {
        if ([deviceSelect.dno isEqualToString:_deviceInfoModelSelect.dno]) {
            return deviceSelect;
        }
    }
    return _deviceInfoModelSelect;
}

- (CBHomeLeftMenuDeviceInfoModel *)getModelWithDno:(NSString *)dno {
    for (CBHomeLeftMenuDeviceInfoModel *deviceSelect in self.deviceDatas) {
        if ([deviceSelect.dno isEqualToString:dno]) {
            return deviceSelect;
        }
    }
    return nil;
}
@end
