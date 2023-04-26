//
//  CBWtCommonTools.m
//  Telematics
//
//  Created by coban on 2019/7/22.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBWtCommonTools.h"
#import <AVFoundation/AVFoundation.h>
#import "ZCChinaLocation.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

//账号保存地址
#define CBAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CBAccount.data"]

@implementation CBWtCommonTools

#pragma mark -- 直接传入精度丢失有问题的Double类型
+ (NSString *)decimalNumberWithDouble:(double)conversionValue {
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

#pragma mark -- 数字精准格式化 decimals == 2整数保留2位小数 decimals == 4整数保留4位小数 默认整数2位小数
//roundingModel == -1 只舍不入 == 0 四舍五入 == 1只入不舍
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
    NSArray *array = [resultString componentsSeparatedByString:@"."];
    NSString *str_index2 = array.count == 2 ? array[1] : @"";
    if ([str_index2 isEqualToString:@""] || str_index2.length == 2) {
        // 整数或者 小数点后面2位的话，保留两位小数
        resultString = [NSString stringWithFormat:@"%.2f",[resultString doubleValue]];
        return resultString;
    }
    return resultString;
}
///***  存储账号信息*  @param account 需要存储的账号 */
//+ (BOOL)saveCBAccount:(CBWtUserLoginModel *)account {
//    return  [NSKeyedArchiver archiveRootObject:account toFile:CBAccountFile];
//}
//
///** 返回存储的账号信息 */
//+ (CBWtUserLoginModel *)CBaccount {
//    // 取出账号
//    @try {
//        CBWtUserLoginModel *deviceInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:CBAccountFile];
//        return deviceInfo;
//    }
//    @catch (NSException *exception) {
//        NSLog(@"==异常");
//        return nil;
//    }
//    @finally {
//    }
//}

/***  删除本地账号信息 */
+ (BOOL)deleteCBaccount {
    if (!CBAccountFile) {
        return NO;
    } else {
        return [[NSFileManager defaultManager] removeItemAtPath:CBAccountFile error:nil];
    }
}

// 时间戳转秒
+ (NSInteger)getDetailTimeWithTimestamp:(NSInteger)timestamp {
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
    
    //second = day*3600*24 + hour*3600 + minute*60 + second;
    
    return second;
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
// 返回设备列表的icon
+ (UIImage *)returnDeveceListImageStr:(NSString *)iconStr isOnline:(NSString *)onlineStr isWarmed:(NSString *)warmedStr {
    UIImage *image = nil;
    if ([onlineStr isEqualToString:@"1"]) {
        // 1 在线
        if ([warmedStr isEqualToString:@"1"]) {
            // 1 报警
            //self.warmedImageView.hidden = NO;
            if ([iconStr isEqualToString:@"0"]) {
                image = [UIImage imageNamed: @"定位图-报警"];
            } else if ([iconStr isEqualToString:@"1"]) {
                image = [UIImage imageNamed: @"人物-报警"];
            } else if ([iconStr isEqualToString:@"2"]) {
                image = [UIImage imageNamed: @"宠物-报警"];
            } else if ([iconStr isEqualToString:@"3"]) {
                image = [UIImage imageNamed: @"单车-报警"];
            } else if ([iconStr isEqualToString:@"4"]) {
                image = [UIImage imageNamed: @"摩托车-报警"];
            } else if ([iconStr isEqualToString:@"5"]) {
                image = [UIImage imageNamed: @"小车-报警"];
            } else if ([iconStr isEqualToString:@"6"]) {
                image = [UIImage imageNamed: @"货车-报警"];
            } else if ([iconStr isEqualToString:@"7"]) {
                image = [UIImage imageNamed: @"行李箱-报警"];
            }
        } else {
            // 0或nil 未报警
            //self.warmedImageView.hidden = YES;
            if ([iconStr isEqualToString:@"0"]) {
                image = [UIImage imageNamed: @"定位图"];
            } else if ([iconStr isEqualToString:@"1"]) {
                image = [UIImage imageNamed: @"人物"];
            } else if ([iconStr isEqualToString:@"2"]) {
                image = [UIImage imageNamed: @"宠物"];
            } else if ([iconStr isEqualToString:@"3"]) {
                image = [UIImage imageNamed: @"单车"];
            } else if ([iconStr isEqualToString:@"4"]) {
                image = [UIImage imageNamed: @"摩托车"];
            } else if ([iconStr isEqualToString:@"5"]) {
                image = [UIImage imageNamed: @"小车"];
            } else if ([iconStr isEqualToString:@"6"]) {
                image = [UIImage imageNamed: @"货车"];
            } else if ([iconStr isEqualToString:@"7"]) {
                image = [UIImage imageNamed: @"行李箱"];
            }
        }
    } else {
        // 0 离线
        //self.warmedImageView.hidden = YES;
        if ([warmedStr isEqualToString:@"1"]) {
            // 1 报警
            //self.warmedImageView.hidden = NO;
            if ([iconStr isEqualToString:@"0"]) {
                image = [UIImage imageNamed: @"定位图-报警"];
            } else if ([iconStr isEqualToString:@"1"]) {
                image = [UIImage imageNamed: @"人物-报警"];
            } else if ([iconStr isEqualToString:@"2"]) {
                image = [UIImage imageNamed: @"宠物-报警"];
            } else if ([iconStr isEqualToString:@"3"]) {
                image = [UIImage imageNamed: @"单车-报警"];
            } else if ([iconStr isEqualToString:@"4"]) {
                image = [UIImage imageNamed: @"摩托车-报警"];
            } else if ([iconStr isEqualToString:@"5"]) {
                image = [UIImage imageNamed: @"小车-报警"];
            } else if ([iconStr isEqualToString:@"6"]) {
                image = [UIImage imageNamed: @"货车-报警"];
            } else if ([iconStr isEqualToString:@"7"]) {
                image = [UIImage imageNamed: @"行李箱-报警"];
            }
        } else {
            if ([iconStr isEqualToString:@"0"]) {
                image = [UIImage imageNamed: @"定位图-离线"];
            } else if ([iconStr isEqualToString:@"1"]) {
                image = [UIImage imageNamed: @"人物-离线"];
            } else if ([iconStr isEqualToString:@"2"]) {
                image = [UIImage imageNamed: @"宠物-离线"];
            } else if ([iconStr isEqualToString:@"3"]) {
                image = [UIImage imageNamed: @"单车-离线"];
            } else if ([iconStr isEqualToString:@"4"]) {
                image = [UIImage imageNamed: @"摩托车-离线"];
            } else if ([iconStr isEqualToString:@"5"]) {
                image = [UIImage imageNamed: @"小车-离线"];
            } else if ([iconStr isEqualToString:@"6"]) {
                image = [UIImage imageNamed: @"货车-离线"];
            } else if ([iconStr isEqualToString:@"7"]) {
                image = [UIImage imageNamed: @"行李箱-离线"];
            }
        }
    }
    return image;
}

// 返回定位设备的icon
+ (UIImage *)returnDeveceLocationImageStr:(NSString *)iconStr isOnline:(NSString *)onlineStr isWarmed:(NSString *)warmedStr {
    UIImage *image = nil;
    if ([onlineStr isEqualToString:@"1"]) {
        // 1 在线
        if ([warmedStr isEqualToString:@"1"]) {
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
            }
        } else {
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
            }
        }
    } else {
        if ([warmedStr isEqualToString:@"1"]) {
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
            }
        } else {
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
            }
        }
    }
    return image;
}

