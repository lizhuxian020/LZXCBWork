//
//  RecordViewController.m
//  Telematics
//
//  Created by lym on 2017/12/1.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "RecordViewController.h"
#import "VoiceModel.h"

@interface RecordViewController ()
{
    UIView *timeView;
    UIView *saveView;
    UIView *voiceView;
}
@property (nonatomic, strong) UITextField *recordTextFeild;
@property (nonatomic, strong) UIButton *uploadBtn;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *voice8KBtn;
@property (nonatomic, strong) UIButton *voice11KBtn;
@property (nonatomic, strong) UIButton *voice23KBtn;
@property (nonatomic, strong) UIButton *voice32KBtn;
@property (nonatomic, strong) VoiceModel *voiceModel;
@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self addAction];
    [self requestData];
}
#pragma mark -- 获取设备录音配置
- (void)requestData
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
//    MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
//    [hud hideAnimated:YES];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devControlController/getVoiceParamList" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                VoiceModel *model = [VoiceModel yy_modelWithJSON: response[@"data"]];
                self.voiceModel = model;
                weakSelf.recordTextFeild.text = [NSString stringWithFormat: @"%d", model.time];
                NSArray *flagArr = @[weakSelf.uploadBtn, weakSelf.saveBtn];
                [weakSelf saveSignBtnClick: flagArr[model.flag]];
                NSArray *sampleArr = @[weakSelf.voice8KBtn, weakSelf.voice11KBtn, weakSelf.voice23KBtn, weakSelf.voice32KBtn];
                [weakSelf voiceBtnClick: sampleArr[model.sample]];
     
            } else {
    
            }
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Action
- (void)addAction
{
    [self.uploadBtn addTarget: self action: @selector(saveSignBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.saveBtn addTarget: self action: @selector(saveSignBtnClick:) forControlEvents: UIControlEventTouchUpInside];
}

- (void)saveSignBtnClick:(UIButton *)button
{
    if (self.uploadBtn == button) {
        self.voiceModel.flag = 0;
        self.uploadBtn.selected = YES;
        self.saveBtn.selected = NO;
    }else {
        self.voiceModel.flag = 1;
        self.uploadBtn.selected = NO;
        self.saveBtn.selected = YES;
    }
    
}

- (void)voiceBtnClick:(UIButton *)button
{
    if (self.voice8KBtn == button) {
        self.voiceModel.sample = 0;
        self.voice8KBtn.selected = YES;
        self.voice11KBtn.selected = NO;
        self.voice23KBtn.selected = NO;
        self.voice32KBtn.selected = NO;
    }else if (self.voice11KBtn == button) {
        self.voiceModel.sample = 1;
        self.voice8KBtn.selected = NO;
        self.voice11KBtn.selected = YES;
        self.voice23KBtn.selected = NO;
        self.voice32KBtn.selected = NO;
    }else if (self.voice23KBtn == button) {
        self.voiceModel.sample = 2;
        self.voice8KBtn.selected = NO;
        self.voice11KBtn.selected = NO;
        self.voice23KBtn.selected = YES;
        self.voice32KBtn.selected = NO;
    }else {
        self.voiceModel.sample = 3;
        self.voice8KBtn.selected = NO;
        self.voice11KBtn.selected = NO;
        self.voice23KBtn.selected = NO;
        self.voice32KBtn.selected = YES;
    }
}

- (void)rightBtnClick
{
    if (self.recordTextFeild.text.length < 1) {
        [HUD showHUDWithText:Localized(@"请输入录音的时间(秒)") withDelay:1.2];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    dic[@"time"] = self.recordTextFeild.text;
    dic[@"flag"] = [NSString stringWithFormat: @"%d", self.voiceModel.flag];
    dic[@"sample"] = [NSString stringWithFormat: @"%d", self.voiceModel.sample];
//    MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
//    [hud hideAnimated:YES];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devControlController/editVoicePara" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [weakSelf.navigationController popViewControllerAnimated: YES];
        } else {
            [HUD showHUDWithText:@"" withDelay:1.2];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"录音") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"确定") target: self action: @selector(rightBtnClick)];
    [self showBackGround];
    [self createTimeView];
    [self createSaveView];
    [self createVoiceView];
}

