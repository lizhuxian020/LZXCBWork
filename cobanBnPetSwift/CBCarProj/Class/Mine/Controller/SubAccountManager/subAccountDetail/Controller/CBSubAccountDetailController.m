//
//  CBSubAccountDetailController.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/19.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBSubAccountDetailController.h"
#import "_CBSubAccountPopView.h"
#import "_CBSubAccountDeivceCell.h"
#import "_CBSubAccountEditView.h"
#import "CBManagerAccountPopView.h"

@interface CBSubAccountDetailController ()<UITableViewDelegate, UITableViewDataSource, CBManagerAccountPopViewDelegate>

@property (nonatomic, strong) NSArray *titleDataSource;

@property (nonatomic, strong) _CBSubAccountPopView *popView;

@property (nonatomic, strong) _CBSubAccountEditView *editView;

@property (nonatomic,strong) CBManagerAccountPopView *accountPopView;
@property (nonatomic,strong) NSMutableArray *arraySelectAccount;
@property (nonatomic,copy) NSString *authStr;
@end

@implementation CBSubAccountDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleDataSource = @[
        Localized(@"账号"),
        Localized(@"名称"),
        Localized(@"权限"),
        Localized(@"电话号码"),
        Localized(@"状态"),
        Localized(@"分配的设备"),
        Localized(@"创建时间"),
    ];
    [self createUI];
}

- (void)createUI {
    [self initBarWithTitle:Localized(@"子账户管理") isBack:YES];
    [self initBarRightImageName:@"更多" target:self action:@selector(showPopView)];
    self.popView = [_CBSubAccountPopView new];
    kWeakSelf(self);
    [self.popView setDidClick:^(int index) {
        [weakself didClickMenu:index];
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView registerClass:_CBSubAccountDeivceCell.class forCellReuseIdentifier:@"_CBSubAccountDeivceCell"];
    
    self.editView = [_CBSubAccountEditView new];
    self.editView.accountModel = self.accountModel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        _CBSubAccountDeivceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_CBSubAccountDeivceCell"];
        cell.accountModel = self.accountModel;
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.titleDataSource[indexPath.row];
    UILabel *lbl = [cell viewWithTag:101];
    if (!lbl) {
        lbl = [MINUtils createLabelWithText:@"" size:14 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
        [cell addSubview:lbl];
        lbl.tag = 101;
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-15);
            make.centerY.equalTo(@0);
        }];
    }
    
    NSString *authString = @"";
    if (!kStringIsEmpty(self.accountModel.auth)) {
        authString =
        self.accountModel.auth.intValue == 0 ? Localized(@"所有权限") :
        self.accountModel.auth.intValue == 1 ? Localized(@"查看权限") :
        self.accountModel.auth.intValue == 2 ? Localized(@"控制权限") : @"";
    }
    NSString *statusString = @"";
    if (!kStringIsEmpty(self.accountModel.status)) {
        statusString =
        self.accountModel.status.intValue == 0 ? Localized(@"正常") :
        self.accountModel.status.intValue == 1 ? Localized(@"冻结") : @"";
    }
    
    lbl.text =
    indexPath.row == 0 ? self.accountModel.account :
    indexPath.row == 1 ? self.accountModel.name :
    indexPath.row == 2 ? authString :
    indexPath.row == 3 ? self.accountModel.phone :
    indexPath.row == 4 ? statusString :
    indexPath.row == 6 ? [MINUtils getTimeFromTimestamp:self.accountModel.create_time formatter:@"yyyy-MM-dd HH:mm:ss"] :
    @"";
    
    
    
    return cell;
}

- (void)showPopView {
    [self.popView pop];
}

