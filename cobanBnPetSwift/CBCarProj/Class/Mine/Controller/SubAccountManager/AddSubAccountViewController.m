//
//  AddSubAccountViewController.m
//  Telematics
//
//  Created by lym on 2017/11/10.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "AddSubAccountViewController.h"
#import "AddSubAccountTableViewCell.h"
#import "MINAlertView.h"
#import "MINPickerView.h"
#import "PlaceModel.h"
#import "SubAccountModel.h"

@interface AddSubAccountViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSMutableArray *dataArr;
@property (nonatomic, weak) UITextField *textField;
@end

@implementation AddSubAccountViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[IQKeyboardManager sharedManager].enable = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[IQKeyboardManager sharedManager].enable = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self dataArr];
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        NSArray *arrayPlace = @[Localized(@"请输入子用户名"), Localized(@"请输入姓名"), Localized(@"请输入密码"), Localized(@"请再次输入密码"), Localized(@"请输入电话号码"), Localized(@"请输入邮箱")];
        for (int i = 0 ; i < arrayPlace.count ; i ++ ) {
            SubAccountAddModel *model = [[SubAccountAddModel alloc]init];
            model.textPlacehold = arrayPlace[i];
            [_dataArr addObject:model];
        }
    }
    return _dataArr;
}
#pragma mark -- 校对子用户名
- (void)validateAccountRequest {
    SubAccountAddModel *modelChildName = self.dataArr[0];
    if ([modelChildName.textStr isValidAlphaNumberPassword] == NO ) {
        [HUD showHUDWithText:Localized(@"请输入4位以上的字母数字组合") withDelay:2.0f];
        return;
    } else if (modelChildName.textStr.length < 4) {
        [HUD showHUDWithText:Localized(@"请输入4位以上的字母数字组合") withDelay:2.0f];
        return;
    }
   
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:modelChildName.textStr?:@"" forKey:@"account"];
    [[NetWorkingManager shared]postWithUrl:@"userController/valideAccount" params:paramters succeed:^(id response,BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [self rightBtnClick];
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 添加子账号
- (void)rightBtnClick
{
    [self.view endEditing:YES];
    
    SubAccountAddModel *modelChildName = self.dataArr[0];
    SubAccountAddModel *modelName = self.dataArr[1];
    SubAccountAddModel *modelPwd = self.dataArr[2];
    SubAccountAddModel *modelSecondPwd = self.dataArr[3];
    SubAccountAddModel *modelPhone = self.dataArr[4];
    SubAccountAddModel *modelEmail = self.dataArr[5];
    
    if ([modelChildName.textStr isValidAlphaNumberPassword] == NO ) {
        [HUD showHUDWithText:Localized(@"请输入4位以上的字母数字组合用户名") withDelay:2.0f];
        return;
    } else if (modelChildName.textStr.length < 4) {
        [HUD showHUDWithText:Localized(@"请输入4位以上的字母数字组合用户名") withDelay:2.0f];
        return;
    }
    
    if (kStringIsEmpty(modelName.textStr)) { // 子用户姓名
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请输入姓名")];
        return ;
    }
    
    if ([modelPwd.textStr isValidAlphaNumberPassword] == NO ) {
        [HUD showHUDWithText:Localized(@"请输入6位以上的字母数字组合密码") withDelay:2.0f];
        return;
    } else if (modelPwd.textStr.length < 6) {
        [HUD showHUDWithText:Localized(@"请输入6位以上的字母数字组合密码") withDelay:2.0f];
        return;
    }
    
    if (kStringIsEmpty(modelSecondPwd.textStr)) { // 确认密码
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请输入确认密码")];
        return ;
    }else if (kStringIsEmpty(modelPhone.textStr)) { // 电话号码
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请输入电话号码")];
        return ;
    }else if (kStringIsEmpty(modelEmail.textStr)) { // 邮箱
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请输入邮箱")];
        return ;
    }

    else if ([modelPwd.textStr isEqualToString:modelSecondPwd.textStr] == NO ) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"两次输入的密码不相同")];
        return ;
    }
    
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:modelChildName.textStr?:@"" forKey:@"account"];
    [paramters setObject:modelName.textStr?:@"" forKey:@"name"];
    [paramters setObject:modelPwd.textStr?:@"" forKey:@"pwd"];
    [paramters setObject:modelSecondPwd.textStr?:@"" forKey:@"pwdConfirm"];
    [paramters setObject:modelPhone.textStr?:@"" forKey:@"phone"];
    [paramters setObject:modelEmail.textStr?:@"" forKey:@"email"];
    
    __weak __typeof__(self) weakSelf = self;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[NetWorkingManager shared]postWithUrl:@"personController/addSubUser" params:paramters succeed:^(id response,BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSLog(@"添加子账号%@",response);
        if (isSucceed) {
            [weakSelf.navigationController popViewControllerAnimated: YES];
        } else {
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"填写信息") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"完成") target: self action: @selector(validateAccountRequest)];
    [self createTableView];
}

- (void)createTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}
#pragma mark - tableview delegate & datasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"AddSubAccountIndentify";
    AddSubAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
    if (cell == nil) {
        cell = [[AddSubAccountTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIndentify ];
    }
    if (self.dataArr.count > indexPath.row) {
        SubAccountAddModel *model = self.dataArr[indexPath.row];
        cell.accountModel = model;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.5 * KFitHeightRate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
