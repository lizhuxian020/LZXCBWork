//
//  AddressBookHeaderView.m
//  Watch
//
//  Created by lym on 2018/2/7.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "AddressBookHeaderView.h"

@implementation AddressBookHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.headImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"姐姐"]];
        self.headImageView.layer.cornerRadius = 25 * KFitWidthRate;
        self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.headImageView.layer.borderColor = KWtLineColor.CGColor;
        self.headImageView.layer.borderWidth = 0.5;
        self.headImageView.layer.masksToBounds = YES;
        [self addSubview: self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
            make.size.mas_equalTo(CGSizeMake(50 * KFitWidthRate, 50 * KFitWidthRate));
        }];
        UIView *infoView = [[UIView alloc] init];
        [self addSubview: infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImageView.mas_right).with.offset(12.5 * KFitWidthRate);
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(-35 * KFitWidthRate);
            make.height.mas_equalTo(50 * KFitWidthRate);
        }];
        self.nameLabel = [CBWtMINUtils createLabelWithText: @"哥哥" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
        [infoView addSubview: self.nameLabel];
        [self.nameLabel setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(infoView);
            make.height.equalTo(infoView).dividedBy(2);
            make.width.mas_greaterThanOrEqualTo(30 * KFitWidthRate);
        }];
        self.phoneLabel = [CBWtMINUtils createLabelWithText: @"138 8888 8888" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWt137Color];
        [infoView addSubview: self.phoneLabel];
        [self.phoneLabel setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(infoView);
            make.height.equalTo(infoView).dividedBy(2);
            make.width.mas_greaterThanOrEqualTo(140 * KFitWidthRate);
        }];
        self.editBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"编辑") titleColor: KWt137Color fontSize: 15 * KFitWidthRate backgroundColor: nil];
        self.editBtn.layer.cornerRadius = 15 * KFitWidthRate;
        self.editBtn.layer.borderColor = KWtLineColor.CGColor;
        self.editBtn.layer.borderWidth = 0.5;
        [self addSubview: self.editBtn];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
            make.size.mas_equalTo(CGSizeMake(55 * KFitWidthRate, 30 * KFitWidthRate));
        }];
        [self.editBtn addTarget: self action: @selector(editBtnClick) forControlEvents: UIControlEventTouchUpInside];
    }
    return self;
}

- (void)editBtnClick
{
    if (self.editBtnClickBlock) {
        self.editBtnClickBlock();
    }
}

@end
