//
//  ForbiddenInClassTableViewCell.m
//  Watch
//
//  Created by lym on 2018/2/11.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "ForbiddenInClassTableViewCell.h"
#import "SwitchView.h"
#import "MINSwitchView.h"

@interface ForbiddenInClassTableViewCell() <MINSwtichViewDelegate>

@end

@implementation ForbiddenInClassTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        [self createUI];
        [self addAction];
    }
    return self;
}

- (void)addAction
{
    [self.editBtn addTarget: self action: @selector(editBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)editBtnClick
{
    if (self.editBtnClickBlock) {
        self.editBtnClickBlock();
    }
}


- (void)createUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = KWtRGB(237, 237, 237);
    UIView *mainView = [[UIView alloc] init];
    mainView.layer.cornerRadius = 5 * KFitWidthRate;
    mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview: mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
        make.bottom.equalTo(self);
    }];
    self.switchView = [[SwitchView alloc] init];
    self.switchView.titleLabel.text = @"禁用时间段一";
    self.switchView.statusLabel.hidden = YES;
    self.switchView.switchView.delegate = self;
    [mainView addSubview: self.switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(mainView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    [CBWtMINUtils addLineToView: self.switchView isTop: NO hasSpaceToSide: YES];
    self.timePeriodLabel = [CBWtMINUtils createLabelWithText: @"早上 09:00-11:30 下午 14:00-16:30" size: 12 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWt137Color];
    [mainView addSubview: self.timePeriodLabel];
    [self.timePeriodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(self.switchView.mas_bottom).with.offset(20 * KFitWidthRate);
        make.height.mas_equalTo(15 * KFitWidthRate);
        make.right.equalTo(mainView).with.offset(-80 * KFitWidthRate);
    }];
    self.repeatLabel = [CBWtMINUtils createLabelWithText: @"重复: 周一到周五" size: 12 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
    [mainView addSubview: self.repeatLabel];
    [self.repeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(self.timePeriodLabel.mas_bottom).with.offset(10 * KFitWidthRate);
        make.height.mas_equalTo(15 * KFitWidthRate);
        make.right.equalTo(mainView).with.offset(-80 * KFitWidthRate);
    }];
    self.editBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"编辑") titleColor: KWt137Color fontSize: 15 * KFitWidthRate backgroundColor: nil];
    self.editBtn.layer.borderColor = KWtLineColor.CGColor;
    self.editBtn.layer.borderWidth = 0.5;
    self.editBtn.layer.cornerRadius = 15 * KFitWidthRate;
    [self addSubview: self.editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(mainView).with.offset(-12.5 * KFitWidthRate);
        make.top.equalTo(self.switchView.mas_bottom).with.offset(23 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(60 * KFitWidthRate, 30 * KFitWidthRate));
    }];
}

#pragma mark - MINSwtichViewDelegate
- (void)switchView:(MINSwitchView *)switchView stateChange:(BOOL)isON
{
    if (self.switchStatusChange) {
        self.switchStatusChange(isON);
    }
}

@end
