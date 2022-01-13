//
//  SwitchHeaderView.h
//  Watch
//
//  Created by lym on 2018/2/8.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchView;
@interface SwitchHeaderView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) SwitchView *swtichView;
@property (nonatomic, copy) void (^switchStatusChange)(BOOL isOn);
@end
