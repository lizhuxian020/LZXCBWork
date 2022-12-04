//
//  FormDateChooseViewController.m
//  Telematics
//
//  Created by lym on 2017/11/17.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "FormDateChooseViewController.h"
#import "FormDateHeaderView.h"
#import "FormDateChooseTableViewCell.h"
#import "MINDatePickerView.h"
#import "FormInfoModel.h"
#import "FormDetailInfoViewController.h"

@interface FormDateChooseViewController () <UITableViewDelegate, UITableViewDataSource, MINDatePickerViewDelegare>
@property (nonatomic, strong) NSString *leftHeaderText;
@property (nonatomic, strong) NSString *middleHeaderText;
@property (nonatomic, strong) NSString *rightHeaderText;
@property (nonatomic, assign) BOOL isShowRightCellLabel;
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *dateStringStart;
@property (nonatomic, copy) NSString *dateStringEnd;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) MINDatePickerView *pickerView;
@end

@implementation FormDateChooseViewController

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
#pragma mark -- 获取报表数据
- (void)requestData
{
    // 报警统计 碰撞报警type = 8;
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";//[CBCommonTools CBdeviceInfo].dno?:@"";
    dic[@"startTime"] = self.dateStringStart;
    dic[@"endTime"] = self.dateStringEnd;
    if (self.type == FormTypeIdling) {
        dic[@"type"] = @1;
        dic[@"reportType"] = @2;
    }else if(self.type == FormTypeStay) {
        dic[@"type"] = @0;
        dic[@"reportType"] = @2;
    }else if (self.type == FormTypeFire) {
        dic[@"reportType"] = @3;
    }else if (self.type == FormTypePourOil) {
        dic[@"reportType"] = @7;
        dic[@"type"] = @1;
    }else if (self.type == FormTypeOilLeak) {
        dic[@"reportType"] = @7;
        dic[@"type"] = @0;
    }else if (self.type == FormTypeAllAlarm) {
        dic[@"reportType"] = @8;
    }else if (self.type == FormTypeSOSAlarm) {
        dic[@"reportType"] = @8;
        dic[@"type"] = @0;
    }else if (self.type == FormTypeOverspeedAlarm) {
        dic[@"reportType"] = @8;
        dic[@"type"] = @1;
    }else if (self.type == FormTypeTiredAlarm) {
        dic[@"reportType"] = @8;
        dic[@"type"] = @2;
    }else if (self.type == FormTypeUnderpackingAlarm) {
        dic[@"reportType"] = @8;
        //dic[@"type"] = @3;
        dic[@"type"] = @7;
    }else if (self.type == FormTypePowerDownAlarm) {
        dic[@"reportType"] = @8;
        //dic[@"type"] = @4;
        dic[@"type"] = @8;
    }else if (self.type == FormTypeShakeAlarm) {
        dic[@"reportType"] = @8;
        //dic[@"type"] = @5;
        dic[@"type"] = @12;
    }else if (self.type == FormTypeOpenDoorAlarm) {
        dic[@"reportType"] = @8;
        //dic[@"type"] = @6;
        dic[@"type"] = @17;
    }else if (self.type == FormTypeFireAlarm) {
        dic[@"reportType"] = @8;
        //dic[@"type"] = @7;
        dic[@"type"] = @16;
    }else if (self.type == FormTypeMoveAlarm) {
        dic[@"reportType"] = @8;
        //dic[@"type"] = @8;
        dic[@"type"] = @15;
    }else if (self.type == FormTypeGasolineTheftAlarm) {
        dic[@"reportType"] = @8;
        //dic[@"type"] = @9;
        dic[@"type"] = @25;
    }else if (self.type == FormTypeCollisionAlarm) {
        dic[@"reportType"] = @8;
        //dic[@"type"] = @10;
        dic[@"type"] = @27;
    }else if (self.type == FormTypeOBD) {
        dic[@"reportType"] = @9;
    }else if (self.type == FormTypeInFencing) {
        dic[@"reportType"] = @10;
        dic[@"type"] = @0;
    }else if (self.type == FormTypeOutFencing) {
        dic[@"reportType"] = @10;;
        dic[@"type"] = @1;
    }else if (self.type == FormTypeInOutFencing) {
        dic[@"reportType"] = @10;
        dic[@"type"] = @2;
    }else if (self.type == FormTypeSchedule) {
        dic[@"reportType"] = @12;
    }
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [self hiddenPromptView:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devReportController/getCommonList" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view  animated:YES];
        NSLog(@"报表数据:===%@===",response);
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                [weakSelf.dataArr removeAllObjects];
                NSArray *dataArr = response[@"data"];
                for (NSDictionary *dic in dataArr) {
                    FormInfoModel *model = [FormInfoModel yy_modelWithDictionary: dic];
                    model.formType = weakSelf.type;
                    [weakSelf.dataArr addObject: model];
                }
            } else {
                [weakSelf.dataArr removeAllObjects];
            }
        } else {
            [weakSelf.dataArr removeAllObjects];
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

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.view);
    }];
    kWeakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        kStrongSelf(self);
        [self requestData];
    }];
}

