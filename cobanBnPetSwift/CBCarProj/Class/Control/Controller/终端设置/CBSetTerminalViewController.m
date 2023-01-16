//
//  CBSetTerminalViewController.m
//  Telematics
//
//  Created by coban on 2019/11/18.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBSetTerminalViewController.h"
#import "MINControlListDataModel.h"
#import "ControlTableViewCell.h"
#import "CBControlAlertPopView.h"
#import "CBControlInputPopView.h"
#import "CBControlPickPopView.h"
#import "ConfigurationParameterModel.h"
#import "PhoneBookViewController.h"
#import "FatigueDrivingViewController.h"
#import "CollosionAlarmViewController.h"
#import "CBControlSetOilPopView.h"
#import "CBControlSetRestPopView.h"
#import "NetWorkConfigurationViewController.h"
#import "CBTimeZoneViewController.h"
#import "CBCarControlConfig.h"
#import "CBTerminalSwitchModel.h"

@interface CBSetTerminalViewController ()<UITableViewDelegate, UITableViewDataSource,CBControlAlertPopViewDelegate,CBControlPickPopViewDelegate,CBControlInputPopViewDelegate,CBControlSetOilPopViewDelegate,CBControlSetRestPopViewDelegate>

@property (nonatomic, strong) MINControlListDataModel *termialControlStatusModel;
@property (nonatomic, strong) ConfigurationParameterModel *configurationModel;
@property (nonatomic, strong) CBTerminalSwitchModel *switchModel;
@property (nonatomic,strong) NSMutableArray *arrayData;
/** 警告弹窗 */
@property (nonatomic, strong) CBControlAlertPopView *alertPopView;
/** 输入弹窗 */
@property (nonatomic, strong) CBControlInputPopView *inputPopView;
/** 选择弹窗 */
@property (nonatomic, strong) CBControlPickPopView *pickerPopView;
/** 油量校准弹窗 */
@property (nonatomic, strong) CBControlSetOilPopView *setOilPopView;
/** 选择休眠模式弹窗 */
@property (nonatomic, strong) CBControlSetRestPopView *setRestPopView;

@end

@implementation CBSetTerminalViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestData];
}
- (void)requestData {
    [self terminalGetControlStatusRequest];
    [self getTerminalSettingReqeust];
    [self requestSwichModel];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(requestData) name:@"CBCAR_NOTFICIATION_GETMQTT_CODE2" object:nil];
}
- (void)setupView {
    [self initBarWithTitle:Localized(@"终端设置") isBack: YES];
    self.view.backgroundColor = kRGB(247, 247, 247);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}
- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = [NSMutableArray array];
        __block NSArray *arrayTitle = nil;
        __block NSArray *arrayTitleImage = nil;
        [CBDeviceTool.shareInstance getDeviceConfigData:_deviceInfoModelSelect blk:^(NSArray * _Nonnull _arrayTitle, NSArray * _Nonnull _arrayTitleImage) {
            arrayTitle = _arrayTitle;
            arrayTitleImage = _arrayTitleImage;
        }];
        for (int i = 0 ; i < arrayTitle.count ; i ++ ) {
            CBControlModel *controlModel = [[CBControlModel alloc]init];
            controlModel.titleStr = arrayTitle[i];
            controlModel.leftImageStr = arrayTitleImage[i];
            [_arrayData addObject:controlModel];
        }
    }
    return _arrayData;
}
- (CBControlAlertPopView *)alertPopView {
    if (!_alertPopView) {
        _alertPopView = [[CBControlAlertPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _alertPopView.delegate = self;
    }
    return _alertPopView;
}
- (CBControlInputPopView *)inputPopView {
    if (!_inputPopView) {
        _inputPopView = [[CBControlInputPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _inputPopView.delegate = self;
    }
    return _inputPopView;
}
- (CBControlPickPopView *)pickerPopView {
    if (!_pickerPopView) {
        _pickerPopView = [[CBControlPickPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _pickerPopView.delegate = self;
    }
    return _pickerPopView;
}
- (CBControlSetOilPopView *)setOilPopView {
    if (!_setOilPopView) {
        _setOilPopView = [[CBControlSetOilPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _setOilPopView.delegate = self;
    }
    return _setOilPopView;
}
- (CBControlSetRestPopView *)setRestPopView {
    if (!_setRestPopView) {
        _setRestPopView = [[CBControlSetRestPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _setRestPopView.delegate = self;
    }
    return _setRestPopView;
}
#pragma mark -- 获取开关类设备控制参数
- (void)requestSwichModel {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:_deviceInfoModelSelect.dno?:@"" forKey:@"dno"];
    kWeakSelf(self);
    [[NetWorkingManager shared] getWithUrl:@"devControlController/getDeviceSwitchControl" params:paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"---------结果：%@",response);
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                self.switchModel = [CBTerminalSwitchModel yy_modelWithJSON:response[@"data"]];
                [self.tableView reloadData];
            }
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)terminalGetControlStatusRequest {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:_deviceInfoModelSelect.dno?:@"" forKey:@"dno"];
    kWeakSelf(self);
    [[NetWorkingManager shared] getWithUrl:@"devControlController/getParamListApp" params:paramters succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"---------结果：%@",response);
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                self.termialControlStatusModel = [MINControlListDataModel yy_modelWithJSON:response[@"data"]];
                [self.tableView reloadData];
            }
        } else {
            [self.tableView reloadData];
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 获取终端设置参数
- (void)getTerminalSettingReqeust {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:_deviceInfoModelSelect.dno?:@"" forKey:@"dno"];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devParamController/getDevConfList" params:paramters succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"---------结果：%@",response);
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                self.configurationModel = [ConfigurationParameterModel yy_modelWithJSON: response[@"data"]];
                [self.tableView reloadData];
            }
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    ControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ControlTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (self.arrayData.count > indexPath.row) {
        CBControlModel *model = self.arrayData[indexPath.row];
        cell.indexPath = indexPath;
        cell.controlModel = model;
        cell.centerLabel.text = @"";
        cell.controlListModel = self.termialControlStatusModel;
        cell.configurationModel = self.configurationModel;
        cell.switchModel = self.switchModel;
        kWeakSelf(self);
        cell.switchStateChangeBlock = ^(NSIndexPath *indexPath, BOOL isON) {
            kStrongSelf(self);
            NSLog(@"%ld %d", (long)indexPath.row , isON);
            NSLog(@"点击的类型%@ %d", model.titleStr , isON);
            [self terminalSwitchClick:model.titleStr status:isON ? @"1" : @"0"];
        };
    }
    return cell;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrayData.count > indexPath.row) {
        CBControlModel *model = self.arrayData[indexPath.row];
        [self cellClickTitle:model.titleStr];
    }
}
- (void)cellClickTitle:(NSString *)title {
    if ([title isEqualToString:_ControlConfigTitle_SQSZ]) {//时区设置
//        CBTimeZoneViewController *vc = [CBTimeZoneViewController new];
//        [self.navigationController pushViewController:vc animated: YES];
        [self showSQSZ];
    } else if ([title isEqualToString:_ControlConfigTitle_SZDXMM]) {//设置短信密码
//        [self.inputPopView updateTitle:Localized(@"设置短信密码") placehold:Localized(@"输入短信密码") isDigital:YES];
//        [self.inputPopView popView];
        [self showSZDXMM];
    } else if ([title isEqualToString:_ControlConfigTitle_SZSQHM]) {//设置授权号码
        PhoneBookViewController *phoneBookVC = [[PhoneBookViewController alloc] init];
        phoneBookVC.deviceInfoModelSelect = self.deviceInfoModelSelect;
        [self.navigationController pushViewController: phoneBookVC animated: YES];
    } else if ([title isEqualToString:_ControlConfigTitle_SZYXRJ]) {//设置油箱容积(L)
        //        [self.inputPopView updateTitle:Localized(@"设置油箱容积(L)") placehold:Localized(@"输入油箱容积(L)") isDigital:YES];
        //        [self.inputPopView popView];
        [self showSZYXRJ];
    } else if ([title isEqualToString:_ControlConfigTitle_SZYLJZ]) {//设置油量校准
//        [self.setOilPopView popView];
        [self showSZYLJZ];
    } else if ([title isEqualToString:_ControlConfigTitle_SZLCCSZ]) {//设置里程初始值(m)
        //        [self.inputPopView updateTitle:Localized(@"设置里程初始值(m)") placehold:Localized(@"输入里程初始值(m)") isDigital:YES];
        //        [self.inputPopView popView];
        [self showSZLCCSZ];
    } else if ([title isEqualToString:_ControlConfigTitle_ACCGZTZ]) {//ACC
    } else if ([title isEqualToString:_ControlConfigTitle_PYYZ]) {//ACC
    } else if ([title isEqualToString:_ControlConfigTitle_SZZWBBJD]) {
//        [self.inputPopView updateTitle:Localized(@"设置转弯补报角度(<180°)") placehold:Localized(@"输入转弯补报角度°") isDigital:YES];
//        [self.inputPopView popView];
        [self showSZZWBBJD];
    } else if ([title isEqualToString:_ControlConfigTitle_SZBJDXFSCS]) {
//        [self.inputPopView updateTitle:Localized(@"设置报警短信发送次数") placehold:Localized(@"输入发送次数") isDigital:YES];
//        [self.inputPopView popView];
        [self showSZBJDXFSCS];
    } else if ([title isEqualToString:_ControlConfigTitle_SZXTJG]) {
//        [self.inputPopView updateTitle:Localized(@"设置心跳间隔") placehold:Localized(@"输入心跳间隔") isDigital:YES];
//        [self.inputPopView popView];
        [self showSZXTJG];
    } else if ([title isEqualToString:_ControlConfigTitle_ZDLMD]) {
//        [self.pickerPopView popView];
//        NSArray *array = @[Localized(@"高"),Localized(@"中"),Localized(@"低")];
//        NSString *seletStr = @"";
//        switch (self.termialControlStatusModel.sensitivity) {
//            case 1:
//                seletStr = Localized(@"高");
//                break;
//            case 2:
//                seletStr = Localized(@"中");
//                break;
//            case 3:
//                seletStr = Localized(@"低");
//                break;
//            default:
//                break;
//        }
//        [self.pickerPopView updateTitle:Localized(@"振动灵敏度") menuArray:array seletedTitle:seletStr];
        [self showZDLMD];
    } else if ([title isEqualToString:_ControlConfigTitle_PZJC]) {
        [self showPZJC];
    } else if ([title isEqualToString:_ControlConfigTitle_JZW]) {
        [self showJZW];
    } else if ([title isEqualToString:_ControlConfigTitle_JJS]) {
        [self showJJS];
    } else if ([title isEqualToString:_ControlConfigTitle_JSC]) {
        [self showJSC];
    } else if ([title isEqualToString:_ControlConfigTitle_CSHSZ]) {
        [self showCSHSZ];
    } else if ([title isEqualToString:_ControlConfigTitle_SBCQ]) {
//        [self.alertPopView updateTitle:Localized(@"设备重启") msg:Localized(@"确定重启?")];
//        [self.alertPopView popView];
        [self showSBCQ];
    }
    /*--------------------------以下暂时无用--------------------------*/
    else if ([title isEqualToString:Localized(@"始终在线")]) {
        [self.alertPopView updateTitle:Localized(@"始终在线") msg:Localized(@"确定切换?")];
        [self.alertPopView popView];
    } else if ([title isEqualToString:Localized(@"休眠模式")]) {
        [self.setRestPopView popView];
        [self.setRestPopView updateType:[NSString stringWithFormat:@"%ld",(long)self.termialControlStatusModel.restMod]];
    } else if ([title isEqualToString:_ControlConfigTitle_SZYLJZ]) {
        [self.setOilPopView popView];
    } else if ([title isEqualToString:Localized(@"疲劳驾驶参数设置")]) {
        FatigueDrivingViewController *fatigueDrivingVC = [[FatigueDrivingViewController alloc] init];
        [self.navigationController pushViewController: fatigueDrivingVC animated: YES];
    } else if ([title isEqualToString:Localized(@"碰撞报警参数设置")]) {
        CollosionAlarmViewController *collosionVC = [[CollosionAlarmViewController alloc] init];
        [self.navigationController pushViewController: collosionVC animated: YES];
    } else if ([title isEqualToString:Localized(@"服务器转移")]) {
        NetWorkConfigurationViewController *netWorkVC = [[NetWorkConfigurationViewController alloc] init];
        [self.navigationController pushViewController: netWorkVC animated: YES];
    }
}
#pragma mark -- 各种弹框
- (void)showSQSZ {
    kWeakSelf(self);
    [[CBCarAlertView viewWithSQSZTitle:_ControlConfigTitle_SQSZ initText:self.termialControlStatusModel.timeZone confrim:^(NSString * _Nonnull contentStr) {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
            @"timeZone": contentStr,
        }];
        [weakself terminalEditControlNewRequest:param success:^{
            weakself.termialControlStatusModel.timeZone = contentStr;
        }];
    }] pop];
}

- (void)showSZDXMM {
    kWeakSelf(self);
    [[CBCarAlertView viewWithMultiInput:@[Localized(@"输入6位短信密码"),Localized(@"请再次输入密码")] title:_ControlConfigTitle_SZDXMM  isDigital:YES confirmCanDismiss:^BOOL(NSArray<NSString *> * _Nonnull contentStr) {
        if (kStringIsEmpty(contentStr.firstObject) || kStringIsEmpty(contentStr.lastObject)) {
            [HUD showHUDWithText:Localized(@"参数不能为空")];
            return NO;
        }
        if ([contentStr.firstObject isEqualToString:contentStr.lastObject]) {
            if (contentStr.firstObject.length != 6) {
                [HUD showHUDWithText:Localized(@"请输入6位数的密码")];
                return NO;
            }
            return YES;
        } else {
            [HUD showHUDWithText:Localized(@"两次输入的密码不一致")];
            return NO;
        }
    } confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
            @"password": contentStr.firstObject,
        }];
        [weakself terminalEditControlNewRequest:param success:^{
            weakself.configurationModel.password = contentStr.firstObject;
        }];
    }] pop];
}
- (void)showSZYXRJ {
    kWeakSelf(self);
    [[CBCarAlertView viewWithMultiInput:@[Localized(@"输入油箱容积(L)")] title:_ControlConfigTitle_SZYXRJ isDigital:YES confirmCanDismiss:nil confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
            @"volume": contentStr.firstObject,
        }];
        [weakself terminalEditControlNewRequest:param success:^{
            weakself.configurationModel.volume = contentStr.firstObject.intValue;
        }];
    }] pop];
}

