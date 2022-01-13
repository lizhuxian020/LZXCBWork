//
//  TimePeriodView.m
//  Watch
//
//  Created by lym on 2018/2/9.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "TimePeriodView.h"

@implementation TimePeriodView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
        [self addAction];
    }
    return self;
}

- (void)addAction
{
    [self.timeSelectBtn addTarget: self action: @selector(timeSelectBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)timeSelectBtnClick
{
    if (self.timeSelectBtnClickBlock) {
        self.timeSelectBtnClickBlock();
    }
}

- (void)createUI
{
    self.titleLabel = [CBWtMINUtils createLabelWithText: @"上午" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
    [self addSubview: self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.top.bottom.equalTo(self);
        //make.width.mas_equalTo(125 * KFitWidthRate);
    }];
    self.timeLabel = [CBWtMINUtils createLabelWithText: @"上学时间段: 06:30 - 11:30" size: 12 * KFitWidthRate alignment: NSTextAlignmentRight textColor: KWtRGB(137, 137, 137)];
    [self addSubview: self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
        make.top.bottom.equalTo(self);
        //make.width.mas_equalTo(250 * KFitWidthRate);
    }];
    self.timeSelectBtn = [[UIButton alloc] init];
    [self addSubview: self.timeSelectBtn];
    [self.timeSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

- (void)setLeftRGB73WithoutDetailImageTitleLabelText:(NSString *)titleText timeLabelText:(NSString *)timeText
{
    self.titleLabel.text = titleText;
    self.timeLabel.text = timeText;
}

- (void)setLeftRGB73BigFontRightWithoutDetailImageTitleLabelText:(NSString *)titleText timeLabelText:(NSString *)timeText
{
    self.titleLabel.text = titleText;
    self.timeLabel.text = timeText;
    self.timeLabel.font = [UIFont systemFontOfSize: 15 * KFitWidthRate];
}

- (void)setLeftRGB137WithDetailImageTitleLabelText:(NSString *)titleText timeLabelText:(NSString *)timeText
{
    self.titleLabel.text = titleText;
    self.titleLabel.textColor = KWtRGB(137, 137, 137);
    self.timeLabel.text = timeText;
    self.timeLabel.font = [UIFont systemFontOfSize: 15 * KFitWidthRate];
    [CBWtMINUtils addDetailImageViewToView: self];
    [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-35 * KFitWidthRate);
    }];
}

- (void)setLeftRGB73WithDetailImageTitleLabelText:(NSString *)titleText timeLabelText:(NSString *)timeText
{
    self.titleLabel.text = titleText;
    self.timeLabel.text = timeText;
    self.timeLabel.font = [UIFont systemFontOfSize: 15 * KFitWidthRate];
    [CBWtMINUtils addDetailImageViewToView: self];
    [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-35 * KFitWidthRate);
    }];
}

@end
