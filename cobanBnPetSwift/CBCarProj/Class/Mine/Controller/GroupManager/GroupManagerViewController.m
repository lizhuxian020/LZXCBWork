//
//  GroupManagerViewController.m
//  Telematics
//
//  Created by lym on 2017/11/1.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "GroupManagerViewController.h"
#import "DeviceTableViewCell.h"
#import "DeviceHeaderView.h"
#import "MINPickerView.h"
#import "MINAlertView.h"
#import "MyDeviceModel.h"
//#import "DeviceHeaderFooterView.h"
#import "CBControlInputPopView.h"

@interface GroupManagerViewController ()<UITableViewDelegate, UITableViewDataSource, MINPickerViewDelegate,CBControlInputPopViewDelegate>
{
    NSMutableArray *sectionStatusArr;
}
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *groupNameArr;
@property (nonatomic, strong) NSMutableArray *groupIDArr;
@property (nonatomic, strong) NSIndexPath *longPressIndexPath;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) DeviceHeaderView *deleteHeaderView;

/** 添加分组、编辑分组，输入值弹窗 */
@property (nonatomic,strong) CBControlInputPopView *inputPopView;
@property (nonatomic,strong) DeviceHeaderView *selectHeaderView;
@end

@implementation GroupManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self addGesture];
    sectionStatusArr = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    self.groupNameArr = [NSMutableArray array];
    self.groupIDArr = [NSMutableArray array];
    [self requestDataWithHud:nil];
}
- (CBControlInputPopView *)inputPopView {
    if (!_inputPopView) {
        _inputPopView = [[CBControlInputPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _inputPopView.delegate = self;
    }
    return _inputPopView;
}
#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"分组管理") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"添加") target: self action: @selector(createGroupClick)];
    [self showBackGround];
    [self createTableView];
}

#pragma mark - gesture
- (void)addGesture
{
    // 添加手势
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(longPressGRClick:)];
    longPressGR.minimumPressDuration = 0.6f;
    [self.tableView addGestureRecognizer: longPressGR];
    //    UISwipeGestureRecognizer *leftSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(leftSwipeGR:)];
    //    [leftSwipeGR setDirection: UISwipeGestureRecognizerDirectionLeft];
    //    [self.tableView addGestureRecognizer: leftSwipeGR];
    UITapGestureRecognizer *hideGR = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(hideGRClick:)];
    [self.tableView addGestureRecognizer: hideGR];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
