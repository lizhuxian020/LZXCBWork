//
//  SubAccountManagerViewController.m
//  Telematics
//
//  Created by lym on 2017/11/10.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "SubAccountManagerViewController.h"
#import "SubAccountTableViewCell.h"
#import "MINAlertView.h"
#import "AddSubAccountViewController.h"
#import "SubAccountModel.h"
#import "CBManagerAccountPopView.h"
#import "CBSubAccountDetailController.h"

@interface SubAccountManagerViewController () <UITableViewDelegate, UITableViewDataSource,CBManagerAccountPopViewDelegate>
{
    UIButton *leftSelectBtn;
    UIButton *rightSelectBtn;
}
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic,strong) CBManagerAccountPopView *accountPopView;
@property (nonatomic,strong) NSMutableArray *arraySelectAccount;
@property (nonatomic,copy) NSString *authStr;
@end

@implementation SubAccountManagerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self requestDataWithHud: nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
- (CBManagerAccountPopView *)accountPopView {
    if (!_accountPopView) {
        _accountPopView = [[CBManagerAccountPopView alloc] init];
        _accountPopView.delegate = self;
        kWeakSelf(self);
        _accountPopView.popViewBlock = ^(id  _Nonnull objc) {
            kStrongSelf(self);
            self.arraySelectAccount = objc;
            [self setPermission];
        };
    }
    return _accountPopView;
}
#pragma mark -- 获取子账户列表
- (void)requestDataWithHud:(MBProgressHUD *)hud
{
    kWeakSelf(self);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[NetWorkingManager shared]getWithUrl:@"personController/getSubUsers" params: dic succeed:^(id response,BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:weakself.view animated:YES];
        [weakself.tableView.mj_header endRefreshing];
        NSLog(@"====子账户列表%@==",response);
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                [weakself.dataArr removeAllObjects];
                NSArray *array = response[@"data"];
                for (NSDictionary *dic in array) {
                    SubAccountModel *model = [SubAccountModel mj_objectWithKeyValues:dic];//[SubAccountModel yy_modelWithDictionary: dic];
                    [weakself.dataArr addObject: model];
                }
                [hud hideAnimated:YES];
                [weakself.tableView reloadData];
            }
        } else {
            //[hud hideAnimated:YES];
        }
        weakself.noDataView.hidden = weakself.dataArr.count == 0?NO:YES;
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakself.view animated:YES];
        [weakself.tableView.mj_header endRefreshing];
    }];
}
#pragma mark -- 删除子账户
- (void)deleteAccountRequestWithIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof__(self) weakSelf = self;
    SubAccountModel *model = self.dataArr[indexPath.row];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sid"] = model.accountId;
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[NetWorkingManager shared]postWithUrl:@"personController/delSubUser" params: dic succeed:^(id response,BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (isSucceed) {
            [weakSelf requestDataWithHud: nil];
        }else {
            //[hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        //[hud hideAnimated:YES];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}
#pragma mark -- 设置权限
- (void)setPermission
{
    NSMutableArray *arraySelect = [NSMutableArray array];
    for (CBHomeLeftMenuDeviceGroupModel *deviceGoupModel in self.arraySelectAccount) {
        if (deviceGoupModel.noGroup) {
            for (CBHomeLeftMenuDeviceInfoModel *model in deviceGoupModel.noGroup) {
                if (model.isCheck) {
                    [arraySelect addObject:model.ids];
                }
            };
        } else {
            for (CBHomeLeftMenuDeviceInfoModel *model in deviceGoupModel.device) {
                if (model.isCheck) {
                    [arraySelect addObject:model.ids];
                }
            };
        }
    }
    NSString *selectIdStr = [arraySelect componentsJoinedByString:@","];
    NSLog(@"选择的id======%@",arraySelect);

    __weak __typeof__(self) weakSelf = self;
    SubAccountModel *model = self.dataArr[self.indexPath.row];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"sid"] = model.accountId;
    dic[@"deviceIds"] = selectIdStr;//model.accountId;
    dic[@"auth"] = self.authStr?:@"0";//model.auth;
    
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[NetWorkingManager shared] postWithUrl:@"personController/editSubUserAuto" params: dic succeed:^(id response,BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (isSucceed) {
            //[hud hideAnimated:YES];
            [CBTopAlertView alertSuccess:Localized(@"操作成功")];
            [weakSelf requestDataWithHud:nil];
        }else {
            //[hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        //[hud hideAnimated:YES];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"子账户管理") isBack: YES];
    [self initBarRighBtnTitle: Localized(@"添加") target: self action: @selector(rightBtnClick)];
    [self createTableView];
    [self showBackGround];
    self.dataArr = [NSMutableArray array];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = kBackColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    kWeakSelf(self);
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [weakself requestDataWithHud:nil];
    }];
}
#pragma mark -- popView  delegate
- (void)accountPopViewClickType:(NSInteger)index {
    switch (index) {
        case 0:
            self.authStr = @"0";
            break;
        case 1:
            self.authStr = @"1";
            break;
        default:
            break;
    }
}
#pragma mark - TableView delegate & datasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubAccountTableViewCell *cell = (SubAccountTableViewCell *)[tableView cellForRowAtIndexPath: indexPath];
    if (cell.isEdit == YES) {
        [cell hideDeleteBtn];
    }else {
        CBSubAccountDetailController *vc = [CBSubAccountDetailController new];
        SubAccountModel *model = self.dataArr[indexPath.row];
        vc.accountModel = model;
        [self.navigationController pushViewController:vc animated:YES];
//        self.indexPath = indexPath;
//        if (self.dataArr.count > indexPath.row) {
//            SubAccountModel *model = self.dataArr[indexPath.row];
//            [self.accountPopView popView:model];
//        }
        //[self showAlertView];
        //[self.accountPopView popView];
    }
}

