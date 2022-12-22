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
        NSArray<CBHomeLeftMenuDeviceInfoModel*> *modelArr = [CBHomeLeftMenuDeviceInfoModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        for (CBHomeLeftMenuDeviceInfoModel *modelInDevice in self.deviceDatas) {
            for (CBHomeLeftMenuDeviceInfoModel *model in modelArr) {
                if ([modelInDevice.dno isEqualToString:model.dno]) {
                    model.devStatus = modelInDevice.devStatus;
                }
            }
        }
        
        self.deviceDatas = modelArr;
        for (CBHomeLeftMenuDeviceInfoModel *deviceModel in self.deviceDatas) {
            [self updateParamList:deviceModel];
        }
        if (self.didUpdateDeviceData) {
            self.didUpdateDeviceData(self.deviceDatas);
        }
        if (finishBlk) {
            finishBlk();
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)updateParamList:(CBHomeLeftMenuDeviceInfoModel *)model {
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
    } failed:^(NSError *error) {
        
    }];
}

- (void)didGetMQTTDeviceModel:(CBMQTTCarDeviceModel *)model {
    for (CBHomeLeftMenuDeviceInfoModel *deviceModel in self.deviceDatas) {
        if ([deviceModel.dno isEqualToString:model.dno]) {
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
            return;
        }
    }
    if (self.didUpdateDeviceData) {
        self.didUpdateDeviceData(self.deviceDatas);
    }
    [NSNotificationCenter.defaultCenter postNotificationName:@"CBCAR_NOTFICIATION_GETMQTT" object:nil userInfo:nil];
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
