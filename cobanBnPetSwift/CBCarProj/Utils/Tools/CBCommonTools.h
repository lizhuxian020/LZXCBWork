//
//  CBCommonTools.h
//  Telematics
//
//  Created by coban on 2019/7/22.
//  Copyright © 2019 coban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBHomeLeftMenuModel.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBCommonTools : NSObject

#pragma mark -- 直接传入精度丢失有问题的Double类型
+ (NSString *)decimalNumberWithDouble:(double)conversionValue;


#pragma mark -- 数字精准格式化 decimals == 2整数保留小数位数 decimals == 4整数保留小数四数
// roundingModel == -1 只舍不入 == 0 四舍五入 == 1只入不舍
//scale: 小数点后保留的位数
//RoundingMode: 小数保留的类型
//根据官方文档说明, 枚举值分析:
//NSRoundPlain, 四舍五入
//NSRoundDown, 只舍不入
//NSRoundUp, 只入不舍
//NSRoundBankers 四舍六入, 中间值时, 取最近的,保持保留最后一位为偶数
+ (NSString *)formatting_numberString_decimals:(NSDecimalNumber *)decimalNumber
                                 roundingModel:(NSInteger)roundingModel
                                      decimals:(NSInteger)decimals;

/***  存储设备信息   */
+ (BOOL)saveCBdeviceInfo:(CBHomeLeftMenuDeviceInfoModel *)CBdeviceInfo;

/** 返回存储的设备信息 */
+ (CBHomeLeftMenuDeviceInfoModel *)CBdeviceInfo;

/***  删除本地设备信息 */
+ (BOOL)deleteCBDeviceInfo;

//CBBaseNetworkModel
/***  存储设备信息   */
+ (BOOL)saveCBdeviceInfoList:(CBBaseNetworkModel *)CBdeviceInfo;

/** 返回存储的设备信息 */
+ (CBBaseNetworkModel *)CBdeviceInfoList;

/***  删除本地设备信息 */
+ (BOOL)deleteCBDeviceInfoList;

/***  字典存储设备列表信息   */
+ (BOOL)saveCBdeviceInfoListDic:(NSMutableDictionary *)deviceDic;

/** 返回存储的设备列表信息字典 */
+ (NSMutableDictionary *)getCBdeviceInfoModelDic;

/***  删除本地设备列表信息字典 */
+ (BOOL)deleteCBDeviceInfoDic;

// 时间戳转时间间隔描述，xx分xx秒
+ (NSArray *)getDetailTimeWithTimestamp:(NSInteger)timestamp;

// 时间转豪秒
+ (NSString *)timeStrConvertTimeInteral:(NSString *)timeStr formatter:(NSDateFormatter* )formatter;

/// 百度坐标转高德坐标
+ (CLLocationCoordinate2D)GCJ02FromBD09:(CLLocationCoordinate2D)coor;

// 高德坐标转百度坐标
+ (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)coor;

// 百度坐标 转谷歌通用坐标
+ (CLLocationCoordinate2D)GoogleCOMMONFromBD09:(CLLocationCoordinate2D)coor;

// 谷歌通用坐标 转百度坐标
+ (CLLocationCoordinate2D)BD09FromGoogleCOMMON:(CLLocationCoordinate2D)coor;

// 返回设备列表的icon
+ (UIImage *)returnDeveceListImageStr:(NSString *)iconStr isOnline:(NSString *)onlineStr isWarmed:(NSString *)warmedStr;

// 返回定位设备的icon
+ (UIImage *)returnDeveceLocationImageStr:(NSString *)iconStr isOnline:(NSString *)onlineStr isWarmed:(NSString *)warmedStr;

#pragma mark 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;

#pragma mark - 是否在国内
+ (BOOL)checkIsChina:(CLLocationCoordinate2D)coor;

/* 获取某一天的时间段 0:00-23:59 （转为东八区）*/
+ (NSDictionary *)getSomeDayPeriod:(NSDate *)date;

#pragma mark - 获取当前时间时间戳
+ (NSString *)getCurrentTimeString;

#pragma mark - 获取关于app的定位权限
+ (BOOL)checkWhetherAllowPosition;

@end

NS_ASSUME_NONNULL_END
