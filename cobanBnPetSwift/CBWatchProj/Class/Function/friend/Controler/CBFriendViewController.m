//
//  CBFriendViewController.m
//  Watch
//
//  Created by coban on 2019/8/27.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBFriendViewController.h"
#import "CBFriendListTableViewCell.h"
#import "CBFriendListFootView.h"
#import "HomeModel.h"
#import "CBFriendModel.h"

@interface CBFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSMutableArray *arrayDeleteData;
@property (nonatomic, strong) CBFriendListFootView *footerView;
@end

@implementation CBFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    [self initData];
}
- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self initBarWithTitle:Localized(@"好友列表") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"编辑") selectTitle:Localized(@"完成") target: self action: @selector(rightBtnClick:)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(0);
    }];
    kWeakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        kStrongSelf(self);
        [self.arrayData removeAllObjects];
        [self getMyFriendListRequest];
    }];
    [self footerView];
}
- (void)initData {
    [self.tableView.mj_header beginRefreshing];
}
- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}
- (NSMutableArray *)arrayDeleteData {
    if (!_arrayDeleteData) {
        _arrayDeleteData = [NSMutableArray array];
    }
    return _arrayDeleteData;
}
- (CBFriendListFootView *)footerView {
    if (!_footerView) {
        _footerView = [[CBFriendListFootView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 70*KFitWidthRate)];
        [self.view addSubview:_footerView];
        kWeakSelf(self);
        _footerView.checkAllBtnClickBlock = ^(BOOL isSelected) {
            kStrongSelf(self);
            if (isSelected == YES) {
                for (CBFriendModel *model in self.arrayData) {
                    model.isCheck = YES;
                }
            } else {
                for (CBFriendModel *model in self.arrayData) {
                    model.isCheck = NO;
                }
            }
            [self.tableView reloadData];
            [self updateDeleteData];
        };
        _footerView.deleteBtnClickBlock = ^{
            kStrongSelf(self);
            [self deleteAction];
        };
    }
    return _footerView;
}
#pragma mark - tableView delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90*frameSizeRate;// + 15*KFitWidthRate;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBFriendListTableViewCell *cell;
    cell = [CBFriendListTableViewCell cellCopyTableView:tableView];
    if (self.arrayData.count > indexPath.row) {
        CBFriendModel *model = self.arrayData[indexPath.row];
        cell.friendModel = model;
    }
    kWeakSelf(self);
    cell.selectFriendBlock = ^(id  _Nonnull objc) {
        kStrongSelf(self);
        //[self.arrayDeleteData addObject:objc];
        [self updateDeleteData];
    };
    return cell;
}
#pragma mark -- 获取好友列表
- (void)getMyFriendListRequest {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:self.homeInfoModel.tbWatchMain.sno?:@"" forKey:@"sno"];
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] getMyFriendListParamters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        NSArray *arrayDataTemp = baseModel.data;
        for (NSDictionary *dic in arrayDataTemp) {
            CBFriendModel *model = [CBFriendModel mj_objectWithKeyValues:dic];
            [self.arrayData addObject:model];
        }
        [self.tableView reloadData];
        self.noDataView.hidden = self.arrayData.count == 0?NO:YES;
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark -- 删除好友
- (void)deleteFriendRequest {
    
    NSString *idsStr = [self.arrayDeleteData componentsJoinedByString:@","];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:idsStr?:@"" forKey:@"ids"];
    
    //return;
    
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] deleteMyFriendParamters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
        self.noDataView.hidden = self.arrayData.count == 0?NO:YES;
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - Action
- (void)rightBtnClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected == NO) {
        button.selected = YES;
        for (CBFriendModel *model in self.arrayData) {
            model.isEdit = YES;
        }
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.mas_equalTo(-70*KFitWidthRate);
        }];
        self.footerView.frame = CGRectMake(0, SCREEN_HEIGHT - PPNavigationBarHeight - TabPaddingBARHEIGHT - 70*KFitWidthRate, SCREEN_WIDTH, 70*KFitWidthRate);
        
    } else {
        button.selected = NO;
        for (CBFriendModel *model in self.arrayData) {
            model.isEdit = NO;
        }
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.mas_equalTo(0);
        }];
        self.footerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 70*KFitWidthRate);
    }
    [self.tableView reloadData];
    [self.arrayDeleteData removeAllObjects];
}
- (void)deleteAction {
    if (self.arrayDeleteData.count <= 0) {
        [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"请选择要删除的好友")];
        return;
    }
    // 删除好友提醒
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:Localized(@"是否删除好友") preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self deleteFriendRequest];
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}
- (void)updateDeleteData {
    [self.arrayDeleteData removeAllObjects];
    for (CBFriendModel *model in self.arrayData) {
        if (model.isCheck) {
            [self.arrayDeleteData addObject:model.ids?:@""];
        } else {
            [self.arrayDeleteData removeObject:model.ids?:@""];
        }
    }
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
