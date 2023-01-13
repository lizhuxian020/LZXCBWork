//
//  ShareFenceViewController.m
//  Telematics
//
//  Created by lym on 2018/3/14.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "ShareFenceViewController.h"
#import "CBShareFenceHeadView.h"
#import "ShareFenceTableViewCell.h"
#import "MyDeviceModel.h"
#import "FenceListModel.h"

static NSString *shareHeadViewIndentifer = @"shareHeadViewIndentifer";

@interface ShareFenceViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *sectionStatusArr;
}
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *groupNameArr;
@property (nonatomic, strong) NSMutableArray *groupIDArr;
@property (nonatomic, strong) NSMutableArray *shareArr;
@property (nonatomic, assign) int currentShareRequest;

/** tableView数据源  */
@property (nonatomic, strong) NSMutableArray *arrayData;

@end

@implementation ShareFenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    sectionStatusArr = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    self.groupNameArr = [NSMutableArray array];
    self.groupIDArr = [NSMutableArray array];
    self.shareArr = [NSMutableArray array];
    
    //设置预估高为0 tableView刷新后防止滚动,闪动
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    kWeakSelf(self);
    if (!self.tableView.mj_header) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            kStrongSelf(self);
            [self.arrayData removeAllObjects];
            [self requestDataWithHud: nil];
            
        }];
        [self requestDataWithHud: nil];
    } else {
        [self requestDataWithHud: nil];
    }
}
- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}
- (void)rightBtnClick
{
    [self.shareArr removeAllObjects];
    for (CBHomeLeftMenuDeviceGroupModel *deveiceGroup in self.arrayData) {
        if (deveiceGroup.noGroup) {
            for (CBHomeLeftMenuDeviceInfoModel *deviceInfoModel in deveiceGroup.noGroup) {
                if (deviceInfoModel.isCheck) {
                    [self.shareArr addObject:deviceInfoModel];
                }
            }
        } else {
            for (CBHomeLeftMenuDeviceInfoModel *deviceInfoModel in deveiceGroup.device) {
                if (deviceInfoModel.isCheck) {
                    [self.shareArr addObject:deviceInfoModel];
                }
            }
        }
    }
    if (self.shareArr.count == 0) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请选择分享的设备")];
    }else {
        self.currentShareRequest = 0;
        [self shareRequestWithHud: nil];
    }
}
#pragma mark -- 分享给选中的设备
- (void)shareRequestWithHud:(MBProgressHUD *)hud
{
    kWeakSelf(self);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    //        hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    //        [hud hideAnimated:YES];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    if (self.currentShareRequest < self.shareArr.count) {
        //MyDeviceModel *shareModel = self.shareArr[self.currentShareRequest];
        CBHomeLeftMenuDeviceInfoModel *deviceInfoModel = self.shareArr[self.currentShareRequest];
        if ([deviceInfoModel.dno isEqualToString:[CBCommonTools CBdeviceInfo].dno]) {
            [HUD showHUDWithText:Localized(@"无法分享给自己") withDelay:3.0];
            return;
        }
        dic[@"dno"] = deviceInfoModel.dno;//shareModel.dno;
        dic[@"name"] = self.model.name;
        dic[@"speed"] = self.model.speed;
        dic[@"shape"] = [NSNumber numberWithInt: self.model.shape];
        dic[@"warmType"] = [NSNumber numberWithInt: self.model.warmType];
        dic[@"data"] = self.model.data;
        //dic[@"fid"] = self.model.fid;
        dic[@"sn"] = [CBCommonTools getCurrentTimeString];//@"当前时间时间戳10位";
        [[NetWorkingManager shared]postWithUrl:@"devControlController/saveFence" params: dic succeed:^(id response,BOOL isSucceed) { //@"devControlController/addFence"
            kStrongSelf(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (isSucceed) {
                self.currentShareRequest += 1;
                [self shareRequestWithHud: hud];
            } else {
            }
        } failed:^(NSError *error) {
            kStrongSelf(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [HUD showHUDWithText:Localized(@"请求超时") withDelay:3.0];
        }];
    } else {
        [self.navigationController popViewControllerAnimated: YES];
    }
}
#pragma mark -- 获取我的设备列表信息
- (void)requestDataWithHud:(MBProgressHUD *)hud {
    kWeakSelf(self);
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [[CBNetworkRequestManager sharedInstance] getMyDeviceListDataParamters:paramters success:^(CBBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [HUD hideHud];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        switch (baseModel.status) {
            case CBNetworkingStatus0:
            {
                for (NSDictionary *dic in baseModel.data) {
                    CBHomeLeftMenuDeviceGroupModel *model = [CBHomeLeftMenuDeviceGroupModel mj_objectWithKeyValues:dic];
                    if (model.offline || model.online) {
//                        if (self.returnBlock) {
//                            self.returnBlock(model);
//                        }
                    } else {
                        [self.arrayData addObject:model];
                    }
                }
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView reloadData];
            }
                break;
            default:
            {
                [HUD showHUDWithText:baseModel.resmsg withDelay:3.0];
            }
                break;
        }
        
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [HUD showHUDWithText:Localized(@"请求超时") withDelay:3.0];
    }];
}
#pragma mark - createUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"分享") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"确定") target: self action: @selector(rightBtnClick)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.view);
    }];
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.arrayData.count > section) {
        CBHomeLeftMenuDeviceGroupModel *deviceGoupModel = self.arrayData[section];
        if (deviceGoupModel.isShow) {
            if (deviceGoupModel.noGroup) {
                return deviceGoupModel.noGroup.count;
            } else {
                return deviceGoupModel.device.count;
            }
        } else {
            return 0;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentify = @"ShareFenceTableViewCellIndentify";
    static NSString *cellIndentifyLast = @"ShareFenceTableViewCellIndentifyLast";
    ShareFenceTableViewCell *cell = nil;
    NSInteger numNumOfRow = [tableView numberOfRowsInSection: indexPath.section];
    if (numNumOfRow == indexPath.row + 1) {
        cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifyLast];
        if (cell == nil) {
            cell = [[ShareFenceTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: cellIndentifyLast];
        }
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
        if (cell == nil) {
            cell = [[ShareFenceTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: cellIndentify];
        }
    }
    if (self.arrayData.count > indexPath.section) {
        CBHomeLeftMenuDeviceGroupModel *deveiceGroup = self.arrayData[indexPath.section];
        if (deveiceGroup.noGroup) {
            CBHomeLeftMenuDeviceInfoModel *deviceInfoModel = deveiceGroup.noGroup[indexPath.row];
            cell.deviceInfoModel = deviceInfoModel;
            return cell;
        } else {
            CBHomeLeftMenuDeviceInfoModel *deviceInfoModel = deveiceGroup.device[indexPath.row];
            cell.deviceInfoModel = deviceInfoModel;
            return cell;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50 * KFitHeightRate;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 63 * KFitHeightRate;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrayData.count > indexPath.section) {
        CBHomeLeftMenuDeviceGroupModel *deveiceGroup = self.arrayData[indexPath.section];
        NSInteger checkNumberNogroup = 0;
        NSInteger checkNumberDevice = 0;
        if (deveiceGroup.noGroup) {
            CBHomeLeftMenuDeviceInfoModel *deviceInfoModel = deveiceGroup.noGroup[indexPath.row];
            for (CBHomeLeftMenuDeviceInfoModel *model in deveiceGroup.noGroup) {
                if ([deviceInfoModel isEqual:model]) {
                    model.isCheck = !model.isCheck;
                }
                if (model.isCheck) {
                    checkNumberNogroup ++;
                }
            }
            deveiceGroup.isCheck = (checkNumberNogroup == deveiceGroup.noGroup.count)?YES:NO;
        } else {
            CBHomeLeftMenuDeviceInfoModel *deviceInfoModel = deveiceGroup.device[indexPath.row];
            for (CBHomeLeftMenuDeviceInfoModel *model in deveiceGroup.device) {
                if ([deviceInfoModel isEqual:model]) {
                    model.isCheck = !model.isCheck;
                }
                if (model.isCheck) {
                    checkNumberDevice ++;
                }
            }
            deveiceGroup.isCheck = (checkNumberDevice == deveiceGroup.device.count)?YES:NO;
        }
        [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CBShareFenceHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:shareHeadViewIndentifer];
    if (!headerView) {
        headerView = [[CBShareFenceHeadView alloc]initWithReuseIdentifier:shareHeadViewIndentifer];
    }
    if (self.arrayData.count > section) {
        CBHomeLeftMenuDeviceGroupModel *deveiceGroup = self.arrayData[section];
        headerView.deveiceGroup = deveiceGroup;
    }
    kWeakSelf(self);
    // 点击head 缩展
    headerView.headerBtnClick = ^(id  _Nonnull objc) {
        kStrongSelf(self);
        [self reloadTableSectionAtIndex:section];
    };
    // head 全选和取消全选
    headerView.selectBtnClick = ^(id  _Nonnull objc, BOOL isSelected) {
        kStrongSelf(self);
        [self checkAllSection:section];
    };
    return headerView;
}
- (void)reloadTableSectionAtIndex:(NSInteger) section {
    if (self.arrayData.count > section) {
        CBHomeLeftMenuDeviceGroupModel *deveiceGroup = self.arrayData[section];
        deveiceGroup.isShow = !deveiceGroup.isShow;
    }
    [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)checkAllSection:(NSInteger)section {
    if (self.arrayData.count > section) {
        CBHomeLeftMenuDeviceGroupModel *deveiceGroup = self.arrayData[section];
        if (deveiceGroup.noGroup) {
            for (CBHomeLeftMenuDeviceInfoModel *deviceInfoModel in deveiceGroup.noGroup) {
                deviceInfoModel.isCheck = deveiceGroup.isCheck;
            }
        } else {
            for (CBHomeLeftMenuDeviceInfoModel *deviceInfoModel in deveiceGroup.device) {
                deviceInfoModel.isCheck = deveiceGroup.isCheck;
            }
        }
    }
    [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ShareFenceTableViewCell *deviceCell = (ShareFenceTableViewCell *)cell;
    if (deviceCell.isCreate == NO) {
        CGFloat cornerRadius = 5.f * KFitHeightRate;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectMake(0, 0, SCREEN_HEIGHT - 25 * KFitWidthRate, 50 * KFitHeightRate);
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) { // 最后一个
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds) - 1, CGRectGetMaxY(bounds), CGRectGetMaxX(bounds) -1, CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds)-1, CGRectGetMinY(bounds));
        }else { // 中间的view
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathMoveToPoint(pathRef, nil, CGRectGetMaxX(bounds)-1, CGRectGetMaxY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds)-1, CGRectGetMinY(bounds));
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

@end
