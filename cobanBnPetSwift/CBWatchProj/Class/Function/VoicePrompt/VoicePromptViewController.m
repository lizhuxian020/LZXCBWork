//
//  VoicePromptViewController.m
//  Watch
//
//  Created by lym on 2018/2/27.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "VoicePromptViewController.h"
#import "SwitchView.h"
#import "MINSwitchView.h"
#import "FuctionSwitchModel.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

@interface VoicePromptViewController () <MINSwtichViewDelegate>
{
    SwitchView *speechRrecognitionView;
    SwitchView *voiceBradcastView;
}
@end

@implementation VoicePromptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    speechRrecognitionView.switchView.isON = self.model.voiceAction1;
    voiceBradcastView.switchView.isON = self.model.voiceAction2;
}

#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"语音提示") isBack: YES];
    speechRrecognitionView = [[SwitchView alloc] init];
    speechRrecognitionView.titleLabel.text = Localized(@"语音识别");
    speechRrecognitionView.statusLabel.hidden = YES;
    speechRrecognitionView.switchView.delegate = self;
    [CBWtMINUtils addLineToView: speechRrecognitionView isTop: NO hasSpaceToSide: NO];
    [self.view addSubview: speechRrecognitionView];
    [speechRrecognitionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(12.5 * KFitWidthRate);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_topMargin).with.offset(12.5 * KFitWidthRate);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    voiceBradcastView = [[SwitchView alloc] init];
    voiceBradcastView.titleLabel.text = Localized(@"语音播报");
    voiceBradcastView.statusLabel.hidden = YES;
    voiceBradcastView.switchView.delegate = self;
    [self.view addSubview: voiceBradcastView];
    [voiceBradcastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(speechRrecognitionView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
}

#pragma mark - MINSwtichViewDelegate
- (void)switchView:(MINSwitchView *)switchView stateChange:(BOOL)isON
{
    if ([switchView isEqual: speechRrecognitionView.switchView] == YES) { // 语音识别
        [self requestChangeSwitchStatus: isON isSpeechRrecognitionView: YES];
    }else { // 语音播报
        [self requestChangeSwitchStatus: isON isSpeechRrecognitionView: NO];
    }
}

- (void)requestChangeSwitchStatus:(BOOL)isOn isSpeechRrecognitionView:(BOOL)isSpeechRrecognitionView
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";
    kWeakSelf(self);
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    if (isSpeechRrecognitionView == YES) {
        dic[@"voiceAction1"] = [NSNumber numberWithBool: isOn];
    }else {
        dic[@"voiceAction2"] = [NSNumber numberWithBool: isOn];
    }
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/updSwitchStatus" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!isSucceed) {
            if (isSpeechRrecognitionView == YES) {
                speechRrecognitionView.switchView.isON = !isOn;
            }else {
                voiceBradcastView.switchView.isON = !isOn;
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
