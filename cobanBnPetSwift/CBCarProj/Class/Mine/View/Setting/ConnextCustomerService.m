//
//  ConnextCustomerService.m
//  Telematics
//
//  Created by lym on 2017/11/14.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "ConnextCustomerService.h"

@implementation ConnextCustomerService

- (instancetype)init
{
    if (self = [super init]) {
        [self createUI];
        [self createAction];
    }
    return self;
}

- (void)createAction
{
    [self.numberBtn addTarget: self action: @selector(callBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.cancelBtn addTarget: self action: @selector(cancelBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)cancelBtnClick
{
    [self removeFromSuperview];
}
- (void)callBtnClick {
    // 拨打电话
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.numberBtn.titleLabel.text?:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (void)createUI
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.3];
    [self addSubview: backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = kCellBackColor;
    [backView addSubview: _contentView];
    _contentView.layer.cornerRadius = 5 * KFitHeightRate;
    _contentView.layer.masksToBounds = YES;
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).with.offset(60 * KFitWidthRate);
        make.right.equalTo(backView).with.offset(-60 * KFitWidthRate);
        make.bottom.equalTo(backView).with.offset(-50 * KFitHeightRate);
        make.height.mas_equalTo(120 * KFitHeightRate);
    }];
    _titleLabel = [MINUtils createLabelWithText:Localized(@"呼叫") size: 15 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: kRGB(34, 34, 34)];
    [_contentView addSubview: _titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(_contentView);
        make.height.mas_equalTo(40 * KFitHeightRate);
        make.width.equalTo(_contentView);
    }];
    UIView *firstTopLineView = [MINUtils createLineView];
    [_contentView addSubview: firstTopLineView];
    [firstTopLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.equalTo(_contentView);
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(- 0.5);
    }];
    _numberBtn = [MINUtils createNoBorderBtnWithTitle: @"13822225555" titleColor: kRGB(34, 34, 34) fontSize:15 * KFitHeightRate];
    [_contentView addSubview: _numberBtn];
    [_numberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.right.equalTo(_contentView);
        make.height.mas_equalTo(40 * KFitHeightRate);
    }];
    UIView *middleLineView = [MINUtils createLineView];
    [_contentView addSubview: middleLineView];
    [middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.equalTo(_contentView);
        make.top.equalTo(_numberBtn.mas_bottom).with.offset(- 0.5);
    }];
    _cancelBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"取消") titleColor: kRGB(34, 34, 34) fontSize:15 * KFitHeightRate];
    [_contentView addSubview: _cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_numberBtn.mas_bottom);
        make.left.right.equalTo(_contentView);
        make.height.mas_equalTo(40 * KFitHeightRate);
    }];
}

@end