- (void)showAlertView
{
    MINAlertView *alertView = [[MINAlertView alloc] init];
    [self.view addSubview: alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    alertView.titleLabel.text = Localized(@"权限设置");
    [alertView.leftBottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
    }];
    [alertView setContentViewHeight:90];
    
    //alertView.contentView.backgroundColor = UIColor.redColor;
    leftSelectBtn = [[UIButton alloc] init];
    leftSelectBtn.selected = YES;
    [leftSelectBtn setImage: [UIImage imageNamed:@"单选-选中"] forState: UIControlStateSelected];
    [leftSelectBtn setImage: [UIImage imageNamed:@"单选-没选中"] forState: UIControlStateNormal];
    [leftSelectBtn setImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 10 * KFitWidthRate)];
    [leftSelectBtn setTitleEdgeInsets: UIEdgeInsetsMake(0, 10 * KFitWidthRate, 0, 0)];
    [leftSelectBtn setTitle: Localized(@"查看") forState: UIControlStateNormal];
    [leftSelectBtn setTitle: Localized(@"查看") forState: UIControlStateSelected];
    [leftSelectBtn setTitleColor:kRGB(137, 137, 137) forState: UIControlStateNormal];
    [leftSelectBtn setTitleColor:kRGB(137, 137, 137) forState: UIControlStateSelected];
    leftSelectBtn.titleLabel.font = [UIFont systemFontOfSize:12 * KFitHeightRate];
    [alertView.contentView addSubview: leftSelectBtn];
    [leftSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerY.equalTo(alertView.contentView);
        make.top.mas_equalTo(alertView.contentView.mas_top).offset(15);
        make.left.equalTo(alertView.contentView).with.offset(45 * KFitWidthRate);
        make.width.mas_equalTo(75 * KFitWidthRate);
        make.height.mas_equalTo(40 * KFitHeightRate);
    }];
    rightSelectBtn = [[UIButton alloc] init];
    [rightSelectBtn setImage: [UIImage imageNamed:@"单选-选中"] forState: UIControlStateSelected];
    [rightSelectBtn setImage: [UIImage imageNamed:@"单选-没选中"] forState: UIControlStateNormal];
    [rightSelectBtn setTitle: Localized(@"控制") forState: UIControlStateNormal];
    [rightSelectBtn setTitle: Localized(@"控制") forState: UIControlStateSelected];
    [rightSelectBtn setImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 10 * KFitWidthRate)];
    [rightSelectBtn setTitleEdgeInsets: UIEdgeInsetsMake(0, 10 * KFitWidthRate, 0, 0)];
    [rightSelectBtn setTitleColor:kRGB(137, 137, 137) forState: UIControlStateNormal];
    [rightSelectBtn setTitleColor:kRGB(137, 137, 137) forState: UIControlStateSelected];
    rightSelectBtn.titleLabel.font = [UIFont systemFontOfSize:12 * KFitHeightRate];
    [alertView.contentView addSubview: rightSelectBtn];
    [rightSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerY.equalTo(alertView.contentView);
        make.top.mas_equalTo(alertView.contentView.mas_top).offset(15);
        make.right.equalTo(alertView.contentView).with.offset(-45 * KFitWidthRate);
        make.width.mas_equalTo(75 * KFitWidthRate);
        make.height.mas_equalTo(40 * KFitHeightRate);
    }];
    if (self.dataArr.count > self.indexPath.row) {
        SubAccountModel *model = self.dataArr[self.indexPath.row];
        if ([model.auth isEqualToString: @"0"] == YES) { // 查看
            leftSelectBtn.selected = YES;
            rightSelectBtn.selected = NO;
        }else { // 控制
            leftSelectBtn.selected = NO;
            rightSelectBtn.selected = YES;
        }
    }
    [leftSelectBtn addTarget: self action: @selector(alertSelectBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [rightSelectBtn addTarget: self action: @selector(alertSelectBtnClick:) forControlEvents: UIControlEventTouchUpInside];
//    SubAccountTableViewCell *cell = [self.tableView cellForRowAtIndexPath: self.indexPath];
    __weak MINAlertView *weakAlertView = alertView;
    __weak __typeof__(self) weakSelf = self;
    alertView.rightBtnClick = ^{
        //改变权限的地方
        [weakSelf setPermission];
        [weakAlertView hideView];
    };
    
}

- (void)alertSelectBtnClick:(UIButton *)sender
{
    SubAccountModel *model = self.dataArr[self.indexPath.row];
    if (sender == leftSelectBtn) {
        leftSelectBtn.selected = YES;
        rightSelectBtn.selected = NO;
        model.auth = @"0";
    }else {
        leftSelectBtn.selected = NO;
        rightSelectBtn.selected = YES;
        model.auth = @"1";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"SubAccountIndentify";
    SubAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
    if (cell == nil) {
        cell = [[SubAccountTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIndentify];
    }
    [cell addLeftSwipeGesture];
    [cell.swipeGestures enumerateObjectsUsingBlock:^(UISwipeGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.scrollGesture requireGestureRecognizerToFail:obj];
    }];
//    [cell setAccountName: @"123123" name: @"MIN" pass: @"123321123"];
    cell.indexPath = indexPath;
    [cell hideDeleteBtn];
    __weak typeof(self) weakSelf = self;
    [cell setDeleteBtnClick:^(NSIndexPath *indexPath) {
        weakSelf.indexPath = indexPath;
        [weakSelf deleteAccountRequestWithIndexPath: indexPath];
    }];
    [cell setEditBtnClick:^(NSIndexPath *indexPath) {
        weakSelf.indexPath = indexPath;
        if (weakSelf.dataArr.count > indexPath.row) {
            SubAccountModel *model = weakSelf.dataArr[indexPath.row];
            [weakSelf.accountPopView popView:model];
            
            [[CBCarAlertView viewWithSubAccountAuthConfig:weakSelf.accountPopView confrim:^(NSString * _Nonnull contentStr) {
                [weakSelf.accountPopView certain];
            }] pop];
        }
    }];
    if (self.dataArr.count > indexPath.row) {
        SubAccountModel *model = self.dataArr[indexPath.row];
        cell.accountLabel.text = model.account;
        cell.nameLabel.text = model.name;
        //cell.passLabel.text = model.password;
        if ([model.auth isEqualToString:@"0"]) {
            cell.permissionLab.text = Localized(@"查看");
        } else if ([model.auth isEqualToString:@"1"]) {
            cell.permissionLab.text = Localized(@"控制");
        } else {
            cell.permissionLab.text = Localized(@"查看");//@"未知";
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50 * KFitHeightRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50 * KFitHeightRate;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 50 * KFitWidthRate)];
    view.backgroundColor = kRGB(240, 240, 240);
    UIColor *labelColor = kRGB(73, 73, 73);
    UILabel *accountLabel = [MINUtils createLabelWithText: Localized(@"账号") size: 12 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: labelColor];
    [view addSubview: accountLabel];
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
//        make.width.mas_equalTo(100 * KFitWidthRate);
//        make.centerX.mas_equalTo(view.mas_centerX).offset(-SCREEN_WIDTH/4);
        make.left.equalTo(@0);
//        make.width.equalTo(view).dividedBy(3);
    }];
    UILabel *nameLabel = [MINUtils createLabelWithText: Localized(@"名称") size: 12 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: labelColor];
    [view addSubview: nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        //make.left.equalTo(accountLabel.mas_right);
//        make.centerX.mas_equalTo(view.mas_centerX);
//        make.width.mas_equalTo(75 * KFitWidthRate);
        make.left.equalTo(accountLabel.mas_right);
        make.width.equalTo(accountLabel);
    }];
