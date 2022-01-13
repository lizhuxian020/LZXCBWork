//
//  SwitchView.m
//  Watch
//
//  Created by lym on 2018/2/8.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "SwitchView.h"
#import "MINSwitchView.h"

@implementation SwitchView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.titleLabel = [CBWtMINUtils createLabelWithText: @"拒绝陌生人来电" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
    [self addSubview: self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        //make.width.mas_equalTo(150 * KFitWidthRate);
    }];
    UIImage *imageGray = [UIImage imageNamed: @"frame"];
    self.switchView = [[MINSwitchView alloc] initWithOnImage: [UIImage imageNamed: @"frame"] offImage: [UIImage imageNamed: @"frame-关"] switchImage: [UIImage imageNamed: @"bold-shadow"]];//frame  frame-关
    //self.switchView.backgroundColor = [UIColor redColor];
    [self addSubview: self.switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).with.offset(-25 * KFitWidthRate);
        //make.size.mas_equalTo(CGSizeMake(50 * KFitWidthRate, 30 * KFitWidthRate));
        make.size.mas_equalTo(CGSizeMake(imageGray.size.width,imageGray.size.height));
    }];
    self.statusLabel = [CBWtMINUtils createLabelWithText: @"已开启" size: 15 * KFitWidthRate alignment: NSTextAlignmentRight textColor: KWt137Color];
    [self addSubview: self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.switchView.mas_left).with.offset(-12.5 * KFitWidthRate);
        make.width.mas_equalTo(100 * KFitWidthRate);
    }];
}

@end
