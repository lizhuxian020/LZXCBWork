//
//  FatigueDrivingViewController.m
//  Telematics
//
//  Created by lym on 2017/11/30.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "FatigueDrivingViewController.h"
#import "FatigueDirvingModel.h"

@interface FatigueDrivingViewController ()
@property (nonatomic, strong) UITextField *continuousDrivingTextField;
@property (nonatomic, strong) UITextField *cumulativeDrivingTextField;
@property (nonatomic, strong) UITextField *minimumRestTextField;
@property (nonatomic, strong) UITextField *longestPullUpTextField;
@property (nonatomic, strong) UITextField *fatigueDrivingTextField;
@property (nonatomic, strong) FatigueDirvingModel *model;
@end

@implementation FatigueDrivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self requestData];
}
#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"疲劳驾驶参数设置") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"确定") target: self action: @selector(rightBtnClick)];
    [self showBackGround];
    [self createContentView];
}
- (void)createContentView {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.shadowColor = [UIColor grayColor].CGColor;
    contentView.layer.shadowRadius = 5 * KFitWidthRate;
    contentView.layer.shadowOpacity = 0.3;
    contentView.layer.shadowOffset  = CGSizeMake(0, 3);// 阴影的范围
    [self.view addSubview: contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(12.5 * KFitHeightRate + kNavAndStatusHeight);
        make.height.mas_equalTo(12.5 * KFitHeightRate * 2 + 20 * KFitHeightRate * 4 + 30 * KFitHeightRate * 5);
    }];
    self.continuousDrivingTextField = [MINUtils createBorderTextFieldWithHoldText:Localized(@"") fontSize: 12 *  KFitHeightRate];
    self.cumulativeDrivingTextField = [MINUtils createBorderTextFieldWithHoldText:Localized(@"") fontSize: 12 *  KFitHeightRate];
    self.minimumRestTextField = [MINUtils createBorderTextFieldWithHoldText:Localized(@"") fontSize: 12 *  KFitHeightRate];
    self.longestPullUpTextField = [MINUtils createBorderTextFieldWithHoldText:Localized(@"") fontSize: 12 *  KFitHeightRate];
    self.fatigueDrivingTextField  = [MINUtils createBorderTextFieldWithHoldText:Localized(@"") fontSize: 12 *  KFitHeightRate];
    NSArray *array = @[self.continuousDrivingTextField, self.cumulativeDrivingTextField, self.minimumRestTextField, self.longestPullUpTextField, self.fatigueDrivingTextField];
    NSArray *arrayTitle = @[Localized(@"连续驾驶时间限制 (S)"),Localized(@"当天累计驾驶时间限制 (S)"),Localized(@"最小休息时间 (S)"),Localized(@"最长停留时间 (S)"),Localized(@"疲劳驾驶预警差值 (S)")];
    UITextField *lastView = nil;
    for (int i = 0; i < array.count; i++) {
        UITextField *textField = array[i];
        [contentView addSubview:textField];
        
        UILabel *lab = [MINUtils createLabelWithText:arrayTitle[i] size:14];
        [contentView addSubview:lab];
        CGFloat width = [NSString getWidthWithText:arrayTitle[i] font:[UIFont systemFontOfSize:14] height:30];
        
        if (lastView == nil) {
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(contentView).with.offset(12.5 * KFitHeightRate);
                make.centerY.mas_equalTo(textField.mas_centerY);
                make.width.mas_equalTo(width);
            }];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(contentView).with.offset(12.5 * KFitHeightRate);
                make.left.mas_equalTo(lab.mas_right).offset(5);
                make.right.equalTo(contentView).with.offset(-12.5 * KFitHeightRate);
                make.height.mas_equalTo(30 * KFitHeightRate);
            }];
            
        }else {
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(contentView).with.offset(12.5 * KFitHeightRate);
                make.centerY.mas_equalTo(textField.mas_centerY);
                make.width.mas_equalTo(width);
            }];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).with.offset(20 * KFitHeightRate);
                make.left.mas_equalTo(lab.mas_right).offset(5);
                make.right.equalTo(contentView).with.offset(-12.5 * KFitHeightRate);
                make.height.mas_equalTo(30 * KFitHeightRate);
            }];
        }
        lastView = textField;
    }
}
- (void)requestData {
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devParamController/getDevParamDriver" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                FatigueDirvingModel *model = [FatigueDirvingModel yy_modelWithJSON: response[@"data"]];
                weakSelf.model = model;
                weakSelf.continuousDrivingTextField.text = model.keepLimit;
                weakSelf.cumulativeDrivingTextField.text = model.todayLimit;
                weakSelf.minimumRestTextField.text = model.minRest;
                weakSelf.longestPullUpTextField.text = model.maxRest;
                weakSelf.fatigueDrivingTextField.text = model.differ;
          
            }else {
       
            }
        }else {

        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Action
- (void)rightBtnClick
{
    if (self.continuousDrivingTextField.text.length < 1) {
        [HUD showHUDWithText: @"请输入连续驾驶时间限制 (S)" withDelay:1.2];
        return;
    }
    if (self.cumulativeDrivingTextField.text.length < 1) {
        [HUD showHUDWithText: @"请输入当天累计驾驶时间限制 (S)" withDelay:1.2];
        return;
    }
    if (self.minimumRestTextField.text.length < 1) {
        [HUD showHUDWithText: @"请输入最小休息时间 (S)" withDelay:1.2];
        return;
    }
    if (self.longestPullUpTextField.text.length < 1) {
        [HUD showHUDWithText: @"请输入最长停留时间 (S)" withDelay:1.2];
        return;
    }
    if (self.fatigueDrivingTextField.text.length < 1) {
        [HUD showHUDWithText: @"请输入疲劳驾驶预警差值 (S)" withDelay:1.2];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    dic[@"keep_limit"] = self.continuousDrivingTextField.text;
    dic[@"today_limit"] = self.cumulativeDrivingTextField.text;
    dic[@"min_rest"] = self.minimumRestTextField.text;
    dic[@"max_rest"] = self.longestPullUpTextField.text;
    dic[@"differ"] = self.fatigueDrivingTextField.text;
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devParamController/editDevParamDriver" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {

            [weakSelf.navigationController popViewControllerAnimated: YES];
        }else {

        }
    } failed:^(NSError *error) {
        kWeakSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
}


#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
