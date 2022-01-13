//
//  NetWorkConfigurationViewController.m
//  Telematics
//
//  Created by lym on 2017/11/29.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "NetWorkConfigurationViewController.h"
#import "NetWorkConfigView.h"
#import "NetworkConfigurationModel.h"

@interface NetWorkConfigurationViewController ()
{
    BOOL keyboardIsShown;
}
@property (nonatomic, strong) NetWorkConfigView *mainSerVerView;
@property (nonatomic, strong) NetWorkConfigView *backupSerVerView;
@property (nonatomic, strong) NetWorkConfigView *addRequestView;
@property (nonatomic, strong) NetWorkConfigView *joinUPView;
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak) UITextField *currentTextField;
@property (nonatomic, strong) NetworkConfigurationModel *model;
@end

@implementation NetWorkConfigurationViewController

-(void) viewWillAppear:(BOOL)animated{
    //键盘弹起的通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:self.view.window];
    //键盘隐藏的通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

//键盘弹起后处理scrollView的高度使得textfield可见
-(void)keyboardWillShow:(NSNotification *)notification{
    if (keyboardIsShown) {
        return;
    }
//    NSDictionary * info = [notification userInfo];
//    NSValue *avalue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [self.view convertRect:[avalue CGRectValue] fromView:nil];
//    [UIView animateWithDuration: 0.3 animations:^{
//        if (self.currentTextField != nil) {
//            [self.scrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(self.view).with.offset(-keyboardRect.size.height - 10 * KFitHeightRate);
//            }];
//            [self.scrollerView.superview layoutIfNeeded];
//        }
//    }];
    keyboardIsShown = YES;
}


//键盘隐藏后处理scrollview的高度，使其还原为本来的高度
-(void)keyboardWillHide:(NSNotification *)notification{
//    NSDictionary *info = [notification userInfo];
//    NSValue *avalue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [self.view convertRect:[avalue CGRectValue] fromView:nil];
//    [UIView animateWithDuration: 0.3 animations:^{
//        [self.scrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.view).with.offset(0);
//        }];
//        [self.scrollerView.superview layoutIfNeeded];
//    }];
    keyboardIsShown = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self addGesture];
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
    [[NetWorkingManager shared]getWithUrl:@"devParamController/getDevParamNetwork" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                NetworkConfigurationModel *model = [NetworkConfigurationModel yy_modelWithJSON: response[@"data"]];
                weakSelf.model = model;
                weakSelf.mainSerVerView.ipOrApnTextField.text = model.masterIp;
                weakSelf.mainSerVerView.domainNameOrUserNameTextField.text = model.masterName;
                weakSelf.mainSerVerView.tcpTextField.text = model.masterTcp;
                weakSelf.mainSerVerView.udpTextField.text = model.masterUdp;
                weakSelf.backupSerVerView.ipOrApnTextField.text = model.slaveIp;
                weakSelf.backupSerVerView.domainNameOrUserNameTextField.text = model.slaveName;
                weakSelf.addRequestView.ipOrApnTextField.text = model.addrIp;
                weakSelf.addRequestView.domainNameOrUserNameTextField.text = model.addrName;
                weakSelf.addRequestView.tcpTextField.text = model.addrTcp;
                weakSelf.addRequestView.udpTextField.text = model.addrUdp;
                weakSelf.joinUPView.ipOrApnTextField.text = model.linkApn;
                weakSelf.joinUPView.domainNameOrUserNameTextField.text = model.linkUser;
                weakSelf.joinUPView.passTextField.text = model.linkPwd;
                
            }else {
                
            }
        }else {
            
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - gesture
- (void)addGesture
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)keyboardHide
{
    [self.mainSerVerView keyboardHide];
    [self.backupSerVerView keyboardHide];
    [self.addRequestView keyboardHide];
    [self.joinUPView keyboardHide];
}

