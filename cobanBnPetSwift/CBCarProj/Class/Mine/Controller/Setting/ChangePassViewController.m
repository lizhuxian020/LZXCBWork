//
//  ChangePassViewController.m
//  Telematics
//
//  Created by lym on 2017/11/14.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "ChangePassViewController.h"
#import "MINLoginPartView.h"
#import "cobanBnPetSwift-Swift.h"

@interface ChangePassViewController ()
{
    MINLoginPartView *oldPassTextView;
    MINLoginPartView *newPassTextView;
    MINLoginPartView *confirmPassTextView;
}
@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation ChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self addAction];
}

#pragma mark - Action
- (void)addAction
{
    [self.saveBtn addTarget: self action: @selector(saveBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)saveBtnClick
{
    if (oldPassTextView.textField.text.length < 1) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请输入您的原密码")];
        return;
    }
    if (newPassTextView.textField.text.length < 1) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请输入你的新密码")];
        return;
    }
    if (confirmPassTextView.textField.text.length < 1) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请再次输入您的新密码")];
        return;
    }
    if ([newPassTextView.textField.text isEqualToString: confirmPassTextView.textField.text] == NO) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"两次输入的密码不相同")];
        return;
    }
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:4];
    dic[@"opwd"] = [oldPassTextView.textField.text md5WithString];
    dic[@"npwd"] = [newPassTextView.textField.text md5WithString];
    //    dic[@"login_type"] = @"1";
    [[NetWorkingManager shared] postWithUrl: @"userController/uptPwd" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response) {
                //[hud hideAnimated: YES];
                [MINUtils showProgressHudToView: self.view withText:Localized(@"修改成功")];
                //[self.navigationController popViewControllerAnimated: YES];
                
                // 修改成功重新登陆
                // 清除本地选中的设备信息
                [CBCommonTools deleteCBDeviceInfo];
                
                CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
                userModel.token = nil;
                [CBPetLoginModelTool saveUser:userModel];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"K_SwitchLoginViewController" object:nil];
                
                [self.navigationController popToRootViewControllerAnimated:true];
            }
        } else {
            //[hud hideAnimated: YES];
        }
    } failed:^(NSError *error) {
        //[hud hideAnimated: YES];
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = kBackColor;
    [self initBarWithTitle:Localized(@"修改密码") isBack: YES];
    [self showBackGround];
    [self createInputPart];
    [self createSaveBtnPart];
}

- (void)createSaveBtnPart
{
    self.saveBtn = [MINUtils createBtnWithRadius: 20 * KFitHeightRate title:Localized(@"保存")];
    [self.view addSubview: self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmPassTextView.mas_bottom).with.offset(40 * KFitHeightRate);
        make.width.mas_equalTo(SCREEN_WIDTH - 50 * KFitWidthRate);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(40 * KFitHeightRate);
    }];
}

- (void)createInputPart
{
    if (oldPassTextView == nil) {
        oldPassTextView = [[MINLoginPartView alloc] initWithImageName: @"" holdText:Localized(@"输入您的原密码") rightBtnTitle: nil];
        [oldPassTextView.textField setSecureTextEntry: YES];
        [oldPassTextView.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(oldPassTextView).with.offset(12.5 * KFitWidthRate);
        }];
        [self.view addSubview: oldPassTextView];
    }
    if (newPassTextView == nil) {
        newPassTextView = [[MINLoginPartView alloc] initWithImageName: @"密码" holdText:Localized(@"输入您的新密码") rightBtnTitle: nil];
        [newPassTextView.textField setSecureTextEntry: YES];
        [self.view addSubview: newPassTextView];
    }
    if (confirmPassTextView == nil) {
        confirmPassTextView = [[MINLoginPartView alloc] initWithImageName: @"密码" holdText:Localized(@"请再次输入您的新密码") rightBtnTitle: nil];
        [confirmPassTextView.textField setSecureTextEntry: YES];
        [self.view addSubview: confirmPassTextView];
    }
    if (oldPassTextView != nil && newPassTextView != nil  && confirmPassTextView != nil) {
        MINLoginPartView *lastView = nil;
        NSArray *arr = @[oldPassTextView, newPassTextView, confirmPassTextView];
        for (int i = 0; i < arr.count; i++) {
            MINLoginPartView *currentView = arr[i];
            if (lastView == nil ) {
                [currentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view).with.offset(kNavAndStatusHeight + 15 * KFitHeightRate);
                    make.left.right.equalTo(self.view);
                    make.height.mas_equalTo(50 * KFitHeightRate);
                }];
            }else {
                [currentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.mas_bottom).with.offset(-1 * KFitHeightRate);
                    make.left.right.equalTo(lastView);
                    make.height.mas_equalTo(50 * KFitHeightRate);
                }];
            }
            lastView = currentView;
        }
    }
}

#pragma mark - Other method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
