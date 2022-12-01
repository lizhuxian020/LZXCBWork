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

@interface CBControlMenuController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation CBControlMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBarWithTitle:self.deviceInfoModelSelect.name?:@"" isBack:YES];
    
    kWeakSelf(self);
    self.dataSource = @[
        @{
            @"icon": @"报表-选中",
            @"title": Localized(@"设备信息"),
            @"blk": ^{
                NSLog(@"%s", __FUNCTION__);
            }
        },
        @{
            @"icon": @"报表-选中",
            @"title": Localized(@"控制指令"),
            @"blk": ^{
                NSLog(@"%s", __FUNCTION__);
                [weakself.navigationController pushViewController:ContorlViewController.new animated:YES];
            }
        },
        @{
            @"icon": @"报表-选中",
            @"title": Localized(@"终端设置"),
            @"blk": ^{
                NSLog(@"%s", __FUNCTION__);
                [weakself.navigationController pushViewController:CBSetTerminalViewController.new animated:YES];
            }
        },
        @{
            @"icon": @"报表-选中",
            @"title": Localized(@"指定记录"),
            @"blk": ^{
                NSLog(@"%s", __FUNCTION__);
            }
        },
        @{
            @"icon": @"报表-选中",
            @"title": Localized(@"报警设置"),
            @"blk": ^{
                NSLog(@"%s", __FUNCTION__);
            }
        },
        @{
            @"icon": @"报表-选中",
            @"title": Localized(@"安装信息"),
            @"blk": ^{
                NSLog(@"%s", __FUNCTION__);
            }
        }
    ];
    
    
    UILabel *lbl = [MINUtils createLabelWithText:@"解绑设备" size:14];
    lbl.layer.cornerRadius = 20;
    [lbl.layer setMasksToBounds:YES];
    lbl.layer.borderColor = UIColor.blackColor.CGColor;
    lbl.layer.borderWidth = 1;
    [self.view addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-TabPaddingBARHEIGHT-10));
        make.height.equalTo(@40);
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
