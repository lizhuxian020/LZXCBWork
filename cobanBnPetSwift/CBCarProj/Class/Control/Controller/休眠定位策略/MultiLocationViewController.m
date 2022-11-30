//
//  MultiLocationViewController.m
//  Telematics
//
//  Created by lym on 2017/11/27.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MultiLocationViewController.h"
#import "MultiLocationHeaderView.h"
#import "MultiLocationDetailView.h"
#import "MINPickerView.h"
#import "MultiLocationModel.h"
#import "_CBXiuMianChooseView.h"
#import "_CBLocateModeView.h"

@interface MultiLocationViewController () <MINPickerViewDelegate>
@property (nonatomic, strong) _CBXiuMianChooseView *xmChooseView;
@property (nonatomic, strong) _CBLocateModeView *locationModeView;
@property (nonatomic, strong) MultiLocationHeaderView *headerView;
@property (nonatomic, strong) MultiLocationDetailView *topDetailView;
@property (nonatomic, strong) MultiLocationDetailView *bottomDetailView;
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, weak) UIButton *selectBtn; // 选中的按钮
@property (nonatomic, strong) NSMutableArray *selectArray; // 选中数据的内容
@property (nonatomic, strong) NSArray *restArr;
@end

@implementation MultiLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.restArr = @[Localized(@"长在线"), Localized(@"振动休眠"), Localized(@"时间休眠"), Localized(@"深度振动休眠"), Localized(@"定时报告"), Localized(@"定时报告+深度振动休眠")];
    [self createUI];
    self.dataArr = @[@[@"10", @"20", @"30", @"40", @"50", @"60", @"70", @"80", @"90"]];
//    self.selectArray = [NSMutableArray arrayWithArray: @[@200, @200, @200, @200, @200, @200]];
    [self requestData];
}
#pragma mark -- 获取设备多次定位参数
- (void)requestData
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";//[AppDelegate shareInstance].currenDeviceSno;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devControlController/getMulPosParamList" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                MultiLocationModel *model = [MultiLocationModel yy_modelWithDictionary: response[@"data"]];
                [weakSelf setDataWithModel: model];
                
            }
        } else {
            
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)setDataWithModel:(MultiLocationModel *)model
{
    [self.headerView setSelectBtn: model.reportWay];
    self.bottomDetailView.hidden = YES;
    if (model.reportWay == 0) {
        [self.topDetailView setDistanceTitle: model.timeQs SOSTitle: model.timeSos staticTitle: model.timeRest];
        [self setTimeOrDistanceLabelText: NO];
    }else if (model.reportWay == 1) {
        [self.topDetailView setDistanceTitle: model.disQs SOSTitle: model.disSos staticTitle: model.disRest];
        [self setTimeOrDistanceLabelText: YES];
    }else {
        self.bottomDetailView.hidden = NO;
        [self.topDetailView setDistanceTitle: model.timeQs SOSTitle: model.timeSos staticTitle: model.timeRest];
        [self.bottomDetailView setDistanceTitle: model.disQs SOSTitle: model.disSos staticTitle: model.disRest];
        [self setTimeOrDistanceLabelText: NO];
    }
}

// 设置定时或者定距显示的text内容
- (void)setTimeOrDistanceLabelText:(BOOL)isDistance
{
    if (isDistance == NO) {
        _topDetailView.distanceLabel.text = [NSString stringWithFormat:@"%@(%@)",Localized(@"运动汇报间隔"),Localized(@"秒")];//@"运动汇报间隔 (秒)";
        _topDetailView.SOSLabel.text = [NSString stringWithFormat:@"%@(%@)",Localized(@"SOS汇报间隔"),Localized(@"秒")];//@"SOS汇报间隔 (秒)";
        _topDetailView.staticLabel.text = [NSString stringWithFormat:@"%@(%@)",Localized(@"静止汇报间隔"),Localized(@"秒")];//@"静止汇报间隔 (分)";
    } else {
        _topDetailView.distanceLabel.text = [NSString stringWithFormat:@"%@(%@)",Localized(@"运动汇报间隔"),Localized(@"米")];//@"运动汇报间隔 (米)";
        _topDetailView.SOSLabel.text = [NSString stringWithFormat:@"%@(%@)",Localized(@"SOS汇报间隔"),Localized(@"米")];//@"SOS汇报间隔 (米)";
        _topDetailView.staticLabel.text = [NSString stringWithFormat:@"%@(%@)",Localized(@"静止汇报间隔"),Localized(@"米")];//@"静止汇报间隔 (米)";
    }
}

