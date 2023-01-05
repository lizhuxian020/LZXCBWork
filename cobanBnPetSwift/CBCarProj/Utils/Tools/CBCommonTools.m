//
//  CBCommonTools.m
//  Telematics
//
//  Created by coban on 2019/7/22.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBCommonTools.h"
#import "ZCChinaLocation.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "DeviceDetailModel.h"

//设备信息保存地址
#define CBDeviceInfoFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CBdeviceInfo.data"]
//设备信息保存地址
#define CBDeviceInfoListFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CBdeviceInfoList.data"]
//设备信息字典保存地址
#define CBDeviceInfoDicFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CBdeviceInfoDic.data"]

@implementation CBCommonTools

#pragma mark -- 直接传入精度丢失有问题的Double类型
+ (NSString *)decimalNumberWithDouble:(double)conversionValue {
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

#pragma mark -- 数字精准格式化 decimals == 2整数保留2位小数 decimals == 4整数保留4位小数 默认整数2位小数
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
                                      decimals:(NSInteger)decimals {
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler
                                                decimalNumberHandlerWithRoundingMode:roundingModel == 0 ? NSRoundPlain : roundingModel == -1 ?  NSRoundDown : NSRoundUp
                                                scale:decimals?:2
                                                raiseOnExactness:NO
                                                raiseOnOverflow:NO
                                                raiseOnUnderflow:NO
                                                raiseOnDivideByZero:NO];
    NSDecimalNumber *resultDN = [decimalNumber decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString *resultString = [NSString stringWithFormat:@"%@",resultDN];
    NSArray *array = [resultString componentsSeparatedByString:@"."];
    NSString *str_index2 = array.count == 2 ? array[1] : @"";
    // 优先判断decimal
    // 小数点后面保留两位小数
    if (decimals == 2) {
        resultString = [NSString stringWithFormat:@"%.2f",[resultString doubleValue]];
        return resultString;
    }
    // 小数点后面保留4位小数
    if (decimals == 4) {
        resultString = [NSString stringWithFormat:@"%.4f",[resultString doubleValue]];
        return resultString;
    }
    if ([str_index2 isEqualToString:@""] || str_index2.length == 2) {
        // 整数或者 小数点后面2位的话，保留两位小数
        resultString = [NSString stringWithFormat:@"%.2f",[resultString doubleValue]];
        return resultString;
    }
    return resultString;
}
/***  存储设备信息  */
+ (BOOL)saveCBdeviceInfo:(CBHomeLeftMenuDeviceInfoModel *)CBdeviceInfo {
    BOOL result = [NSKeyedArchiver archiveRootObject:CBdeviceInfo toFile:CBDeviceInfoFile];
    if (result) {
        NSLog(@"=======存储选中设备信息====成功====");
    } else {
        NSLog(@"=======存储选中设备信息====失败====");
    }
    return  result;
}

/** 返回存储的设备信息 */
+ (CBHomeLeftMenuDeviceInfoModel *)CBdeviceInfo {
    // 取出账号
    @try {
        CBHomeLeftMenuDeviceInfoModel *deviceInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:CBDeviceInfoFile];
        return deviceInfo;
    }
    @catch (NSException *exception) {
        NSLog(@"==异常");
        return nil;
    }
    @finally {
    }
}

/***  删除本地设备信息 */
+ (BOOL)deleteCBDeviceInfo {
    if (!CBDeviceInfoFile) {
        return NO;
    } else {
        NSError *error;
        BOOL result = [[NSFileManager defaultManager] removeItemAtPath:CBDeviceInfoFile error:&error];
        if (result) {
            NSLog(@"=======删除选中设备信息====成功====");
        } else {
            NSLog(@"=======删除选中设备信息====失败====");
            NSLog(@"======%@",error);
        }
        return result;
    }
}
/***  存储设备列表信息   */
+ (BOOL)saveCBdeviceInfoList:(CBBaseNetworkModel *)CBdeviceInfo {
    return  [NSKeyedArchiver archiveRootObject:CBdeviceInfo toFile:CBDeviceInfoListFile];
}

