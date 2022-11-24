//
//  CBCarAlertMsgController.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/24.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBCarAlertMsgController.h"
#import "_CBCarAlertMsgCell.h"

@interface CBCarAlertMsgController ()<UITableViewDelegate, UITableViewDataSource>

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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _CBCarAlertMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_CBCarAlertMsgCell"];
    return cell;
}


@end