- (void)didClickMenu:(int)index {
    kWeakSelf(self);
    if (index == 0) {
        CBAlertBaseView *alertView = [[CBAlertBaseView alloc] initWithContentView:self.editView title:Localized(@"编辑")];
        CBBasePopView *popView = [[CBBasePopView alloc] initWithContentView:alertView];
        __weak CBBasePopView *wpopView = popView;
        
        [alertView setDidClickConfirm:^{
            [wpopView dismiss];
            [weakself didFinishEdit];
        }];
        [alertView setDidClickCancel:^{
            [wpopView dismiss];
        }];
        
        [popView pop];
    }
    if (index == 1) {
        [self.accountPopView popView:_accountModel];
        [[CBCarAlertView viewWithSubAccountAuthConfig:self.accountPopView confrim:^(NSString * _Nonnull contentStr) {
            [weakself.accountPopView certain];
        }] pop];
    }
    if (index == 2) {
        [[CBCarAlertView viewWithMultiInput:@[Localized(@"请输入您的新密码"),Localized(@"请再次输入您的新密码")] title:Localized(@"修改密码") isDigitalBlk:^BOOL(int index) {
            return NO;
        } maxLengthBlk:^int(int index) {
            return 100;
        } securityBLk:^BOOL(int index) {
            return YES;
        } confirmCanDismiss:^BOOL(NSArray<NSString *> * _Nonnull contentStr) {
            NSString *pwd1 = contentStr.firstObject;
            NSString *pwd2 = contentStr.lastObject;
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
            }
            return YES;
        } confrim:^(NSArray<NSString *> * _Nonnull contentStr, CBBasePopView * _Nonnull popView) {
            [popView dismiss];
            [weakself setNewPwd:contentStr.firstObject];
        }] pop];
    }
    if (index == 3) {
        [[CBCarAlertView viewWithAlertTips:Localized(@"确认删除?\n删除后不可找回") title:Localized(@"提示") confrim:^(NSString * _Nonnull contentStr) {
            [weakself deleteAccountRequestWithIndexPath];
        }] pop];
    }
}

- (void)didFinishEdit {
    NSLog(@"%@", self.editView);
    NSString *account = self.editView.accountTF.text;
    NSString *address = self.editView.addressTF.text;
    NSString *comment = self.editView.markTF.text;
    NSString *email = self.editView.emailTF.text;
    NSString *name = self.editView.nameTF.text;
    NSString *phone = self.editView.phoneTF.text;
    if (kStringIsEmpty(account) || kStringIsEmpty(address) || kStringIsEmpty(comment) || kStringIsEmpty(email) || kStringIsEmpty(name) || kStringIsEmpty(phone) ) {
        [HUD showHUDWithText:Localized(@"任何一项不能为空")];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    SubAccountModel *model = _accountModel;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"sid"] = model.accountId;
    [dic addEntriesFromDictionary:@{
        @"account": account,
        @"address": address,
        @"comment": comment,
        @"email": email,
        @"name": name,
        @"phone": phone,
        @"status": @0
    }];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[NetWorkingManager shared] postWithUrl:@"personController/editSubUserAuto" params: dic succeed:^(id response,BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (isSucceed) {
            //[hud hideAnimated:YES];
            [CBTopAlertView alertSuccess:Localized(@"操作成功")];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else {
            //[hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        //[hud hideAnimated:YES];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
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
    SubAccountModel *model = _accountModel;
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
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else {
            //[hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        //[hud hideAnimated:YES];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

- (void)setNewPwd:(NSString *)pwd {
    __weak __typeof__(self) weakSelf = self;
    SubAccountModel *model = _accountModel;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"sid"] = model.accountId;
    dic[@"pwd"] = [pwd md5WithString];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[NetWorkingManager shared] postWithUrl:@"personController/editSubUserAuto" params: dic succeed:^(id response,BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (isSucceed) {
            //[hud hideAnimated:YES];
            [CBTopAlertView alertSuccess:Localized(@"操作成功")];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else {
            //[hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        //[hud hideAnimated:YES];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

#pragma mark -- 删除子账户
- (void)deleteAccountRequestWithIndexPath
{
    __weak __typeof__(self) weakSelf = self;
    SubAccountModel *model = _accountModel;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sid"] = model.accountId;
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[NetWorkingManager shared]postWithUrl:@"personController/delSubUser" params: dic succeed:^(id response,BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (isSucceed) {
            [CBTopAlertView alertSuccess:Localized(@"操作成功")];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else {
            //[hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        //[hud hideAnimated:YES];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}
@end
