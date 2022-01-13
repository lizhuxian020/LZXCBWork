//
//  SetTimePeriodViewController.m
//  Watch
//
//  Created by lym on 2018/2/9.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "SetTimePeriodViewController.h"
#import "MINScrollView.h"
#import "TimePeriodView.h"
#import "MINPickerView.h"
#import "TimeRepeatViewController.h"
#import "GuardIndoModel.h"

@interface SetTimePeriodViewController () <MINPickerViewDelegate, TimeRepeatViewControllerDelegate>
{
    TimePeriodView *morningTimePeriodView;
    TimePeriodView *morningStartTimePeriodView;
    TimePeriodView *morningEndTimePeriodView;
    TimePeriodView *afternoonTimePeriodView;
    TimePeriodView *afternoonStartTimePeriodView;
    TimePeriodView *afternoonEndTimePeriodView;
    TimePeriodView *atLatestGoHomeTimePeriodView;
    TimePeriodView *repeatTimePeriodView;
}
@property (nonatomic, strong) MINScrollView *minScrollView;
@property (nonatomic, strong) NSMutableArray *dateArr;//NSArray *dateArr;
@property (nonatomic, strong) NSMutableDictionary *editDic;
@end

@implementation SetTimePeriodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
//    self.dateArr = @[@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"],@[@"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55"],@[@"上午",@"下午"]];
    
    NSMutableArray *arrayHour = [NSMutableArray array];
    NSMutableArray *arrayMinute = [NSMutableArray array];
    for (int i = 0 ; i < 60 ; i ++ ) {
        [arrayMinute addObject:[NSString stringWithFormat:@"%02d",i]];
        if (i < 24) {
            [arrayHour addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    //@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"]
    self.dateArr = [NSMutableArray array];
    //NSArray *arrayHours = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    [self.dateArr addObject:arrayHour];
    
//    NSMutableArray *arrayDay = [NSMutableArray array];
//    for (int i = 0 ; i < 60 ; i ++ ) {
//        [arrayDay addObject:[NSString stringWithFormat:@"%02d",i]];
//    }
    [self.dateArr addObject:arrayMinute];
    
    //[self.dateArr addObject:@[Localized(@"上午-守护"),Localized(@"下午-守护")]];
}
- (NSMutableDictionary *)editDic {
    if (!_editDic) {
        _editDic = [NSMutableDictionary dictionary];
        [_editDic setObject:self.model.inAm?:@"" forKey:@"inAm"];
        [_editDic setObject:self.model.outAm?:@"" forKey:@"outAm"];
        [_editDic setObject:self.model.inPm?:@"" forKey:@"inPm"];
        [_editDic setObject:self.model.outPm?:@"" forKey:@"outPm"];
        [_editDic setObject:self.model.backTime?:@"" forKey:@"backTime"];
        [_editDic setObject:self.model.repeat?:@"" forKey:@"repeat"];
    }
    return _editDic;
}
#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"设置时间段") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"保存") target: self action: @selector(rightBtnClick)];
    [self createMainView];
    [self createMainViewBlock];
    [self initModelData];
}
- (void)createMainView
{
    self.minScrollView = [[MINScrollView alloc] init];
    [self.view addSubview: self.minScrollView];
    [self.minScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_topMargin);
        }
    }];
    morningTimePeriodView = [[TimePeriodView alloc] init];
    [morningTimePeriodView setLeftRGB73WithoutDetailImageTitleLabelText:Localized(@"上午-守护") timeLabelText: @"上学时间段: 06:30 - 11:30"];
    [CBWtMINUtils addLineToView: morningTimePeriodView isTop: NO hasSpaceToSide: NO];
    [self.minScrollView.contentView addSubview: morningTimePeriodView];
    [morningTimePeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.minScrollView.contentView).with.offset(12.5 * KFitWidthRate);
        make.left.right.equalTo(self.minScrollView.contentView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    morningStartTimePeriodView = [[TimePeriodView alloc] init];
    [morningStartTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:[NSString stringWithFormat:@"%@:",Localized(@"到校时间")] timeLabelText: @"06:30"];
    [CBWtMINUtils addLineToView: morningStartTimePeriodView isTop: NO hasSpaceToSide: YES];
    [self.minScrollView.contentView addSubview: morningStartTimePeriodView];
    [morningStartTimePeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(morningTimePeriodView.mas_bottom);
        make.left.right.equalTo(self.minScrollView.contentView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    morningEndTimePeriodView = [[TimePeriodView alloc] init];
    [morningEndTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:[NSString stringWithFormat:@"%@:",Localized(@"离校时间")] timeLabelText: @"06:30"];
    [self.minScrollView.contentView addSubview: morningEndTimePeriodView];
    [morningEndTimePeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(morningStartTimePeriodView.mas_bottom);
        make.left.right.equalTo(self.minScrollView.contentView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    afternoonTimePeriodView = [[TimePeriodView alloc] init];
    [afternoonTimePeriodView setLeftRGB73WithoutDetailImageTitleLabelText:Localized(@"下午-守护") timeLabelText: @"放学时间段: 06:30 - 11:30"];
    [CBWtMINUtils addLineToView: afternoonTimePeriodView isTop: NO hasSpaceToSide: NO];
    [self.minScrollView.contentView addSubview: afternoonTimePeriodView];
    [afternoonTimePeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(morningEndTimePeriodView.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.left.right.equalTo(self.minScrollView.contentView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    afternoonStartTimePeriodView = [[TimePeriodView alloc] init];
    [afternoonStartTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:[NSString stringWithFormat:@"%@:",Localized(@"到校时间")] timeLabelText: @"06:30"];
    [CBWtMINUtils addLineToView: afternoonStartTimePeriodView isTop: NO hasSpaceToSide: YES];
    [self.minScrollView.contentView addSubview: afternoonStartTimePeriodView];
    [afternoonStartTimePeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(afternoonTimePeriodView.mas_bottom);
        make.left.right.equalTo(self.minScrollView.contentView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    afternoonEndTimePeriodView = [[TimePeriodView alloc] init];
    [afternoonEndTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:[NSString stringWithFormat:@"%@:",Localized(@"离校时间")] timeLabelText: @"06:30"];
    [self.minScrollView.contentView addSubview: afternoonEndTimePeriodView];
    [afternoonEndTimePeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(afternoonStartTimePeriodView.mas_bottom);
        make.left.right.equalTo(self.minScrollView.contentView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    atLatestGoHomeTimePeriodView = [[TimePeriodView alloc] init];
    [atLatestGoHomeTimePeriodView setLeftRGB73WithDetailImageTitleLabelText:Localized(@"最晚到家") timeLabelText: @"11:30"];
    [CBWtMINUtils addLineToView: atLatestGoHomeTimePeriodView isTop: NO hasSpaceToSide: YES];
    [self.minScrollView.contentView addSubview: atLatestGoHomeTimePeriodView];
    [atLatestGoHomeTimePeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(afternoonEndTimePeriodView.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.left.right.equalTo(self.minScrollView.contentView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    repeatTimePeriodView = [[TimePeriodView alloc] init];
    [repeatTimePeriodView setLeftRGB73WithDetailImageTitleLabelText:Localized(@"重复") timeLabelText: @"周一到周五"];
    [self.minScrollView.contentView addSubview: repeatTimePeriodView];
    [repeatTimePeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(atLatestGoHomeTimePeriodView.mas_bottom);
        make.left.right.equalTo(self.minScrollView.contentView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    [self.minScrollView.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(repeatTimePeriodView).with.offset(12.5 * KFitWidthRate);
    }];
}
- (void)initModelData
{
    if (self.model != nil) {
        NSString *morningString = [NSString stringWithFormat: @"%@: %@ - %@", Localized(@"上学时间段"),self.model.inAm, self.model.outAm];
        NSString *afternoonString = [NSString stringWithFormat: @"%@: %@ - %@",Localized(@"放学时间段") ,self.model.inPm, self.model.outPm];
        [morningTimePeriodView setLeftRGB73WithoutDetailImageTitleLabelText:Localized(@"上午-守护") timeLabelText: morningString];
        [morningStartTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:[NSString stringWithFormat:@"%@:",Localized(@"到校时间")] timeLabelText: self.model.inAm];
        [morningEndTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:[NSString stringWithFormat:@"%@:",Localized(@"离校时间")] timeLabelText: self.model.outAm];
        [afternoonTimePeriodView setLeftRGB73WithoutDetailImageTitleLabelText:Localized(@"下午-守护") timeLabelText: afternoonString];
        [afternoonStartTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:[NSString stringWithFormat:@"%@:",Localized(@"到校时间")] timeLabelText: self.model.inPm];
        [afternoonEndTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:[NSString stringWithFormat:@"%@:",Localized(@"离校时间")] timeLabelText: self.model.outPm];
        [atLatestGoHomeTimePeriodView setLeftRGB73WithDetailImageTitleLabelText:Localized(@"最晚到家") timeLabelText: self.model.backTime];
        NSString *timeString = [self getReatTimeWithString: self.model.repeat];
        [repeatTimePeriodView setLeftRGB73WithDetailImageTitleLabelText:Localized(@"重复") timeLabelText: timeString];
    }
}

- (void)createMainViewBlock
{
    __weak __typeof__(self) weakSelf = self;
    morningStartTimePeriodView.timeSelectBtnClickBlock = ^{
        [weakSelf showPickerWithFlag: 0];
    };
    morningEndTimePeriodView.timeSelectBtnClickBlock = ^{
        [weakSelf showPickerWithFlag: 1];
    };
    afternoonStartTimePeriodView.timeSelectBtnClickBlock = ^{
        [weakSelf showPickerWithFlag: 2];
    };
    afternoonEndTimePeriodView.timeSelectBtnClickBlock = ^{
        [weakSelf showPickerWithFlag: 3];
    };
    atLatestGoHomeTimePeriodView.timeSelectBtnClickBlock = ^{
        [weakSelf showPickerWithFlag: 4];
    };
    repeatTimePeriodView.timeSelectBtnClickBlock = ^{
        TimeRepeatViewController *timeRepeatVC = [[TimeRepeatViewController alloc] init];
        timeRepeatVC.delegate = weakSelf;
        [weakSelf.navigationController pushViewController: timeRepeatVC animated: YES];
    };
}

#pragma mark - Action
#pragma mark -- 修改上学守护信息
- (void)rightBtnClick
{
    
    if ([[self.editDic allKeys] count] > 0) {
        __weak __typeof__(self) weakSelf = self;
        self.editDic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
        [MBProgressHUD showHUDIcon:self.view animated:YES];
        kWeakSelf(self);
        [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/updGoShcool" params: self.editDic succeed:^(id response, BOOL isSucceed) {
            kStrongSelf(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (isSucceed ) {
                [CBWtMINUtils showProgressHudToView: weakSelf.view withText:Localized(@"修改成功")];
                [weakSelf.navigationController popViewControllerAnimated: YES];
            }
            //[hud hideAnimated: YES];
        } failed:^(NSError *error) {
            //[hud hideAnimated: YES];
            kStrongSelf(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else {
        [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"请先修改守护信息")];
    }
}
- (void)showPickerWithFlag:(NSInteger)flag
{
    MINPickerView *pickerView = [[MINPickerView alloc] init];
    pickerView.titleLabel.text = @"";
    pickerView.flag = flag;
    pickerView.dataArr = self.dateArr;
    pickerView.delegate = self;
    [self.view addSubview: pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    [pickerView showView];
}

#pragma mark - MINPickerViewDelegate
- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic
{
    NSNumber *hourNumber = dic[@"0"];
    NSNumber *minNum = dic[@"1"];
    //NSNumber *lastNum = dic[@"2"];
    int hour = [hourNumber intValue];// + 1;
    int min = [minNum intValue];// * 5;
//    if ([lastNum intValue] == 1) {
//        hour += 12;
//    }
    NSString *timeStr = [NSString stringWithFormat: @"%02d:%02d", hour, min];
    if (pickerView.flag == 0) { // morningStartTimePeriodView
        self.editDic[@"inAm"] = timeStr;
        morningStartTimePeriodView.timeLabel.text = timeStr;
        morningTimePeriodView.timeLabel.text = [NSString stringWithFormat: @"%@: %@ - %@",Localized(@"上学时间段"), morningStartTimePeriodView.timeLabel.text, morningEndTimePeriodView.timeLabel.text];
    }else if (pickerView.flag == 1) { // morningEndTimePeriodView
        self.editDic[@"outAm"] = timeStr;
        morningEndTimePeriodView.timeLabel.text = timeStr;
        morningTimePeriodView.timeLabel.text = [NSString stringWithFormat: @"%@: %@ - %@",Localized(@"上学时间段") ,morningStartTimePeriodView.timeLabel.text, morningEndTimePeriodView.timeLabel.text];
    }else if (pickerView.flag == 2) { // afternoonStartTimePeriodView
        self.editDic[@"inPm"] = timeStr;
        afternoonStartTimePeriodView.timeLabel.text = timeStr;
        afternoonTimePeriodView.timeLabel.text = [NSString stringWithFormat: @"%@: %@ - %@",Localized(@"放学时间段"), afternoonStartTimePeriodView.timeLabel.text, afternoonEndTimePeriodView.timeLabel.text];
    }else if (pickerView.flag == 3) { // afternoonEndTimePeriodView
        self.editDic[@"outPm"] = timeStr;
        afternoonEndTimePeriodView.timeLabel.text = timeStr;
        afternoonTimePeriodView.timeLabel.text = [NSString stringWithFormat: @"%@: %@ - %@",Localized(@"放学时间段"), afternoonStartTimePeriodView.timeLabel.text, afternoonEndTimePeriodView.timeLabel.text];
    }else if (pickerView.flag == 4) { // atLatestGoHomeTimePeriodView
        self.editDic[@"backTime"] = timeStr;
        atLatestGoHomeTimePeriodView.timeLabel.text = timeStr;
    }
}

#pragma mark - TimeRepeatViewControllerDelegate
- (void)timeRepeatViewControllerDidSelectTime:(NSString *)time
{
    
    NSString *timeString = [self getReatTimeWithString: time];
    self.editDic[@"repeat"] = time;
    [repeatTimePeriodView setLeftRGB73WithDetailImageTitleLabelText:Localized(@"重复") timeLabelText: timeString];
}

- (NSString *)getReatTimeWithString:(NSString *)time
{
    NSMutableArray *detailDateArr = [NSMutableArray array];
    NSArray *dateArr = [time componentsSeparatedByString: @","];
    for (int i = 0; i < dateArr.count; i++) {
        if ([dateArr[i] integerValue] == 1) {
            [detailDateArr addObject:Localized(@"周一")];
        }else if ([dateArr[i] integerValue] == 2) {
            [detailDateArr addObject:Localized(@"周二")];
        }else if ([dateArr[i] integerValue] == 3) {
            [detailDateArr addObject:Localized(@"周三")];
        }else if ([dateArr[i] integerValue] == 4) {
            [detailDateArr addObject:Localized(@"周四")];
        }else if ([dateArr[i] integerValue] == 5) {
            [detailDateArr addObject:Localized(@"周五")];
        }else if ([dateArr[i] integerValue] == 6) {
            [detailDateArr addObject:Localized(@"周六")];
        }else if ([dateArr[i] integerValue] == 7) {
            [detailDateArr addObject:Localized(@"周日")];
        }
    }
    return [detailDateArr componentsJoinedByString: @"、"];
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
