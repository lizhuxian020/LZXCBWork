//
//  ChangeBindPhoneNumViewController.m
//  Watch
//
//  Created by lym on 2018/3/2.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "ChangeBindPhoneNumViewController.h"
#import "HomeModel.h"

@interface ChangeBindPhoneNumViewController ()
@property (nonatomic, strong) UITextField *applyTextFiled;
@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation ChangeBindPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self addAction];
}
#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"手表号码") isBack: YES];
    UILabel *titleLabel = [CBWtMINUtils createLabelWithText:Localized(@"APP检测到手表号码后，会自动替换手动输入的号码") size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
    titleLabel.numberOfLines = 0;
    [self.view addSubview: titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(12.5 * KFitWidthRate);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_topMargin).with.offset(12.5 * KFitWidthRate);
        }
        make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
    }];
    self.applyTextFiled = [CBWtMINUtils createBorderTextFieldWithHoldText: @"" fontSize: 15 * KFitWidthRate];
    self.applyTextFiled.backgroundColor = [UIColor whiteColor];
    self.applyTextFiled.placeholder = Localized(@"输入手机号码");
    [self.view addSubview: self.applyTextFiled];
    [self.applyTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(12.5*KFitWidthRate);
        make.width.mas_equalTo(SCREEN_WIDTH - 25 * KFitWidthRate);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(40 * KFitWidthRate);
    }];
    self.saveBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"保存") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: KWtBlueColor Radius: 4 * KFitWidthRate];
    [self.view addSubview: self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.applyTextFiled.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.width.mas_equalTo(SCREEN_WIDTH - 25 * KFitWidthRate);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(40 * KFitWidthRate);
    }];
}

#pragma mark - addAction
- (void)addAction
{
    [self.saveBtn addTarget: self action: @selector(saveBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)saveBtnClick
{
    if (self.applyTextFiled.text.length <= 0) {
        [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"输入手机号码")];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentWatchModel.sno;
    dic[@"phone"] = self.applyTextFiled.text;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/persion/updWatchInfo" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [weakSelf.navigationController popToRootViewControllerAnimated: YES];
            
        }else {
            
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
