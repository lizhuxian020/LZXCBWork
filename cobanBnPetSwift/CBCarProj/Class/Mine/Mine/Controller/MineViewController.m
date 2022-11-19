//
//  MineViewController.m
//  Telematics
//
//  Created by lym on 2017/10/25.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "SettingViewController.h"
#import "MyDeviceViewController.h"
#import "GroupManagerViewController.h"
#import "SubAccountManagerViewController.h"
#import "AlamSettingViewController.h"
#import "cobanBnPetSwift-Swift.h"
#import "CBCBCarMineHeaderView.h"
#import "CBHomeLeftMenuView.h"

@interface MineViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *dataArrs;

@property (nonatomic, strong) CBCBCarMineHeaderView *headerView;
@property (nonatomic, strong) UIScrollView *containerView;

@property (nonatomic, strong) NSMutableArray<UIView *> *contentViewArr;
@property (nonatomic, strong) CBHomeLeftMenuView *deviceView;
/** 菜单数据源  */
@property (nonatomic, strong) NSMutableArray *slider_array;

@property (nonatomic, strong) UIView *groupView;
@property (nonatomic, strong) UIView *subAcccountView;
@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

#pragma mark - CrateUI
- (void)createUI
{
    self.contentViewArr = [NSMutableArray new];
//    [self initBarWithTitle:Localized(@"我的") isBack: NO];
    [self createHeader];
    [self createContent];
//    [self initBarRightImageName: @"设置-顶栏" target: self action: @selector(rightBtnClick)];
//    [self createTableView];
//    self.dataArrs = @[Localized(@"设备管理"), Localized(@"分组管理"), Localized(@"子账户管理")];//Localized(@"报警消息设置")
}

- (void)createHeader {
    self.headerView = [CBCBCarMineHeaderView new];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kStatusBarHeight));
        make.left.right.equalTo(@0);
        make.height.equalTo(@40);
    }];
    kWeakSelf(self)
    [self.headerView setDidClickTitle:^(int index) {
        kStrongSelf(self);
        [self.containerView setContentOffset:CGPointMake(self.view.width * index, 0) animated:YES];
    }];
}

- (void)createContent {
    self.containerView = [UIScrollView new];
    [self.view addSubview:self.containerView];
    self.containerView.backgroundColor = UIColor.redColor;
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.equalTo(@0);
    }];
    self.containerView.pagingEnabled = YES;
    self.containerView.bounces = NO;
    self.containerView.delegate = self;
    
    self.deviceView = [[CBHomeLeftMenuView alloc] initWithFrame:CGRectZero withSlideArray:self.slider_array index:0];
    [self.containerView addSubview:self.deviceView];
    [self.deviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0);
        make.width.height.equalTo(self.containerView);
    }];
    [self.deviceView requestData];
    
    self.groupView = UIView.new;
    self.groupView.backgroundColor = UIColor.redColor;
    [self.containerView addSubview:self.groupView];
    [self.groupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deviceView.mas_right);
        make.top.width.height.equalTo(self.deviceView);
    }];
    
    self.subAcccountView = [UIView new];
    self.subAcccountView.backgroundColor = UIColor.blueColor;
    [self.containerView addSubview:self.subAcccountView];
    [self.subAcccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.groupView.mas_right);
        make.top.width.height.equalTo(self.deviceView);
    }];
    
    self.containerView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
}

- (void)createTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

- (NSMutableArray *)slider_array {
    if (!_slider_array) {
        _slider_array = [NSMutableArray array];
        NSArray *arrayTitle = @[Localized(@"全部"),Localized(@"在线"),Localized(@"离线")];
        NSArray *arrayStatus = @[@"",@"1",@"0"];
        for (int i = 0 ; i < arrayTitle.count ; i ++ ) {
            CBHomeLeftMenuSliderModel *model = [[CBHomeLeftMenuSliderModel alloc]init];
            model.title = arrayTitle[i];
            model.status = arrayStatus[i];
            [_slider_array addObject:model];
        }
    }
    return _slider_array;
}

#pragma mark --ScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    int index = [NSString stringWithFormat:@"%.2f",scrollView.contentOffset.x/SCREEN_WIDTH].floatValue;
    [self.headerView didMoveToIndex:index];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark - tableview delegate & datasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
    // 0为查看权限
    if ([userModel.auth isEqualToString:@"0"]) {
        [HUD showHUDWithText:Localized(@"无权限访问") withDelay:2.0];
        return;
    }
    if (indexPath.row == 0) { // 设备管理
        MyDeviceViewController *myDeviceVC = [[MyDeviceViewController alloc] init];
        myDeviceVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: myDeviceVC animated: YES];
    }else if(indexPath.row == 1){ // 分组管理
        GroupManagerViewController *groupManagerVC = [[GroupManagerViewController alloc] init];
        groupManagerVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: groupManagerVC animated: YES];
    }else if(indexPath.row == 2){ // 子账户管理
        SubAccountManagerViewController *subAccountVC = [[SubAccountManagerViewController alloc] init];
        subAccountVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: subAccountVC animated: YES];
    }else if(indexPath.row == 3){ // 报警消息设置
        AlamSettingViewController *alamSettingVC = [[AlamSettingViewController alloc] init];
        alamSettingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: alamSettingVC animated: YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"mineCellIndentify";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentify];
    if (cell == nil) {
        cell = [[MineTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIdentify];
    }
    cell.nameLabel.text = self.dataArrs[indexPath.row];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.5 * KFitHeightRate;
}

#pragma mark - Action
- (void)rightBtnClick
{
    NSLog(@"rightBtnClick");
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: settingVC animated:YES];
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
