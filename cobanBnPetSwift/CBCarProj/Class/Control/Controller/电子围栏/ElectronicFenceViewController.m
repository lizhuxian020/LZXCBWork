//
//  ElectronicFenceViewController.m
//  Telematics
//
//  Created by lym on 2017/12/11.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "ElectronicFenceViewController.h"
#import "ElectronicFenceHeaderView.h"
#import "ElectornicFenceTableViewCell.h"
#import "MINAlertView.h"
#import "NewElectronicFenceView.h"
#import "MINPickerView.h"
#import "NewFenceViewController.h"
#import "FenceListModel.h"
#import "FenceDetailViewController.h"

@interface ElectronicFenceViewController () <UITableViewDelegate, UITableViewDataSource, MINPickerViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NewElectronicFenceView *eletronicView;
@property (nonatomic, copy) NSArray *alramTypeArr;
@property (nonatomic, copy) NSArray *modelArr;
@property (nonatomic, copy) NSArray *fenceShapeTypeImageStrArr;
@end

@implementation ElectronicFenceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self addGesture];
    self.alramTypeArr = @[@[Localized(@"出围栏报警"),Localized(@"入围栏报警"), Localized(@"出入围栏报警"),Localized(@"位移报警")]];
    self.fenceShapeTypeImageStrArr = @[@"电子围栏-多边形", @"电子围栏-圆形", @"电子围栏-正方形", @"路线"];
}
#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"电子围栏") isBack: YES];
    [self showBackGround];
    [self initBarRighBtnTitle:Localized(@"新增") target: self action: @selector(rightBtnClick)];
    [self createTableView];
}

- (void)createTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    kWeakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        kStrongSelf(self);
        [self requestData];
    }];
}
#pragma mark -- 获取设备围栏列表
- (void)requestData
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devControlController/getFenceListByName" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"电子围栏数据:%@",response);
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dic in response[@"data"]) {
                    FenceListModel *model = [FenceListModel mj_objectWithKeyValues:dic];
//                    if (model.warmType != 3) {
//                        [array addObject: model];
//                    }
                    [array addObject: model];
                }
                weakSelf.modelArr = array;
            } else {
                weakSelf.modelArr = nil;
            }
        }
        [weakSelf.tableView reloadData];
        self.noDataView.hidden = self.modelArr.count == 0?NO:YES;
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - addGesture
- (void)addGesture
{
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}
#pragma mark - Action
- (void)rightBtnClick
{
    __weak __typeof__(self) weakSelf = self;
    MINAlertView *alertView = [[MINAlertView alloc] init];
    __weak MINAlertView *weakAlertView = alertView;
    alertView.titleLabel.text = Localized(@"新增围栏");
    [weakSelf.view addSubview: alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    // 重置高度
    [alertView setContentViewHeight: 160];
    NewElectronicFenceView *newView = [[NewElectronicFenceView alloc] init];
    weakSelf.eletronicView = newView;
    weakSelf.eletronicView.speedTextField.keyboardType = UIKeyboardTypeNumberPad;
    newView.alramTypeBtnClickBlock = ^{
        MINPickerView *pickerView = [[MINPickerView alloc] init];
        pickerView.titleLabel.text = @"";
        pickerView.dataArr = weakSelf.alramTypeArr;
        pickerView.delegate = self;
        [weakSelf.view addSubview: pickerView];
        [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_equalTo(SCREEN_HEIGHT);
        }];
        [pickerView showView];
    };
    [weakAlertView.contentView addSubview: newView];
    [newView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakAlertView.contentView);
    }];
    alertView.rightBtnClick = ^{
        [weakAlertView hideView];
        // 修改model的数据，不要忘记了
        NSLog(@"%@ %@ %@", weakSelf.eletronicView.fenceNameTextField.text, weakSelf.eletronicView.speedTextField.text, weakSelf.eletronicView.alramTypeBtn.titleLabel.text);
        FenceListModel *model = [[FenceListModel alloc] init];
        model.name = weakSelf.eletronicView.fenceNameTextField.text;
        model.speed = weakSelf.eletronicView.speedTextField.text;
        if (weakSelf.eletronicView.fenceNameTextField.text.length < 1) {
            [MINUtils showProgressHudToView: weakSelf.view withText: @"请输入围栏名称"];
            return ;
        }
        if (weakSelf.eletronicView.speedTextField.text.length < 1) {
            [MINUtils showProgressHudToView: weakSelf.view withText: @"请输入限速"];
            return ;
        }
        NSArray *arr = weakSelf.alramTypeArr[0];
        for (int i = 0; i < arr.count;  i++) {
            if ([arr[i] isEqualToString: weakSelf.eletronicView.alramTypeBtn.titleLabel.text]) {
                model.warmType = i;
            }
        }
        NewFenceViewController *fenceVC = [[NewFenceViewController alloc] init];
        fenceVC.isCreateFence = YES;
        fenceVC.model = model;
        [weakSelf.navigationController pushViewController: fenceVC animated: YES];
    };
    alertView.leftBtnClick = ^{
        [weakAlertView hideView];
    };
}
#pragma mark - tableview delegate & datasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.modelArr.count > indexPath.row) {
        FenceDetailViewController *fenceDetailVC = [[FenceDetailViewController alloc] init];
        fenceDetailVC.model = self.modelArr[indexPath.row];
        [self.navigationController pushViewController: fenceDetailVC animated: YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"ElectronicFenceTableViewCell";
    static NSString *cellIndentifyLast = @"ElectronicFenceTableViewCellLast";
    ElectornicFenceTableViewCell *cell = nil;
    if (indexPath.row != self.modelArr.count - 1) {
        cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
        if (cell == nil) {
            cell = [[ElectornicFenceTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIndentify];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifyLast];
        if (cell == nil) {
            cell = [[ElectornicFenceTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIndentifyLast];
        }
    }
    if (indexPath.row != self.modelArr.count - 1) {
        [cell addBottomLineView];
    }
    FenceListModel *model = self.modelArr[indexPath.row];
    cell.fenceNameLabel.text = [NSString stringWithFormat:@"%@",model.name?:@""];
    [cell.fenceTypeImageBtn setImage: [UIImage imageNamed: self.fenceShapeTypeImageStrArr[model.shape]] forState: UIControlStateNormal];
    [cell.fenceTypeImageBtn setImage: [UIImage imageNamed: self.fenceShapeTypeImageStrArr[model.shape]] forState: UIControlStateHighlighted];
    cell.deviceLbl.text = model.deviceName;
    cell.speedLabel.text = [NSString stringWithFormat: @"%@KM/h", model.speed];
    cell.alarmTypeLabel.text = self.alramTypeArr[0][model.warmType];
    cell.isOver = YES;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ElectronicFenceHeaderView *headView = [[ElectronicFenceHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 62.5 * KFitHeightRate)];
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 62.5 * KFitHeightRate;
}

#pragma mark - PickerViewDelegate
- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic
{
    NSNumber *number = dic[@"0"];
    NSString *title = self.alramTypeArr[0][[number integerValue]];
    [self.eletronicView.alramTypeBtn setTitle: title forState: UIControlStateNormal];
    [self.eletronicView.alramTypeBtn setTitle: title forState: UIControlStateHighlighted];
    //    ControlTableViewCell *cell = [self.tableView cellForRowAtIndexPath: self.currentIndexPath];
    //    cell.detailLabel.text = self.restArr[0][[number integerValue]];
}


#pragma mark - UIGestureRecognizerDelegate
// 防止手势与tableView冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 点击了tableViewCell，view的类名为UITableViewCellContentView，则不接收Touch点击事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