//    UILabel *passLabel = [MINUtils createLabelWithText: Localized(@"密码") size: 12 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: labelColor];
//    [view addSubview: passLabel];
//    [passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(view);
//        make.left.equalTo(nameLabel.mas_right);
//        make.width.mas_equalTo(114 * KFitWidthRate);
//    }];
    UILabel *permissionLabel = [MINUtils createLabelWithText:Localized(@"权限") size: 12 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: labelColor];
    [view addSubview: permissionLabel];
    [permissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(view);
        //make.left.equalTo(passLabel.mas_right);
//        make.centerX.mas_equalTo(view.mas_centerX).offset(SCREEN_WIDTH/4);
        make.left.equalTo(nameLabel.mas_right);
        make.width.equalTo(nameLabel);
    }];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_HEIGHT, 1)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - Action
- (void)rightBtnClick
{
//    AddSubAccountViewController *addAcountVC = [[AddSubAccountViewController alloc] init];
//    [self.navigationController pushViewController: addAcountVC animated: YES];
    kWeakSelf(self);
    [[CBCarAlertView viewWithMultiInput:@[
            Localized(@"请输入子用户名"), Localized(@"请输入姓名"), Localized(@"请输入密码"), Localized(@"请再次输入密码"), Localized(@"请输入电话号码")
    ] title:Localized(@"添加子用户") isDigitalBlk:^BOOL(int index) {
        return index == 4;
    } maxLengthBlk:^int(int index) {
        return 11;
    } securityBLk:^BOOL(int index) {
        return index == 2 || index == 3;
    } confirmCanDismiss:^(NSArray<NSString *> *contentStr){
        NSString *accountName = contentStr[0];
        NSString *name = contentStr[1];
        NSString *pwd1 = contentStr[2];
        NSString *pwd2 = contentStr[3];
        NSString *phone = contentStr[4];
        
        if ([accountName isValidAlphaNumberPassword4] == NO ) {
            [HUD showHUDWithText:Localized(@"请输入4位以上的字母数字组合用户名") withDelay:2.0f];
            return NO;
        } else if (accountName.length < 4) {
            [HUD showHUDWithText:Localized(@"请输入4位以上的字母数字组合用户名") withDelay:2.0f];
            return NO;
        }
        if (kStringIsEmpty(name)) { // 子用户姓名
            [HUD showHUDWithText:Localized(@"请输入姓名") withDelay:2.0f];
            return NO;
        }
        
        if ([pwd1 isValidAlphaNumberPassword] == NO ) {
            [HUD showHUDWithText:Localized(@"请输入6位以上的字母数字组合密码") withDelay:2.0f];
            return NO;
        } else if (pwd1.length < 6) {
            [HUD showHUDWithText:Localized(@"请输入6位以上的字母数字组合密码") withDelay:2.0f];
            return NO;
        }
        
        if (kStringIsEmpty(pwd2)) { // 确认密码
            [HUD showHUDWithText:Localized(@"请输入确认密码") withDelay:2.0f];
            return NO;
        }else if ([pwd1 isEqualToString:pwd2] == NO ) {
            [HUD showHUDWithText:Localized(@"两次输入的密码不相同") withDelay:2.0f];
            return NO;
        }else if (kStringIsEmpty(phone)) { // 电话号码
            [HUD showHUDWithText:Localized(@"请输入电话号码") withDelay:2.0f];
            return NO;
        }

        
        return YES;
    } confrim:^(NSArray<NSString *> * _Nonnull contentStr,CBBasePopView *popView) {
        
        [weakself didClickAddAccount:contentStr finishBlk:^{
            [popView dismiss];
        }];
    }] pop];
}

- (void)didClickAddAccount:(NSArray<NSString *> *)contentStr finishBlk:(void(^)(void))finishBlk {
    finishBlk();
    NSString *accountName = contentStr[0];
    NSString *name = contentStr[1];
    NSString *pwd1 = contentStr[2];
    NSString *pwd2 = contentStr[3];
    NSString *phone = contentStr[4];
    
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:accountName forKey:@"account"];
    [paramters setObject:name forKey:@"name"];
    [paramters setObject:pwd1 forKey:@"pwd"];
    [paramters setObject:pwd2 forKey:@"pwdConfirm"];
    [paramters setObject:phone forKey:@"phone"];
    
    kWeakSelf(self);
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[NetWorkingManager shared]postWithUrl:@"userController/valideAccount" params:@{
        @"account": accountName
    } succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        if (isSucceed) {
            [[NetWorkingManager shared]postWithUrl:@"personController/addSubUser" params:paramters succeed:^(id response,BOOL isSucceed) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (isSucceed) {
                    [CBTopAlertView alertSuccess:Localized(@"操作成功")];
                    [weakself requestDataWithHud:nil];
//                    [self.navigationController popViewControllerAnimated: YES];
                } else {
                }
            } failed:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failed:^(NSError *error) {
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
