//
//  PhoneBookTableViewCell.m
//  Telematics
//
//  Created by lym on 2017/11/30.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "PhoneBookTableViewCell.h"

@interface PhoneBookTableViewCell() <UITextFieldDelegate>

@end

@implementation PhoneBookTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kBackColor;
        [self createUI];
        [self addAction];
    }
    return self;
}

- (void)addAction
{
    //[self.phoneTypeBtn addTarget: self action: @selector(phoneTypeBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.deleteBtn addTarget: self action: @selector(deleteBtnClick) forControlEvents: UIControlEventTouchUpInside];
    //[self.phoneTextFeild addTarget: self action: @selector(phoneTextFeildEdit:) forControlEvents: UIControlEventEditingChanged];
    //[self.nameTextFeild addTarget: self action: @selector(nameTextFeildEdit:) forControlEvents: UIControlEventEditingChanged];
}

- (void)phoneTextFeildEdit:(UITextField *)textField
{
    if (self.phoneTextFieldEidtBlock) {
        self.phoneTextFieldEidtBlock( self.indexPath,  textField.text);
    }
}

- (void)nameTextFeildEdit:(UITextField *)textField
{
    if (self.nameTextFieldEidtBlock) {
        self.nameTextFieldEidtBlock( self.indexPath,  textField.text);
    }
}

- (void)deleteBtnClick
{
    if (self.deleteBtnClickBlock) {
        self.deleteBtnClickBlock(self.indexPath);
    }
}

- (void)phoneTypeBtnClick
{
    if (self.phoneTypeBtnClickBlock) {
        self.phoneTypeBtnClickBlock(self.indexPath);
    }
}

- (void)createUI
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.shadowColor = [UIColor grayColor].CGColor;
    backView.layer.shadowRadius = 5 * KFitWidthRate;
    backView.layer.shadowOpacity = 0.3;
    backView.layer.shadowOffset  = CGSizeMake(0, 3);// 阴影的范围
    backView.userInteractionEnabled = YES;
    [self addSubview: backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).with.offset(12.5 * KFitHeightRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    _nameTextFeild = [MINUtils createBorderTextFieldWithHoldText: @"姓名" fontSize: 12 * KFitWidthRate];
    _nameTextFeild.delegate = self;
    _nameTextFeild.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backView addSubview: _nameTextFeild];
    [_nameTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).with.offset(12.5 * KFitWidthRate);
        make.centerY.equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(65 * KFitWidthRate, 30 * KFitHeightRate));
    }];
    _phoneTextFeild = [MINUtils createBorderTextFieldWithHoldText: @"电话号码" fontSize: 12 * KFitWidthRate];
    _phoneTextFeild.delegate = self;
    _phoneTextFeild.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backView addSubview: _phoneTextFeild];
    [_phoneTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameTextFeild.mas_right).with.offset(12.5 * KFitWidthRate);
        make.centerY.equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(100 * KFitWidthRate, 30 * KFitHeightRate));
    }];
    _deleteBtn = [[UIButton alloc] init];
    [_deleteBtn setImage: [UIImage imageNamed: @"删-除"] forState: UIControlStateNormal];
    [_deleteBtn setImage: [UIImage imageNamed: @"删-除"] forState: UIControlStateHighlighted];
    [backView addSubview: _deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(backView);
        make.width.mas_equalTo(35 * KFitWidthRate);
    }];
    _phoneTypeBtn = [self createBtn];
    //        _phoneTypeBtn.layer.borderColor = kRGB(210, 210, 210).CGColor;
    //        _phoneTypeBtn.layer.borderWidth = 0.5;
    //        _phoneTypeBtn.layer.cornerRadius = 5 * KFitWidthRate;
    [self addSubview: _phoneTypeBtn];
    [_phoneTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_phoneTextFeild.mas_right).with.offset(12.5 * KFitWidthRate);
        make.centerY.equalTo(backView);
        make.height.mas_equalTo(30 * KFitHeightRate);
        make.right.equalTo(_deleteBtn.mas_left).with.offset(-2.5 * KFitWidthRate);
    }];
    _phoneTypeTitleLabel = [MINUtils createLabelWithText: @"恢复原厂设置号码" size: 12 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: k137Color];
    [_phoneTypeBtn addSubview: _phoneTypeTitleLabel];
    [_phoneTypeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_phoneTypeBtn).with.offset(12.5 * KFitWidthRate);
        make.top.bottom.equalTo(_phoneTypeBtn);
        make.right.equalTo(_phoneTypeBtn).with.offset(-30 * KFitWidthRate);
    }];
   
    _nameTextFeild.enabled = NO;
    _phoneTextFeild.enabled = NO;
    _phoneTypeBtn.enabled = NO;
}

- (UIButton *)createBtn
{
    UIImage *arrowImage = [UIImage imageNamed: @"下拉三角"];
    UIButton *button = [[UIButton alloc] init];
//    [button setTitle: name forState: UIControlStateNormal];
//    [button setTitle: name forState: UIControlStateHighlighted];
//    button.titleLabel.font = [UIFont systemFontOfSize: 12 * KFitHeightRate];
//    [button setTitleColor: k137Color forState: UIControlStateNormal];
//    [button setTitleColor: k137Color  forState: UIControlStateHighlighted];
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = kRGB(210, 210, 210).CGColor;
    button.layer.cornerRadius = 3 * KFitWidthRate;
    UIImageView *districtImageView = [[UIImageView alloc] initWithImage: arrowImage];
    [button addSubview: districtImageView];
    [districtImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(button);
        make.right.equalTo(button).with.offset(-12 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake( arrowImage.size.width,  arrowImage.size.height));
    }];
    return button;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.cellDelegate && [self.cellDelegate respondsToSelector: @selector(shouldEditCellWithIndexPath:)]) {
       BOOL canEdit = [self.cellDelegate shouldEditCellWithIndexPath: self.indexPath];
        
        return canEdit;
    }
    return YES;
}

@end
