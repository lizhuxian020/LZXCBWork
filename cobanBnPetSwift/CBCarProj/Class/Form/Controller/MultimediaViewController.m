//
//  MultimediaViewController.m
//  Telematics
//
//  Created by lym on 2017/11/20.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MultimediaViewController.h"
#import "MultimediaHeaderView.h"
#import "FormDateChooseViewController.h"
#import "FormDateChooseTableViewCell.h"
#import "FormHeaderView.h"
#import "FormDateHeaderView.h"
#import "DownloadPicViewController.h"
#import "DownloadVoiceViewController.h"
#import "DownloadVideoViewController.h"
#import "FormInfoModel.h"
#import "MINDatePickerView.h"
#import "FormDetailInfoViewController.h"

@interface MultimediaViewController () <UITableViewDelegate, UITableViewDataSource, MINDatePickerViewDelegare>
{
    MultimediaHeaderView *headerView;
}
@property (nonatomic, strong) NSString *leftHeaderText;
@property (nonatomic, strong) NSString *middleHeaderText;
@property (nonatomic, strong) NSString *rightHeaderText;
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *dateStringStart;
@property (nonatomic, copy) NSString *dateStringEnd;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) MINDatePickerView *pickerView;
@end

@implementation MultimediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    self.leftHeaderText = Localized(@"编号");
    self.middleHeaderText = Localized(@"触发时间");
    self.rightHeaderText = Localized(@"多媒体类型");
    self.dateString = [self getCurrentTimeString];
    NSDictionary *dicTime = [CBCommonTools getSomeDayPeriod:[NSDate date]];
    self.dateStringStart = [NSString stringWithFormat:@"%@",dicTime[@"startTime"]];
    self.dateStringEnd = [NSString stringWithFormat:@"%@",dicTime[@"endTime"]];
    self.dataArr = [NSMutableArray array];
    [self requestData];
}

- (void)requestData
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    dic[@"reportType"] = @11;
    dic[@"startTime"] = self.dateStringStart;
    dic[@"endTime"] = self.dateStringEnd;
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devReportController/getCommonList" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                [weakSelf.dataArr removeAllObjects];
                NSArray *dataArr = response[@"data"];
                for (NSDictionary *dic in dataArr) {
                    FormInfoModel *model = [FormInfoModel yy_modelWithDictionary: dic];
                    [weakSelf.dataArr addObject: model];
                }
                [weakSelf.tableView reloadData];
            }
            
        }else {
           
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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

#pragma mark - CraeteUI
- (void)createUI
{
    CBHomeLeftMenuDeviceInfoModel *model = [CBCommonTools CBdeviceInfo];
    [self initBarWithTitle:model.name?:@"" isBack: YES];//@"ASSSSS"
    [self initBarRighWhiteBackBtnTitle:Localized(@"查询") target: self action: @selector(rightBtnClick)];
    [self showBackGround];
    [self createHeaderView];
    [self createTableView];
}

- (void)createTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.right.left.bottom.equalTo(self.view);
    }];
}

- (void)createHeaderView
{
    headerView = [[MultimediaHeaderView alloc] init];
    [self.view addSubview: headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(self.view).with.offset(kNavAndStatusHeight + 12.5 * KFitWidthRate);
        make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(75 * KFitHeightRate);// 70
    }];
    __weak __typeof__(self) weakSelf = self;
    headerView.picBtnClickBlock = ^{
        DownloadPicViewController *downloadVC = [[DownloadPicViewController alloc] init];
        [weakSelf.navigationController pushViewController: downloadVC animated: YES];
    };
    headerView.voiceBtnClickBlock = ^{
        DownloadVoiceViewController *downloadVC = [[DownloadVoiceViewController alloc] init];
        [weakSelf.navigationController pushViewController: downloadVC animated: YES];
    };
    headerView.videoBtnClickBlock = ^{
        DownloadVideoViewController *downloadVC = [[DownloadVideoViewController alloc] init];
        [weakSelf.navigationController pushViewController: downloadVC animated: YES];
    };
}

#pragma mark - Action
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

#pragma mark - Tableview delegate & dataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    FormInfoModel *model = self.dataArr[indexPath.row];
//    FormDetailInfoViewController *infoVC = [[FormDetailInfoViewController alloc] init];
//    NSMutableArray *array = [model getMultimediaModelArr];
//    infoVC.url = model.url;
//    infoVC.isShowDownloadBtn = YES;
//    [array insertObject: [NSString stringWithFormat: @"%@: %ld", Localized(@"编号"),(long)indexPath.row + 1] atIndex: 0];
//    infoVC.dataArr = array;
//    infoVC.type = model.type;
//    [self.navigationController pushViewController: infoVC animated: YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"FormTableViewCell";
    static NSString *cellIndentifyLast = @"FormTableViewCellLast";
    FormDateChooseTableViewCell *cell = nil;
    NSInteger numNumOfRow = [tableView numberOfRowsInSection: indexPath.section];
    if (numNumOfRow == indexPath.row + 1) {
        cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifyLast];
        if (cell == nil) {
            cell = [[FormDateChooseTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: cellIndentifyLast];
        }
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
        if (cell == nil) {
            cell = [[FormDateChooseTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: cellIndentify];
            [cell addBottomLineView];
        }
    }
    FormInfoModel *model = self.dataArr[indexPath.row];
    cell.middleLabel.text = [MINUtils getTimeFromTimestamp: model.createTime formatter: @"yyyy-MM-dd HH:mm"];
    if (model.type == 0) {
        cell.rightLabel.text = [NSString stringWithFormat:@"%@",Localized(@"图像")];
    }else if (model.type == 1) {
        cell.rightLabel.text = [NSString stringWithFormat:@"%@", Localized(@"音频")];
    }else if (model.type == 2) {
        cell.rightLabel.text = [NSString stringWithFormat:@"%@",Localized(@"视频")];
    }
    cell.leftLabel.text = [NSString stringWithFormat: @"%ld.", indexPath.row + 1];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 62.5 * KFitHeightRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-  (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FormDateHeaderView *view = [[FormDateHeaderView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 50 * KFitHeightRate);
    view.leftLabel.text = self.leftHeaderText;
    view.middleLabel.text = self.middleHeaderText;
    view.rightLabel.text = self.rightHeaderText;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_HEIGHT, 1)];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    FormDateChooseTableViewCell *deviceCell = (FormDateChooseTableViewCell *)cell;
    if (deviceCell.isCreate == NO) {
        CGFloat cornerRadius = 5.f * KFitHeightRate;
        //        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectMake(0, 0, SCREEN_HEIGHT - 12.5 * KFitWidthRate - 12.5 * KFitWidthRate, 50 * KFitHeightRate);
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds) - 1, CGRectGetMaxY(bounds), CGRectGetMaxX(bounds) -1, CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds) -1, CGRectGetMinY(bounds));
        }else { // 中间的view
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds)-1, CGRectGetMinY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds)-1, CGRectGetMaxY(bounds));
        }
        layer.path = pathRef;
        //颜色修改
        layer.fillColor = kCellBackColor.CGColor;
        layer.strokeColor = kRGB(210, 210, 210).CGColor;
        CFRelease(pathRef);
        [deviceCell.backView.layer insertSublayer: layer atIndex: 0];
        deviceCell.isCreate = YES;
    }
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

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
