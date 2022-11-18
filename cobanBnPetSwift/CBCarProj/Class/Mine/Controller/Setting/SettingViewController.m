//
//  SettingViewController.m
//  Telematics
//
//  Created by lym on 2017/10/25.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "SettingViewController.h"
#import "MineTableViewCell.h"
#import "ChangePassViewController.h"
#import "ConnextCustomerService.h"
#import "ChangeLanguageViewController.h"
#import "AboutUsViewController.h"
#import "cobanBnPetSwift-Swift.h"

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *dataArrs;
@property (nonatomic, strong) UIButton *loginOutBtn;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self addAction];
}

#pragma mark - CrateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"设置") isBack: YES];
    [self createTableView];
    [self showBackGround];
    self.dataArrs = @[Localized(@"修改密码"), Localized(@"关于我们"), Localized(@"联系客服")];//@"更换语言"
    self.loginOutBtn = [MINUtils createBtnWithRadius:20 * KFitHeightRate title: Localized(@"退出登录")];
    [self.view addSubview: self.loginOutBtn];
    [self.loginOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15 * KFitWidthRate);
        make.right.equalTo(self.view).with.offset(-15 * KFitWidthRate);
        make.height.mas_equalTo(45 * KFitHeightRate);
        make.bottom.equalTo(self.view).with.offset(-45 * KFitHeightRate);
    }];
}

- (void)createTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-150 * KFitHeightRate);
    }];
}

#pragma mark - tableview delegate & datasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) { // 修改密码
        CBPetUpdatePwdViewController *changePass = [[CBPetUpdatePwdViewController alloc] init];
        [self.navigationController pushViewController: changePass animated: YES];
    }else if(indexPath.row == 1){ // 关于我们
        AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController: aboutUsVC animated: YES];
    }else if(indexPath.row == 2){ // 联系客服
//        ConnextCustomerService *connectV = [[ConnextCustomerService alloc] init];
//        [self.view addSubview: connectV];
//        [connectV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self.view);
//            make.height.mas_equalTo(SCREEN_HEIGHT);
//        }];
        // 拨打电话
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-2938-9980"];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
                //
            }];
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
        }
    }else if(indexPath.row == 3){ // 更换语言
        ChangeLanguageViewController *changeLanguage = [[ChangeLanguageViewController alloc] init];
        [self.navigationController  pushViewController: changeLanguage animated: YES];
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

#pragma mark - addAction
- (void)addAction
{
    [self.loginOutBtn addTarget:self action: @selector(loginOutBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)loginOutBtnClick {
    // 退出登录提醒
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:Localized(@"是否退出登录") preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self logoutAction];
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}
- (void)logoutAction {
    CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
    userModel.token = nil;
    [CBPetLoginModelTool saveUser:userModel];
    
    [CBCommonTools deleteCBDeviceInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"K_SwitchLoginViewController" object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)dealloc {
    NSLog(@"======SettingViewController");
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
