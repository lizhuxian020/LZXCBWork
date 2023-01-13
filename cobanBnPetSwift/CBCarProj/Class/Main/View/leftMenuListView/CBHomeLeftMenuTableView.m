//
//  CBHomeLeftMenuTableView.m
//  Telematics
//
//  Created by coban on 2019/7/18.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBHomeLeftMenuTableView.h"
#import "CBHomeLeftMenuModel.h"
#import "CBHomeLeftMenuHeadView.h"
#import "CBHomeLeftMenuTableViewCell.h"
#import "MainMapViewController.h"

static NSString *homeHeadViewIndentifer = @"homeHeadViewIndentifer";

@interface CBHomeLeftMenuTableView ()<UITableViewDelegate,UITableViewDataSource>

/** tableView数据源  */
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) NSMutableArray *arrayAllData;

@property (nonatomic,strong) CBHomeLeftMenuSliderModel *sliderModel;

@end
@implementation CBHomeLeftMenuTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.bounces = YES;
    self.delegate = self;
    self.dataSource = self;
    
    //tableView刷新后防止滚动
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
}
- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}
- (NSMutableArray *)arrayAllData {
    if (!_arrayAllData) {
        _arrayAllData = [NSMutableArray array];
    }
    return _arrayAllData;
}
- (void)reloadDataWithModel:(CBHomeLeftMenuSliderModel *)model {
    _sliderModel = model;
//    [self.arrayData removeAllObjects];
//    [self.arrayAllData removeAllObjects];
//    self.arrayData = [NSMutableArray array];
//    self.arrayAllData = [NSMutableArray array];
//    [self reloadData];
    
    kWeakSelf(self);
    if (!self.mj_header) {
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            kStrongSelf(self);
            [self.arrayData removeAllObjects];
            [self getMyDeviceListRequest];
        }];
    }
    [self getMyDeviceListRequest];
}
#pragma mark - Table view data source
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
    CBHomeLeftMenuTableViewCell *cell;
    cell = [CBHomeLeftMenuTableViewCell cellCopyTableView:tableView];
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
    return UITableViewCell.new;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrayData.count > indexPath.section) {
        CBHomeLeftMenuDeviceGroupModel *deveiceGroup = self.arrayData[indexPath.section];
        if (deveiceGroup.noGroup) {
            
            CBHomeLeftMenuDeviceInfoModel *deviceInfoModel = deveiceGroup.noGroup[indexPath.row];
            if (self.returnBlock) {
                self.returnBlock(deviceInfoModel);
            }
        } else {
            
            CBHomeLeftMenuDeviceInfoModel *deviceInfoModel = deveiceGroup.device[indexPath.row];
            if (self.returnBlock) {
                self.returnBlock(deviceInfoModel);
            }
        }
    }
}
- (NSUInteger)chooseFirOne {
    for (int i = 0; i < self.arrayData.count; i++) {
        CBHomeLeftMenuDeviceGroupModel *deveiceGroup = self.arrayData[i];
        if (deveiceGroup.noGroup && deveiceGroup.noGroup.count > 0) {
            return i;
        } else {
            if (deveiceGroup.device && deveiceGroup.device.count > 0) {
                return i;
            }
        }
    }
    return NSNotFound;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40*KFitHeightRate;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}
//设置view，将替代titleForHeaderInSection方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CBHomeLeftMenuHeadView *homeSectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:homeHeadViewIndentifer];
    if (!homeSectionHeadView) {
        homeSectionHeadView = [[CBHomeLeftMenuHeadView alloc]initWithReuseIdentifier:homeHeadViewIndentifer];
    }
    if (self.arrayData.count > section) {
        kWeakSelf(self);
        CBHomeLeftMenuDeviceGroupModel *deviceGoupModel = self.arrayData[section];
        homeSectionHeadView.deviceGoupModel = deviceGoupModel;
        homeSectionHeadView.headClickBlock = ^(id  _Nonnull objc) {
            kStrongSelf(self);
            [self reloadSections:[[NSIndexSet alloc]initWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            //[self reloadData];
        };
    }
    return homeSectionHeadView;
}
- (void)filterAction {
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
#pragma mark -- 获取我的设备列表信息
- (void)getMyDeviceListRequest {
    [MBProgressHUD hideHUDForView:self animated:YES];
    kWeakSelf(self);
    [MBProgressHUD showHUDIcon:self animated:YES];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:self.sliderModel.KeyWord?:@"" forKey:@"keyWord"];
    [paramters setObject:self.sliderModel.status?:@"" forKey:@"type"];
    
    [[CBNetworkRequestManager sharedInstance] getMyDeviceListDataParamters:paramters success:^(CBBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        [HUD hideHud];
        [MBProgressHUD hideHUDForView:self animated:YES];
        NSLog(@"--设备列表:-%@----",baseModel.data);
        NSMutableArray *array = [NSMutableArray array];
        NSMutableArray *arrayAll = [NSMutableArray array];
        switch (baseModel.status) {
            case CBNetworkingStatus0:
            {
                for (NSDictionary *dic in baseModel.data) {
                    CBHomeLeftMenuDeviceGroupModel *model = [CBHomeLeftMenuDeviceGroupModel mj_objectWithKeyValues:dic];
                    if (model.offline || model.online) {
                        if (self.returnBlock) {
                            self.returnBlock(model);
                        }
                    } else {
                        //[self.arrayData addObject:model];
                        [array addObject:model];
                        self.arrayData = array;
                    }
                    //[self.arrayAllData addObject:model];
                    [arrayAll addObject:model];
                    self.arrayAllData = arrayAll;
                }
                [self.mj_footer endRefreshingWithNoMoreData];
                [self reloadData];
                //判断首页是有已经有选中, 如无,则选中第一条
                if (self.needToChooseFirst ) {
                    [self tryToSelectFirOne];
                }
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
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        [HUD hideHud];
        [MBProgressHUD hideHUDForView:self animated:YES];
//        [HUD showHUDWithText:Localized(@"请求超时") withDelay:3.0];
    }];
}

- (void)tryToSelectFirOne {
    UITabBarController *rootVC = UIApplication.sharedApplication.keyWindow.rootViewController;
    if (![rootVC isKindOfClass:UITabBarController.class]) {
        return;
    }
    UINavigationController *naviVC = rootVC.viewControllers.firstObject;
    if (![naviVC isKindOfClass:UINavigationController.class]) {
        return;
    }
    for (MainMapViewController *vc in naviVC.viewControllers) {
        if ([vc isKindOfClass:MainMapViewController.class]) {
            if (CarDeviceManager.deviceInfoModelSelect == nil && self.needToChooseFirst) {
                NSUInteger section = [self chooseFirOne];
                if (section == NSNotFound) {
                    return;
                }
                [self tableView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            }
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
