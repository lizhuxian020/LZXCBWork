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
@property (nonatomic, strong) NSArray *restArr;
@property (nonatomic, strong) NSArray *restIdArr;
@end

@implementation MultiLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.restArr = @[Localized(@"长在线"), Localized(@"振动休眠"), Localized(@"时间休眠"), Localized(@"深度振动休眠"), Localized(@"定时报告"), Localized(@"定时报告+深度振动休眠")];
//    self.restIdArr = @[@0, @1, @2, @3, @4, @5];
    kWeakSelf(self);
    [CBDeviceTool.shareInstance getXiumianData:^(NSArray * _Nonnull arrayTitle, NSArray * _Nonnull arrayId) {
        weakself.restArr = arrayTitle;
        weakself.restIdArr = arrayId;
    }];
    [self createUI];
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
    self.locationModeView.locationModel = model;
}
#pragma mark - Action
- (void)rightBtnClick
{
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    //[hud hideAnimated: YES];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:4];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";//[AppDelegate shareInstance].currenDeviceSno;
    dic[@"report_way"] = self.locationModeView.getReportWay;
    dic[@"rest_mod"] = @(self.xmChooseView.currentIndex+1);//休眠模式 都要+1   不是0-5是 1-6
    dic[@"dis_qs"] = self.locationModeView.getSpeed;
    dic[@"time_qs"] = self.locationModeView.getTimeQS;
    dic[@"time_rest"] = self.locationModeView.getTimeRest;
    if (self.locationModeView.getTimeQSUnit) {
        dic[@"time_qs_unit"] = self.locationModeView.getTimeQSUnit;
    }
    if (self.locationModeView.getTimeRestUnit) {
        dic[@"time_rest_unit"] = self.locationModeView.getTimeRestUnit;
    }
    dic[@"dcdd"] = @1;
    
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
    
    self.xmChooseView = [[_CBXiuMianChooseView alloc] initWithData:self.restArr :self.restIdArr];
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
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
    }];
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
