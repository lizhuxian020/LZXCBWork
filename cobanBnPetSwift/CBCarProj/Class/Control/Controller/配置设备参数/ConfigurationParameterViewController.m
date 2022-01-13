//
//  ConfigurationParameterViewController.m
//  Telematics
//
//  Created by lym on 2017/11/28.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "ConfigurationParameterViewController.h"
#import "ControlTableViewCell.h"
#import "MINAlertView.h"
#import "NetWorkConfigurationViewController.h"
#import "FatigueDrivingViewController.h"
#import "CollosionAlarmViewController.h"
#import "MessageResponseViewController.h"
#import "PhoneBookViewController.h"
#import "ConfigurationParameterModel.h"
#import "MINSwitchView.h"
#import "ConfigurationParameterProtocalModel.h"

@interface ConfigurationParameterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *dataTitleArr;
@property (nonatomic, copy) NSArray *dataTitleImageArr;
@property (nonatomic, strong) NSArray *stateArr;
@property (nonatomic, weak) UITextField *textField; // 警告框的输入框
@property (nonatomic, strong) ConfigurationParameterModel *model;
@end

@implementation ConfigurationParameterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self addAction];
//    self.dataTitleArr = @[Localized(@"恢复原厂设置"), Localized(@"设置短信控制密码"), Localized(@"设置授权号码"), Localized(@"设置转弯补传角度(180°)"), Localized(@"设置里程初始值(m)"), Localized(@"设置低压报警值(V)"), Localized(@"设置油箱容积(L)"), Localized(@"油量校准"), Localized(@"电气锁转换"), Localized(@"设置报警短信发送次数"), Localized(@"超速报警预警差值(1/100km/h)"), Localized(@"消息应答超时机制"), Localized(@"疲劳驾驶参数设置"), Localized(@"碰撞报警参数设置"), Localized(@"网络设置"), Localized(@"设备重启")];
//    self.dataTitleImageArr = @[@"恢复", @"短信-1", @"授权号码", @"转弯", @"里程", @"低压", @"油箱容量", @"校准", @"转换-1", @"短信", @"超速报警", @"消息应答", @"GPS-疲劳驾驶", @"碰撞报警", @"网络-", @"重启"];
//    self.stateArr = @[@1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1];

    
    // 超速报警预警差值，疲劳驾驶参数设置，碰撞报警参数设置,为开放先隐藏
    self.dataTitleArr = @[Localized(@"恢复原厂设置"), Localized(@"设置短信控制密码"), Localized(@"设置授权号码"), Localized(@"设置转弯补报角度(180°)"), Localized(@"设置里程初始值(m)"), Localized(@"设置低压报警值(V)"), Localized(@"设置油箱容积(L)"), Localized(@"油量校准"), Localized(@"电气锁转换"), Localized(@"设置报警短信发送次数"), Localized(@"消息应答超时机制"), Localized(@"网络设置"), Localized(@"设备重启")];
    self.dataTitleImageArr = @[@"恢复", @"短信-1", @"授权号码", @"转弯", @"里程", @"低压", @"油箱容量", @"校准", @"转换-1", @"短信", @"消息应答", @"网络-", @"重启"];
    self.stateArr = @[@1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1];
    
    //[self requestData];
    [self rightBtnClick];
}
#pragma mark -- 根据协议展示报表菜单  暂未用到
- (void)requestData
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    //dic[@"proto"] = [AppDelegate shareInstance].potocal;
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    //[hud hideAnimated:YES];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devParamController/getMenuByProto" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                ConfigurationParameterProtocalModel *model = [ConfigurationParameterProtocalModel yy_modelWithJSON: response[@"data"]];
                weakSelf.stateArr = [model getStateArr];
                [weakSelf.tableView reloadData];
            }
        }else {
            
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Action
- (void)addAction
{
    
}
#pragma mark -- 根据设备编号获取参数
- (void)rightBtnClick
{
    __weak __typeof__(self) weakSelf = self;
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
                ConfigurationParameterModel *model = [ConfigurationParameterModel yy_modelWithJSON: response[@"data"]];
                weakSelf.model = model;
                [weakSelf.tableView reloadData];
                
            }else {
                
            }
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
    [self initBarWithTitle:Localized(@"配置设备参数") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"读取") target: self action: @selector(rightBtnClick)];
    [self createTableView];
}

