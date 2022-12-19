//
//  CBCarDeviceManager.h
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/19.
//  Copyright © 2022 coban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBMQTTCarDeviceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBCarDeviceManager : NSObject

@property (nonatomic, strong) NSArray<CBHomeLeftMenuDeviceInfoModel *> *deviceDatas;
@property (nonatomic, copy) void (^didUpdateDeviceData)(NSArray<CBHomeLeftMenuDeviceInfoModel *> *deviceDatas);

+ (instancetype)shared;
- (void)requestDeviceData;


- (id)getDevicePaoInfo;

- (void)didGetMQTTDeviceModel:(CBMQTTCarDeviceModel *)model;
@end

NS_ASSUME_NONNULL_END
