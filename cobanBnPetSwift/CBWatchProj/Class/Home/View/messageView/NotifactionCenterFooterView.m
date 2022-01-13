//
//  NotifactionCenterFooterView.m
//  Watch
//
//  Created by lym on 2018/3/7.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "NotifactionCenterFooterView.h"

@implementation NotifactionCenterFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        [self createUI];
        [self addAction];
        self.backgroundColor = KWtBackColor;
    }
    return self;
}

- (void)addAction
{
    [self.checkAllBtn addTarget: self action: @selector(checkAllBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.deleteBtn addTarget: self action: @selector(deleteBtnClick) forControlEvents: UIControlEventTouchUpInside];
}


- (void)deleteBtnClick
{
    if (self.deleteBtnClickBlock) {
        self.deleteBtnClickBlock();
    }
}

- (void)checkAllBtnClick
{
    if (self.checkAllBtnClickBlock) {
        if (self.checkAllBtn.selected == NO) {
            self.checkAllBtn.selected = YES;
            self.checkAllBtnClickBlock(YES);
        }else {
            self.checkAllBtn.selected = NO;
            self.checkAllBtnClickBlock(NO);
        }
    }
}

- (void)createUI
{
    self.checkAllBtn = [[UIButton alloc] init];//WithFrame:CGRectMake(0, 0, 75, 40)];
    self.checkAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.checkAllBtn setTitle:Localized(@"全选") forState: UIControlStateNormal];
    [self.checkAllBtn setTitle:Localized(@"全选") forState: UIControlStateSelected];
    [self.checkAllBtn setImage: [UIImage imageNamed: @"选项-未选中"] forState: UIControlStateNormal];
    [self.checkAllBtn setImage: [UIImage imageNamed: @"选项-选中"] forState: UIControlStateSelected];
    [self.checkAllBtn setImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 12.5 * KFitWidthRate)];
    [self.checkAllBtn setTitleEdgeInsets: UIEdgeInsetsMake(0, 12.5 * KFitWidthRate, 0, 0)];
    self.checkAllBtn.titleLabel.font = [UIFont systemFontOfSize: 12 * KFitWidthRate];
    [self.checkAllBtn setTitleColor: KWt137Color forState: UIControlStateNormal];
    [self.checkAllBtn setTitleColor: KWt137Color forState: UIControlStateSelected];
    [self addSubview: self.checkAllBtn];
    [self.checkAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(125 * KFitWidthRate, 40 * KFitWidthRate));
    }];
    self.deleteBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"删除") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: KWtBlueColor];
    self.deleteBtn.layer.cornerRadius = 20 * KFitWidthRate;
    [self addSubview: self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.bottom.equalTo(self).with.offset(-12.5 * KFitWidthRate - 34);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(150 * KFitWidthRate, 40 * KFitWidthRate));
        make.centerX.equalTo(self);
        make.height.mas_equalTo(40 * KFitWidthRate);
    }];
}

- (void)changeStatus:(BOOL)isEdit
{
    if (isEdit == YES) {
        self.checkAllBtn.hidden = NO;
        self.deleteBtn.hidden = NO;
    }else {
//        self.checkAllBtn.hidden = YES;
//        self.deleteBtn.hidden = YES;
    }
}

@end
