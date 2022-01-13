//
//  AddFamilyViewController.m
//  Watch
//
//  Created by lym on 2018/2/8.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "AddFamilyViewController.h"
#import "MINInputView.h"
#import "AddressBookViewController.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

@interface AddFamilyViewController ()
{
    MINInputView *connectInputView;
    MINInputView *phoneInputView;
}
@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation AddFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self addAction];

    [connectInputView updateLeftTitle:@"" text:self.model.name?:@"" placehold:@""];
    [phoneInputView updateLeftTitle:[NSString stringWithFormat:@"%@:",Localized(@"手机号码")] text:@"" placehold:[NSString stringWithFormat:@"%@",Localized(@"请输入手机号码")]];
    phoneInputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    if (self.model.famlily == 1) {
        // 绑定时 编辑关系，此时手机号即登录的手机号，不可修改
        phoneInputView.textField.text = [CBPetLoginModelTool getUser].phone;
        phoneInputView.textField.enabled = NO;
    }
}
#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"添加联系人") isBack: YES];
    self.view.backgroundColor = UIColor.whiteColor;
    
    connectInputView = [[MINInputView alloc] init];
    [self.view addSubview: connectInputView];
    [connectInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(12.5 * KFitWidthRate);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_topMargin).with.offset(12.5 * KFitWidthRate + kNavAndStatusHeight);
        }
        make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(40 * KFitWidthRate);
    }];
    
    phoneInputView = [[MINInputView alloc] init];
    [self.view addSubview: phoneInputView];
    [phoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(connectInputView.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(40 * KFitWidthRate);
    }];
    
    self.saveBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"保存") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: KWtBlueColor];
    [self.view addSubview: self.saveBtn];
    self.saveBtn.layer.cornerRadius = 5 * KFitWidthRate;
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneInputView.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.height.mas_equalTo(40 * KFitWidthRate);
        make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
    }];
}

#pragma mark - addAction
- (void)addAction
{
    [self.saveBtn addTarget: self action: @selector(saveBtnClick) forControlEvents: UIControlEventTouchUpInside];
}
#pragma mark -- 添加联系人
- (void)saveBtnClick {
    if (connectInputView.textField.text.length <= 0) {
        [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"请输入备注名")];
        return;
    }
    if (phoneInputView.textField.text.length <= 0) {
        [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"请输入手机号码")];
        return;
    }
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";
    // 添加联系人 family 传0
    paramters[@"family"] =  [NSNumber numberWithInt: self.model.famlily];
    paramters[@"type"] = [NSNumber numberWithInt: self.model.type];
    paramters[@"isAutoConnect"] = [NSNumber numberWithBool: NO];
    paramters[@"phone"] = phoneInputView.textField.text;
    paramters[@"relation"] = connectInputView.textField.text;
    
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/addConnector" params:paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [CBWtMINUtils showProgressHudToView:self.view withText: @"添加成功"];
            for (UIViewController *vc in self.navigationController.childViewControllers) {
                if ([vc isKindOfClass:[AddressBookViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
