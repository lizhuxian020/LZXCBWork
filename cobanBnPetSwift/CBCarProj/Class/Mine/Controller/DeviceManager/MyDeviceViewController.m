//
//  MyDeviceViewController.m
//  Telematics
//
//  Created by lym on 2017/10/27.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MyDeviceViewController.h"
#import "DeviceTableViewCell.h"
#import "DeviceHeaderView.h"
#import "MINPickerView.h"
#import "MyDeviceDetailViewController.h"
#import "AddDeviceViewController.h"
#import "MyDeviceModel.h"
#import "NotificationKey.h"

@interface MyDeviceViewController () <UITableViewDelegate, UITableViewDataSource, MINPickerViewDelegate>
{
    NSMutableArray *sectionStatusArr;
}
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *groupNameArr;
@property (nonatomic, strong) NSMutableArray *groupIDArr;
@property (nonatomic, strong) NSIndexPath *longPressIndexPath;

@end

@implementation MyDeviceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self requestDataWithHud: nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    sectionStatusArr = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    self.groupNameArr = [NSMutableArray array];
    self.groupIDArr = [NSMutableArray array];
}
#pragma mark - CreateUI
- (void)createUI {
    [self initBarWithTitle:Localized(@"我的设备") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"添加") target: self action: @selector(addDeviceName)];
    [self showBackGround];
    [self createTableView];
    [self addGesture];
}

- (void)addGesture
{
    // 添加手势
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(longPressGRClick:)];
    longPressGR.minimumPressDuration = 0.6f;
    [self.tableView addGestureRecognizer: longPressGR];
}

