//
//  TimingSwitchViewController.m
//  Watch
//
//  Created by lym on 2018/2/26.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "TimingSwitchViewController.h"
#import "SwitchHeaderView.h"
#import "SwitchView.h"
#import "MINSwitchView.h"
#import "TimePeriodView.h"
#import "MINPickerView.h"
#import "FuctionSwitchModel.h"

@interface TimingSwitchViewController () <MINPickerViewDelegate>
{
    UIView *timmingView;
    TimePeriodView *timingPowerOnView;
    TimePeriodView *timingPowerOffView;
    SwitchHeaderView *headerView;
}
@property (nonatomic, assign) BOOL isEdited;
@property (nonatomic, strong) NSArray *dateArr;
@property (nonatomic, copy) NSString *lastStartTimeStr; // 上一次定时开机时间
@property (nonatomic, copy) NSString *lastEndTimeStr; // 上一次定时关机时间
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation TimingSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lastStartTimeStr = self.model.openTime;
    self.lastEndTimeStr = self.model.closeTime;
    [self createUI];
    [self addAction];
     self.dateArr = @[@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"],@[@"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55"],@[@"上午",@"下午"]];
    [self createMainViewBlock];
    [self isEditTimingView: NO];
    [self changeHeaderViewSwitchStatus: self.model.shutdownAction];
}

- (void)createMainViewBlock
{
    __weak __typeof__(self) weakSelf = self;
    timingPowerOnView.timeSelectBtnClickBlock = ^{
        [weakSelf showPickerWithFlag: 0];
    };
    timingPowerOffView.timeSelectBtnClickBlock = ^{
        [weakSelf showPickerWithFlag: 1];
    };
}

- (void)showPickerWithFlag:(NSInteger)flag
{
    if (headerView.swtichView.switchView.isON == YES) {
        MINPickerView *pickerView = [[MINPickerView alloc] init];
        pickerView.titleLabel.text = @"";
        pickerView.flag = flag;
        pickerView.dataArr = self.dateArr;
        pickerView.delegate = self;
        [self.view addSubview: pickerView];
        [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_equalTo(SCREEN_WIDTH);
        }];
        [pickerView showView];
    }
}

#pragma mark - CreateAction
- (void)addAction
{
    [self.saveBtn addTarget: self action: @selector(saveBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.cancelBtn addTarget: self action: @selector(cancelBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)saveBtnClick
{
    [self requestChangeTime];
}

- (void)cancelBtnClick
{
    timingPowerOnView.timeLabel.text = self.lastStartTimeStr;
    timingPowerOffView.timeLabel.text = self.lastEndTimeStr;
    [self isEditTimingView: NO];
}

#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = KWtRGB(230, 230, 230);
    [self initBarWithTitle: @"定时开关机" isBack: YES];
    headerView = [[SwitchHeaderView alloc] init];
    headerView.swtichView.switchView.isON = YES;
    headerView.swtichView.titleLabel.text = @"定时开关机";
    headerView.imageView.image = [UIImage imageNamed: @"定时开关"];
    __weak __typeof__(self) weakSelf = self;
    __weak __typeof__(SwitchHeaderView *)weakHeaderView = headerView;
    headerView.switchStatusChange = ^(BOOL isOn) {
        [weakSelf requestChangeSwitchStatus: isOn];
    };
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * (5.0 / 7.5));
    [self.view addSubview: headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_topMargin);
        }
        make.height.mas_equalTo(SCREEN_WIDTH * (5.0 / 7.5));
    }];
    timmingView = [[UIView alloc] init];
    timmingView.backgroundColor = [UIColor whiteColor];
    timmingView.layer.cornerRadius = 4 * KFitWidthRate;
    [self.view addSubview: timmingView];
    [timmingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(headerView.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(100 * KFitWidthRate);
    }];
    timingPowerOnView = [[TimePeriodView alloc] init];
    [timingPowerOnView setLeftRGB137WithDetailImageTitleLabelText: @"定时开机时间" timeLabelText: self.lastStartTimeStr];
    [CBWtMINUtils addLineToView: timingPowerOnView isTop: NO hasSpaceToSide: YES];
    [timmingView addSubview: timingPowerOnView];
    [timingPowerOnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timmingView);
        make.left.right.equalTo(timmingView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    timingPowerOffView = [[TimePeriodView alloc] init];
    [timingPowerOffView setLeftRGB137WithDetailImageTitleLabelText: @"定时关机时间" timeLabelText: self.lastEndTimeStr];
    [timmingView addSubview: timingPowerOffView];
    [timingPowerOffView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timingPowerOnView.mas_bottom);
        make.left.right.equalTo(timmingView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    self.cancelBtn = [CBWtMINUtils createNoBorderBtnWithTitle: @"取消" titleColor: KWtBlueColor fontSize: 15 * KFitWidthRate backgroundColor: [UIColor whiteColor] Radius: 20 * KFitWidthRate];
    [self.view addSubview: self.cancelBtn];
    self.saveBtn = [CBWtMINUtils createNoBorderBtnWithTitle: @"保存" titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: KWtBlueColor Radius: 20 * KFitWidthRate];
    [self.view addSubview: self.saveBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(30 * KFitWidthRate);
        make.height.mas_equalTo(40 * KFitWidthRate);
        make.right.equalTo(self.saveBtn.mas_left).with.offset(-12.5 * KFitWidthRate);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(-25 * KFitWidthRate);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view.mas_bottomMargin).with.offset(25 * KFitWidthRate);
        }
    }];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-30 * KFitWidthRate);
        make.height.mas_equalTo(40 * KFitWidthRate);
        make.width.equalTo(self.cancelBtn);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(-25 * KFitWidthRate);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view.mas_bottomMargin).with.offset(25 * KFitWidthRate);
        }
    }];
}

