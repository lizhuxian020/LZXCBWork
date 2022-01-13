//
//  CollectionMessageViewController.m
//  Watch
//
//  Created by lym on 2018/2/24.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "CollectionMessageViewController.h"
#import "SwitchHeaderView.h"
#import "AutoHeightSwitchTableViewCell.h"
#import "SwitchView.h"
#import "MINSwitchView.h"
#import "ShortMessageTableViewCell.h"
#import "EditCollectionMessageViewController.h"
#import "FuctionSwitchModel.h"
#import "CallChargeModel.h"

@interface CollectionMessageViewController () <UITableViewDelegate, UITableViewDataSource>
{
    SwitchHeaderView *headerView;
}
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UILabel *prompLb;
@end

@implementation CollectionMessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self requestMessageListWithHud: nil];
//    if (self.model.receiveMsg == YES) {
//        [self requestMessageListWithHud: nil];
//    }
//    else {
//        self.tableView.scrollEnabled = NO;
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self changeHeaderViewSwitchStatus: self.model.receiveMsg];
}
#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"代收消息") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"编辑") target: self action: @selector(rightBtnClick)];
    
    headerView = [[SwitchHeaderView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * (5.0 / 7.5));
    headerView.swtichView.titleLabel.text = Localized(@"代收手表信息");
    headerView.imageView.image = [UIImage imageNamed: @"代收信息"];
    __weak __typeof__(self) weakSelf = self;
    headerView.switchStatusChange = ^(BOOL isOn) {
        [weakSelf requestChangeSwitchStatus:isOn];
    };
    [self.view addSubview:headerView];
    
    _prompLb = [CBWtMINUtils createLabelWithText:Localized(@"注:垃圾短信会浪费手表电量和流量") size: 12 * KFitWidthRate alignment: NSTextAlignmentCenter textColor: KWt137Color];
    _prompLb.numberOfLines = 0;
    _prompLb.font = [UIFont fontWithName:CBPingFang_SC size:13];
    _prompLb.numberOfLines = 0;
    [self.view addSubview:_prompLb];
    [_prompLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
        make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
        make.bottom.equalTo(self.view).with.offset(-20-TabPaddingBARHEIGHT);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 高度自适应cell
    self.tableView.estimatedRowHeight = 75 * KFitWidthRate;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(_prompLb.mas_top);
    }];
}
#pragma mark - Action
- (void)rightBtnClick
{
    EditCollectionMessageViewController *editCollectionMessageVC = [[EditCollectionMessageViewController alloc] init];
    editCollectionMessageVC.dataArr = self.dataArr;
    [self.navigationController pushViewController: editCollectionMessageVC animated: YES];
}
#pragma mark -- 获取手表话费列表 type = 1 为短信
- (void)requestMessageListWithHud:(MBProgressHUD *)hud
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
    dic[@"type"] = @1;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] getWithUrl: @"watch/commonly/getWatchMsgList" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed && response && [response[@"data"] isKindOfClass: [NSArray class]]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in response[@"data"]) {
                CallChargeModel *model = [CallChargeModel yy_modelWithDictionary: dic];
                [arr addObject: model];
            }
            weakSelf.dataArr = arr;
//            NSSortDescriptor *idSd = [NSSortDescriptor sortDescriptorWithKey: @"callChargeId" ascending: NO];
//            [weakSelf.dataArr sortUsingDescriptors: @[idSd]];
            [weakSelf.tableView reloadData];
        }
        _prompLb.hidden = self.dataArr.count > 0?YES:NO;
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 修改手表开关状态（手表的基本开关）
- (void)requestChangeSwitchStatus:(BOOL)isOn
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
    dic[@"receiveMsg"] = [NSNumber numberWithBool: isOn];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/updSwitchStatus" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            //self.tableView.scrollEnabled = isOn;
            // 获取数据源
            [self.tableView reloadData];
        }else {
            [self changeHeaderViewSwitchStatus: !isOn];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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

#pragma mark - tableView delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.tableView.scrollEnabled == YES) {
//        return self.dataArr.count;
//    }
    if (self.dataArr.count > 0) {
        return self.dataArr.count;
    } else {
        return 2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.tableView.scrollEnabled == YES) {
//        static NSString *indentify = @"WatchCallChargeTableViewCell";
//        ShortMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: indentify];
//        if (cell == nil) {
//            cell = [[ShortMessageTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: indentify];
//        }
//        CallChargeModel *model = self.dataArr[indexPath.row];
//        cell.senderLabel.text = model.phone;
//        cell.timeLabel.text = [CBWtMINUtils getTimeFromTimestamp: model.createTime formatter: @"yyyy-MM-dd HH:mm:ss"];
//        cell.messageLabel.text= model.content;
//        return cell;
//    }else {
//        static NSString *indentify = @"AutoHeightSwitchTableViewCellIndentify";
//        AutoHeightSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: indentify];
//        if (cell == nil) {
//            cell = [[AutoHeightSwitchTableViewCell alloc] init];
//        }
//        if (indexPath.row == 0) {
//            cell.topLabel.text = @"手表屏蔽陌生短信";
//            cell.bottomLabel.text = @"手表会显示联系人发来的短信，不显示陌生短信";
//        }else if (indexPath.row == 1){
//            cell.topLabel.text = @"代收手表短信";
//            cell.bottomLabel.text = @"你可查看手表收到的验证码，运营商和陌生人短信";
//        }
//        return cell;
//    }
    if (self.dataArr.count > 0) {
        static NSString *indentify = @"WatchCallChargeTableViewCell";
        ShortMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: indentify];
        if (cell == nil) {
            cell = [[ShortMessageTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: indentify];
        }
        CallChargeModel *model = self.dataArr[indexPath.row];
        cell.senderLabel.text = model.phone;
        cell.timeLabel.text = [CBWtMINUtils getTimeFromTimestamp: model.createTime formatter: @"yyyy-MM-dd HH:mm:ss"];
        cell.messageLabel.text= model.content;
        return cell;
    } else {
        static NSString *indentify = @"AutoHeightSwitchTableViewCellIndentify";
        AutoHeightSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: indentify];
        if (cell == nil) {
            cell = [[AutoHeightSwitchTableViewCell alloc] init];
        }
        if (indexPath.row == 0) {
            cell.topLabel.text = Localized(@"手表屏蔽陌生短信");
            cell.bottomLabel.text = Localized(@"手表会显示联系人发来的短信，不显示陌生短信");
        }else if (indexPath.row == 1) {
            cell.topLabel.text = Localized(@"代收手表短信");
            cell.bottomLabel.text = Localized(@"你可查看手表收到的验证码，运营商和陌生人短信");
        }
        return cell;
    }
}
#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
