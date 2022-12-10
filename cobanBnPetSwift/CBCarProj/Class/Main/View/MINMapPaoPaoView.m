//
//  MINMapPaoPaoView.m
//  Telematics
//
//  Created by lym on 2017/12/7.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MINMapPaoPaoView.h"

@interface MINMapPaoPaoView ()
@property (nonatomic,strong) UIButton *wholeBtn;
@end

@implementation MINMapPaoPaoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        int width = frame.size.width;
        int height = frame.size.height;
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.image = [UIImage imageNamed:@"话框"];
        [self addSubview: _imageView];

        _backView = [[UIView alloc] init];
        [self addSubview: _backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];

        
        _titleLabel = [MINUtils createLabelWithText:@"XXX设备名称" size:10 alignment: NSTextAlignmentLeft textColor: kCellTextColor];
        [_backView addSubview: _titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.equalTo(@0);
        }];
        
        [self layoutIfNeeded];

//        _speedAndStayLabel = [MINUtils createLabelWithText:@"速度: 20 / 停留 1 分钟" size: 10 * KFitWidthRate * 4 alignment: NSTextAlignmentLeft textColor: [UIColor blackColor]];
//        _speedAndStayLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom + 5 * KFitWidthRate * 4, _titleLabel.width, _titleLabel.height);
//        [_backView addSubview: _speedAndStayLabel];
        
//        _wholeBtn = [[UIButton alloc]initWithFrame:CGRectMake(22*KFitWidthRate, 18* KFitWidthRate, width - 22*KFitWidthRate*2, height - 18*KFitWidthRate*2 - 35*KFitWidthRate)];
//        _wholeBtn.backgroundColor = UIColor.orangeColor;
//        [self addSubview:_wholeBtn];
//        [_wholeBtn addTarget:self action:@selector(wholeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return  self;
}
- (void)wholeBtnClick {
    if (self.clickBlock) {
        self.clickBlock();
    }
}
- (instancetype)initWithNormalFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {

        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.image = [UIImage imageNamed:@"话框"];
        [self addSubview: _imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self);
        }];

        _backView = [[UIView alloc] init];
        [self addSubview: _backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(3*KFitWidthRate);
            make.left.equalTo(self).with.offset(5* KFitWidthRate);
            make.right.equalTo(self).with.offset(-5 * KFitWidthRate);
            make.height.mas_equalTo(38 * KFitHeightRate);
        }];
        _titleLabel = [MINUtils createLabelWithText:@"XXX设备名称" size: 10 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: kBlueColor];
        [_backView addSubview: _titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backView).with.offset(5 * KFitWidthRate);
            make.left.equalTo(_backView).with.offset(10 * KFitWidthRate);
            make.right.equalTo(_backView).with.offset(-10 * KFitWidthRate);
            make.height.mas_equalTo(11 * KFitWidthRate);
        }];
        _speedAndStayLabel = [MINUtils createLabelWithText:@"速度: 20 / 停留 1 分钟" size: 10 * KFitWidthRate  alignment: NSTextAlignmentLeft textColor: [UIColor blackColor]];
        [_backView addSubview: _speedAndStayLabel];
        [_speedAndStayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).with.offset(5 * KFitWidthRate);
            make.left.equalTo(_backView).with.offset(10 * KFitWidthRate);
            make.right.equalTo(_backView).with.offset(-10 * KFitWidthRate);
            make.height.mas_equalTo(11 * KFitWidthRate);
        }];

    }
    return  self;
}

- (void)setAlertStyle
{
    self.titleLabel.textColor = [UIColor whiteColor];
    self.speedAndStayLabel.textColor = [UIColor whiteColor];
//    self.backView.backgroundColor = kRGB(255, 21, 1);
    self.imageView.image = [UIImage imageNamed: @"画框-报警"];
}

- (void)setSpeed:(CGFloat)speed stayTime:(CGFloat)stayTime
{
    self.speedAndStayLabel.text = [NSString stringWithFormat: @"速度: %f / 停留 %f 分钟", speed, stayTime];
}

@end