- (void)createVoiceView
{
    voiceView = [MINUtils createViewWithRadius: 5 * KFitWidthRate];
    [self.view addSubview: voiceView];
    [voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    UILabel *recodeTimeLabel = [MINUtils createLabelWithText:Localized(@"音频采样") size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(73, 73, 73)];
    [voiceView addSubview: recodeTimeLabel];
    [recodeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(voiceView).with.offset(12.5 * KFitWidthRate);
        make.top.bottom.equalTo(voiceView);
        make.width.mas_equalTo(100 * KFitWidthRate);
    }];
    NSArray *titleArr = @[@"8K", @"11K", @"23K", @"32K"];
    UIButton *lastView = nil;
    CGFloat btnWidth = (SCREEN_WIDTH - 12.5*KFitWidthRate*3 - 100*KFitWidthRate)/titleArr.count;
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *button = [MINUtils createNoBorderBtnWithTitle: titleArr[i] titleColor: k137Color fontSize: 12 * KFitHeightRate backgroundColor: nil];
        [button horizontalCenterImageAndTitle:8*KFitWidthRate];
        [button setImage: [UIImage imageNamed: @"单选-没选中"] forState: UIControlStateNormal];
        [button setImage: [UIImage imageNamed: @"单选-选中"] forState: UIControlStateSelected];
        [button addTarget: self action: @selector(voiceBtnClick:) forControlEvents: UIControlEventTouchUpInside];
        [voiceView addSubview: button];
        if (i == 0) {
            self.voice8KBtn = button;
        }else if (i == 1) {
            self.voice11KBtn = button;
        }else if (i == 2) {
            self.voice23KBtn = button;
        }else if (i == 3) {
            self.voice32KBtn = button;
        }
        if (i == 0) {
            button.selected = YES;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(recodeTimeLabel.mas_right);
                make.top.bottom.equalTo(voiceView);
                make.width.mas_equalTo(btnWidth);
            }];
        }else{
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).with.offset(0* KFitHeightRate);
                make.top.bottom.equalTo(voiceView);
                make.width.mas_equalTo(btnWidth);
            }];
        }
        lastView = button;
    }
}

- (void)createSaveView
{
    saveView = [MINUtils createViewWithRadius: 5 * KFitWidthRate];
    [self.view addSubview: saveView];
    [saveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    UILabel *recodeTimeLabel = [MINUtils createLabelWithText:Localized(@"保存标志") size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(73, 73, 73)];
    [saveView addSubview: recodeTimeLabel];
    [recodeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(saveView).with.offset(12.5 * KFitWidthRate);
        make.top.bottom.equalTo(saveView);
        make.width.mas_equalTo(100 * KFitWidthRate);
    }];
    CGFloat btnWidth = (SCREEN_WIDTH - 12.5*KFitWidthRate*3 - 100*KFitWidthRate)/2;
    self.uploadBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"实时上传") titleColor: k137Color fontSize: 12 * KFitHeightRate backgroundColor: nil];
    self.uploadBtn.selected = YES;
    [self.uploadBtn horizontalCenterImageAndTitle:8*KFitWidthRate];
    [self.uploadBtn setImage: [UIImage imageNamed: @"单选-没选中"] forState: UIControlStateNormal];
    [self.uploadBtn setImage: [UIImage imageNamed: @"单选-选中"] forState: UIControlStateSelected];
    [saveView addSubview: self.uploadBtn];
    [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(recodeTimeLabel.mas_right);
        make.top.bottom.equalTo(saveView);
        make.width.mas_equalTo(btnWidth);
    }];
    self.saveBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"保存") titleColor: k137Color fontSize: 12 * KFitHeightRate backgroundColor: nil];
    [self.saveBtn horizontalCenterImageAndTitle:8*KFitWidthRate];
    [self.saveBtn setImage: [UIImage imageNamed: @"单选-没选中"] forState: UIControlStateNormal];
    [self.saveBtn setImage: [UIImage imageNamed: @"单选-选中"] forState: UIControlStateSelected];
    [saveView addSubview: self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uploadBtn.mas_right).with.offset(0 * KFitWidthRate);
        make.top.bottom.equalTo(saveView);
        make.width.mas_equalTo(btnWidth);
    }];
}

- (void)createTimeView
{
    timeView = [MINUtils createViewWithRadius: 5 * KFitWidthRate];
    [self.view addSubview: timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(12.5 * KFitHeightRate + kNavAndStatusHeight);
        make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    UILabel *recodeTimeLabel = [MINUtils createLabelWithText:Localized(@"录音时间") size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(73, 73, 73)];
    [timeView addSubview: recodeTimeLabel];
    [recodeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeView).with.offset(12.5 * KFitWidthRate);
        make.top.bottom.equalTo(timeView);
        make.width.mas_equalTo(100 * KFitWidthRate);
    }];
    self.recordTextFeild = [MINUtils createBorderTextFieldWithHoldText:Localized(@"秒 (0表示一直录音)") fontSize: 12 * KFitHeightRate];
    self.recordTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    self.recordTextFeild.textAlignment = NSTextAlignmentCenter;
    [timeView addSubview: self.recordTextFeild];
    [self.recordTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeView);
        make.left.equalTo(recodeTimeLabel.mas_right);
        make.height.mas_equalTo(30 * KFitHeightRate);
        make.right.equalTo(timeView).with.offset(-12.5 * KFitWidthRate);
    }];
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
