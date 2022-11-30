//
//  _CBLocateModeView.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/30.
//  Copyright © 2022 coban. All rights reserved.
//

#import "_CBLocateModeView.h"

@interface _CBLocateModeView ()

@property (nonatomic, strong) UILabel *modeLbl;

@property (nonatomic, strong) UIView *contentAView;
@property (nonatomic, strong) UIView *contentBView;

@end

@implementation _CBLocateModeView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    UILabel *titleLbl = [MINUtils createLabelWithText:Localized(@"定位策略") size:14];
    [self addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0);
    }];
    
    UIImageView *arrV = [UIImageView new];
    arrV.image = [UIImage imageNamed:@"右边"];
    [self addSubview:arrV];
    [arrV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLbl);
        make.right.equalTo(@0);
    }];
    
    self.modeLbl = [MINUtils createLabelWithText:Localized(@"定时汇报") size:14];
    [self addSubview:self.modeLbl];
    [self.modeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrV.mas_left).mas_offset(-10);
        make.centerY.equalTo(arrV);
    }];
    
    [self setupAView];
    [self addSubview:self.contentAView];
    [self.contentAView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLbl.mas_bottom).mas_offset(10);
        make.left.equalTo(titleLbl);
        make.right.equalTo(arrV);
        make.bottom.equalTo(@-10);
    }];
    
    [self setupBView];
    [self addSubview:self.contentBView];
    [self.contentBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentAView);
    }];
    self.contentBView.hidden = YES;
    
    [self addClick];
}

- (void)setupAView {
    UIView *view = [UIView new];
    UILabel *lblA = [MINUtils createLabelWithText:Localized(@"静止时的时间间隔") size:14];
    [view addSubview:lblA];
    [lblA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@10);
    }];
    
    UISwitch *s = [UISwitch new];
    [view addSubview:s];
    [s mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lblA);
        make.right.equalTo(@0);
    }];
    
    UIView *cView = [UIView new];
    
    UIImageView *cImgV = [UIImageView new];
    cImgV.image = [UIImage imageNamed:@"下拉三角"];
    [cView addSubview:cImgV];
    [cImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.right.equalTo(@-5);
        make.width.height.equalTo(@15);
    }];
    
    UILabel *cLbl = [MINUtils createLabelWithText:@"10s" size:14];
    cLbl.textAlignment = NSTextAlignmentCenter;
    [cView addSubview:cLbl];
    [cLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(cImgV.mas_left);
    }];
    
    [view addSubview:cView];
    [cView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblA.mas_right);
        make.right.equalTo(s.mas_left);
        make.centerY.equalTo(lblA);
    }];
    cView.layer.borderWidth = 1;
    
    UILabel *lblB = [MINUtils createLabelWithText:Localized(@"运动时的时间间隔") size:14];
    [view addSubview:lblB];
    [lblB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblA.mas_bottom).mas_offset(40);
        make.left.equalTo(@10);
        make.bottom.equalTo(@-40);
    }];
    
    
    UISwitch *sb = [UISwitch new];
    [view addSubview:sb];
    [sb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lblB);
        make.right.equalTo(@0);
    }];
    
    UIView *cBView = [UIView new];
    
    UIImageView *cBImgV = [UIImageView new];
    cBImgV.image = [UIImage imageNamed:@"下拉三角"];
    [cBView addSubview:cBImgV];
    [cBImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.right.equalTo(@-5);
        make.width.height.equalTo(@15);
    }];
    
    UILabel *cBLbl = [MINUtils createLabelWithText:@"10s" size:14];
    cBLbl.textAlignment = NSTextAlignmentCenter;
    [cBView addSubview:cBLbl];
    [cBLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(cBImgV.mas_left);
    }];
    
    [view addSubview:cBView];
    [cBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblB.mas_right);
        make.right.equalTo(sb.mas_left);
        make.centerY.equalTo(lblB);
    }];
    cBView.layer.borderWidth = 1;
    
    self.contentAView = view;
}

- (void)setupBView {
    UIView *view = [UIView new];
    UILabel *lblA = [MINUtils createLabelWithText:Localized(@"静止时的时间间隔") size:14];
    [view addSubview:lblA];
    [lblA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@10);
    }];
    
    
    UISwitch *s = [UISwitch new];
    [view addSubview:s];
    [s mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lblA);
        make.right.equalTo(@0);
    }];
    
    UIView *cView = [UIView new];
    
    UIImageView *cImgV = [UIImageView new];
    cImgV.image = [UIImage imageNamed:@"下拉三角"];
    [cView addSubview:cImgV];
    [cImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.right.equalTo(@-5);
        make.width.height.equalTo(@15);
    }];
    
    UILabel *cLbl = [MINUtils createLabelWithText:@"10s" size:14];
    cLbl.textAlignment = NSTextAlignmentCenter;
    [cView addSubview:cLbl];
    [cLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(cImgV.mas_left);
    }];
    
    [view addSubview:cView];
    [cView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblA.mas_right);
        make.right.equalTo(s.mas_left);
        make.centerY.equalTo(lblA);
    }];
    cView.layer.borderWidth = 1;
    
    UILabel *lblB = [MINUtils createLabelWithText:Localized(@"运动时的距离间隔") size:14];
    [view addSubview:lblB];
    [lblB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblA.mas_bottom).mas_offset(40);
        make.left.equalTo(@10);
        make.bottom.equalTo(@-40);
    }];
    
    
    UISwitch *sb = [UISwitch new];
    [view addSubview:sb];
    [sb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lblB);
        make.right.equalTo(@0);
    }];
    
    UILabel *uniLbl = [MINUtils createLabelWithText:Localized(@"米") size:14];
    uniLbl.textAlignment = NSTextAlignmentCenter;
    [view addSubview:uniLbl];
    [uniLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sb);
        make.right.equalTo(sb.mas_left);
        make.width.equalTo(@20);
    }];
    
    UIView *cBView = [UIView new];
    
    UIImageView *cBImgV = [UIImageView new];
    cBImgV.image = [UIImage imageNamed:@"下拉三角"];
    [cBView addSubview:cBImgV];
    [cBImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.right.equalTo(@-5);
        make.width.height.equalTo(@15);
    }];
    
    UILabel *cBLbl = [MINUtils createLabelWithText:@"10s" size:14];
    cBLbl.textAlignment = NSTextAlignmentCenter;
    [cBView addSubview:cBLbl];
    [cBLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(cBImgV.mas_left);
    }];
    
    [view addSubview:cBView];
    [cBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblB.mas_right);
        make.right.equalTo(uniLbl.mas_left);
        make.centerY.equalTo(lblB);
    }];
    cBView.layer.borderWidth = 1;
    
    self.contentBView = view;
}

- (void)addClick {
    self.modeLbl.userInteractionEnabled = YES;
    kWeakSelf(self);
    [self.modeLbl bk_whenTapped:^{
        [weakself showChooseModel];
    }];
}

- (void)showChooseModel {
    kWeakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:Localized(@"定时汇报") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakself.contentAView.hidden = NO;
        weakself.contentBView.hidden = YES;
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:Localized(@"定时和定距汇报") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        weakself.contentAView.hidden = YES;
        weakself.contentBView.hidden = NO;
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
