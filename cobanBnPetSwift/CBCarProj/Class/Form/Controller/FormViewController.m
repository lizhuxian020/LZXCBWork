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

@interface FormViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *sectionStatusArr;
}
@property (nonatomic, strong) NSArray *sectionArr; // section的数组，0表示显示 1表示不显示项
@property (nonatomic, strong) NSArray *alarmArr; // alarm的数组, 0表示显示 1表示不显示项
@property (nonatomic, strong) FormProtocalModel *model;
@property (nonatomic, copy) NSArray *sectionTitleArr;
@property (nonatomic, copy) NSArray *sectionImageTitleArr;
@property (nonatomic, copy) NSArray *oilTitleArr;
@property (nonatomic, copy) NSArray *warnTitleArr;
@property (nonatomic, copy) NSArray *electronicTitleArr;
@property (nonatomic, assign) NSInteger lastAlarm;
//@property (nonatomic, strong) NSMutableArray *showArr; // 显示项
@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    self.sectionArr = [NSMutableArray arrayWithArray: @[@1, @1, @1, @1, @1, @1, @1, @1, @1]];
    // 分别是 速度报表，怠速报表，停留统计，点火报表，里程统计，油量统计，报警统计，OBD报表，电子围栏报表，多媒体记录报表
    self.alarmArr = [NSMutableArray arrayWithArray: @[@1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1]];
    // 分别是 所有报警，sos报警，超速报警，疲劳驾驶，欠压报警，掉电报警，振动报警，开门报警，点火报警，位移报警，偷油漏油报警，碰撞报警统计报表
//    self.sectionTitleArr = @[Localized(@"速度报表"), Localized(@"怠速报表"), Localized(@"停留统计"), Localized(@"点火报表"), Localized(@"里程统计"), Localized(@"油量统计"), Localized(@"报警统计"), Localized(@"OBD报表"), Localized(@"电子围栏报表"), Localized(@"多媒体记录报表"), Localized(@"调度记录报表")];
    self.sectionTitleArr = @[Localized(@"速度报表"), Localized(@"怠速报表"), Localized(@"停留统计"), Localized(@"点火报表"), Localized(@"里程统计"), Localized(@"油量统计"), Localized(@"报警统计"), Localized(@"OBD报表"), Localized(@"电子围栏报表")];
//    self.sectionImageTitleArr = @[@"速度报表", @"怠速报表", @"停留统计", @"点火报表", @"里程统计", @"油量统计", @"报警统计", @"OBD报表", @"电子围栏报表", @"多媒体记录报表", @"调度记录报表"];
    self.sectionImageTitleArr = @[@"速度报表", @"怠速报表", @"停留统计", @"点火报表", @"里程统计", @"油量统计", @"报警统计", @"OBD报表", @"电子围栏报表"];
    self.oilTitleArr = @[Localized(@"日里程耗油报表"), Localized(@"油量里程速度表"), Localized(@"加油报表"), Localized(@"漏油报表")];
    self.warnTitleArr = @[Localized(@"所有报警统计报表"), Localized(@"SOS报警统计报表"), Localized(@"超速报警统计报表"), Localized(@"疲劳驾驶统计报表"), Localized(@"欠压报警统计报表"), Localized(@"掉电报警统计报表"), Localized(@"振动报警统计报表"), Localized(@"开门报警统计报表"), Localized(@"点火报警统计报表"), Localized(@"位移报警统计报表"), Localized(@"偷油漏油报警统计报表"), Localized(@"碰撞报警报表")];
    self.electronicTitleArr = @[Localized(@"入围栏报警报表"), Localized(@"出围栏报警报表"), Localized(@"出入围栏报警报表")];
    sectionStatusArr = [NSMutableArray arrayWithObjects: @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, nil];
    // 设置需要显示报警的cell的最后一个index
    for (int i = 0; i < self.alarmArr.count; i++) {
        if ([self.alarmArr[self.alarmArr.count - 1 - i] integerValue] == 1) {
            self.lastAlarm = self.alarmArr.count - 1 - i;
            break;
        }
    }
    //[self requestData];
    
