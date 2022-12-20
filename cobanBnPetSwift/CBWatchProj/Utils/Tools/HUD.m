//
//  HUD.m
//  PowerBank
//
//  Created by 麦鱼科技 on 2017/7/11.
//  Copyright © 2017年 麦鱼科技. All rights reserved.
//

#import "HUD.h"

@implementation HUD


+ (void)showHUDWithText:(NSString *)text{
    //[SVProgressHUD setMinimumSize:CGSizeMake(280, 120)];
//    [SVProgressHUD setCornerRadius:5];
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//    [SVProgressHUD setFont:[UIFont systemFontOfSize:15]];
//    [SVProgressHUD setForegroundColor:[UIColor colorWithHexString:@"666666"]];
//    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showImage:nil status:text];
    [SVProgressHUD dismissWithDelay:1.2];
}
+ (void)showHUDWithText:(NSString*)text withDelay:(CGFloat)delay {
//    [SVProgressHUD setMinimumSize:CGSizeMake(280, 120)];
//    [SVProgressHUD setCornerRadius:5];
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//    [SVProgressHUD setFont:[UIFont systemFontOfSize:15]];
//    [SVProgressHUD setForegroundColor:[UIColor colorWithHexString:@"666666"]];
//    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showImage:nil status:text];
    [SVProgressHUD dismissWithDelay:delay == 0?1.2:delay];
}
+ (void)showHudWaitStr:(NSString *)str {
    [SVProgressHUD setMinimumSize:CGSizeMake(0, 0)];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:str];//@"正在加载..."
}

+ (void)hideHud{
    [SVProgressHUD dismiss];
}

+ (void)showStateWithText:(NSString *)text{
    [SVProgressHUD setMinimumSize:CGSizeMake(0, 0)];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:text];
}
@end
