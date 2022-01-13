//
//  ChangeLanguageViewController.m
//  Telematics
//
//  Created by lym on 2017/11/14.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "ChangeLanguageViewController.h"
#import "AlarmTypeTableViewCell.h"
#import "MainTabBarViewController.h"

@interface ChangeLanguageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataStateArr;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;
@end

@implementation ChangeLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    self.dataStateArr = [NSMutableArray arrayWithArray: @[@1,@0,@0,@0]];
    self.dataArr = @[@"简体中文",@"繁体中文",@"English",@"其他"];
    self.lastSelectedIndexPath = [NSIndexPath indexPathForRow: 0 inSection:0];
}
#pragma mark - CreateAction
- (void)confirmBtnClick
{
    for (int i = 0 ; i < self.dataStateArr.count ; i ++ ) {
        NSNumber *indexNumber = self.dataStateArr[i];
        if ([indexNumber isEqualToNumber:[NSNumber numberWithInt:1]]) {
            NSString *typeStr = self.dataArr[i];
            if ([typeStr isEqualToString:@"简体中文"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:AppLanguage];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else if ([typeStr isEqualToString:@"English"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:AppLanguage];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
    
    // 跳转到设置页
    MainTabBarViewController *rootTabbar = [[MainTabBarViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = rootTabbar;
    //rootTabbar.selectedIndex = 4;
    
    //[self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle: @"更换语言" isBack: YES];
    [self initBarRighBtnTitle: @"确定" target: self action: @selector(confirmBtnClick)];
    [self createTableView];
}

- (void)createTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kBackColor;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - tableView delegate & dataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.lastSelectedIndexPath == nil) {
        self.lastSelectedIndexPath = indexPath;
    }
    if (indexPath.row != self.lastSelectedIndexPath.row) {
        AlarmTypeTableViewCell *lastSelectCell = [tableView cellForRowAtIndexPath: self.lastSelectedIndexPath];
        lastSelectCell.selectImageBtn.selected = NO;
        [self.dataStateArr replaceObjectAtIndex:self.lastSelectedIndexPath.row withObject: @0];
        
        AlarmTypeTableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
        cell.selectImageBtn.selected = YES;
        [self.dataStateArr replaceObjectAtIndex:indexPath.row withObject: @1];
        self.lastSelectedIndexPath = indexPath;
    }
    NSLog(@"%@", self.dataStateArr);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"AlarmTypeViewCell";
    AlarmTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
    if (cell == nil) {
        cell = [[AlarmTypeTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIndentify];
    }
    if (indexPath.row == 0) {
        cell.selectImageBtn.selected = YES;
    }
    if (indexPath.row != self.dataArr.count -1) {
        [cell addLineView];
    }
    cell.nameLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50 * KFitHeightRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_HEIGHT, 1)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.5 * KFitHeightRate;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_HEIGHT, 12.5 * KFitHeightRate)];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    AlarmTypeTableViewCell *deviceCell = (AlarmTypeTableViewCell *)cell;
    if (deviceCell.isCreate == NO) {
        CGFloat cornerRadius = 5.f * KFitHeightRate;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectMake(0, 0, SCREEN_HEIGHT - 25 * KFitWidthRate, 50 * KFitHeightRate);
        if (indexPath.row == 0) { // 最后一个
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        }else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) { // 最后一个
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        }else { // 中间的view
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathMoveToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = kCellBackColor.CGColor;
        layer.strokeColor = kRGB(210, 210, 210).CGColor;
        
        [deviceCell.backView.layer insertSublayer: layer atIndex: 0];
        layer.strokeColor = kRGB(210, 210, 210).CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        deviceCell.isCreate = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