#pragma mark - Action
- (void)rightBtnClick
{
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    //[hud hideAnimated: YES];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:4];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";//[AppDelegate shareInstance].currenDeviceSno;
    dic[@"report_way"] = [self.headerView getSelectBtn];
    if ([[self.headerView getSelectBtn] integerValue] == 0) {
//        dic[@"time_qs"] = self.topDetailView.distanceBtn.titleLabel.text;
//        dic[@"time_sos"] = self.topDetailView.SOSBtn.titleLabel.text;
//        dic[@"time_rest"] = self.topDetailView.staticBtn.titleLabel.text;
        
        dic[@"time_qs"] = self.topDetailView.distanceTF.text;
        dic[@"time_sos"] = self.topDetailView.SOSTF.text;
        dic[@"time_rest"] = self.topDetailView.staticTF.text;
        
    }else if ([[self.headerView getSelectBtn] integerValue] == 1) {
//        dic[@"dis_qs"] = self.topDetailView.distanceBtn.titleLabel.text;
//        dic[@"dis_sos"] = self.topDetailView.SOSBtn.titleLabel.text;
//        dic[@"dis_rest"] = self.topDetailView.staticBtn.titleLabel.text;
        
        dic[@"time_qs"] = self.topDetailView.distanceTF.text;
        dic[@"time_sos"] = self.topDetailView.SOSTF.text;
        dic[@"time_rest"] = self.topDetailView.staticTF.text;
        
    }else {
//        dic[@"time_qs"] = self.topDetailView.distanceBtn.titleLabel.text;
//        dic[@"time_sos"] = self.topDetailView.SOSBtn.titleLabel.text;
//        dic[@"time_rest"] = self.topDetailView.staticBtn.titleLabel.text;
//        dic[@"dis_qs"] = self.bottomDetailView.distanceBtn.titleLabel.text;
//        dic[@"dis_sos"] = self.bottomDetailView.SOSBtn.titleLabel.text;
//        dic[@"dis_rest"] = self.bottomDetailView.staticBtn.titleLabel.text;
        
        dic[@"time_qs"] = self.topDetailView.distanceTF.text;
        dic[@"time_sos"] = self.topDetailView.SOSTF.text;
        dic[@"time_rest"] = self.topDetailView.staticTF.text;
        dic[@"dis_qs"] = self.bottomDetailView.distanceTF.text;
        dic[@"dis_sos"] = self.bottomDetailView.SOSTF.text;
        dic[@"dis_rest"] = self.bottomDetailView.staticTF.text;
    }
    //    dic[@"login_type"] = @"1";
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl: @"devControlController/editMulPosParam" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [self.navigationController popViewControllerAnimated: YES];
        } else {
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - createUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"休眠定位策略") isBack: YES];
    [self showBackGround];
    [self initBarRighBtnTitle: Localized(@"确定") target: self action: @selector(rightBtnClick)];
    
    self.xmChooseView = [[_CBXiuMianChooseView alloc] initWithData:self.restArr];
    [self.view addSubview:self.xmChooseView];
    [self.xmChooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(12.5 * KFitHeightRate + kNavAndStatusHeight);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
    }];
    
    self.locationModeView = [_CBLocateModeView new];
    [self.view addSubview:self.locationModeView];
    [self.locationModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xmChooseView.mas_bottom);
        make.left.right.equalTo(self.view);
    }];
    
    _headerView = [[MultiLocationHeaderView alloc] init];
    [self.view addSubview: _headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(12.5 * KFitHeightRate + kNavAndStatusHeight);
        make.top.equalTo(self.locationModeView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(100 * KFitHeightRate);
    }];
    _topDetailView = [[MultiLocationDetailView alloc] init];
    [self.view addSubview: _topDetailView];
    [_topDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(150 * KFitHeightRate);
    }];
    
    _bottomDetailView = [[MultiLocationDetailView alloc] init];
    _bottomDetailView.hidden = YES;
    [self.view addSubview: _bottomDetailView];
    [_bottomDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topDetailView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(150 * KFitHeightRate);
    }];
    
    __weak __typeof__(MultiLocationDetailView *) weaktopDetailView = self.topDetailView;
    __weak __typeof__(MultiLocationDetailView *) weakbottomDetailView = self.bottomDetailView;
    __weak __typeof__(self) weakSelf = self;
    _topDetailView.distanceBtnClickBlock = ^{
        weakSelf.selectBtn = weaktopDetailView.distanceBtn;
        [weakSelf showPickerView];
    };
    _topDetailView.SOSBtnClickBlock = ^{
        weakSelf.selectBtn = weaktopDetailView.SOSBtn;
        [weakSelf showPickerView];
    };
    _topDetailView.staticBtnClickBlock = ^{
        weakSelf.selectBtn = weaktopDetailView.staticBtn;
        [weakSelf showPickerView];
    };
    
    _bottomDetailView.distanceBtnClickBlock = ^{
        weakSelf.selectBtn = weakbottomDetailView.distanceBtn;
        [weakSelf showPickerView];
    };
    _bottomDetailView.SOSBtnClickBlock = ^{
        weakSelf.selectBtn = weakbottomDetailView.SOSBtn;
        [weakSelf showPickerView];
    };
    _bottomDetailView.staticBtnClickBlock = ^{
        weakSelf.selectBtn = weakbottomDetailView.staticBtn;
        [weakSelf showPickerView];
    };
    _headerView.timingBtnClickBlock = ^{
        weaktopDetailView.hidden = NO;
        weakbottomDetailView.hidden = YES;
        [weakSelf setTimeOrDistanceLabelText: NO];
    };
    _headerView.distanceBtnClickBlock = ^{
        weaktopDetailView.hidden = NO;
        weakbottomDetailView.hidden = YES;
        [weakSelf setTimeOrDistanceLabelText: YES];
    };
    _headerView.timingAndDistanceBtnClickBlock = ^{
        weaktopDetailView.hidden = NO;
        weakbottomDetailView.hidden = NO;
        [weakSelf setTimeOrDistanceLabelText: NO];
    };
}

- (void)showPickerView
{
    MINPickerView *pickerView = [[MINPickerView alloc] init];
    pickerView.titleLabel.text = @"";
    pickerView.dataArr = self.dataArr;
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
    NSNumber *selectRow = dic[@"0"];
    [self.selectBtn setTitle: self.dataArr[0][[selectRow integerValue]] forState: UIControlStateNormal];
    [self.selectBtn setTitle: self.dataArr[0][[selectRow integerValue]] forState: UIControlStateHighlighted];
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
