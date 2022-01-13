//
//  CBWtMINUtils.h
//  Telematics
//
//  Created by lym on 2017/10/25.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CBWtMINUtils : NSObject
+ (UIView *)createViewWithRadius:(CGFloat)radius;

+ (UILabel *)createLabelWithText:(NSString *)text;
+ (UILabel *)createLabelWithText:(NSString *)text size:(CGFloat)size;
+ (UILabel *)createLabelWithText:(NSString *)text size:(CGFloat)size alignment:(NSTextAlignment)alignment;
+ (UILabel *)createLabelWithText:(NSString *)text size:(CGFloat)size alignment:(NSTextAlignment)alignment textColor:(UIColor *)color;

+ (UIButton *)createBtnWithRadius:(CGFloat)radius title:(NSString *)title;
+ (UIButton *)createBorderBtnWithArrowImage;
+ (UIButton *)createBorderBtnWithArrowImageWithTitle:(NSString *)title;

+ (UITextField *)createTextFieldWithHoldText:(NSString *)holdText;
+ (UITextField *)createTextFieldWithHoldText:(NSString *)holdText fontSize:(CGFloat)size;
+ (UITextField *)createTextFieldWithHoldText:(NSString *)holdText fontSize:(CGFloat)size leftView:(UIView *)view;
+ (UITextField *)createTextFieldWithHoldText:(NSString *)holdText fontSize:(CGFloat)size leftImage:(UIImage *)leftImage leftImageSize:(CGSize)leftSize;
+ (UITextField *)createBorderTextFieldWithHoldText:(NSString *)holdText fontSize:(CGFloat)size;

+ (UIButton *)createNoBorderBtnWithTitle:(NSString *)title;
+ (UIButton *)createNoBorderBtnWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;
+ (UIButton *)createNoBorderBtnWithTitle:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)size;
+ (UIButton *)createNoBorderBtnWithTitle:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)size backgroundColor:(UIColor *)backgroundColor;
+ (UIButton *)createNoBorderBtnWithTitle:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)size backgroundColor:(UIColor *)backgroundColor Radius:(CGFloat)radius;
+ (UIButton *)createBtnWithImage:(UIImage *)image;
+ (UIButton *)createBtnWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage;

+ (UIView *)createLineView;

+ (MBProgressHUD *)hudToView:(UIView *)view withText:(NSString *)text;
+ (void)showProgressHudToView:(UIView *)view withText:(NSString *)text;
+ (NSString *)getTimeFromTimestamp:(NSString *)timestamp formatter:(NSString *)formatterString;
+ (NSDate *)getDateFromTimestamp:(NSString *)timestamp;
+ (NSURL *)getHeadUrl:(NSString *)head;
+ (void)addDetailImageViewToView:(UIView *)view;
+ (void)addLineToView:(UIView *)view isTop:(BOOL)isTop hasSpaceToSide:(BOOL)hasSpace;
@end
