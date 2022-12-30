//
//  MBProgressHUD+BDT.m
//  groupon
//
//  Created by 爱阅读 on 2019/4/24.
//  Copyright © 2019 爱阅读. All rights reserved.
//

#import "MBProgressHUD+BDT.h"

@implementation MBProgressHUD (BDT)
+ (void)showMessage:(NSString *)msg withDelay:(NSTimeInterval)delay {
    if (msg.length > 0) {
        [self showHUDWithMsg:msg detail:@"" withDelay:delay];
    }
}
+ (void)showHUDWithMsg:(NSString *)msg detail:(NSString *)detail withDelay:(NSTimeInterval)delay {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;//防止键盘遮挡
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.backgroundColor = [UIColor colorWithHexString:@"#000000"];//[UIColor colorWithHexString:@"#666666"];
    hud.contentColor = [UIColor colorWithHexString:@"#FFFFFF"];
    hud.label.text = msg;
    hud.label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14 *KFitHeightRate];
    hud.label.numberOfLines = 0;
    hud.detailsLabel.text = detail;
    hud.detailsLabel.numberOfLines = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:delay];
}

+ (void)showHUDWithMsg:(NSString *)msg detail:(NSString *)detail {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;//防止键盘遮挡
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.backgroundColor = [UIColor colorWithHexString:@"#000000"];//[UIColor colorWithHexString:@"#666666"];
    hud.contentColor = [UIColor colorWithHexString:@"#FFFFFF"];
    hud.label.text = msg;
    hud.label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14 *KFitHeightRate];
    hud.label.numberOfLines = 0;
    hud.detailsLabel.text = detail;
    hud.detailsLabel.numberOfLines = 0;
    hud.removeFromSuperViewOnHide = YES;
}
+ (void)showHUDIcon:(UIView *)view animated:(BOOL)animated {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.graceTime = 20;
    hud.mode = MBProgressHUDModeIndeterminate;
    //hud.offset = offset;
    
//    //loading图片和动画
//    UIImage *image = [UIImage imageNamed:@"ic_wheel"];//[[UIImage imageNamed:@"ic_wheel"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
//    imgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
//    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
////    anima.fromValue = @(0);
////    anima.toValue = @(M_PI*2);
//    anima.fromValue = @(M_PI*2);
//    anima.toValue = @(0);
//    anima.duration = 5.0f;//1.0f;
//    anima.repeatCount = 100;
//    [imgView.layer addAnimation:anima forKey:nil];
//
////    UIImage *image_ye = [UIImage imageNamed:@"ic_wheel"];//[[UIImage imageNamed:@"ic_wheel"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
////    UIImageView *imgCenterView = [[UIImageView alloc] initWithImage:image_ye];
////
////    UIImageView *contentView = [[UIImageView alloc] initWithImage:image_ye];
////    [contentView addSubview:imgView];
////    [contentView addSubview:imgCenterView];
////    imgCenterView.center = contentView.center;
////    imgView.center = contentView.center;
//
//    hud.customView = imgView;//contentView;
    
    //先设置hud.bezelView 的style 为MBProgressHUDBackgroundStyleSolidColor，然后再设置其背影色就可以了。因为他默认的style 是MBProgressHUDBackgroundStyleBlur，即不管背影色设置成什么颜色，都会被加上半透明的效果，所以要先改其style
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    //背景颜色
//    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];//[UIColor redColor];
    //hud.bezelView.alpha = 0;//0.5f;
    
//    //背景宽高
//    CGFloat targetWidth;
//    CGFloat targetHeight;
//    CGFloat margin = 0;//10.0f;
//    targetWidth = imgView.width + margin*2;
//    targetHeight = imgView.height + margin*2;
//    CGSize newSize = CGSizeMake(targetWidth, targetHeight);
//    hud.minSize = newSize;
    
    //颜色
    //hud.contentColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];//[UIColor whiteColor];
    //hud.animationType = MBProgressHUDAnimationFade;
}
@end
