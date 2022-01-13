//
//  AlarmTypeTableViewCell.m
//  Telematics
//
//  Created by lym on 2017/11/13.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "AlarmTypeTableViewCell.h"
@interface AlarmTypeTableViewCell()

@end
@implementation AlarmTypeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kBackColor;
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = kCellBackColor;
        [self addSubview: _backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5 * KFitHeightRate);
            make.right.equalTo(self).with.offset(-12.5 * KFitHeightRate);
            make.top.bottom.equalTo(self);//.with.offset(-2.5 * KFitHeightRate);
        }];
        _nameLabel = [MINUtils createLabelWithText: @"设备管理"];
        [_backView addSubview: _nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView);
            make.left.equalTo(_backView).with.offset(12.5 * KFitHeightRate);
            make.size.mas_equalTo(CGSizeMake(200 * KFitWidthRate, 20 * KFitHeightRate));
        }];
        _selectImageBtn = [[UIButton alloc] init];
        [_selectImageBtn setImage: [UIImage imageNamed: @""] forState: UIControlStateNormal];
        [_selectImageBtn setImage: [UIImage imageNamed: @"选择"] forState: UIControlStateSelected];
        [_backView addSubview: _selectImageBtn];
        [_selectImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView);
            make.right.equalTo(_backView).with.offset(-12.5 * KFitHeightRate);
            make.size.mas_equalTo(CGSizeMake(15 * KFitHeightRate, 15 * KFitHeightRate));
        }];
    }
    return self;
}

- (void)addLineView
{
    UIView *lineView = [MINUtils createLineView];
    [_backView addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(_backView).with.offset(-12.5 * KFitWidthRate);
        make.bottom.equalTo(_backView).with.offset(-0.5);
        make.height.mas_offset(0.5);
    }];
}

@end
