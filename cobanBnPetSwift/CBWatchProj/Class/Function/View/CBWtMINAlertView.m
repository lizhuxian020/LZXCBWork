//
//  CBWtMINAlertView.m
//  Telematics
//
//  Created by lym on 2017/11/2.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "CBWtMINAlertView.h"

@interface CBWtMINAlertView()
{
    UIView *alertView;
    UIView *backView;
    CGFloat contentViewHeight;
}
@property (nonatomic, strong) UIButton *rightCloseBtn;
@end

@implementation CBWtMINAlertView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
        [self addAction];
    }
    return self;
}

- (void)hideView
{
    [self removeFromSuperview];
}

#pragma mark - addAction
- (void)addAction
{
    [self.leftBottomBtn addTarget: self action: @selector(leftBottomBtnClick) forControlEvents: UIControlEventTouchUpInside];
//    [self.rightBottomBtn addTarget: self action: @selector(rightBottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)leftBottomBtnClick
{
    if (self.leftBtnClick) {
        self.leftBtnClick();
    }
}

//- (void)rightBottomBtnClick
//{
//    if (self.rightBtnClick) {
//        self.rightBtnClick();
//    }
//}

#pragma mark - createUI
- (void)createUI
{
    [self createBackViewAndAlertView];
    [self createTitleView];
    
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)createTitleView
{
    _titleLabel = [CBWtMINUtils createLabelWithText: @"标题" size: 18 * KFitWidthRate alignment: NSTextAlignmentCenter textColor:KWtRGB(51, 51, 51)];
    [alertView addSubview: _titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(alertView);
        make.height.mas_equalTo(45 * KFitHeightRate);
        make.left.right.equalTo(alertView);
    }];
    _contentView = [[UIView alloc] init];
    [alertView addSubview: _contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(5 * KFitHeightRate);
        make.left.right.equalTo(alertView);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    _leftBottomBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"确定") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: KWtBlueColor];
    _leftBottomBtn.layer.cornerRadius = 20 * KFitWidthRate;
    [alertView addSubview: _leftBottomBtn];
    [_leftBottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(alertView).with.offset(-12.5 * KFitWidthRate);
        make.bottom.equalTo(alertView).with.offset(-25 * KFitWidthRate);
        make.height.mas_equalTo(40 * KFitWidthRate);
    }];
//    _rightBottomBtn = [CBWtMINUtils createNoBorderBtnWithTitle: @"确定" titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: KWtBlueColor];
//    [alertView addSubview: _rightBottomBtn];
//    [_rightBottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.bottom.equalTo(alertView);
//        make.height.mas_equalTo(45 * KFitHeightRate);
//        make.left.equalTo(_leftBottomBtn.mas_right);
//    }];
}

- (void)showRightCloseBtn
{
    if (_rightCloseBtn == nil) {
        UIImage *closeImage = [UIImage imageNamed:@"关闭-登录"];
        UIImageView *closeImageView = [[UIImageView alloc] initWithImage:closeImage];
        [alertView addSubview: closeImageView];
        [closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertView).with.offset(18 * KFitHeightRate);
            make.right.equalTo(alertView).with.offset(-20 * KFitHeightRate);
            make.size.mas_equalTo(CGSizeMake(closeImage.size.width, closeImage.size.height));
        }];
        _rightCloseBtn = [[UIButton alloc] init];
        [self addSubview: _rightCloseBtn];
        [_rightCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(alertView);
            make.height.width.mas_equalTo(45 * KFitHeightRate);
        }];
        [_rightCloseBtn addTarget:self action: @selector(hideView) forControlEvents: UIControlEventTouchUpInside];
    }
}

- (void)setContentViewHeight:(CGFloat)height
{
    contentViewHeight = height - 50;
    [alertView.superview layoutIfNeeded];
    [alertView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo((115 + height) * KFitHeightRate);
    }];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height * KFitHeightRate);
    }];
    [alertView.superview layoutIfNeeded];
}

- (void)createBackViewAndAlertView
{
    backView = [[UIView alloc] init];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.3];
    [self addSubview: backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    alertView = [[UIView alloc] init];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 10 * KFitWidthRate;
    alertView.layer.masksToBounds = YES;
    [backView addSubview: alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(backView);
        make.width.mas_offset(280 * KFitWidthRate);
        make.height.mas_equalTo(165 * KFitHeightRate);
    }];
}
#pragma mark 键盘出现
- (void)keyboardWillShow:(NSNotification*)note {
    
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 不让键盘上移
    //self.tableView.contentInset = UIEdgeInsetsZero;
    //self.tableView.contentInset = UIEdgeInsetsMake(0,0, keyBoardRect.size.height,0);
    [alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.bottom.mas_equalTo(-keyBoardRect.size.height-10);
        //make.centerY.equalTo(backView);
        make.width.mas_offset(280 * KFitWidthRate);
        make.height.mas_equalTo((150 + contentViewHeight) * KFitHeightRate);
    }];
}
#pragma mark 键盘消失
- (void)keyboardWillHide:(NSNotification*)note {
    
    //self.tableView.contentInset = UIEdgeInsetsZero;
    [alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.centerY.equalTo(backView);
        make.width.mas_offset(280 * KFitWidthRate);
        make.height.mas_equalTo((150 + contentViewHeight)* KFitHeightRate);
    }];
}
@end
