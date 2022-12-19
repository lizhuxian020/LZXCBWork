//
//  CBCarDeviceManager.h
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/19.
//  Copyright © 2022 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBCarDeviceManager : NSObject

@property (nonatomic, strong) NSArray *deviceList;

+ (instancetype)shared;

- (id)getDevicePaoInfo;

@end

NS_ASSUME_NONNULL_END
