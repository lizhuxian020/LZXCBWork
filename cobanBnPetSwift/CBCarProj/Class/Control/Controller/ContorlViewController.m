//
//  ContorlViewController.m
//  Telematics
//
//  Created by lym on 2017/11/27.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "ContorlViewController.h"
#import "ControlTableViewCell.h"
#import "MultiLocationViewController.h"
#import "ConfigurationParameterViewController.h"
#import "MINAlertView.h"
#import "MINPickerView.h"
#import "RecordViewController.h"
#import "MessageServerViewController.h"
#import "ConsoleControlViewController.h"
#import "ImmediatelyPhotoViewController.h"
#import "MultiplePhotoViewController.h"
#import "ElectronicFenceViewController.h"
#import "MINControlModel.h"
#import "MINControlListDataModel.h"
#import "MINSwitchView.h"
#import "MoveWarmViewController.h"
#import "CBSetAlarmViewController.h"
#import "CBSetTerminalViewController.h"
#import "CBControlAlertPopView.h"
#import "CBControlInputPopView.h"
#import "CBControlPickPopView.h"
#import "CBEnquiryFeeViewController.h"
#import "CBOBDMsgViewController.h"

#define K_CBCarWakeUpByCallPhoneNotification @"K_CBCarWakeUpByCallPhoneNotification"  // 车联网唤醒

@interface ContorlViewController () <UITableViewDelegate, UITableViewDataSource, MINPickerViewDelegate,CBControlAlertPopViewDelegate,CBControlInputPopViewDelegate,CBControlPickPopViewDelegate>

@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic, weak) UITextField *textField; // 警告框的输入框
@property (nonatomic, weak) UILabel *btnLabel;
@property (nonatomic, weak) UIButton *alertButton;
@property (nonatomic, copy) NSArray *restArr; // 休眠模式的可选项
@property (nonatomic, weak) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) UIButton *obdTopBtn;
@property (nonatomic, strong) UIButton *obdBttomBtn;
@property (nonatomic, assign) BOOL isObdMessage;
@property (nonatomic, strong) MINControlListDataModel *listModel;

/** 提示弹窗 */
@property (nonatomic,strong) CBControlAlertPopView *alertPopView;
/** 输入值弹窗 */
@property (nonatomic,strong) CBControlInputPopView *inputPopView;
/** 选择弹窗 */
@property (nonatomic,strong) CBControlPickPopView *armingAlertView;

@end

