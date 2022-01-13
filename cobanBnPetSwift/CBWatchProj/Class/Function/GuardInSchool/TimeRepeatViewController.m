//
//  TimeRepeatViewController.m
//  Watch
//
//  Created by lym on 2018/2/10.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "TimeRepeatViewController.h"
#import "TimeRepeatTableViewCell.h"

@interface TimeRepeatViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *selectStatusArr;
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic,strong) UIButton *btnComfirm;
@end

@implementation TimeRepeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    self.selectStatusArr = [NSMutableArray arrayWithObjects: @0, @0, @0, @0, @0, @0, @0, nil];
    self.dataArr = @[Localized(@"星期一"), Localized(@"星期二"), Localized(@"星期三"), Localized(@"星期四"), Localized(@"星期五"), Localized(@"星期六"), Localized(@"星期日")];
}

#pragma mark - Action
- (void)comfirmClick
{
    NSMutableArray *dateArr = [NSMutableArray array];
    for (int i = 0; i < self.selectStatusArr.count; i++) {
        if ([self.selectStatusArr[i] integerValue] == 1) {
            [dateArr addObject: [NSNumber numberWithInteger: i+1]];
        }
    }
    NSString *dateString = [dateArr componentsJoinedByString: @","];
    [self.delegate timeRepeatViewControllerDidSelectTime: dateString];
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"重复") isBack: YES];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self btnComfirm];
}
- (UIButton *)btnComfirm {
    if (!_btnComfirm) {
        CGFloat width = [NSString getWidthWithText:Localized(@"确定") font:[UIFont fontWithName:CBPingFangSC_Regular size:14] height:50];
        _btnComfirm = [UIButton new];
        [_btnComfirm setTitle:Localized(@"确定") forState:UIControlStateNormal];
        [_btnComfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnComfirm.titleLabel.font = [UIFont fontWithName:CBPingFangSC_Regular size:14];
        _btnComfirm.backgroundColor = KWtAppMainColor;
        _btnComfirm.layer.masksToBounds = YES;
        _btnComfirm.layer.cornerRadius = 20;
        [self.view addSubview:_btnComfirm];
        [_btnComfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-TabPaddingBARHEIGHT-40);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(width + 60);
        }];
        [_btnComfirm addTarget:self action:@selector(comfirmClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnComfirm;
}
#pragma mark - tableView delegate & dataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *selectStatusNum = self.selectStatusArr[indexPath.row];
    TimeRepeatTableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
    if ([selectStatusNum integerValue] == 0) {
        [self.selectStatusArr replaceObjectAtIndex: indexPath.row withObject: @1];
        cell.selectBtn.selected = YES;
    }else {
        [self.selectStatusArr replaceObjectAtIndex: indexPath.row withObject: @0];
        cell.selectBtn.selected = NO;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"TimeRepeatTableViewCellIndentify";
    TimeRepeatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: indentify];
    if (cell == nil) {
        cell = [[TimeRepeatTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: indentify];
    }
    cell.repeatTimeLabel.text = self.dataArr[indexPath.row];
    NSNumber *selectStatusNum = self.selectStatusArr[indexPath.row];
    if ([selectStatusNum integerValue] == 0) {
        cell.selectBtn.selected = NO;
    }else {
        cell.selectBtn.selected = YES;
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
    return 50 * KFitWidthRate;
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
