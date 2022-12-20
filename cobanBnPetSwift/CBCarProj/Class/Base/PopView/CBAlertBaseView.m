//
//  CBAlertBaseView.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/23.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBAlertBaseView.h"

@interface CBAlertBaseView ()

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *cancelLbl;

@property (nonatomic, strong) UILabel *confirmLbl;

@end

@implementation CBAlertBaseView

- (instancetype)initWithContentView:(UIView *)contentView title:(NSString *)title{
    self = [super init];
    if (self){
        self.title = title;
        self.contentView = contentView;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.titleLbl = [MINUtils createLabelWithText:self.title size:20 alignment:NSTextAlignmentCenter textColor:UIColor.whiteColor];
    UIView *titleC = [UIView new];
    [titleC addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
    }];
    [self addSubview:titleC];
    [titleC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
    }];
    titleC.backgroundColor = kCellTextColor;
    
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(titleC.mas_bottom);
    }];
    
    UIView *btnC = [UIView new];
    btnC.backgroundColor = kBackColor;
    [self addSubview:btnC];
    [btnC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    self.cancelLbl = [MINUtils createLabelWithText:Localized(@"取消") size:15 alignment:NSTextAlignmentCenter textColor:kCellTextColor];
    self.cancelLbl.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    [btnC addSubview:self.cancelLbl];
    self.cancelLbl.backgroundColor = kGreyColor;
    
    self.confirmLbl = [MINUtils createLabelWithText:Localized(@"确定") size:15 alignment:NSTextAlignmentCenter textColor:kAppMainColor];
    self.confirmLbl.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    [btnC addSubview:self.confirmLbl];
    self.confirmLbl.backgroundColor = kGreyColor;
    
    UIView *line = [UIView new];
    line.backgroundColor = KCarLineColor;
    [self.cancelLbl addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(@0);
        make.width.equalTo(@1);
    }];
    
    UIView *lineTop = [MINUtils createLineView];
    [self addSubview:lineTop];
    [lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(line.mas_top);
        make.left.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    [self.cancelLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(@0);
    }];
    [self.confirmLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(@0);
        make.width.equalTo(self.cancelLbl);
        make.left.equalTo(self.cancelLbl.mas_right);
    }];
    
    UIView *centerLine = [MINUtils createLineView];
    [btnC addSubview:centerLine];
    [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.centerX.equalTo(@0);
        make.width.equalTo(@1);
    }];
    
    self.cancelLbl.userInteractionEnabled = YES;
    self.confirmLbl.userInteractionEnabled = YES;
    
    kWeakSelf(self);
    [self.cancelLbl bk_whenTapped:^{
        NSLog(@"%s", __FUNCTION__);
        if (weakself.didClickCancel) {
            weakself.didClickCancel();
        }
    }];
    
    [self.confirmLbl bk_whenTapped:^{
        NSLog(@"%s", __FUNCTION__);
        if (weakself.didClickConfirm){
            weakself.didClickConfirm();
        }
    }];
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
}

@end
