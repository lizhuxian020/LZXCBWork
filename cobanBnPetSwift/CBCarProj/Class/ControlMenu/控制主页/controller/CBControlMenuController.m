//
//  CBControlMenuController.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/29.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBControlMenuController.h"
#import "_CBControlMenuCell.h"
#import "ContorlViewController.h"
#import "CBSetTerminalViewController.h"
#import "CBCommandRecordController.h"
#import "CBSetAlarmViewController.h"
#import "CBInstallInfoController.h"
#import "MyDeviceViewController.h"
#import "MyDeviceDetailViewController.h"
#import "MyDeviceModel.h"

@interface CBControlMenuController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) MyDeviceModel *model;

@property (nonatomic, strong) NSMutableArray *groupNameArr;
@property (nonatomic, strong) NSMutableArray *groupIDArr;
@end

@implementation CBControlMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBarWithTitle:self.deviceInfoModelSelect.name?:@"" isBack:YES];
    self.groupNameArr = [NSMutableArray new];
    self.groupIDArr = [NSMutableArray new];
    
    kWeakSelf(self);
    self.dataSource = @[
        @{
            @"icon": @"设备信息",
            @"title": Localized(@"设备信息"),
            @"blk": ^{
                NSLog(@"%s", __FUNCTION__);
                [weakself jumpToDeviceInfo];
            }
        },
        @{
            @"icon": @"控制指令",
            @"title": Localized(@"控制指令"),
            @"blk": ^{
                NSLog(@"%s", __FUNCTION__);
                [weakself.navigationController pushViewController:ContorlViewController.new animated:YES];
            }
        },
        @{
            @"icon": @"终端设置",
            @"title": Localized(@"终端设置"),
            @"blk": ^{
                NSLog(@"%s", __FUNCTION__);
                [weakself.navigationController pushViewController:CBSetTerminalViewController.new animated:YES];
            }
        },
        @{
            @"icon": @"指令记录",
            @"title": Localized(@"指令记录"),
            @"blk": ^{
                NSLog(@"%s", __FUNCTION__);
                [weakself.navigationController pushViewController:CBCommandRecordController.new animated:YES];
            }
        },
        @{
            @"icon": @"报警设置",
            @"title": Localized(@"报警设置"),
            @"blk": ^{
                NSLog(@"%s", __FUNCTION__);
                [weakself.navigationController pushViewController:CBSetAlarmViewController.new animated:YES];
            }
        },
        @{
            @"icon": @"安装信息",
            @"title": Localized(@"安装信息"),
            @"blk": ^{
                NSLog(@"%s", __FUNCTION__);
                [weakself.navigationController pushViewController:CBInstallInfoController.new animated:YES];
            }
        }
    ];
    
    
    UILabel *lbl = [MINUtils createLabelWithText:@"解绑设备" size:14];
    lbl.layer.cornerRadius = 20;
    [lbl.layer setMasksToBounds:YES];
    lbl.layer.borderColor = KCarLineColor.CGColor;
    lbl.layer.borderWidth = 1;
    [self.view addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-TabPaddingBARHEIGHT-10));
        make.height.equalTo(@50);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
    }];
    lbl.userInteractionEnabled = YES;
    [lbl bk_whenTapped:^{
        NSLog(@"%s", __FUNCTION__);
    }];
    lbl.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(lbl.mas_top).mas_offset(-10);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:_CBControlMenuCell.class forCellReuseIdentifier:@"_CBControlMenuCell"];
   
}

- (void)jumpToDeviceInfo {
    
    MyDeviceDetailViewController *detailVC = [[MyDeviceDetailViewController alloc] init];
    detailVC.model = self.model;
    detailVC.groupName = self.model.groupNameStr;
    detailVC.groupNameArray = self.groupNameArr;
    detailVC.groupIdArray = self.groupIDArr;
    [self.navigationController pushViewController: detailVC animated: YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestDeviceList];
}

- (void)requestDeviceList {
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"personController/getMyDeviceList" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"设备列表:%@",response);
        if (isSucceed) {
            NSMutableArray *dataArr = [NSMutableArray array];
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                [weakSelf.groupNameArr removeAllObjects];
                [weakSelf.groupIDArr removeAllObjects];
                NSArray *responseArr = response[@"data"];
                for (int i = 0; i < responseArr.count - 2; i++) {
                    NSDictionary *dataDic = responseArr[i];
                    for (NSDictionary *deviceDic in dataDic[@"device"]) {
                        MyDeviceModel *model = [MyDeviceModel yy_modelWithDictionary: deviceDic];
                        model.groupNameStr = dataDic[@"groupName"];
                        model.groupId = dataDic[@"groupId"];
                        [dataArr addObject: model];
                    }
                    [weakSelf.groupNameArr addObject: dataDic[@"groupName"]];
                    [weakSelf.groupIDArr addObject: dataDic[@"groupId"]];
                }
                NSDictionary *noGroupDic = responseArr[responseArr.count - 2];
                for (NSDictionary *deviceDic in noGroupDic[@"noGroup"]) {
                    MyDeviceModel *model = [MyDeviceModel yy_modelWithDictionary: deviceDic];
                    model.groupNameStr = Localized(@"默认分组");
                    model.groupId = @"0";
                    [dataArr addObject: model];
                }
                [weakSelf.groupNameArr insertObject:Localized(@"默认分组") atIndex: 0];
                [weakSelf.groupIDArr insertObject: @0 atIndex: 0];
            }
            
            for (MyDeviceModel *model in dataArr) {
                if ([model.dno isEqualToString:self.deviceInfoModelSelect.dno]) {
                    self.model = model;
                }
            }
            
        }else {
            
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _CBControlMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_CBControlMenuCell"];
    cell.data = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = self.dataSource[indexPath.row];
    void(^blk)(void) = data[@"blk"];
    blk();
}
@end
