//
//  CBDeviceTool.h
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/9.
//  Copyright © 2022 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 主要处理设备对应的功能菜单显示数据
@interface CBDeviceTool : NSObject
+ (instancetype)shareInstance;

@property (nonatomic, strong) NSMutableArray *productSepcArr;
@property (nonatomic, strong) NSMutableArray *productSepcIdArr;

- (void)getProductSpecData:(void(^)(NSArray *productSepcArr, NSArray *productSepcIdArr))productSpecBlk;

- (void)getDeviceNames:(void(^)(NSArray<NSString *> *deviceNames))blk;

- (void)getGroupName:(void(^)(NSArray<NSString *> *groupNames))blk;

- (void)didChooseDevice:(CBHomeLeftMenuDeviceInfoModel *)currentModel;

- (void)getControlData:(CBHomeLeftMenuDeviceInfoModel *)deviceModel blk:(void(^)(NSArray *arrayTitle ,NSArray *arrayTitleImage))blk;

- (void)getDeviceConfigData:(CBHomeLeftMenuDeviceInfoModel *)deviceModel blk:(void(^)(NSArray *arrayTitle ,NSArray *arrayTitleImage))blk;

- (void)getAlarmConfigData:(CBHomeLeftMenuDeviceInfoModel *)deviceModel blk:(void(^)(NSArray *arrayTitle ,NSArray *arrayTitleImage))blk;

- (void)getXiumianData:(CBHomeLeftMenuDeviceInfoModel *)deviceModel blk:(void(^)(NSArray *arrayTitle, NSArray *arrayId))blk;

- (void)getReportData:(CBHomeLeftMenuDeviceInfoModel *)deviceModel blk:(void(^)(NSArray *sectionArr, NSArray *sectionTitleArr, NSArray *sectionImageTitleArr, NSArray *oilTitleArr, NSArray *oilImageArr, NSArray *warnTitleArr, NSArray *warnImageArr, NSArray *electronicTitleArr, NSArray *electronicImageArr))blk;

- (NSString *)getProductSpec:(CBHomeLeftMenuDeviceInfoModel *)model;

- (void)getPaoViewConfig:(CBHomeLeftMenuDeviceInfoModel *)deviceModel blk:(void(^)(NSDictionary *configData))blk;
@end

NS_ASSUME_NONNULL_END
