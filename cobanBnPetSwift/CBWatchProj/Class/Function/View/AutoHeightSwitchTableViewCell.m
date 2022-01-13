//
//  AutoHeightSwitchTableViewCell.m
//  Watch
//
//  Created by lym on 2018/2/8.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "AutoHeightSwitchTableViewCell.h"

@implementation AutoHeightSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        [self createUI];
        self.backgroundColor = KWtBackColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createUI
{
    self.topLabel = [CBWtMINUtils createLabelWithText: @"免受陌生人打扰，安全放心" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor:[UIColor blackColor]];//KWtRGB(73, 73, 73)
    self.topLabel.font = [UIFont fontWithName:CBPingFang_SC_Bold size:15];
    self.topLabel.numberOfLines = 0;
    [self.contentView addSubview: self.topLabel];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
    }];
    self.bottomLabel = [CBWtMINUtils createLabelWithText: @"随时查看宝贝当前佩戴状态" size: 12 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWt137Color];
    self.bottomLabel.font = [UIFont fontWithName:CBPingFang_SC size:13];
    self.bottomLabel.numberOfLines = 0;
    [self.contentView addSubview: self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLabel.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
        make.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
        make.bottom.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
    }];
}

- (void)setTopLabelText:(NSString *)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing: 7 * KFitWidthRate];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.topLabel.attributedText = attributedString;
}

@end
