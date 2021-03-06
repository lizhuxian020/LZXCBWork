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
        _accountPopView = [[CBManagerAccountPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
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
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[NetWorkingManager shared]getWithUrl:@"personController/getSubUsers" params: dic succeed:^(id response,BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSLog(@"====子账户列表%@==",response);
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                [weakSelf.dataArr removeAllObjects];
                NSArray *array = response[@"data"];
                for (NSDictionary *dic in array) {
                    SubAccountModel *model = [SubAccountModel mj_objectWithKeyValues:dic];//[SubAccountModel yy_modelWithDictionary: dic];
                    [weakSelf.dataArr addObject: model];
                }
                [hud hideAnimated:YES];
                [weakSelf.tableView reloadData];
            }
        } else {
            //[hud hideAnimated:YES];
        }
        weakSelf.noDataView.hidden = weakSelf.dataArr.count == 0?NO:YES;
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}
#pragma mark -- 删除子账户
- (void)deleteAccountRequestWithIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof__(self) weakSelf = self;
    SubAccountModel *model = self.dataArr[self.indexPath.row];
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(12.5);
        make.left.right.bottom.equalTo(self.view);
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
        self.indexPath = indexPath;
        if (self.dataArr.count > indexPath.row) {
            SubAccountModel *model = self.dataArr[indexPath.row];
            [self.accountPopView popView:model];
        }
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
//    [cell setAccountName: @"123123" name: @"MIN" pass: @"123321123"];
    cell.indexPath = indexPath;
    [cell hideDeleteBtn];
    __weak typeof(self) weakSelf = self;
    [cell setDeleteBtnClick:^(NSIndexPath *indexPath) {
        [weakSelf deleteAccountRequestWithIndexPath: indexPath];
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
        make.width.mas_equalTo(100 * KFitWidthRate);
        make.centerX.mas_equalTo(view.mas_centerX).offset(-SCREEN_WIDTH/4);
    }];
    UILabel *nameLabel = [MINUtils createLabelWithText: Localized(@"名称") size: 12 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: labelColor];
    [view addSubview: nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        //make.left.equalTo(accountLabel.mas_right);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.width.mas_equalTo(75 * KFitWidthRate);
    }];
//    UILabel *passLabel = [MINUtils createLabelWithText: Localized(@"密码") size: 12 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: labelColor];
//    [view addSubview: passLabel];
//    [passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(view);
//        make.left.equalTo(nameLabel.mas_right);
//        make.width.mas_equalTo(114 * KFitWidthRate);
//    }];
    UILabel *permissionLabel = [MINUtils createLabelWithText:Localized(@"权限设置") size: 12 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: labelColor];
    [view addSubview: permissionLabel];
    [permissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(view);
        //make.left.equalTo(passLabel.mas_right);
        make.centerX.mas_equalTo(view.mas_centerX).offset(SCREEN_WIDTH/4);
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
    AddSubAccountViewController *addAcountVC = [[AddSubAccountViewController alloc] init];
    [self.navigationController pushViewController: addAcountVC animated: YES];
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
