//
//  MINLoginPartView.m
//  Telematics
//
//  Created by lym on 2017/10/26.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MINLoginPartView.h"

@implementation MINLoginPartView
+ (instancetype)loginPartViewWithImageName:(NSString *)name holdText:(NSString *)holdText rightBtnTitle:(NSString *)title
{
    return [[self alloc] initWithImageName: name holdText: holdText rightBtnTitle: title];
}

- (instancetype)initWithImageName:(NSString *)name holdText:(NSString *)holdText rightBtnTitle:(NSString *)title
{
    if (self = [super init]) {
        self.backgroundColor = kCellBackColor;
        self.layer.borderColor = kRGB(218, 218, 218).CGColor;
        self.layer.borderWidth = 1 * KFitHeightRate;
        if (name != nil && ![name isEqualToString: @""]) {
            UIImage *image = [UIImage imageNamed: name];
            _imageView = [[UIImageView alloc] initWithImage: image];
            [self addSubview: _imageView];
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).with.offset(15 * KFitWidthRate);
                make.size.mas_equalTo(CGSizeMake(image.size.width * KFitWidthRate, image.size.height * KFitHeightRate));
            }];
        }
        if (holdText != nil && ![holdText isEqualToString: @""]) {
            _textField = [[UITextField alloc] init];
            NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString: holdText];
            [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, holdText.length)];
            [placeholder addAttribute:NSForegroundColorAttributeName value:kTextFieldColor range:NSMakeRange(0, holdText.length)];
            _textField.attributedPlaceholder = placeholder;
            _textField.textColor = kTextFieldColor;
            _textField.font = [UIFont systemFontOfSize: 12 * KFitHeightRate];
            _textField.textAlignment = NSTextAlignmentLeft;
            [self addSubview: _textField];
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).with.offset(55 * KFitWidthRate);
                make.size.mas_equalTo(CGSizeMake(250 * KFitWidthRate, 30 * KFitHeightRate));
            }];
        }
        if (title != nil && ![title isEqualToString: @""]) {
            _rightBtn = [[UIButton alloc] init];
            [_rightBtn setTitle: title forState: UIControlStateNormal];
            [_rightBtn setTitle: title forState: UIControlStateHighlighted];
            [_rightBtn setTitleColor: kLoginPartColor forState: UIControlStateNormal];
            [_rightBtn setTitleColor: kLoginPartColor forState: UIControlStateHighlighted];
            _rightBtn.titleLabel.font = [UIFont systemFontOfSize: 12 * KFitHeightRate];
            [_rightBtn addTarget: self action: @selector(rightButtonClick) forControlEvents: UIControlEventTouchUpInside];
            [self addSubview: _rightBtn];
            [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-15 * KFitWidthRate);
                make.top.bottom.equalTo(self);
                make.width.mas_equalTo(120 * KFitWidthRate);
            }];
        }
    }
    return self;
}

- (void)rightButtonClick
{
    if (self.rightBtnClick != nil) {
        self.rightBtnClick();
    }
}

@end
