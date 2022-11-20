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
        self.swipeGestures = [NSMutableArray new];
        self.backgroundColor = kCellBackColor;
        UIColor *labelColor = kRGB(137, 137, 137);
        _accountLabel = [MINUtils createLabelWithText: @"5562255" size: 12*KFitHeightRate alignment:NSTextAlignmentCenter textColor:labelColor];
        [self addSubview: _accountLabel];
        [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
//            make.width.mas_equalTo(100 * KFitWidthRate);
//            make.centerX.mas_equalTo(self.mas_centerX).offset(-SCREEN_WIDTH/4);
            make.left.equalTo(@0);
        }];
        _nameLabel = [MINUtils createLabelWithText: @"小11" size: 12*KFitHeightRate alignment:NSTextAlignmentCenter textColor:labelColor];
        [self addSubview: _nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(_accountLabel.mas_right);
//            make.width.mas_equalTo(75 * KFitWidthRate);
            make.width.equalTo(_accountLabel);
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
//            make.centerX.mas_equalTo(self.mas_centerX).offset(SCREEN_WIDTH/4);
            make.left.equalTo(_nameLabel.mas_right);
            make.width.equalTo(_nameLabel);
        }];
        
        UIImage *permissionImage = [UIImage imageNamed: @"右边"];
        _permissionImage = [[UIImageView alloc] initWithImage: permissionImage];
        [self addSubview: _permissionImage];
        [_permissionImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(permissionImage.size.width * KFitHeightRate,  permissionImage.size.height * KFitHeightRate));
        }];
        
//        _editBtn = [MINUtils createNoBorderBtnWithTitle: @"删除" titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: kRGB(252, 30 , 28)];
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
