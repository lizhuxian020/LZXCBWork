//
//  BarChartViewController.m
//  Telematics
//
//  Created by lym on 2017/11/16.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "BarChartViewController.h"
#import "LineBarChart.h"
#import "LineData.h"
#import "BarData.h"
#import "MINDatePickerView.h"

#import "CBColumnChartView.h"

@interface BarChartViewController () <MINDatePickerViewDelegare>
{
    NSMutableArray *_dataArr_x;
    NSMutableArray *_dataArr_y;
    NSMutableArray *_dataArr_y_right;
    NSMutableArray *_valueDataArr_x;
    NSMutableArray *_valueDataArr_y;
    NSMutableArray *_valueDataArr_x_second;
    NSMutableArray *_valueDataArr_y_second;
}
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic) LineBarChart * lineBarChart;
@property (nonatomic, strong) BarData * barData1; // 依靠左边Y轴的
@property (nonatomic, strong) BarData * barData2; // 依靠右边Y轴的
@property (nonatomic, strong) LineBarDataSet *lineBarDataSet;
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *dateStringStart;
@property (nonatomic, copy) NSString *dateStringEnd;
@property (nonatomic, strong) NSNumber *sumMileage;
@property (nonatomic, strong) NSNumber *sumuseOil;

@property (nonatomic, strong) MINDatePickerView *pickerView;

@property (nonatomic, strong) CBColumnChartView *columnChartView;
@property (nonatomic,strong) CBNoDataView *noDataView_columnChart;
@property (nonatomic,strong) UIView *noteView;
@end

@implementation BarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dateString = [self getCurrentTimeString];
    NSDictionary *dicTime = [CBCommonTools getSomeDayPeriod:[NSDate date]];
    self.dateStringStart = [NSString stringWithFormat:@"%@",dicTime[@"startTime"]];
    self.dateStringEnd = [NSString stringWithFormat:@"%@",dicTime[@"endTime"]];
    [self createUI];
    
    if (self.isDoubleYChart == YES) {
        [self requestDoubleData];
    }else {
        [self requestSingleData];
    }
}
- (CBColumnChartView *)columnChartView {
    if (!_columnChartView) {
        _columnChartView = [CBColumnChartView new];
        _columnChartView.frame = CGRectMake(0,PPNavigationBarHeight + 100*KFitHeightRate, SCREEN_WIDTH, SCREEN_HEIGHT - 100 - PPNavigationBarHeight - TabBARHEIGHT - TabPaddingBARHEIGHT - 100);
        _columnChartView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_columnChartView];
    }
    return _columnChartView;
}
- (CBNoDataView *)noDataView_columnChart {
    if (!_noDataView_columnChart) {
        _noDataView_columnChart = [[CBNoDataView alloc] initWithGrail];
        [self.view addSubview:_noDataView_columnChart];
        _noDataView_columnChart.center = self.view.center;
        _noDataView_columnChart.hidden = YES;
        kWeakSelf(self);
        [_noDataView_columnChart mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf(self);
            make.size.mas_equalTo(CGSizeMake(200, 200));
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        }];
    }
    return _noDataView_columnChart;
}
- (UIView *)noteView {
    if (!_noteView) {
        _noteView = [UIView new];
        
        UILabel *labOil = [MINUtils createLabelWithText:Localized(@"油耗") size:12];
        UIView *colorOil = [UIView new];
        colorOil.backgroundColor = RGB(251, 136, 9);
        [self.view addSubview:labOil];
        [self.view addSubview:colorOil];
        [labOil mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.columnChartView.mas_top).offset(0);
            make.right.mas_equalTo(-40);
            make.height.mas_equalTo(15);
        }];
        [colorOil mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(labOil.mas_centerY);
            make.right.mas_equalTo(labOil.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(10, 4));
        }];
        
        UILabel *labMilegage = [MINUtils createLabelWithText:Localized(@"里程") size:12];
        UIView *colorMileage = [UIView new];
        colorMileage.backgroundColor = RGB(15, 126, 254);
        [self.view addSubview:labMilegage];
        [self.view addSubview:colorMileage];
        [labMilegage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(labOil.mas_centerY);
            make.right.mas_equalTo(colorOil.mas_left).offset(-5);
            make.height.mas_equalTo(15);
        }];
        [colorMileage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(labOil.mas_centerY);
            make.right.mas_equalTo(labMilegage.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(10, 4));
        }];
    }
    return _noteView;
}

