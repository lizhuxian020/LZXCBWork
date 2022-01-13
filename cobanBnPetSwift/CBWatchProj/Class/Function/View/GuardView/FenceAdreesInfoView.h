//
//  FenceAdreesInfoView.h
//  Watch
//
//  Created by lym on 2018/4/19.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FenceAdreesInfoView : UIView
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic,copy) void(^returnBlock)(id action , id objc);

- (void)updateInfoViewIsGoogle:(BOOL)isGoogle;

@end
