//
//  CBWtCommonTools.h
//  Telematics
//
//  Created by coban on 2019/7/22.
//  Copyright © 2019 coban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBWtHomeLeftMenuModel.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBWtCommonTools : NSObject

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

///***  存储账号信息*  @param account 需要存储的账号 */
//+ (BOOL)saveCBAccount:(CBWtUserLoginModel *)account;
//
///** 返回存储的账号信息 */
//+ (CBWtUserLoginModel *)CBaccount;

/***  删除本地账号信息 */
+ (BOOL)deleteCBaccount;

// 时间戳转秒
+ (NSInteger)getDetailTimeWithTimestamp:(NSInteger)timestamp;

/// 百度坐标转高德坐标
+ (CLLocationCoordinate2D)GCJ02FromBD09:(CLLocationCoordinate2D)coor;

// 高德坐标转百度坐标
+ (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)coor;

// 返回设备列表的icon
+ (UIImage *)returnDeveceListImageStr:(NSString *)iconStr isOnline:(NSString *)onlineStr isWarmed:(NSString *)warmedStr;

// 返回定位设备的icon
+ (UIImage *)returnDeveceLocationImageStr:(NSString *)iconStr isOnline:(NSString *)onlineStr isWarmed:(NSString *)warmedStr;

#pragma mark - 获取沙盒Caches的文件目录
+ (NSString *)CachesDirectory;
#pragma mark - 返回path路径下文件的文件大小
+ (double)sizeWithFilePaht:(NSString *)path;
#pragma mark - 清理缓存
+ (void)cleanTheCachesFinished:(void (^)(BOOL success))finishBlcok;

#pragma mark -  处理UILabel特定字符串颜色
+ (void)labelColorWithKeywords:(NSString *)keywords label:(UILabel *)label color:(UIColor *)color;
#pragma mark -  处理UILabel特定字符串颜色和字体
+ (void)labelColorWithKeywords:(NSString *)keywords label:(UILabel *)label color:(UIColor *)color font:(UIFont *)font;
#pragma mark -  处理UILabel特定字符串字体
+ (void)labelColorWithKeywords:(NSString *)keywords label:(UILabel *)label font:(UIFont *)font;

// 字典转json字符串方法
#pragma mark -  字典转json字符串方法
+ (NSString *)convertToJsonData:(id )dict;
#pragma mark -  json字符串转字典方法
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
#pragma mark -  json字符串转数组方法
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;

#pragma mark 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;

#pragma mark View转图片
+ (UIImage *)getImageFromView:(UIView *)view;

#pragma mark - 生成二维码中间带logo代码
+ (UIImage *)createQRCodeByStringLogo:(NSString *)string;

#pragma mark - 麦克风授权
+ (BOOL)checkMicrophonePermission;

#pragma mark - 是否在国内
+ (BOOL)checkIsChina:(CLLocationCoordinate2D)coor;

#pragma mark - 获取关于app的信息
+ (NSString *)appVersion;

#pragma mark - 获取关于app的定位权限
+ (BOOL)checkWhetherAllowPosition;

//#pragma mark - 获取关于app的录音权限
//+ (BOOL)checkWhetherAllowRecord;

@end

NS_ASSUME_NONNULL_END
