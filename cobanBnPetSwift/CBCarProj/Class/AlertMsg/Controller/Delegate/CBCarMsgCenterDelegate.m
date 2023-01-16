//
//  CBCarMsgCenterDelegate.m
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/16.
//  Copyright © 2023 coban. All rights reserved.
//

#import "CBCarMsgCenterDelegate.h"

@implementation CBCarMsgCenterDelegate

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
        [_tableView registerClass:_CBMsgCenterCell.class forCellReuseIdentifier:@"_CBMsgCenterCell"];
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
        @"type" : @"2"
    } succeed:^(id response, BOOL isSucceed) {
        
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        [self.tableView.mj_header endRefreshing];
        if (!isSucceed) {
            return;
        }
        if (response && [response[@"data"] isKindOfClass:NSArray.class]) {
            self.dataArr = [_CBMsgCenterModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
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
    _CBMsgCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_CBMsgCenterCell"];
    _CBMsgCenterModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    kWeakSelf(self);
    [cell setDidClickCheck:^{
        [weakself requestToStop:model];
    }];
    return cell;
}

- (void)requestToStop:(_CBMsgCenterModel *)model {
    kWeakSelf(self);
    [[NetWorkingManager shared] getWithUrl:@"alarmDealController/updateAlarmDeal" params:@{
        @"id": model.iid,
        @"type": @"2",
    } succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [HUD showHUDWithText:Localized(@"操作成功")];
//        [self reload];
        [self.navigationController popViewControllerAnimated:YES];
        } failed:^(NSError *error) {

        }];
}
@end
