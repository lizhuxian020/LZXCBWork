//
//  AppSettingViewController.m
//  Watch
//
//  Created by lym on 2018/3/2.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "AppSettingViewController.h"
#import "MINClickCellView.h"
#import "SwitchView.h"
#import "MINSwitchView.h"
#import "CBModifyPwdViewController.h"
#import "CBAboutUsViewController.h"
#import "cobanBnPetSwift-Swift.h"

@interface AppSettingViewController () <MINSwtichViewDelegate>
{
    SwitchView *messageNotiView;
    MINClickCellView *changePassView;
    MINClickCellView *clearCacheView;
    MINClickCellView *aboutUsView;
    MINClickCellView *englishView;
    MINClickCellView *chineseView;
}
@property (nonatomic, strong) UIButton *quitBtn;

@property (nonatomic,copy) NSString *cachesStr;

@end

@implementation AppSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self addAction];
    [self setClickCellBlock];
    
    [self getMessageNotificationRequest];
    
    // 获取缓存数据
    double cachesSize = [CBWtCommonTools sizeWithFilePaht:[CBWtCommonTools CachesDirectory]];
    self.cachesStr = [NSString stringWithFormat:@"%.0fMB",cachesSize];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:self.cachesStr forKey:@"caches"];
    if (!self.cachesStr) {
        self.cachesStr = @"0MB";
    }
    clearCacheView.rightLabel.text = self.cachesStr;
}
#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"APP设置") isBack: YES];
    
    messageNotiView = [[SwitchView alloc] init];
    messageNotiView.titleLabel.text = Localized(@"消息通知");
    messageNotiView.statusLabel.text = Localized(@"已关闭");
    messageNotiView.switchView.delegate = self;
    [CBWtMINUtils addLineToView: messageNotiView isTop: NO hasSpaceToSide: NO];
    [self.view addSubview: messageNotiView];
    [messageNotiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    
    changePassView = [[MINClickCellView alloc] init];
    [changePassView setLeftLabelText:Localized(@"修改密码") rightLabelText: @""];
    [CBWtMINUtils addLineToView: changePassView isTop: NO hasSpaceToSide: NO];
    [self.view addSubview: changePassView];
    [changePassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messageNotiView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    
    clearCacheView = [[MINClickCellView alloc] init];
    [clearCacheView setLeftLabelText:Localized(@"清除缓存") rightLabelText: @""];
    [CBWtMINUtils addLineToView: clearCacheView isTop: NO hasSpaceToSide: NO];
    [self.view addSubview: clearCacheView];
    [clearCacheView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(changePassView.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(changePassView.mas_bottom).with.offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    
    aboutUsView = [[MINClickCellView alloc] init];
    [aboutUsView setLeftLabelText:Localized(@"关于我们") rightLabelText: @""];
    [CBWtMINUtils addLineToView: aboutUsView isTop: NO hasSpaceToSide: NO];
    [self.view addSubview: aboutUsView];
    [aboutUsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(clearCacheView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    
//    englishView = [[MINClickCellView alloc] init];
//    [englishView setLeftLabelText: @"英文" rightLabelText: @""];
//    [CBWtMINUtils addLineToView: englishView isTop: NO hasSpaceToSide: NO];
//    englishView.rightImageView.hidden = YES;
//    [self.view addSubview: englishView];
//    [englishView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(aboutUsView.mas_bottom);
//        make.left.right.equalTo(self.view);
//        make.height.mas_equalTo(50 * KFitWidthRate);
//    }];
//    
//    chineseView = [[MINClickCellView alloc] init];
//    [chineseView setLeftLabelText: @"中文" rightLabelText: @""];
//    [CBWtMINUtils addLineToView: chineseView isTop: NO hasSpaceToSide: NO];
//    chineseView.rightImageView.hidden = YES;
//    [self.view addSubview: chineseView];
//    [chineseView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(englishView.mas_bottom);
//        make.left.right.equalTo(self.view);
//        make.height.mas_equalTo(50 * KFitWidthRate);
//    }];
    
    self.quitBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"退出登录") titleColor: KWtBlueColor fontSize: 15 * KFitWidthRate backgroundColor: [UIColor clearColor] Radius: 20 * KFitWidthRate];
    self.quitBtn.layer.borderColor = KWtBlueColor.CGColor;
    self.quitBtn.layer.borderWidth = 0.5;
    [self.view addSubview: self.quitBtn];
    [self.quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-50 * KFitWidthRate - 34);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(290 * KFitWidthRate, 40 * KFitWidthRate));
    }];
}
#pragma mark -- 获取消息通知开关状态
- (void)getMessageNotificationRequest {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] getMessageNotificationSuccess:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *status = [NSString stringWithFormat:@"%@",baseModel.data[@"status"]];
        if ([status isEqualToString:@"0"]) {
            messageNotiView.switchView.isON = NO;
            messageNotiView.statusLabel.text = Localized(@"已关闭");
        } else {
            messageNotiView.switchView.isON = YES;
            messageNotiView.statusLabel.text = Localized(@"已开启");
        }
        
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - addAction
- (void)addAction
{
    [self.quitBtn addTarget: self action: @selector(quitBtnClick) forControlEvents: UIControlEventTouchUpInside];
}
- (void)modifyPwdClick {
    CBModifyPwdViewController *vc = [CBModifyPwdViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)quitBtnClick
{
    // 退出登录提醒
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:Localized(@"是否退出登录") preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self logoutRequest];
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}
- (void)logoutRequest {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] logoutSuccess:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        switch (baseModel.status) {
            case CBWtNetworkingStatus0:
            {
                [self logoutAction];
            }
                break;
            default:
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [CBWtMINUtils showProgressHudToView:self.view withText:baseModel.resmsg];
            }
                break;
        }
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)logoutAction {
    // 清除本地选中的设备token
//    CBWtUserLoginModel *userModel = [CBWtUserLoginModel CBaccount];
//    userModel.token = nil;
//    [CBWtUserLoginModel saveCBAccount:userModel];
//    [[NSNotificationCenter defaultCenter] postNotificationName:KCBWt_SwitchCBWtLoginViewController object:nil];
    // 信鸽推送 解绑
    //[[XGPushTokenManager defaultTokenManager] unbindWithIdentifer:[NSString stringWithFormat:@"%@",@(userModel.uid)] type:XGPushTokenBindTypeAccount];
    
    CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
    userModel.token = nil;
    [CBPetLoginModelTool saveUser:userModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"K_SwitchLoginViewController" object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)setClickCellBlock
{
    __weak __typeof__(self) weakSelf = self;
    changePassView.clickBtnClickBlock = ^{
        [weakSelf modifyPwdClick];
    };
    clearCacheView.clickBtnClickBlock = ^{
        //清除缓存
        [weakSelf cleanCacheClick];
    };
    aboutUsView.clickBtnClickBlock = ^{
        // 关于我们
        [weakSelf aboutUsClick];
    };
    englishView.clickBtnClickBlock = ^{
        //
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:AppLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [weakSelf toMain];
    };
    chineseView.clickBtnClickBlock = ^{
        //
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:AppLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [weakSelf toMain];
    };
}
#pragma mark -- 清除缓存
- (void)cleanCacheClick {
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:Localized(@"清除缓存") message:Localized(@"确定要清除缓存吗？") preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self cleanCache];
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}
- (void)cleanCache {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    CGFloat caches = [[user objectForKey:@"caches"]floatValue];
    if (caches > 20.0) {
        //ShowSuccessStatus(@"");
    }
    kWeakSelf(self);
    [CBWtCommonTools cleanTheCachesFinished:^(BOOL success) {
        if (success) {
            kStrongSelf(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.cachesStr = @"0MB";
                clearCacheView.rightLabel.text = self.cachesStr;
                [MBProgressHUD showMessage:Localized(@"缓存已清除") withDelay:3.0f];
            });
        }
    }];
}
- (void)aboutUsClick {
    CBAboutUsViewController *vc = [[CBAboutUsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)toMain {
    [[NSNotificationCenter defaultCenter] postNotificationName:KCBWt_SwitchRootViewController object:nil];
}
#pragma mark - MINSwtichViewDelegate
- (void)switchView:(MINSwitchView *)switchView stateChange:(BOOL)isON
{
    if (isON == YES) {
        messageNotiView.statusLabel.text = Localized(@"已开启");
    }else {
        messageNotiView.statusLabel.text = Localized(@"已关闭");
    }
    [self updateMessageNotificationStatusReqeustIsOn:isON];
}
#pragma mark -- 修改消息通知开关状态
- (void)updateMessageNotificationStatusReqeustIsOn:(BOOL)isOn {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:isOn?@"1":@"0" forKey:@"status"];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] updateMessageNotificationStatusParamters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self getMessageNotificationRequest];
        
    } failure:^(NSError * _Nonnull error) {
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
