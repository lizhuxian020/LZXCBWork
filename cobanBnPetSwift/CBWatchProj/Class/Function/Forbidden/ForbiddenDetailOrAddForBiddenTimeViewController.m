//
//  ForbiddenDetailOrAddForBiddenTimeViewController.m
//  Watch
//
//  Created by lym on 2018/2/22.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "ForbiddenDetailOrAddForBiddenTimeViewController.h"
#import "MINScrollView.h"
#import "TimePeriodView.h"
#import "MINPickerView.h"
#import "TimeRepeatViewController.h"
#import "CBWtMINAlertView.h"
#import "ForbiddenInClassModel.h"

@interface ForbiddenDetailOrAddForBiddenTimeViewController () <MINPickerViewDelegate, TimeRepeatViewControllerDelegate>
{
    TimePeriodView *nameTimePeriodView;
    TimePeriodView *morningTimePeriodView;
    TimePeriodView *morningStartTimePeriodView;
    TimePeriodView *morningEndTimePeriodView;
    TimePeriodView *afternoonTimePeriodView;
    TimePeriodView *afternoonStartTimePeriodView;
    TimePeriodView *afternoonEndTimePeriodView;
    TimePeriodView *repeatTimePeriodView;
}
@property (nonatomic, strong) MINScrollView *minScrollView;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) NSArray *dateArr;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableDictionary *editDic;
@end

@implementation ForbiddenDetailOrAddForBiddenTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.isEdit == NO) {
        self.editDic = [NSMutableDictionary dictionary];
        self.editDic[@"startAm"] = @"06:30";
        self.editDic[@"endAm"] = @"06:30";
        self.editDic[@"startPm"] = @"06:30";
        self.editDic[@"endPm"] = @"06:30";
        self.editDic[@"repeat"] = @"1,2,3,4,5";
        self.editDic[@"name"] = Localized(@"禁用时段2");
    }
    NSMutableArray *arrayHour = [NSMutableArray array];
    NSMutableArray *arrayMinute = [NSMutableArray array];
    for (int i = 0 ; i < 60 ; i ++ ) {
        [arrayMinute addObject:[NSString stringWithFormat:@"%02d",i]];
        if (i < 24) {
            [arrayHour addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    //@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"]
    //@[@"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55"]
    //@[Localized(@"上午-禁用时间段"),Localized(@"下午-禁用时间段")]
    self.dateArr = @[arrayHour,arrayMinute];
    
    [self createUI];
    [self addAction];
    if (self.isEdit == YES) {
        [self initModelData];
        self.editDic = [NSMutableDictionary dictionary];
        self.editDic[@"startAm"] = self.model.startAm;
        self.editDic[@"endAm"] = self.model.endAm;
        self.editDic[@"startPm"] = self.model.startPm;
        self.editDic[@"endPm"] = self.model.endPm;
        self.editDic[@"repeat"] = self.model.repeat;
        self.editDic[@"name"] = self.model.name;
    }
}

- (void)initModelData {
    [nameTimePeriodView setLeftRGB73BigFontRightWithoutDetailImageTitleLabelText:Localized(@"名称") timeLabelText: self.model.name];
    [morningStartTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:Localized(@"开始时间:") timeLabelText: self.model.startAm];
    [morningEndTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:Localized(@"结束时间:") timeLabelText: self.model.endAm];
    [afternoonStartTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:Localized(@"开始时间:") timeLabelText: self.model.startPm];
    [afternoonEndTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:Localized(@"结束时间:") timeLabelText: self.model.endPm];
    NSString *timeString = [self getReatTimeWithString: self.model.repeat];
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
#pragma mark - CreateUI
- (void)createUI {
    self.view.backgroundColor = KWtBackColor;
    if (self.isEdit == YES) {
        [self initBarWithTitle:Localized(@"禁用详情") isBack: YES];
        [self initBarRighBtnTitle:Localized(@"删除") target: self action: @selector(rightBtnClick)];
    } else {
        [self initBarWithTitle:Localized(@"添加禁用时间段") isBack: YES];
    }
    [self createMainView];
    [self createMainViewBlock];
}
- (void)createMainViewBlock {
    __weak __typeof__(self) weakSelf = self;
    //if (self.isEdit == NO) {
        __weak __typeof__(TimePeriodView *) weakNameTimePeriodView = nameTimePeriodView;
        nameTimePeriodView.timeSelectBtnClickBlock = ^{
            CBWtMINAlertView *alertView = [[CBWtMINAlertView alloc] init];
            alertView.titleLabel.text = Localized(@"请输入名称");
            [alertView showRightCloseBtn];
            [weakSelf.view addSubview: alertView];
            [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(weakSelf.view);
                make.height.mas_equalTo(SCREEN_HEIGHT);
            }];
            [alertView setContentViewHeight:80];
            __weak __typeof__(CBWtMINAlertView *) weakAlertView = alertView;
            weakSelf.textField = [CBWtMINUtils createTextFieldWithHoldText:Localized(@"请输入名称") fontSize: 15 * KFitWidthRate];
            weakSelf.textField.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 25 * KFitWidthRate,  40 * KFitWidthRate)];
            weakSelf.textField.layer.cornerRadius = 20 * KFitWidthRate;
            weakSelf.textField.leftViewMode = UITextFieldViewModeAlways;
            weakSelf.textField.backgroundColor = KWtRGB(240, 240, 240);
            [alertView.contentView addSubview: weakSelf.textField];
            [weakSelf.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(alertView.contentView);
                make.centerY.equalTo(alertView.contentView).with.offset(-5 * KFitHeightRate);
                make.height.mas_equalTo(40 * KFitWidthRate);
                make.width.mas_equalTo(250 * KFitWidthRate);
            }];
            alertView.leftBtnClick = ^{
                weakNameTimePeriodView.timeLabel.text = weakSelf.textField.text;
                weakSelf.editDic[@"name"] = weakSelf.textField.text;
                [weakAlertView hideView];
            };
        };
    //}
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
    repeatTimePeriodView.timeSelectBtnClickBlock = ^{
        TimeRepeatViewController *timeRepeatVC = [[TimeRepeatViewController alloc] init];
        timeRepeatVC.delegate = weakSelf;
        [weakSelf.navigationController pushViewController: timeRepeatVC animated: YES];
    };
}

