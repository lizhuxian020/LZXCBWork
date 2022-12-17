//
//  CBCarAlertMsgController.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/24.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBCarAlertMsgController.h"
#import "_CBCarAlertMsgCell.h"
#import "_CBCarAlertMsgModel.h"
#import "_CBAlertMsgMenuPopView.h"

@interface CBCarAlertMsgController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<_CBCarAlertMsgModel *> *dataArr;

@property (nonatomic, strong) _CBAlertMsgMenuPopView *popView;
@end

@implementation CBCarAlertMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    kWeakSelf(self);
    
    [self initBarWithTitle:Localized(@"报警消息") isBack:YES];
    [self initBarRightImageName:@"更多" target:self action:@selector(showPopView)];
    self.popView = [_CBAlertMsgMenuPopView new];
    [self.popView setDidClick:^{
        [weakself requestAllRead];
    }];
    [self.popView setDidClickCheck:^{
        [weakself switchTabBarThird];
    }];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.tableView registerClass:_CBCarAlertMsgCell.class forCellReuseIdentifier:@"_CBCarAlertMsgCell"];
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [weakself requestData];
    }];
    
    [self requestData];
}

- (void)requestAllRead {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] getWithUrl:@"/alarmDealController/updateAlarmDeal" params:nil succeed:^(id response, BOOL isSucceed) {
        
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [HUD showHUDWithText:Localized(@"操作成功")];
        }
        } failed:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
}

- (void)switchTabBarThird {
    UITabBarController *tabVC = UIApplication.sharedApplication.keyWindow.rootViewController;
    if (!tabVC || ![tabVC isKindOfClass:UITabBarController.class]) {
        return;;
    }
    [self.navigationController popToRootViewControllerAnimated:NO];
    tabVC.selectedIndex = 2;
}

- (void)showPopView {
    [self.popView pop];
}

- (void)requestData {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] getWithUrl:@"/alarmDealController/getMyWarnList" params:nil succeed:^(id response, BOOL isSucceed) {
        
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        if (!isSucceed) {
            return;
        }
        if (response && [response[@"data"] isKindOfClass:NSArray.class]) {
            self.dataArr = [_CBCarAlertMsgModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            [self.tableView reloadData];
        }
        } failed:^(NSError *error) {
            kStrongSelf(self);
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _CBCarAlertMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_CBCarAlertMsgCell"];
    _CBCarAlertMsgModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    kWeakSelf(self);
    [cell setDidClickStop:^{
        [weakself requestToStop:model];
    }];
    [cell setDidClickCheck:^{
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
    return cell;
}

- (void)requestToStop:(_CBCarAlertMsgModel *)model {
    NSString *url = [NSString stringWithFormat:@"%@%@", @"alarmDealController/updateAlarmDeal?id=", model.iid ];// 1595591725143363589
    kWeakSelf(self);
    [[NetWorkingManager shared] getWithUrl:url params:nil succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [HUD showHUDWithText:Localized(@"操作成功")];
        [self requestData];
        } failed:^(NSError *error) {
            
        }];
}
@end
