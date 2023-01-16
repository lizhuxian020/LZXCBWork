//
//  CBCarAlertMsgDelegate.m
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/16.
//  Copyright © 2023 coban. All rights reserved.
//

#import "CBCarAlertMsgDelegate.h"

@implementation CBCarAlertMsgDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        [self tableView];
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = kBackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:_CBCarAlertMsgCell.class forCellReuseIdentifier:@"_CBCarAlertMsgCell"];
        kWeakSelf(self);
        _tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [weakself reload];
        }];
    }
    return _tableView;
}

- (void)reload {
    [MBProgressHUD showHUDIcon:self.tableView animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] getWithUrl:@"/alarmDealController/getMyWarnList" params:@{
        @"type" : @"1"
    } succeed:^(id response, BOOL isSucceed) {
        
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
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
            [MBProgressHUD hideHUDForView:self.tableView animated:YES];
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
//        [weakself requestToStop:model];
    }];
    [cell setDidClickCheck:^{
//        [weakself.navigationController popViewControllerAnimated:YES];
    }];
    return cell;
}
@end