/** 返回存储的设备列表信息 */
+ (CBBaseNetworkModel *)CBdeviceInfoList {
    @try {
        CBBaseNetworkModel *deviceInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:CBDeviceInfoListFile];
        return deviceInfo;
    }
    @catch (NSException *exception) {
        NSLog(@"==异常");
        return nil;
    }
    @finally {
    }
}

/***  删除本地设备列表信息 */
+ (BOOL)deleteCBDeviceInfoList {
    if (!CBDeviceInfoListFile) {
        return NO;
    } else {
        return [[NSFileManager defaultManager] removeItemAtPath:CBDeviceInfoListFile error:nil];
    }
}
/***  字典存储设备列表信息   */
+ (BOOL)saveCBdeviceInfoListDic:(NSMutableDictionary *)deviceDic {
    BOOL result = [NSKeyedArchiver archiveRootObject:deviceDic toFile:CBDeviceInfoDicFile];
    if (result == YES) {
        NSLog(@"字典存储设备成功");
    } else {
        NSLog(@"字典存储设备失败");
    }
    return  result;
}

/** 返回存储的设备列表信息字典 */
+ (NSMutableDictionary *)getCBdeviceInfoModelDic {
    @try {
        NSMutableDictionary *deviceInfoModelDic = [NSKeyedUnarchiver unarchiveObjectWithFile:CBDeviceInfoDicFile];
        return deviceInfoModelDic;
    }
    @catch (NSException *exception) {
        NSLog(@"==异常");
        return nil;
    }
    @finally {
    }
}

