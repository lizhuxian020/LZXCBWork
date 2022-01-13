//
//  LineTypeView.m
//  Telematics
//
//  Created by lym on 2017/11/16.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "LineTypeView.h"

@implementation LineTypeView

- (instancetype)init
{
    if (self = [super init]) {
        UIView *rightView = [self createBaseViewWithColor: RGB(47, 237, 191) name: @"里程"];
        UIView *middleView = [self createBaseViewWithColor: RGB(253, 155, 39) name: @"速度"];
        UIView *leftView = [self createBaseViewWithColor: RGB(26, 151, 251) name: @"油量"];
        [self addSubview: rightView];
        [self addSubview: middleView];
        [self addSubview: leftView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(60 * KFitWidthRate);
        }];
        [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightView.mas_left).with.offset(-23 * KFitWidthRate);
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(60 * KFitWidthRate);
        }];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(middleView.mas_left).with.offset(-23 * KFitWidthRate);
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(60 * KFitWidthRate);
        }];
    }
    return self;
}

- (UIView *)createBaseViewWithColor:(UIColor *)color name:(NSString *)name
{
    UIView *baseView = [[UIView alloc] init];
    UIView *colorView = [[UIView alloc] init];
    colorView.backgroundColor = color;
    [baseView addSubview: colorView];
    [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(baseView);
        make.left.equalTo(baseView);
        make.size.mas_equalTo(CGSizeMake(12.5 * KFitWidthRate, 6 * KFitWidthRate));
    }];
    UILabel *nameLabel = [MINUtils createLabelWithText: name size:12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: k137Color];
    [baseView addSubview: nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(baseView);
        make.left.equalTo(colorView.mas_right).with.offset(10 * KFitWidthRate);
    }];
    return baseView;
}

@end
