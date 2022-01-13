//
//  MINMapPaoPaoView.h
//  Telematics
//
//  Created by lym on 2017/12/7.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MINMapPaoPaoView : UIView
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *speedAndStayLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *warmedBgmView;
@property (nonatomic,copy) void(^clickBlock)(void);
- (instancetype)initWithNormalFrame:(CGRect)frame;
- (void)setSpeed:(CGFloat)speed stayTime:(CGFloat)stayTime;
- (void)setAlertStyle;
@end
