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
    [self generalInitData:^{
        [self requestDeviceDataBlk:finishBlk];
    }];
}

- (void)generalInitData:(void(^)(void))finishBlk {
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
        self.deviceDatas = deviceList;
        finishBlk();
    } failed:^(NSError *error) {
        
    }];
}

- (void)requestDeviceData {
    [self requestDeviceDataBlk:nil];
}

- (void)requestDeviceDataBlk:(void(^)(void))finishBlk {
    if (!self.deviceDatas) {
        [self generalInitData:^{
            [self requestDeviceDataBlk:finishBlk];
        }];
        return;
    }
    [[NetWorkingManager shared] getWithUrl:@"/personController/getDevData" params:@{} succeed:^(id response, BOOL isSucceed) {
        if (!isSucceed || !response || !response[@"data"]) {
            return;
        }
        //把接口DeviceList的devStatus, online数据, 更新到getDevData之后的模型里
        NSArray<CBHomeLeftMenuDeviceInfoModel*> *modelArr = [CBHomeLeftMenuDeviceInfoModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        for (CBHomeLeftMenuDeviceInfoModel *modelInDevice in self.deviceDatas) {
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
        
        self.deviceDatas = modelArr;
        [self updateAllDeviceParamList:^{
            NSLog(@"%s", __FUNCTION__);
        }];
        if (self.didUpdateDeviceData) {
            self.didUpdateDeviceData(self.deviceDatas);
        }
        if (finishBlk) {
            finishBlk();
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)updateAllDeviceParamList:(void(^)(void))finishBlk {
    __block int time = 0;
    for (CBHomeLeftMenuDeviceInfoModel *deviceModel in self.deviceDatas) {
        [self updateParamList:deviceModel finish:^{
            if (finishBlk) {
                time++;
                if (time == self.deviceDatas.count) {
                    finishBlk();
                }
            }
        }];
    }
}

- (void)updateParamList:(CBHomeLeftMenuDeviceInfoModel *)model finish:(void(^)(void))finishBLk {
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
            finishBLk();
        }
    } failed:^(NSError *error) {
        if (finishBLk) {
            finishBLk();
        }
    }];
}

- (void)didGetMQTTDeviceModel:(CBMQTTCarDeviceModel *)model {
    if (model.code == 2) { //2时, 更新围栏.
        /*
         {
             answerResult = 0;
             code = 2;
         }
         */
        [self updateFence:^{
            [self updateAllDeviceParamList:^{
                if (self.didUpdateDeviceData) {
                    self.didUpdateDeviceData(self.deviceDatas);
                }
            }];
        }];
        [NSNotificationCenter.defaultCenter postNotificationName:@"CBCAR_NOTFICIATION_GETMQTT" object:nil userInfo:nil];
        return;
    }
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
            deviceModel.gps = model.location.gps;
            deviceModel.gsm = model.location.gsm;
            
            deviceModel.mqttCode = model.code;
            
            deviceModel.timeZone = model.location.timeZone;
            deviceModel.createTime = model.location.updateTime;
        }
    }
    if (model.code == 21 && model.devStatus.intValue == 3) { //收到报警时, 更新首页的报警数量
        [NSNotificationCenter.defaultCenter postNotificationName:@"CBCAR_NOTFICIATION_UPDATE_ALARM_NUM" object:nil userInfo:nil];
    }
    if (self.didUpdateDeviceData) {
        self.didUpdateDeviceData(self.deviceDatas);
    }
    [NSNotificationCenter.defaultCenter postNotificationName:@"CBCAR_NOTFICIATION_GETMQTT" object:nil userInfo:nil];
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
@end
