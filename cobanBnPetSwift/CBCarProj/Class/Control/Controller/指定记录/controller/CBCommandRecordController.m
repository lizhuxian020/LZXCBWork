//
//  CBCommandRecordController.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/3.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBCommandRecordController.h"
#import "_CBCommandRecordCell.h"

@interface CBCommandRecordController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<_CBCommandRecord *> *dataArr;

@end

@implementation CBCommandRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self requestData];
}

- (void)createUI {
    [self initBarWithTitle:Localized(@"指令记录") isBack:YES];
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.tableView registerClass:_CBCommandRecordCell.class forCellReuseIdentifier:@"_CBCommandRecordCell"];
}

- (void)requestData {
//    {
//        "dno": "585965120000101",
//        "length": 100,
//        "page": 1
//    }
    
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    CBHomeLeftMenuDeviceInfoModel *deviceModel = _deviceInfoModelSelect;
    NSDictionary *param = @{
        @"dno": deviceModel.dno ?: @"",
        @"length": @100,
        @"page": @1
    };
    kWeakSelf(self);
    [[NetWorkingManager shared] postJSONWithUrl:@"/hisCommand/list" params:param succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!isSucceed || !response[@"data"]) {
            return;
        }
        NSArray<_CBCommandRecord *> *data = [_CBCommandRecord mj_objectArrayWithKeyValuesArray:response[@"data"]];
        self.dataArr = data;
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        kStrongSelf(self);
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
    _CBCommandRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_CBCommandRecordCell"];
    _CBCommandRecord *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

@end
