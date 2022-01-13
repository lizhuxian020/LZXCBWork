//
//  Utils.h
//  PowerBank
//
//  Created by 麦鱼科技 on 2017/7/6.
//  Copyright © 2017年 麦鱼科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CBWtUtils : NSObject

+ (CGFloat)heigthForFont10;
+ (CGFloat)heigthForFont11;
+ (CGFloat)heigthForFont12;
+ (CGFloat)heigthForFont13;
+ (CGFloat)heigthForFont14;
+ (CGFloat)heigthForFont15;
+ (CGFloat)heigthForFont16;
+ (CGFloat)heigthForFont17;

/**
 从Main初始化控制器

 @param identifer 标识符
 @return 控制器
 */
+ (UIViewController*)initViewControllerWithIdentifer:(NSString*)identifer;
//安全取值
+ (NSString *)getSafeString:(id)aObj;
+ (NSInteger)getSafeIntValue:(id)aObj;
+ (CGFloat)getSafeFloatValue:(id)aObj;
+ (double)getSafeDoubleValue:(id)aObj;
+ (NSString *)getSafeTrimString:(id)aObj;

//URL编、解码
+ (NSString *)encodeToPercentEscapeString:(NSString*)str;
+ (NSString *)decodeFromPercentEscapeString:(NSString*)str;
//获取URL中的参数
+ (NSDictionary *)getParamsFromUrlStr:(NSString*)str;
//拨打电话
+ (BOOL)callPhone:(NSString *)phoneNum;
//创建view
+ (UIView *)viewWithFrame:(CGRect)frm bgColor:(UIColor *)bgColor;
// 创建按钮
+ (UIButton *)createBtnWithFrame:(CGRect)rect title:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action;
// 创建UILabel
+ (UILabel *)createLbWithFrame:(CGRect)rect title:(NSString *)title aliment:(NSTextAlignment)aliment color:(UIColor *)color size:(CGFloat)size;
//时间戳转时间
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;

+ (NSString *)caculateTimeSub:(NSString *)time;

@end