#pragma mark - 获取沙盒Caches的文件目录
+ (NSString *)CachesDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}
#pragma mark - 返回path路径下文件的文件大小
+ (double)sizeWithFilePaht:(NSString *)path {
    // 1.获得文件夹管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 2.检测路径的合理性
    BOOL dir = NO;
    BOOL exits = [mgr fileExistsAtPath:path isDirectory:&dir];
    if (!exits) return 0;
    
    // 3.判断是否为文件夹
    if (dir) { // 文件夹, 遍历文件夹里面的所有文件
        // 这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径)
        NSArray *subpaths = [mgr subpathsAtPath:path];
        int totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullsubpath = [path stringByAppendingPathComponent:subpath];
            
            BOOL dir = NO;
            [mgr fileExistsAtPath:fullsubpath isDirectory:&dir];
            if (!dir) { // 子路径是个文件
                NSDictionary *attrs = [mgr attributesOfItemAtPath:fullsubpath error:nil];
                totalSize += [attrs[NSFileSize] intValue];
            }
        }
        return totalSize / (1024 * 1024.0);
    } else { // 文件
        NSDictionary *attrs = [mgr attributesOfItemAtPath:path error:nil];
        return [attrs[NSFileSize] intValue] / (1024 * 1024.0);
    }
}
#pragma mark - 清理缓存
+ (void)cleanTheCachesFinished:(void (^)(BOOL success))finishBlcok {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        for (NSString *p in files) {
            NSError *error;
            NSString *path;
            path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        finishBlcok(YES);
    });
}
#pragma mark -  处理UILabel特定字符串颜色
+ (void)labelColorWithKeywords:(NSString *)keywords label:(UILabel *)label color:(UIColor *)color {
    NSString *totalText = label.text;
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc] initWithString:totalText];
    NSRange range = [totalText rangeOfString:keywords];
    
    if(range.location != NSNotFound)
    {
        [attributeString setAttributes:@{NSForegroundColorAttributeName:color} range:range];
    }
    
    label.attributedText = attributeString;
}
#pragma mark -  处理UILabel特定字符串颜色和字体
+ (void)labelColorWithKeywords:(NSString *)keywords label:(UILabel *)label color:(UIColor *)color font:(UIFont *)font {
    NSString *totalText = label.text;
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc] initWithString:totalText];
    NSRange range = [totalText rangeOfString:keywords];
    
    if(range.location != NSNotFound)
    {
        [attributeString setAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font} range:range];
    }
    
    label.attributedText = attributeString;
}
#pragma mark -  处理UILabel特定字符串字体
+ (void)labelColorWithKeywords:(NSString *)keywords label:(UILabel *)label font:(UIFont *)font {
    NSString *totalText = label.text?:@"";
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc] initWithString:totalText];
    NSRange range = [totalText rangeOfString:keywords];
    
    if(range.location != NSNotFound)
    {
        [attributeString setAttributes:@{NSFontAttributeName:font} range:range];
    }
    
    label.attributedText = attributeString;
}


