//
//  CBOBDMsgViewController.m
//  Telematics
//
//  Created by coban on 2019/11/21.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBOBDMsgViewController.h"
#import "WatchCallChargeFooterView.h"
#import "CBOBDModel.h"
#import "ShortMessageTableViewCell.h"

@interface CBOBDMsgViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    WatchCallChargeFooterView *footerView;
}
@property (nonatomic, strong) NSMutableArray *selectStatusArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation CBOBDMsgViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self getOBDMsgListReuqest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}
- (void)setupView {
    [self initBarWithTitle:Localized(@"请求OBD消息") isBack: YES];
    self.view.backgroundColor = kRGB(247, 247, 247);
    [self initBarRighBtnTitle:Localized(@"编辑") selectTitle:Localized(@"完成") target:self action: @selector(rightBtnClick:)];
    
    kWeakSelf(self);
    footerView = [[WatchCallChargeFooterView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_HEIGHT, 65 * KFitWidthRate + 34)];
    [footerView.queryBtn setTitle:Localized(@"查询") forState:UIControlStateNormal];
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
        [self requestOBD];
    };
    footerView.deleteBtnClickBlock = ^{
        kStrongSelf(self);
        [self deleteOBD];
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
        make.top.mas_equalTo(self.view.mas_top).offset(PPNavigationBarHeight);
        make.bottom.mas_equalTo(footerView.mas_top).offset(-10);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        kStrongSelf(self);
        [self getOBDMsgListReuqest];
    }];
}
- (NSMutableArray *)selectStatusArr {
    if (!_selectStatusArr) {
        _selectStatusArr = [NSMutableArray array];
    }
    return _selectStatusArr;
}
#pragma mark -- 获取OBD消息列表
- (void)getOBDMsgListReuqest {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
    [paramters setObject:@"2" forKey:@"type"]; // type 2 为OBD
    [[CBNetworkRequestManager sharedInstance] getCallChargeParamters:paramters success:^(CBBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@",baseModel.data);
        //if (isSucceed && response && [response[@"data"] isKindOfClass: [NSArray class]]) {
        NSMutableArray *arr = [NSMutableArray array];
        [self.selectStatusArr removeAllObjects];
        for (NSDictionary *dic in baseModel.data) {
            CBOBDModel *model = [CBOBDModel yy_modelWithDictionary:dic];
            [arr addObject: model];
            [self.selectStatusArr addObject: @0];
        }
        //NSSortDescriptor *idSd = [NSSortDescriptor sortDescriptorWithKey: @"ids" ascending:NO];
        self.dataArr = arr;
        //[self.dataArr sortUsingDescriptors: @[idSd]];
        [self.tableView reloadData];
        self.noDataView.hidden = self.dataArr.count == 0?NO:YES;
        //}
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - Action
- (void)rightBtnClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected == NO) {
        button.selected = YES;
        [footerView changeStatus:YES];
        self.tableView.editing = YES;
    } else {
        button.selected = NO;
        [footerView changeStatus:NO];
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
    CBOBDModel *model = self.dataArr[indexPath.row];
    cell.senderLabel.text = @"";//model.phone;
    cell.timeLabel.text = @"";//[MINUtils getTimeFromTimestamp: model.createTime formatter: @"yyyy-MM-dd HH:mm:ss"];
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
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 60;
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
#pragma mark -- 查询OBD
- (void)requestOBD {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
    [paramters setObject:@"1" forKey:@"obdmsg"];
    kWeakSelf(self);
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[CBNetworkRequestManager sharedInstance] terminalSettingParamters:paramters success:^(CBBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (baseModel.status == CBNetworkingStatus0) {
            //[MINUtils showProgressHudToView:[AppDelegate shareInstance].window withText:Localized(@"发送成功")];
            [self getOBDMsgListReuqest];
        }
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 删除手表话费
- (void)deleteOBD {
    NSMutableArray *delIdArr = [NSMutableArray array];
    for (int i = 0; i < self.selectStatusArr.count; i++) {
        NSNumber *num = self.selectStatusArr[i];
        if ([num intValue] == 1) {
            CBOBDModel *model = self.dataArr[i];
            [delIdArr addObject: model.ids];
        }
    }
    if (delIdArr.count == 0) {
        //[MINUtils showProgressHudToView: self.view withText:Localized(@"请选择你要删除的短信")];
        return;
    }
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
    [paramters setObject:[delIdArr componentsJoinedByString: @","] forKey:@"ids"];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] getWithUrl: @"personController/delDeviceMsg" params:paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [self rightBtnClick:self.navigationItem.rightBarButtonItems.lastObject.customView];
            [self getOBDMsgListReuqest];
        } else {
            //[MINUtils showProgressHudToView:self.view withText:Localized(@"删除失败")];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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
