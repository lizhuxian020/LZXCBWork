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

@interface CBSetTerminalViewController ()<UITableViewDelegate, UITableViewDataSource,CBControlAlertPopViewDelegate,CBControlPickPopViewDelegate,CBControlInputPopViewDelegate,CBControlSetOilPopViewDelegate,CBControlSetRestPopViewDelegate>

@property (nonatomic, strong) MINControlListDataModel *termialControlStatusModel;
@property (nonatomic, strong) ConfigurationParameterModel *configurationModel;
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
    
    [self terminalGetControlStatusRequest];
    [self getTerminalSettingReqeust];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
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
        NSArray *arrayTitle = @[
            _ControlConfigTitle_SQSZ,
            Localized(@"设置短信密码"),
            Localized(@"设置授权号码") ,
            Localized(@"始终在线") ,
            Localized(@"休眠模式"),
            Localized(@"设置油箱容积(L)"),
            Localized(@"油量校准"),
            Localized(@"设置里程初始值(m)"),
            Localized(@"疲劳驾驶参数设置"),
            Localized(@"碰撞报警参数设置"),
            Localized(@"Acc工作通知"),
            Localized(@"漂移抑制"),
            Localized(@"设置转弯补报角度(<180°)"),
            Localized(@"设置报警短信发送次数"),
            Localized(@"设置心跳间隔"),
            Localized(@"设备重启"),
            Localized(@"振动灵敏度"),
            Localized(@"初始化设置")
        ];//Localized(@"服务器转移")
        NSArray *arrayTitleImage = @[
            @"怠速报表",
            @"短信-1",
            @"授权号码",
            @"休眠",
            @"休眠",
            @"油箱容量",
            @"校准",
            @"里程",
            @"GPS-疲劳驾驶",
            @"碰撞报警",
            @"速度报表",
            @"震动报警",
            @"转弯",
            @"短信",
            @"速度报表",
            @"重启",
            @"震动报警",
            @"恢复"
        ];//@"网络-"
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
- (void)terminalGetControlStatusRequest {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
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
    [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
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
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 62.5*KFitHeightRate;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 12.5 * KFitHeightRate;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_HEIGHT, 12.5 * KFitHeightRate)];
//}
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
        kWeakSelf(self);
        cell.switchStateChangeBlock = ^(NSIndexPath *indexPath, BOOL isON) {
            kStrongSelf(self);
            NSLog(@"%ld %d", (long)indexPath.row , isON);
            NSLog(@"点击的类型%@ %d", model.titleStr , isON);
            if (isON == YES) {
                [self terminalSwitchClick:model.titleStr status:@"1"];
            } else {
                [self terminalSwitchClick:model.titleStr status:@"0"];
            }
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
    if ([title isEqualToString:_ControlConfigTitle_SQSZ]) {
//        CBTimeZoneViewController *vc = [CBTimeZoneViewController new];
//        [self.navigationController pushViewController:vc animated: YES];
        [self showSQSZ];
    } else if ([title isEqualToString:Localized(@"设置短信密码")]) {
        [self.inputPopView updateTitle:Localized(@"设置短信密码") placehold:Localized(@"输入短信密码") isDigital:YES];
        [self.inputPopView popView];
    } else if ([title isEqualToString:Localized(@"设置授权号码")]) {
        PhoneBookViewController *phoneBookVC = [[PhoneBookViewController alloc] init];
        [self.navigationController pushViewController: phoneBookVC animated: YES];
    } else if ([title isEqualToString:Localized(@"初始化设置")]) {
        [self.alertPopView updateTitle:Localized(@"初始化设置") msg:Localized(@"确定初始化?")];
        [self.alertPopView popView];
    } else if ([title isEqualToString:Localized(@"始终在线")]) {
        [self.alertPopView updateTitle:Localized(@"始终在线") msg:Localized(@"确定切换?")];
        [self.alertPopView popView];
    } else if ([title isEqualToString:Localized(@"休眠模式")]) {
        [self.setRestPopView popView];
        [self.setRestPopView updateType:[NSString stringWithFormat:@"%ld",(long)self.termialControlStatusModel.restMod]];
    } else if ([title isEqualToString:Localized(@"设置油箱容积(L)")]) {
        [self.inputPopView updateTitle:Localized(@"设置油箱容积(L)") placehold:Localized(@"输入油箱容积(L)") isDigital:YES];
        [self.inputPopView popView];
    } else if ([title isEqualToString:Localized(@"油量校准")]) {
        [self.setOilPopView popView];
    } else if ([title isEqualToString:Localized(@"设置里程初始值(m)")]) {
        [self.inputPopView updateTitle:Localized(@"设置里程初始值(m)") placehold:Localized(@"输入里程初始值(m)") isDigital:YES];
        [self.inputPopView popView];
    } else if ([title isEqualToString:Localized(@"疲劳驾驶参数设置")]) {
        FatigueDrivingViewController *fatigueDrivingVC = [[FatigueDrivingViewController alloc] init];
        [self.navigationController pushViewController: fatigueDrivingVC animated: YES];
    } else if ([title isEqualToString:Localized(@"碰撞报警参数设置")]) {
        CollosionAlarmViewController *collosionVC = [[CollosionAlarmViewController alloc] init];
        [self.navigationController pushViewController: collosionVC animated: YES];
    } else if ([title isEqualToString:Localized(@"设置转弯补报角度(<180°)")]) {
        [self.inputPopView updateTitle:Localized(@"设置转弯补报角度(<180°)") placehold:Localized(@"输入转弯补报角度°") isDigital:YES];
        [self.inputPopView popView];
    } else if ([title isEqualToString:Localized(@"设置报警短信发送次数")]) {
        [self.inputPopView updateTitle:Localized(@"设置报警短信发送次数") placehold:Localized(@"输入发送次数") isDigital:YES];
        [self.inputPopView popView];
    }  else if ([title isEqualToString:Localized(@"设置心跳间隔")]) {
       [self.inputPopView updateTitle:Localized(@"设置心跳间隔") placehold:Localized(@"输入心跳间隔") isDigital:YES];
       [self.inputPopView popView];
    } else if ([title isEqualToString:Localized(@"设备重启")]) {
        [self.alertPopView updateTitle:Localized(@"设备重启") msg:Localized(@"确定重启?")];
        [self.alertPopView popView];
    } else if ([title isEqualToString:Localized(@"振动灵敏度")]) {
        [self.pickerPopView popView];
        NSArray *array = @[Localized(@"高"),Localized(@"中"),Localized(@"低")];
        NSString *seletStr = @"";
        switch (self.termialControlStatusModel.sensitivity) {
            case 1:
                seletStr = Localized(@"高");
                break;
            case 2:
                seletStr = Localized(@"中");
                break;
            case 3:
                seletStr = Localized(@"低");
                break;
            default:
                break;
        }
        [self.pickerPopView updateTitle:Localized(@"振动灵敏度") menuArray:array seletedTitle:seletStr];
    } else if ([title isEqualToString:Localized(@"服务器转移")]) {
        NetWorkConfigurationViewController *netWorkVC = [[NetWorkConfigurationViewController alloc] init];
        [self.navigationController pushViewController: netWorkVC animated: YES];
    }
}
#pragma mark -- 各种弹框
- (void)showSQSZ {
    [[CBCarAlertView viewWithSQSZTitle:_ControlConfigTitle_SQSZ initText:self.termialControlStatusModel.timeZone confrim:^(NSString * _Nonnull contentStr) {
                
    }] pop];
}
#pragma mark -- 开关点击
- (void)terminalSwitchClick:(NSString *)titleStr status:(NSString *)status {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
    if ([titleStr isEqualToString:Localized(@"Acc工作通知")]) {
        [paramters setObject:status forKey:@"accNotice"];
        [self terminalEditControlNewRequest:paramters];
    } else if ([titleStr isEqualToString:Localized(@"漂移抑制")]) {
        [paramters setObject:status forKey:@"gpsFloat"];
        [self terminalEditControlNewRequest:paramters];
    }
}
#pragma mark -- 警告弹窗代理 -- 代理
- (void)clickType:(NSString *)title {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
    if ([title isEqualToString:Localized(@"初始化设置")] || [title isEqualToString:Localized(@"设备重启")]) {
        [self terminalInitRequest:paramters];
    } else if ([title isEqualToString:Localized(@"始终在线")]) {
        [paramters setObject:@"0" forKey:@"rest_mod"];
        [self terminalEditControlSwitchRequest:paramters];
    }
}
#pragma mark -- 输入弹窗代理 -- 代理
- (void)updateTextFieldValue:(NSString *)inputStr returnTitle:(NSString *)title {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
    if ([title isEqualToString:Localized(@"设置短信密码")]) {
        if (inputStr.length != 6) {
            [HUD showHUDWithText:[Utils getSafeString:Localized(@"请输入6位数的密码")] withDelay:2.0];
            return;
        }
        [paramters setObject:inputStr forKey:@"password"];
    } else if ([title isEqualToString:Localized(@"设置油箱容积(L)")]) {
        [paramters setObject:inputStr forKey:@"volume"];
    } else if ([title isEqualToString:Localized(@"设置里程初始值(m)")]) {
        [paramters setObject:inputStr forKey:@"mileage"];
    } else if ([title isEqualToString:Localized(@"设置转弯补报角度(<180°)")]) {
        [paramters setObject:inputStr forKey:@"angle"];
    } else if ([title isEqualToString:Localized(@"设置报警短信发送次数")]) {
        [paramters setObject:inputStr forKey:@"send_msg_limit"];
    } else if ([title isEqualToString:Localized(@"设置心跳间隔")]) {
        [paramters setObject:inputStr forKey:@"heartbeat_Interval"];
    }
    [self terminalEditControlParamRequest:paramters];
}
#pragma mark -- 选择振动灵敏度弹窗代理 -- 代理
- (void)pickerPopViewClickIndex:(NSInteger)index {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
    switch (index) {
        case 100:
        {
            [paramters setObject:@"1" forKey:@"sensitivity"];
            [self terminalEditControlNewRequest:paramters];
        }
            break;
        case 101:
        {
            [paramters setObject:@"2" forKey:@"sensitivity"];
            [self terminalEditControlNewRequest:paramters];
        }
            break;
        case 102:
        {
            [paramters setObject:@"3" forKey:@"sensitivity"];//sensitivity  //silentArm
            [self terminalEditControlNewRequest:paramters];
        }
            break;
        default:
            break;
    }
}
#pragma mark -- 设置休眠模式弹窗代理 -- 代理
- (void)pickerRestPopViewClickIndex:(NSInteger)index time:(NSString *)time unit:(NSString *)unit {
    NSLog(@"标题顺序%ld  时间:%@  单位:%@",(long)index,time,unit);
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
    if (index == 4 || index == 5) {
        if (time.length <= 0) {
            [HUD showHUDWithText:[Utils getSafeString:Localized(@"任何一项都不能为空")] withDelay:2.0];
            return;
        } else if (unit.length <= 0) {
            [HUD showHUDWithText:[Utils getSafeString:Localized(@"任何一项都不能为空")] withDelay:2.0];
            return;
        }
        [paramters setObject:time forKey:@"fixAwakenTime"];
        [paramters setObject:unit forKey:@"fixAwakenTimeUnit"];
    }
    [paramters setObject:[NSString stringWithFormat:@"%ld",(long)index] forKey:@"rest_mod"];
    NSLog(@"参数:------%@--------",paramters);
    [self terminalEditControlSwitchRequest:paramters];
}
#pragma mark -- 油量校准弹窗代理 -- 代理
- (void)selectOilValueType:(NSString *)oilVale {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
    [paramters setObject:oilVale forKey:@"oil_validate"];
    [self terminalEditControlParamRequest:paramters];
}
#pragma mark -- 终端设备开关设置
- (void)terminalEditControlSwitchRequest:(NSMutableDictionary *)paramters {
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
- (void)terminalEditControlParamRequest:(NSMutableDictionary *)paramters {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl:@"devParamController/editDevConf" params: paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self getTerminalSettingReqeust];
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 终端设备参数设置 -- 新增
- (void)terminalEditControlNewRequest:(NSMutableDictionary *)paramters {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBNetworkRequestManager sharedInstance] terminalSettingParamters:paramters success:^(CBBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self terminalGetControlStatusRequest];
        
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
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
    } failed:^(NSError *error) {
        kStrongSelf(self);
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