@implementation ContorlViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self requestListDataWithHud:nil];
}
//Localized(@"断油断电")
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    self.restArr = @[@[Localized(@"长在线"), Localized(@"时间休眠"), Localized(@"振动休眠"), Localized(@"深度振动休眠"), Localized(@"定时报告"), Localized(@"定时报告+深度振动休眠")]];
}
- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = [NSMutableArray array];
        NSArray *arrayTitle = @[Localized(@"单次定位"), Localized(@"多次定位"),Localized(@"电话唤醒"), Localized(@"电话回拨"), Localized(@"断油断电"),Localized(@"停止报警"), Localized(@"布防/撤防"),Localized(@"电子围栏"),Localized(@"话费查询"),Localized(@"请求OBD消息"),Localized(@"报警设置"),Localized(@"终端设置")];
        NSArray *arrayTitleImage = @[@"单位定位", @"单位定位",@"电话", @"电话", @"断油",@"重启", @"布防", @"电子围栏",@"信息下发",@"OBD",@"报警统计",@"配置设备"];
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
- (CBControlPickPopView *)armingAlertView {
    if (!_armingAlertView) {
        _armingAlertView = [[CBControlPickPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _armingAlertView.delegate = self;
    }
    return _armingAlertView;
}
- (CBControlInputPopView *)inputPopView {
    if (!_inputPopView) {
        _inputPopView = [[CBControlInputPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _inputPopView.delegate = self;
    }
    return _inputPopView;
}
#pragma mark -- 获取开关类设备控制参数
- (void)requestListDataWithHud:(MBProgressHUD *)hud {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    [[NetWorkingManager shared]getWithUrl:@"devControlController/getParamListApp" params: dic succeed:^(id response,BOOL isSucceed) {
        NSLog(@"----开关类参数-%@-----",response);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                MINControlListDataModel *model = [MINControlListDataModel yy_modelWithJSON: response[@"data"]];
                weakSelf.listModel = model;
            }
        }
        [weakSelf.tableView reloadData];
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Action
- (void)alertButtonClick {
    MINPickerView *pickerView = [[MINPickerView alloc] init];
    pickerView.titleLabel.text = @"";
    pickerView.dataArr = self.restArr;
    pickerView.delegate = self;
    [self.view addSubview: pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    [pickerView showView];
}
- (void)obdButtonClick:(UIButton *)button {
    if (button == self.obdTopBtn) {
        if (self.isObdMessage == YES) {
            self.listModel.obdMsg = 0;
        }else {
            self.listModel.oil = 0;
        }
        self.obdTopBtn.backgroundColor = kBlueColor;
        [self.obdTopBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [self.obdTopBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateHighlighted];
        self.obdBttomBtn.backgroundColor = [UIColor whiteColor];
        [self.obdBttomBtn setTitleColor: k137Color forState: UIControlStateNormal];
        [self.obdBttomBtn setTitleColor: k137Color forState: UIControlStateHighlighted];
    } else {
        if (self.isObdMessage == YES) {
            self.listModel.obdMsg = 1;
        }else {
            self.listModel.oil = 1;
        }
        self.obdBttomBtn.backgroundColor = kBlueColor;
        [self.obdBttomBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [self.obdBttomBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateHighlighted];
        self.obdTopBtn.backgroundColor = [UIColor whiteColor];
        [self.obdTopBtn setTitleColor: k137Color forState: UIControlStateNormal];
        [self.obdTopBtn setTitleColor: k137Color forState: UIControlStateHighlighted];
    }
}

#pragma mark - CreateUI
- (void)createUI {
    [self initBarWithTitle:Localized(@"控制") isBack: NO];
    self.view.backgroundColor = kRGB(247, 247, 247);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}
#pragma mark - tableView delegate & dateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62.5 * KFitHeightRate;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentify = @"ControlCellIndentify";
    ControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
    if (cell == nil) {
        cell = [[ControlTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIndentify];
    }
    if (self.arrayData.count > indexPath.row) {
        CBControlModel *model = self.arrayData[indexPath.row];
        cell.indexPath = indexPath;
        cell.controlModel = model;
        cell.centerLabel.text = @"";
        cell.controlListModel = self.listModel;
    }
    __weak __typeof__(self) weakSelf = self;
    cell.switchStateChangeBlock = ^(NSIndexPath *indexPath, BOOL isON) {
        NSLog(@"%ld %d", (long)indexPath.row , isON);
        if (isON == YES) {
            [weakSelf editRowDataWithIndexPath:indexPath data:@"1" switchStr:@"1"];
        }else {
            [weakSelf editRowDataWithIndexPath:indexPath data:@"0" switchStr:@"0"];
        }
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12.5 * KFitHeightRate;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_HEIGHT, 12.5 * KFitHeightRate)];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    ControlTableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
    if (self.arrayData.count > indexPath.row) {
        CBControlModel *model = self.arrayData[indexPath.row];
        if ([model.titleStr isEqualToString:Localized(@"单次定位")]) {
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
            [[NSNotificationCenter defaultCenter] postNotificationName: @"SingleLocationNoti" object: nil];
        } else if ([model.titleStr isEqualToString:Localized(@"多次定位")]) {
            if (cell.switchView.isON == !self.listModel.dcdd) { // 取反是因为UI的结构导致的
                MultiLocationViewController *locationVC = [[MultiLocationViewController alloc] init];
                locationVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController: locationVC animated: YES];
            }
        } else if ([model.titleStr isEqualToString:Localized(@"电子围栏")]) {
            ElectronicFenceViewController *electronicFenceVC = [[ElectronicFenceViewController alloc] init];
            electronicFenceVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: electronicFenceVC animated: YES];
        } else if ([model.titleStr isEqualToString:Localized(@"断油断电")]) {
            [self showAlertOBDViewWithTitle:Localized(@"断油断电模式设置") indexPath: indexPath];
        } else if ([model.titleStr isEqualToString:Localized(@"停止报警")]) {
            [self stopWarnClick];
        } else if ([model.titleStr isEqualToString:Localized(@"布防/撤防")]) {
            [self arming_disarmingClick];
        } else if ([model.titleStr isEqualToString:Localized(@"振动报警")]) {
        } else if ([model.titleStr isEqualToString:Localized(@"低电报警")]) {
        } else if ([model.titleStr isEqualToString:Localized(@"掉电报警")]) {
        } else if ([model.titleStr isEqualToString:Localized(@"位移报警")]) {
        } else if ([model.titleStr isEqualToString:Localized(@"录音")]) {
            RecordViewController *recordeVC = [[RecordViewController alloc] init];
            recordeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: recordeVC animated: YES];
        } else if ([model.titleStr isEqualToString:Localized(@"立即拍照")]) {
            ImmediatelyPhotoViewController *immediatelyPhotoVC = [[ImmediatelyPhotoViewController alloc] init];
            immediatelyPhotoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: immediatelyPhotoVC animated: YES];
        } else if ([model.titleStr isEqualToString:Localized(@"电话唤醒")]) {
            [self phoneCallBackClick_wakeUp];
        } else if ([model.titleStr isEqualToString:Localized(@"电话回拨")]) {
            [self phoneCallBackClick];
        } else if ([model.titleStr isEqualToString:Localized(@"超速报警")]) {
        } else if ([model.titleStr isEqualToString:Localized(@"信息服务下发")]) {
            MessageServerViewController *messageServerVC = [[MessageServerViewController alloc] init];
            messageServerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: messageServerVC animated: YES];
        } else if ([model.titleStr isEqualToString:Localized(@"云台控制")]) {
            ConsoleControlViewController *consoleVC = [[ConsoleControlViewController alloc] init];
            consoleVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: consoleVC animated: YES];
        } else if ([model.titleStr isEqualToString:Localized(@"多次拍照")]) {
            MultiplePhotoViewController *multiplePhoto = [[MultiplePhotoViewController alloc] init];
            multiplePhoto.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: multiplePhoto animated: YES];
        } else if ([model.titleStr isEqualToString:Localized(@"休眠模式")]) {
            NSString *title = self.restArr[0][self.listModel.restMod];
            [self showAlertPickerViewWithTitle:Localized(@"休眠模式") selectTitle: title indexPath: indexPath];
        } else if ([model.titleStr isEqualToString:Localized(@"配置设备参数")]) {
            ConfigurationParameterViewController *configVC = [[ConfigurationParameterViewController alloc] init];
            configVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: configVC animated: YES];
        } else if ([model.titleStr isEqualToString:Localized(@"报警设置")]) {
            CBSetAlarmViewController *alarmVC = [[CBSetAlarmViewController alloc] init];
            alarmVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: alarmVC animated: YES];
        } else if ([model.titleStr isEqualToString:Localized(@"终端设置")]) {
            CBSetTerminalViewController *terminalVC = [[CBSetTerminalViewController alloc] init];
            terminalVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: terminalVC animated: YES];
        } else if ([model.titleStr isEqualToString:Localized(@"话费查询")]) {
            CBEnquiryFeeViewController *vc = [[CBEnquiryFeeViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: vc animated: YES];
        } else if ([model.titleStr isEqualToString:Localized(@"请求OBD消息")]) {
            CBOBDMsgViewController *vc = [[CBOBDMsgViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: vc animated: YES];
        }
    }
}
- (void)showAlertOBDViewWithTitle:(NSString *)title indexPath:(NSIndexPath *)indexPath {
    __weak __typeof__(self) weakSelf = self;
    MINAlertView *alertView = [[MINAlertView alloc] init];
    __weak MINAlertView *weakAlertView = alertView;
    alertView.titleLabel.text = title;
    [weakSelf.view addSubview: alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    // 重置高度
    [alertView setContentViewHeight: 110];

    CBControlModel *model = self.arrayData[indexPath.row];
    NSString *titleStr = model.titleStr;
    if ([titleStr isEqualToString:Localized(@"断油断电")]) {
        self.isObdMessage = NO;
        weakSelf.obdTopBtn = [MINUtils createBtnWithRadius:5 * KFitHeightRate title:Localized(@"立即断油断电")];
    } else {
        self.isObdMessage = YES;
        weakSelf.obdTopBtn = [MINUtils createBtnWithRadius:5 * KFitHeightRate title:Localized(@"跟随单次定位")];
    }
    weakSelf.obdTopBtn.layer.borderWidth = 0.5;
    weakSelf.obdTopBtn.layer.borderColor = kRGB(210, 210, 210).CGColor;
    weakSelf.obdTopBtn.layer.cornerRadius = 3 * KFitWidthRate;
    [alertView.contentView addSubview: weakSelf.obdTopBtn];
    [weakSelf.obdTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(alertView.contentView);
        make.height.mas_equalTo(40 * KFitHeightRate);
        make.width.mas_equalTo(250 * KFitWidthRate);
    }];
    [weakSelf.obdTopBtn addTarget: self action: @selector(obdButtonClick:) forControlEvents: UIControlEventTouchUpInside];

    if ([titleStr isEqualToString:Localized(@"断油断电")]) {
        weakSelf.obdBttomBtn = [MINUtils createBtnWithRadius:5 * KFitHeightRate title:Localized(@"延时断油断电")];
    } else {
        weakSelf.obdBttomBtn = [MINUtils createBtnWithRadius:5 * KFitHeightRate title:Localized(@"跟随多次定位")];
    }
    weakSelf.obdBttomBtn.backgroundColor = [UIColor whiteColor];
    weakSelf.obdBttomBtn.layer.borderWidth = 0.5;
    weakSelf.obdBttomBtn.layer.borderColor = kRGB(210, 210, 210).CGColor;
    weakSelf.obdBttomBtn.layer.cornerRadius = 3 * KFitWidthRate;
    [weakSelf.obdBttomBtn setTitleColor: k137Color forState: UIControlStateNormal];
    [weakSelf.obdBttomBtn setTitleColor: k137Color forState: UIControlStateHighlighted];
    [alertView.contentView addSubview: weakSelf.obdBttomBtn];
    [weakSelf.obdBttomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView.contentView);
        make.bottom.equalTo(alertView.contentView).with.offset(-18 * KFitWidthRate);
        make.height.mas_equalTo(40 * KFitHeightRate);
        make.width.mas_equalTo(250 * KFitWidthRate);
    }];
    [weakSelf.obdBttomBtn addTarget: self action: @selector(obdButtonClick:) forControlEvents: UIControlEventTouchUpInside];
    if ((weakSelf.listModel.obdMsg == 0 && self.isObdMessage == YES) || (weakSelf.listModel.oil == 0 && weakSelf.isObdMessage == NO)) {
        weakSelf.obdTopBtn.backgroundColor = kBlueColor;
        [weakSelf.obdTopBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [weakSelf.obdTopBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateHighlighted];
        weakSelf.obdBttomBtn.backgroundColor = [UIColor whiteColor];
        [weakSelf.obdBttomBtn setTitleColor: k137Color forState: UIControlStateNormal];
        [weakSelf.obdBttomBtn setTitleColor: k137Color forState: UIControlStateHighlighted];
    }else {
        weakSelf.obdBttomBtn.backgroundColor = kBlueColor;
        [weakSelf.obdBttomBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [weakSelf.obdBttomBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateHighlighted];
        weakSelf.obdTopBtn.backgroundColor = [UIColor whiteColor];
        [weakSelf.obdTopBtn setTitleColor: k137Color forState: UIControlStateNormal];
        [weakSelf.obdTopBtn setTitleColor: k137Color forState: UIControlStateHighlighted];
    }
    self.obdBttomBtn.selected = self.listModel.oil == 1?YES:NO;//YES;
    self.obdTopBtn.selected = self.listModel.oil == 1?NO:YES;
    alertView.rightBtnClick = ^{
        [weakAlertView hideView];
        // 修改model的数据，不要忘记了
        if ([titleStr isEqualToString:Localized(@"断油断电")]) {
            [weakSelf editRowDataWithIndexPath: indexPath data:@"oil" switchStr:nil];
        } else {
            [weakSelf editRowDataWithIndexPath: indexPath data:@"ObdMsg" switchStr:nil];
        }
    };
    alertView.leftBtnClick = ^{
        [weakAlertView hideView];
    };
}
- (void)showAlertPickerViewWithTitle:(NSString *)title selectTitle:(NSString *)selectTitle indexPath:(NSIndexPath *)indexPath {
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
    weakSelf.alertButton = [MINUtils createBorderBtnWithArrowImage];
    [alertView.contentView addSubview: weakSelf.alertButton];
    [weakSelf.alertButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView.contentView);
        make.centerY.equalTo(alertView.contentView).with.offset(-5 * KFitHeightRate);
        make.height.mas_equalTo(40 * KFitHeightRate);
        make.width.mas_equalTo(250 * KFitWidthRate);
    }];
    [weakSelf.alertButton addTarget: self action: @selector(alertButtonClick) forControlEvents: UIControlEventTouchUpInside];
    weakSelf.btnLabel = [MINUtils createLabelWithText: selectTitle size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(96, 96, 96)];
    [weakSelf.alertButton addSubview: weakSelf.btnLabel];
    [weakSelf.btnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.alertButton);
        make.left.equalTo(weakSelf.alertButton).with.offset(12.5 * KFitWidthRate);
        make.width.mas_equalTo(200 * KFitWidthRate);
    }];
    alertView.rightBtnClick = ^{
        [weakAlertView hideView];
            // 修改model的数据，不要忘记了
        cell.detailLabel.text = weakSelf.btnLabel.text;
        [weakSelf editRowDataWithIndexPath: indexPath data: [NSString stringWithFormat: @"%d" , weakSelf.listModel.restMod] switchStr:nil];
    };
    alertView.leftBtnClick = ^{
        [weakAlertView hideView];
    };
}
- (void)editRowDataWithIndexPath:(NSIndexPath *)indexPath data:(NSString *)data switchStr:(NSString *)switchStr {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    if (self.arrayData.count > indexPath.row) {
        CBControlModel *model = self.arrayData[indexPath.row];
        NSString *titleStr = model.titleStr;
        if ([titleStr isEqualToString:Localized(@"单次定位")]) {
        } else if ([titleStr isEqualToString:Localized(@"多次定位")]) {
            dic[@"dcdd"] = data;
        } else if ([titleStr isEqualToString:Localized(@"电子围栏")]) {
        } else if ([titleStr isEqualToString:Localized(@"断油断电")]) {
            if ([data isEqualToString: @"oil"]) {
                dic[@"oil"] = [NSString stringWithFormat: @"%d", self.listModel.oil];;
            }else {
                dic[@"dydd"] = data;
            }
        } else if ([titleStr isEqualToString:Localized(@"布防/撤防")]) {
            dic[@"cfbf"] = data;
        } else if ([titleStr isEqualToString:Localized(@"振动报警")]) {
            dic[@"warm_zd"] = data;
        } else if ([titleStr isEqualToString:Localized(@"低电报警")]) {
            dic[@"warm_didian"] = data;
        } else if ([titleStr isEqualToString:Localized(@"掉电报警")]) {
            dic[@"warm_diaodian"] = data;
        } else if ([titleStr isEqualToString:Localized(@"位移报警")]) {
            dic[@"warm_wy"] = data;  //位移开关
            if (switchStr) {
                dic[@"move_warm"] = data; //位移值
            }
        } else if ([titleStr isEqualToString:Localized(@"录音")]) {
            dic[@"voice"] = data;
        } else if ([titleStr isEqualToString:Localized(@"立即拍照")]) {
            dic[@"photo"] = data;
        } else if ([titleStr isEqualToString:Localized(@"请求OBD消息")]) {
            if ([data isEqualToString: @"ObdMsg"]) {
                dic[@"obdMsg"] = [NSString stringWithFormat: @"%d", self.listModel.obdMsg];
                dic[@"obd"] = @"1";  // 选择了时间，就开启了OBD消息
            }else {
                dic[@"obd"] = data;
            }
        } else if ([titleStr isEqualToString:Localized(@"电话回拨")]) {
            dic[@"phone"] = data;
        } else if ([titleStr isEqualToString:Localized(@"超速报警")]) {
            dic[@"over_warm"] = data;           //超速值
            if (switchStr) {
                dic[@"warm_speed"] = switchStr; //超速开关
            }
        } else if ([titleStr isEqualToString:Localized(@"信息服务下发")]) {
        } else if ([titleStr isEqualToString:Localized(@"云台控制")]) {
        } else if ([titleStr isEqualToString:Localized(@"多次拍照")]) {
        } else if ([titleStr isEqualToString:Localized(@"休眠模式")]) {
            dic[@"rest_mod"] = data;
        } else if ([titleStr isEqualToString:Localized(@"配置设备参数")]) {
        }
    }
#pragma mark -- 编辑开关类控制网络请求
    __weak __typeof__(self) weakSelf = self;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl: @"devControlController/editSwitchParam" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        if (isSucceed) {
            [weakSelf requestListDataWithHud:nil];
        } else {
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
    }];
}
#pragma mark - PickerViewDelegate
- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic {
    NSNumber *number = dic[@"0"];
    self.btnLabel.text = self.restArr[0][[number integerValue]];
    self.listModel.restMod = [number intValue];
}
#pragma mark -- 电话回拨
- (void)phoneCallBackClick {
    [self.inputPopView updateTitle:Localized(@"电话回拨") placehold:Localized(@"输入电话号码") isDigital:YES];
    [self.inputPopView popView];
    [self.inputPopView.inputTF limitTextFieldTextLength:18];
}
- (void)phoneCallBackClick_wakeUp {
    [self.inputPopView updateTitle:Localized(@"电话唤醒") placehold:Localized(@"输入电话号码") isDigital:YES];
    [self.inputPopView popView];
    [self.inputPopView.inputTF limitTextFieldTextLength:18];
    NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:K_CBCarWakeUpByCallPhoneNotification];
    if (phone.length > 0) {
        self.inputPopView.inputTF.text = phone;
    }
}
#pragma mark -- 电话回拨 -- 代理
- (void)updateTextFieldValue:(NSString *)inputStr returnTitle:(NSString *)title {
    if ([title isEqualToString:Localized(@"电话回拨")]) {
        NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
        [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
        [paramters setObject:inputStr?:@"" forKey:@"phone"];
        [self editControlSwitchRequest:paramters];
    } else if ([title isEqualToString:Localized(@"电话唤醒")]) {
        //拨打电话
        if (inputStr.length > 0) {
            [CBWtUtils callPhone:inputStr];
            [[NSUserDefaults standardUserDefaults]setObject:inputStr forKey:K_CBCarWakeUpByCallPhoneNotification];
        }
    }
    
}
#pragma mark -- 停止报警
- (void)stopWarnClick {
    [self.alertPopView updateTitle:Localized(@"停止报警") msg:Localized(@"确定停止报警?")];
    [self.alertPopView popView];
}
#pragma mark -- 停止报警 -- 代理
- (void)clickType:(NSString *)title {
    if ([title isEqualToString:Localized(@"停止报警")]) {
        NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
        [paramters setObject:@"0" forKey:@"warnStop"];
        [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
        [self editControlNewRequest:paramters];
    }
}
#pragma mark -- 布防/撤防
- (void)arming_disarmingClick {
    [self.armingAlertView popView];
    NSArray *array = @[Localized(@"布防"),Localized(@"撤防"),Localized(@"静音布防")];
    //silent_arm
    NSString *selectTitle = @"";
    if ([self.listModel.silentArm isEqualToString:@"1"]) {
        // 静音布防
        selectTitle = Localized(@"静音布防");
    } else if (self.listModel.cfbf == 1) {
        // 布防
        selectTitle = Localized(@"布防");
    } else {
        // 撤防
        selectTitle = Localized(@"撤防");
    }
    [self.armingAlertView updateTitle:Localized(@"布防/撤防") menuArray:array seletedTitle:selectTitle];
    //[self.armingAlertView popView];
}
#pragma mark -- 布防/撤防 点击代理
- (void)pickerPopViewClickIndex:(NSInteger)index {
    switch (index) {
        case 100:
        {
            NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
            [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
            [paramters setObject:@"1" forKey:@"cfbf"];
            [self editControlSwitchRequest:paramters];
        }
            break;
        case 101:
        {
            NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
            [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
            [paramters setObject:@"0" forKey:@"cfbf"];
            [self editControlSwitchRequest:paramters];
        }
            break;
        case 102:
        {
            NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithObject:@"1" forKey:@"silentArm"];
            [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
            [self editControlNewRequest:paramters];
        }
            break;
        default:
            break;
    }
}
#pragma mark -- 终端设备开关设置
- (void)editControlSwitchRequest:(NSMutableDictionary *)paramters {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl: @"devControlController/editSwitchParam" params: paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self requestListDataWithHud:nil];
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 终端设备参数设置 -- 新增
- (void)editControlNewRequest:(NSMutableDictionary *)paramters {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBNetworkRequestManager sharedInstance] terminalSettingParamters:paramters success:^(CBBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self requestListDataWithHud:nil];
    } failure:^(NSError * _Nonnull error) {
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