- (void)requestDoubleData
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";//[CBCommonTools CBdeviceInfo].dno?:@"";
    dic[@"reportType"] = @5;
    dic[@"startTime"] = self.dateStringStart;
    dic[@"endTime"] = self.dateStringEnd;
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devReportController/getCommonList" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *dataArr = response[@"data"];
                for (NSDictionary *dic in dataArr) {
                    if ([dic isKindOfClass: [NSNull class]] || [dic isEqual:@"<null>"]) {
                        //weakSelf.firstNumber = [NSNumber numberWithInt:0];
                    } else {
                        weakSelf.sumMileage = dic[@"sumMileage"];
                        weakSelf.sumuseOil = dic[@"sumUseoil"];
                    }
                }
                
                [weakSelf rebuildBarChart];
            } else {
                weakSelf.sumMileage = [NSNumber numberWithInt:0];
                weakSelf.sumuseOil = [NSNumber numberWithInt:0];
                [weakSelf rebuildBarChart];
            }
        }else {
            
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)requestSingleData
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";//[CBCommonTools CBdeviceInfo].dno?:@"";
    dic[@"reportType"] = @4;
    dic[@"startTime"] = self.dateStringStart;
    dic[@"endTime"] = self.dateStringEnd;
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devReportController/getCommonList" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *dataArr = response[@"data"];
                for (NSDictionary *dic in dataArr) {
                    if ([dic isKindOfClass: [NSNull class]] || [dic isEqual:@"<null>"]) {
                        //weakSelf.firstNumber = [NSNumber numberWithInt:0];
                    } else {
                        weakSelf.sumMileage = dic[@"sumMileage"];
                    }
                    //weakSelf.firstNumber = dic[@"sumMileage"];
                }
                [weakSelf rebuildBarChart];
            } else {
                weakSelf.sumMileage = [NSNumber numberWithInt:0];
                [weakSelf rebuildBarChart];
            }
        } else {
    
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (NSString *)getCurrentTimeString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 设置为东八区时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*3600];
    [formatter setTimeZone:timeZone];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}


