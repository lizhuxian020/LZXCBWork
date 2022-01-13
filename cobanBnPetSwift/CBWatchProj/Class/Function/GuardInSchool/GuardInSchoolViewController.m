//
//  GuardInSchoolViewController.m
//  Watch
//
//  Created by lym on 2018/2/9.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "GuardInSchoolViewController.h"
#import "SwitchHeaderView.h"
#import "SwitchView.h"
#import "MINSwitchView.h"
#import "GuardInSchoolTableViewCell.h"
#import "SetTimePeriodViewController.h"
#import "SetWiFiViewController.h"
#import "GuardIndoModel.h"
#import "SetGuardFenceViewController.h"

@interface GuardInSchoolViewController () <UITableViewDelegate, UITableViewDataSource>
{
    SwitchHeaderView *headerView;
}
@property (nonatomic, strong) GuardIndoModel *model;
@end

@implementation GuardInSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self getGuardInfoData];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"上学守护") isBack: YES];
    headerView = [[SwitchHeaderView alloc] init];
    headerView.swtichView.switchView.isON = YES;
    headerView.swtichView.titleLabel.text = Localized(@"上学守护");
    headerView.imageView.image = [UIImage imageNamed: @"上学守护"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = headerView;
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * (5.0 / 7.5));
    self.tableView.scrollEnabled = NO;
    //    // 高度自适应cell
    self.tableView.estimatedRowHeight = 70 * KFitWidthRate;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    __weak __typeof__(self) weakSelf = self;
    //__weak __typeof__(SwitchHeaderView *)weakHeaderView = headerView;
    headerView.switchStatusChange = ^(BOOL isOn) {
        [weakSelf modifyGuardInfo:isOn];
    };
}
- (void)initModelData
{
    headerView.swtichView.switchView.isON = self.model.action;
    if (self.model.action == YES) {
        headerView.swtichView.statusLabel.text = Localized(@"已开启");
    }else {
        headerView.swtichView.statusLabel.text = Localized(@"已关闭");
    }
    [self.tableView reloadData];
}
#pragma mark -- 获取上学守护信息
- (void)getGuardInfoData
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
    //MBProgressHUD *hud = [CBWtMINUtils hudToView: self.view withText: Localized(@"MINHud_Loading")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] getWithUrl: @"watch/watch/getGoShcoolInfo" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"---------结果：%@",response);
        if (isSucceed && response && [response[@"data"] isKindOfClass: [NSDictionary class]]) {
            weakSelf.model = [GuardIndoModel yy_modelWithDictionary: response[@"data"]];
            [weakSelf initModelData];
        }
        //[hud hideAnimated: YES];
    } failed:^(NSError *error) {
        //[hud hideAnimated: YES];
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 修改上学守护信息
- (void)modifyGuardInfo:(BOOL)switchValue {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
    if (switchValue == YES) {
        dic[@"action"] = @1;
        headerView.swtichView.statusLabel.text = Localized(@"已开启");
    }else {
        dic[@"action"] = @0;
        headerView.swtichView.statusLabel.text = Localized(@"已关闭");
    }
    kWeakSelf(self);
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/updGoShcool" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed ) {
            //[CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"修改成功")];
        }
        [self getGuardInfoData];
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - tableview delegate & datasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // 上学时间
        SetTimePeriodViewController *setTimePeriodVC = [[SetTimePeriodViewController alloc] init];
        setTimePeriodVC.model = self.model;
        [self.navigationController pushViewController: setTimePeriodVC animated: YES];
    }else if (indexPath.row == 0 && indexPath.section == 1) { // 学校地址
        SetGuardFenceViewController *setSchoolFenceVC = [[SetGuardFenceViewController alloc] init];
        setSchoolFenceVC.isSetSchoolFence = YES;
        setSchoolFenceVC.guardModel = self.model;
        [self.navigationController pushViewController: setSchoolFenceVC animated: YES];
    }else if (indexPath.row == 1 && indexPath.section == 1) { // 家小区地址
        SetGuardFenceViewController *setSchoolFenceVC = [[SetGuardFenceViewController alloc] init];
        setSchoolFenceVC.isSetSchoolFence = NO;
        setSchoolFenceVC.guardModel = self.model;
        [self.navigationController pushViewController: setSchoolFenceVC animated: YES];
    }else if (indexPath.row == 0 && indexPath.section == 2) { // 家里WIFI
        SetWiFiViewController *setWifiVC = [[SetWiFiViewController alloc] init];
        [self.navigationController pushViewController: setWifiVC animated: YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentify = @"GuardInSchoolTableViewCellIndentify";
    GuardInSchoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: indentify];
    if (cell == nil) {
        cell = [[GuardInSchoolTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: indentify];
    }
    if (indexPath.section == 0) {
        cell.topLabel.text = Localized(@"上学时间");
        NSString *timeString = [NSString stringWithFormat: @"%@ %@ - %@ %@ %@ - %@ %@ %@",Localized(@"早上-守护"), self.model.inAm?:@"",Localized(@"下午-守护") ,self.model.outAm?:@"", self.model.inPm?:@"", self.model.outPm?:@"",Localized(@"到家-守护"),self.model.backTime?:@""];
        cell.bottomLabel.text = kStringIsEmpty(self.model.outAm)?Localized(@"请设置时间"):timeString;//timeString;
    } else if (indexPath.row == 0 && indexPath.section == 1) {
        cell.topLabel.text = Localized(@"学校地址");
        cell.bottomLabel.text = kStringIsEmpty(self.model.schoolAddress)?Localized(@"请设置地址"):self.model.schoolAddress?:@"";
        [CBWtMINUtils addLineToView: cell.contentView isTop: NO hasSpaceToSide: YES];
    } else if (indexPath.row == 1 && indexPath.section == 1) {
        cell.topLabel.text = Localized(@"家小区地址");
        cell.bottomLabel.text = kStringIsEmpty(self.model.homeAddress)?Localized(@"请设置地址"):self.model.homeAddress?:@"";
    } else if (indexPath.row == 0 && indexPath.section == 2) {
//        cell.topLabel.text = @"家里WIFI";
//        cell.bottomLabel.text = self.model.wifi;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;//3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.5 * KFitWidthRate;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12.5 * KFitWidthRate)];
    headerView.backgroundColor = KWtBackColor;
    return headerView;
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
