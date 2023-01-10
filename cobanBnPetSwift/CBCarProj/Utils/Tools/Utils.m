//
//  Utils.m
//  PowerBank
//
//  Created by 麦鱼科技 on 2017/7/6.
//  Copyright © 2017年 麦鱼科技. All rights reserved.
//

#import "Utils.h"
#import "NSString+LBExtension.h"
@implementation Utils


static CGFloat yyj_font10 = 0;
static CGFloat yyj_font11 = 0;
static CGFloat yyj_font12 = 0;
static CGFloat yyj_font13 = 0;
static CGFloat yyj_font14 = 0;
static CGFloat yyj_font15 = 0;
static CGFloat yyj_font16 = 0;
static CGFloat yyj_font17 = 0;

+ (CGFloat)heigthForFont10 {
    static dispatch_once_t onceF10Token;
    dispatch_once(&onceF10Token, ^{
        NSString *aText = @"金珠";
        yyj_font10 = [aText sizeFroTextWithMaxSize:CGSizeMake(100,24) font:[UIFont systemFontOfSize:10.0]].height + 2.0;
    });
    return yyj_font10;
}

+ (CGFloat)heigthForFont11 {
    static dispatch_once_t onceF11Token;
    dispatch_once(&onceF11Token, ^{
        NSString *aText = @"金珠";
        yyj_font11 = [aText sizeFroTextWithMaxSize:CGSizeMake(100,24) font:[UIFont systemFontOfSize:11.0]].height + 2.0;
    });
    return yyj_font11;
}

+ (CGFloat)heigthForFont12 {
    static dispatch_once_t onceF12Token;
    dispatch_once(&onceF12Token, ^{
        NSString *aText = @"金珠";
        yyj_font12 = [aText sizeFroTextWithMaxSize:CGSizeMake(100,24) font:[UIFont systemFontOfSize:12.0]].height + 2.0;
    });
    return yyj_font12;
}

+ (CGFloat)heigthForFont13 {
    static dispatch_once_t onceF13Token;
    dispatch_once(&onceF13Token, ^{
        NSString *aText = @"金珠";
        yyj_font13 = [aText sizeFroTextWithMaxSize:CGSizeMake(100,24) font:[UIFont systemFontOfSize:13.0]].height + 2.0;
    });
    return yyj_font13;
}

+ (CGFloat)heigthForFont14 {
    static dispatch_once_t onceF14Token;
    dispatch_once(&onceF14Token, ^{
        NSString *aText = @"金珠";
        yyj_font14 = [aText sizeFroTextWithMaxSize:CGSizeMake(100,24) font:[UIFont systemFontOfSize:14.0]].height + 2.0;
    });
    return yyj_font14;
}

+ (CGFloat)heigthForFont15 {
    static dispatch_once_t onceF15Token;
    dispatch_once(&onceF15Token, ^{
        NSString *aText = @"金珠";
        yyj_font15 = [aText sizeFroTextWithMaxSize:CGSizeMake(100,24) font:[UIFont systemFontOfSize:15.0]].height + 2.0;
    });
    return yyj_font15;
}

+ (CGFloat)heigthForFont16 {
    static dispatch_once_t onceF16Token;
    dispatch_once(&onceF16Token, ^{
        NSString *aText = @"金珠";
        yyj_font16 = [aText sizeFroTextWithMaxSize:CGSizeMake(100,30) font:[UIFont systemFontOfSize:16.0]].height + 2.0;
    });
    return yyj_font16;
}

+ (CGFloat)heigthForFont17 {
    static dispatch_once_t onceF17Token;
    dispatch_once(&onceF17Token, ^{
        NSString *aText = @"金珠";
        yyj_font17 = [aText sizeFroTextWithMaxSize:CGSizeMake(100,30) font:[UIFont systemFontOfSize:16.0]].height + 2.0;
    });
    return yyj_font17;
}

+ (UIViewController*)initViewControllerWithIdentifer:(NSString*)identifer{
    
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:identifer];
    
}

