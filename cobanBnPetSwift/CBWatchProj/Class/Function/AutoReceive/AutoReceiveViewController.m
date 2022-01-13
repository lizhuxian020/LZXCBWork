//
//  AutoReceiveViewController.m
//  Watch
//
//  Created by lym on 2018/2/27.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "AutoReceiveViewController.h"
#import "SwitchHeaderView.h"
#import "SwitchView.h"
#import "MINSwitchView.h"
#import "AutoReceiveHeaderView.h"
#import "AutoReceiveTableViewCell.h"
#import "FuctionSwitchModel.h"
#import "AddressBookModel.h"

@interface AutoReceiveViewController () <UITableViewDelegate, UITableViewDataSource>
{
    SwitchHeaderView *headerView;
}
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic,strong) NSMutableArray *arrayData;
@end

@implementation AutoReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self addAction];

    [self changeHeaderViewSwitchStatus: self.model.autoConnect];
    [self requestAutoReceiveWithHud: nil];
}
#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"自动接通") isBack: YES];
    headerView = [[SwitchHeaderView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * (5.0 / 7.5));
    headerView.swtichView.switchView.isON = YES;
    headerView.swtichView.titleLabel.text = Localized(@"自动接通");
    headerView.imageView.image = [UIImage imageNamed: @"自动接通-1"];
    __weak __typeof__(self) weakSelf = self;
    headerView.switchStatusChange = ^(BOOL isOn) {
        [weakSelf requestChangeSwitchStatus: isOn];
    };
    [self.view addSubview:headerView];
    
    self.saveBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"保存") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: KWtBlueColor Radius: 20 * KFitWidthRate];
    [self.saveBtn addTarget: self action: @selector(saveBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-TabPaddingBARHEIGHT-12.5);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150 * KFitWidthRate, 40 * KFitWidthRate));
    }];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(self.saveBtn.mas_top).offset(-12.5);
    }];
}
- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}
#pragma mark -- 获取自动接通列表
- (void)requestAutoReceiveWithHud:(MBProgressHUD *)hud
{
    [self.arrayData removeAllObjects];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] getWithUrl: @"watch/commonly/getAutoConnectList" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"自动接通列表:===%@===",response);
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass: [NSArray class]]) {
                for (NSDictionary *dic in response[@"data"]) {
                    AddressBookModel *model = [AddressBookModel yy_modelWithDictionary: dic];
                    [self.arrayData addObject:model];
                }
                [self.tableView reloadData];
            }
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 修改自动接通
- (void)saveBtnClick
{
    NSMutableArray *updArr = [NSMutableArray array];
    for (AddressBookModel *model in self.arrayData) {
//        if (model.isAutoConnect) {
//            [updArr addObject: [NSString stringWithFormat: @"%@,%d", model.relationId, model.isAutoConnect]];
//        }
        [updArr addObject: [NSString stringWithFormat: @"%@,%d", model.relationId, model.isAutoConnect]];
    }
    if (updArr.count <= 0) {
        [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"请选择需要自动接通的联系人")];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"updParamStr"] = [updArr componentsJoinedByString: @";"];
    kWeakSelf(self);
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/commonly/updAutoConnect" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [weakSelf requestAutoReceiveWithHud:nil];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
#pragma mark -- 修改手表开关状态（手表的基本开关
- (void)requestChangeSwitchStatus:(BOOL)isOn
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
    dic[@"autoConnect"] = [NSNumber numberWithBool: isOn];
    kWeakSelf(self);
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/updSwitchStatus" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!isSucceed) {
            [weakSelf changeHeaderViewSwitchStatus: !isOn];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - CreateAction
- (void)addAction
{
    
}
- (void)changeHeaderViewSwitchStatus:(BOOL)status
{
    if (status == YES) {
        headerView.swtichView.switchView.isON = YES;
        headerView.swtichView.statusLabel.text = Localized(@"已开启");
    }else {
        headerView.swtichView.switchView.isON = NO;
        headerView.swtichView.statusLabel.text = Localized(@"已关闭");
    }
}

#pragma mark - tableView delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"AutoReceiveTableViewCell";
    AutoReceiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: indentify];
    if (cell == nil) {
        cell = [[AutoReceiveTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: indentify];
    }
    if (self.arrayData.count > indexPath.row) {
        AddressBookModel *model = self.arrayData[indexPath.row];
        cell.model = model;
    }
    kWeakSelf(self);
    cell.clickBlock = ^{
        kStrongSelf(self);
        [self.tableView reloadData];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10+10+20+10+10+50*frameSizeRate+10;//80 * KFitWidthRate;
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
