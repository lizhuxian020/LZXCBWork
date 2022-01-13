//
//  UIImage+YLImage.h
//  YlzfBusiness
//
//  Created by yunlaizhifu_ios on 2018/1/4.
//  Copyright © 2018年 yunlaizhifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YLImage)
///根据颜色返回一张纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
/**
 根据颜色生成图片

 @param text 图片中文字
 @param fontSize 文字字体
 @param size 图片大小
 @param textColor 文字颜色
 @param backgroundColor 图片颜色
 @param radius 图片圆角半径
 @return 返回图片
 */
+ (UIImage *)imageWithText:(NSString *)text
                  fontSize:(CGFloat)fontSize
                      size:(CGSize)size
                 textColor:(UIColor *)textColor
           backgroundColor:(UIColor *)backgroundColor
                    radius:(CGFloat)radius;
@end
