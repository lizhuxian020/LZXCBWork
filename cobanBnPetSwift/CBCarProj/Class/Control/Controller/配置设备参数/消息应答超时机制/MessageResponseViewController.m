//
//  MessageResponseViewController.m
//  Telematics
//
//  Created by lym on 2017/11/30.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MessageResponseViewController.h"
#import "MessageResponseModel.h"

@interface MessageResponseViewController ()
@property (nonatomic, strong) UITextField *tcpMessageTextField;
@property (nonatomic, strong) UITextField *udpMessageTextField;
@property (nonatomic, strong) UITextField *smsMessageTextField;
@property (nonatomic, strong) UITextField *tcpRetransmissionTextField;
@property (nonatomic, strong) UITextField *udpRetransmissionTextField;
@property (nonatomic, strong) UITextField *smsRetransmissionTextField;
@property (nonatomic, strong) UITextField *heartbeatTextField;
@property (nonatomic, strong) MessageResponseModel *model;
@end

@implementation MessageResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self requestData];
}

- (void)requestData
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devParamController/getDevParamOvertime" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                MessageResponseModel *model = [MessageResponseModel yy_modelWithJSON: response[@"data"]];
                weakSelf.model = model;
                weakSelf.heartbeatTextField.text = model.heartbeat;
                weakSelf.smsMessageTextField.text = model.smsOuttime;
                weakSelf.smsRetransmissionTextField.text = model.smsCount;
                weakSelf.tcpMessageTextField.text = model.tcpOuttime;
                weakSelf.tcpRetransmissionTextField.text = model.tcpCount;
                weakSelf.udpMessageTextField.text = model.udpOuttime;
                weakSelf.udpRetransmissionTextField.text = model.udpCount;
                //[hud hideAnimated:YES];
            }else {
                //[hud hideAnimated:YES];
            }
        }else {
            //[hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Action
- (void)rightBtnClick
{
    if (self.tcpMessageTextField.text.length < 1) {
        [HUD showHUDWithText:Localized(@"请输入TCP消息应答超时时间") withDelay:1.2];
        return;
    }
    if (self.udpMessageTextField.text.length < 1) {
        [HUD showHUDWithText:Localized(@"请输入UDP消息应答超时时间") withDelay:1.2];
        return;
    }
    if (self.smsMessageTextField.text.length < 1) {
        [HUD showHUDWithText:Localized(@"请输入SMS消息应答超时时间") withDelay:1.2];
        return;
    }
    if (self.heartbeatTextField.text.length < 1) {
        [HUD showHUDWithText:Localized(@"心跳发送间隔") withDelay:1.2];
        return;
    }
    if (self.tcpRetransmissionTextField.text.length < 1 || self.udpRetransmissionTextField.text.length < 1 || self.smsRetransmissionTextField.text.length < 1) {
        [HUD showHUDWithText:Localized(@"重传次数") withDelay:1.2];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    dic[@"tcp_outtime"] = self.tcpMessageTextField.text;
    dic[@"tcp_count"] = self.tcpRetransmissionTextField.text;
    dic[@"udp_outtime"] = self.udpMessageTextField.text;
    dic[@"udp_count"] = self.udpRetransmissionTextField.text;
    dic[@"sms_outtime"] = self.smsMessageTextField.text;
    dic[@"sms_count"] = self.smsRetransmissionTextField.text;
    dic[@"heartbeat"] = self.heartbeatTextField.text;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devParamController/editDevParamOvertime" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [weakSelf.navigationController popViewControllerAnimated: YES];
        }else {
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"消息应答超时机制") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"发送") target: self action: @selector(rightBtnClick)];
    [self showBackGround];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.shadowColor = [UIColor grayColor].CGColor;
    contentView.layer.shadowRadius = 5 * KFitWidthRate;
    contentView.layer.shadowOpacity = 0.3;
    contentView.layer.shadowOffset  = CGSizeMake(0, 3);// 阴影的范围
    [self.view addSubview: contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(12.5 * KFitHeightRate + kNavAndStatusHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo((12.5*KFitHeightRate + 30*KFitHeightRate)*7 + 12.5*KFitHeightRate);
    }];
    self.tcpMessageTextField = [MINUtils createBorderTextFieldWithHoldText:[NSString stringWithFormat:@"%@ (S)",Localized (@"TCP消息应答超时时间")] fontSize: 12 * KFitHeightRate];
    self.udpMessageTextField = [MINUtils createBorderTextFieldWithHoldText:[NSString stringWithFormat:@"%@ (S)",Localized (@"UDP消息应答超时时间")] fontSize: 12 * KFitHeightRate];
    self.smsMessageTextField = [MINUtils createBorderTextFieldWithHoldText:[NSString stringWithFormat:@"%@ (S)",Localized (@"SMS消息应答超时时间")] fontSize: 12 * KFitHeightRate];
    self.tcpRetransmissionTextField = [MINUtils createBorderTextFieldWithHoldText:Localized(@"重传次数") fontSize: 12 * KFitHeightRate];
    self.udpRetransmissionTextField = [MINUtils createBorderTextFieldWithHoldText:Localized(@"重传次数") fontSize: 12 * KFitHeightRate];
    self.smsRetransmissionTextField = [MINUtils createBorderTextFieldWithHoldText:Localized(@"重传次数") fontSize: 12 * KFitHeightRate];
    self.heartbeatTextField = [MINUtils createBorderTextFieldWithHoldText:[NSString stringWithFormat:@"%@ (S)",Localized (@"心跳发送间隔")] fontSize: 12 * KFitHeightRate];
    NSArray *leftTitleArray = @[[NSString stringWithFormat:@"%@ (S)",Localized (@"TCP消息应答超时时间")],Localized(@"重传次数"),[NSString stringWithFormat:@"%@ (S)",Localized (@"UDP消息应答超时时间")],Localized(@"重传次数"),[NSString stringWithFormat:@"%@ (S)",Localized (@"SMS消息应答超时时间")],Localized(@"重传次数"),[NSString stringWithFormat:@"%@ (S)",Localized (@"心跳发送间隔")]];
    NSArray *rightTextArray = @[self.tcpMessageTextField,self.tcpRetransmissionTextField, self.udpMessageTextField,self.udpRetransmissionTextField, self.smsMessageTextField,self.smsRetransmissionTextField,self.heartbeatTextField];
    UITextField *lastView = nil;
    for (int i = 0; i < leftTitleArray.count; i++) {//messageArr
        UILabel *leftTitle = [UILabel new];
        leftTitle.text = leftTitleArray[i];
        leftTitle.font = [UIFont systemFontOfSize:12*KFitHeightRate];
        leftTitle.textColor = kTextFieldColor;
        [contentView addSubview:leftTitle];
        
        UITextField *rightTexfField = rightTextArray[i];
        [contentView addSubview:rightTexfField];
        
        CGFloat width = [NSString getWidthWithText:leftTitleArray[i] font:[UIFont systemFontOfSize:12*KFitHeightRate] height:30*KFitHeightRate];
        if (lastView == nil) {
            [leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(contentView).with.offset(12.5 * KFitHeightRate);
                make.height.mas_equalTo(30*KFitHeightRate);
                make.width.mas_equalTo(width);
            }];
            [rightTexfField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftTitle.mas_right).with.offset(12.5*KFitHeightRate);
                make.right.equalTo(contentView).with.offset(-12.5*KFitHeightRate);
                make.centerY.mas_equalTo(leftTitle.mas_centerY);
                make.height.mas_equalTo(30*KFitHeightRate);
            }];
            
            
        } else {
            [leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(contentView).with.offset(12.5 * KFitHeightRate);
                make.top.mas_equalTo(lastView.mas_bottom).offset(12.5*KFitHeightRate);
                make.height.mas_equalTo(30*KFitHeightRate);
            }];
            [rightTexfField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftTitle.mas_right).with.offset(12.5*KFitHeightRate);
                make.right.equalTo(contentView).with.offset(-12.5*KFitHeightRate);
                make.centerY.mas_equalTo(leftTitle.mas_centerY);
                make.height.mas_equalTo(30*KFitHeightRate);
            }];
        }
        lastView = rightTexfField;
    }
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
