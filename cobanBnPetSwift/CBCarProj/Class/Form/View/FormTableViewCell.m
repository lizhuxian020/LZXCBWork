//
//  FormTableViewCell.m
//  Telematics
//
//  Created by lym on 2017/11/15.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "FormTableViewCell.h"
@interface FormTableViewCell()
{
    UIImageView *rightBtnImageView;
}
@end

@implementation FormTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = kRGB(236, 236, 236);
        self.backgroundColor = kBackColor;
        _backView = [[UIView alloc] init];
//        _backView.backgroundColor = kCellBackColor;
        [self.contentView addSubview: _backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(@(12.5 * KFitHeightRate));
            make.right.equalTo(@(-12.5 * KFitHeightRate));
        }];
        _imgView = [UIImageView new];
        _imgView.image = [UIImage imageNamed:@"选项-选中"];
        [_backView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@15);
            make.left.equalTo(@(12.5 * KFitHeightRate));
            make.centerY.equalTo(@0);
        }];
        _nameLabel = [MINUtils createLabelWithText:@"日里程耗油报表" size:12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: k137Color];
        [_backView addSubview: _nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_backView).with.offset(-15 * KFitWidthRate);
            make.top.bottom.equalTo(_backView);
            make.left.equalTo(_imgView.mas_right).with.offset(15 * KFitWidthRate);
        }];
        UIImage *rightImage = [UIImage imageNamed:@"左边-三角"];
        rightBtnImageView = [[UIImageView alloc] initWithImage: rightImage];
        [_backView addSubview: rightBtnImageView];
        [rightBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView);
            make.right.equalTo(_backView).with.offset(-10 * KFitWidthRate);
            make.height.mas_equalTo(rightImage.size.height * KFitHeightRate);
            make.width.mas_equalTo(rightImage.size.width * KFitHeightRate);
        }];
        
    }
    return self;
}

//- (void)addTopLineView
//{
//    UIView *lineView = [MINUtils createLineView];
//    [_backView addSubview: lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_backView);
//        make.height.mas_equalTo(0.5);
//        make.left.right.equalTo(_backView);
//    }];
//}

- (void)addBottomLineView
{
    UIView *lineView = [MINUtils createLineView];
    [_backView addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_backView).with.offset(-0.5);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(_backView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(_backView).with.offset(-12.5 * KFitWidthRate);
    }];
}

- (void)hideRightImage
{
    rightBtnImageView.hidden = YES;
}

@end