// 字典转json字符串方法
#pragma mark -  字典转json字符串方法
+ (NSString *)convertToJsonData:(id)dict

{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}
#pragma mark -  json字符串转字典方法
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark -  json字符串转数组方法
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString {
    if (jsonString) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp];
                
            } else {
                return nil;
            }
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}

//获取当前屏幕显示的viewcontroller
#pragma mark 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC {
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
#pragma mark View转图片
+ (UIImage *)getImageFromView:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 生成二维码中间带logo代码
+ (UIImage *)createQRCodeByStringLogo:(NSString *)string {
    //1.生成coreImage框架中的滤镜来生产二维码
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:[string dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    //4.获取生成的图片
    CIImage *ciImg = filter.outputImage;
    //放大ciImg,默认生产的图片很小
    //5.设置二维码的前景色和背景颜色
    CIFilter *colorFilter=[CIFilter filterWithName:@"CIExposureAdjust"];
    //5.1设置默认值
    [colorFilter setDefaults];
    [colorFilter setValue:ciImg forKey:@"inputImage"];
    //5.3获取生存的图片
    ciImg=colorFilter.outputImage;
    
    CGAffineTransform scale=CGAffineTransformMakeScale(10, 10);
    ciImg=[ciImg imageByApplyingTransform:scale];
    
    //    self.imgView.image=[UIImage imageWithCIImage:ciImg];
    
    //6.在中心增加一张图片
    UIImage *img=[UIImage imageWithCIImage:ciImg];
    //7.生存图片
    //7.1开启图形上下文
    UIGraphicsBeginImageContext(img.size);
    //7.2将二维码的图片画入
    CGFloat imgW = img.size.width;
    CGFloat imgH = img.size.height;
    [img drawInRect:CGRectMake(0, 0, imgW, imgH)];
    //7.3在中心划入其他图片
    
    UIImage *centerImg=[UIImage imageNamed:@"icon--60"];
    if (centerImg){
        CGFloat centerW = centerImg.size.width * 0.6;//1.5;//3;
        CGFloat centerH = centerImg.size.height * 0.6;//1.5;//3;
        CGFloat centerX = (img.size.width - centerW) * 0.5;
        CGFloat centerY = (img.size.height - centerH) * 0.5;

        [centerImg drawInRect:CGRectMake(centerX, centerY, centerW, centerH)];
    }
    
    //7.4获取绘制好的图片
    UIImage *finalImg=UIGraphicsGetImageFromCurrentImageContext();
    
    //7.5关闭图像上下文
    UIGraphicsEndImageContext();
    return finalImg;
    
    //    return [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:string] withSize:160.0f];
}
#pragma mark - 麦克风授权
+ (BOOL)checkMicrophonePermission {
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {// 未询问用户是否授权
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
                [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                    if (granted) {
                        bCanRecord = YES;
                    } else {
                        bCanRecord = NO;
                    }
                }];
            }
        } else if(videoAuthStatus == AVAuthorizationStatusRestricted || videoAuthStatus == AVAuthorizationStatusDenied) {
            bCanRecord = NO;
            // 未授权
            [self showSetAlertView];
        } else{
            // 已授权
            NSLog(@"已授权");
        }
    }
    return bCanRecord;
}
//提示用户进行麦克风使用授权
+ (void)showSetAlertView {
    // 麦克风授权提醒
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:Localized(@"麦克风权限未开启") message:Localized(@"麦克风权限未开启,请进入系统【设置】>【隐私】>【麦克风】中打开开关,开启麦克风功能") preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"去设置") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //跳入当前App设置界面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [[AppDelegate shareInstance].window.rootViewController presentViewController:alertControl animated:YES completion:nil];
};
#pragma mark - 校验是否在国内
+ (BOOL)checkIsChina:(CLLocationCoordinate2D)coor {
    BOOL isChina = [[ZCChinaLocation shared] isInsideChina:coor];
    return isChina;
}
#pragma mark - 获取关于app的信息
+ (NSString *)appVersion {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}
#pragma mark - 获取关于app的定位权限
+ (BOOL)checkWhetherAllowPosition {
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        return YES;
    } else {
        return NO;
    }
}
//#pragma mark - 获取关于app的录音权限
//+ (BOOL)checkWhetherAllowRecord {
//    
//}
@end
