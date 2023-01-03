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
//    [self.deleteBtn addTarget: self action: @selector(deleteBtnClick) forControlEvents: UIControlEventTouchUpInside];
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
//    backView.layer.shadowColor = [UIColor grayColor].CGColor;
//    backView.layer.shadowRadius = 5 * KFitWidthRate;
//    backView.layer.shadowOpacity = 0.3;
//    backView.layer.shadowOffset  = CGSizeMake(0, 3);// 阴影的范围
    backView.userInteractionEnabled = YES;
    [self addSubview: backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.bottom.equalTo(self).with.offset(0 * KFitHeightRate);
        
    }];
    _nameTextFeild = [MINUtils createTextFieldWithHoldText: @"姓名" fontSize: 14];
    _nameTextFeild.delegate = self;
    _nameTextFeild.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backView addSubview: _nameTextFeild];
    [_nameTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).with.offset(0 * KFitWidthRate);
        make.centerY.equalTo(backView);
        make.width.equalTo(backView).multipliedBy(0.3);
        make.height.equalTo(@(30 * KFitHeightRate));
    }];
    _phoneTextFeild = [MINUtils createTextFieldWithHoldText: @"电话号码" fontSize: 14];
    _phoneTextFeild.delegate = self;
    _phoneTextFeild.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backView addSubview: _phoneTextFeild];
    [_phoneTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameTextFeild.mas_right).with.offset(0 * KFitWidthRate);
        make.centerY.equalTo(backView);
        make.width.equalTo(backView).multipliedBy(0.3);
        make.height.equalTo(@(30 * KFitHeightRate));
    }];
//    _deleteBtn = [[UIButton alloc] init];
//    [_deleteBtn setImage: [UIImage imageNamed: @"删-除"] forState: UIControlStateNormal];
//    [_deleteBtn setImage: [UIImage imageNamed: @"删-除"] forState: UIControlStateHighlighted];
//    [backView addSubview: _deleteBtn];
//    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.right.equalTo(backView);
//        make.width.mas_equalTo(35 * KFitWidthRate);
//    }];
    _phoneTypeBtn = [self createBtn];
    //        _phoneTypeBtn.layer.borderColor = kRGB(210, 210, 210).CGColor;
    //        _phoneTypeBtn.layer.borderWidth = 0.5;
    //        _phoneTypeBtn.layer.cornerRadius = 5 * KFitWidthRate;
    [self addSubview: _phoneTypeBtn];
    [_phoneTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_phoneTextFeild.mas_right).with.offset(0 * KFitWidthRate);
        make.centerY.equalTo(backView);
        make.width.equalTo(backView).multipliedBy(0.4);
        make.height.equalTo(@(30 * KFitHeightRate));
    }];
    _phoneTypeTitleLabel = [MINUtils createLabelWithText: @"恢复原厂设置号码" size: 14 alignment: NSTextAlignmentLeft textColor: kCellTextColor];
    [_phoneTypeBtn addSubview: _phoneTypeTitleLabel];
    [_phoneTypeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_phoneTypeBtn).with.offset(0 * KFitWidthRate);
        make.top.bottom.equalTo(_phoneTypeBtn);
        make.right.equalTo(_phoneTypeBtn).with.offset(0 * KFitWidthRate);
    }];
   
    _nameTextFeild.enabled = NO;
    _phoneTextFeild.enabled = NO;
    _phoneTypeBtn.enabled = NO;
    
    _editBtn = [MINUtils createBtnWithNormalImage:[UIImage imageNamed:@"编辑"] selectedImage:[UIImage imageNamed:@"编辑"]];
    _editBtn.backgroundColor = UIColor.orangeColor;
    [_editBtn addTarget: self action: @selector(deviceEditBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: _editBtn];
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_right);
        make.width.mas_equalTo(80 * KFitWidthRate);
    }];
    _editBtn.hidden = YES;
    
    _deleteBtn = [MINUtils createBtnWithNormalImage:[UIImage imageNamed:@"删除"] selectedImage:[UIImage imageNamed:@"删除"]];
    _deleteBtn.backgroundColor = UIColor.orangeColor;
    [_deleteBtn addTarget: self action: @selector(deviceDeleteBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: _deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.editBtn.mas_right);
        make.width.mas_equalTo(80 * KFitWidthRate);
    }];
    _deleteBtn.hidden = YES;
}

- (UIButton *)createBtn
{
//    UIImage *arrowImage = [UIImage imageNamed: @"下拉三角"];
    UIButton *button = [[UIButton alloc] init];
//    [button setTitle: name forState: UIControlStateNormal];
//    [button setTitle: name forState: UIControlStateHighlighted];
//    button.titleLabel.font = [UIFont systemFontOfSize: 12 * KFitHeightRate];
//    [button setTitleColor: k137Color forState: UIControlStateNormal];
//    [button setTitleColor: k137Color  forState: UIControlStateHighlighted];
//    button.layer.borderWidth = 0.5;
//    button.layer.borderColor = kRGB(210, 210, 210).CGColor;
//    button.layer.cornerRadius = 3 * KFitWidthRate;
//    UIImageView *districtImageView = [[UIImageView alloc] initWithImage: arrowImage];
//    [button addSubview: districtImageView];
//    [districtImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(button);
//        make.right.equalTo(button).with.offset(-12 * KFitWidthRate);
//        make.size.mas_equalTo(CGSizeMake( arrowImage.size.width,  arrowImage.size.height));
//    }];
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


- (void)showDeleteBtn
{
    [self sendSubviewToBack:self.contentView];
    if (self.deleteBtn != nil) {
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration: 0.3 animations:^{
            [self.editBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.editBtn.superview.mas_right).with.offset(-80 * 2 * KFitWidthRate);
            }];
            self.deleteBtn.hidden = NO;
            self.editBtn.hidden = NO;
            [self.superview layoutIfNeeded];
        }];
        self.isEdit = YES;
    }
}

- (void)hideDeleteBtn
{
    [self sendSubviewToBack:self.contentView];
    if (self.deleteBtn != nil) {
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration: 0.3 animations:^{
            [self.editBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.editBtn.superview.mas_right);
            }];
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.deleteBtn.hidden = YES;
            self.editBtn.hidden = YES;
        }];
        self.isEdit = NO;
    }
}

- (void)addLeftSwipeGesture
{
    UISwipeGestureRecognizer *leftSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(leftSwipeGR:)];
    [leftSwipeGR setDirection: UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight];
    [self.swipeGestures addObject:leftSwipeGR];
    [self addGestureRecognizer: leftSwipeGR];
}
- (void)addRightSwipeGesture
{
    UISwipeGestureRecognizer *rightSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(rightSwipeGR:)];
    [rightSwipeGR setDirection: UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer: rightSwipeGR];
}
- (void)rightSwipeGR:(UISwipeGestureRecognizer *)lsGR
{
    [self hideDeleteBtn];
}

- (void)leftSwipeGR:(UISwipeGestureRecognizer *)lsGR
{
    if (self.isEdit) {
        [self hideDeleteBtn];
    } else {
        [self showDeleteBtn];
    }
}

- (void)deviceDeleteBtnClick
{
    if (self.deleteBtnClick) {
        self.deleteBtnClick( self.indexPath);
    }
}

- (void)deviceEditBtnClick
{
    if (self.editBtnClick) {
        self.editBtnClick(self.indexPath);
    }
}
@end