//    //设置预估高为0 tableView刷新后防止滚动,闪动
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CBHomeLeftMenuDeviceInfoModel *model = [CBCommonTools CBdeviceInfo];
    [self initBarRighBtnTitle: model.name?:@"" target: nil action: nil];
}
#pragma mark -- 根据协议展示控制功能
- (void)requestData
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    //dic[@"proto"] = [AppDelegate shareInstance].potocal;
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devReportController/getMenuByProto" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                FormProtocalModel *model = [FormProtocalModel yy_modelWithJSON: response[@"data"]];
                weakSelf.sectionArr = [model getSectionArr];
                weakSelf.alarmArr = [model getWarmArr];
                for (int i = 0; i < weakSelf.alarmArr.count; i++) {
                    if ([weakSelf.alarmArr[weakSelf.alarmArr.count - 1 - i] integerValue] == 1) {
                        weakSelf.lastAlarm = weakSelf.alarmArr.count - 1 - i;
                        break;
                    }
                }
                [weakSelf.tableView reloadData];

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
    [self initBarWithTitle: Localized(@"统计报表") isBack: NO];
    CBHomeLeftMenuDeviceInfoModel *model = [CBCommonTools CBdeviceInfo];
    [self initBarRighBtnTitle: model.name?:@"" target: nil action: nil];
    [self createTableView];
}

- (void)createTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kRGB(236, 236, 236);
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}

