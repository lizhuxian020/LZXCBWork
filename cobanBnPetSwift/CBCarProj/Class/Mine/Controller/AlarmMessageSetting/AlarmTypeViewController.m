//
//  AlarmTypeViewController.m
//  Telematics
//
//  Created by lym on 2017/11/13.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "AlarmTypeViewController.h"
#import "AlarmTypeTableViewCell.h"

@interface AlarmTypeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataStateArr;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation AlarmTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    self.dataStateArr = [NSMutableArray arrayWithArray: @[@0,@0,@0,@0,@0]];
    self.dataArr = @[@"出围栏报警",@"断电报警",@"超速报警",@"位移报警",@"其他"];
    [self requestData];
}

- (void)requestData
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [[NetWorkingManager shared]getWithUrl:@"personController/getMyWarmType" params: dic succeed:^(id response,BOOL isSucceed) {
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSString class]]) {
                NSString *dataString = response[@"data"];
                NSArray *stateArr = [dataString componentsSeparatedByString: @","];
                for (NSNumber *stateNum in stateArr) {
                    [weakSelf.dataStateArr replaceObjectAtIndex:[stateNum integerValue] withObject: @1];
                }
                [weakSelf.tableView reloadData];
            }
            [hud hideAnimated:YES];
        }else {
            [hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle: @"报警信息类型" isBack: YES];
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
    AlarmTypeTableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
    if (cell.selectImageBtn.selected == NO) {
        cell.selectImageBtn.selected = YES;
        [self.dataStateArr replaceObjectAtIndex:indexPath.row withObject: @1];
    }else {
        cell.selectImageBtn.selected = NO;
        [self.dataStateArr replaceObjectAtIndex:indexPath.row withObject: @0];
    }
    NSLog(@"%@", self.dataStateArr);
    [self editStateArr];
}

- (void)editStateArr
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    NSMutableArray *typeInfoArr = [NSMutableArray array];
    for (int i = 0; i < self.dataStateArr.count; i++) {
        NSNumber *stateNum = self.dataStateArr[i];
        if ([stateNum integerValue] == 1) {
            [typeInfoArr addObject:[NSNumber numberWithInt: i]];
        }
    }
    dic[@"typeInfo"] = [typeInfoArr componentsJoinedByString: @","];
    MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [[NetWorkingManager shared] postWithUrl:@"personController/editMyWarmType" params: dic succeed:^(id response,BOOL isSucceed) {
        if (isSucceed) {
//            [MINUtils showProgressHudToView:self.view withText: @"修改成功"];
            [hud hideAnimated:YES];
        }else {
            [hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"AlarmTypeViewCell";
    AlarmTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
    if (cell == nil) {
        cell = [[AlarmTypeTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIndentify];
    }
    if (indexPath.row != self.dataArr.count -1) {
        [cell addLineView];
    }
    cell.nameLabel.text = self.dataArr[indexPath.row];
    NSNumber *selectNum = self.dataStateArr[indexPath.row];
    if ([selectNum intValue] == 1) {
        cell.selectImageBtn.selected = YES;
    }
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

#pragma mark - Other Method
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
