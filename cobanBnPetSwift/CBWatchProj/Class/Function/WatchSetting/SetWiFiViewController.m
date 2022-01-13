//
//  SetWiFiViewController.m
//  Watch
//
//  Created by lym on 2018/2/10.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "SetWiFiViewController.h"
#import <NetworkExtension/NetworkExtension.h>
#import "GuardIndoModel.h"

@interface SetWiFiViewController ()

@property (nonatomic, strong) UITextField *wifiNameTF;
@property (nonatomic, strong) UITextField *wifiPwdTF;

@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation SetWiFiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    //[self scanWifiInfos];
}
#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"WIFI设置") isBack: YES];
    
    self.wifiNameTF = [CBWtMINUtils createTextFieldWithHoldText:Localized(@"请输入wifi账号") fontSize:14 * KFitWidthRate leftImage: [UIImage imageNamed: @"wifi"] leftImageSize: CGSizeMake(50 * KFitWidthRate, 50 * KFitWidthRate)];
    self.wifiNameTF.keyboardType = UIKeyboardTypeDefault;
    self.wifiNameTF.textColor = KWtBlackColor;
    self.wifiNameTF.text = self.model.wifi?:@"";
    [self.view addSubview: self.wifiNameTF];
    [self.wifiNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    [self addBottomLineViewToView: self.wifiNameTF];
    
    self.wifiPwdTF = [CBWtMINUtils createTextFieldWithHoldText:Localized(@"请输入wifi密码") fontSize:14 * KFitWidthRate leftImage: [UIImage imageNamed: @"密码"] leftImageSize: CGSizeMake(50 * KFitWidthRate, 50 * KFitWidthRate)];
    self.wifiPwdTF.secureTextEntry = YES;
    self.wifiPwdTF.textColor = KWtBlackColor;
    self.wifiPwdTF.text = self.model.wifiPwd?:@"";
    [self.view addSubview: self.wifiPwdTF];
    [self.wifiPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.wifiNameTF.mas_bottom);
        make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    [self addBottomLineViewToView: self.wifiPwdTF];
    
    self.saveBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"保存") titleColor:[UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: KWtBlueColor];
    self.saveBtn.layer.cornerRadius = 20;
    [self.view addSubview: self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(30*frameSizeRate);
        make.right.equalTo(self.view).with.offset(-30*frameSizeRate);
        make.top.equalTo(self.wifiPwdTF.mas_bottom).with.offset(30);
        make.height.mas_equalTo(40);
    }];
    [self.saveBtn addTarget:self action:@selector(updateWIfiInfoRequest) forControlEvents:UIControlEventTouchUpInside];
}
- (void)addBottomLineViewToView:(UITextField *)textFiled
{
    UIView *lineView = [CBWtMINUtils createLineView];
    [self.view addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(textFiled);
        make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)scanWifiInfos{
    NSLog(@"1.Start");
    
    NSMutableDictionary* options = [[NSMutableDictionary alloc] init];
    [options setObject:@"EFNEHotspotHelperDemo" forKey: kNEHotspotHelperOptionDisplayName];
    dispatch_queue_t queue = dispatch_queue_create("EFNEHotspotHelperDemo", NULL);
    
    NSLog(@"2.Try");
    BOOL returnType = [NEHotspotHelper registerWithOptions: options queue: queue handler: ^(NEHotspotHelperCommand * cmd) {
        
        NSLog(@"4.Finish");
        NEHotspotNetwork* network;
        if (cmd.commandType == kNEHotspotHelperCommandTypeEvaluate || cmd.commandType == kNEHotspotHelperCommandTypeFilterScanList) {
            // 遍历 WiFi 列表，打印基本信息
            for (network in cmd.networkList) {
                NSString* wifiInfoString = [[NSString alloc] initWithFormat: @"---------------------------\nSSID: %@\nMac地址: %@\n信号强度: %f\nCommandType:%ld\n---------------------------\n\n", network.SSID, network.BSSID, network.signalStrength, (long)cmd.commandType];
                NSLog(@"%@", wifiInfoString);
                
                // 检测到指定 WiFi 可设定密码直接连接
                if ([network.SSID isEqualToString: @"测试 WiFi"]) {
                    [network setConfidence: kNEHotspotHelperConfidenceHigh];
                    [network setPassword: @"123456789"];
                    NEHotspotHelperResponse *response = [cmd createResponse: kNEHotspotHelperResultSuccess];
                    NSLog(@"Response CMD: %@", response);
                    [response setNetworkList: @[network]];
                    [response setNetwork: network];
                    [response deliver];
                }
            }
        }
    }];
    
    // 注册成功 returnType 会返回一个 Yes 值，否则 No
    NSLog(@"3.Result: %@", returnType == YES ? @"Yes" : @"No");
}
#pragma mark -- 修改上学守护信息
- (void)updateWIfiInfoRequest {
    if (kStringIsEmpty(self.wifiNameTF.text)) {
        [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"请输入wifi账号")];
        return;
    }
    if (kStringIsEmpty(self.wifiPwdTF.text)) {
        [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"请输入wifi密码")];
        return;
    }
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[HomeModel CBDevice].tbWatchMain.sno?:@"" forKey:@"sno"];
    [paramters setObject:self.wifiNameTF.text forKey:@"wifi"];
    [paramters setObject:self.wifiPwdTF.text forKey:@"wifiPwd"];
    kWeakSelf(self);
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/updGoShcool" params:paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed ) {
            [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"修改成功")];
            [self.navigationController popViewControllerAnimated:YES];
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
