//
//  FormViewController.m
//  Telematics
//
//  Created by lym on 2017/11/14.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "FormViewController.h"
#import "FormProtocalModel.h"
#import "FormHeaderView.h"
#import "FormTableViewCell.h"
#import "LineChartViewController.h"
#import "BarChartViewController.h"
#import "FormDateChooseViewController.h"
#import "MultimediaViewController.h"
#import "_CBMyInfoPopView.h"
#import "CBPersonInfoController.h"
#import "AboutUsViewController.h"
#import "cobanBnPetSwift-Swift.h"
@interface FormViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *sectionStatusArr;
@property (nonatomic, strong) FormProtocalModel *model;
@property (nonatomic, copy) NSArray *sectionTitleArr;
@property (nonatomic, copy) NSArray *sectionImageTitleArr;
@property (nonatomic, copy) NSArray *oilTitleArr;
@property (nonatomic, copy) NSArray *oilImageArr;
@property (nonatomic, copy) NSArray *warnTitleArr;
@property (nonatomic, copy) NSArray *warnImageArr;
@property (nonatomic, copy) NSArray *electronicTitleArr;
@property (nonatomic, copy) NSArray *electronicImageArr;
//@property (nonatomic, strong) NSMutableArray *showArr; // 显示项
@property (nonatomic, strong) _CBMyInfoPopView *infoPopView;
@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createUI];
//    //设置预估高为0 tableView刷新后防止滚动,闪动
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    kWeakSelf(self);
    [[CBDeviceTool shareInstance] getReportData:[CBCommonTools CBdeviceInfo] blk:^(NSArray * _Nonnull sectionArr, NSArray * _Nonnull sectionTitleArr, NSArray * _Nonnull sectionImageTitleArr, NSArray * _Nonnull oilTitleArr, NSArray * _Nonnull oilImageArr, NSArray * _Nonnull warnTitleArr, NSArray * _Nonnull warnImageArr, NSArray * _Nonnull electronicTitleArr, NSArray * _Nonnull electronicImageArr) {
        weakself.sectionStatusArr = [NSMutableArray arrayWithArray:sectionArr];
        weakself.sectionTitleArr = sectionTitleArr;
        weakself.sectionImageTitleArr = sectionImageTitleArr;
        
        weakself.oilTitleArr = oilTitleArr;
        weakself.oilImageArr = oilImageArr;
        
        weakself.warnTitleArr = warnTitleArr;
        weakself.warnImageArr = warnImageArr;
        
        weakself.electronicTitleArr = electronicTitleArr;
        weakself.electronicImageArr = electronicImageArr;
        
    }];
    [self.tableView reloadData];
    
    CBHomeLeftMenuDeviceInfoModel *model = [CBCommonTools CBdeviceInfo];
    [self initBarRighBtnTitle: model.name?:@"" target: self action: @selector(didRightBtn)];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle: Localized(@"统计报表") isBack: NO];
    CBHomeLeftMenuDeviceInfoModel *model = [CBCommonTools CBdeviceInfo];
    [self initBarRighBtnTitle: model.name?:@"" target: self action: @selector(didRightBtn)];
    [self createTableView];
    [self setupInfoPopView];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kBackColor;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}
