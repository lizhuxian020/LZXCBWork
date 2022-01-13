//
//  NotifactionCenterViewController.m
//  Watch
//
//  Created by lym on 2018/3/7.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "NotifactionCenterViewController.h"
#import "NotificationCenterTableViewCell.h"
#import "NotifactionCenterFooterView.h"
#import "NotifactionDetailViewController.h"
#import "MessageModel.h"
#import "HomeModel.h"

@interface NotifactionCenterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) NSArray *contentArr;

@property (nonatomic, strong) NotifactionCenterFooterView *footerView;

@end

@implementation NotifactionCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageListData) name:KCBWtMessageNotification object:nil];
}
- (void)updateMessageListData {
    [self requestMessageListWithHud:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KCBWtMessageNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self requestMessageListWithHud:nil];
}
#pragma mark -- 消息列表
- (void)requestMessageListWithHud:(MBProgressHUD *)hud
{
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[HomeModel CBDevice].tbWatchMain.sno?:@"" forKey:@"sno"];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] getMessageListParamters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (baseModel && [baseModel.data isKindOfClass: [NSArray class]]) {
            NSMutableArray *arr = [NSMutableArray array];
            [self.dataArr removeAllObjects];
            for (NSDictionary *dic in baseModel.data) {
                MessageModel *model = [MessageModel yy_modelWithDictionary: dic];
                [arr addObject: model];
            }
            self.dataArr = arr;
            [self.tableView reloadData];
        }
        self.noDataView.hidden = self.dataArr.count ==0?NO:YES;
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self initBarWithTitle:Localized(@"消息中心") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"编辑") selectTitle:Localized(@"完成") target: self action: @selector(rightBtnClick:)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(0);
    }];
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestMessageListWithHud:)];
//    // 设置普通状态的动画图片
//    [header setImages:@[[UIImage imageNamed:@""]] forState:MJRefreshStateIdle];
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    [header setImages:@[[UIImage imageNamed:@""]] forState:MJRefreshStatePulling];
//    // 设置正在刷新状态的动画图片
//    [header setImages:@[[UIImage imageNamed:@""]] forState:MJRefreshStateRefreshing];
//    // 设置header
//    self.tableView.mj_header = header;
    kWeakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        kStrongSelf(self);
        [self requestMessageListWithHud:nil];
    }];
    [self footerView];
}
- (NotifactionCenterFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[NotifactionCenterFooterView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 70*KFitWidthRate)];
        [self.view addSubview:_footerView];
        kWeakSelf(self);
        _footerView.checkAllBtnClickBlock = ^(BOOL isSelected) {
            kStrongSelf(self);
            if (isSelected == YES) {
                for (MessageModel *model in self.dataArr) {
                    model.isCheck = YES;
                }
            } else {
                for (MessageModel *model in self.dataArr) {
                    model.isCheck = NO;
                }
            }
            [self.tableView reloadData];
        };
        _footerView.deleteBtnClickBlock = ^{
            kStrongSelf(self);
            [self deleMessageRequest];
        };
    }
    return _footerView;
}
#pragma mark - tableView delegate & dataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return;
//    if (self.tableView.isEditing == YES) {
//        [self.selectStatusArr replaceObjectAtIndex: indexPath.row withObject: @1];
//    }else {
//        MessageModel *model = self.dataArr[indexPath.row];
//        if (model.isRead == NO) {
//            [self readMessageRequestWithModel: model];
//        }else {
//            NotifactionDetailViewController *notificationDetailVC = [[NotifactionDetailViewController alloc] init];
//            notificationDetailVC.model = model;
//            [self.navigationController pushViewController: notificationDetailVC animated: YES];
//        }
//    }
    
    if (self.dataArr.count > indexPath.row) {
        MessageModel *model = self.dataArr[indexPath.row];
        if (model.type == 0) {
            // 监护人申请 b点击不进入详情
        } else {
            NotifactionDetailViewController *notificationDetailVC = [[NotifactionDetailViewController alloc] init];
            notificationDetailVC.model = model;
            [self.navigationController pushViewController: notificationDetailVC animated: YES];
            [self readMessageRequestWithModel:model];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
//    if (self.tableView.isEditing == YES) {
//        [self.selectStatusArr replaceObjectAtIndex: indexPath.row withObject: @0];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"NotificationCenterTableViewCellIndentify";
    NotificationCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: indentify];
    if (cell == nil) {
        cell = [[NotificationCenterTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: indentify];
    }
    kWeakSelf(self);
    cell.refuseBtnClickBlock = ^{
        kStrongSelf(self);
        MessageModel *model = self.dataArr[indexPath.row];
        [self alertTitle:Localized(@"确认拒绝?") status:2 messageId:model.messageId applyUid:nil applyUserPhone:nil sno:nil];
    };
    cell.agreeBtnClickBlock = ^{
        kStrongSelf(self);
        MessageModel *model = self.dataArr[indexPath.row];
        [self alertTitle:Localized(@"确认同意?") status:1 messageId:model.messageId applyUid:@"" applyUserPhone:@"" sno:@""];
    };
    if (self.dataArr.count > indexPath.row) {
        MessageModel *model = self.dataArr[indexPath.row];
        cell.messageModel = model;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > indexPath.row) {
        MessageModel *model = self.dataArr[indexPath.row];
        return model.cellHeigt;
    }
    return 0;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
#pragma mark - Action
- (void)rightBtnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.selected == NO) {
        button.selected = YES;
        for (MessageModel *model in self.dataArr) {
            model.isEdit = YES;
        }
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.mas_equalTo(-70*KFitWidthRate);
        }];
        self.footerView.frame = CGRectMake(0, SCREEN_HEIGHT - PPNavigationBarHeight - TabPaddingBARHEIGHT - 70*KFitWidthRate, SCREEN_WIDTH, 70*KFitWidthRate);
        
    } else {
        button.selected = NO;
        for (MessageModel *model in self.dataArr) {
            model.isEdit = NO;
        }
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.mas_equalTo(0);
        }];
        self.footerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 70*KFitWidthRate);
    }
    [self.tableView reloadData];
}
#pragma mark -- 处理消息
- (void)alertTitle:(NSString *)titleStr
            status:(int)status
         messageId:(NSString *)messageId
           applyUid:(NSString *)applyUid
    applyUserPhone:(NSString *)applyUserPhone
               sno:(NSString *)sno {
    kWeakSelf(self);
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:titleStr preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        kStrongSelf(self);
        [self dismissViewControllerAnimated:YES completion:nil];
        [self dealApplyMessageWithStatus:status messageID:messageId applyUid:applyUid applyUserphone:applyUserPhone sno:sno];
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}
- (void)dealApplyMessageWithStatus:(int)status messageID:(NSString *)messageId applyUid:(NSString *)applyUid applyUserphone:(NSString *)applyUserphone sno:(NSString *)sno
{
    //__weak __typeof__(self) weakSelf = self;
    //MBProgressHUD *hud = [CBWtMINUtils hudToView: self.view withText: Localized(@"MINHud_Loading")];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    if (status == 1) { // 接收
        paramters[@"status"] = @1;
    }else {
        paramters[@"status"] = @2;
    }
