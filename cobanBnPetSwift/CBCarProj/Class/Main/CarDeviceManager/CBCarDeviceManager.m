//
//  CBCarDeviceManager.m
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/19.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBCarDeviceManager.h"

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
    }
    return self;
}

- (void)requestDeviceData {
    [[NetWorkingManager shared] getWithUrl:@"/personController/getDevData" params:@{} succeed:^(id response, BOOL isSucceed) {
        if (!isSucceed || !response || !response[@"data"]) {
            return;
        }
        self.deviceDatas = [CBHomeLeftMenuDeviceInfoModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        if (self.didUpdateDeviceData) {
            self.didUpdateDeviceData(self.deviceDatas);
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)didGetMQTTDeviceModel:(CBMQTTCarDeviceModel *)model {
    for (CBHomeLeftMenuDeviceInfoModel *deviceModel in self.deviceDatas) {
        if ([deviceModel.dno isEqualToString:model.dno]) {
            deviceModel.lat = model.location.lat;
            deviceModel.lng = model.location.lng;
            deviceModel.devStatus = model.devStatus;
            deviceModel.cfbf = model.state.cfbf;
            deviceModel.acc = model.state.acc;
            deviceModel.door = model.state.door;
            deviceModel.battery = model.location.battery;
            deviceModel.warmType = model.state.warnType;
            
            deviceModel.oil = model.state.oil;
            deviceModel.gps = model.location.gps;
            deviceModel.gsm = model.location.gsm;
            
            return;
        }
    }
    if (self.didUpdateDeviceData) {
        self.didUpdateDeviceData(self.deviceDatas);
    }
}
@end
