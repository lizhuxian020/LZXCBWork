//
//  SwitchViewController.m
//  Watch
//
//  Created by lym on 2018/2/8.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "SwitchViewController.h"
#import "SwitchHeaderView.h"
#import "AutoHeightSwitchTableViewCell.h"
#import "SwitchView.h"
#import "MINSwitchView.h"
#import "FuctionSwitchModel.h"

@interface SwitchViewController () <UITableViewDelegate, UITableViewDataSource>
{
    SwitchHeaderView *headerView;
}
@end

@implementation SwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = KWtBackColor;
    headerView = [[SwitchHeaderView alloc] init];
    headerView.swtichView.switchView.isON = YES;
    if (self.switchType == SwitchViewTypeWear) {
        [self initBarWithTitle: @"佩戴检测" isBack: YES];
        headerView.swtichView.titleLabel.text = @"佩戴检测";
        if (self.model.wearAction == YES) {
            headerView.imageView.image = [UIImage imageNamed: @"佩戴检测-已佩戴"];
        }else {
            headerView.imageView.image = [UIImage imageNamed: @"佩戴检测-未佩戴"];
        }
        [self changeHeaderViewSwitchStatus: self.model.wearAction];
    }else if (self.switchType == SwitchViewTypeCommunicatePostion) {
        [self initBarWithTitle:Localized(@"通话位置") isBack: YES];
        headerView.swtichView.titleLabel.text = Localized(@"通话位置");
        headerView.imageView.image = [UIImage imageNamed: @"通话位置-1"];
        [self changeHeaderViewSwitchStatus: self.model.callPosiAction];
    }else if (self.switchType == SwitchViewTypeResercationPower) {
        [self initBarWithTitle:Localized(@"预留电量") isBack: YES];
        headerView.swtichView.titleLabel.text = Localized(@"预留电量");
        headerView.imageView.image = [UIImage imageNamed: @"预留电量-1"];
        [self changeHeaderViewSwitchStatus: self.model.elecAction];
    }else if (self.switchType == SwitchViewTypeStep) {
        [self initBarWithTitle:Localized(@"计步") isBack: YES];
        headerView.swtichView.titleLabel.text = Localized(@"计步");
        headerView.imageView.image = [UIImage imageNamed: @"计步-1"];
        [self changeHeaderViewSwitchStatus: self.model.stepAction];
    }else if (self.switchType == SwitchViewTypeCalling) {
        [self initBarWithTitle:Localized(@"拒绝陌生人来电") isBack: YES];
        headerView.swtichView.titleLabel.text = Localized(@"拒绝陌生人来电");
        headerView.imageView.image = [UIImage imageNamed: @"拒绝陌生人来电"];
        [self changeHeaderViewSwitchStatus: self.model.refuseStrangers];
    }else if (self.switchType == SwitchViewTypeSomatosensory) {
        [self initBarWithTitle:Localized(@"体感接听") isBack: YES];
        headerView.swtichView.titleLabel.text = Localized(@"体感接听");
        headerView.imageView.image = [UIImage imageNamed: @"体感接听"];
        [self changeHeaderViewSwitchStatus: self.model.bodyFeel];
    }else if (self.switchType == SwitchViewTypeWatchReportLoss) {
        [self initBarWithTitle:Localized(@"手表挂失") isBack: YES];
        headerView.swtichView.titleLabel.text = Localized(@"手表挂失");
        headerView.imageView.image = [UIImage imageNamed: @"手表挂失-1"];
        [self changeHeaderViewSwitchStatus: self.model.reportingLoss];
    }
    __weak __typeof__(self) weakSelf = self;
    headerView.switchStatusChange = ^(BOOL isOn) {
        [weakSelf requestChangeSwitchStatus: isOn];
    };
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = headerView;
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * (5.0 / 7.5));
    self.tableView.scrollEnabled = NO;
    // 高度自适应cell
    self.tableView.estimatedRowHeight = 75 * KFitWidthRate;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}
