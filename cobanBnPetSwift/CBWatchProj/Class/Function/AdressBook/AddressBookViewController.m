//
//  AddressBookViewController.m
//  Watch
//
//  Created by lym on 2018/2/7.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "AddressBookViewController.h"
#import "AddressBookTableViewCell.h"
#import "AddressBookHeaderView.h"
#import "BabyInfoViewController.h"
#import "CBAddressBKDetailViewController.h"
#import "CBPickRelationshipVC.h"
#import "AddressBookModel.h"
#import "HomeModel.h"

@interface AddressBookViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, strong) UIButton *addFamilyBtn;
@end

@implementation AddressBookViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self requestAddressBookList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
#pragma mark -- 获取通讯录列表
- (void)requestAddressBookList {
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] getWithUrl: @"watch/watch/getConnectList" params:paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            NSLog(@"通讯录列表:%@",response);
            if (response && [response[@"data"] isKindOfClass: [NSArray class]]) {
                NSMutableArray *modelArr = [NSMutableArray array];
                for (NSDictionary *dic in response[@"data"]) {
                    AddressBookModel *model = [AddressBookModel yy_modelWithDictionary: dic];
                    [modelArr addObject: model];
                }
                weakSelf.dataArr = modelArr;
                [weakSelf.tableView reloadData];
            }
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - Action
#pragma mark - 添加联系人
- (void)addFamilyBtnClick {
    CBPickRelationshipVC *addFamilyVC = [[CBPickRelationshipVC alloc] init];
    addFamilyVC.isAddContact = YES;
    [self.navigationController pushViewController: addFamilyVC animated: YES];
}
#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"通讯录") isBack: YES];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(-TabPaddingBARHEIGHT-12.5*frameSizeRate-44*frameSizeRate-10*frameSizeRate);
    }];
    
    [self addFamilyBtn];
}
- (UIButton *)addFamilyBtn {
    if (!_addFamilyBtn) {
        _addFamilyBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"添加联系人") titleColor: [UIColor whiteColor] fontSize:18*frameSizeRate backgroundColor: KWtBlueColor];
        [self.view addSubview:self.addFamilyBtn];
        _addFamilyBtn.layer.cornerRadius = 20*KFitWidthRate;
        [_addFamilyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.bottom.mas_equalTo(-12.5*frameSizeRate-TabPaddingBARHEIGHT);
            make.size.mas_equalTo(CGSizeMake(140*frameSizeRate, 40*frameSizeRate));
        }];
        [_addFamilyBtn addTarget: self action: @selector(addFamilyBtnClick) forControlEvents: UIControlEventTouchUpInside];
    }
    return _addFamilyBtn;
}
#pragma mark - tableview delegate & dataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    EditFamilyInfoViewController *editFamilyVC = [[EditFamilyInfoViewController alloc] init];
//    AddressBookModel *model = self.dataArr[indexPath.row];
//    editFamilyVC.model = model;
//    [self.navigationController pushViewController: editFamilyVC animated: YES];
    
    if (self.dataArr.count > 0) {
        CBAddressBKDetailViewController *addressBKDetailVC = [[CBAddressBKDetailViewController alloc] init];
        AddressBookModel *model = self.dataArr[indexPath.row];
        addressBKDetailVC.model = model;
        [self.navigationController pushViewController:addressBKDetailVC animated: YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"AddressBookTableViewCellIndentify";
    AddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
    if (cell == nil) {
        cell = [[AddressBookTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIndentify];
    }
    if (self.dataArr.count > indexPath.row) {
        AddressBookModel *model = self.dataArr[indexPath.row];
        cell.addressModel = model;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 92.5 * KFitWidthRate)];
    headerView.backgroundColor = KWtRGB(237, 237, 237);
    AddressBookHeaderView *mainHaaderView = [[AddressBookHeaderView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 80 * KFitWidthRate)];
    HomeModel *model = [HomeModel CBDevice];//[AppDelegate shareInstance].currentWatchModel;
    [mainHaaderView.headImageView sd_setImageWithURL: [NSURL URLWithString: model.tbWatchMain.head] placeholderImage: [UIImage imageNamed: @"姐姐"]];
    mainHaaderView.phoneLabel.text = model.tbWatchMain.phone;
    mainHaaderView.nameLabel.text = model.tbWatchMain.name;
    [headerView addSubview: mainHaaderView];
    __weak __typeof__(self) weakSelf = self;
    mainHaaderView.editBtnClickBlock = ^{
        BabyInfoViewController *babyInfoVC = [[BabyInfoViewController alloc] init];
        [weakSelf.navigationController pushViewController: babyInfoVC animated: YES];
    };
    return headerView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 92.5 * KFitWidthRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80 * KFitWidthRate;
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
