//
//  CBCarDeviceManager.h
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/19.
//  Copyright © 2022 coban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBMQTTCarDeviceModel.h"

#define CarDeviceManager CBCarDeviceManager.shared
NS_ASSUME_NONNULL_BEGIN

/// 主要处理地图相关, 设备的显示数据
@interface CBCarDeviceManager : NSObject

/** 选中的设备  */
@property (nonatomic, strong, readonly) CBHomeLeftMenuDeviceInfoModel *deviceInfoModelSelect;

/// 需要画绿色围栏的设备
@property (nonatomic, strong, readonly) CBHomeLeftMenuDeviceInfoModel *greedFenceDevice;

/// 用于点击地图时显示(数据来源于getDevData, getParamList)
/// 应该先请求DeviceList,
@property (nonatomic, strong) NSArray<CBHomeLeftMenuDeviceInfoModel *> *deviceDatas;

/// 目前主要用于画图
@property (nonatomic, copy) void (^didUpdateDeviceData)(NSArray<CBHomeLeftMenuDeviceInfoModel *> *deviceDatas);

+ (instancetype)shared;

/// 选择设备后刷新,
- (void)requestDeviceData;

- (id)getDevicePaoInfo;

- (void)didGetMQTTDeviceModel:(CBMQTTCarDeviceModel *)model;

- (void)setCurrentChooseDevice:(CBHomeLeftMenuDeviceInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
