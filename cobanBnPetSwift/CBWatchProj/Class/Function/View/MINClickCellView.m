//
//  MINClickCellView.m
//  Watch
//
//  Created by lym on 2018/2/8.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "MINClickCellView.h"
//#import "CBWtMINUtils.h"

@implementation MINClickCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
        [self addAction];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.leftImageView.layer.masksToBounds = YES;
    self.leftImageView.layer.cornerRadius = (self.frame.size.height - 10*KFitWidthRate)/2;
    
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFill;
}
- (void)addAction
{
    [self.clickBtn addTarget: self action: @selector(clickBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)clickBtnClick
{
    if (self.clickBtnClickBlock) {
        self.clickBtnClickBlock();
    }
}
- (void)createUI
{
    UIView *topLineView = [CBWtMINUtils createLineView];
    [self addSubview: topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    self.leftImageView = [UIImageView new];//alloc] initWithImage: [UIImage imageNamed: @"景区互动-图3"]];
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview: self.leftImageView];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(self).with.offset(5 * KFitWidthRate);
        make.bottom.equalTo(self).with.offset(-5 * KFitWidthRate);
        make.height.equalTo(self.leftImageView.mas_width);
        
    }];
    self.rightImageView =  [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"arrow-右边"]];
    self.rightImageView.contentMode = UIViewContentModeCenter;
    [self addSubview: self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(20 * KFitWidthRate, 20 * KFitWidthRate));
    }];
    self.leftLabel = [CBWtMINUtils createLabelWithText: @"呢城" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(34, 34, 34)];
    [self addSubview: self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).multipliedBy(1.0 / 2);
    }];
    self.rightLabel = [CBWtMINUtils createLabelWithText: @"呢城" size: 12 * KFitWidthRate alignment: NSTextAlignmentRight textColor: KWt137Color];
    [self addSubview: self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImageView.mas_left).with.offset(-12.5 * KFitWidthRate);
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.leftLabel.mas_right);
    }];
    self.clickBtn = [[UIButton alloc] init];
    [self addSubview: self.clickBtn];
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}
- (void)setLeftImageUrlString:(NSString *)leftImageUrlStirng rightLabelText:(NSString *)text {
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString: leftImageUrlStirng] placeholderImage: [UIImage imageNamed: @"默认宝贝头像"]];
    self.rightLabel.text = text;
    self.leftLabel.hidden = YES;
}
- (void)setLeftLabelText:(NSString *)leftText rightLabelText:(NSString *)rightText {
    self.leftLabel.text = leftText;
    self.rightLabel.text = rightText;
    self.leftImageView.hidden = YES;
}
- (void)addBottomLine {
    UIView *bottomLineView = [CBWtMINUtils createLineView];
    [self addSubview: bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

@end