- (void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.textField resignFirstResponder];
}
- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = kBackColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.view);
    }];
    kWeakSelf(self);
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [weakself requestDataWithHud:nil];
    }];
    
}
#pragma mark -- 获取设备列表
- (void)requestDataWithHud:(MBProgressHUD *)hud
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    if (hud == nil) {
        //hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    }
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"personController/getMyDeviceList" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.header endRefreshing];
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
            //[hud hideAnimated:YES];
        }else {
            //[hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        //[hud hideAnimated:YES];
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.header endRefreshing];
    }];
}
#pragma mark -tableview
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
    if ([self.dataArr[indexPath.section] count] > indexPath.row) {
        MyDeviceModel *model = self.dataArr[indexPath.section][indexPath.row];
        cell.deviceInfoModel = model;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return UIView.new;
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
    //headerView.titleLabel.text = self.groupNameArr[section];
    NSArray *arraySectionAccount = self.dataArr[section];
    headerView.titleLabel.text = [NSString stringWithFormat:@"%@(%ld)",self.groupNameArr[section],arraySectionAccount.count];//self.groupNameArr[section];
    headerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 50 * KFitHeightRate);
    __weak __typeof__(self) weakSelf = self;
    headerView.headerBtnClick = ^(NSInteger section) {
        [weakSelf reloadTableSectionAtIndex: section];
    };
    if (section != 0) {
        [headerView addLeftGesture];
        [self.scrollGesture requireGestureRecognizerToFail:headerView.gesture];
        headerView.headerLongPressGesture = ^(NSInteger section, DeviceHeaderView *headView) {
            weakSelf.selectHeaderView = headView;
            [weakSelf editGroupClick];
        };
        headerView.deleteBtnClick = ^(NSInteger section) {
            NSMutableArray *sectionArr = weakSelf.dataArr[section];
            if (sectionArr.count > 0) {
                [MINUtils showProgressHudToView: weakSelf.view withText:Localized(@"请先将设备移到其他分组或删除分组设备")];
            }else {
                [[CBCarAlertView viewWithAlertTips:Localized(@"确认删除?") title:Localized(@"提示") confrim:^(NSString * _Nonnull contentStr) {
                    [weakSelf deleteGroupWithSection: section];
                }] pop];
            }
        };
        [headerView setEditBtnClick:^(NSInteger section, DeviceHeaderView *headView) {
            weakSelf.selectHeaderView = headView;
            [weakSelf editGroupClick];
        }];
        headerView.leftSwipeClick = ^(DeviceHeaderView *headView) {
            __weak DeviceHeaderView *weakHeadView = headView;
//            if (weakSelf.deleteHeaderView != nil) { // 先收回之前的head的删除按钮
//                [weakSelf.deleteHeaderView hideDeleteBtn];
//            }else {
//                [weakSelf.deleteHeaderView showDeleteBtn];
//            }
            weakSelf.deleteHeaderView = weakHeadView;
        };
        [headerView hideDeleteBtn];
    } else {
        //[HUD showHUDWithText:Localized(@"不能对默认分组进行编辑操作") withDelay:3.0f];
    }
    return headerView;
}
#pragma mark -- 删除分组
- (void)deleteGroupWithSection:(NSInteger) section
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"gid"] = self.groupIDArr[section];
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[NetWorkingManager shared]postWithUrl:@"personController/delDevGroup" params: dic succeed:^(id response,BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [weakSelf requestDataWithHud: nil];
        }else {
            //[hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        //[hud hideAnimated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 编辑分组
- (void)editGroupClick {
    kWeakSelf(self);
    [[CBCarAlertView viewWithMultiInput:@[Localized(@"请输入组名")] title:Localized(@"分组管理") confirmCanDismiss:nil confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
        // 分组管理
        [weakself editGroupNameRequestWithName:contentStr.firstObject section:weakself.selectHeaderView.section];
    }] pop];
}
- (void)editGroupNameRequestWithName:(NSString *)groupName section:(NSInteger)section
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"gname"] = groupName;
    dic[@"gid"] = self.groupIDArr[section];
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[NetWorkingManager shared]postWithUrl:@"personController/editDevGroup" params: dic succeed:^(id response,BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (isSucceed) {
            [weakSelf requestDataWithHud: nil];
            [CBTopAlertView alertSuccess:Localized(@"操作成功")];
        }else {
            //[hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        //[hud hideAnimated:YES];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

- (void)reloadTableSectionAtIndex:(NSInteger) section
{
    int flag = [sectionStatusArr[section] intValue];
    if (flag == 0) {
        [sectionStatusArr setObject: @1 atIndexedSubscript: section];
    }else {
        [sectionStatusArr setObject: @0 atIndexedSubscript: section];
    }
//    //刷新当前的分组
//    NSIndexSet * set = [[NSIndexSet alloc] initWithIndex: section];
//    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    DeviceTableViewCell *deviceCell = (DeviceTableViewCell *)cell;
//    if (deviceCell.isCreate == NO) {
//        CGFloat cornerRadius = 5.f * KFitHeightRate;
//        cell.backgroundColor = UIColor.clearColor;
//        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//        CGMutablePathRef pathRef = CGPathCreateMutable();
//        CGRect bounds = CGRectMake(0, 0, SCREEN_HEIGHT - 25 * KFitWidthRate, 50 * KFitHeightRate);
//        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) { // 最后一个
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds) - 1, CGRectGetMaxY(bounds), CGRectGetMaxX(bounds) -1, CGRectGetMidY(bounds), cornerRadius);
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds)-1, CGRectGetMinY(bounds));
//        }else { // 中间的view
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMaxX(bounds)-1, CGRectGetMaxY(bounds));
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds)-1, CGRectGetMinY(bounds));
//        }
//        layer.path = pathRef;
//        CFRelease(pathRef);
//        //颜色修改
//        layer.fillColor = kCellBackColor.CGColor;
//        layer.strokeColor = kRGB(210, 210, 210).CGColor;
//
//        [deviceCell.backView.layer insertSublayer: layer atIndex: 0];
//        layer.strokeColor = kRGB(210, 210, 210).CGColor;
//        layer.fillColor = [UIColor clearColor].CGColor;
//        deviceCell.isCreate = YES;
//    }
//}

