//
//  LineChartViewController.m
//  Telematics
//
//  Created by lym on 2017/11/16.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "LineChartViewController.h"
#import "LineCanvas.h"
#import "LineDataSet.h"
#import "LineData.h"
#import "GridBackCanvas.h"
#import "LineChart.h"
#import "LineTypeView.h"
#import "MINDatePickerView.h"
#import "LineDoubleChartModel.h"
#import "LineSingleChartModel.h"

#import "CBChartView.h"
#import "CBLineChartView.h"

@interface LineChartViewController () <MINDatePickerViewDelegare>
{
    NSMutableArray *_dataArr_x;
    NSMutableArray *_dataArr_y;
    NSMutableArray *_dataArr_y_right;
    NSMutableArray *_valueDataArr_x;
    NSMutableArray *_valueDataArr_y;
    NSMutableArray *_valueDataArr_x_second;
    NSMutableArray *_valueDataArr_y_second;
    NSMutableArray *_valueDataArr_x_third;
    NSMutableArray *_valueDataArr_y_third;
}
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) LineData *leftdLine;
@property (nonatomic, strong) LineData *rightLine;
@property (nonatomic, strong) LineData *rightLine2;
@property (nonatomic, strong) LineChart *lineChart;
@property (nonatomic, strong) LineDataSet *lineDataSet;
@property (nonatomic, copy) NSArray *bottomLabels;
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *dateStringStart;
@property (nonatomic, copy) NSString *dateStringEnd;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) MINDatePickerView *pickerView;

@property (nonatomic, strong) CBLineChartView *lineChartView;
@property (nonatomic,strong) CBNoDataView *noDataView_lineChart;
@property (nonatomic,strong) UIView *noteView;
@end

@implementation LineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dateString = [self getCurrentTimeString];
    NSDictionary *dicTime = [CBCommonTools getSomeDayPeriod:[NSDate date]];
    self.dateStringStart = [NSString stringWithFormat:@"%@",dicTime[@"startTime"]];
    self.dateStringEnd = [NSString stringWithFormat:@"%@",dicTime[@"endTime"]];
    [self createUI];
    self.dataArr = [NSMutableArray array];
    if (self.isDoubleYChart == YES) {
        [self requestDoubleData];
    }else {
        [self requestSingleData];
    }
    