- (void)requestChangeSwitchStatus:(BOOL)isOn
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";
    MBProgressHUD *hud = [CBWtMINUtils hudToView: self.view withText: Localized(@"MINHud_Loading")];
    dic[@"shutdownAction"] = [NSNumber numberWithBool: isOn];
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/updSwitchStatus" params: dic succeed:^(id response, BOOL isSucceed) {
        if (!isSucceed) {
            [weakSelf changeHeaderViewSwitchStatus: !isOn];
        }
        [hud hideAnimated: YES];
    } failed:^(NSError *error) {
        [hud hideAnimated: YES];
    }];
}

- (void)changeHeaderViewSwitchStatus:(BOOL)status
{
    if (status == YES) {
        headerView.swtichView.switchView.isON = YES;
        headerView.swtichView.statusLabel.text = @"已开启";
    }else {
        headerView.swtichView.switchView.isON = NO;
        headerView.swtichView.statusLabel.text = @"已关闭";
    }
}

- (void)isEditTimingView:(BOOL)isEidt
{
    if (isEidt == NO) {
        self.isEdited = NO;
        self.cancelBtn.hidden = YES;
        self.saveBtn.hidden = YES;
    }else {
        self.isEdited = YES;
        self.cancelBtn.hidden = NO;
        self.saveBtn.hidden = NO;
    }
}

#pragma mark - MINPickerViewDelegate
- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic
{
    NSNumber *hourNumber = dic[@"0"];
    NSNumber *minNum = dic[@"1"];
    NSNumber *lastNum = dic[@"2"];
    int hour = [hourNumber intValue] + 1;
    int min = [minNum intValue] * 5;
    if ([lastNum intValue] == 1) {
        hour += 12;
    }
    NSString *time = [NSString stringWithFormat: @"%02d:%02d", hour, min];
    if (pickerView.flag == 0) { // timingPowerOnView
        timingPowerOnView.timeLabel.text = time;
    }else if (pickerView.flag == 1) { // timingPowerOffView
        timingPowerOffView.timeLabel.text = time;
    }
    [self isEditTimingView: YES];
}

- (void)requestChangeTime
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";
    MBProgressHUD *hud = [CBWtMINUtils hudToView: self.view withText: Localized(@"MINHud_Loading")];
    dic[@"openTime"] = timingPowerOnView.timeLabel.text;
    dic[@"closeTime"] = timingPowerOffView.timeLabel.text;
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/updSwitchStatus" params: dic succeed:^(id response, BOOL isSucceed) {
        if (isSucceed) {
            weakSelf.lastStartTimeStr = timingPowerOnView.timeLabel.text;
            weakSelf.lastEndTimeStr = timingPowerOffView.timeLabel.text;
            [weakSelf isEditTimingView: NO];
        }else {
            timingPowerOnView.timeLabel.text = weakSelf.lastStartTimeStr;
            timingPowerOffView.timeLabel.text = weakSelf.lastEndTimeStr;
        }
        [hud hideAnimated: YES];
    } failed:^(NSError *error) {
        [hud hideAnimated: YES];
    }];
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
