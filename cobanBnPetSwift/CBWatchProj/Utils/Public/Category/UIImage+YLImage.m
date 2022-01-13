//
//  UIImage+YLImage.m
//  YlzfBusiness
//
//  Created by yunlaizhifu_ios on 2018/1/4.
//  Copyright © 2018年 yunlaizhifu. All rights reserved.
//

#import "UIImage+YLImage.h"

@implementation UIImage (YLImage)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    if (size.height == 0){
        return [self changeImageWithColor:color];
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    // 贝塞尔裁切
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:10];
    [path addClip];
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage*) changeImageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
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
                    radius:(CGFloat)radius {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, textColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGFloat yOffset = (rect.size.height - font.pointSize)/2.0 - 1.25;
    CGRect textRect = CGRectMake(0, yOffset, rect.size.width, rect.size.height - yOffset);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [text drawInRect:textRect withAttributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
