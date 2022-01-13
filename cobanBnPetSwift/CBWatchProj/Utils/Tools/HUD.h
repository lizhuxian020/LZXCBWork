//
//  HUD.h
//  PowerBank
//
//  Created by 麦鱼科技 on 2017/7/11.
//  Copyright © 2017年 麦鱼科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"
@interface HUD : NSObject

/**
 文字弹窗

 @param text 显示的文字
 */
+ (void)showHUDWithText:(NSString*)text;

/**
 文字弹窗

 @param text 显示的文字
 */
+ (void)showHUDWithText:(NSString*)text withDelay:(CGFloat)delay;


/**
 转圈圈 （正在加载...）
 */
+ (void)showHudWaitStr:(NSString *)str;

/**
 隐藏弹窗
 */
+ (void)hideHud;

/**
 转圈圈

 @param text 一边转圈一边显示的文字
 */
+ (void)showStateWithText:(NSString *)text;


@end
