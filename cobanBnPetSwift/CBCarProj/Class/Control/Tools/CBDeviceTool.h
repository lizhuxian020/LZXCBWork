//
//  CBDeviceTool.h
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/9.
//  Copyright © 2022 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBDeviceTool : NSObject
+ (instancetype)shareInstance;

@property (nonatomic, strong) NSMutableArray *productSepcArr;
@property (nonatomic, strong) NSMutableArray *productSepcIdArr;

- (void)getDeviceNames:(void(^)(NSArray<NSString *> *deviceNames))blk;

- (void)getGroupName:(void(^)(NSArray<NSString *> *groupNames))blk;

- (void)didChooseDevice:(CBHomeLeftMenuDeviceInfoModel *)currentModel;

- (void)getControlData:(void(^)(NSArray *arrayTitle ,NSArray *arrayTitleImage))blk;
@end

NS_ASSUME_NONNULL_END
