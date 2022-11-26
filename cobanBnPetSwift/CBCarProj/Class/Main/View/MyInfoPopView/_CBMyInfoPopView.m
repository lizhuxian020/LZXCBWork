//
//  _CBMyInfoPopView.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/26.
//  Copyright © 2022 coban. All rights reserved.
//

#import "_CBMyInfoPopView.h"
#import "cobanBnPetSwift-Swift.h"

@interface _CBMyInfoPopView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIImageView *arrowView;

@property (nonatomic, strong) UILabel *phoneLbl;


@end

@implementation _CBMyInfoPopView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.frame = UIScreen.mainScreen.bounds;
    self.backgroundColor = [UIColor colorWithDisplayP3Red:0 green:0 blue:0 alpha:0];
    kWeakSelf(self);
    [self bk_whenTapped:^{
        [weakself dismiss];
    }];
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
    }];
    self.contentView.alpha = 0;
    
    UIButton *closeBtn = [MINUtils createBtnWithNormalImage:[UIImage imageNamed:@"报表-选中"] selectedImage:[UIImage imageNamed:@""]];
    [self.contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.width.height.equalTo(@20);
    }];
    
    CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
    
    UIImageView *arrowV = [UIImageView new];
    [arrowV sd_setImageWithURL:[NSURL URLWithString:userModel.photo ?: @""] placeholderImage:[UIImage imageNamed:@"摩托车-定位-正常"]];
    [self.contentView addSubview:arrowV];
    [arrowV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.centerX.equalTo(@0);
        make.width.height.equalTo(@150);
    }];
    arrowV.layer.cornerRadius = 150/2;
    [arrowV.layer setMasksToBounds:YES];
    [arrowV clipsToBounds];
    
    UILabel *phoneLbl = [MINUtils createLabelWithText:userModel.phone ?: userModel.email ?: @"" size:14 alignment:NSTextAlignmentCenter textColor:UIColor.blackColor];
    [self.contentView addSubview:phoneLbl];
    [phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(arrowV.mas_bottom).mas_offset(10);
        make.centerX.equalTo(@0);
    }];
    
    UIView *infoV = [self viewWithImg:@"报表-选中" title:Localized(@"个人信息")];
    UIView *aboutV = [self viewWithImg:@"报表-选中" title:Localized(@"关于我们")];
    UIView *pwdV = [self viewWithImg:@"报表-选中" title:Localized(@"修改密码")];
    [self.contentView addSubview:infoV];
    [self.contentView addSubview:aboutV];
    [self.contentView addSubview:pwdV];
    [infoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(phoneLbl.mas_bottom);
    }];
    [aboutV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(infoV.mas_bottom);
    }];
    [pwdV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(aboutV.mas_bottom);
    }];
    
    UIButton *logoutBtn = [MINUtils createBtnWithRadius:20 title:Localized(@"退出登录")];
    logoutBtn.backgroundColor = UIColor.whiteColor;
    logoutBtn.layer.borderColor = [kAppMainColor CGColor];
    logoutBtn.layer.borderWidth = 1;
    [logoutBtn setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [self.contentView addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.equalTo(@30);
        make.right.equalTo(@-30);
        make.bottom.equalTo(@-20);
        make.top.equalTo(pwdV.mas_bottom).mas_offset(20);
    }];
    
    self.contentView.layer.cornerRadius = 10;
    
    
    [closeBtn bk_whenTapped:^{
        [weakself dismiss];
    }];
    
    [infoV bk_whenTapped:^{
        [weakself dismiss];
        weakself.didClickPersonInfo();
    }];
    [aboutV bk_whenTapped:^{
        [weakself dismiss];
        weakself.didClickAbout();
    }];
    [pwdV bk_whenTapped:^{
        [weakself dismiss];
        weakself.didClickPwd();
    }];
    [logoutBtn bk_whenTapped:^{
        [weakself dismiss];
        weakself.didClickLogout();
    }];
    
    [self layoutIfNeeded];
}


- (UIView *)viewWithImg:(NSString *)imgName title:(NSString *)title {
    UIView *c = [UIView new];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    [c addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.width.height.equalTo(@30);
        make.bottom.equalTo(@-10);
    }];
    UILabel *lbl = [MINUtils createLabelWithText:title size:14 alignment:NSTextAlignmentCenter textColor:UIColor.blackColor];
    [c addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgV);
        make.left.equalTo(imgV.mas_right).mas_offset(5);
    }];
    
    UIImageView *arrowV =[ UIImageView new];
    arrowV.image = [UIImage imageNamed:@"detail"];
    [c addSubview:arrowV];
    [arrowV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@15);
        make.centerY.equalTo(@0);
        make.right.equalTo(@-10);
    }];
    return c;
}

- (void)pop {
    NSLog(@"%s", __FUNCTION__);
    
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(PPNavigationBarHeight+20));
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.alpha = 1;
        self.backgroundColor = [UIColor colorWithDisplayP3Red:0 green:0 blue:0 alpha:0.3];
        [self layoutIfNeeded];
    }];
}

- (void)dismiss {
    NSLog(@"%s", __FUNCTION__);
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.alpha = 0;
        self.backgroundColor = [UIColor colorWithDisplayP3Red:0 green:0 blue:0 alpha:0];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end
