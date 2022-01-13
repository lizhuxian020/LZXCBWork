//
//  CBHomeBindReusltView.m
//  Watch
//
//  Created by coban on 2019/8/19.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBHomeBindReusltView.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

@interface CBHomeBindReusltView ()
@property (nonatomic, strong) UIImageView *bindImageView;
@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *detailLabel;
//@property (nonatomic, strong) UIButton *confimBtn;
@end
@implementation CBHomeBindReusltView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.backgroundColor = KWtBackColor;
    //[self initBarWithTitle: @"绑定手表" isBack:NO];
    self.bindImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"绑定手表"]];
    [self addSubview: self.bindImageView];
    [self.bindImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).with.offset(PPNavigationBarHeight + 80*KFitWidthRate);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.mas_topMargin).with.offset(PPNavigationBarHeight + 80*KFitWidthRate);
        }
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(220 * KFitWidthRate, 220 * KFitWidthRate));
    }];
    self.titleLabel = [CBWtMINUtils createLabelWithText: Localized(@"绑定申请已发送，请等待管理员确认") size: 17 * KFitWidthRate alignment: NSTextAlignmentCenter textColor: KWtRGB(73, 73, 73)];
    [self addSubview: self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(self.bindImageView.mas_bottom).with.offset(30 * KFitWidthRate);
        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(40 * KFitWidthRate);
    }];
    
    UIButton *bindbtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"重新绑定")];//[UIButton new];
    [bindbtn setTitleColor:KWtBlueColor forState:UIControlStateNormal];
    [self addSubview:bindbtn];
    [bindbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_centerX).offset(-10*frameSizeRate);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10 * KFitWidthRate);
        //make.width.mas_equalTo(150 * KFitWidthRate);
        make.height.mas_equalTo(40 * KFitWidthRate);
    }];
    [bindbtn addTarget:self action:@selector(RebindingAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnLogout = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"退出登录")];//[UIButton new];
    [btnLogout setTitleColor:KWtBlueColor forState:UIControlStateNormal];
    [self addSubview:btnLogout];
    [btnLogout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10 * KFitWidthRate);
        //make.width.mas_equalTo(150 * KFitWidthRate);
        //make.centerX.equalTo(self);
        make.left.mas_equalTo(self.mas_centerX).offset(10*frameSizeRate);
        make.height.mas_equalTo(40 * KFitWidthRate);
    }];
    [btnLogout addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)RebindingAction {
    if (self.bindWatchResultBlock) {
        self.bindWatchResultBlock(@"");
    }
}
- (void)logoutAction {
    // 退出登录提醒
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:Localized(@"是否退出登录") preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
        [self logoutActionReal];
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self.viewController presentViewController:alertControl animated:YES completion:nil];
}
- (void)logoutActionReal {
    // 清除本地选中的设备信息
    //[CBWtCommonTools deleteCBaccount];
    // 清除本地选中的设备token
//    CBWtUserLoginModel *userModel = [CBWtUserLoginModel CBaccount];
//    userModel.token = nil;
//    [CBWtUserLoginModel saveCBAccount:userModel];
//    [[NSNotificationCenter defaultCenter] postNotificationName:KCBWt_SwitchCBWtLoginViewController object:nil];
    
    CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
    userModel.token = nil;
    [CBPetLoginModelTool saveUser:userModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"K_SwitchLoginViewController" object:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
