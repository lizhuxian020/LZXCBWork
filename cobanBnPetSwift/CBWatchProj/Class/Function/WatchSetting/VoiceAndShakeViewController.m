//
//  VoiceAndShakeViewController.m
//  Watch
//
//  Created by lym on 2018/2/27.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "VoiceAndShakeViewController.h"
#import "MINClickCellView.h"
#import "SwitchView.h"
#import "MINSwitchView.h"
#import "FuctionSwitchModel.h"

@interface VoiceAndShakeViewController () <MINSwtichViewDelegate>
{
    MINClickCellView *watchIncomingView;
    MINClickCellView *watchInfoView;
    SwitchView *incomingVoiceView;      // 手表来电铃声
    SwitchView *incomingShakeView;      // 手表来电振动
    SwitchView *infoVoiceView;          // 手表信息铃声
    SwitchView *infoShakeView;          // 手表信息振动
}
@end

@implementation VoiceAndShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    incomingVoiceView.switchView.isON = self.model.callBellAction;
    //incomingShakeView.switchView.isON = self.model.callLibrateAction;
    infoVoiceView.switchView.isON = self.model.msgBellAction;
    //infoShakeView.switchView.isON = self.model.msgLibrateAction;
}

#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"声音和振动") isBack: YES];
    watchIncomingView = [[MINClickCellView alloc] init];
    [watchIncomingView setLeftLabelText:Localized(@"手表来电") rightLabelText: @""];
    watchIncomingView.rightImageView.hidden = YES;
    [CBWtMINUtils addLineToView: watchIncomingView isTop: NO hasSpaceToSide: NO];
    [self.view addSubview: watchIncomingView];
    [watchIncomingView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(12.5 * KFitWidthRate);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_topMargin).with.offset(12.5 * KFitWidthRate);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    
    incomingVoiceView = [[SwitchView alloc] init];
    incomingVoiceView.titleLabel.text = Localized(@"铃声");
    incomingVoiceView.statusLabel.hidden = YES;
    incomingVoiceView.switchView.delegate = self;
    [CBWtMINUtils addLineToView: incomingVoiceView isTop: NO hasSpaceToSide: YES];
    [self.view addSubview: incomingVoiceView];
    [incomingVoiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(watchIncomingView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    
//    incomingShakeView = [[SwitchView alloc] init];
//    incomingShakeView.titleLabel.text = Localized(@"振动");
//    incomingShakeView.statusLabel.hidden = YES;
//    incomingShakeView.switchView.delegate = self;
//    [self.view addSubview: incomingShakeView];
//    [incomingShakeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(incomingVoiceView.mas_bottom);
//        make.left.right.equalTo(self.view);
//        make.height.mas_equalTo(50 * KFitWidthRate);
//    }];
    
    watchInfoView = [[MINClickCellView alloc] init];
    [watchInfoView setLeftLabelText:Localized(@"手表信息") rightLabelText: @""];
    watchInfoView.rightImageView.hidden = YES;
    [CBWtMINUtils addLineToView: watchInfoView isTop: NO hasSpaceToSide: NO];
    [self.view addSubview: watchInfoView];
    [watchInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(incomingShakeView.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(incomingVoiceView.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    
    infoVoiceView = [[SwitchView alloc] init];
    infoVoiceView.titleLabel.text = Localized(@"铃声");
    infoVoiceView.statusLabel.hidden = YES;
    infoVoiceView.switchView.delegate = self;
    [CBWtMINUtils addLineToView: infoVoiceView isTop: NO hasSpaceToSide: YES];
    [self.view addSubview: infoVoiceView];
    [infoVoiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(watchInfoView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    
//    infoShakeView = [[SwitchView alloc] init];
//    infoShakeView.titleLabel.text = Localized(@"振动");
//    infoShakeView.statusLabel.hidden = YES;
//    infoShakeView.switchView.delegate = self;
//    [self.view addSubview: infoShakeView];
//    [infoShakeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(infoVoiceView.mas_bottom);
//        make.left.right.equalTo(self.view);
//        make.height.mas_equalTo(50 * KFitWidthRate);
//    }];
}

#pragma mark - MINSwtichViewDelegate
- (void)switchView:(MINSwitchView *)switchView stateChange:(BOOL)isON
{
    NSString *name = nil;
    if ([switchView isEqual: incomingVoiceView.switchView]) { // 手表来电 铃声
        name = @"callBellAction";
    }else if ([switchView isEqual: incomingShakeView.switchView]) { // 手表来电 振动
        name = @"callLibrateAction";
    }else if ([switchView isEqual: infoVoiceView.switchView]) { // 手表信息 铃声
        name = @"msgBellAction";
    }else if ([switchView isEqual: infoShakeView.switchView]) { // 手表信息 振动
        name = @"msgLibrateAction";
    }
    [self requestEditSwitchView: switchView isOn: isON switchName: name];
}

- (void)requestEditSwitchView:(MINSwitchView *)switchView isOn:(BOOL)isOn switchName:(NSString *)name
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
    dic[name] = [NSNumber numberWithBool: isOn];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/updSwitchStatus" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [CBWtMINUtils showProgressHudToView:weakSelf.view withText:Localized(@"设置成功")];
        }else {
            switchView.isON = !isOn;
        }
        [self updateSwitchView:switchView isOn:isOn];
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)updateSwitchView:(MINSwitchView *)switchView isOn:(BOOL)isOn {
    if ([switchView isEqual: incomingVoiceView.switchView]) { // 手表来电 铃声
        self.model.callBellAction = isOn;
    } else if ([switchView isEqual: incomingShakeView.switchView]) { // 手表来电 振动
        self.model.callLibrateAction = isOn;
    } else if ([switchView isEqual: infoVoiceView.switchView]) { // 手表信息 铃声
        self.model.msgBellAction = isOn;
    } else if ([switchView isEqual: infoShakeView.switchView]) { // 手表信息 振动
        self.model.msgLibrateAction = isOn;
    }
    incomingVoiceView.switchView.isON = self.model.callBellAction;
    //incomingShakeView.switchView.isON = self.model.callLibrateAction;
    infoVoiceView.switchView.isON = self.model.msgBellAction;
    //infoShakeView.switchView.isON = self.model.msgLibrateAction;
}
#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
