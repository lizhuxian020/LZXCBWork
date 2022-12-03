//
//  CBSetAlarmViewController.m
//  Telematics
//
//  Created by coban on 2019/11/18.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBSetAlarmViewController.h"
#import "ControlTableViewCell.h"
#import "MINControlListDataModel.h"
#import "MINAlertView.h"
#import "CBControlInputPopView.h"
#import "CBControlSetServicePopView.h"

@interface CBSetAlarmViewController ()<UITableViewDelegate, UITableViewDataSource,CBControlInputPopViewDelegate,CBControlSetServicePopViewDelegate>

@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic, strong) MINControlListDataModel *controlStatusModel;
@property (nonatomic, strong) UITextField *speedTF;

/** 输入弹窗 */
@property (nonatomic, strong) CBControlInputPopView *inputPopView;
/** 选择弹窗 */
@property (nonatomic, strong) CBControlSetServicePopView *serviceFlagPopView;

@end

@implementation CBSetAlarmViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getControlStatusRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}
- (void)setupView {
    [self initBarWithTitle:Localized(@"报警设置") isBack: YES];
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
            Localized(@"掉电报警"),
            Localized(@"低电报警"),
            Localized(@"盲区报警") ,
//            Localized(@"紧急报警") ,
//            Localized(@"超速报警") ,
            Localized(@"振动报警"),
            Localized(@"油量检测报警")
        ];//Localized(@"保养通知")
        NSArray *arrayTitleImage = @[
            @"掉电",
            @"低电",
            @"里程统计",
//            @"报警统计",
//            @"超速",
            @"震动报警",
            @"油量统计"
        ];//@"点火报表"
        for (int i = 0 ; i < arrayTitle.count ; i ++ ) {
            CBControlModel *controlModel = [[CBControlModel alloc]init];
            controlModel.titleStr = arrayTitle[i];
            controlModel.leftImageStr = arrayTitleImage[i];
            [_arrayData addObject:controlModel];
        }
    }
    return _arrayData;
}
- (CBControlInputPopView *)inputPopView {
    if (!_inputPopView) {
        _inputPopView = [[CBControlInputPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _inputPopView.delegate = self;
    }
    return _inputPopView;
}
- (CBControlSetServicePopView *)serviceFlagPopView {
    if (!_serviceFlagPopView) {
        _serviceFlagPopView = [[CBControlSetServicePopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _serviceFlagPopView.delegate = self;
    }
    return _serviceFlagPopView;
}
#pragma mark -- 获取开关类设备控制参数
- (void)getControlStatusRequest {
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
                self.controlStatusModel = [MINControlListDataModel yy_modelWithJSON:response[@"data"]];
                [self.tableView reloadData];
            }
        } else {
            [self.tableView reloadData];
        }
    } failed:^(NSError *error) {
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    ControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ControlTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (self.arrayData.count > indexPath.row) {
        __block CBControlModel *model = self.arrayData[indexPath.row];
        cell.indexPath = indexPath;
        cell.controlModel = model;
        cell.controlListModel = self.controlStatusModel;
        kWeakSelf(self);
        cell.switchStateChangeBlock = ^(NSIndexPath *indexPath, BOOL isON) {
            kStrongSelf(self);
            NSLog(@"%ld %d", (long)indexPath.row , isON);
            NSLog(@"点击的类型%@ %d", model.titleStr , isON);
            if (isON == YES) {
                [self switchClick:model.titleStr status:@"1"];
            } else {
                [self switchClick:model.titleStr status:@"0"];
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
        if ([model.titleStr isEqualToString:Localized(@"超速报警")]) {
            [self showAlertSppedView];
        } else if ([model.titleStr isEqualToString:Localized(@"保养通知")]) {
            [self showServiceFlagView];
        }
    }
}
#pragma mark -- 开关
- (void)switchClick:(NSString *)titleStr status:(NSString *)status {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
    if ([titleStr isEqualToString:Localized(@"掉电报警")]) {
        [paramters setObject:status forKey:@"warm_diaodian"];
        [self alarmEditControlSwitchRequest:paramters];
    } else if ([titleStr isEqualToString:Localized(@"低电报警")]) {
        [paramters setObject:status forKey:@"warm_didian"];
        [self alarmEditControlSwitchRequest:paramters];
    } else if ([titleStr isEqualToString:Localized(@"盲区报警")]) {
        [paramters setObject:status forKey:@"warnBlind"];
        [self alarmEditControlNewRequest:paramters];
    } else if ([titleStr isEqualToString:Localized(@"紧急报警")]) {
        [paramters setObject:status forKey:@"urgentWarn"];
        [self alarmEditControlNewRequest:paramters];
    } else if ([titleStr isEqualToString:Localized(@"超速报警")]) {
        [paramters setObject:status forKey:@"warm_speed"];
        [self alarmEditControlSwitchRequest:paramters];
    } else if ([titleStr isEqualToString:Localized(@"振动报警")]) {
        [paramters setObject:status forKey:@"warm_zd"];
        [self alarmEditControlSwitchRequest:paramters];
    } else if ([titleStr isEqualToString:Localized(@"油量检测报警")]) {
        [paramters setObject:status forKey:@"oilCheckWarn"];
        [self alarmEditControlNewRequest:paramters];
    } else if ([titleStr isEqualToString:Localized(@"保养通知")]) {
        [paramters setObject:status forKey:@"serviceFlag"];
        [self alarmEditControlNewRequest:paramters];
    }
}
#pragma mark -- 超速报警
- (void)showAlertSppedView {
    [self.inputPopView updateTitle:Localized(@"超速报警") placehold:Localized(@"输入时速KM") isDigital:YES];
    [self.inputPopView popView];
}
#pragma mark -- 超速报警 -- 代理
- (void)updateTextFieldValue:(NSString *)inputStr returnTitle:(NSString *)title {
    if ([title isEqualToString:Localized(@"超速报警")]) {
        if (inputStr.length < 1) {
            [HUD showHUDWithText:@"输入时速KM" withDelay:1.2];
            return;
        }
        NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
        [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
        [paramters setObject:inputStr?:@"" forKey:@"over_warm"];
        [self alarmEditControlParamRequest:paramters];
    }
}
#pragma mark -- 保养通知
- (void)showServiceFlagView {
    [self.serviceFlagPopView popView];
}
#pragma mark -- 保养通知 -- 代理
- (void)returnTextFieldValueTimeStr:(NSString *)timeStr serviceFlagStr:(NSString *)serviceFlagStr {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
    [paramters setObject:timeStr forKey:@"serviceInterval"];
    [paramters setObject:serviceFlagStr forKey:@"serviceMileage"];
    [paramters setObject:@"1" forKey:@"serviceFlag"];
    [self alarmEditControlNewRequest:paramters];
}
#pragma mark -- 终端设备开关设置
- (void)alarmEditControlSwitchRequest:(NSMutableDictionary *)paramters {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl:@"devControlController/editSwitchParam" params: paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self getControlStatusRequest];
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 终端设备参数设置
- (void)alarmEditControlParamRequest:(NSMutableDictionary *)paramters {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl:@"devParamController/editDevConf" params: paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self getControlStatusRequest];
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 终端设备参数设置 -- 新增
- (void)alarmEditControlNewRequest:(NSMutableDictionary *)paramters {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBNetworkRequestManager sharedInstance] terminalSettingParamters:paramters success:^(CBBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self getControlStatusRequest];
    } failure:^(NSError * _Nonnull error) {
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