- (void)showSZYLJZ {
    kWeakSelf(self);
    [[CBCarAlertView viewWithChooseData:@[Localized(@"零值校准"),Localized(@"满值校准")] selectedIndex:self.configurationModel.oilValidate title:_ControlConfigTitle_SZYLJZ didClickData:^(NSString * _Nonnull contentStr, NSInteger index) {
        
    } confrim:^(NSString * _Nonnull contentStr, NSInteger index) {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
            @"oil_validate": @(index),
        }];
        [weakself terminalEditControlNewRequest:param success:^{
            weakself.configurationModel.oilValidate = index;
        }];
    }] pop];
}
- (void)showSZLCCSZ {
    kWeakSelf(self);
    [[CBCarAlertView viewWithMultiInput:@[Localized(@"输入里程初始值(m)")] title:_ControlConfigTitle_SZLCCSZ isDigital:YES confirmCanDismiss:nil confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
            @"mileage": contentStr.firstObject,
        }];
        [weakself terminalEditControlNewRequest:param success:^{
            weakself.configurationModel.mileage = contentStr.firstObject.intValue;
        }];
    }] pop];
}
- (void)showSZZWBBJD {
    kWeakSelf(self);
    [[CBCarAlertView viewWithMultiInput:@[Localized(@"输入转弯补报角度°")] title:_ControlConfigTitle_SZZWBBJD isDigital:YES confirmCanDismiss:nil confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
        if (contentStr.firstObject.intValue < 5) {
            //TODO: LZXTODO 英文文案
            [CBTopAlertView alertFail:Localized(@"设置转弯补报角度最低不能小于5度")];
            return;
        }
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
            @"angle": contentStr.firstObject,
        }];
        [weakself terminalEditControlNewRequest:param success:^{
            weakself.configurationModel.angle = contentStr.firstObject.intValue;
        }];
    }] pop];
}
- (void)showSZBJDXFSCS {
    kWeakSelf(self);
    [[CBCarAlertView viewWithMultiInput:@[Localized(@"输入发送次数")] title:_ControlConfigTitle_SZBJDXFSCS isDigital:YES  confirmCanDismiss:nil confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
            @"send_msg_limit": contentStr.firstObject,
        }];
        [weakself terminalEditControlNewRequest:param success:^{
            weakself.configurationModel.sendMsgLimit = contentStr.firstObject.intValue;
        }];
    }] pop];
}
- (void)showSZXTJG {
    kWeakSelf(self);
    [[CBCarAlertView viewWithMultiInput:@[Localized(@"输入心跳间隔")] title:_ControlConfigTitle_SZXTJG isDigital:YES  confirmCanDismiss:^(NSArray<NSString *> *contentStr){
        if (kStringIsEmpty(contentStr.firstObject)) {
            [HUD showHUDWithText:Localized(@"参数不呢为空")];
            return NO;
        }
        if (contentStr.firstObject.intValue < 60) {
            [HUD showHUDWithText:Localized(@"心跳间隔不能低于60秒")];
            return NO;
        }
        return YES;
    } confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
            @"heartbeat_Interval": contentStr.firstObject,
        }];
        [weakself terminalEditControlNewRequest:param success:^{
            weakself.configurationModel.heartbeatInterval = contentStr.firstObject;
        }];
    }] pop];
}
- (void)showZDLMD {
    kWeakSelf(self);
    NSInteger index = (self.termialControlStatusModel.sensitivity - 1) >= 0 ? (self.termialControlStatusModel.sensitivity - 1) : 0;
    [[CBCarAlertView viewWithChooseData:@[Localized(@"高"), Localized(@"中"), Localized(@"低")] selectedIndex:index title:_ControlConfigTitle_ZDLMD didClickData:^(NSString * _Nonnull contentStr, NSInteger index) {
            
    } confrim:^(NSString * _Nonnull contentStr, NSInteger index) {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
            @"sensitivity": @(index+1),
        }];
        [weakself terminalEditControlNewRequest:param success:^{
            weakself.termialControlStatusModel.sensitivity = index + 1;
        }];
    }] pop];
}
- (void)showPZJC {
    kWeakSelf(self);
    [[CBCarAlertView viewWithMultiInput:@[Localized(@"碰撞持续时间(ms)"), Localized(@"碰撞加速度(g)")] title:_ControlConfigTitle_PZJC isDigital:YES confirmCanDismiss:nil confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
        NSString *pzTime = contentStr.firstObject;
        NSString *pzSpeed = contentStr.lastObject;
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: @{
            @"pz_speed": pzSpeed ?: @"",
            @"pz_time": pzTime ?: @"",
        }];
        [weakself terminalEditControlParamRequest:param success:^{
            weakself.switchModel.pz_speed = pzSpeed ?: @"";
            weakself.switchModel.pz_time = pzTime ?: @"";
            [weakself.tableView reloadData];
        }];
    }] pop];
}
- (void)showJZW {
    kWeakSelf(self);
    [[CBCarAlertView viewWithMultiInput:@[Localized(@"转弯角度(度)"), Localized(@"转弯速度(km/h)")] title:_ControlConfigTitle_JZW isDigital:YES confirmCanDismiss:nil confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
        NSString *angle = contentStr.firstObject;
        NSString *speed = contentStr.lastObject;
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: @{
            @"jzw_speed": speed ?: @"",
            @"jzw_angle": angle ?: @"",
        }];
        [weakself terminalEditControlParamRequest:param success:^{
            weakself.switchModel.jzw_speed = speed ?: @"";
            weakself.switchModel.jzw_angle = angle ?: @"";
            [weakself.tableView reloadData];
        }];
    }] pop];
}
- (void)showJJS {
    kWeakSelf(self);
    [[CBCarAlertView viewWithMultiInput:@[Localized(@"速度增加量(km/h)"), Localized(@"加速时间(s)")] title:_ControlConfigTitle_JJS isDigital:YES confirmCanDismiss:nil confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
        NSString *speed = contentStr.firstObject;
        NSString *time = contentStr.lastObject;
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: @{
            @"jjs_speed": speed ?: @"",
            @"jjs_time": time ?: @"",
        }];
        [weakself terminalEditControlParamRequest:param success:^{
            weakself.switchModel.jjs_speed = speed ?: @"";
            weakself.switchModel.jjs_time = time ?: @"";
            [weakself.tableView reloadData];
        }];
    }] pop];
}
- (void)showJSC {
    kWeakSelf(self);
    [[CBCarAlertView viewWithMultiInput:@[Localized(@"速度减小量(km/h)"), Localized(@"刹车时间(s)")] title:_ControlConfigTitle_JSC isDigital:YES confirmCanDismiss:nil confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
        NSString *speed = contentStr.firstObject;
        NSString *time = contentStr.lastObject;
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: @{
            @"jsc_speed": speed ?: @"",
            @"jsc_time": time ?: @"",
        }];
        [weakself terminalEditControlParamRequest:param success:^{
            weakself.switchModel.jsc_speed = speed ?: @"";
            weakself.switchModel.jsc_time = time ?: @"";
            [weakself.tableView reloadData];
        }];
    }] pop];
}
- (void)showCSHSZ {
    kWeakSelf(self);
    [[CBCarAlertView viewWithAlertTips:Localized(@"确定初始化?") title:_ControlConfigTitle_CSHSZ confrim:^(NSString * _Nonnull contentStr) {
        NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
        [paramters setObject:_deviceInfoModelSelect.dno?:@"" forKey:@"dno"];
        [weakself terminalInitRequest:paramters];
    }] pop];
}
- (void)showSBCQ {
    kWeakSelf(self);
    [[CBCarAlertView viewWithAlertTips:Localized(@"确定重启?") title:_ControlConfigTitle_SBCQ confrim:^(NSString * _Nonnull contentStr) {
        [weakself rebootDeviceRequest];
    }] pop];
}
#pragma mark -- 开关点击
- (void)terminalSwitchClick:(NSString *)titleStr status:(NSString *)status {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:_deviceInfoModelSelect.dno?:@"" forKey:@"dno"];
    if ([titleStr isEqualToString:_ControlConfigTitle_ACCGZTZ]) {
        [paramters setObject:status forKey:@"accNotice"];
    } else if ([titleStr isEqualToString:_ControlConfigTitle_PYYZ]) {
        [paramters setObject:status forKey:@"gpsFloat"];
    }
    kWeakSelf(self);
    [self terminalEditControlNewRequest:paramters success:^{
        if ([titleStr isEqualToString:_ControlConfigTitle_ACCGZTZ]) {
            weakself.termialControlStatusModel.accNotice = status.intValue;
        } else if ([titleStr isEqualToString:_ControlConfigTitle_PYYZ]) {
            weakself.termialControlStatusModel.gpsFloat = status.intValue;
        }
        
    }];
}
#pragma mark -- 终端设备开关设置
- (void)terminalEditControlSwitchRequest:(NSMutableDictionary *)paramters {
    [paramters setObject:_deviceInfoModelSelect.dno?:@"" forKey:@"dno"];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl:@"devControlController/editSwitchParam" params: paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self getTerminalSettingReqeust];
        [self terminalGetControlStatusRequest];
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 终端设备参数设置
- (void)terminalEditControlParamRequest:(NSMutableDictionary *)paramters success:(void(^)(void))successBLK {
    [paramters setObject:_deviceInfoModelSelect.dno?:@"" forKey:@"dno"];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl:@"devParamController/editDevConf" params: paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CBTopAlertView alertSuccess:Localized(@"操作成功")];
        if (successBLK) {
            successBLK();
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [self getTerminalSettingReqeust];
        [self requestSwichModel];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 终端设备参数设置 -- 新增
- (void)terminalEditControlNewRequest:(NSMutableDictionary *)paramters success:(void(^)(void))successBLK{
    [paramters setObject:_deviceInfoModelSelect.dno?:@"" forKey:@"dno"];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl:@"/devControlController/updateDeviceStatus" params:paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CBTopAlertView alertSuccess:Localized(@"操作成功")];
        if (successBLK) {
            successBLK();
        }
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [self terminalGetControlStatusRequest];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 初始化
- (void)terminalInitRequest:(NSMutableDictionary *)paramters {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl:@"devParamController/resetDevice" params: paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [CBTopAlertView alertSuccess:Localized(@"初始化成功")];
            [self getTerminalSettingReqeust];
            [self terminalGetControlStatusRequest];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark -- 设备重启
- (void)rebootDeviceRequest {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = _deviceInfoModelSelect.dno?:@"";
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devParamController/rebootDevice" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [CBTopAlertView alertSuccess:Localized(@"重启成功")];
            [self getTerminalSettingReqeust];
            [self terminalGetControlStatusRequest];
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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
