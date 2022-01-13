//
//  ForbiddenInClassViewController.m
//  Watch
//
//  Created by lym on 2018/2/11.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "ForbiddenInClassViewController.h"
#import "ForbiddenInClassTableViewCell.h"
#import "ForbiddenDetailOrAddForBiddenTimeViewController.h"
#import "ForbiddenInClassModel.h"
#import "MINSwitchView.h"
#import "SwitchView.h"

/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

@interface ForbiddenInClassViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, copy) NSArray *dataArr;
@end

@implementation ForbiddenInClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self addAction];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self getGuardInfoData];
}
#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"上课禁用") isBack: YES];
    self.view.backgroundColor = KWtBackColor;
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"上课禁用"]];
    headerImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 4.0 / 7.5);
    [self.view addSubview:headerImageView];
    
    CGFloat width = [NSString getWidthWithText:Localized(@"添加禁用时间段") font:[UIFont fontWithName:CBPingFangSC_Regular size:14] height:40];
    self.addBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"添加禁用时间段") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: KWtBlueColor];
    self.addBtn.titleLabel.font = [UIFont fontWithName:CBPingFangSC_Regular size:14];
    self.addBtn.layer.cornerRadius = 18 * KFitWidthRate;
    [self.view addSubview: self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.bottom.equalTo(footerView.mas_bottom).with.offset(-12.5 * KFitWidthRate);
        make.bottom.mas_equalTo(-TabPaddingBARHEIGHT-12.5);
        make.size.mas_equalTo(CGSizeMake(width + 40*frameSizeRate, 38*frameSizeRate));
        make.centerX.equalTo(self.view);
    }];
    
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(headerImageView.mas_bottom);
        make.bottom.mas_equalTo(self.addBtn.mas_top).offset(-12.5);
    }];
}
#pragma mark -- 获取上课禁用时间段列表
- (void)getGuardInfoData
{
    self.dataArr = @[];
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] getWithUrl: @"watch/watch/getClassForbidList" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed && response && [response[@"data"] isKindOfClass: [NSArray class]]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in response[@"data"]) {
                ForbiddenInClassModel *model = [ForbiddenInClassModel yy_modelWithDictionary: dic];
                [arr addObject: model];
            }
            weakSelf.dataArr = arr;
        }
        [weakSelf.tableView reloadData];
        self.noDataView.hidden = weakSelf.dataArr.count == 0?NO:YES;
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 编辑上课禁用时间段
- (void)editForbiddenTimeRequestIsOn:(BOOL)isOn model:(ForbiddenInClassModel *)model {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
    if (isOn == YES) {
        dic[@"action"] = @1;
    } else {
        dic[@"action"] = @0;
    }
    dic[@"id"] = model.forbiddenId;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/updClassForbid" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed ) {
            [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"修改成功")];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - Action
- (void)addAction
{
    [self.addBtn addTarget: self action: @selector(addBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)addBtnClick
{
    ForbiddenDetailOrAddForBiddenTimeViewController *addForBiddenVC = [[ForbiddenDetailOrAddForBiddenTimeViewController alloc] init];
    addForBiddenVC.isEdit = NO;
    [self.navigationController pushViewController: addForBiddenVC animated: YES];
}
- (void)toEditClickModel:(ForbiddenInClassModel *)model {
    ForbiddenDetailOrAddForBiddenTimeViewController *editForBiddenVC = [[ForbiddenDetailOrAddForBiddenTimeViewController alloc] init];
    editForBiddenVC.isEdit = YES;
    editForBiddenVC.model = model;
    [self.navigationController pushViewController: editForBiddenVC animated: YES];
}
#pragma mark - tableView delegate & dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"ForbiddenInClassTableViewCell";
    ForbiddenInClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: indentify];
    if (cell == nil) {
        cell = [[ForbiddenInClassTableViewCell alloc] init];
    }
    ForbiddenInClassModel *model = self.dataArr[indexPath.row];
    __weak __typeof__(self) weakSelf = self;
    cell.editBtnClickBlock = ^{
//        ForbiddenDetailOrAddForBiddenTimeViewController *editForBiddenVC = [[ForbiddenDetailOrAddForBiddenTimeViewController alloc] init];
//        editForBiddenVC.isEdit = YES;
//        editForBiddenVC.model = model;
//        [weakSelf.navigationController pushViewController: editForBiddenVC animated: YES];
        [weakSelf toEditClickModel:model];
    };
    cell.switchStatusChange = ^(BOOL isOn) {
        [weakSelf editForbiddenTimeRequestIsOn:isOn model:model];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
//        dic[@"sno"] = [AppDelegate shareInstance].currentSno;
//        if (isOn == YES) {
//            dic[@"action"] = @1;
//        }else {
//            dic[@"action"] = @0;
//        }
//        dic[@"id"] = model.forbiddenId;
//        MBProgressHUD *hud = [CBWtMINUtils hudToView: weakSelf.view withText: Localized(@"MINHud_Loading")];
//        [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/updClassForbid" params: dic succeed:^(id response, BOOL isSucceed) {
//            if (isSucceed ) {
//                [CBWtMINUtils showProgressHudToView: weakSelf.view withText: @"修改成功"];
//            }
//            [hud hideAnimated: YES];
//        } failed:^(NSError *error) {
//            [hud hideAnimated: YES];
//        }];
    };
    cell.switchView.titleLabel.text = model.name;
    cell.switchView.switchView.isON = model.action;
    cell.timePeriodLabel.text = [NSString stringWithFormat: @"%@ %@ - %@ %@ %@ - %@",Localized(@"早上-守护"), model.startAm, model.endAm, Localized(@"下午-守护"),model.startPm, model.endPm];
    cell.repeatLabel.text = [NSString stringWithFormat: @"%@：%@",Localized(@"重复"), [self getReatTimeWithString:model.repeat]];
    return cell;
}

- (NSString *)getReatTimeWithString:(NSString *)time
{
    NSMutableArray *detailDateArr = [NSMutableArray array];
    NSArray *dateArr = [time componentsSeparatedByString: @","];
    for (int i = 0; i < dateArr.count; i++) {
        if ([dateArr[i] integerValue] == 1) {
            [detailDateArr addObject:Localized(@"周一")];
        }else if ([dateArr[i] integerValue] == 2) {
            [detailDateArr addObject:Localized(@"周二")];
        }else if ([dateArr[i] integerValue] == 3) {
            [detailDateArr addObject:Localized(@"周三")];
        }else if ([dateArr[i] integerValue] == 4) {
            [detailDateArr addObject:Localized(@"周四")];
        }else if ([dateArr[i] integerValue] == 5) {
            [detailDateArr addObject:Localized(@"周五")];
        }else if ([dateArr[i] integerValue] == 6) {
            [detailDateArr addObject:Localized(@"周六")];
        }else if ([dateArr[i] integerValue] == 7) {
            [detailDateArr addObject:Localized(@"周日")];
        }
    }
    return [detailDateArr componentsJoinedByString: @"、"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132.5 * KFitWidthRate;
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
