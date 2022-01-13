//
//  AlamSettingView.m
//  Telematics
//
//  Created by lym on 2017/11/13.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "AlamSettingView.h"
#import "MINSwitchView.h"
@interface AlamSettingView()
{
    UIButton *detailImageBtn;
}
@end

@implementation AlamSettingView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = kCellBackColor;
        self.layer.cornerRadius = 3 * KFitWidthRate;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOpacity = 0.3;
        _nameLabel = [MINUtils createLabelWithText: @"接收新消息" size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kCellTextColor];
        [self addSubview: _nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
            make.width.mas_equalTo(240 * KFitWidthRate);
            make.bottom.equalTo(self.mas_top).with.offset(50 * KFitHeightRate);
        }];
        _alramSwitch = [[MINSwitchView alloc] initWithOnImage:[UIImage imageNamed: @"开关-开"] offImage:[UIImage imageNamed: @"开关-关"] switchImage:[UIImage imageNamed: @"开关-按钮"]];
        [self addSubview: _alramSwitch];
        [_alramSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_top).with.offset(25 * KFitWidthRate);
            make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
            make.size.mas_equalTo(CGSizeMake(70 * KFitWidthRate, 27 * KFitHeightRate));
        }];
        detailImageBtn = [[UIButton alloc] init];
        [detailImageBtn setImage: [UIImage imageNamed: @"detail"] forState: UIControlStateNormal];
        [detailImageBtn setImage: [UIImage imageNamed: @"detail"] forState: UIControlStateHighlighted];
        [self addSubview: detailImageBtn];
        [detailImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(-12.5 * KFitHeightRate);
            make.size.mas_equalTo(CGSizeMake(16 * KFitHeightRate, 16 * KFitHeightRate));
        }];
        detailImageBtn.hidden = YES;
        _detailBtn = [[UIButton alloc] init];
        [self addSubview: _detailBtn];
        [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        _detailBtn.hidden = YES;
    }
    return self;
}

- (void)changeViewType
{
    _alramSwitch.hidden = YES;
    _detailBtn.hidden = NO;
    detailImageBtn.hidden = NO;
}

@end