- (void)didRightBtn {
//    [self.infoPopView pop];
}
- (void)setupInfoPopView {
    self.infoPopView = [_CBMyInfoPopView new];
    kWeakSelf(self);
    [self.infoPopView setDidClickPersonInfo:^{
        CBPersonInfoController *v = [CBPersonInfoController new];
        [weakself.navigationController pushViewController:v animated: YES];
    }];
    [self.infoPopView setDidClickAbout:^{
        AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
        [weakself.navigationController pushViewController: aboutUsVC animated: YES];
    }];
    [self.infoPopView setDidClickPwd:^{
        CBPetUpdatePwdViewController *vc = [CBPetUpdatePwdViewController new];
        [weakself.navigationController pushViewController:vc animated:YES];
    }];
    [self.infoPopView setDidClickLogout:^{
        [weakself quitBtnClick];
    }];
}
- (void)quitBtnClick
{
    // 退出登录提醒
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:Localized(@"是否退出登录") preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self logoutRequest];
        [self logoutAction];
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}
- (void)logoutAction {
    // 清除本地选中的设备token
//    CBWtUserLoginModel *userModel = [CBWtUserLoginModel CBaccount];
//    userModel.token = nil;
//    [CBWtUserLoginModel saveCBAccount:userModel];
//    [[NSNotificationCenter defaultCenter] postNotificationName:KCBWt_SwitchCBWtLoginViewController object:nil];
    // 信鸽推送 解绑
    //[[XGPushTokenManager defaultTokenManager] unbindWithIdentifer:[NSString stringWithFormat:@"%@",@(userModel.uid)] type:XGPushTokenBindTypeAccount];
    
    CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
    userModel.token = nil;
    [CBPetLoginModelTool saveUser:userModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"K_SwitchLoginViewController" object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - tableView delegate & dataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBHomeLeftMenuDeviceInfoModel *model = [CBCommonTools CBdeviceInfo];
    NSString *sectionTitle = self.sectionTitleArr[indexPath.section];
    
    // 这里显示曲线的只有 日里程耗油报表 和 油量里程速度表
    if ([sectionTitle isEqualToString:Localized(@"油量统计")]) {
        NSString *oilTitle = self.oilTitleArr[indexPath.row];
        if ([oilTitle isEqualToString:Localized(@"日里程耗油报表")]) { // 日里程耗油报表
            BarChartViewController *doubleYBarChartVC = [[BarChartViewController alloc] init];
            doubleYBarChartVC.hidesBottomBarWhenPushed = YES;
            doubleYBarChartVC.titleName = model.name?:@"";//@"ASFE2EF3";
            doubleYBarChartVC.isDoubleYChart = YES;
            [self.navigationController pushViewController: doubleYBarChartVC animated:YES];
        }
        if ([oilTitle isEqualToString:Localized(@"油量里程速度表")]) {// 油量里程速度表
            LineChartViewController *doubleYLineChartVC = [[LineChartViewController alloc] init];
            doubleYLineChartVC.hidesBottomBarWhenPushed = YES;
            doubleYLineChartVC.isDoubleYChart = YES;
            doubleYLineChartVC.titleName = model.name?:@"";//@"ASFE2EF3";
            [self.navigationController pushViewController: doubleYLineChartVC animated:YES];
        }
    } else { // 其余都是一种类型
        FormDateChooseViewController *formDateChooseVC = [[FormDateChooseViewController alloc] init];
        formDateChooseVC.hidesBottomBarWhenPushed = YES;
        if ([sectionTitle isEqualToString:Localized(@"油量统计")]) {
            NSString *oilTitle = self.oilTitleArr[indexPath.row];
            formDateChooseVC.type =
            [oilTitle isEqualToString:Localized(@"加油报表")] ? FormTypePourOil :
            [oilTitle isEqualToString:Localized(@"漏油报表")] ? FormTypeOilLeak :
            FormTypePourOil;
        }
        if ([sectionTitle isEqualToString:Localized(@"报警统计")]) {
            NSString *alarmTitle = self.warnTitleArr[indexPath.row];
            formDateChooseVC.type =
            [alarmTitle isEqualToString: Localized(@"所有报警统计报表")] ? FormTypeAllAlarm :
            [alarmTitle isEqualToString: Localized(@"SOS报警统计报表")] ? FormTypeSOSAlarm :
            [alarmTitle isEqualToString: Localized(@"超速报警统计报表")] ? FormTypeOverspeedAlarm :
            [alarmTitle isEqualToString: Localized(@"疲劳驾驶统计报表")] ? FormTypeTiredAlarm :
            [alarmTitle isEqualToString: Localized(@"欠压报警统计报表")] ? FormTypeUnderpackingAlarm :
            [alarmTitle isEqualToString: Localized(@"掉电报警统计报表")] ? FormTypePowerDownAlarm :
            [alarmTitle isEqualToString: Localized(@"振动报警统计报表")] ? FormTypeShakeAlarm :
            [alarmTitle isEqualToString: Localized(@"开门报警统计报表")] ? FormTypeOpenDoorAlarm :
            [alarmTitle isEqualToString: Localized(@"点火报警统计报表")] ? FormTypeFireAlarm :
            [alarmTitle isEqualToString: Localized(@"位移报警统计报表")] ? FormTypeMoveAlarm :
            [alarmTitle isEqualToString: Localized(@"偷油漏油报警统计报表")] ? FormTypeGasolineTheftAlarm :
            [alarmTitle isEqualToString: Localized(@"碰撞报警报表")] ? FormTypeCollisionAlarm :
            FormTypeAllAlarm;
        }
        if ([sectionTitle isEqualToString:Localized(@"电子围栏报表")]) {
            NSString *eleString = self.electronicTitleArr[indexPath.row];
            formDateChooseVC.type =
            [eleString isEqualToString:Localized(@"入围栏报警报表")] ? FormTypeInFencing :
            [eleString isEqualToString:Localized(@"出围栏报警报表")] ? FormTypeOutFencing :
            [eleString isEqualToString:Localized(@"出入围栏报警报表")] ? FormTypeInOutFencing :
            FormTypeInFencing;
        }
        [self.navigationController pushViewController: formDateChooseVC animated: YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionStatusArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int flag = [self.sectionStatusArr[section] intValue];
    if (flag == 0) {
        return 0;
    }
    NSString *sectionTitle = self.sectionTitleArr[section];
    if ([sectionTitle isEqualToString:Localized(@"油量统计")]) { // 油量统计
        return self.oilTitleArr.count;
    } else if ([sectionTitle isEqualToString:Localized(@"报警统计")]) { // 报警统计
        return self.warnTitleArr.count;
    } else if ([sectionTitle isEqualToString:Localized(@"电子围栏报表")]) { // 电子围栏报表
        return self.electronicTitleArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"FormTableViewCell";
    FormTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
    if (cell == nil) {
        cell = [[FormTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: cellIndentify];
    }
    NSString *sectionTitle = self.sectionTitleArr[indexPath.section];
    if ([sectionTitle isEqualToString:Localized(@"油量统计")]) { // 油量统计
        cell.nameLabel.text = self.oilTitleArr[indexPath.row];
        cell.imgView.image = [UIImage imageNamed:self.oilImageArr[indexPath.row]];
    } else if ([sectionTitle isEqualToString:Localized(@"报警统计")]) { // 报警统计
        cell.nameLabel.text = self.warnTitleArr[indexPath.row];
        cell.imgView.image = [UIImage imageNamed:self.warnImageArr[indexPath.row]];
    } else if ([sectionTitle isEqualToString:Localized(@"电子围栏报表")]) { // 电子围栏报表
        cell.nameLabel.text = self.electronicTitleArr[indexPath.row];
        cell.imgView.image = [UIImage imageNamed:self.electronicImageArr[indexPath.row]];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FormHeaderView *view = [[FormHeaderView alloc] init];
//    view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 50 * KFitHeightRate);
    view.titleLabel.text = self.sectionTitleArr[section];
    view.exTitleLabel.text = self.sectionTitleArr[section];
    view.titleImageView.image = [UIImage imageNamed: self.sectionImageTitleArr[section]];
    view.section = section;
    [view checkIfShowBottomLine:self.sectionImageTitleArr currentIdx:section];
//    [view setCornerWithSection: section];
    int flag = [_sectionStatusArr[section] intValue];
    if (flag == 0) {
        view.arrowImageBtn.selected = NO;//YES;
        view.exArrowImageBtn.selected = NO;//YES;
    }else {
        view.arrowImageBtn.selected = YES;//NO;
        view.exArrowImageBtn.selected = YES;//NO;
    }
    NSString *sectionTitle = self.sectionTitleArr[section];
    if ([sectionTitle isEqualToString:Localized(@"油量统计")] ||
        [sectionTitle isEqualToString:Localized(@"报警统计")] ||
        [sectionTitle isEqualToString:Localized(@"电子围栏报表")]) { // 5油量统计 6报警统计 8电子围栏报表
        [view setDownforwardImage];
        [view showExpandableView];
    } else {
        [view hideExpandableView];
    }
    __weak __typeof__(self) weakSelf = self;
    //__block FormHeaderView *weakHeadView = view;
    __weak typeof(view) weakHeadView = view;
    view.headerBtnClick = ^(NSInteger section) {
        
        CBHomeLeftMenuDeviceInfoModel *model = [CBCommonTools CBdeviceInfo];
        if ([sectionTitle isEqualToString:Localized(@"速度报表")]) { // 速度报表
            LineChartViewController *singleLineChartVC = [[LineChartViewController alloc] init];
            singleLineChartVC.hidesBottomBarWhenPushed = YES;
            singleLineChartVC.titleName = model.name?:@"";//@"ASFE2EF3";
            [self.navigationController pushViewController: singleLineChartVC animated: YES];
        }else if ([sectionTitle isEqualToString:Localized(@"里程统计")]) { // 里程统计
            BarChartViewController *singleBarChartVC = [[BarChartViewController alloc] init];
            singleBarChartVC.hidesBottomBarWhenPushed = YES;
            singleBarChartVC.titleName = model.name?:@"";//@"ASFE2EF3";
            [self.navigationController pushViewController: singleBarChartVC animated: YES];
        }else if ([sectionTitle isEqualToString:Localized(@"油量统计")] ||
                  [sectionTitle isEqualToString:Localized(@"报警统计")] ||
                  [sectionTitle isEqualToString:Localized(@"电子围栏报表")]) { // 5油量统计 6报警统计 8电子围栏报表 // 这里是展开还是收缩
            weakHeadView.arrowImageBtn.selected = !weakHeadView.arrowImageBtn.selected;
            weakHeadView.exArrowImageBtn.selected = !weakHeadView.exArrowImageBtn.selected;
            [weakSelf reloadTableSectionAtIndex: section];
        }
//        else if (section == 9) { // 多媒体记录报表
//            MultimediaViewController *multimedieVC = [[MultimediaViewController alloc] init];
//            multimedieVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController: multimedieVC animated: YES];
//        }
        else { // 其他都一样
            FormDateChooseViewController *formDateChooseVC = [[FormDateChooseViewController alloc] init];
            if ([sectionTitle isEqualToString:Localized(@"怠速报表")]) {
                formDateChooseVC.type = FormTypeIdling;
            }else if ([sectionTitle isEqualToString:Localized(@"停留统计")]) {
                formDateChooseVC.type = FormTypeStay;
            }else if ([sectionTitle isEqualToString:Localized(@"点火报表")]) {
                formDateChooseVC.type = FormTypeFire;
            }else if ([sectionTitle isEqualToString:Localized(@"OBD报表")]) {
                formDateChooseVC.type = FormTypeOBD;
            }
//            else if (section == 10) {
//                formDateChooseVC.type = FormTypeSchedule;
//            }
            formDateChooseVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: formDateChooseVC animated: YES];
        }
    };
    return view;
}

- (void)reloadTableSectionAtIndex:(NSInteger) section
{
    int flag = [_sectionStatusArr[section] intValue];
    if (flag == 0) {
        [_sectionStatusArr setObject: @1 atIndexedSubscript: section];
    }else {
        [_sectionStatusArr setObject: @0 atIndexedSubscript: section];
    }
    //刷新当前的分组
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex: section];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
