//
//  PhoneBookViewController.m
//  Telematics
//
//  Created by lym on 2017/11/30.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "PhoneBookViewController.h"
#import "PhoneBookTableViewCell.h"
#import "MINPickerView.h"
#import "PhoneBookModel.h"
#import "MINAlertView.h"
#import "CBAddAddressBKView.h"
#import "CBControlAlertPopView.h"
#import "CBPhoneBookHeaderView.h"
#import "CBPhoneBookAlertView.h"

@interface PhoneBookViewController () <UITableViewDelegate, UITableViewDataSource, MINPickerViewDelegate, PhoneBookTableViewCellDelegate>
{
    BOOL keyboardIsShown;
}
@property (nonatomic, strong) NSMutableArray *dataArr;
//@property (nonatomic, strong) NSMutableArray *editArr;
//@property (nonatomic, strong) NSMutableArray *addArr;
@property (nonatomic, copy) NSArray *phoneTypeArr;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, strong) CBAddAddressBKView *addAddresBKView;
/** 警告弹窗 */
@property (nonatomic, strong) CBControlAlertPopView *alertPopView;
@property (nonatomic,strong) NSIndexPath *deleteIndexPath;
@end

@implementation PhoneBookViewController

-(void)viewWillAppear:(BOOL)animated{
    [IQKeyboardManager sharedManager].enable = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    
    self.dataArr = [NSMutableArray array];
//    self.editArr = [NSMutableArray array];
//    self.addArr = [NSMutableArray array];
    self.phoneTypeArr = @[@[Localized(@"允许呼入"), Localized(@"允许呼出"), Localized(@"允许呼入/呼出"), Localized(@"第一授权号码"), Localized(@"授权号码"), Localized(@"平台短信中心号码"), Localized(@"复位设备号码"), Localized(@"恢复出厂设置号码")]];
    [self requestDataWithHud:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(requestDataWithHud:) name:@"CBCAR_NOTFICIATION_GETMQTT_CODE2" object:nil];
}
- (CBControlAlertPopView *)alertPopView {
    if (!_alertPopView) {
        _alertPopView = [[CBControlAlertPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        //_alertPopView.delegate = self;
    }
    return _alertPopView;
}
- (void)setupView {
    [self initBarWithTitle:Localized(@"设置电话本") isBack: YES];
    [self initBarRightImageName:@"添加" target:self action:@selector(didClickAddPhone)];
    self.view.backgroundColor = kRGB(247, 247, 247);
    
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    kWeakSelf(self);
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [weakself requestDataWithHud:nil];
    }];
    
}
#pragma mark -- 根据设备号获取设备授权号码列表
- (void)requestDataWithHud:(MBProgressHUD *)hud {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devParamController/getDevParamAuthList" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                [self.dataArr removeAllObjects];
                for (NSDictionary *dic in  response[@"data"]) {
                    PhoneBookModel *model = [PhoneBookModel yy_modelWithDictionary: dic];
                    [self.dataArr addObject: model];
                }
                [self.tableView reloadData];
//                [self.addArr removeAllObjects];
//                [self.editArr removeAllObjects];
            }
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)didClickAddPhone {
    [self showPhonePopView:nil];
}
- (void)showPhonePopView:(PhoneBookModel *)phoneModel {
    
    CBPhoneBookAlertView *contentView = [CBPhoneBookAlertView new];
    contentView.phoneModel = phoneModel;
    
    CBAlertBaseView *alertView = [[CBAlertBaseView alloc] initWithContentView:contentView title:Localized(phoneModel ? @"编辑": @"添加")];
    
    __weak CBPhoneBookAlertView *wContentView = contentView;
    CBBasePopView *popView = [[CBBasePopView alloc] initWithContentView:alertView];
    __weak CBBasePopView *wpopView = popView;
    kWeakSelf(self);
    [alertView setDidClickConfirm:^{
        if ([wContentView canDismiss]) {
            [wpopView dismiss];
            NSDictionary *param = [wContentView getRequestParam];
            if (phoneModel) {
                [weakself editPhoneReqeust:param];
            } else {
                [weakself addNewPhoneBookRequest:param];
            }
            
        }
    }];
    [alertView setDidClickCancel:^{
        [wpopView dismiss];
    }];
    
    [popView pop];
}
#pragma mark -- 新增电话本request
- (void)addNewPhoneBookRequest:(NSDictionary *)param {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic addEntriesFromDictionary:param];
    dic[@"dno"] = self.deviceInfoModelSelect.dno?:@"";
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devParamController/sendDevParamAuth" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CBTopAlertView alertSuccess:Localized(@"操作成功")];
        if (isSucceed) {
            [self requestDataWithHud:nil];
//            [self.addArr removeAllObjects];
//            [self.editArr removeAllObjects];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 编辑电话本request
- (void)editPhoneReqeust:(NSDictionary *)param {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic addEntriesFromDictionary:param];
    dic[@"dno"] = self.deviceInfoModelSelect.dno?:@"";
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devParamController/editDevParamAuth" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CBTopAlertView alertSuccess:Localized(@"操作成功")];
        [self requestDataWithHud:nil];
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self requestDataWithHud:nil];
    }];
}
#pragma mark -- 编辑或新增弹框

#pragma mark - tableView delegate & dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45 * KFitHeightRate;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CBPhoneBookHeaderView *headView = [[CBPhoneBookHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 45 * KFitHeightRate)];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.5 * KFitHeightRate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"PhoneBookCellIndentify";
    PhoneBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
    if (cell == nil) {
        cell = [[PhoneBookTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIndentify];
    }
    [cell addLeftSwipeGesture];
    [cell hideDeleteBtn];
    __weak typeof(self) weakSelf = self;
    [cell setDeleteBtnClick:^(NSIndexPath *indexPath) {
        [weakSelf deleteAlertPopClick:indexPath];
    }];
    [cell setEditBtnClick:^(NSIndexPath *indexPath) {
        [weakSelf showPhonePopView:self.dataArr[indexPath.row]];
    }];
    cell.cellDelegate = self;
    cell.indexPath = indexPath;
    if (indexPath.row < self.dataArr.count) {
        PhoneBookModel *model = self.dataArr[indexPath.row];
        cell.nameTextFeild.text = model.name;
        cell.phoneTextFeild.text = model.phone;
        cell.phoneTypeTitleLabel.text = [NSString stringWithFormat:@"%@",weakSelf.phoneTypeArr[0][model.type]];
        model.indexPath = indexPath;
    }
    cell.deleteBtnClickBlock = ^(NSIndexPath *indexPath) {
        [weakSelf deleteAlertPopClick:indexPath];
    };
    return cell;
}
#pragma mark -- 删除
- (void)deleteAlertPopClick:(NSIndexPath *)indexPath {
    self.deleteIndexPath = indexPath;
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:Localized(@"确定删除?") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self deletePhoneBookReqeust];
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}
#pragma mark -- 删除电话本request
- (void)deletePhoneBookReqeust {
    
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    PhoneBookModel *model = self.dataArr[self.deleteIndexPath.row];//self.dataArr[indexPath.row];
    dic[@"aid"] = model.phoneId;
    dic[@"imei"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devParamController/delDevParamAuth" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CBTopAlertView alertSuccess:Localized(@"操作成功")];
        if (isSucceed) {
            [weakSelf requestDataWithHud:nil];
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
