//
//  WatchSettingViewController.m
//  Watch
//
//  Created by lym on 2018/2/27.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "WatchSettingViewController.h"
#import "MINClickCellView.h"
#import "SwitchView.h"
#import "MINSwitchView.h"
#import "WatchBrightenTimeSettingViewController.h"
#import "VoiceAndShakeViewController.h"
#import "FuctionSwitchModel.h"
#import "WatchSettingModel.h"
#import "GuardIndoModel.h"
#import "SetWiFiViewController.h"

@interface WatchSettingViewController () <MINSwtichViewDelegate>

@property (nonatomic, strong) MINClickCellView *brightenScreenTimeView;
@property (nonatomic, strong) MINClickCellView *voiceAndShakeView;
@property (nonatomic, strong) SwitchView *allDaySystemView;
@property (nonatomic, strong) MINClickCellView *wifiSettingView;
@property (nonatomic, strong) WatchSettingModel *settingModel;
@property (nonatomic, strong) GuardIndoModel *guardInfoModel;
@end

@implementation WatchSettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self getGuardInfoData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self setClickCellBlock];
    self.allDaySystemView.switchView.isON = self.model.switchFlag;
    
    [self getGuardInfoData];
}

- (void)setClickCellBlock
{
    __weak __typeof__(self) weakSelf = self;
    self.brightenScreenTimeView.clickBtnClickBlock = ^{
        [weakSelf setScreenTime];
    };
    self.voiceAndShakeView.clickBtnClickBlock = ^{
        [weakSelf setVoiceClick];
    };
    self.wifiSettingView.clickBtnClickBlock = ^{
        [weakSelf setWifiClick];
    };
}
- (void)setScreenTime {
    WatchBrightenTimeSettingViewController *brightenTimeVC = [[WatchBrightenTimeSettingViewController alloc] init];
    kWeakSelf(self);
    brightenTimeVC.returnBlock = ^(id objc) {
        kStrongSelf(self);
        [self.brightenScreenTimeView setLeftLabelText:Localized(@"亮屏时间") rightLabelText:[NSString stringWithFormat:@"%@%@",objc?:@"",Localized(@"秒")]];
    };
    [self.navigationController pushViewController: brightenTimeVC animated: YES];
}
- (void)setVoiceClick {
    VoiceAndShakeViewController *voiceAndShakeVC = [[VoiceAndShakeViewController alloc] init];
    voiceAndShakeVC.model = self.model;
    [self.navigationController pushViewController: voiceAndShakeVC animated: YES];
}
- (void)setWifiClick {
    SetWiFiViewController *vc = [[SetWiFiViewController alloc]init];
    vc.model = self.guardInfoModel;
    [self.navigationController pushViewController:vc animated: YES];
}
#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"手表设置") isBack: YES];
    
    self.brightenScreenTimeView = [[MINClickCellView alloc] init];
    [self.brightenScreenTimeView setLeftLabelText:Localized(@"亮屏时间") rightLabelText:[NSString stringWithFormat:@"%@%@",self.model.screenTime?:@"",Localized(@"秒")]];//@"10秒"
    [CBWtMINUtils addLineToView:self.brightenScreenTimeView isTop:NO hasSpaceToSide:NO];
    [self.view addSubview:self.brightenScreenTimeView];
    [self.brightenScreenTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(12.5 * KFitWidthRate);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_topMargin).with.offset(12.5 * KFitWidthRate);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    
    self.voiceAndShakeView = [[MINClickCellView alloc] init];
    [self.voiceAndShakeView setLeftLabelText:Localized(@"声音和振动") rightLabelText:@""];
    [CBWtMINUtils addLineToView:self.voiceAndShakeView isTop:NO hasSpaceToSide:NO];
    [self.view addSubview:self.voiceAndShakeView];
    [self.voiceAndShakeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.brightenScreenTimeView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    
    self.allDaySystemView = [[SwitchView alloc] init];
    self.allDaySystemView.titleLabel.text = Localized(@"24小时制");
    self.allDaySystemView.statusLabel.hidden = YES;
    self.allDaySystemView.switchView.delegate = self;
    [self.view addSubview: self.allDaySystemView];
    [self.allDaySystemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceAndShakeView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    
    self.wifiSettingView = [[MINClickCellView alloc] init];
    [self.wifiSettingView setLeftLabelText:Localized(@"WIFI设置") rightLabelText:@""];//@"10秒"
    [CBWtMINUtils addLineToView:self.wifiSettingView isTop:NO hasSpaceToSide:NO];
    [self.view addSubview: self.wifiSettingView];
    [self.wifiSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allDaySystemView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
}

#pragma mark - MINSwtichViewDelegate
- (void)switchView:(MINSwitchView *)switchView stateChange:(BOOL)isON
{
    [self requestChangeSwitchStatus: isON];
}
#pragma mark -- 修改手表开关状态（手表的基本开关）
- (void)requestChangeSwitchStatus:(BOOL)isOn
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
    dic[@"switchFlag"] = [NSNumber numberWithBool:isOn];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/updSwitchStatus" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!isSucceed) {
            self.allDaySystemView.switchView.isON = !isOn;
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 获取上学守护信息
- (void)getGuardInfoData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] getWithUrl: @"watch/watch/getGoShcoolInfo" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed && response && [response[@"data"] isKindOfClass: [NSDictionary class]]) {
            self.guardInfoModel = [GuardIndoModel yy_modelWithDictionary: response[@"data"]];
            [self.wifiSettingView setLeftLabelText:Localized(@"WIFI设置") rightLabelText:self.guardInfoModel.wifi?:@""];
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