/***  删除本地设备列表信息字典 */
+ (BOOL)deleteCBDeviceInfoDic {
    if (!CBDeviceInfoDicFile) {
        return NO;
    } else {
        return [[NSFileManager defaultManager] removeItemAtPath:CBDeviceInfoDicFile error:nil];
    }
}
// 时间戳转时间间隔描述，xx分xx秒
+ (NSArray *)getDetailTimeWithTimestamp:(NSInteger)timestamp {
    NSInteger ms = timestamp;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    if (timestamp <= 0) {
//        self.hourLabel.text = [NSString stringWithFormat:@"%d",0];
//        self.minuesLabel.text = [NSString stringWithFormat:@"%d",0];
//        self.secondsLabel.text = [NSString stringWithFormat:@"%d",0];
//        if (self.timerStopBlock) {
//            self.timerStopBlock();
//        }
//        return;
        timestamp = 0;
    }
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger hourMax = 0;
    if (day >= 1) {
        hourMax = 24 + hour;//时(超过24小时，不算天)
    } else {
        hourMax = hour;
    }
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    return @[@(day),@(hourMax),@(minute),@(second)];
    //return second;
}
// 时间转豪秒
+ (NSString *)timeStrConvertTimeInteral:(NSString *)timeStr formatter:(NSDateFormatter* )formatter {
    if (!formatter){
        formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSDate *date=[formatter dateFromString:timeStr];
    NSString *backString = [NSString stringWithFormat:@"%.f", [date timeIntervalSince1970]];
    //backString = [backString stringByAppendingString:@"000"];
    return backString;
}
//百度地图坐标与苹果自带地图经纬度之间的相互转换方法：
/// 百度坐标转高德坐标
+ (CLLocationCoordinate2D)GCJ02FromBD09:(CLLocationCoordinate2D)coor {
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude - 0.0065, y = coor.latitude - 0.006;
    CLLocationDegrees z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    CLLocationDegrees gg_lon = z * cos(theta);
    CLLocationDegrees gg_lat = z * sin(theta);
    return CLLocationCoordinate2DMake(gg_lat, gg_lon);
}

// 高德坐标转百度坐标
+ (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)coor {
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude, y = coor.latitude;
    CLLocationDegrees z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    CLLocationDegrees bd_lon = z * cos(theta) + 0.0065;
    CLLocationDegrees bd_lat = z * sin(theta) + 0.006;
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}
// 百度坐标 转谷歌通用坐标
+ (CLLocationCoordinate2D)GoogleCOMMONFromBD09:(CLLocationCoordinate2D)coor {
    CLLocationCoordinate2D googleCommonCoor = BMKCoordTrans(coor, BMK_COORDTYPE_COMMON, BMK_COORDTYPE_BD09LL);
    return googleCommonCoor;
}
// 谷歌通用坐标 转百度坐标
+ (CLLocationCoordinate2D)BD09FromGoogleCOMMON:(CLLocationCoordinate2D)coor {
    CLLocationCoordinate2D baiduCoor = BMKCoordTrans(coor, BMK_COORDTYPE_BD09LL,BMK_COORDTYPE_COMMON);
    return baiduCoor;
}

+ (UIImage *)returnDeveceListImageStr:(NSString *)iconStr isOnline:(NSString *)onlineStr isWarmed:(NSString *)warmedStr {
    return [self returnDeveceLocationImageStr:iconStr isOnline:onlineStr isWarmed:warmedStr mqttCode:0 devStatusInMqtt:@""];
}

// 返回定位设备的icon
+ (UIImage *)returnDeveceLocationImageStr:(NSString *)iconStr
                                 isOnline:(NSString *)onlineStr
                                 isWarmed:(NSString *)warmedStr
                                 mqttCode:(int)mqttCode
                          devStatusInMqtt:(NSString *)devStatusInMqtt {
    return [self returnDeveceListImageWithDic:@{
        @"iconStr": iconStr ?: @"",
        @"onlineStr": onlineStr ?: @"",
        @"warmedStr": warmedStr ?: @"",
        @"devStatusInMqtt": devStatusInMqtt ?: @"",
        @"mqttCode": @(mqttCode)
    }];
}


// 返回设备列表的icon
/*
 只有上线后才会收到code=21的推送
一个完整的流程就是 先上线 然后上报位置（其中会产生不同的设备状态） 最后离线

先收到code=6的推送 把图标和状态由离线更新成在线（静止类型图标）
之后会到code=21的推送 把图标和状态由离线更新根据devstats判断展示（判断展示类型图标）
最后会到code=1的推送代表设备离线状态更改为离线（离线类型图标）
 */
+ (UIImage *)returnDeveceListImageWithDic:(NSDictionary *)dic {
    NSString *iconStr = dic[@"iconStr"];
    NSString *onlineStr = dic[@"onlineStr"];
    NSString *warmedStr = dic[@"warmedStr"];
    NSString *devStatusInMqtt = dic[@"devStatusInMqtt"];////设备状态    0：未启用 1静止 2行驶 3报警 4停留（各状态对应不同图标）
    int mqttCode = [dic[@"mqttCode"] intValue];
    
    if (mqttCode > 0) {
        if (mqttCode == 6) {
            return [self getNormalIcon:iconStr];
        }
        if (mqttCode == 21) {
            if (devStatusInMqtt.intValue == 1 || devStatusInMqtt.intValue == 4) {
                return [self getStopIcon:iconStr];
            }
            if (devStatusInMqtt.intValue == 2) {
                return [self getNormalIcon:iconStr];
            }
            if (devStatusInMqtt.intValue == 3) {
                return [self getWarmIcon:iconStr];
            }
            return [self getOfflineIcon:iconStr];
        }
        if (mqttCode == 1) {
            return [self getOfflineIcon:iconStr];
        }
    }
    
    if ([warmedStr isEqualToString:@"1"]) {
        return [self getWarmIcon:iconStr];
    } else if ([onlineStr isEqualToString:@"1"]) {
        return [self getNormalIcon:iconStr];
    } else {
        return [self getOfflineIcon:iconStr];
    }
    return [self getOfflineIcon:iconStr];
}

+ (UIImage *)getWarmIcon:(NSString *)iconStr {
    UIImage *image = nil;
    // 1 报警
    if ([iconStr isEqualToString:@"0"]) {
        image = [UIImage imageNamed: @"定位图-报警"];
    } else if ([iconStr isEqualToString:@"1"]) {
        image = [UIImage imageNamed: @"人物-定位-报警"];
    } else if ([iconStr isEqualToString:@"2"]) {
        image = [UIImage imageNamed: @"宠物-定位-报警"];
    } else if ([iconStr isEqualToString:@"3"]) {
        image = [UIImage imageNamed: @"单车-定位-报警"];
    } else if ([iconStr isEqualToString:@"4"]) {
        image = [UIImage imageNamed: @"摩托车-定位-报警"];
    } else if ([iconStr isEqualToString:@"5"]) {
        image = [UIImage imageNamed: @"小车-定位-报警"];//@"小车-报警"
    } else if ([iconStr isEqualToString:@"6"]) {
        image = [UIImage imageNamed: @"货车-定位-报警"];
    } else if ([iconStr isEqualToString:@"7"]) {
        image = [UIImage imageNamed: @"行李箱-定位-报警"];
    } else if ([iconStr isEqualToString:@"8"]) {
        image = [UIImage imageNamed: @"船-定位-报警"];
    } else if ([iconStr isEqualToString:@"9"]) {
        image = [UIImage imageNamed: @"电动车-定位-报警"];
    } else if ([iconStr isEqualToString:@"10"]) {
        image = [UIImage imageNamed: @"公交车-定位-报警"];
    } else {
        image = [UIImage imageNamed: @"定位图-报警"];
    }
    return image;
}

+ (UIImage *)getNormalIcon:(NSString *)iconStr {
    UIImage *image = nil;
    // 0或nil 未报警
    if ([iconStr isEqualToString:@"0"]) {
        image = [UIImage imageNamed: @"定位图"];
    } else if ([iconStr isEqualToString:@"1"]) {
        image = [UIImage imageNamed: @"人物-定位-正常"];
    } else if ([iconStr isEqualToString:@"2"]) {
        image = [UIImage imageNamed: @"宠物-定位-正常"];
    } else if ([iconStr isEqualToString:@"3"]) {
        image = [UIImage imageNamed: @"单车-定位-正常"];
    } else if ([iconStr isEqualToString:@"4"]) {
        image = [UIImage imageNamed: @"摩托车-定位-正常"];
    } else if ([iconStr isEqualToString:@"5"]) {
        image = [UIImage imageNamed: @"小车-定位-正常"];
    } else if ([iconStr isEqualToString:@"6"]) {
        image = [UIImage imageNamed: @"货车-定位-正常"];
    } else if ([iconStr isEqualToString:@"7"]) {
        image = [UIImage imageNamed: @"行李箱-定位-正常"];
    } else if ([iconStr isEqualToString:@"8"]) {
        image = [UIImage imageNamed: @"船-定位-正常"];
    } else if ([iconStr isEqualToString:@"9"]) {
        image = [UIImage imageNamed: @"电动车-定位-正常"];
    } else if ([iconStr isEqualToString:@"10"]) {
        image = [UIImage imageNamed: @"公交车-定位-正常"];
    } else {
        image = [UIImage imageNamed: @"定位图"];
    }
    return image;
}
+ (UIImage *)getOfflineIcon:(NSString *)iconStr {
    UIImage *image = nil;
    // 0 离线
    if ([iconStr isEqualToString:@"0"]) {
        image = [UIImage imageNamed: @"定位图-离线"];
    } else if ([iconStr isEqualToString:@"1"]) {
        image = [UIImage imageNamed: @"人物-定位-离线"];
    } else if ([iconStr isEqualToString:@"2"]) {
        image = [UIImage imageNamed: @"宠物-定位-离线"];
    } else if ([iconStr isEqualToString:@"3"]) {
        image = [UIImage imageNamed: @"单车-定位-离线"];
    } else if ([iconStr isEqualToString:@"4"]) {
        image = [UIImage imageNamed: @"摩托车-定位-离线"];
    } else if ([iconStr isEqualToString:@"5"]) {
        image = [UIImage imageNamed: @"小车-定位-离线"];//@"小车-离线" 离线
    } else if ([iconStr isEqualToString:@"6"]) {
        image = [UIImage imageNamed: @"货车-定位-离线"];
    } else if ([iconStr isEqualToString:@"7"]) {
        image = [UIImage imageNamed: @"行李箱-定位-离线"];
    } else if ([iconStr isEqualToString:@"8"]) {
        image = [UIImage imageNamed: @"船-定位-离线"];
    } else if ([iconStr isEqualToString:@"9"]) {
        image = [UIImage imageNamed: @"电动车-定位-离线"];
    } else if ([iconStr isEqualToString:@"10"]) {
        image = [UIImage imageNamed: @"公交车-定位-离线"];
    } else {
        image = [UIImage imageNamed: @"定位图-离线"];
    }
    return image;
}

+ (UIImage *)getStopIcon:(NSString *)iconStr {
    UIImage *image = nil;
    if ([iconStr isEqualToString:@"0"]) {
        image = [UIImage imageNamed: @"定位-静止"];
    } else if ([iconStr isEqualToString:@"1"]) {
        image = [UIImage imageNamed: @"人-静止"];
    } else if ([iconStr isEqualToString:@"2"]) {
        image = [UIImage imageNamed: @"宠物-静止"];
    } else if ([iconStr isEqualToString:@"3"]) {
        image = [UIImage imageNamed: @"自行车-静止"];
    } else if ([iconStr isEqualToString:@"4"]) {
        image = [UIImage imageNamed: @"摩托车-静止"];
    } else if ([iconStr isEqualToString:@"5"]) {
        image = [UIImage imageNamed: @"小车-静止"];
    } else if ([iconStr isEqualToString:@"6"]) {
        image = [UIImage imageNamed: @"货车-静止"];
    } else if ([iconStr isEqualToString:@"7"]) {
        image = [UIImage imageNamed: @"行李箱-静止"];
    } else if ([iconStr isEqualToString:@"8"]) {
        image = [UIImage imageNamed: @"船-静止"];
    } else if ([iconStr isEqualToString:@"9"]) {
        image = [UIImage imageNamed: @"电动车-静止"];
    } else if ([iconStr isEqualToString:@"10"]) {
        image = [UIImage imageNamed: @"公交车-静止"];
    } else {
        image = [UIImage imageNamed: @"定位-静止"];
    }
    return image;
}

//获取当前屏幕显示的viewcontroller
#pragma mark 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    return currentVC;
}
#pragma mark - 校验是否在国内
+ (BOOL)checkIsChina:(CLLocationCoordinate2D)coor {
    BOOL isChina = [[ZCChinaLocation shared] isInsideChina:coor];
    return isChina;
}