- (void)setHeaderText
{
    if (self.type == FormTypeIdling) {
        [self initBarWithTitle:Localized(@"怠速报表") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"怠速时长");
    }else if (self.type == FormTypeStay) {
        [self initBarWithTitle:Localized(@"停留统计") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"停留时间");
    }else if (self.type == FormTypeFire) {
        [self initBarWithTitle:Localized(@"点火报表") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"ACC状态");
    }else if (self.type == FormTypePourOil) {
        [self initBarWithTitle:Localized(@"加油报表") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"油量 (升)");
    }else if (self.type == FormTypeOilLeak) {
        [self initBarWithTitle: Localized(@"漏油报表") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"漏油 (升)");
    }else if (self.type == FormTypeAllAlarm) {
        [self initBarWithTitle: Localized(@"所有报警") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"报警类型");
    }else if (self.type == FormTypeSOSAlarm) {
        [self initBarWithTitle: Localized(@"SOS报警") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"报警类型");
        self.isShowRightCellLabel = NO;
    }else if (self.type == FormTypeOverspeedAlarm) {
        [self initBarWithTitle:Localized(@"超速报警") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"速度");
    }else if (self.type == FormTypeTiredAlarm) {
        [self initBarWithTitle:Localized(@"疲劳驾驶统计") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"速度");
    }else if (self.type == FormTypeUnderpackingAlarm) {
        [self initBarWithTitle:Localized(@"欠压统计") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"电瓶状态");
    }else if (self.type == FormTypePowerDownAlarm) {
        [self initBarWithTitle: Localized(@"掉电报警统计报表") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"报警类型");
    }else if (self.type == FormTypeShakeAlarm) {
        [self initBarWithTitle: Localized(@"振动报警统计报表") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"报警类型");
        self.isShowRightCellLabel = NO;
    }else if (self.type == FormTypeOpenDoorAlarm) {
        [self initBarWithTitle: Localized(@"开门报警统计报表") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"报警类型");
    }else if (self.type ==  FormTypeFireAlarm) {
        [self initBarWithTitle: Localized(@"点火报警统计报表") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"报警类型");
    }else if (self.type == FormTypeMoveAlarm) {
        [self initBarWithTitle: Localized(@"位移报警统计报表") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"报警类型");
        self.isShowRightCellLabel = NO;
    }else if (self.type == FormTypeGasolineTheftAlarm) {
        [self initBarWithTitle: Localized(@"偷油漏油报警统计报表") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"当前油量");
    }else if (self.type == FormTypeCollisionAlarm) {
        [self initBarWithTitle: Localized(@"碰撞报警报表") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"速度");
    }else if (self.type == FormTypeOBD) {
        [self initBarWithTitle: Localized(@"OBD报表") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"故障码");
    }else if (self.type == FormTypeInFencing) {
        [self initBarWithTitle: Localized(@"入围栏报警报表") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"围栏名称");
    }else if (self.type == FormTypeOutFencing) {
        [self initBarWithTitle: Localized(@"出围栏报警报表") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"围栏名称");
    }else if (self.type == FormTypeInOutFencing) {
        [self initBarWithTitle: Localized(@"出入围栏报警报表") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"围栏名称");
    }else if (self.type == FormTypeSchedule) {
        [self initBarWithTitle: Localized(@"调度记录") isBack: YES];
        self.middleHeaderText = Localized(@"起始时间");
        self.rightHeaderText = Localized(@"消息类型");
    }
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
#pragma mark - Tableview delegate & dataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormInfoModel *model = self.dataArr[indexPath.row];
    FormDetailInfoViewController *infoVC = [[FormDetailInfoViewController alloc] init];
    if (self.type == FormTypeStay || self.type == FormTypeIdling) { // 停留或怠速报表
        NSMutableArray *array = [model getIdingOrStayModelArr];
        [array insertObject: [NSString stringWithFormat: @"%@: %@",Localized(@"编号"), [NSString stringWithFormat: @"%@.", model.ids]] atIndex: 0];
        infoVC.dataArr = array;
    }else if (self.type == FormTypeFire) { //点火报表
        NSMutableArray *array = [model getFireModelArr];
        [array insertObject: [NSString stringWithFormat: @"%@: %@", Localized(@"编号"),[NSString stringWithFormat: @"%@.", model.ids]] atIndex: 0];
        infoVC.dataArr = array;
    }else if (self.type == FormTypeOilLeak || self.type == FormTypePourOil) {//漏油报表 加油报表
        NSMutableArray *array = [model getPourOilOrOilLeakModelArr];
        [array insertObject: [NSString stringWithFormat: @"%@: %@", Localized(@"编号"),[NSString stringWithFormat: @"%@.", model.ids?:@"0"]] atIndex: 0];
        infoVC.dataArr = array;
    }else if (self.type == FormTypeAllAlarm ||
              self.type == FormTypeSOSAlarm ||
              self.type == FormTypeOverspeedAlarm ||
              self.type == FormTypeTiredAlarm ||
              self.type == FormTypeUnderpackingAlarm ||
              self.type == FormTypePowerDownAlarm ||
              self.type == FormTypeShakeAlarm ||
              self.type == FormTypeOpenDoorAlarm ||
              self.type == FormTypeFireAlarm ||
              self.type == FormTypeMoveAlarm ||
              self.type == FormTypeGasolineTheftAlarm ||
              self.type == FormTypeCollisionAlarm) {
        NSMutableArray *array = [model getAlarmModelArr:self.type];
        [array insertObject: [NSString stringWithFormat: @"%@: %@", Localized(@"编号"),[NSString stringWithFormat: @"%@.", model.ids]] atIndex: 0];
        infoVC.dataArr = array;
    }else if (self.type == FormTypeOBD) {
        NSMutableArray *array = [model getObdModelArr];
        [array insertObject: [NSString stringWithFormat: @"%@: %@", Localized(@"编号"),[NSString stringWithFormat: @"%@.", model.ids]] atIndex: 0];
        infoVC.dataArr = array;
    }else if (self.type == FormTypeInFencing || self.type == FormTypeOutFencing || self.type == FormTypeInOutFencing) {
        model.formType = self.type;
        NSMutableArray *array = [model getFenceModelArr];
        [array insertObject: [NSString stringWithFormat: @"%@: %@", Localized(@"编号"),[NSString stringWithFormat: @"%@.", model.ids]] atIndex: 0];
        infoVC.dataArr = array;
    }
//    else if (self.type == FormTypeSchedule) {
//        NSMutableArray *array = [model getScheduleModelArr];
//        [array insertObject: [NSString stringWithFormat: @"%@: %@", Localized(@"编号"),[NSString stringWithFormat: @"%@.", model.ids]] atIndex: 0];
//        infoVC.dataArr = array;
//    }
    [self.navigationController pushViewController: infoVC animated: YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"FormDataTableViewCell";
    static NSString *cellIndentifyLast = @"FormDataTableViewCellLast";
    FormDateChooseTableViewCell *cell = nil;
    NSInteger numNumOfRow = [tableView numberOfRowsInSection: indexPath.section];
    if (numNumOfRow == indexPath.row + 1) {
        cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifyLast];
        if (cell == nil) {
            cell = [[FormDateChooseTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: cellIndentifyLast];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
        if (cell == nil) {
            cell = [[FormDateChooseTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: cellIndentify];
            [cell addBottomLineView];
        }
    }
    if (self.dataArr.count > indexPath.row) {
        FormInfoModel *model = self.dataArr[indexPath.row];
        cell.formModel = model;
    }
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

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    FormDateChooseTableViewCell *deviceCell = (FormDateChooseTableViewCell *)cell;
//    if (deviceCell.isCreate == NO) {
//        CGFloat cornerRadius = 5.f * KFitHeightRate;
//        //        cell.backgroundColor = UIColor.clearColor;
//        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//        CGMutablePathRef pathRef = CGPathCreateMutable();
//        CGRect bounds = CGRectMake(0, 0, SCREEN_HEIGHT - 12.5 * KFitWidthRate - 12.5 * KFitWidthRate, 50 * KFitHeightRate);
//        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds) - 1, CGRectGetMaxY(bounds), CGRectGetMaxX(bounds) -1, CGRectGetMidY(bounds), cornerRadius);
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds) -1, CGRectGetMinY(bounds));
//        }else { // 中间的view
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMaxX(bounds)-1, CGRectGetMinY(bounds));
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds)-1, CGRectGetMaxY(bounds));
//        }
//        layer.path = pathRef;
//        //颜色修改
//        layer.fillColor = kCellBackColor.CGColor;
//        layer.strokeColor = kRGB(210, 210, 210).CGColor;
//        CFRelease(pathRef);
//        [deviceCell.backView.layer insertSublayer: layer atIndex: 0];
//        deviceCell.isCreate = YES;
//    }
//}

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
