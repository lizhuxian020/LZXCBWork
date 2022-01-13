//
//  MBProgressHUD+BDT.h
//  groupon
//
//  Created by 爱阅读 on 2019/4/24.
//  Copyright © 2019 爱阅读. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (BDT)

/**
 显示提示信息

 @param msg 提示信息内容
 @param delay 显示时间
 */
+ (void)showMessage:(NSString *)msg withDelay:(NSTimeInterval)delay;

+ (void)showHUDWithMsg:(NSString *)msg detail:(NSString *)detail withDelay:(NSTimeInterval)delay;

+ (void)showHUDWithMsg:(NSString *)msg detail:(NSString *)detail;

+ (void)showHUDIcon:(UIView *)view animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