- (void)createTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.view);
    }];
    
    //设置预估高为0 tableView刷新后防止滚动,闪动
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
}
#pragma mark -- 获取设备列表
- (void)requestDataWithHud:(MBProgressHUD *)hud
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"personController/getMyDeviceList" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"设备列表:%@",response);
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                [weakSelf.dataArr removeAllObjects];
                [sectionStatusArr removeAllObjects];
                [weakSelf.groupNameArr removeAllObjects];
                [weakSelf.groupIDArr removeAllObjects];
                NSArray *responseArr = response[@"data"];
                for (int i = 0; i < responseArr.count - 2; i++) {
                    NSDictionary *dataDic = responseArr[i];
                    NSMutableArray *dataArr = [NSMutableArray array];
                    for (NSDictionary *deviceDic in dataDic[@"device"]) {
                        MyDeviceModel *model = [MyDeviceModel yy_modelWithDictionary: deviceDic];
                        [dataArr addObject: model];
                    }
                    [weakSelf.dataArr addObject: dataArr];
                    [weakSelf.groupNameArr addObject: dataDic[@"groupName"]];
                    [weakSelf.groupIDArr addObject: dataDic[@"groupId"]];
                    [sectionStatusArr addObject: @0];
                }
                NSMutableArray *noGroupArr = [NSMutableArray array];
                NSDictionary *noGroupDic = responseArr[responseArr.count - 2];
                for (NSDictionary *deviceDic in noGroupDic[@"noGroup"]) {
                    MyDeviceModel *model = [MyDeviceModel yy_modelWithDictionary: deviceDic];
                    [noGroupArr addObject: model];
                }
                [weakSelf.dataArr insertObject:noGroupArr atIndex: 0 ];
                [weakSelf.groupNameArr insertObject:Localized(@"默认分组") atIndex: 0];
                [weakSelf.groupIDArr insertObject: @9999999 atIndex: 0];
                [sectionStatusArr addObject: @0];
                [weakSelf.tableView reloadData];
            }
            
        }else {
            
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -tableview
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceTableViewCell *cell = (DeviceTableViewCell *)[tableView cellForRowAtIndexPath: indexPath];
    if (cell.isEdit == YES) {
        [cell hideDeleteBtn];
    }else {
        MyDeviceDetailViewController *detailVC = [[MyDeviceDetailViewController alloc] init];
        detailVC.model = self.dataArr[indexPath.section][indexPath.row];
        detailVC.groupName = self.groupNameArr[indexPath.section];
        detailVC.groupNameArray = self.groupNameArr;
        detailVC.groupIdArray = self.groupIDArr;
        [self.navigationController pushViewController: detailVC animated: YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int flag = [sectionStatusArr[section] intValue];
    if (flag == 0) {
        return 0;
    }
    NSArray *arr = self.dataArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"MyDeviceIndentify";
    static NSString *cellIndentifyLast = @"MyDeviceIndentifyLast";
    DeviceTableViewCell *cell = nil;
    NSInteger numNumOfRow = [tableView numberOfRowsInSection: indexPath.section];
    if (numNumOfRow == indexPath.row + 1) {
        cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifyLast];
        if (cell == nil) {
            cell = [[DeviceTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: cellIndentifyLast];
        }
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
        if (cell == nil) {
            cell = [[DeviceTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: cellIndentify];
        }
    }
    __weak typeof(self) weakSelf = self;
    [cell addLeftSwipeGesture];
    cell.indexPath = indexPath;
    [cell hideDeleteBtn];
    [cell setDeleteBtnClick:^(NSIndexPath *indexPathCurrent) {
        [weakSelf deleteDevice: weakSelf.dataArr[indexPathCurrent.section][indexPathCurrent.row]];
    }];
    if (self.dataArr.count > indexPath.row) {
        MyDeviceModel *model = self.dataArr[indexPath.section][indexPath.row];
        cell.deviceInfoModel = model;
    }
    return cell;
}
#pragma mark -- 删除设备-重置设备
- (void)deleteDevice:(MyDeviceModel *)model
{
    [self deleteDeviceReal:model];
//    __weak __typeof__(self) weakSelf = self;
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
//    dic[@"dno"] = model.dno;
//    [MBProgressHUD showHUDIcon:self.view animated:YES];
//    kWeakSelf(self);
//    [[NetWorkingManager shared]postWithUrl:@"devParamController/resetDevice" params: dic succeed:^(id response,BOOL isSucceed) {
//        kStrongSelf(self);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (isSucceed) {
//            //[weakSelf requestDataWithHud: nil];
//            if ([response[@"status"]integerValue] == 602) {
//                [HUD showHUDWithText:[Utils getSafeString:Localized(@"设备不在线")] withDelay:2.0];
//            } else if ([response[@"status"] integerValue] == 0) {
//                [weakSelf deleteDeviceReal:model];
//            }
//        }else {
//        }
//    } failed:^(NSError *error) {
//        kStrongSelf(self);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
}
#pragma mark -- 删除设备-删除设备数据
- (void)deleteDeviceReal:(MyDeviceModel *)model
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = model.dno;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"personController/delDev" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [weakSelf requestDataWithHud: nil];
            // 删除设备后，删除缓存的设备信息
            [CBCommonTools deleteCBDeviceInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_TabBarColorChangeNotification object:nil];
        }else {
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50 * KFitHeightRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 63 * KFitHeightRate;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DeviceHeaderView *headerView = [[DeviceHeaderView alloc] init];
    headerView.section = section;
    int flag = [sectionStatusArr[section] intValue];
    if (flag == 0) {
        headerView.arrowImageBtn.selected = NO;
    }else {
        headerView.arrowImageBtn.selected = YES;
    }
    headerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 50 * KFitHeightRate);
    __weak __typeof__(self) weakSelf = self;
    headerView.headerBtnClick = ^(NSInteger section) {
        [weakSelf reloadTableSectionAtIndex: section];
    };
    NSArray *arraySectionAccount = self.dataArr[section];
    headerView.titleLabel.text = [NSString stringWithFormat:@"%@(%ld)",self.groupNameArr[section],arraySectionAccount.count];//self.groupNameArr[section];
    return headerView;
}

- (void)reloadTableSectionAtIndex:(NSInteger) section
{
    int flag = [sectionStatusArr[section] intValue];
    if (flag == 0) {
        [sectionStatusArr setObject: @1 atIndexedSubscript: section];
    }else {
        [sectionStatusArr setObject: @0 atIndexedSubscript: section];
    }
    //[self.tableView reloadSections: [NSIndexSet indexSetWithIndex: section] withRowAnimation: UITableViewRowAnimationNone];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceTableViewCell *deviceCell = (DeviceTableViewCell *)cell;
    if (deviceCell.isCreate == NO) {
        CGFloat cornerRadius = 5.f * KFitHeightRate;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectMake(0, 0, SCREEN_HEIGHT - 25 * KFitWidthRate, 50 * KFitHeightRate);
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) { // 最后一个
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds) -1, CGRectGetMaxY(bounds), CGRectGetMaxX(bounds) -1, CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds) -1, CGRectGetMinY(bounds));
        }else { // 中间的view
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathMoveToPoint(pathRef, nil, CGRectGetMaxX(bounds) -1, CGRectGetMaxY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds) -1, CGRectGetMinY(bounds));
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = kCellBackColor.CGColor;
        layer.strokeColor = kRGB(210, 210, 210).CGColor;
        
        [deviceCell.backView.layer insertSublayer: layer atIndex: 0];
        layer.strokeColor = kRGB(210, 210, 210).CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        deviceCell.isCreate = YES;
    }
}

