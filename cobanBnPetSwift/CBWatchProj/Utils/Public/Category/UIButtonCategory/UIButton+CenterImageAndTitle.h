//
//  UIButton+UIButtonSetEdgeInsets.h
//  UIButtonSetEdgeInsets
//
//  Created by Qi Wang on 11/14/14.
//  Copyright (c) 2014 qiwang. All rights reserved.
//
/*
 
 1，导入#import“UIButton + CenterImageAndTitle.h”2，直接调用方法例如：UIButton button1 = [UIButton buttonWithType：UIButtonTypeCustom]; button1.frame = CGRectMake（60，80 + i 60，SCREEN_WIDTH-60 * 2，45）; button1.tag = i; button1.backgroundColor = [UIColor yellowColor]; button1.titleLabel.font = [UIFont systemFontOfSize：15]; [button1 setTitleColor：[UIColor blackColor] forState：UIControlStateNormal]; [button1 setImage：[UIImage imageNamed：@“img_up”] forState：UIControlStateNormal]; [button1 setTitle：@“测试文本”forState：UIControlStateNormal]; [button1 addTarget：self action：@selector（testAction :) forControlEvents：UIControlEventTouchUpInside]; [self.view addSubview：button1];
 
 //上下居中，图片在上，文字在下[button1 verticalCenterImageAndTitle：10.0f];
 
 //左右居中，文字在左，图片在右[button1 horizo​​ntalCenterTitleAndImage：50.0f];
 
 //左右居中，图片在左，文字在右[button1 horizo​​ntalCenterImageAndTitle：50.0f];
 
 //文字居中，图片在左边[button1 horizo​​ntalCenterTitleAndImageLeft：50.0f];
 
 //文字居中，图片在右边[button1 horizo​​ntalCenterTitleAndImageRight：50.0f];
 
 */
#import <UIKit/UIKit.h>

@interface UIButton (CenterImageAndTitle)

//上下居中，图片在上，文字在下
- (void)verticalCenterImageAndTitle:(CGFloat)spacing;
- (void)verticalCenterImageAndTitle; //默认6.0

//左右居中，文字在左，图片在右
- (void)horizontalCenterTitleAndImage:(CGFloat)spacing;
- (void)horizontalCenterTitleAndImage; //默认6.0

//左右居中，图片在左，文字在右
- (void)horizontalCenterImageAndTitle:(CGFloat)spacing;
- (void)horizontalCenterImageAndTitle; //默认6.0

//文字居中，图片在左边
- (void)horizontalCenterTitleAndImageLeft:(CGFloat)spacing;
- (void)horizontalCenterTitleAndImageLeft; //默认6.0

//文字居中，图片在右边
- (void)horizontalCenterTitleAndImageRight:(CGFloat)spacing;
- (void)horizontalCenterTitleAndImageRight; //默认6.0

@end