#pragma mark -- 修改手表开关状态（手表的基本开关）
- (void)requestChangeSwitchStatus:(BOOL)isOn
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";
    //MBProgressHUD *hud = [CBWtMINUtils hudToView: self.view withText: Localized(@"MINHud_Loading")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    __weak __typeof__(SwitchHeaderView *)weakHeaderView = headerView;
    NSNumber *isOnNum = [NSNumber numberWithBool: isOn];
    if (weakSelf.switchType == SwitchViewTypeWear) {
        dic[@"wearAction"] = isOnNum;
    }else if (weakSelf.switchType == SwitchViewTypeCommunicatePostion) {
        dic[@"callPosiAction"] = isOnNum;
    }else if (weakSelf.switchType == SwitchViewTypeResercationPower) {
        dic[@"elecAction"] = isOnNum;
    }else if (weakSelf.switchType == SwitchViewTypeStep) {
        dic[@"stepAction"] = isOnNum;
    }else if (weakSelf.switchType == SwitchViewTypeCalling) {
        dic[@"refuseStrangers"] = isOnNum;
    }else if (weakSelf.switchType == SwitchViewTypeSomatosensory) {
        dic[@"bodyFeel"] = isOnNum;
    }else if (weakSelf.switchType == SwitchViewTypeWatchReportLoss) {
        dic[@"reportingLoss"] = isOnNum;
    }
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/updSwitchStatus" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (weakSelf.switchType == SwitchViewTypeWear) {
                if (isOn == YES) {
                    weakHeaderView.imageView.image = [UIImage imageNamed: @"佩戴检测-已佩戴"];
                }else {
                    weakHeaderView.imageView.image = [UIImage imageNamed: @"佩戴检测-未佩戴"];
                }
            }
        }else {
            [weakSelf changeHeaderViewSwitchStatus: !isOn];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"AutoHeightSwitchTableViewCellIndentify";
    AutoHeightSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: indentify];
    if (cell == nil) {
        cell = [[AutoHeightSwitchTableViewCell alloc] init];
    }
    if (self.switchType == SwitchViewTypeWear) {
        if (indexPath.row == 0) {
            cell.topLabel.text = @"显示佩戴状态";
            cell.bottomLabel.text = @"随时查看宝贝当前佩戴状态";
        }else if (indexPath.row == 1){
            cell.topLabel.text = @"未读消息提醒";
            cell.bottomLabel.text = @"有未读消息时戴上手表会提醒孩子";
        }
    }else if (self.switchType == SwitchViewTypeCommunicatePostion) {
        if (indexPath.row == 0) {
            cell.topLabel.text = Localized(@"设置通话是否上报位置");
            cell.bottomLabel.text = @"";
        }
    }else if (self.switchType == SwitchViewTypeResercationPower) {
        if (indexPath.row == 0) {
            cell.topLabel.text = Localized(@"手表禁用");
            cell.bottomLabel.text = Localized(@"电量还剩10%以下时，手表禁用");
        }else if (indexPath.row == 1) {
            cell.topLabel.text = Localized(@"仅能接听电话");
            cell.bottomLabel.text = Localized(@"无法使用定位和微聊，仅能接听电话");
        }
    }else if (self.switchType == SwitchViewTypeStep) {
        if (indexPath.row == 0) {
            cell.topLabel.text = Localized(@"记录每天部署，查看孩子的运动量");
            cell.bottomLabel.text = @"";
        }
    }else if (self.switchType == SwitchViewTypeCalling) {
        if (indexPath.row == 0) {
            cell.topLabel.text = Localized(@"免受陌生人打扰，安全放心");
            cell.bottomLabel.text = @"";
        }
    }else if (self.switchType == SwitchViewTypeSomatosensory) {
        if (indexPath.row == 0) {
            cell.topLabel.text = Localized(@"抖一抖接听");
            cell.bottomLabel.text = Localized(@"手表抖一抖即可接听电话，让孩子尽情玩耍");
        }
    }else if (self.switchType == SwitchViewTypeWatchReportLoss) {
        if (indexPath.row == 0) {
//            cell.topLabel.text = @"位置上报，报失后，只要手边联网成功就会自动发送位置到APP，请耐心等待";
            [cell setTopLabelText: Localized(@"位置上报，报失后，只要手边联网成功就会自动发送位置到APP，请耐心等待")];
            cell.bottomLabel.text = @"";
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.switchType == SwitchViewTypeWear || self.switchType == SwitchViewTypeResercationPower) {
        return 2;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