#pragma mark - tableView delegate & dataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBHomeLeftMenuDeviceInfoModel *model = [CBCommonTools CBdeviceInfo];
    // 这里显示曲线的只有 日里程耗油报表 和 油量里程速度表
    if (indexPath.section == 5 && indexPath.row == 0) { // 日里程耗油报表
        BarChartViewController *doubleYBarChartVC = [[BarChartViewController alloc] init];
        doubleYBarChartVC.hidesBottomBarWhenPushed = YES;
        doubleYBarChartVC.titleName = model.name?:@"";//@"ASFE2EF3";
        doubleYBarChartVC.isDoubleYChart = YES;
        [self.navigationController pushViewController: doubleYBarChartVC animated:YES];
    }else if (indexPath.section == 5 && indexPath.row == 1) { // 油量里程速度表
        LineChartViewController *doubleYLineChartVC = [[LineChartViewController alloc] init];
        doubleYLineChartVC.hidesBottomBarWhenPushed = YES;
        doubleYLineChartVC.isDoubleYChart = YES;
        doubleYLineChartVC.titleName = model.name?:@"";//@"ASFE2EF3";
        [self.navigationController pushViewController: doubleYLineChartVC animated:YES];
    }else { // 其余都是一种类型
        FormDateChooseViewController *formDateChooseVC = [[FormDateChooseViewController alloc] init];
        formDateChooseVC.hidesBottomBarWhenPushed = YES;
        if (indexPath.section == 5 && indexPath.row == 2) {
            formDateChooseVC.type = FormTypePourOil;
        }else if (indexPath.section == 5 && indexPath.row == 3) {
            formDateChooseVC.type = FormTypeOilLeak;
        }else if (indexPath.section == 6 && indexPath.row == 0) {
            formDateChooseVC.type = FormTypeAllAlarm;
        }else if (indexPath.section == 6 && indexPath.row == 1) {
            formDateChooseVC.type = FormTypeSOSAlarm;
        }else if (indexPath.section == 6 && indexPath.row == 2) {
            formDateChooseVC.type = FormTypeOverspeedAlarm;
        }else if (indexPath.section == 6 && indexPath.row == 3) {
            formDateChooseVC.type = FormTypeTiredAlarm;
        }else if (indexPath.section == 6 && indexPath.row == 4) {
            formDateChooseVC.type = FormTypeUnderpackingAlarm;
        }else if (indexPath.section == 6 && indexPath.row == 5) {
            formDateChooseVC.type = FormTypePowerDownAlarm;
        }else if (indexPath.section == 6 && indexPath.row == 6) {
            formDateChooseVC.type = FormTypeShakeAlarm;
        }else if (indexPath.section == 6 && indexPath.row == 7) {
            formDateChooseVC.type = FormTypeOpenDoorAlarm;
        }else if (indexPath.section == 6 && indexPath.row == 8) {
            formDateChooseVC.type = FormTypeFireAlarm;
        }else if (indexPath.section == 6 && indexPath.row == 9) {
            formDateChooseVC.type = FormTypeMoveAlarm;
        }else if (indexPath.section == 6 && indexPath.row == 10) {
            formDateChooseVC.type = FormTypeGasolineTheftAlarm;
        }else if (indexPath.section == 6 && indexPath.row == 11) {
            formDateChooseVC.type = FormTypeCollisionAlarm;
        }else if (indexPath.section == 8 && indexPath.row == 0) {
            formDateChooseVC.type = FormTypeInFencing;
        }else if (indexPath.section == 8 && indexPath.row == 1) {
            formDateChooseVC.type = FormTypeOutFencing;
        }else if (indexPath.section == 8 && indexPath.row == 2) {
            formDateChooseVC.type = FormTypeInOutFencing;
        }
        [self.navigationController pushViewController: formDateChooseVC animated: YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int flag = [sectionStatusArr[section] intValue];
    if (flag == 0) {
        return 0;
    }
    if (section == 5 && [self.sectionArr[section] intValue] == 1) { // 油量统计
        return 4;
    }else if (section == 6 && [self.sectionArr[section] intValue] == 1) { // 报警统计
        return 12;
    }else if (section == 8 && [self.sectionArr[section] intValue] == 1) { // 电子围栏报表
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 6 && [self.alarmArr[indexPath.row] integerValue] == 0) {
        FormTableViewCell *cell = [[FormTableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 0)];
        cell.backView.hidden = YES;
        return cell;
    }
    static NSString *cellIndentify = @"FormTableViewCell";
    static NSString *cellIndentifyLast = @"FormTableViewCellLast";
    FormTableViewCell *cell = nil;
    NSInteger numNumOfRow = [tableView numberOfRowsInSection: indexPath.section];
    if (numNumOfRow == indexPath.row + 1 || (self.lastAlarm == indexPath.row && indexPath.section == 6)) {
        cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifyLast];
        if (cell == nil) {
            cell = [[FormTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: cellIndentifyLast];
        }
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
        if (cell == nil) {
            cell = [[FormTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: cellIndentify];
            if ((self.lastAlarm != indexPath.row && indexPath.section == 6) || indexPath.section != 6) {
                [cell addBottomLineView];
            }
        }
    }
    if (indexPath.section == 5) { // 油量统计
        cell.nameLabel.text = self.oilTitleArr[indexPath.row];
    }else if (indexPath.section == 6) { // 报警统计
        cell.nameLabel.text = self.warnTitleArr[indexPath.row];
    }else if (indexPath.section == 8) { // 电子围栏报表
        cell.nameLabel.text = self.electronicTitleArr[indexPath.row];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.sectionArr[section] intValue] == 0) {
        return nil;
    }
    FormHeaderView *view = [[FormHeaderView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 50 * KFitHeightRate);
    view.titleLabel.text = self.sectionTitleArr[section];
    view.titleImageView.image = [UIImage imageNamed: self.sectionImageTitleArr[section]];
    view.section = section;
    [view setCornerWithSection: section];
    int flag = [sectionStatusArr[section] intValue];
    if (flag == 0) {
        view.arrowImageBtn.selected = NO;//YES;
    }else {
        view.arrowImageBtn.selected = YES;//NO;
    }
    if (section == 5 || section == 6 || section == 8) { // 5油量统计 6报警统计 8电子围栏报表
        [view setDownforwardImage];
        [view addBottomLineView];
    }
    __weak __typeof__(self) weakSelf = self;
    //__block FormHeaderView *weakHeadView = view;
    __weak typeof(view) weakHeadView = view;
    view.headerBtnClick = ^(NSInteger section) {
        
        CBHomeLeftMenuDeviceInfoModel *model = [CBCommonTools CBdeviceInfo];
        if (section == 0) { // 速度报表
            LineChartViewController *singleLineChartVC = [[LineChartViewController alloc] init];
            singleLineChartVC.hidesBottomBarWhenPushed = YES;
            singleLineChartVC.titleName = model.name?:@"";//@"ASFE2EF3";
            [self.navigationController pushViewController: singleLineChartVC animated: YES];
        }else if (section == 4) { // 里程统计
            BarChartViewController *singleBarChartVC = [[BarChartViewController alloc] init];
            singleBarChartVC.hidesBottomBarWhenPushed = YES;
            singleBarChartVC.titleName = model.name?:@"";//@"ASFE2EF3";
            [self.navigationController pushViewController: singleBarChartVC animated: YES];
        }else if (section == 5 || section == 6 || section == 8){ // 这里是展开还是收缩
            weakHeadView.arrowImageBtn.selected = !weakHeadView.arrowImageBtn.selected;
            [weakSelf reloadTableSectionAtIndex: section];
        }else if (section == 9) { // 多媒体记录报表
            MultimediaViewController *multimedieVC = [[MultimediaViewController alloc] init];
            multimedieVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: multimedieVC animated: YES];
        }else { // 其他都一样
            FormDateChooseViewController *formDateChooseVC = [[FormDateChooseViewController alloc] init];
            if (section == 1) {
                formDateChooseVC.type = FormTypeIdling;
            }else if (section == 2) {
                formDateChooseVC.type = FormTypeStay;
            }else if (section == 3) {
                formDateChooseVC.type = FormTypeFire;
            }else if (section == 7) {
                formDateChooseVC.type = FormTypeOBD;
            }else if (section == 10) {
                formDateChooseVC.type = FormTypeSchedule;
            }
            formDateChooseVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: formDateChooseVC animated: YES];
        }
    };
    return view;
}

