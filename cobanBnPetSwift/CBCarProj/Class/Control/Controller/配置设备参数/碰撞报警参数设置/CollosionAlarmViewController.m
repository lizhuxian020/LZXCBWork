//
//  CollosionAlarmViewController.m
//  Telematics
//
//  Created by lym on 2017/11/30.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "CollosionAlarmViewController.h"
#import "ConfigurationParameterModel.h"

@interface CollosionAlarmViewController ()
{
    UIView *collosionView;
    UIView *rollOverView;
}
@property (nonatomic, strong) UITextField *collosionTimeTextField;
@property (nonatomic, strong) UITextField *acceleratedSpeedTextFeild;
@property (nonatomic, strong) UITextField *rollOverTextFeild;

@property (nonatomic, strong) ConfigurationParameterModel *configureModel;
@end

@implementation CollosionAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
    [self getConfigParamters];
}

#pragma mark - Action
- (void)rightBtnClick
{
    
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"碰撞报警参数设置") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"确定") target: self action: @selector(pzParamtersSet)];
    [self showBackGround];
    [self createCollosionView];
    [self createRollOverView];
}
- (void)createCollosionView
{
    collosionView = [[UIView alloc] init];
    collosionView.backgroundColor = [UIColor whiteColor];
    collosionView.layer.shadowColor = [UIColor grayColor].CGColor;
    collosionView.layer.shadowRadius = 5 * KFitWidthRate;
    collosionView.layer.shadowOpacity = 0.3;
    collosionView.layer.shadowOffset  = CGSizeMake(0, 3);// 阴影的范围
    [self.view addSubview: collosionView];
    [collosionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(12.5 * KFitHeightRate + kNavAndStatusHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitHeightRate + 12.5 * KFitHeightRate * 2 + 30 * KFitHeightRate * 2 + 20 * KFitHeightRate);
    }];
    UILabel *collosionTitleLabel = [MINUtils createLabelWithText:Localized(@"碰撞报警参数") size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(73, 73, 73)];
    [collosionView addSubview: collosionTitleLabel];
    [collosionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(collosionView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(collosionView);
        make.width.mas_equalTo(250 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    UIView *lineView = [MINUtils createLineView];
    [collosionView addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(collosionView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(collosionView).with.offset(-12.5 * KFitWidthRate);
        make.top.equalTo(collosionTitleLabel.mas_bottom).with.offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *timeLb = [MINUtils createLabelWithText:[NSString stringWithFormat:@"%@ (ms)",Localized (@"碰撞时间")] size:14];
    [collosionView addSubview:timeLb];
    CGFloat widthTime = [NSString getWidthWithText:[NSString stringWithFormat:@"%@ (ms)",Localized (@"碰撞时间")] font:[UIFont systemFontOfSize:14] height:30];
    
    self.collosionTimeTextField = [MINUtils createBorderTextFieldWithHoldText:@"" fontSize: 12 * KFitWidthRate];
    [collosionView addSubview: self.collosionTimeTextField];
    
    [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(collosionView).with.offset(12.5 * KFitHeightRate);
        make.centerY.mas_equalTo(self.collosionTimeTextField.mas_centerY);
        make.width.mas_equalTo(widthTime);
    }];
    
    [self.collosionTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.height.mas_equalTo(30 * KFitHeightRate);
        //make.left.equalTo(collosionView).with.offset(12.5 * KFitWidthRate);
        make.left.mas_equalTo(timeLb.mas_right).offset(5);
        make.right.equalTo(collosionView).with.offset(-12.5 * KFitWidthRate);
    }];
    
    UILabel *speedLb = [MINUtils createLabelWithText:[NSString stringWithFormat:@"%@ (g)",Localized (@"碰撞加速度")] size:14];
    [collosionView addSubview:speedLb];
    CGFloat widthSpeed = [NSString getWidthWithText:[NSString stringWithFormat:@"%@ (g)",Localized (@"碰撞加速度")] font:[UIFont systemFontOfSize:14] height:30];
    
    self.acceleratedSpeedTextFeild =  [MINUtils createBorderTextFieldWithHoldText:@"" fontSize: 12 * KFitWidthRate];
    [collosionView addSubview: self.acceleratedSpeedTextFeild];
    
    [speedLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(collosionView).with.offset(12.5 * KFitHeightRate);
        make.centerY.mas_equalTo(self.acceleratedSpeedTextFeild.mas_centerY);
        make.width.mas_equalTo(widthSpeed);
    }];
    
    [self.acceleratedSpeedTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collosionTimeTextField.mas_bottom).with.offset(20 * KFitHeightRate);
        make.height.mas_equalTo(30 * KFitHeightRate);
        //make.left.equalTo(collosionView).with.offset(12.5 * KFitWidthRate);
        make.left.mas_equalTo(speedLb.mas_right).offset(5);
        make.right.equalTo(collosionView).with.offset(-12.5 * KFitWidthRate);
    }];
}
- (void)createRollOverView
{
    rollOverView = [[UIView alloc] init];
    rollOverView.backgroundColor = [UIColor whiteColor];
    rollOverView.layer.shadowColor = [UIColor grayColor].CGColor;
    rollOverView.layer.shadowRadius = 5 * KFitWidthRate;
    rollOverView.layer.shadowOpacity = 0.3;
    rollOverView.layer.shadowOffset  = CGSizeMake(0, 3);// 阴影的范围
    [self.view addSubview: rollOverView];
    [rollOverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collosionView.mas_bottom).with.offset(12.5 * KFitHeightRate );
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitHeightRate + 12.5 * KFitHeightRate * 2 + 30 * KFitHeightRate);
    }];
    UILabel *rollOverTitleLabel = [MINUtils createLabelWithText:Localized(@"侧翻报警参数") size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(73, 73, 73)];
    [rollOverView addSubview: rollOverTitleLabel];
    [rollOverTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rollOverView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(rollOverView);
        make.width.mas_equalTo(250 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    UIView *lineView = [MINUtils createLineView];
    [rollOverView addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rollOverView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(rollOverView).with.offset(-12.5 * KFitWidthRate);
        make.top.equalTo(rollOverTitleLabel.mas_bottom).with.offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *angleLb = [MINUtils createLabelWithText:[NSString stringWithFormat:@"%@ (<180°)",Localized (@"侧翻角度")] size:14];
    [rollOverView addSubview:angleLb];
    CGFloat widthAngle = [NSString getWidthWithText:[NSString stringWithFormat:@"%@ (<180°)",Localized (@"侧翻角度")] font:[UIFont systemFontOfSize:14] height:30];
    
    self.rollOverTextFeild = [MINUtils createBorderTextFieldWithHoldText:@"" fontSize: 12 * KFitWidthRate];
    [rollOverView addSubview: self.rollOverTextFeild];
    
    [angleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(collosionView).with.offset(12.5 * KFitHeightRate);
        make.centerY.mas_equalTo(self.rollOverTextFeild.mas_centerY);
        make.width.mas_equalTo(widthAngle);
    }];
    
    [self.rollOverTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.height.mas_equalTo(30 * KFitHeightRate);
        //make.left.equalTo(rollOverView).with.offset(12.5 * KFitWidthRate);
        make.left.mas_equalTo(angleLb.mas_right).offset(5);
        make.right.equalTo(rollOverView).with.offset(-12.5 * KFitWidthRate);
    }];
}

- (void)getConfigParamters {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    //    MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    //    [hud hideAnimated:YES];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devParamController/getDevConfList" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                self.configureModel = [ConfigurationParameterModel yy_modelWithJSON: response[@"data"]];
                
                self.rollOverTextFeild.text = [NSString stringWithFormat:@"%@",self.configureModel.pzCfbj.length <= 0?@"":self.configureModel.pzCfbj];
                self.collosionTimeTextField.text = [NSString stringWithFormat:@"%d",self.configureModel.pzTime];
                self.acceleratedSpeedTextFeild.text = [NSString stringWithFormat:@"%d",self.configureModel.pzSpeed];
                
            }else {
                
            }
        }else {
            
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 碰撞报警参数设置
- (void)pzParamtersSet {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    
    dic[@"pz_time"] = self.collosionTimeTextField.text;

    dic[@"pz_speed"] = self.acceleratedSpeedTextFeild.text;//self.collosionTimeTextField.text;

    dic[@"pz_cfbj"] = self.rollOverTextFeild.text;

    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl: @"devParamController/editDevConf" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
           
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            
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
