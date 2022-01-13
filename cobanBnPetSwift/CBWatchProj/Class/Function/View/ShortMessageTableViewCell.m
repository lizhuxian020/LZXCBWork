//
//  ShortMessageTableViewCell.m
//  Watch
//
//  Created by lym on 2018/2/23.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "ShortMessageTableViewCell.h"

@implementation ShortMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        self.backgroundColor = KWtBackColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UIView *mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.layer.borderColor = KWtLineColor.CGColor;
    mainView.layer.borderWidth = 0.5;
    [self.contentView addSubview: mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
        make.bottom.equalTo(self.contentView);
    }];
    self.senderLabel = [CBWtMINUtils createLabelWithText: @"10086" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
    [mainView addSubview: self.senderLabel];
    [self.senderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView).with.offset(12.5 * KFitWidthRate);
        make.height.mas_equalTo(40 * KFitWidthRate);
        make.top.equalTo(mainView);
        make.width.equalTo(mainView).multipliedBy(0.5);
    }];
    self.timeLabel = [CBWtMINUtils createLabelWithText: @"2018/01/05" size: 15 * KFitWidthRate alignment: NSTextAlignmentRight textColor: KWt137Color];
    [mainView addSubview: self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(mainView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(40 * KFitWidthRate);
        make.top.equalTo(mainView);
        make.width.equalTo(mainView).multipliedBy(0.5);
    }];
    self.messageLabel = [CBWtMINUtils createLabelWithText: @"尊敬的客户：您当前账户余额150.99元，其中基本账户余额0.00元。尊敬的客户：您当前账户余额150.99元，其中基本账户余额0.00元。尊敬的客户：您当前账户余额150.99元，其中基本账户余额0.00元。尊敬的客户：您当前账户余额150.99元，其中基本账户余额0.00元。尊敬的客户：您当前账户余额150.99元，其中基本账户余额0.00元。尊敬的客户：您当前账户余额150.99元，其中基本账户余额0.00元。尊敬的客户：您当前账户余额150.99元，其中基本账户余额0.00元。" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWt137Color];
    self.messageLabel.numberOfLines = 0;
    [mainView addSubview: self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(mainView).with.offset(-12.5 * KFitWidthRate);
        make.bottom.equalTo(mainView).with.offset(-30 * KFitWidthRate);
        make.left.equalTo(mainView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(self.senderLabel.mas_bottom);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.isEditing == YES) {
        [super setSelected:selected animated: animated];
        if (self.isSelected == YES) {
            UIControl *control = [self.subviews lastObject];
            UIImageView * imgView = [[control subviews] objectAtIndex:0];
            imgView.image = [UIImage imageNamed:@"选项-选中"];
        }else {
            UIControl *control = [self.subviews lastObject];
            UIImageView * imgView = [[control subviews] objectAtIndex:0];
            imgView.image = [UIImage imageNamed:@"选项-未选中"];
        }
    }
}

@end