- (void)createTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.view);
    }];
}

#pragma mark - tableView delegate & dateSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataTitleArr.count > indexPath.row) {
        NSString *titleStr = self.dataTitleArr[indexPath.row];
        if ([titleStr isEqualToString:Localized(@"恢复原厂设置")]) {
            [self showAlertViewWithTitle:Localized(@"提示") datailText:Localized(@"确定重启 / 恢复出厂设置?") indexPath: indexPath];
        } else if ([titleStr isEqualToString:Localized(@"设置短信控制密码")]) {
            [self showAlertViewWithTitle: self.dataTitleArr[indexPath.row] placeHold: self.dataTitleArr[indexPath.row] indexPath: indexPath];
        } else if ([titleStr isEqualToString:Localized(@"设置授权号码")]) {
            PhoneBookViewController *phoneBookVC = [[PhoneBookViewController alloc] init];
            [self.navigationController pushViewController: phoneBookVC animated: YES];
        } else if ([titleStr isEqualToString:Localized(@"设置转弯补报角度(180°)")]) {
            [self showAlertViewWithTitle: self.dataTitleArr[indexPath.row] placeHold: self.dataTitleArr[indexPath.row] indexPath: indexPath];
        } else if ([titleStr isEqualToString:Localized(@"设置里程初始值(m)")]) {
            [self showAlertViewWithTitle: self.dataTitleArr[indexPath.row] placeHold: self.dataTitleArr[indexPath.row] indexPath: indexPath];
        } else if ([titleStr isEqualToString:Localized(@"设置低压报警值(V)")]) {
            [self showAlertViewWithTitle: self.dataTitleArr[indexPath.row] placeHold: self.dataTitleArr[indexPath.row] indexPath: indexPath];
        } else if ([titleStr isEqualToString:Localized(@"设置油箱容积(L)")]) {
            [self showAlertViewWithTitle: self.dataTitleArr[indexPath.row] placeHold: self.dataTitleArr[indexPath.row] indexPath: indexPath];
        } else if ([titleStr isEqualToString:Localized(@"油量校准")]) {
            [self showAlertViewWithTitle:Localized(@"油量校准") datailText:Localized(@"设置当前油量为") indexPath: indexPath];
        } else if ([titleStr isEqualToString:Localized(@"电气锁转换")]) {
        } else if ([titleStr isEqualToString:Localized(@"设置报警短信发送次数")]) {
            [self showAlertViewWithTitle: self.dataTitleArr[indexPath.row] placeHold: self.dataTitleArr[indexPath.row] indexPath: indexPath];
        } else if ([titleStr isEqualToString:Localized(@"超速报警预警差值(1/100km/h)")]) {
            [self showAlertViewWithTitle: self.dataTitleArr[indexPath.row] placeHold: self.dataTitleArr[indexPath.row] indexPath: indexPath];
        } else if ([titleStr isEqualToString:Localized(@"消息应答超时机制")]) {
            MessageResponseViewController *messageVC = [[MessageResponseViewController alloc] init];
            [self.navigationController pushViewController: messageVC animated: YES];
        } else if ([titleStr isEqualToString:Localized(@"疲劳驾驶参数设置")]) {
            FatigueDrivingViewController *fatigueDrivingVC = [[FatigueDrivingViewController alloc] init];
            [self.navigationController pushViewController: fatigueDrivingVC animated: YES];
        } else if ([titleStr isEqualToString:Localized(@"碰撞报警参数设置")]) {
            CollosionAlarmViewController *collosionVC = [[CollosionAlarmViewController alloc] init];
            [self.navigationController pushViewController: collosionVC animated: YES];
        } else if ([titleStr isEqualToString:Localized(@"网络设置")]) {
            NetWorkConfigurationViewController *netWorkVC = [[NetWorkConfigurationViewController alloc] init];
            [self.navigationController pushViewController: netWorkVC animated: YES];
        } else if ([titleStr isEqualToString:Localized((@"设备重启"))]) {
            [self showAlertViewWithTitle:Localized(@"提示") datailText:Localized(@"确定重启 / 恢复出厂设置?") indexPath: indexPath];
        }
    }
}
#pragma mark -- 恢复出厂设置
- (void)restoreTheFactoryDefaultSettings
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: @"加载中..."];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl: @"devParamController/resetDevice" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            
        }else {
            
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 设置 短信控制密码 转弯补传角度 里程初始值 低压报警值 油箱容积 油量校准 电气锁转换 报警短信发送次数 超速报警 碰撞报警参数
- (void)editRowDataWithIndexPath:(NSIndexPath *)indexPath data:(NSString *)data
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    if (self.dataTitleArr.count > indexPath.row) {
        NSString *titleStr = self.dataTitleArr[indexPath.row];
        if ([titleStr isEqualToString:Localized(@"恢复原厂设置")]) {
        } else if ([titleStr isEqualToString:Localized(@"设置短信控制密码")]) {
            dic[@"password"] = data;
        } else if ([titleStr isEqualToString:Localized(@"设置授权号码")]) {
        } else if ([titleStr isEqualToString:Localized(@"设置转弯补报角度(180°)")]) {
            dic[@"angle"] = data;
        } else if ([titleStr isEqualToString:Localized(@"设置里程初始值(m)")]) {
            dic[@"mileage"] = data;
        } else if ([titleStr isEqualToString:Localized(@"设置低压报警值(V)")]) {
            dic[@"low_warm"] = data;
        } else if ([titleStr isEqualToString:Localized(@"设置油箱容积(L)")]) {
            dic[@"volume"] = data;
        } else if ([titleStr isEqualToString:Localized(@"油量校准")]) {
            dic[@"oil_validate"] = data;
        } else if ([titleStr isEqualToString:Localized(@"电气锁转换")]) {
            dic[@"eg_change"] = data;
        } else if ([titleStr isEqualToString:Localized(@"设置报警短信发送次数")]) {
            dic[@"send_msg_limit"] = data;
        } else if ([titleStr isEqualToString:Localized(@"超速报警预警差值(1/100km/h)")]) {
            dic[@"over_warm"] = data;
        } else if ([titleStr isEqualToString:Localized(@"消息应答超时机制")]) {
        } else if ([titleStr isEqualToString:Localized(@"疲劳驾驶参数设置")]) {
        } else if ([titleStr isEqualToString:Localized(@"碰撞报警参数设置")]) {
        } else if ([titleStr isEqualToString:Localized(@"网络设置")]) {
        } else if ([titleStr isEqualToString:Localized((@"设备重启"))]) {
        }
    }
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: @"加载中..."];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl: @"devParamController/editDevConf" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            
        }else {
            
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)showAlertViewWithTitle:(NSString *)title datailText:(NSString *)text indexPath:(NSIndexPath *)indexPath
{
    //ControlTableViewCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
    __weak __typeof__(self) weakSelf = self;
    MINAlertView *alertView = [[MINAlertView alloc] init];
    __weak MINAlertView *weakAlertView = alertView;
    alertView.titleLabel.text = title;
    [weakSelf.view addSubview: alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    UILabel *detailLabel = [MINUtils createLabelWithText: text size: 15 * KFitHeightRate alignment:NSTextAlignmentCenter textColor: kRGB(96, 96, 96)];
    detailLabel.numberOfLines = 0;
    [alertView.contentView addSubview: detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView.contentView);
        make.centerY.equalTo(alertView.contentView).with.offset(-5 * KFitHeightRate);
        make.height.mas_equalTo(40 * KFitHeightRate);
        make.width.mas_equalTo(250 * KFitWidthRate);
    }];
    if (self.dataTitleArr.count > indexPath.row) {
        NSString *titleStr = self.dataTitleArr[indexPath.row];
        if ([titleStr isEqualToString:Localized(@"油量校准")]) {
            [alertView showRightCloseBtn];
            [alertView.rightBottomBtn setTitle:Localized(@"满值") forState: UIControlStateNormal];
            [alertView.rightBottomBtn setTitle:Localized(@"满值") forState: UIControlStateHighlighted];
            [alertView.leftBottomBtn setTitle:Localized(@"零值") forState: UIControlStateNormal];
            [alertView.leftBottomBtn setTitle:Localized(@"零值") forState: UIControlStateHighlighted];
            [alertView.leftBottomBtn setBackgroundColor: [UIColor whiteColor]];
            UIView *lineView = [MINUtils createLineView];
            [lineView setBackgroundColor: kBlueColor];
            [alertView.leftBottomBtn addSubview: lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(alertView.leftBottomBtn).with.offset(0.5);
                make.left.equalTo(alertView.leftBottomBtn);
                make.right.equalTo(alertView.leftBottomBtn);
                make.height.mas_equalTo(0.5);
            }];
        }
    }
    alertView.rightBtnClick = ^{
        [weakAlertView hideView];
//        if (indexPath.row == 0) {
//            [weakSelf restoreTheFactoryDefaultSettings];
//        }else if (indexPath.row == 7) {
//            [weakSelf editRowDataWithIndexPath: indexPath data: @"1"];
//        }else if (indexPath.row == 15) {
//            [weakSelf rebootDeviceRequest];
//        }
        NSString *titleStr = self.dataTitleArr[indexPath.row];
        if ([titleStr isEqualToString:Localized(@"恢复原厂设置")]) {
            [weakSelf restoreTheFactoryDefaultSettings];
        } else if ([titleStr isEqualToString:Localized(@"设置短信控制密码")]) {
        } else if ([titleStr isEqualToString:Localized(@"设置授权号码")]) {
        } else if ([titleStr isEqualToString:Localized(@"设置转弯补报角度(180°)")]) {
        } else if ([titleStr isEqualToString:Localized(@"设置里程初始值(m)")]) {
        } else if ([titleStr isEqualToString:Localized(@"设置低压报警值(V)")]) {
        } else if ([titleStr isEqualToString:Localized(@"设置油箱容积(L)")]) {
        } else if ([titleStr isEqualToString:Localized(@"油量校准")]) {
            [weakSelf editRowDataWithIndexPath: indexPath data: @"1"];
        } else if ([titleStr isEqualToString:Localized(@"电气锁转换")]) {
        } else if ([titleStr isEqualToString:Localized(@"设置报警短信发送次数")]) {
        } else if ([titleStr isEqualToString:Localized(@"超速报警预警差值(1/100km/h)")]) {
        } else if ([titleStr isEqualToString:Localized(@"消息应答超时机制")]) {
        } else if ([titleStr isEqualToString:Localized(@"疲劳驾驶参数设置")]) {
        } else if ([titleStr isEqualToString:Localized(@"碰撞报警参数设置")]) {
        } else if ([titleStr isEqualToString:Localized(@"网络设置")]) {
        } else if ([titleStr isEqualToString:Localized((@"设备重启"))]) {
            [weakSelf rebootDeviceRequest];
        }
    };
    alertView.leftBtnClick = ^{
        [weakAlertView hideView];
//        if (indexPath.row == 7) {
//            [weakSelf editRowDataWithIndexPath: indexPath data: @"0"];
//        }
        NSString *titleStr = self.dataTitleArr[indexPath.row];
        if ([titleStr isEqualToString:Localized(@"油量校准")]) {
            [weakSelf editRowDataWithIndexPath: indexPath data: @"0"];
        }
    };
}
#pragma mark -- 设备重启
- (void)rebootDeviceRequest
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devParamController/rebootDevice" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            
            [MINUtils showProgressHudToView: weakSelf.view withText:Localized(@"重启成功")];
        }else {
            
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)showAlertViewWithTitle:(NSString *)title placeHold:(NSString *)placeHold indexPath:(NSIndexPath *)indexPath
{
    ControlTableViewCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
    __weak __typeof__(self) weakSelf = self;
    MINAlertView *alertView = [[MINAlertView alloc] init];
    __weak MINAlertView *weakAlertView = alertView;
    alertView.titleLabel.text = title;
    [weakSelf.view addSubview: alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    weakSelf.textField = [MINUtils createTextFieldWithHoldText: placeHold  fontSize: 15];
    if (indexPath.row != 1) {
        weakSelf.textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    [alertView.contentView addSubview: weakSelf.textField];
    [weakSelf.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView.contentView);
        make.centerY.equalTo(alertView.contentView).with.offset(-5 * KFitHeightRate);
        make.height.mas_equalTo(40 * KFitHeightRate);
        make.width.mas_equalTo(250 * KFitWidthRate);
    }];
    UIView *lineView = [MINUtils createLineView];
    [alertView.contentView addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(alertView.contentView).with.offset( -5*KFitHeightRate);//-15
        make.left.equalTo(alertView.contentView).with.offset(10 * KFitWidthRate);
        make.right.equalTo(alertView.contentView).with.offset(-10 * KFitWidthRate);
        make.height.mas_equalTo(1);
    }];
    alertView.rightBtnClick = ^{
        if (weakSelf.textField.text.length > 0) {
            [weakAlertView hideView];
            // 修改model的数据，不要忘记了
            NSString *text = nil;
//            if (indexPath.row == 3) { // 设置转弯补传角度
//                text = [NSString stringWithFormat: @"%@", weakSelf.textField.text];//°
//            }else if (indexPath.row == 4) { // 设置里程初始值
//                text = [NSString stringWithFormat: @"%@", weakSelf.textField.text];//m
//            }else if (indexPath.row == 9 || indexPath.row == 10) { // 9-设置报警短信发送次数 10-超速报警
//                text = [NSString stringWithFormat: @"%@", weakSelf.textField.text];
//            }else if (indexPath.row == 5) { // 设置低压报警值
//                text = [NSString stringWithFormat: @"%@", weakSelf.textField.text];//V
//            }else if (indexPath.row == 6) { // 设置油箱容积
//                text = [NSString stringWithFormat: @"%@", weakSelf.textField.text];//L
//            }else { // 设置短信控制密码
//                text = weakSelf.textField.text;//@"********";
//            }
            NSString *titleStr = self.dataTitleArr[indexPath.row];
            if ([titleStr isEqualToString:Localized(@"设置转弯补报角度(180°)")]) {
                text = [NSString stringWithFormat: @"%@", weakSelf.textField.text];//°
            } else if ([titleStr isEqualToString:Localized(@"设置里程初始值(m)")]) {
                text = [NSString stringWithFormat: @"%@", weakSelf.textField.text];//m
            } else if ([titleStr isEqualToString:Localized(@"设置低压报警值(V)")]) {
                text = [NSString stringWithFormat: @"%@", weakSelf.textField.text];//V
            } else if ([titleStr isEqualToString:Localized(@"设置油箱容积(L)")]) {
                text = [NSString stringWithFormat: @"%@", weakSelf.textField.text];//L
            } else if ([titleStr isEqualToString:Localized(@"设置报警短信发送次数")]) {
                text = [NSString stringWithFormat: @"%@", weakSelf.textField.text];
            } else if ([titleStr isEqualToString:Localized(@"超速报警预警差值(1/100km/h)")]) {
                text = [NSString stringWithFormat: @"%@", weakSelf.textField.text];
            } else {
                text = weakSelf.textField.text;//@"********";
            }
            [weakSelf editRowDataWithIndexPath: indexPath data: weakSelf.textField.text];
            cell.detailLabel.text = text;
        }
    };
    alertView.leftBtnClick = ^{
        [weakAlertView hideView];
    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.stateArr[indexPath.row] integerValue] == 0) {
        ControlTableViewCell *cell = [[ControlTableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 0)];
        cell.hidden = YES;
        return cell;
    }
    static NSString *cellIndentify = @"ControlCellIndentifyyy";
    ControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
    if (cell == nil) {
        cell = [[ControlTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIndentify];
    }
    cell.detailLabel.text = @"";//Localized(@"未读取");
    if (self.model != nil) {
//        if (indexPath.row == 1) {
//            cell.detailLabel.text = [NSString stringWithFormat: @"%@", self.model.password];
//        }
//        else if (indexPath.row == 3) { // 设置转弯补传角度
//            cell.detailLabel.text = [NSString stringWithFormat: @"%d", self.model.angle];//°
//        }else if (indexPath.row == 4) { // 设置里程初始值
//            cell.detailLabel.text = [NSString stringWithFormat: @"%d", self.model.mileage];//m
//        }else if (indexPath.row == 5) { // 设置低压报警值
//            cell.detailLabel.text = [NSString stringWithFormat: @"%d", self.model.lowWarm];//V
//        }else if (indexPath.row == 6) { // 设置油箱容积
//            cell.detailLabel.text = [NSString stringWithFormat: @"%d", self.model.volume];//L
//        }else if (indexPath.row == 8) { // 电气锁转换 // 不用管switch的东西
//            //电气锁转换；0-电锁，1-气锁
//            cell.switchView.isON = self.model.change;
//            if (self.model.change == 0) {
//                cell.centerLabel.text = Localized(@"电锁");
//            } else if (self.model.change == 1) {
//                cell.centerLabel.text = Localized(@"气锁");
//            }
//        }else if (indexPath.row == 9) { // 设置报警短信发送次数
//            cell.detailLabel.text = [NSString stringWithFormat: @"%d", self.model.sendMsgLimit];
//        }else if (indexPath.row == 10) { // 超速报警
//            cell.detailLabel.text = [NSString stringWithFormat: @"%d", self.model.overWarm];
//        }
        NSString *titleStr = self.dataTitleArr[indexPath.row];
        if ([titleStr isEqualToString:Localized(@"恢复原厂设置")]) {
        } else if ([titleStr isEqualToString:Localized(@"设置短信控制密码")]) {
            cell.detailLabel.text = [NSString stringWithFormat: @"%@", self.model.password];
        } else if ([titleStr isEqualToString:Localized(@"设置授权号码")]) {
        } else if ([titleStr isEqualToString:Localized(@"设置转弯补报角度(180°)")]) {
            cell.detailLabel.text = [NSString stringWithFormat: @"%d", self.model.angle];//°
        } else if ([titleStr isEqualToString:Localized(@"设置里程初始值(m)")]) {
            cell.detailLabel.text = [NSString stringWithFormat: @"%d", self.model.mileage];//m
        } else if ([titleStr isEqualToString:Localized(@"设置低压报警值(V)")]) {
            cell.detailLabel.text = [NSString stringWithFormat: @"%d", self.model.lowWarm];//V
        } else if ([titleStr isEqualToString:Localized(@"设置油箱容积(L)")]) {
            cell.detailLabel.text = [NSString stringWithFormat: @"%d", self.model.volume];//L
        } else if ([titleStr isEqualToString:Localized(@"油量校准")]) {
        } else if ([titleStr isEqualToString:Localized(@"电气锁转换")]) {
            //电气锁转换；0-电锁，1-气锁
            cell.switchView.isON = self.model.change;
            if (self.model.change == 0) {
                cell.centerLabel.text = Localized(@"电锁");
            } else if (self.model.change == 1) {
                cell.centerLabel.text = Localized(@"气锁");
            }
        } else if ([titleStr isEqualToString:Localized(@"设置报警短信发送次数")]) {
            cell.detailLabel.text = [NSString stringWithFormat: @"%d", self.model.sendMsgLimit];
        } else if ([titleStr isEqualToString:Localized(@"超速报警预警差值(1/100km/h)")]) {
            cell.detailLabel.text = [NSString stringWithFormat: @"%d", self.model.overWarm];
        } else if ([titleStr isEqualToString:Localized(@"消息应答超时机制")]) {
        } else if ([titleStr isEqualToString:Localized(@"疲劳驾驶参数设置")]) {
        } else if ([titleStr isEqualToString:Localized(@"碰撞报警参数设置")]) {
        } else if ([titleStr isEqualToString:Localized(@"网络设置")]) {
        } else if ([titleStr isEqualToString:Localized((@"设备重启"))]) {
        }
    }
    [cell.controlImageView setImage: [UIImage imageNamed: self.dataTitleImageArr[indexPath.row]]];
    cell.titleLabel.text = self.dataTitleArr[indexPath.row];
    cell.indexPath = indexPath;
    [cell showDetailViewWithIndexPath: indexPath titleStr:self.dataTitleArr[indexPath.row]];
    __weak __typeof__(self) weakSelf = self;
    __weak __typeof__(cell) weakCell = cell;
    cell.switchStateChangeBlock = ^(NSIndexPath *indexPath, BOOL isON) {
        NSLog(@"%ld %d", (long)indexPath.row , isON);
        NSString *titleStr = self.dataTitleArr[indexPath.row];
        if ([titleStr isEqualToString:Localized(@"电气锁转换")]) {
            // 编辑电气锁 取反
            isON = !isON;
            if (!isON) {
                // 电锁
                weakCell.centerLabel.text = Localized(@"电锁");
            } else {
                // 气锁
                weakCell.centerLabel.text = Localized(@"气锁");;
            }
        }
        if (isON == YES) {
            [weakSelf editRowDataWithIndexPath:indexPath data: @"1"];
        }else {
            [weakSelf editRowDataWithIndexPath:indexPath data: @"0"];
        }
    };
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataTitleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.stateArr[indexPath.row] integerValue] == 0) {
        return 0;
    }
    return 62.5 * KFitHeightRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_HEIGHT, 1)];
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
