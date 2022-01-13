//
//  WatchCallChargeViewController.m
//  Watch
//
//  Created by lym on 2018/2/23.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "WatchCallChargeViewController.h"
#import "ShortMessageTableViewCell.h"
#import "WatchCallChargeFooterView.h"
#import "CallChargeModel.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

@interface WatchCallChargeViewController () <UITableViewDelegate, UITableViewDataSource>
{
    WatchCallChargeFooterView *footerView;
}
//@property (nonatomic,strong) WatchCallChargeFooterView *footerView;
@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, strong) UITextField *messageTextField;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *selectStatusArr;
/** 定时器刷新 */
@property (nonatomic,strong) NSTimer *timerRefreshChargeData;

@end

@implementation WatchCallChargeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self requestCallChargeList];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    
    [self.timerRefreshChargeData invalidate];
    self.timerRefreshChargeData = nil;
}
- (void)dealloc {
    [self.timerRefreshChargeData invalidate];
    self.timerRefreshChargeData = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    self.selectStatusArr = [NSMutableArray array];
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark - CreateUI
- (void)createUI {
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"手表话费") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"编辑") selectTitle:Localized(@"完成") target:self action: @selector(rightBtnClick:)];
    
    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 117.5 * KFitWidthRate)];
    [self.view addSubview:headerView];
    
    self.numberTextField = [CBWtMINUtils createBorderTextFieldWithHoldText:Localized(@"请输入手机号码") fontSize: 15 * KFitWidthRate];
    self.numberTextField.backgroundColor = [UIColor whiteColor];
    self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [headerView addSubview: self.numberTextField];
    [self.numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).with.offset(12.5 * KFitWidthRate);
        make.width.mas_equalTo(SCREEN_WIDTH - 25 * KFitWidthRate);
        make.centerX.equalTo(headerView);
        make.height.mas_equalTo(40 * KFitWidthRate);
    }];
    self.messageTextField = [CBWtMINUtils createBorderTextFieldWithHoldText:Localized(@"请输入短信内容") fontSize: 15 * KFitWidthRate];
    self.messageTextField.backgroundColor = [UIColor whiteColor];
    [headerView addSubview: self.messageTextField];
    [self.messageTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberTextField.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.width.mas_equalTo(SCREEN_WIDTH - 25 * KFitWidthRate);
        make.centerX.equalTo(headerView);
        make.height.mas_equalTo(40 * KFitWidthRate);
    }];
    [CBWtMINUtils addLineToView: headerView isTop: NO hasSpaceToSide: YES];
    
    kWeakSelf(self);
    footerView = [[WatchCallChargeFooterView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 65 * KFitWidthRate + 34)];
    [self.view addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(-TabPaddingBARHEIGHT-0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(65);
    }];
    footerView.checkAllBtnClickBlock = ^(BOOL isSelected) {
        kStrongSelf(self);
        if (isSelected == YES) {
            for (int i = 0; i < self.selectStatusArr.count; i++) {
                [self.selectStatusArr replaceObjectAtIndex: i withObject: @1];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
                [self.tableView selectRowAtIndexPath: indexPath animated: YES scrollPosition: UITableViewScrollPositionTop];
            }
        }else {
            for (int i = 0; i < self.selectStatusArr.count; i++) {
                [self.selectStatusArr replaceObjectAtIndex: i withObject: @0];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
                [self.tableView deselectRowAtIndexPath: indexPath animated: YES];
            }
        }
        
    };
    footerView.queryBtnClickBlock = ^{
        kStrongSelf(self);
        [self requestCallCharge];
    };
    footerView.deleteBtnClickBlock = ^{
        kStrongSelf(self);
        [self deleWatchCallCharge];
    };
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 125 * KFitWidthRate;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(headerView.mas_bottom).offset(0);
        make.bottom.mas_equalTo(footerView.mas_top).offset(-10);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        kStrongSelf(self);
        [self requestCallChargeList];
    }];
}
#pragma mark - Action
- (void)rightBtnClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected == NO) {
        button.selected = YES;
         [footerView changeStatus: YES];
        self.tableView.editing = YES;
    } else {
        button.selected = NO;
         [footerView changeStatus: NO];
        self.tableView.editing = NO;
    }
}

#pragma mark - tableView delegate & dataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.isEditing == YES) {
        [self.selectStatusArr replaceObjectAtIndex: indexPath.row withObject: @1];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.isEditing == YES) {
        [self.selectStatusArr replaceObjectAtIndex: indexPath.row withObject: @0];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"WatchCallChargeTableViewCell";
    ShortMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: indentify];
    if (cell == nil) {
        cell = [[ShortMessageTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: indentify];
    }
    if (self.tableView.editing == YES && [self.selectStatusArr[indexPath.row] intValue] == 1) {
        [cell setSelected: YES animated: YES];
    }
    CallChargeModel *model = self.dataArr[indexPath.row];
    cell.senderLabel.text = model.phone;
    cell.timeLabel.text = [CBWtMINUtils getTimeFromTimestamp: model.createTime formatter: @"yyyy-MM-dd HH:mm:ss"];
    cell.messageLabel.text= model.content;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
#pragma mark -- 获取手表话费列表
- (void)requestCallChargeList {
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";
    dic[@"type"] = @0;
    //[MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] getWithUrl: @"watch/commonly/getWatchMsgList" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        if (isSucceed && response && [response[@"data"] isKindOfClass: [NSArray class]]) {
            NSMutableArray *arr = [NSMutableArray array];
            [weakSelf.selectStatusArr removeAllObjects];
            for (NSDictionary *dic in response[@"data"]) {
                CallChargeModel *model = [CallChargeModel yy_modelWithDictionary: dic];
                [arr addObject: model];
                [weakSelf.selectStatusArr addObject: @0];
            }
            weakSelf.dataArr = arr;
            [weakSelf.tableView reloadData];
        }
        self.noDataView.hidden = weakSelf.dataArr.count == 0?NO:YES;
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 删除手表话费
- (void)deleWatchCallCharge {
    NSMutableArray *delIdArr = [NSMutableArray array];
    for (int i = 0; i < self.selectStatusArr.count; i++) {
        NSNumber *num = self.selectStatusArr[i];
        if ([num intValue] == 1) {
            CallChargeModel *model = self.dataArr[i];
            [delIdArr addObject: model.callChargeId];
        }
    }
    if (delIdArr.count == 0) {
        [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"请选择你要删除的短信")];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"ids"] = [delIdArr componentsJoinedByString: @","];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/commonly/delWatchMsg" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [weakSelf rightBtnClick: weakSelf.navigationItem.rightBarButtonItems.lastObject.customView];
            [weakSelf requestCallChargeList];
        }else {
            [CBWtMINUtils showProgressHudToView: weakSelf.view withText:Localized(@"短信删除失败")];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 查询手表话费
- (void)requestCallCharge {
    if(self.numberTextField.text.length <= 0) {
        [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"请输入你的查询的电话号码")];
        return;
    }
    if (self.messageTextField.text.length <= 0) {
        [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"请输入查询内容")];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
    dic[@"phone"] = self.numberTextField.text;
    dic[@"content"] = self.messageTextField.text;
    kWeakSelf(self);
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/commonly/doWatchMsg" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [MBProgressHUD showMessage:Localized(@"发送成功") withDelay:1.5];
            self.timerRefreshChargeData = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(requestCallChargeList) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timerRefreshChargeData forMode:NSRunLoopCommonModes];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
