//
//  CBModifyPwdViewController.m
//  Watch
//
//  Created by coban on 2019/9/9.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBModifyPwdViewController.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

@interface CBModifyPwdViewController ()

@property (nonatomic,strong) UIView *textFieldBackView;;
//@property (nonatomic,strong) UITextField *textField_mobile;
@property (nonatomic,strong) UITextField *textField_oldPwd;
@property (nonatomic,strong) UITextField *textField_newPwd;
@property (nonatomic,strong) UITextField *textField_newPwd_again;
@property (nonatomic,strong) UIButton *btn_modify;

@end

@implementation CBModifyPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}
- (void)setupView {
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"修改密码") isBack: YES];
    [self textFieldBackView];
    //[self textField_mobile];
    [self textField_oldPwd];
    [self textField_newPwd];
    [self textField_newPwd_again];
    [self btn_modify];
}
#pragma mark -- setting && getting
- (UIView *)textFieldBackView {
    if (!_textFieldBackView) {
        _textFieldBackView = [[UIView alloc] init];
        _textFieldBackView.backgroundColor = [UIColor whiteColor];
        _textFieldBackView.layer.cornerRadius = 5 * KFitWidthRate;
        _textFieldBackView.layer.borderColor = KWtLineColor.CGColor;
        _textFieldBackView.layer.borderWidth = 0.5;
        [self.view addSubview:_textFieldBackView];
        [_textFieldBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12.5*KFitWidthRate);
            make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
            make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
            make.height.mas_equalTo(150 * KFitWidthRate);
        }];
    }
    return _textFieldBackView;
}
//- (UITextField *)textField_mobile {
//    if (!_textField_mobile) {
//        _textField_mobile = [CBWtMINUtils createTextFieldWithHoldText:Localized(@"请输入手机号码") fontSize:14 * KFitWidthRate leftImage: [UIImage imageNamed: @"手机"] leftImageSize: CGSizeMake(50 * KFitWidthRate, 50 * KFitWidthRate)];
//        [self.textFieldBackView addSubview:_textField_mobile];
//        [_textField_mobile mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.equalTo(self.textFieldBackView);
//            make.right.equalTo(self.textFieldBackView).with.offset(-12.5 * KFitWidthRate);
//            make.height.mas_equalTo(50 * KFitWidthRate);
//        }];
//        [self addBottomLineViewToView:_textField_mobile];
//    }
//    return _textField_mobile;
//}
- (UITextField *)textField_oldPwd {
    if (!_textField_oldPwd) {
        _textField_oldPwd = [CBWtMINUtils createTextFieldWithHoldText:Localized(@"请输入您的旧密码") fontSize:14 * KFitWidthRate leftImage: [UIImage imageNamed:@"密码"] leftImageSize: CGSizeMake(50 * KFitWidthRate, 50 * KFitWidthRate)];
        [self.textFieldBackView addSubview:_textField_oldPwd];
        [_textField_oldPwd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.textFieldBackView);
            //make.left.equalTo(self.textFieldBackView);
            //make.top.mas_equalTo(self.textField_mobile.mas_bottom).offset(0);
            make.right.equalTo(self.textFieldBackView).with.offset(-12.5 * KFitWidthRate);
            make.height.mas_equalTo(50 * KFitWidthRate);
        }];
        [self addBottomLineViewToView:_textField_oldPwd];
    }
    return _textField_oldPwd;
}
- (UITextField *)textField_newPwd {
    if (!_textField_newPwd) {
        _textField_newPwd = [CBWtMINUtils createTextFieldWithHoldText:Localized(@"请输入您的新密码") fontSize:14 * KFitWidthRate leftImage: [UIImage imageNamed: @"密码"] leftImageSize: CGSizeMake(50 * KFitWidthRate, 50 * KFitWidthRate)];
        [self.textFieldBackView addSubview:_textField_newPwd];
        [_textField_newPwd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textFieldBackView);
            make.top.mas_equalTo(self.textField_oldPwd.mas_bottom).offset(0);
            make.right.equalTo(self.textFieldBackView).with.offset(-12.5 * KFitWidthRate);
            make.height.mas_equalTo(50 * KFitWidthRate);
        }];
        [self addBottomLineViewToView:_textField_newPwd];
    }
    return _textField_newPwd;
}
- (UITextField *)textField_newPwd_again {
    if (!_textField_newPwd_again) {
        _textField_newPwd_again = [CBWtMINUtils createTextFieldWithHoldText:Localized(@"请再次确认输入您的新密码") fontSize:14 * KFitWidthRate leftImage: [UIImage imageNamed: @"密码"] leftImageSize: CGSizeMake(50 * KFitWidthRate, 50 * KFitWidthRate)];
        [self.textFieldBackView addSubview:_textField_newPwd_again];
        [_textField_newPwd_again mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textFieldBackView);
            make.top.mas_equalTo(self.textField_newPwd.mas_bottom).offset(0);
            make.right.equalTo(self.textFieldBackView).with.offset(-12.5 * KFitWidthRate);
            make.height.mas_equalTo(50 * KFitWidthRate);
        }];
        [self addBottomLineViewToView:_textField_newPwd_again];
    }
    return _textField_newPwd_again;
}
- (UIButton *)btn_modify {
    if (!_btn_modify) {
        _btn_modify = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"修改密码") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: KWtBlueColor Radius: 5 * KFitWidthRate];
        _btn_modify.layer.masksToBounds = YES;
        _btn_modify.layer.cornerRadius = 20*frameSizeRate;
        [self.view addSubview: _btn_modify];
        [_btn_modify mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textFieldBackView.mas_bottom).with.offset(25 * KFitWidthRate);
            make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
            make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
            make.height.mas_equalTo(40*frameSizeRate);
        }];
        [_btn_modify addTarget:self action:@selector(modifyPwdRequest) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_modify;
}
#pragma mark -- 修改密码
- (void)modifyPwdRequest {
    if (self.textField_oldPwd.text.length < 1) {
        [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"请输入您的原密码")];
        return;
    }
    if (self.textField_newPwd.text.length < 1) {
        [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"请输入你的新密码")];
        return;
    }
    if (self.textField_newPwd_again.text.length < 1) {
        [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"请再次输入您的新密码")];
        return;
    }
    if ([self.textField_newPwd.text isEqualToString: self.textField_newPwd_again.text] == NO) {
        [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"两次输入的密码不相同")];
        return;
    }
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[self.textField_oldPwd.text md5WithString] forKey:@"opwd"];
    [paramters setObject:[self.textField_newPwd.text md5WithString] forKey:@"npwd"];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl: @"userController/uptPwd" params: paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response) {
                [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"修改成功")];
                //[self.navigationController popViewControllerAnimated: YES];
                
//                CBWtUserLoginModel *userModel = [CBWtUserLoginModel CBaccount];
//                userModel.token = nil;
//                [CBWtUserLoginModel saveCBAccount:userModel];
//                // 修改密码，请重新登录
//                [[NSNotificationCenter defaultCenter] postNotificationName:KCBWt_SwitchCBWtLoginViewController object:nil];
                
                CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
                userModel.token = nil;
                [CBPetLoginModelTool saveUser:userModel];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"K_SwitchLoginViewController" object:nil];
            }
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)addBottomLineViewToView:(UITextField *)textFiled {
    UIView *lineView = [CBWtMINUtils createLineView];
    [_textFieldBackView addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(textFiled);
        make.left.equalTo(_textFieldBackView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(_textFieldBackView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(0.5);
    }];
}
@end