#pragma mark -- 添加分组
- (void)createGroupClick
{
    kWeakSelf(self);
    [[CBCarAlertView viewWithMultiInput:@[Localized(@"长度不能超过6")] title:Localized(@"请输入组名") confirmCanDismiss:nil confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
        // 添加分组
        [weakself addGroupRequestWithGroupName:contentStr.firstObject];
    }] pop];
}
- (void)addGroupRequestWithGroupName:(NSString *)groupName
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"gname"] = groupName;
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[NetWorkingManager shared]postWithUrl:@"personController/addDevGroup" params: dic succeed:^(id response,BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (isSucceed) {
            [weakSelf requestDataWithHud: nil];
            [CBTopAlertView alertSuccess:Localized(@"操作成功")];
        }else {
            //[hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        //[hud hideAnimated:YES];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}
#pragma mark -- 输入弹窗代理
- (void)updateTextFieldValue:(NSString *)inputStr returnTitle:(NSString *)title {
    if (kStringIsEmpty(inputStr)) {
        [HUD showHUDWithText:Localized(@"请输入组名") withDelay:3.0];
        return;
    }
    if ([title isEqualToString:Localized(@"请输入组名")]) {
    // 添加分组
        [self addGroupRequestWithGroupName:inputStr];
    } else if ([title isEqualToString:Localized(@"分组管理")]) {
    // 分组管理
        [self editGroupNameRequestWithName:inputStr section:self.selectHeaderView.section];
    }
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
//                make.left.right.top.equalTo(self.view);
//                make.bottom.equalTo(@(-TabBARHEIGHT));
                make.edges.equalTo(@0);
            }];
            [pickerView showView];
        }
    }
}

//- (void)leftSwipeGR:(UISwipeGestureRecognizer *)lsGR
//{
//    if (lsGR.state == UIGestureRecognizerStateEnded) {
//        for (int i = 0; i < sectionStatusArr.count;  i++) {
//            DeviceHeaderFooterView *headerView = (DeviceHeaderFooterView *)[self.tableView headerViewForSection: i];
//            NSLog(@"i = %d, %ld", i, (long)headerView.section);
//        }
//    }
//
//}

- (void)hideGRClick:(UITapGestureRecognizer *)tapGR
{
    [self.deleteHeaderView hideDeleteBtn];
}

#pragma mark - MINPickerViewDelegate
- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic
{
    //NSLog(@"%@", dic);
    // 取出选中的行，因为只有一列，所以直接暴力取出了
    NSNumber *selectRow = dic[@"0"];
    NSMutableArray *selectSectionDataArr = self.dataArr[[selectRow integerValue]];
    NSMutableArray *longPressSectionDataArr =  self.dataArr[self.longPressIndexPath.section];
    MyDeviceModel *longPressCellModel = longPressSectionDataArr[self.longPressIndexPath.row];
    if ([selectRow integerValue] != self.longPressIndexPath.section) {
        [self moveGroupWithSection: [selectRow integerValue] device: longPressCellModel];
    }
}
#pragma mark -- 移动分组
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
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[NetWorkingManager shared]postWithUrl:@"personController/moveDevGroup" params: dic succeed:^(id response,BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (isSucceed) {
            [weakSelf requestDataWithHud: nil];
            [CBTopAlertView alertSuccess:Localized(@"操作成功")];
        }else {
            //[hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        //[hud hideAnimated:YES];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
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
