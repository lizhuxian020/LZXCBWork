//
//  CBJIashiXingWeiViewController.m
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/16.
//  Copyright © 2023 coban. All rights reserved.
//

#import "CBJIashiXingWeiViewController.h"
#import "FormDateHeaderView.h"
#import "MINDatePickerView.h"
#import "FormDetailInfoViewController.h"
#import "CBJiaShiXingWeiCell.h"

@interface CBJIashiXingWeiViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString *leftHeaderText;
@property (nonatomic, strong) NSString *middleHeaderText;
@property (nonatomic, strong) NSString *rightHeaderText;
@property (nonatomic, assign) BOOL isShowRightCellLabel;
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *dateStringStart;
@property (nonatomic, copy) NSString *dateStringEnd;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) MINDatePickerView *pickerView;
@property (nonatomic, assign) NSInteger modelId ; /** <##> **/
@end

@implementation CBJIashiXingWeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    self.dateString = [self getCurrentTimeString];
    NSDictionary *dicTime = [CBCommonTools getSomeDayPeriod:[NSDate date]];
    self.dateStringStart = [NSString stringWithFormat:@"%@",dicTime[@"startTime"]];
    self.dateStringEnd = [NSString stringWithFormat:@"%@",dicTime[@"endTime"]];
    self.dataArr = [NSMutableArray array];
    [self requestData];
}


- (NSString *)getCurrentTimeString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 设置为东八区时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*3600];
    [formatter setTimeZone:timeZone];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}

#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = kBackColor;
    self.leftHeaderText = Localized(@"编号");
    self.middleHeaderText = Localized(@"时间");
    self.isShowRightCellLabel = YES;
    [self setHeaderText];
    CBHomeLeftMenuDeviceInfoModel *model = [CBCommonTools CBdeviceInfo];
    [self initBarWithTitle: model.name?:@"" isBack: YES];
    [self initBarRighWhiteBackBtnTitle:Localized(@"查询") target: self action:@selector(rightBtnClick)];
    [self createTableView];
}

#pragma mark -- 获取报表数据
- (void)requestData {
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";//[CBCommonTools CBdeviceInfo].dno?:@"";
    dic[@"startTime"] = self.dateStringStart;
    dic[@"endTime"] = self.dateStringEnd;
    dic[@"length"] = @100;
    dic[@"page"] = @1;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [self hiddenPromptView:YES];
    
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devReportController/getDrivingBehaviorReport" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view  animated:YES];
        NSLog(@"报表数据:===%@===",response);
        if (!isSucceed || !response[@"data"] || !response[@"data"][@"dataList"]) {
            return;
        }
        self.modelId = 0;
        [self.dataArr removeAllObjects];
        NSArray<CBJiaShiXingWeiModel *> *dataArr = [CBJiaShiXingWeiModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"dataList"]];
        [self.dataArr addObjectsFromArray:dataArr];
        for (CBJiaShiXingWeiModel *model in self.dataArr) {
            model.ids = [NSString stringWithFormat:@"%ld", ++self.modelId];
        }
        [weakSelf.tableView reloadData];
        self.noDataView.hidden = weakSelf.dataArr.count == 0?NO:YES;
        [self.tableView.mj_header endRefreshing];
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view  animated:YES];
        [self.dataArr removeAllObjects];
        [self.tableView reloadData];
        self.noNetworkView.hidden = NO;
        kWeakSelf(self);
        self.noNetworkView.reloadBlock = ^(id  _Nonnull objc) {
            kStrongSelf(self);
            [self requestData];
        };
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.view);
    }];
    [self.tableView registerClass:CBJiaShiXingWeiCell.class forCellReuseIdentifier:@"CBJiaShiXingWeiCell"];
    kWeakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        kStrongSelf(self);
        [self requestData];
    }];
}

- (void)setHeaderText
{
    self.middleHeaderText = Localized(@"起始时间");
    self.rightHeaderText = Localized(@"消息类型");
}

- (void)rightBtnClick
{
    [self.pickerView showView];
}

- (MINDatePickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[MINDatePickerView alloc] init];
        [self.view addSubview: _pickerView];
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        _pickerView.delegate = self;
    }
    return _pickerView;
}

#pragma mark - MINDatePickerViewDelegare
- (void)datePicker:(MINDatePickerView *)pickerView didSelectordate:(NSString *)dateString date:(NSDate *)date {
    NSLog(@"%@", dateString);
    self.dateString = dateString;
    NSDictionary *dicTime = [CBCommonTools getSomeDayPeriod:date];
    self.dateStringStart = [NSString stringWithFormat:@"%@",dicTime[@"startTime"]];
    self.dateStringEnd = [NSString stringWithFormat:@"%@",dicTime[@"endTime"]];
    [self requestData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBJiaShiXingWeiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBJiaShiXingWeiCell"];
    CBJiaShiXingWeiModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-  (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FormDateHeaderView *view = [[FormDateHeaderView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 50);
    view.leftLabel.text = self.leftHeaderText;
    view.middleLabel.text = self.middleHeaderText;
    view.rightLabel.text = self.rightHeaderText;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_HEIGHT, 1)];
}


@end