//    self.view.backgroundColor = [UIColor whiteColor];
//    CBChartView *chartView = [[CBChartView alloc]initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 300) column:7 row:7 type:LYChartViewTypeLine title:@"11" unit:@"8"];
//    chartView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:chartView];
//
//    [chartView customColumnIndexData:@[@"11",@"22",@"33"]];
////    /* 功能:设置下标
////    * 参数data:下标数组
////    */
////    - (void)customColumnIndexData:(NSArray *)data;
////    /*
////     * 功能:设置数据
////     * 参数data:数值数组
////     */
////    - (void)customValueData:(NSArray *)data;
//
//    [chartView customValueData:@[@"11",@"22",@"33",@"44",@"88"]];
//
//    [chartView reloadData];
}
- (CBLineChartView *)lineChartView {
    if (!_lineChartView) {
        _lineChartView = [CBLineChartView new];
        _lineChartView.frame = CGRectMake(0,PPNavigationBarHeight + 100*KFitHeightRate, SCREEN_WIDTH, SCREEN_HEIGHT - 100 - PPNavigationBarHeight - TabBARHEIGHT - TabPaddingBARHEIGHT - 100);
        _lineChartView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_lineChartView];
    }
    return _lineChartView;
}
- (CBNoDataView *)noDataView_lineChart {
    if (!_noDataView_lineChart) {
        _noDataView_lineChart = [[CBNoDataView alloc] initWithGrail];
        [self.view addSubview:_noDataView_lineChart];
        _noDataView_lineChart.center = self.view.center;
        _noDataView_lineChart.hidden = YES;
        kWeakSelf(self);
        [_noDataView_lineChart mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf(self);
            make.size.mas_equalTo(CGSizeMake(200, 200));
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        }];
    }
    return _noDataView_lineChart;
}
- (UIView *)noteView {
    if (!_noteView) {
        _noteView = [UIView new];
        
        UILabel *labMilegage = [MINUtils createLabelWithText:Localized(@"里程") size:12];
        UIView *colorMileage = [UIView new];
        colorMileage.backgroundColor = RGB(36, 237, 176);
        [self.view addSubview:labMilegage];
        [self.view addSubview:colorMileage];
        [labMilegage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.lineChartView.mas_top).offset(0);
            make.right.mas_equalTo(-40);
            make.height.mas_equalTo(15);
        }];
        [colorMileage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(labMilegage.mas_centerY);
            make.right.mas_equalTo(labMilegage.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(10, 4));
        }];
        
        UILabel *labSpeed = [MINUtils createLabelWithText:Localized(@"速度") size:12];
        UIView *colorSpeed = [UIView new];
        colorSpeed.backgroundColor = RGB(251, 136, 9);
        [self.view addSubview:labSpeed];
        [self.view addSubview:colorSpeed];
        [labSpeed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(labMilegage.mas_centerY);
            make.right.mas_equalTo(colorMileage.mas_left).offset(-5);
            make.height.mas_equalTo(15);
        }];
        [colorSpeed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(labMilegage.mas_centerY);
            make.right.mas_equalTo(labSpeed.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(10, 4));
        }];
        
        UILabel *labOil = [MINUtils createLabelWithText:Localized(@"油量") size:12];
        UIView *colorOil = [UIView new];
        colorOil.backgroundColor = RGB(15, 126, 254);
        [self.view addSubview:labOil];
        [self.view addSubview:colorOil];
        [labOil mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(colorSpeed.mas_centerY);
            make.right.mas_equalTo(colorSpeed.mas_left).offset(-5);
            make.height.mas_equalTo(15);
        }];
        [colorOil mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(labMilegage.mas_centerY);
            make.right.mas_equalTo(labOil.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(10, 4));
        }];
    }
    return _noteView;
}
- (void)requestSingleData
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";//[CBCommonTools CBdeviceInfo].dno?:@"";
    dic[@"reportType"] = @1;
    dic[@"startTime"] = self.dateStringStart;
    dic[@"endTime"] = self.dateStringEnd;
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devReportController/getCommonList" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"曲线:%@",response);
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *dataArr = response[@"data"];
                [weakSelf.dataArr removeAllObjects];
                for (NSDictionary *dic in dataArr) {
                    LineSingleChartModel *model = [LineSingleChartModel yy_modelWithDictionary: dic];
                    [weakSelf.dataArr addObject: model];
                }
                [weakSelf rebuildLineChart];
            } else {
                [weakSelf.dataArr removeAllObjects];
                [weakSelf rebuildLineChart];
            }
            self.noDataView_lineChart.hidden = weakSelf.dataArr.count ==0?NO:YES;
        }else {
            
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)requestDoubleData
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";//[CBCommonTools CBdeviceInfo].dno?:@"";
    dic[@"reportType"] = @6;
    dic[@"startTime"] = self.dateStringStart;
    dic[@"endTime"] = self.dateStringEnd;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devReportController/getCommonList" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *dataArr = response[@"data"];
                [weakSelf.dataArr removeAllObjects];
                for (NSDictionary *dic in dataArr) {
                    LineDoubleChartModel *model = [LineDoubleChartModel yy_modelWithDictionary: dic];
                    [weakSelf.dataArr addObject: model];
                }
                [weakSelf rebuildLineChart];
            } else {
                [weakSelf.dataArr removeAllObjects];
                [weakSelf rebuildLineChart];
            }
            self.noDataView_lineChart.hidden = weakSelf.dataArr.count ==0?NO:YES;
        }else {
            
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (NSString *)getCurrentTimeString {
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

- (void)rebuildLineChart
{

    if(self.isDoubleYChart == YES) {
        _dataArr_x = [NSMutableArray array];
        _dataArr_y = [NSMutableArray array];
        _dataArr_y_right = [NSMutableArray array];
        _valueDataArr_x = [NSMutableArray array];
        _valueDataArr_y = [NSMutableArray array];
        _valueDataArr_x_second = [NSMutableArray array];
        _valueDataArr_y_second = [NSMutableArray array];
        _valueDataArr_x_third = [NSMutableArray array];
        _valueDataArr_y_third = [NSMutableArray array];
        
        NSInteger start_x = 99999999999999;
        NSInteger end_x = 0;
        NSInteger start_y = 0;
        NSInteger end_y_oil = 0;
        NSInteger end_y_speed = 0;
        NSInteger end_y_mileage = 0;
        CGFloat padding_x = 0;
        CGFloat padding_y_speed = 0;
        CGFloat padding_y_oil = 0;
        // y轴最大值，x轴最大最小值
        for (int i = 0 ; i < self.dataArr.count ; i ++ ) {
            LineSingleChartModel *model = self.dataArr[i];
            if (model.createTime.doubleValue >= end_x) {
                end_x = model.createTime.integerValue;
            }
            if (model.createTime.doubleValue <= start_x) {
                start_x = model.createTime.integerValue;
            }
            if (model.speed >= end_y_speed) {
                end_y_speed = model.speed;
            }
            if (model.use_oil >= end_y_oil) {
                end_y_oil = model.use_oil;
            }
            if (model.mileage >= end_y_mileage) {
                end_y_mileage = model.mileage;
            }
        }
        // x轴时间
        start_x = start_x - 2.1*60*1000;
        end_x = end_x + 2.1*60*1000;
        padding_x = (end_x - start_x)/self.dataArr.count;
        if (self.dataArr.count > 0) {
            if (self.dataArr.count >= 8) {
                //超过8个，x轴为8个点，否则7个点
                padding_x = (end_x - start_x)/7.0;
            } else {
                padding_x = (end_x - start_x)/6.0;
            }
        } else {
            padding_x = 0;
        }
        
        // y轴速度
        end_y_speed = end_y_speed*1.2;
        end_y_speed = end_y_speed <6.0f?6.0f:end_y_speed;
        padding_y_speed = (end_y_speed - start_y)/6.0;
    
        // y轴油量
        end_y_oil = end_y_oil*1.2;
        end_y_oil = end_y_oil <6.0f?6.0f:end_y_oil;
        padding_y_oil = (end_y_oil - start_y)/6.0f;
        
        // y轴里程
        end_y_mileage = end_y_mileage*1.2;
        end_y_mileage = end_y_mileage <6.0f?6.0f:end_y_mileage;
        
        // 左侧起点 距离左侧屏幕
        CGFloat width = [NSString getWidthWithText:[NSString stringWithFormat:@"%ldL",(long)end_y_oil] font:[UIFont systemFontOfSize:10] height:16];
        width = width < 35?(35 + 10):(width + 10);
        
        // 右侧终点 距离右侧屏幕
        CGFloat width_right = [NSString getWidthWithText:[NSString stringWithFormat:@"%ldKM",(long)end_y_speed] font:[UIFont systemFontOfSize:10] height:16];
        width_right = width_right < 15?15:(width + 10);
        
        NSInteger total = self.dataArr.count >= 8?self.dataArr.count:7;
        if (self.dataArr.count == 0) {
            total = 0;
        }
        for (int i = 0 ; i < total ; i ++ ) {
            // x轴时间分段值
            if (i <= 7) {
                CGFloat point_x = start_x + padding_x*i;
                NSString *time = [MINUtils getTimeFromTimestamp:[NSString stringWithFormat:@"%.f",point_x] formatter:@"HH:mm"];
                [_dataArr_x addObject:time];
            }
            // y轴速度分段值
            if (i <= 6) {
                NSInteger point_y_oil = start_y + padding_y_oil*i;
                NSString *oil = [NSString stringWithFormat:@"%ldL",(long)point_y_oil];
                [_dataArr_y addObject:oil];
                
                NSInteger point_y_speed = start_y + padding_y_speed*i;
                NSString *speed = [NSString stringWithFormat:@"%ldKM",(long)point_y_speed];
                [_dataArr_y_right addObject:speed];
            }
            // 添加点坐标
            if (i < self.dataArr.count) {
                LineSingleChartModel *model = self.dataArr[i];
                CGFloat time = width + (SCREEN_WIDTH - width - width_right)/(end_x - start_x) * (model.createTime.doubleValue - start_x);
                [_valueDataArr_x addObject:[NSString stringWithFormat:@"%@",@(time)]];
                [_valueDataArr_x_second addObject:[NSString stringWithFormat:@"%@",@(time)]];
                [_valueDataArr_x_third addObject:[NSString stringWithFormat:@"%@",@(time)]];
                
                CGFloat oil = 8 + (self.lineChartView.frame.size.height - 30) - (self.lineChartView.frame.size.height - 30)/end_y_oil * model.use_oil;
                [_valueDataArr_y addObject:[NSString stringWithFormat:@"%@",@(oil)]];
                //NSLog(@"++++++++++++油量:%f++++++++++++",oil);
                
                CGFloat speed = (8 + (self.lineChartView.frame.size.height - 30.0f)) - ((self.lineChartView.frame.size.height - 30.0f)/end_y_speed * model.speed);
                [_valueDataArr_y_second addObject:[NSString stringWithFormat:@"%@",@(speed)]];
                //NSLog(@"++++++++++++速度:%.6f++++++++++++",speed);
                
                CGFloat mileage = 8 + (self.lineChartView.frame.size.height - 30) - (self.lineChartView.frame.size.height - 30)/end_y_mileage * model.mileage;
                [_valueDataArr_y_third addObject:[NSString stringWithFormat:@"%@",@(mileage)]];
                //NSLog(@"++++++++++++里程:%f++++++++++++",mileage);
            }
        }
        self.lineChartView.maxData_left = [NSString stringWithFormat:@"%ldL",(long)end_y_oil];
        self.lineChartView.maxData_right = [NSString stringWithFormat:@"%ldKM",(long)end_y_speed];
        // 油量折线
        self.lineChartView.linePointColor_first = RGB(15, 126, 254);//RGB(26, 151, 251);
        // 速度折线
        self.lineChartView.linePointColor_second = RGB(251, 136, 9);
        // 里程折线
        self.lineChartView.linePointColor_third = RGB(36, 237, 176);
        
        self.lineChartView.dateArr_x = _dataArr_x;
        self.lineChartView.dateArr_y = _dataArr_y;
        self.lineChartView.dateArr_y_right = _dataArr_y_right;
        
        self.lineChartView.valueDateArr_x = _valueDataArr_x;
        self.lineChartView.valueDataArr_y = _valueDataArr_y;
        self.lineChartView.valueDateArr_x_second = _valueDataArr_x_second;
        self.lineChartView.valueDataArr_y_second = _valueDataArr_y_second;
        self.lineChartView.valueDateArr_x_third = _valueDataArr_x_third;
        self.lineChartView.valueDataArr_y_third = _valueDataArr_y_third;
        
        self.lineChartView.isDouble = YES;
        [self.lineChartView refreshLineChart];
        if (self.dataArr.count > 0) {
            [self noteView];
        }
    } else {
        if (self.dataArr.count <=0 ) {
            return;
        }
        [NSMutableArray array];
        _dataArr_y = [NSMutableArray array];
        _valueDataArr_x = [NSMutableArray array];
        _valueDataArr_y = [NSMutableArray array];
        
        NSInteger start_x = 99999999999999;
        NSInteger end_x = 0;
        double start_y = 0;
        NSInteger end_y = 0;
        CGFloat padding_x = 0;
        CGFloat padding_y = 0;
        // y轴最大值，x轴最大最小值
        for (int i = 0 ; i < self.dataArr.count ; i ++ ) {
            LineSingleChartModel *model = self.dataArr[i];
            if (model.createTime.doubleValue >= end_x) {
                end_x = model.createTime.integerValue;
            }
            if (model.createTime.doubleValue <= start_x) {
                start_x = model.createTime.integerValue;
            }
            if (model.speed >= end_y) {
                end_y = model.speed;
            }
        }
        // x轴时间
        start_x = start_x - 2.1*60*1000;//36
        end_x = end_x + 2.1*60*1000;//20
        padding_x = (end_x - start_x)/self.dataArr.count;
        if (self.dataArr.count > 0) {
            if (self.dataArr.count >= 8) {
                //超过8个，x轴为8个，否则7个点
                padding_x = (end_x - start_x)/7.0;
            } else {
                padding_x = (end_x - start_x)/6.0;
            }
        } else {
            padding_x = 0;
        }
        // y轴速度
        end_y = end_y*1.2;
        padding_y = (end_y - start_y)/6.0;
        
        // 左侧起点 距离左侧屏幕
        CGFloat space_left = [NSString getWidthWithText:[NSString stringWithFormat:@"%ldKM",(long)end_y] font:[UIFont systemFontOfSize:10] height:16];
        space_left = space_left < 35?(35 + 10):(space_left + 10);
        
        NSInteger total = self.dataArr.count >= 8?self.dataArr.count:7;
        if (self.dataArr.count == 0) {
            total = 0;
        }
        for (NSInteger i = 0 ; i < total ; i ++ ) {
            // x轴时间分段值
            if (i <= 7) {
                //x轴限制8个点
                CGFloat point_x = start_x + padding_x*i;
                NSString *time = [MINUtils getTimeFromTimestamp:[NSString stringWithFormat:@"%.f",point_x] formatter:@"HH:mm"];
                [_dataArr_x addObject:time];
            }
            // y轴速度分段值
            if (i <= 6) {
                //y轴限制7个点
                NSInteger point_y = start_y + padding_y*i;
                NSString *speed = [NSString stringWithFormat:@"%ldKM",(long)point_y];
                [_dataArr_y addObject:speed];
            }
            // 添加点坐标
            if (i < self.dataArr.count) {
                LineSingleChartModel *model = self.dataArr[i];
                CGFloat time = space_left + (SCREEN_WIDTH - space_left - 15)/(end_x - start_x) * (model.createTime.doubleValue - start_x);
                [_valueDataArr_x addObject:[NSString stringWithFormat:@"%@",@(time)]];
                
                CGFloat speed = 8 + (self.lineChartView.frame.size.height - 30) - (self.lineChartView.frame.size.height - 30)/end_y * model.speed;
                [_valueDataArr_y addObject:[NSString stringWithFormat:@"%@",@(speed)]];
            }
        }
        self.lineChartView.maxData_left = [NSString stringWithFormat:@"%ldKM",(long)end_y];
        self.lineChartView.maxData_right = @"";
        self.lineChartView.linePointColor_first = RGB(15, 126, 254);
        
        self.lineChartView.dateArr_x = _dataArr_x;
        self.lineChartView.dateArr_y = _dataArr_y;
        self.lineChartView.valueDateArr_x = _valueDataArr_x;
        self.lineChartView.valueDataArr_y = _valueDataArr_y;
        [self.lineChartView refreshLineChart];
        
    }
}

#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self initBarWithTitle: self.titleName isBack: YES];
    [self initBarRighWhiteBackBtnTitle:Localized(@"查询") target: self action: @selector(rightBtnClick)];
    [self createTopPart];
    //[self createLineChart];
    [self lineChartView];
}

- (void)createTopPart
{
    if (self.isDoubleYChart == YES) {
        _nameLabel = [MINUtils createLabelWithText:Localized(@"油量里程速度表") size: 17 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: kCellTextColor];
    }else {
        _nameLabel = [MINUtils createLabelWithText:Localized(@"速度曲线") size: 17 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: kCellTextColor];
    }
    [self.view addSubview: _nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kNavAndStatusHeight + 15 * KFitHeightRate);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(25 * KFitHeightRate);
    }];
    _timeLabel = [MINUtils createLabelWithText:self.dateString?:@"2015-05-05" size: 12 * KFitHeightRate alignment:(NSTextAlignment)NSTextAlignmentCenter textColor: kCellTextColor];
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
