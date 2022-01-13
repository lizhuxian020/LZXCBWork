//
//  NewElectronicFenceView.m
//  Telematics
//
//  Created by lym on 2017/12/11.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "NewElectronicFenceView.h"

@implementation NewElectronicFenceView

- (instancetype)init
{
    if (self = [super init]) {
        [self createUI];
        [self addAction];
    }
    return self;
}

- (void)addAction
{
    [self.alramTypeBtn addTarget: self action: @selector(alarmTypeBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)alarmTypeBtnClick
{
    if (self.alramTypeBtnClickBlock) {
        self.alramTypeBtnClickBlock();
    }
}


- (void)createUI
{
    _fenceNameTextField = [MINUtils createBorderTextFieldWithHoldText:Localized(@"输入围栏名称") fontSize: 12 * KFitHeightRate];
    [self addSubview: _fenceNameTextField];
    [_fenceNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).with.offset(12.5 * KFitHeightRate);
        make.right.equalTo(self).with.offset(-12.5 * KFitHeightRate);
        make.height.mas_equalTo(30 * KFitHeightRate);
    }];
    _speedTextField = [MINUtils createBorderTextFieldWithHoldText:Localized(@"限速") fontSize: 12 * KFitHeightRate];
    [self addSubview: _speedTextField];
    [_speedTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fenceNameTextField.mas_bottom).with.offset(20 * KFitHeightRate);
        make.left.equalTo(self).with.offset(12.5 * KFitHeightRate);
        make.right.equalTo(self).with.offset(-12.5 * KFitHeightRate);
        make.height.mas_equalTo(30 * KFitHeightRate);
    }];
    _alramLabel = [MINUtils createLabelWithText:Localized(@"报警类型") size: 12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(73, 73, 73)];
    [self addSubview: _alramLabel];
    [_alramLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_speedTextField.mas_bottom).with.offset(20 * KFitHeightRate);
        make.left.equalTo(self).with.offset(12.5 * KFitHeightRate);
        make.right.mas_equalTo(70 * KFitWidthRate);
        make.height.mas_equalTo(30 * KFitHeightRate);
    }];
    _alramTypeBtn = [MINUtils createBorderBtnWithArrowImageWithTitle:Localized(@"出围栏报警")];
    [self addSubview: _alramTypeBtn];
    [_alramTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_speedTextField.mas_bottom).with.offset(20 * KFitHeightRate);
        make.width.mas_equalTo(170 * KFitWidthRate);
        make.right.equalTo(self).with.offset(-12.5 * KFitHeightRate);
        make.height.mas_equalTo(30 * KFitHeightRate);
    }];
}

@end
