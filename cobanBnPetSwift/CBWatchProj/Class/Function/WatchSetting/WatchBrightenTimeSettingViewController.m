//
//  WatchBrightenTimeSettingViewController.m
//  Watch
//
//  Created by lym on 2018/2/27.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "WatchBrightenTimeSettingViewController.h"
#import "TimeRepeatTableViewCell.h"
#import "WatchSettingModel.h"

@interface WatchBrightenTimeSettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) WatchSettingScreenTimeModel *selectModel;
@end

@implementation WatchBrightenTimeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"选择亮屏时间") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"完成") target: self action: @selector(rightBtnClick)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}
- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = [NSMutableArray array];
        NSArray *arrayTime = @[@"5", @"10", @"15", @"20", @"30", @"60"];
        for (int i = 0 ; i < arrayTime.count ; i ++ ) {
            WatchSettingScreenTimeModel *model = [[WatchSettingScreenTimeModel alloc]init];
            model.screenTime = arrayTime[i];
            model.isSelect = NO;
            [_arrayData addObject:model];
        }
    }
    return _arrayData;
}
#pragma mark - Action
- (void)rightBtnClick
{
    if (self.selectModel.isSelect == NO) {
        [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"请选择亮屏时间")];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
    dic[@"screenTime"] = [NSNumber numberWithInteger:self.selectModel.screenTime.integerValue];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/updSwitchStatus" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!isSucceed) {
            [CBWtMINUtils showProgressHudToView:weakSelf.view withText:Localized(@"修改失败")];
        }else {
            if (self.returnBlock) {
                self.returnBlock(self.selectModel.screenTime);
            }
            [weakSelf.navigationController popViewControllerAnimated: YES];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - tableView delegate & dataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WatchSettingScreenTimeModel *model = self.arrayData[indexPath.row];
    model.isSelect = !model.isSelect;
    for (WatchSettingScreenTimeModel *modelTemp in self.arrayData) {
        if ([modelTemp isEqual:model]) {
            self.selectModel = modelTemp;
        } else {
            modelTemp.isSelect = NO;
        }
    }
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"TimeRepeatTableViewCellIndentify";
    TimeRepeatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: indentify];
    if (cell == nil) {
        cell = [[TimeRepeatTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: indentify];
    }
    if (self.arrayData.count > indexPath.row) {
        WatchSettingScreenTimeModel *model = self.arrayData[indexPath.row];
        cell.model = model;
    }
    //[cell.selectBtn addTarget:self action:@selector(cellBtnClick) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50 * KFitWidthRate;
}
- (void)cellBtnClick {
    
}
#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