#pragma mark - Action
- (void)rightBtnClick
{
//    if (self.mainSerVerView.ipOrApnTextField.text.length < 1) {
//        [HUD showHUDWithText:Localized(@"请输入主服务器IP") withDelay:1.2];
//        return;
//    }
//    if (self.mainSerVerView.domainNameOrUserNameTextField.text.length < 1) {
//        [HUD showHUDWithText:Localized(@"请输入主服务器域名") withDelay:1.2];
//        return;
//    }
//    if (self.mainSerVerView.tcpTextField.text.length < 1) {
//        [HUD showHUDWithText:Localized(@"请输入主服务器TCP端口") withDelay:1.2];
//        return;
//    }
//    if (self.mainSerVerView.udpTextField.text.length < 1) {
//        [HUD showHUDWithText:Localized(@"请输入主服务器UDP端口") withDelay:1.2];
//        return;
//    }
//    if (self.backupSerVerView.ipOrApnTextField.text.length < 1) {
//        [HUD showHUDWithText:Localized(@"请输入备份服务器IP") withDelay:1.2];
//        return;
//    }
//    if (self.backupSerVerView.domainNameOrUserNameTextField.text.length < 1) {
//        [HUD showHUDWithText:Localized(@"请输入备份服务器域名") withDelay:1.2];
//        return;
//    }
//    if (self.addRequestView.ipOrApnTextField.text.length < 1) {
//        [HUD showHUDWithText:Localized(@"请输入地址请求服务器IP") withDelay:1.2];
//        return;
//    }
//    if (self.addRequestView.domainNameOrUserNameTextField.text.length < 1) {
//        [HUD showHUDWithText:Localized(@"请输入地址请求服务器域名") withDelay:1.2];
//        return;
//    }
//    if (self.addRequestView.tcpTextField.text.length < 1) {
//        [HUD showHUDWithText:Localized(@"请输入地址请求服务器TCP端口") withDelay:1.2];
//        return;
//    }
//    if (self.addRequestView.udpTextField.text.length < 1) {
//        [HUD showHUDWithText:Localized(@"请输入地址请求服务器UDP端口") withDelay:1.2];
//        return;
//    }
//    if (self.joinUPView.ipOrApnTextField.text.length < 1) {
//        [HUD showHUDWithText:Localized(@"请输入接入点APN") withDelay:1.2];
//        return;
//    }
//    if (self.joinUPView.domainNameOrUserNameTextField.text.length < 1) {
//        [HUD showHUDWithText:Localized(@"请输入接入点用户名") withDelay:1.2];
//        return;
//    }if (self.joinUPView.passTextField.text.length < 1) {
//        [HUD showHUDWithText:Localized(@"请输入接入点密码") withDelay:1.2];
//        return;
//    }
    
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    dic[@"master_ip"] = self.mainSerVerView.ipOrApnTextField.text;
    dic[@"master_name"] = self.mainSerVerView.domainNameOrUserNameTextField.text;
    dic[@"master_tcp"] = self.mainSerVerView.tcpTextField.text;
    
//    dic[@"master_udp"] = self.mainSerVerView.udpTextField.text;
//    dic[@"slave_ip"] = self.backupSerVerView.ipOrApnTextField.text;
//    dic[@"slave_name"] = self.backupSerVerView.domainNameOrUserNameTextField.text;
//    dic[@"addr_ip"] = self.addRequestView.ipOrApnTextField.text;
//    dic[@"addr_name"] = self.addRequestView.domainNameOrUserNameTextField.text;
//    dic[@"addr_tcp"] = self.addRequestView.tcpTextField.text;
//    dic[@"addr_udp"] = self.addRequestView.udpTextField.text;
//    dic[@"link_apn"] = self.joinUPView.ipOrApnTextField.text;
//    dic[@"link_user"] = self.joinUPView.domainNameOrUserNameTextField.text;
//    dic[@"link_pwd"] = self.joinUPView.passTextField.text;
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devParamController/editDevParamNetwork" params: dic succeed:^(id response,BOOL isSucceed) {
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self initBarWithTitle:Localized(@"网络配置") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"保存") target: self action: @selector(rightBtnClick)];
//    self.scrollerView = [[UIScrollView alloc] init];
//    [self.view addSubview: self.scrollerView];
//    [self.scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.left.equalTo(self.view);
//        make.bottom.equalTo(self.view).with.offset(0);
//    }];
    self.contentView = [[UIView alloc] init];
    [self.view addSubview: self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(PPNavigationBarHeight+12.5*frameSizeRate);
        make.bottom.equalTo(self.view);//.with.insets(UIEdgeInsetsZero);
        //make.width.equalTo(self.view);
        make.left.mas_equalTo(12.5*frameSizeRate);
        make.right.mas_equalTo(-12.5*frameSizeRate);
    }];
    self.mainSerVerView = [[NetWorkConfigView alloc] initWithType:2];//1
    self.mainSerVerView.titleLabel.text = Localized(@"主服务器");
    [self.mainSerVerView setIpOrApnLabelText: @"IP:"];
    [self.mainSerVerView setDomainNameOrUserNameLabelText:Localized(@"域名:")];
    __weak __typeof__(self) weakSelf = self;
    self.mainSerVerView.textFieldDidEdit = ^(UITextField *textField) {
        weakSelf.currentTextField = textField;
    };
    [self.contentView addSubview: self.mainSerVerView];
    [self.mainSerVerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(12.5 * KFitHeightRate);
        //make.width.mas_equalTo(SCREEN_HEIGHT);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(200 * KFitHeightRate - 50);
    }];