- (void)rebuildBarChart
{
    if (self.isDoubleYChart == YES) {
        _dataArr_y = [NSMutableArray array];
        _dataArr_y_right = [NSMutableArray array];
        
        double maxMileage = self.sumMileage.doubleValue;
        double maxOil = self.sumuseOil.doubleValue;
        double maxValue = 0;
        maxValue = self.sumMileage.doubleValue >= self.sumuseOil.doubleValue?self.sumMileage.doubleValue:self.sumuseOil.doubleValue;
        
        CGFloat padding_y_Mileage = 0;
        CGFloat padding_y_oil = 0;
        CGFloat padding_y = 0;
        // y轴里程
        maxMileage = maxMileage*1.2;
        maxMileage = maxMileage <= 0?180.0:maxMileage;
        padding_y_Mileage = maxMileage/5.0;
        
        // y轴油耗
        maxOil = maxOil*1.2;
        maxOil = maxOil <= 0?180.0:maxOil;
        padding_y_oil = maxMileage/5.0;//maxOil/5.0;
        
        // 左右y轴最大值
        maxValue = maxValue*1.2;
        maxValue = maxValue <= 0?180.0:maxValue;
        NSInteger zzz = 0;
        if (maxValue <= 0) {
        } else if (maxValue/100 < 10) {
            zzz = maxValue/100;
            maxValue = zzz * 100;// 取100的整数
        } else if (maxValue/1000 < 10 ) {
            zzz = maxValue/1000;
            maxValue = zzz * 1000;// 取1000的整数
        } else if (maxValue/10000 < 10) {
            zzz = maxValue/10000;
            maxValue = zzz * 10000;// 取10000的整数
        } else if (maxValue/100000 < 10) {
            zzz = maxValue/100000;
            maxValue = zzz * 100000;// 取100000的整数
        } else if (maxValue/1000000 < 10) {
            zzz = maxValue/1000000;
            maxValue = zzz * 1000000;// 取1000000的整数
        }
        padding_y = maxValue/5.0;//maxOil/5.0;
        
        for (int i = 0 ; i < 6 ; i ++ ) {
            NSInteger point_y_Mileage = padding_y*i;
            NSString *mileage = [NSString stringWithFormat:@"%ldKM",(long)point_y_Mileage];
            [_dataArr_y addObject:mileage];
            
            NSInteger point_y_Oil = padding_y*i;
            NSString *oil = [NSString stringWithFormat:@"%ldL",(long)point_y_Oil];
            [_dataArr_y_right addObject:oil];
        }
        
//        CGFloat mileageValue = (self.columnChartView.frame.size.height - 30)/maxMileage*self.sumMileage.doubleValue;
//        CGFloat oilValue = (self.columnChartView.frame.size.height - 30)/maxOil*self.sumuseOil.doubleValue;
        CGFloat mileageValue = (self.columnChartView.frame.size.height - 30)/maxValue*self.sumMileage.doubleValue;
        CGFloat oilValue = (self.columnChartView.frame.size.height - 30)/maxValue*self.sumuseOil.doubleValue;
        
//        self.columnChartView.maxData_left = [NSString stringWithFormat:@"%ldKM",(long)maxMileage];
//        self.columnChartView.maxData_right = [NSString stringWithFormat:@"%ldL",(long)maxOil];
        self.columnChartView.maxData_left = [NSString stringWithFormat:@"%ldKM",(long)maxValue];
        self.columnChartView.maxData_right = [NSString stringWithFormat:@"%ldL",(long)maxValue];
        // 里程折线
        self.columnChartView.columnChartColor_first = RGB(15, 126, 254);
        // 油耗折线
        self.columnChartView.columnChartColor_second = RGB(251, 136, 9);
        
        self.columnChartView.dateArr_y = _dataArr_y;
        self.columnChartView.dateArr_y_right = _dataArr_y_right;
        
        self.columnChartView.value_mileage = mileageValue;
        self.columnChartView.value_oil = oilValue;
        
        self.columnChartView.value_mileage_str = [NSString stringWithFormat:@"%ld",(long)self.sumMileage.doubleValue];
        self.columnChartView.value_oil_str = [NSString stringWithFormat:@"%ld",(long)self.sumuseOil.doubleValue];
        
        self.columnChartView.isDouble = YES;
        [self.columnChartView refreshColumnChart];
        
        [self noteView];
        
    } else {
        _dataArr_y = [NSMutableArray array];
        
        double maxMileage = self.sumMileage.doubleValue;
        double maxValue = 0;
        maxValue = self.sumMileage.doubleValue >= self.sumuseOil.doubleValue?self.sumMileage.doubleValue:self.sumuseOil.doubleValue;
        
        CGFloat padding_y_Mileage = 0;
        CGFloat padding_y = 0;
        // y轴里程
        maxMileage = maxMileage*1.2;
        maxMileage = maxMileage <= 0?180.0:maxMileage;
        padding_y_Mileage = maxMileage/5.0;
        
        // 左右y轴最大值
        maxValue = maxValue*1.2;
        maxValue = maxValue <= 0?180.0:maxValue;
        NSInteger zzz = 0;
        if (maxValue <= 0) {
        } else if (maxValue/100 < 10) {
            zzz = maxValue/100;
            maxValue = zzz * 100;// 取100的整数
        } else if (maxValue/1000 < 10 ) {
            zzz = maxValue/1000;
            maxValue = zzz * 1000;// 取1000的整数
        } else if (maxValue/10000 < 10) {
            zzz = maxValue/10000;
            maxValue = zzz * 10000;// 取10000的整数
        } else if (maxValue/100000 < 10) {
            zzz = maxValue/100000;
            maxValue = zzz * 100000;// 取100000的整数
        } else if (maxValue/1000000 < 10) {
            zzz = maxValue/1000000;
            maxValue = zzz * 1000000;// 取1000000的整数
        }
        padding_y = maxValue/5.0;//maxOil/5.0;
        
        for (int i = 0 ; i < 6 ; i ++ ) {
            NSInteger point_y_Mileage = padding_y*i;
            NSString *mileage = [NSString stringWithFormat:@"%ldKM",(long)point_y_Mileage];
            [_dataArr_y addObject:mileage];
        }
        CGFloat mileageValue = (self.columnChartView.frame.size.height - 30)/maxValue*self.sumMileage.doubleValue;
        
        self.columnChartView.maxData_left = [NSString stringWithFormat:@"%ldKM",(long)maxValue];
        // 里程折线
        self.columnChartView.columnChartColor_first = RGB(15, 126, 254);
        
        self.columnChartView.dateArr_y = _dataArr_y;
        
        self.columnChartView.value_mileage = mileageValue;
        
        self.columnChartView.value_mileage_str = [NSString stringWithFormat:@"%ld",(long)self.sumMileage.doubleValue];
    
        [self.columnChartView refreshColumnChart];
    }
}

