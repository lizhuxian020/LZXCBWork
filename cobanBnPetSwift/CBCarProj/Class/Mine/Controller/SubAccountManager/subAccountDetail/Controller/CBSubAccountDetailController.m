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

@interface CBSubAccountDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *titleDataSource;

@property (nonatomic, strong) _CBSubAccountPopView *popView;

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
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView registerClass:_CBSubAccountDeivceCell.class forCellReuseIdentifier:@"_CBSubAccountDeivceCell"];
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
    lbl.text =
    indexPath.row == 0 ? self.accountModel.account :
    indexPath.row == 1 ? self.accountModel.name :
    indexPath.row == 2 ? self.accountModel.auth :
    indexPath.row == 3 ? self.accountModel.phone :
    indexPath.row == 4 ? self.accountModel.status :
    indexPath.row == 6 ? [MINUtils getTimeFromTimestamp:self.accountModel.create_time formatter:@"yyyy-MM-dd HH:mm:ss"] :
    @"";
    
    
    
    return cell;
}

- (void)showPopView {
    [self.popView pop];
}



@end
