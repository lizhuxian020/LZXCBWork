//
//  EditCollectionMessageViewController.m
//  Watch
//
//  Created by lym on 2018/2/26.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "EditCollectionMessageViewController.h"
#import "ShortMessageTableViewCell.h"
#import "WatchCallChargeFooterView.h"
#import "CallChargeModel.h"

@interface EditCollectionMessageViewController () <UITableViewDataSource, UITableViewDelegate>
{
    WatchCallChargeFooterView *footerView;
}
@property (nonatomic, strong) NSMutableArray *selectStatusArr;
@end

@implementation EditCollectionMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    self.selectStatusArr = [NSMutableArray array];
    for (int i = 0 ; i < self.dataArr.count ; i ++ ) {
        [self.selectStatusArr addObject:@0];
    }
    //self.selectStatusArr = [NSMutableArray arrayWithArray: @[@0, @0, @0, @0, @0, @0]];
}
#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"代收短信管理") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"完成") target: self action: @selector(rightBtnClick)];
    
    kWeakSelf(self);
    footerView = [[WatchCallChargeFooterView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 65 * KFitWidthRate + 34)];
    [footerView changeStatus: YES];
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
            
            for (int i = 0; i < self.dataArr.count; i++) {
                [self.selectStatusArr replaceObjectAtIndex: i withObject: @1];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
                [self.tableView selectRowAtIndexPath: indexPath animated: YES scrollPosition: UITableViewScrollPositionTop];
            }
        } else {
            
            for (int i = 0; i < self.dataArr.count; i++) {
                [self.selectStatusArr replaceObjectAtIndex: i withObject: @0];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
                [self.tableView deselectRowAtIndexPath: indexPath animated: YES];
            }
        }
    };
    footerView.deleteBtnClickBlock = ^{
        kStrongSelf(self);
        [self deleWatchCallCharge];
    };
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 125 * KFitWidthRate;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.editing = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(footerView.mas_top).offset(-10);
    }];
}
#pragma mark - Action
- (void)rightBtnClick
{
    [self.navigationController popViewControllerAnimated: YES];
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
    if (self.dataArr.count > indexPath.row) {
        CallChargeModel *model = self.dataArr[indexPath.row];
        cell.senderLabel.text = model.phone;
        cell.timeLabel.text = [CBWtMINUtils getTimeFromTimestamp: model.createTime formatter: @"yyyy-MM-dd HH:mm:ss"];
        cell.messageLabel.text= model.content;
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

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    __weak __typeof__(self) weakSelf = self;
//    footerView = [[WatchCallChargeFooterView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 65 * KFitWidthRate + 34)];
//    [footerView changeStatus: YES];
//    footerView.checkAllBtnClickBlock = ^(BOOL isSelected) {
//        if (isSelected == YES) {
//            for (int i = 0; i < weakSelf.selectStatusArr.count; i++) {
//                [weakSelf.selectStatusArr replaceObjectAtIndex: i withObject: @1];
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
//                [weakSelf.tableView selectRowAtIndexPath: indexPath animated: YES scrollPosition: UITableViewScrollPositionTop];
//            }
//        }else {
//            for (int i = 0; i < weakSelf.selectStatusArr.count; i++) {
//                [weakSelf.selectStatusArr replaceObjectAtIndex: i withObject: @0];
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
//                [weakSelf.tableView deselectRowAtIndexPath: indexPath animated: YES];
//            }
//        }
//
//    };
//    footerView.deleteBtnClickBlock = ^{
//        [weakSelf deleWatchCallCharge];
//    };
//    return footerView;
//}
#pragma mark -- 删除手表短信
- (void)deleWatchCallCharge
{
    NSMutableArray *delIdArr = [NSMutableArray array];
    for (int i = 0; i < self.selectStatusArr.count; i++) {
        NSNumber *num = self.selectStatusArr[i];
        if ([num intValue] == 1) {
            CallChargeModel *model = self.dataArr[i];
            [delIdArr addObject: model.callChargeId];
        }
    }
    if (delIdArr.count == 0) {
        [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"请选择你要删除的短信")];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"ids"] = [delIdArr componentsJoinedByString: @","];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/commonly/delWatchMsg" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [weakSelf.navigationController popViewControllerAnimated: YES];
        }else {
            [CBWtMINUtils showProgressHudToView: weakSelf.view withText:Localized(@"短信删除失败")];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 65 * KFitWidthRate + 34;
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
