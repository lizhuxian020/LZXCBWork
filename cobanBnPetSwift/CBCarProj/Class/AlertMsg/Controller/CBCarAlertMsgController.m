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

@interface CBCarAlertMsgController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<_CBCarAlertMsgModel *> *dataArr;

@end

@implementation CBCarAlertMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBarWithTitle:Localized(@"报警消息") isBack:YES];
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.tableView registerClass:_CBCarAlertMsgCell.class forCellReuseIdentifier:@"_CBCarAlertMsgCell"];
    kWeakSelf(self);
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakself requestData];
    }];
    
    [self requestData];
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
        [HUD showHUDWithText:@"成功"];
        [self requestData];
        } failed:^(NSError *error) {
            
        }];
}
@end
