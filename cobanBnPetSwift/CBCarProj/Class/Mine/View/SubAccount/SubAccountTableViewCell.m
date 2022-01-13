//
//  SubAccountTableViewCell.m
//  Telematics
//
//  Created by lym on 2017/11/10.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "SubAccountTableViewCell.h"

@implementation SubAccountTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kCellBackColor;
        UIColor *labelColor = kRGB(137, 137, 137);
        _accountLabel = [MINUtils createLabelWithText: @"5562255" size: 12*KFitHeightRate alignment:NSTextAlignmentCenter textColor:labelColor];
        [self addSubview: _accountLabel];
        [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(100 * KFitWidthRate);
            make.centerX.mas_equalTo(self.mas_centerX).offset(-SCREEN_WIDTH/4);
        }];
        _nameLabel = [MINUtils createLabelWithText: @"小11" size: 12*KFitHeightRate alignment:NSTextAlignmentCenter textColor:labelColor];
        [self addSubview: _nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(_accountLabel.mas_right);
            make.width.mas_equalTo(75 * KFitWidthRate);
        }];
//        _passLabel = [MINUtils createLabelWithText: @"小11" size: 12*KFitHeightRate alignment:NSTextAlignmentCenter textColor:labelColor];
//        _passLabel.numberOfLines = 0;
//        [self addSubview: _passLabel];
//        [_passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(self);
//            make.left.equalTo(_nameLabel.mas_right);
//            make.width.mas_equalTo(114 * KFitWidthRate);
//        }];
        
        _permissionLab = [MINUtils createLabelWithText: @"小11" size: 12*KFitHeightRate alignment:NSTextAlignmentCenter textColor:labelColor];
        _permissionLab.numberOfLines = 0;
        [self addSubview: _permissionLab];
        [_permissionLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(self);
//            //make.left.equalTo(_nameLabel.mas_right);
//            make.width.mas_equalTo(114 * KFitWidthRate);
            make.top.right.bottom.equalTo(self);
            //make.left.equalTo(passLabel.mas_right);
            make.centerX.mas_equalTo(self.mas_centerX).offset(SCREEN_WIDTH/4);
        }];
        
        UIImage *permissionImage = [UIImage imageNamed: @"右边"];
        _permissionImage = [[UIImageView alloc] initWithImage: permissionImage];
        [self addSubview: _permissionImage];
        [_permissionImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(permissionImage.size.width * KFitHeightRate,  permissionImage.size.height * KFitHeightRate));
        }];
        _deleteBtn = [MINUtils createNoBorderBtnWithTitle: @"删除" titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: kRGB(252, 30 , 28)];
        [_deleteBtn addTarget: self action: @selector(deviceDeleteBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: _deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.mas_right);
            make.width.mas_equalTo(80 * KFitWidthRate);
        }];
        _deleteBtn.hidden = YES;
    }
    return self;
}

- (void)setAccountName:(NSString *)account name:(NSString *)name pass:(NSString *)pass
{
    self.accountLabel.text = account;
    self.nameLabel.text = name;
    self.passLabel.text = pass;
}

- (void)showDeleteBtn
{
    if (self.deleteBtn != nil) {
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration: 0.3 animations:^{
            [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.deleteBtn.superview.mas_right).with.offset(-80 * KFitWidthRate);
            }];
            self.deleteBtn.hidden = NO;
            [self.superview layoutIfNeeded];
        }];
        self.isEdit = YES;
    }
}

- (void)hideDeleteBtn
{
    if (self.deleteBtn != nil) {
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration: 0.3 animations:^{
            [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.deleteBtn.superview.mas_right);
            }];
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.deleteBtn.hidden = YES;
        }];
        self.isEdit = NO;
    }
}

- (void)addLeftSwipeGesture
{
    UISwipeGestureRecognizer *leftSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(leftSwipeGR:)];
    [leftSwipeGR setDirection: UISwipeGestureRecognizerDirectionLeft];
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
    [self showDeleteBtn];
}

- (void)deviceDeleteBtnClick
{
    if (self.deleteBtnClick) {
        self.deleteBtnClick( self.indexPath);
    }
}
@end
