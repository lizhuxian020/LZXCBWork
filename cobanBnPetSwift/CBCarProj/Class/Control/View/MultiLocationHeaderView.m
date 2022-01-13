//
//  MultiLocationHeaderView.m
//  Telematics
//
//  Created by lym on 2017/11/27.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MultiLocationHeaderView.h"

@interface MultiLocationHeaderView()

@end

@implementation MultiLocationHeaderView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowRadius = 5 * KFitWidthRate;
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowOffset  = CGSizeMake(0, 3);// 阴影的范围
        [self createUI];
        [self addAction];
    }
    return self;
}

- (void)setSelectBtn:(int)type
{
    self.timingImageBtn.selected = NO;
    self.distanceImageBtn.selected = NO;
    self.timingAndDistanceImageBtn.selected = NO;
    if (type == 0) {
        self.timingImageBtn.selected = YES;
    }else if (type == 1) {
        self.distanceImageBtn.selected = YES;
    }else {
        self.timingAndDistanceImageBtn.selected = YES;
    }
}

- (NSNumber *)getSelectBtn
{
    if (self.timingImageBtn.selected == YES) {
        return @0;
    }else if (self.distanceImageBtn.selected == YES) {
        return @1;
    }else {
        return @2;
    }
}

- (void)addAction
{
    [_timingImageBtn addTarget: self action: @selector(selectBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [_distanceImageBtn addTarget: self action: @selector(selectBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [_timingAndDistanceImageBtn addTarget: self action: @selector(selectBtnClick:) forControlEvents: UIControlEventTouchUpInside];
}

- (void)selectBtnClick:(UIButton *)button
{
    if (button == self.timingImageBtn) {
        if (_timingImageBtn.selected == NO) {
            if (self.timingBtnClickBlock) {
                self.timingBtnClickBlock();
            }
        }
        _timingImageBtn.selected = YES;
        _distanceImageBtn.selected = NO;
        _timingAndDistanceImageBtn.selected = NO;
        
    }else if (button == self.distanceImageBtn) {
        if (_distanceImageBtn.selected == NO) {
            if (self.distanceBtnClickBlock) {
                self.distanceBtnClickBlock();
            }
        }
        _timingImageBtn.selected = NO;
        _distanceImageBtn.selected = YES;
        _timingAndDistanceImageBtn.selected = NO;
        
    }else {
        if (_timingAndDistanceImageBtn.selected == NO) {
            if (self.timingAndDistanceBtnClickBlock) {
                self.timingAndDistanceBtnClickBlock();
            }
        }
        _timingImageBtn.selected = NO;
        _distanceImageBtn.selected = NO;
        _timingAndDistanceImageBtn.selected = YES;
    }
    
}

- (void)createUI
{
    _titleLabel = [MINUtils createLabelWithText:Localized(@"位置汇报策略") size: 15 * KFitHeightRate  alignment: NSTextAlignmentLeft textColor: kRGB(73, 73, 73)];
    [self addSubview: _titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(self);
        make.width.mas_equalTo(250 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    UIView *lineView = [MINUtils createLineView];
    [self addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(- 0.5);
        make.height.mas_equalTo(0.5);
    }];
    UIImage *selectImage = [UIImage imageNamed:@"单选-选中"];
    _timingImageBtn = [[UIButton alloc] init];
    [_timingImageBtn setImage: [UIImage imageNamed:@"单选-没选中"] forState: UIControlStateNormal];
    [_timingImageBtn setImage: [UIImage imageNamed: @"单选-选中"] forState: UIControlStateSelected];
    [_timingImageBtn setTitle:Localized(@"定时汇报") forState:UIControlStateNormal];
    [_timingImageBtn setTitleColor:k137Color forState:UIControlStateNormal];
    _timingImageBtn.titleLabel.font = [UIFont systemFontOfSize:12*KFitHeightRate];
    _timingImageBtn.selected = YES;
    _timingImageBtn.adjustsImageWhenHighlighted = NO;
    _timingImageBtn.adjustsImageWhenDisabled = NO;
    [self addSubview: _timingImageBtn];
    CGFloat width_time = [NSString getWidthWithText:Localized(@"定时汇报") font:[UIFont systemFontOfSize:12*KFitHeightRate] height:selectImage.size.height * KFitHeightRate];
    [_timingImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.centerY.equalTo(self.mas_bottom).with.offset(- 25 * KFitHeightRate);
        make.size.mas_equalTo(CGSizeMake(selectImage.size.height * KFitHeightRate + width_time + 10, selectImage.size.height * KFitHeightRate));
    }];
    [_timingImageBtn horizontalCenterImageAndTitle];

    _distanceImageBtn = [[UIButton alloc] init];
    [_distanceImageBtn setImage: [UIImage imageNamed:@"单选-没选中"] forState: UIControlStateNormal];
    [_distanceImageBtn setImage: [UIImage imageNamed: @"单选-选中"] forState: UIControlStateSelected];
    [_distanceImageBtn setTitle:Localized(@"定距汇报") forState:UIControlStateNormal];
    [_distanceImageBtn setTitleColor:k137Color forState:UIControlStateNormal];
    _distanceImageBtn.titleLabel.font = [UIFont systemFontOfSize:12*KFitHeightRate];
    _distanceImageBtn.adjustsImageWhenHighlighted = NO;
    _distanceImageBtn.adjustsImageWhenDisabled = NO;
    [self addSubview: _distanceImageBtn];
    CGFloat width_distance = [NSString getWidthWithText:Localized(@"定距汇报") font:[UIFont systemFontOfSize:12*KFitHeightRate] height:selectImage.size.height * KFitHeightRate];
    [_distanceImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timingImageBtn.mas_right).with.offset(12.5 * KFitWidthRate);
        make.centerY.equalTo(self.mas_bottom).with.offset(- 25 * KFitHeightRate);
        make.size.mas_equalTo(CGSizeMake(selectImage.size.height * KFitHeightRate + width_distance + 10, selectImage.size.height * KFitHeightRate));
    }];
    [_distanceImageBtn horizontalCenterImageAndTitle];

    _timingAndDistanceImageBtn = [[UIButton alloc] init];
    [_timingAndDistanceImageBtn setImage: [UIImage imageNamed:@"单选-没选中"] forState: UIControlStateNormal];
    [_timingAndDistanceImageBtn setImage: [UIImage imageNamed: @"单选-选中"] forState: UIControlStateSelected];
    [_timingAndDistanceImageBtn setTitle:Localized(@"定时和定距汇报") forState:UIControlStateNormal];
    [_timingAndDistanceImageBtn setTitleColor:k137Color forState:UIControlStateNormal];
    _timingAndDistanceImageBtn.titleLabel.font = [UIFont systemFontOfSize:12*KFitHeightRate];
    _timingAndDistanceImageBtn.adjustsImageWhenHighlighted = NO;
    _timingAndDistanceImageBtn.adjustsImageWhenDisabled = NO;
    [self addSubview: _timingAndDistanceImageBtn];
    CGFloat width_time_distance = [NSString getWidthWithText:Localized(@"定时和定距汇报") font:[UIFont systemFontOfSize:12*KFitHeightRate] height:selectImage.size.height * KFitHeightRate];
    [_timingAndDistanceImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_distanceImageBtn.mas_right).with.offset(12.5 * KFitWidthRate);
        make.centerY.equalTo(self.mas_bottom).with.offset(- 25 * KFitHeightRate);
        make.size.mas_equalTo(CGSizeMake(selectImage.size.height * KFitHeightRate + width_time_distance + 10, selectImage.size.height * KFitHeightRate));
    }];
    [_timingAndDistanceImageBtn horizontalCenterImageAndTitle];
}

@end
