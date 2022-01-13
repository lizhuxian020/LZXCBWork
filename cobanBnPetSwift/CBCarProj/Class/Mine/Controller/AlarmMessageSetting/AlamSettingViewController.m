//
//  AlamSettingViewController.m
//  Telematics
//
//  Created by lym on 2017/11/13.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "AlamSettingViewController.h"
#import "AlamSettingView.h"
#import "MINSwitchView.h"
#import "MINPickerView.h"
#import "AlarmTypeViewController.h"

@interface AlamSettingViewController ()<MINSwtichViewDelegate, MINPickerViewDelegate>
{
    AlamSettingView *notiView;
    AlamSettingView *voiceView;
    AlamSettingView *shakeView;
    AlamSettingView *setAlarmTypeView;
    AlamSettingView *wholeDayView;
}
@property (nonatomic, strong) UILabel *wholeStartTimeLabel;
@property (nonatomic, strong) UILabel *wholeEndTimeLabel;
@property (nonatomic, strong) UIButton *wholeStartTimeBtn;
@property (nonatomic, strong) UIButton *wholeEndTimeBtn;
@property (nonatomic, copy) NSArray *dateArr;
@end

@implementation AlamSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    self.dateArr = @[@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"],@[@"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55"],@[@"上午",@"下午"]];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle: Localized(@"设置") isBack: YES];
    [self showBackGround];
    AlamSettingView *lastView = nil;
    for (int i = 0; i < 5; i++) {
        AlamSettingView *view = [[AlamSettingView alloc] init];
        [self.view addSubview: view];
        if (lastView == nil) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
                make.top.equalTo(self.view).with.offset(kNavAndStatusHeight + 12.5 * KFitHeightRate);
                make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
                make.height.mas_equalTo(50 * KFitHeightRate);
            }];
        }else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
                make.top.equalTo(lastView.mas_bottom).with.offset(12.5 * KFitHeightRate);
                make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
                make.height.mas_equalTo(50 * KFitHeightRate);
            }];
        }
        view.alramSwitch.delegate = self;
        lastView = view;
        if (i == 0) {
            notiView = view;
        }else if (i == 1){
            voiceView = view;
        }else if (i == 2){
            shakeView = view;
        }else if (i == 3){
            setAlarmTypeView = view;
            [setAlarmTypeView.detailBtn addTarget: self action: @selector(setAlarmTypeViewDetailBtnClick) forControlEvents: UIControlEventTouchUpInside];
            [setAlarmTypeView changeViewType];
        }else if (i == 4){
            wholeDayView = view;
            [wholeDayView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(150 * KFitHeightRate);
            }];
            UIView *topLineView = [MINUtils createLineView];
            [wholeDayView addSubview: topLineView];
            [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(wholeDayView);
                make.top.equalTo(wholeDayView).with.offset(50 * KFitHeightRate);
                make.height.mas_equalTo(0.5);
            }];
            UIView *middleLineView = [MINUtils createLineView];
            [wholeDayView addSubview: middleLineView];
            [middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(wholeDayView).with.offset(12.5 * KFitWidthRate);
                make.right.equalTo(wholeDayView).with.offset(-12.5 * KFitWidthRate);
                make.top.equalTo(wholeDayView).with.offset(100 * KFitHeightRate);
                make.height.mas_equalTo(0.5);
            }];
            _wholeStartTimeLabel = [MINUtils createLabelWithText: @"开始时间：08:00" size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: k137Color];
            [wholeDayView addSubview: _wholeStartTimeLabel];
            [_wholeStartTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(topLineView.mas_bottom);
                make.bottom.equalTo(middleLineView);
                make.left.equalTo(wholeDayView).with.offset(12.5 * KFitWidthRate);
                make.width.mas_equalTo(300);
            }];
            _wholeEndTimeLabel = [MINUtils createLabelWithText: @"结束时间：22:00" size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: k137Color];
            [wholeDayView addSubview: _wholeEndTimeLabel];
            [_wholeEndTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(middleLineView.mas_bottom);
                make.bottom.equalTo(wholeDayView);
                make.left.equalTo(wholeDayView).with.offset(12.5 * KFitWidthRate);
                make.width.mas_equalTo(300);
            }];
            _wholeStartTimeBtn = [[UIButton alloc] init];
            [wholeDayView addSubview: _wholeStartTimeBtn];
            [_wholeStartTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(wholeDayView);
                make.bottom.top.equalTo(_wholeStartTimeLabel);
            }];
            [_wholeStartTimeBtn addTarget: self action: @selector(wholeStartTimeBtnClick) forControlEvents: UIControlEventTouchUpInside];
            _wholeEndTimeBtn = [[UIButton alloc] init];
            [wholeDayView addSubview: _wholeEndTimeBtn];
            [_wholeEndTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(wholeDayView);
                make.bottom.top.equalTo(_wholeEndTimeLabel);
            }];
            [_wholeEndTimeBtn addTarget: self action: @selector(wholeEndTimeBtnClick) forControlEvents: UIControlEventTouchUpInside];
            self.wholeStartTimeBtn.enabled = NO;
            self.wholeEndTimeBtn.enabled = NO;
        }
    }
}

#pragma mark - Action
- (void)setAlarmTypeViewDetailBtnClick
{
    AlarmTypeViewController *tyepVC = [[AlarmTypeViewController alloc] init];
    [self.navigationController pushViewController: tyepVC animated: YES];
}

- (void)wholeStartTimeBtnClick
{
    MINPickerView *pickerView = [[MINPickerView alloc] init];
    pickerView.titleLabel.text = @"开始时间";
    pickerView.dataArr = self.dateArr;
    pickerView.delegate = self;
    [self.view addSubview: pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    [pickerView showView];
}

- (void)wholeEndTimeBtnClick
{
    MINPickerView *pickerView = [[MINPickerView alloc] init];
    pickerView.titleLabel.text = @"结束时间";
    pickerView.dataArr = self.dateArr;
    pickerView.delegate = self;
    [self.view addSubview: pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    [pickerView showView];
}

#pragma mark - MINSwtichViewDelegate
- (void)switchView:(MINSwitchView *)switchView stateChange:(BOOL)isON
{
    if (switchView == notiView.alramSwitch) {
        NSLog(@"%d", isON);
    }else if (switchView == voiceView.alramSwitch) {
        
    }else if (switchView == shakeView.alramSwitch) {
        
    }else if (switchView == setAlarmTypeView.alramSwitch) {
        
    }else if (switchView == wholeDayView.alramSwitch) {
        if (isON == YES) {
            self.wholeStartTimeBtn.enabled = YES;
            self.wholeEndTimeBtn.enabled = YES;
        }else {
            self.wholeStartTimeBtn.enabled = NO;
            self.wholeEndTimeBtn.enabled = NO;
        }
    }
    
}
#pragma mark - MINPickerViewDelegate
- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic
{
    //    NSLog(@"%@", dic);
    NSNumber *hourNumber = dic[@"0"];
    NSNumber *minNum = dic[@"1"];
    NSNumber *lastNum = dic[@"2"];
    int hour = [hourNumber intValue] + 1;
    int min = [minNum intValue] * 5;
    if ([lastNum intValue] == 1) {
        hour += 12;
    }
    if ([pickerView.titleLabel.text isEqualToString: @"开始时间"]) {
        
        self.wholeStartTimeLabel.text = [NSString stringWithFormat: @"开始时间：%02d:%02d", hour, min];
    }else {
        self.wholeEndTimeLabel.text = [NSString stringWithFormat: @"结束时间：%02d:%02d", hour, min];
    }
}

#pragma mark - Other Method
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
