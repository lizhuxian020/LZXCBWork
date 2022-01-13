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

@interface MineViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *dataArrs;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

#pragma mark - CrateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"我的") isBack: NO];
    [self initBarRightImageName: @"设置-顶栏" target: self action: @selector(rightBtnClick)];
    [self createTableView];
    self.dataArrs = @[Localized(@"设备管理"), Localized(@"分组管理"), Localized(@"子账户管理")];//Localized(@"报警消息设置")
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