+ (NSString *)getSafeString:(id)aObj {
    if (aObj == nil
        || [aObj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    NSString *aText = [NSString stringWithFormat:@"%@",aObj];
    if ([aText.lowercaseString isEqualToString:@"<null>"]) {
        return @"";
    }
    return aText;
}

+ (NSInteger)getSafeIntValue:(id)aObj {
    NSString *aText = [self getSafeString:aObj];
    if ([[self superclass]isPureInt:aText]) {
        return [aText integerValue];
    }
    return 0;
}

+ (CGFloat)getSafeFloatValue:(id)aObj {
    NSString *aText = [self getSafeString:aObj];
    if ([[self superclass]isPureInt:aText]) {
        return [aText floatValue];
    }
    return 0;
}

+ (double)getSafeDoubleValue:(id)aObj {
    NSString *aText = [self getSafeString:aObj];
    if ([[self superclass]isPureInt:aText]) {
        return [aText doubleValue];
    }
    return 0;
}

+ (NSString *)getSafeTrimString:(id)aObj {
    NSString *aStr = [[self class] getSafeString:aObj];
    aStr = [aStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return aStr;
}

//判断字符串是否是整型
+ (BOOL)isPureInt:(NSString*)text {
    if (0 == [text length]){
        return NO;
    }
    NSScanner* scan = [NSScanner scannerWithString:text];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//URL编码
+ (NSString *)encodeToPercentEscapeString:(NSString *)str {
    if ([str length] == 0) {
        return str;
    }
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSString *outputStr = (NSString *)
    //    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
    //                                                              (CFStringRef)self,
    //                                                              NULL,
    //                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
    //                                                              kCFStringEncodingUTF8));
    //    return outputStr;
}

//URL解码
+ (NSString *)decodeFromPercentEscapeString:(NSString *)str{
    if ([str length] == 0) {
        return @"";
    }
    return [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSString *decodedString  =
    //    (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)self,CFSTR(""),
    //                                                                                          CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    //    return [NSString getSafeString:decodedString];
}

//获取URL中的参数
+ (NSDictionary *)getParamsFromUrlStr:(NSString *)str {
    NSString *urlText = [self getSafeString:str];
    if ([urlText length] == 0) {
        return nil;
    }
    NSArray *aList = [urlText componentsSeparatedByString:@"?"];
    if ([aList count] < 2) {
        return nil;
    }
    
    NSString *pText = [self getSafeString:aList[1]];
    if ([pText length] == 0) {
        return nil;
    }
    
    NSArray *pList = [pText componentsSeparatedByString:@"&"];
    NSMutableDictionary *pDict = [NSMutableDictionary dictionaryWithCapacity:2];
    for (NSString *paramText in pList) {
        NSArray *paramList = [paramText componentsSeparatedByString:@"="];
        if ([paramList count] == 2) {
            pDict[paramList[0]] = paramList[1];
        }else if ([paramList count] == 1) {
            pDict[paramList[0]] = @"";
        }
    }
    return pDict;
}

+ (BOOL)callPhone:(NSString *)phoneNum {
    if (0 == [phoneNum length]) {
        return NO;
    }
    
    NSString *phoneStr = [NSString stringWithFormat:@"telprompt://%@",phoneNum];
    NSURL *phoneUrl = [NSURL URLWithString:phoneStr];
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
        return YES;
    }
    return NO;
}

+ (UIView *)viewWithFrame:(CGRect)frm bgColor:(UIColor *)bgColor {
    UIView *aView = [[UIView alloc] initWithFrame:frm];
    aView.backgroundColor = bgColor;
    
    return aView;
}

+ (UIButton *)createBtnWithFrame:(CGRect)rect title:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle: title forState: UIControlStateHighlighted];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
//    [btn setBackgroundImage:image forState:UIControlStateHighlighted];
    //[btn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UILabel *)createLbWithFrame:(CGRect)rect title:(NSString *)title aliment:(NSTextAlignment)aliment color:(UIColor *)color size:(CGFloat)size
{
    UILabel * lb = [[UILabel alloc] initWithFrame:rect];
    lb.text = title;
    lb.textAlignment = aliment;
    lb.textColor = color;
    lb.font = [UIFont systemFontOfSize:size];
    return lb;
}

+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
//时间戳转时间 指定时区
+ (NSString *)convertTimeWithTimeIntervalString:(NSString *)timeString timeZone:(NSString *)timeZoneStr {
    if (kStringIsEmpty(timeZoneStr)) {
        
        NSArray *deviceArr = CBCarDeviceManager.shared.deviceDatas;
        timeZoneStr = CBCarDeviceManager.shared.deviceInfoModelSelect.timeZone;
        if (kStringIsEmpty(timeZoneStr)) {
            timeZoneStr = @"8";
        }
    }
    
    //毫秒值转化为秒
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时区
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:((timeZoneStr?:@"8").doubleValue)*3600.0];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}

+ (NSString *)caculateTimeSub:(NSString *)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue] + 60 * 60];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components =[calendar components:type fromDate:[NSDate date] toDate:date options:NSCalendarWrapComponents];
    NSLog(@"%ld年%ld月%ld日%ld小时%ld分钟%ld秒",(long)components.year,components.month,components.day,components.hour,components.minute,components.second);
    if (components.year == 0 && components.month == 0 && components.date == 0 && components.hour == 0 && components.minute >= 0 && components.second >= 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)components.minute,(long)components.second];
    }
    return @"";
}

@end