#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self initBarWithTitle: self.titleName isBack: YES];
    [self initBarRighWhiteBackBtnTitle:Localized(@"查询") target: self action: @selector(rightBtnClick)];
    [self createTopPart];
    [self columnChartView];
}

- (void)createTopPart
{
    if (self.isDoubleYChart == YES) {
        _nameLabel = [MINUtils createLabelWithText:Localized(@"日里程耗油报表") size: 17 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: kCellTextColor];
    }else {
        _nameLabel = [MINUtils createLabelWithText:Localized(@"里程统计") size: 17 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: kCellTextColor];
    }
    [self.view addSubview: _nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kNavAndStatusHeight + 15 * KFitHeightRate);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(25 * KFitHeightRate);
    }];
    //@"2015-05-05"
    _timeLabel = [MINUtils createLabelWithText:self.dateString size: 12 * KFitHeightRate alignment:(NSTextAlignment)NSTextAlignmentCenter textColor: kCellTextColor];
    [self.view addSubview: _timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(5 * KFitHeightRate);
        make.left.right.equalTo(_nameLabel);
        make.height.mas_equalTo(15 * KFitHeightRate);
    }];
}

#pragma makr = Action
- (void)rightBtnClick
{
    [self.pickerView showView];
    
}
- (MINDatePickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[MINDatePickerView alloc] init];
        [self.view addSubview: _pickerView];
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        _pickerView.delegate = self;
    }
    return _pickerView;
}
#pragma mark - MINDatePickerViewDelegare
- (void)datePicker:(MINDatePickerView *)pickerView didSelectordate:(NSString *)dateString date:(NSDate *)date {
    NSLog(@"%@", dateString);
    self.dateString = dateString;
    NSDictionary *dicTime = [CBCommonTools getSomeDayPeriod:date];
    self.dateStringStart = [NSString stringWithFormat:@"%@",dicTime[@"startTime"]];
    self.dateStringEnd = [NSString stringWithFormat:@"%@",dicTime[@"endTime"]];
    self.timeLabel.text = dateString;
    if (self.isDoubleYChart == YES) {
        [self requestDoubleData];
    }else {
        [self requestSingleData];
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
