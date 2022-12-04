//
//  FormDateHeaderView.m
//  Telematics
//
//  Created by lym on 2017/11/17.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "FormDateHeaderView.h"

@interface FormDateHeaderView()
{
    UIView *backView;
}
@end

@implementation FormDateHeaderView
- (instancetype)init
{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = kGreyColor;
    backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
//    backView.layer.cornerRadius = 5 * KFitHeightRate;
    [self addSubview: backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitHeightRate);
        make.right.equalTo(self).with.offset(-12.5 * KFitHeightRate);
        make.centerY.equalTo(@0);
    }];
    
//    CGFloat cornerRadius = 5.f * KFitHeightRate;
//    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//    CGMutablePathRef pathRef = CGPathCreateMutable();
//    CGRect bounds = CGRectMake(0, 0, SCREEN_HEIGHT - 12.5 * KFitWidthRate - 12.5 * KFitWidthRate, 50 * KFitHeightRate);
//    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds) - 1, CGRectGetMinY(bounds), CGRectGetMaxX(bounds) -1, CGRectGetMidY(bounds), cornerRadius);
//    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds) - 1, CGRectGetMaxY(bounds));
//    CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//    layer.path = pathRef;
//    CFRelease(pathRef);
//    [backView.layer insertSublayer: layer atIndex: 0];
//    layer.strokeColor = kRGB(210, 210, 210).CGColor;
//    layer.fillColor = kRGB(244, 244, 244).CGColor;
    
    _leftLabel = [MINUtils createLabelWithText: @"编号" size: 15 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: kRGB(33, 33, 33)];
    [backView addSubview: _leftLabel];
    //_leftLabel.backgroundColor = [UIColor redColor];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(backView).with.offset(12.5 * KFitWidthRate);
        make.left.equalTo(backView);
        make.top.bottom.equalTo(backView);
        make.width.mas_equalTo(70 * KFitWidthRate);
    }];
    _middleLabel = [MINUtils createLabelWithText: @"时间" size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(33, 33, 33)];
    [backView addSubview: _middleLabel];
    [_middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(_leftLabel.mas_right);
        make.left.equalTo(_leftLabel.mas_right).with.offset(35 * KFitWidthRate);
        make.top.bottom.equalTo(backView);
        make.width.mas_equalTo(155 * KFitWidthRate);
    }];
    _rightLabel = [MINUtils createLabelWithText: @"速度" size: 15 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: kRGB(33, 33, 33)];
    [backView addSubview: _rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_middleLabel.mas_right).with.offset(10 * KFitWidthRate);
        make.top.bottom.equalTo(backView);
        make.width.mas_equalTo(125 * KFitWidthRate);
    }];
    UIView *lineView = [MINUtils createLineView];
    [self addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.height.mas_equalTo(0.5);
        make.left.right.equalTo(@0);
    }];
}

@end