//    if (applyUid != nil) {
//        paramters[@"applyUid"] = applyUid;
//    }
//    if (applyUserphone != nil) {
//        paramters[@"applyUserphone"] = applyUserphone;
//    }
//    if (sno != nil) {
//        paramters[@"sno"] = sno;
//    }
    paramters[@"id"] = messageId;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] dealMessageParamters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        switch (baseModel.status) {
            case CBWtNetworkingStatus0:
            {
                // 刷新消息列表
                [self requestMessageListWithHud:nil];
            }
                break;
            default:
                break;
        }
        
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 标记为已读消息
- (void)readMessageRequestWithModel:(MessageModel *)model {
//    __weak __typeof__(self) weakSelf = self;
//    MBProgressHUD *hud = [CBWtMINUtils hudToView: self.view withText: Localized(@"MINHud_Loading")];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[@"id"] = model.messageId;
//    [[CBWtNetWorkingManager shared] getWithUrl: @"watch/persion/isReadMessage" params: dic succeed:^(id response, BOOL isSucceed) {
//        if (isSucceed) {
//            NotifactionDetailViewController *notificationDetailVC = [[NotifactionDetailViewController alloc] init];
//            notificationDetailVC.model = model;
//            [weakSelf.navigationController pushViewController: notificationDetailVC animated: YES];
//            [hud hideAnimated: YES];
//        }else {
//            [hud hideAnimated: YES];
//        }
//    } failed:^(NSError *error) {
//        [hud hideAnimated: YES];
//    }];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:model.messageId?:@"" forKey:@"id"];
    [[CBWtNetworkRequestManager sharedInstance] readMessageParamters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        switch (baseModel.status) {
            case CBWtNetworkingStatus0:
            {
//                NotifactionDetailViewController *notificationDetailVC = [[NotifactionDetailViewController alloc] init];
//                notificationDetailVC.model = model;
//                [self.navigationController pushViewController: notificationDetailVC animated: YES];
            }
                break;
            default:
                break;
        }
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 删除消息
- (void)deleMessageRequest
{
    NSMutableArray *delArr = [NSMutableArray array];
    for (MessageModel *model in self.dataArr) {
        if (model.isCheck && model.isEdit) {
            [delArr addObject: model.messageId];
        }
    }
    if (delArr.count == 0) {
        [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"请输入你要删除的消息")];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    kWeakSelf(self);
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"ids"] = [delArr componentsJoinedByString: @","];
    [[CBWtNetWorkingManager shared] getWithUrl: @"watch/persion/delMyMessage" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [weakSelf rightBtnClick: weakSelf.navigationItem.rightBarButtonItems.lastObject.customView];
            [weakSelf requestMessageListWithHud: nil];
        }else {
            
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