- (void)showPickerWithFlag:(NSInteger)flag {
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

- (void)createMainView {
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
    nameTimePeriodView = [[TimePeriodView alloc] init];
    if (self.isEdit == YES) {
        [nameTimePeriodView setLeftRGB73BigFontRightWithoutDetailImageTitleLabelText:Localized(@"名称") timeLabelText:self.model.name?:@""];
    }else {
        [nameTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:Localized(@"名称") timeLabelText:Localized(@"禁用时段2")];
    }
    [self.minScrollView.contentView addSubview: nameTimePeriodView];
    [nameTimePeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.minScrollView.contentView).with.offset(12.5 * KFitWidthRate);
        make.left.right.equalTo(self.minScrollView.contentView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    
    morningTimePeriodView = [[TimePeriodView alloc] init];
    [morningTimePeriodView setLeftRGB73WithoutDetailImageTitleLabelText:Localized(@"上午-禁用时间段") timeLabelText: @""];
    [CBWtMINUtils addLineToView: morningTimePeriodView isTop: NO hasSpaceToSide: NO];
    [self.minScrollView.contentView addSubview: morningTimePeriodView];
    [morningTimePeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTimePeriodView.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.left.right.equalTo(self.minScrollView.contentView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    morningStartTimePeriodView = [[TimePeriodView alloc] init];
    [morningStartTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:Localized(@"开始时间:") timeLabelText: @"06:30"];
    [CBWtMINUtils addLineToView: morningStartTimePeriodView isTop: NO hasSpaceToSide: YES];
    [self.minScrollView.contentView addSubview: morningStartTimePeriodView];
    [morningStartTimePeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(morningTimePeriodView.mas_bottom);
        make.left.right.equalTo(self.minScrollView.contentView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    morningEndTimePeriodView = [[TimePeriodView alloc] init];
    [morningEndTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:Localized(@"结束时间:") timeLabelText: @"06:30"];
    [self.minScrollView.contentView addSubview: morningEndTimePeriodView];
    [morningEndTimePeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(morningStartTimePeriodView.mas_bottom);
        make.left.right.equalTo(self.minScrollView.contentView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    afternoonTimePeriodView = [[TimePeriodView alloc] init];
    [afternoonTimePeriodView setLeftRGB73WithoutDetailImageTitleLabelText:Localized(@"下午-禁用时间段") timeLabelText: @""];
    [CBWtMINUtils addLineToView: afternoonTimePeriodView isTop: NO hasSpaceToSide: NO];
    [self.minScrollView.contentView addSubview: afternoonTimePeriodView];
    [afternoonTimePeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(morningEndTimePeriodView.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.left.right.equalTo(self.minScrollView.contentView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    afternoonStartTimePeriodView = [[TimePeriodView alloc] init];
    [afternoonStartTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:Localized(@"开始时间:") timeLabelText: @"06:30"];
    [CBWtMINUtils addLineToView: afternoonStartTimePeriodView isTop: NO hasSpaceToSide: YES];
    [self.minScrollView.contentView addSubview: afternoonStartTimePeriodView];
    [afternoonStartTimePeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(afternoonTimePeriodView.mas_bottom);
        make.left.right.equalTo(self.minScrollView.contentView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    afternoonEndTimePeriodView = [[TimePeriodView alloc] init];
    [afternoonEndTimePeriodView setLeftRGB137WithDetailImageTitleLabelText:Localized(@"结束时间:") timeLabelText: @"06:30"];
    [self.minScrollView.contentView addSubview: afternoonEndTimePeriodView];
    [afternoonEndTimePeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(afternoonStartTimePeriodView.mas_bottom);
        make.left.right.equalTo(self.minScrollView.contentView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    repeatTimePeriodView = [[TimePeriodView alloc] init];
    NSString *timeString = [self getReatTimeWithString:self.editDic[@"repeat"]];
    [repeatTimePeriodView setLeftRGB73WithDetailImageTitleLabelText:Localized(@"重复") timeLabelText: timeString];
    //[repeatTimePeriodView setLeftRGB73WithDetailImageTitleLabelText:Localized(@"重复") timeLabelText:Localized(@"未知")];
    [self.minScrollView.contentView addSubview: repeatTimePeriodView];
    [repeatTimePeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(afternoonEndTimePeriodView.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.left.right.equalTo(self.minScrollView.contentView);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    self.saveBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"保存") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: KWtBlueColor];
    self.saveBtn.layer.cornerRadius = 20 * KFitWidthRate;
    [self.minScrollView.contentView addSubview: self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(repeatTimePeriodView.mas_bottom).with.offset(85 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(150 * KFitWidthRate, 40 * KFitWidthRate));
        make.centerX.equalTo(self.minScrollView.contentView);
    }];
    [self.minScrollView.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.saveBtn.mas_bottom).with.offset(12.5 * KFitWidthRate);
    }];
}
#pragma mark - Action
- (void)addAction {
    [self.saveBtn addTarget: self action: @selector(saveBtnClick) forControlEvents: UIControlEventTouchUpInside];
}
#pragma mark -- 编辑上课禁用时间段
- (void)saveBtnClick {
    if (self.isEdit == YES) {
        if ([[self.editDic allKeys] count] > 0) {
            self.editDic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
            self.editDic[@"id"] = self.model.forbiddenId;
            [MBProgressHUD showHUDIcon:self.view animated:YES];
            kWeakSelf(self);
            [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/updClassForbid" params: self.editDic succeed:^(id response, BOOL isSucceed) {
                kStrongSelf(self);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (isSucceed ) {
                    [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"修改成功")];
                    [self.navigationController popViewControllerAnimated: YES];
                }
            } failed:^(NSError *error) {
                kStrongSelf(self);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }else {
            [CBWtMINUtils showProgressHudToView: self.view withText: @"请先修改信息"];
        }
    } else {
        self.editDic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
        [MBProgressHUD showHUDIcon:self.view animated:YES];
        kWeakSelf(self);
        [[CBWtNetWorkingManager shared] postWithUrl:@"watch/watch/addClassForbid" params: self.editDic succeed:^(id response, BOOL isSucceed) {
            kStrongSelf(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (isSucceed ) {
                [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"添加成功")];
                [self.navigationController popViewControllerAnimated: YES];
            }
        } failed:^(NSError *error) {
            kStrongSelf(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}
#pragma mark -- 删除上课禁用时间段
- (void)rightBtnClick
{
    self.editDic[@"id"] = self.model.forbiddenId;
    self.editDic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/delClassForbid" params: self.editDic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed ) {
            [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"删除成功")];
            [self.navigationController popViewControllerAnimated: YES];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - MINPickerViewDelegate
- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic {
    NSLog(@"===%@===",dic);
    NSNumber *hourNumber = dic[@"0"];
    NSNumber *minNum = dic[@"1"];
    //NSNumber *lastNum = dic[@"2"];
    int hour = [hourNumber intValue];//[hourNumber intValue] + 1;
    int min = [minNum intValue];//[minNum intValue] * 5;
//    if ([lastNum intValue] == 1) {
//        hour += 12;
//    }
    NSString *timeString = [NSString stringWithFormat: @"%02d:%02d", hour, min];
    if (pickerView.flag == 0) { // morningStartTimePeriodView
        self.editDic[@"startAm"] = timeString;
        morningStartTimePeriodView.timeLabel.text = timeString;
    }else if (pickerView.flag == 1) { // morningEndTimePeriodView
        self.editDic[@"endAm"] = timeString;
        morningEndTimePeriodView.timeLabel.text = timeString;
    }else if (pickerView.flag == 2) { // afternoonStartTimePeriodView
        self.editDic[@"startPm"] = timeString;
        afternoonStartTimePeriodView.timeLabel.text = timeString;
    }else if (pickerView.flag == 3) { // afternoonEndTimePeriodView
        self.editDic[@"endPm"] = timeString;
        afternoonEndTimePeriodView.timeLabel.text = timeString;
    }
}

#pragma mark - TimeRepeatViewControllerDelegate
- (void)timeRepeatViewControllerDidSelectTime:(NSString *)time
{
    NSString *timeString = [self getReatTimeWithString: time];
    self.editDic[@"repeat"] = time;
    [repeatTimePeriodView setLeftRGB73WithDetailImageTitleLabelText:Localized(@"重复") timeLabelText:timeString];
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