- (void)reloadTableSectionAtIndex:(NSInteger) section
{
    int flag = [sectionStatusArr[section] intValue];
    if (flag == 0) {
        [sectionStatusArr setObject: @1 atIndexedSubscript: section];
    }else {
        [sectionStatusArr setObject: @0 atIndexedSubscript: section];
    }
    //刷新当前的分组
    //NSIndexSet *set = [[NSIndexSet alloc] initWithIndex: section];
    //[self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 6 && [self.alarmArr[indexPath.row] integerValue] == 0) {
        return 0;
    }
    return 50 * KFitHeightRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.sectionArr[section] intValue] == 0) {
        return 0;
    }
    return 62.5 * KFitHeightRate;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.sectionArr.count - 1 == section) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 12.5 * KFitHeightRate)];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.sectionArr.count - 1 == section) {
        return 12.5 * KFitHeightRate;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 6 && [self.alarmArr[indexPath.row] integerValue] == 0) {
        return ;
    }
    FormTableViewCell *deviceCell = (FormTableViewCell *)cell;
    if (deviceCell.isCreate == NO) {
        CGFloat cornerRadius = 5.f * KFitHeightRate;
//        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectMake(0, 0, SCREEN_HEIGHT - 12.5 * KFitWidthRate - 12.5 * KFitWidthRate, 50 * KFitHeightRate);
        if ((self.lastAlarm == indexPath.row && indexPath.section == 6) || indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds) - 1, CGRectGetMaxY(bounds), CGRectGetMaxX(bounds) -1, CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds) -1, CGRectGetMinY(bounds));
        }else { // 中间的view
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds)-1, CGRectGetMinY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds)-1, CGRectGetMaxY(bounds));
        }
        layer.path = pathRef;
        //颜色修改
        layer.fillColor = kCellBackColor.CGColor;
        layer.strokeColor = kCellBackColor.CGColor;
        CFRelease(pathRef);
        [deviceCell.backView.layer insertSublayer: layer atIndex: 0];
        deviceCell.isCreate = YES;
    }
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
