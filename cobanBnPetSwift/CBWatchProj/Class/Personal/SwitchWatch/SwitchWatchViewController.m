//
//  SwitchWatchViewController.m
//  Watch
//
//  Created by lym on 2018/2/28.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "SwitchWatchViewController.h"
#import "AutoReceiveTableViewCell.h"
#import "CBEditWatchInfoTableViewCell.h"
#import "WatchModel.h"
#import "HomeModel.h"

@interface SwitchWatchViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, copy) NSArray *imageArr;
@end

@implementation SwitchWatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self requestBindWatch];
    self.imageArr = @[@"爸爸", @"妈妈", @"姐姐", @"爷爷", @"奶奶", @"哥哥", @"外公", @"外婆", @"老师", @"自定义", @"校讯通"];
}
#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"切换手表") isBack: YES];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}
#pragma mark -- 获取绑定的手表信息
- (void)requestBindWatch {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] getWithUrl: @"watch/persion/getBindWatch" params: nil succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass: [NSArray class]]) {
                NSMutableArray *modelArr = [NSMutableArray array];
                for (NSDictionary *dic in  response[@"data"]) {
                    WatchModel *model = [WatchModel yy_modelWithDictionary: dic];
                    [modelArr addObject: model];
                }
                self.dataArr = modelArr;
                [self.tableView reloadData];
            }
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - tableView delegate & dataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > indexPath.row) {
        WatchModel *model = self.dataArr[indexPath.row];
        [self switchWatchWithSno: model.sno];
//        if ([model.sno isEqualToString: [AppDelegate shareInstance].currentWatchModel.tbWatchMain.sno] == NO) {
//
//            [self switchWatchWithSno: model.sno];
//        } else {
//
//            [self.navigationController popViewControllerAnimated: YES];
//        }
    }
}
#pragma mark -- 切换用户
- (void)switchWatchWithSno:(NSString *)sno {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"sno"] = sno;
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/persion/changeBindWatch" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (self.returnBlock) {
                self.returnBlock(@"");
            }
            HomeModel *deviceModel = [HomeModel CBDevice];
            deviceModel.tbWatchMain.sno = sno;
            [HomeModel saveCBDevice:deviceModel];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentify = @"CBEditWatchInfoTableViewCell";
    CBEditWatchInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: indentify];
    if (cell == nil) {
        cell = [[CBEditWatchInfoTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: indentify];
    }
    if (self.dataArr.count > indexPath.row) {
        WatchModel *model = self.dataArr[indexPath.row];
        if ([model.sno isEqualToString:[HomeModel CBDevice].tbWatchMain.sno] == NO) {//[AppDelegate shareInstance].currentWatchModel.sno]
            cell.selectBtn.selected = NO;
        } else {
            cell.selectBtn.selected = YES;
        }
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"默认宝贝头像"]]]; //个人中心默认头像 [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageArr[model.type]]]
        cell.nameLabel.text = model.name?:Localized(@"小诺");
        cell.phoneLabel.text = model.phone?:Localized(@"未知");
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 15 + 50*frameSizeRate + 15 + 15;//80 * KFitWidthRate;
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