#pragma mark - Action
- (void)addDeviceName {
    AddDeviceViewController *addDeviceController = [[AddDeviceViewController alloc] init];
    addDeviceController.groupNameArray = self.groupNameArr;
    addDeviceController.groupIdArray = self.groupIDArr;
    [self.navigationController pushViewController: addDeviceController animated:YES];
}

- (void)longPressGRClick:(UILongPressGestureRecognizer *)lpGR
{
    if(lpGR.state == UIGestureRecognizerStateBegan){
        CGPoint point = [lpGR locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        if(indexPath != nil){
            self.longPressIndexPath = indexPath;
            MINPickerView *pickerView = [[MINPickerView alloc] init];
            pickerView.titleLabel.text = @"";
            pickerView.dataArr = @[self.groupNameArr];
            pickerView.delegate = self;
            [self.view addSubview: pickerView];
            [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self.view);
                make.height.mas_equalTo(SCREEN_HEIGHT);
            }];
            [pickerView showView];
        }
    }
}
#pragma mark - MINPickerViewDelegate
- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic
{
    NSLog(@"%@", dic);
    // 取出选中的行，因为只有一列，所以直接暴力取出了
    NSNumber *selectRow = dic[@"0"];
    //NSMutableArray *selectSectionDataArr = self.dataArr[[selectRow integerValue]];
    NSMutableArray *longPressSectionDataArr =  self.dataArr[self.longPressIndexPath.section];
    MyDeviceModel *longPressCellModel = longPressSectionDataArr[self.longPressIndexPath.row];
    if ([selectRow integerValue] != self.longPressIndexPath.section) {
        [self moveGroupWithSection: [selectRow integerValue] device: longPressCellModel];
    }
}
#pragma mark -- 移动设备分组
- (void)moveGroupWithSection:(NSInteger) section device:(MyDeviceModel *)model
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([self.groupIDArr[section] intValue] == 9999999) {
        dic[@"gid"] = @"0";
    }else {
        dic[@"gid"] = self.groupIDArr[section];
    }
    dic[@"dno"] = model.dno;
    NSLog(@"移到的段落:%@", @(section));
    NSLog(@"移到的段落id组:%@", self.groupIDArr);
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"personController/moveDevGroup" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [weakSelf requestDataWithHud: nil];
        }else {
            //[hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        //[hud hideAnimated:YES];
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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
