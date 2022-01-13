//
//  CBTalkListViewController.m
//  cobanBnWatch
//
//  Created by coban on 2019/12/4.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBTalkListViewController.h"
#import "CBTalkListTableView.h"
#import "CBTalkModel.h"
#import "CBTalkListTableViewCell.h"
#import "CBHomeTalkViewController.h"
#import "CBSingTalkViewController.h"

@interface CBTalkListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) CBTalkListTableView *talkListTableView;
@property (nonatomic,strong) NSMutableArray *arrayData;
@end

@implementation CBTalkListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getChatListRequset];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTalkListData) name:KCBWtSingleChatNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTalkListData) name:KCBWtGroupChatNotification object:nil];
}
- (void)updateTalkListData {
    [self.arrayData removeAllObjects];
    [self getChatListRequset];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KCBWtSingleChatNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KCBWtGroupChatNotification object:nil];
}
- (void)setupView {
    self.view.backgroundColor = UIColor.whiteColor;//KWtBackColor;
    [self initBarWithTitle:Localized(@"语聊") isBack:YES];
    
    [self talkListTableView];
}
#pragma mark -- setting && getting
- (CBTalkListTableView *)talkListTableView {
    if (!_talkListTableView) {
        _talkListTableView = [[CBTalkListTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - PPNavigationBarHeight - TabPaddingBARHEIGHT) style:UITableViewStylePlain];
        [self.view addSubview:_talkListTableView];
        _talkListTableView.delegate = self;
        _talkListTableView.dataSource = self;
        _talkListTableView.backgroundColor = [UIColor whiteColor];
        kWeakSelf(self);
        _talkListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            kStrongSelf(self);
            [self.arrayData removeAllObjects];
            [self getChatListRequset];
        }];
//        _talkListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            kStrongSelf(self);
//            [self.arrayData removeAllObjects];
//            [self getChatListRequset];
//        }];
    }
    return _talkListTableView;
}
- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}
#pragma mark -- 获取聊天列表
- (void)getChatListRequset {
    [self.arrayData removeAllObjects];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[HomeModel CBDevice].tbWatchMain.sno?:@"" forKey:@"sno"];
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] getChatListParamters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",baseModel.data);

        NSArray *array = baseModel.data;
        NSLog(@"+++++聊天记录++++++++:%@",array);
        if (array.count > 0) {
            for (NSDictionary *dic in array) {
                CBTalkListModel *model = [CBTalkListModel mj_objectWithKeyValues:dic];
                [self.arrayData addObject:model];
            }
        }
        [self.talkListTableView reloadData];
        [self.talkListTableView.mj_header endRefreshing];
        [self.talkListTableView.mj_footer endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.talkListTableView.mj_header endRefreshing];
        [self.talkListTableView.mj_footer endRefreshing];
    }];
}
#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBTalkListTableViewCell *cell;
    cell = [CBTalkListTableViewCell cellCopyTableView:tableView];
    if (self.arrayData.count > indexPath.row) {
        CBTalkListModel *model = self.arrayData[indexPath.row];
        cell.talkListModel = model;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrayData.count > indexPath.row) {
        CBTalkListModel *model = self.arrayData[indexPath.row];
        if ([model.ids isEqualToString:@"1"]) {
            // 群聊
            CBHomeTalkViewController *vc = [CBHomeTalkViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([model.ids isEqualToString:@"2"]) {
            // 单聊
            CBSingTalkViewController *vc = [CBSingTalkViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}
#pragma mark - tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
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