/* 获取某一天的时间段 0:00-23:59 （转为东八区）*/
+ (NSDictionary *)getSomeDayPeriod:(NSDate *)date {
    /* 转为当天零点*/
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth
                            | NSCalendarUnitDay | NSCalendarUnitHour
                            | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *zerocompents = [cal components:unitFlags fromDate:date];
    NSLog(@"%@",zerocompents);
    // 转化成0晨0点时间
    zerocompents.hour = 0;
    zerocompents.minute = 0;
    zerocompents.second = 0;
    NSLog(@"%@",zerocompents);
    // NSdatecomponents转NSdate类型
    NSDate *beginDate = [cal dateFromComponents:zerocompents];
    NSDate *endDate = [beginDate dateByAddingTimeInterval:3600*24-1];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*3600];
    [formatter setTimeZone:timeZone];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    
    NSString* startTime = [formatter stringFromDate:beginDate];
    NSString* endTime = [formatter stringFromDate:endDate];

    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[startTime, endTime]forKeys:@[@"startTime",@"endTime"]];
    return dic;
}

+ (NSString *)getCurrentTimeString {
    NSDate *date = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%.f", [date timeIntervalSince1970]];
    return dateString;
    
}
#pragma mark - 获取关于app的定位权限
+ (BOOL)checkWhetherAllowPosition {
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        return YES;
    } else {
        return NO;
    }
}
@end
