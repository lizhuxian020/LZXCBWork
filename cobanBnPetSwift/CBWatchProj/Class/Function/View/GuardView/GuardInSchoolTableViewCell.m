//
//  GuardInSchoolTableViewCell.m
//  Watch
//
//  Created by lym on 2018/2/9.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "GuardInSchoolTableViewCell.h"

@implementation GuardInSchoolTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        [self createUI];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createUI
{
    self.topLabel = [CBWtMINUtils createLabelWithText: @"上学时间" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
    self.topLabel.numberOfLines = 0;
    [self.contentView addSubview: self.topLabel];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(self.contentView).with.offset(16 * KFitWidthRate);
        make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
    }];
    self.bottomLabel = [CBWtMINUtils createLabelWithText: @"早上 08:00 - 11:30 下午 14:00 - 16:30" size: 12 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWt137Color];
    self.bottomLabel.numberOfLines = 0;
    [self.contentView addSubview: self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLabel.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
        make.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
        make.bottom.equalTo(self.contentView).with.offset(-16 * KFitWidthRate);
    }];
    [CBWtMINUtils addDetailImageViewToView: self];
}

- (void)setBottomLabelText:(NSString *)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing: 7 * KFitWidthRate];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.topLabel.attributedText = attributedString;
}

@end
