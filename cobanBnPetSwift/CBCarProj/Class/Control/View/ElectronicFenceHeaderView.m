//
//  ElectronicFenceHeaderView.m
//  Telematics
//
//  Created by lym on 2017/12/11.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "ElectronicFenceHeaderView.h"

@implementation ElectronicFenceHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = kBackColor;
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = kRGB(238, 238, 238);
    [self addSubview: backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.5 * KFitWidthRate);
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
        make.top.equalTo(self).with.offset(12.5 * KFitHeightRate);
    }];
    _fenceNameLabel = [self createLabelWithText:Localized(@"围栏名称")];
    _fenceTypeLabel = [self createLabelWithText:Localized(@"围栏类型")];
    _speedLabel = [self createLabelWithText:Localized(@"速度")];
    _alarmTypeLabel = [self createLabelWithText:Localized(@"报警类型")];
    UILabel *lastLabel = nil;
    NSArray *arr = @[self.fenceNameLabel, self.fenceTypeLabel, self.speedLabel, self.alarmTypeLabel];
    for (int i = 0; i < arr.count; i++) {
        UILabel *label = arr[i];
        [backView addSubview: label];
        if (lastLabel == nil) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.top.bottom.equalTo(backView);
                make.width.mas_equalTo(90 * KFitWidthRate);
            }];
        }else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastLabel.mas_right);
                make.top.bottom.equalTo(backView);
                if (i == 1) {
                    make.width.mas_equalTo(65 * KFitWidthRate);
                }else if (i == 2) {
                    make.width.mas_equalTo(65 * KFitWidthRate);
                }else {
                    make.width.mas_equalTo(125 * KFitWidthRate);
                }
            }];
        }
        lastLabel = label;
    }
}

- (UILabel *)createLabelWithText:(NSString *)text
{
    UILabel *label = [MINUtils createLabelWithText: text size:12 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: kRGB(73, 73, 73)];
    return label;
}

@end
