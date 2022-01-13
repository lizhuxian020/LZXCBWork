//
//  ElectornicFenceTableViewCell.m
//  Telematics
//
//  Created by lym on 2017/12/11.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "ElectornicFenceTableViewCell.h"

@implementation ElectornicFenceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = UIColor.whiteColor;
    _fenceNameLabel = [self createLabelWithText: @"超级围栏A"];
    //_fenceNameLabel.textAlignment = NSTextAlignmentLeft;
    //_fenceNameLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview: _fenceNameLabel];
    [_fenceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(90 * KFitWidthRate);
    }];
    UIImage *image = [UIImage imageNamed: @"多边形-1"];
    _fenceTypeImageBtn = [[UIButton alloc] init];
    [_fenceTypeImageBtn setImage: image forState: UIControlStateNormal];
    _fenceTypeImageBtn.enabled = NO;
    [self.contentView addSubview: _fenceTypeImageBtn];
    [_fenceTypeImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fenceNameLabel.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(65 * KFitWidthRate);
    }];
    _speedLabel = [self createLabelWithText: @"100KM/h"];
    [self.contentView addSubview: _speedLabel];
    [_speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fenceTypeImageBtn.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(65 * KFitWidthRate);
    }];
    _alarmTypeLabel = [self createLabelWithText: @"入围栏报警"];
    [self.contentView addSubview: _alarmTypeLabel];
    [_alarmTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_speedLabel.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(125 * KFitWidthRate);
    }];
    UIImage *detailImage = [UIImage imageNamed: @"右边"];
    UIImageView *detailImageView = [[UIImageView alloc] initWithImage: detailImage];
    [self.contentView addSubview: detailImageView];
    [detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(detailImage.size.width * KFitHeightRate, detailImage.size.height * KFitHeightRate));
    }];
}

- (UILabel *)createLabelWithText:(NSString *)text
{
    UILabel *label = [MINUtils createLabelWithText: text size:12 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: k137Color];
    return label;
}

- (void)addBottomLineView
{
    UIView *lineView = [MINUtils createLineView];
    [self addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).with.offset(-0.5);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
    }];
}

@end
