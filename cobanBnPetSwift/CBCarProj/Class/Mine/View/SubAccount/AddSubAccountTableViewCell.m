//
//  AddSubAccountTableViewCell.m
//  Telematics
//
//  Created by lym on 2017/11/10.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "AddSubAccountTableViewCell.h"
#import "MINLabel.h"

@interface AddSubAccountTableViewCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *nameTF;
@end
@implementation AddSubAccountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kBackColor;
        UIView *backView = [MINUtils createViewWithRadius:5 * KFitHeightRate];
        [self addSubview: backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).with.offset(12.5 * KFitHeightRate);
            make.right.equalTo(self).with.offset(-12.5 * KFitHeightRate);
            make.bottom.equalTo(self);
        }];

        _nameTF = [MINUtils createTextFieldWithHoldText:@"设备管理"];
        _nameTF.font = [UIFont systemFontOfSize:15*KFitHeightRate];
        _nameTF.delegate = self;
        _nameTF.textColor = k137Color;
        [_nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [backView addSubview: _nameTF];
        [_nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView);
            make.left.equalTo(backView).with.offset(12.5 * KFitHeightRate);
            make.right.equalTo(backView).with.offset(-12.5 * KFitHeightRate);
            make.height.mas_equalTo(40*KFitHeightRate);
        }];

    }
    return self;
}
- (void)setAccountModel:(SubAccountAddModel *)accountModel {
    _accountModel = accountModel;
    if (accountModel) {
        _nameTF.placeholder = accountModel.textPlacehold;
        if ([accountModel.textPlacehold isEqualToString:Localized(@"请输入电话号码")]) {
            _nameTF.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
}
- (UILabel *)createLabelWithName:(NSString *)name {
    UIImage *arrowImage = [UIImage imageNamed: @"下拉三角"];
    MINLabel *label = [[MINLabel alloc] init];
    label.text = name;
    label.font = [UIFont systemFontOfSize: 12 * KFitHeightRate];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = k137Color;
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = kRGB(210, 210, 210).CGColor;
    label.layer.cornerRadius = 3 * KFitWidthRate;
    UIImageView *districtImageView = [[UIImageView alloc] initWithImage: arrowImage];
    [label addSubview: districtImageView];
    [districtImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label);
        make.right.equalTo(label).with.offset(-12 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake( arrowImage.size.width,  arrowImage.size.height));
    }];
    return label;
}
- (void)textFieldDidChange:(UITextField *)textField {
    self.accountModel.textStr = textField.text;
}
#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.accountModel.textPlacehold isEqualToString:Localized(@"请输入电话号码")]) {
        return [string isOnlyNumber];
    } else if ([self.accountModel.textPlacehold isEqualToString:Localized(@"请输入子用户名")] && ![string isEqualToString:@""]) {
        return [string isValidAlphaNumberPassword];
    } else if ([self.accountModel.textPlacehold isEqualToString:Localized(@"请输入密码")] && ![string isEqualToString:@""]) {
        return [string isValidAlphaNumberPassword];
    } else if ([self.accountModel.textPlacehold isEqualToString:Localized(@"请再次输入密码")] && ![string isEqualToString:@""]) {
        return [string isValidAlphaNumberPassword];
    }
    return YES;
}
@end