//    self.backupSerVerView = [[NetWorkConfigView alloc] initWithType: 2];
//    self.backupSerVerView.titleLabel.text = Localized(@"备份服务器");
//    [self.backupSerVerView showHideBtn];
//    [self.backupSerVerView setIpOrApnLabelText: @"IP:"];
//    [self.backupSerVerView setDomainNameOrUserNameLabelText:Localized(@"域名:")];
//    self.backupSerVerView.textFieldDidEdit = ^(UITextField *textField) {
//        weakSelf.currentTextField = textField;
//    };
//    [self.contentView addSubview: self.backupSerVerView];
//    [self.backupSerVerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mainSerVerView.mas_bottom).with.offset(12.5 * KFitHeightRate);
//        make.width.mas_equalTo(SCREEN_HEIGHT);
//        make.left.equalTo(self.contentView);
//        make.height.mas_equalTo(150 * KFitHeightRate);
//    }];
//    self.addRequestView = [[NetWorkConfigView alloc] initWithType: 1];
//    self.addRequestView.titleLabel.text = Localized(@"地址请求服务器");
//    [self.addRequestView showHideBtn];
//    [self.addRequestView setIpOrApnLabelText: @"IP:"];
//    [self.addRequestView setDomainNameOrUserNameLabelText:Localized(@"域名:")];
//    self.addRequestView.textFieldDidEdit = ^(UITextField *textField) {
//        weakSelf.currentTextField = textField;
//    };
//    [self.contentView addSubview: self.addRequestView];
//    [self.addRequestView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.backupSerVerView.mas_bottom).with.offset(12.5 * KFitHeightRate);
//        make.width.mas_equalTo(SCREEN_HEIGHT);
//        make.left.equalTo(self.contentView);
//        make.height.mas_equalTo(200 * KFitHeightRate);
//    }];
//    self.joinUPView = [[NetWorkConfigView alloc] initWithType: 3];
//    self.joinUPView.titleLabel.text = Localized(@"接入点设置");
//    [self.joinUPView showHideBtn];
//    [self.joinUPView setIpOrApnLabelText:Localized(@"APN:")];
//    [self.joinUPView setDomainNameOrUserNameLabelText:Localized(@"用户名:")];
//    [self.joinUPView setPassLabelText:Localized(@"密码:")];
//    self.joinUPView.textFieldDidEdit = ^(UITextField *textField) {
//        weakSelf.currentTextField = textField;
//    };
//    [self.contentView addSubview: self.joinUPView];
//    [self.joinUPView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.addRequestView.mas_bottom).with.offset(12.5 * KFitHeightRate);
//        make.width.mas_equalTo(SCREEN_HEIGHT);
//        make.left.equalTo(self.contentView);
//        make.height.mas_equalTo(200 * KFitHeightRate);
//    }];
//    [self.scrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.joinUPView.mas_bottom).with.offset(12.5 * KFitHeightRate);
//    }];
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
