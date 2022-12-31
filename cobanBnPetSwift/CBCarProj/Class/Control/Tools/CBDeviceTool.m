//
//  CBDeviceTool.m
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/9.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBDeviceTool.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "CBProductSpecModel.h"
#import "CBCarControlConfig.h"

@interface CBDeviceTool ()

@property (nonatomic, strong) CBProductSpecModel *currentProductSpec;;

@property (nonatomic, strong) NSArray<CBProductSpecModel *> *productSpecData;
@end

@implementation CBDeviceTool

+ (instancetype)shareInstance {
    static CBDeviceTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [CBDeviceTool new];
    });
    return tool;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.productSepcArr = [NSMutableArray new];
        self.productSepcIdArr = [NSMutableArray new];
    }
    return self;
}

- (void)getDeviceNames:(void(^)(NSArray<NSString *> *))blk {
    UIWindow *window = [UIApplication.sharedApplication keyWindow];
    [MBProgressHUD showHUDIcon:window animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"personController/getMyDeviceList" params: @{} succeed:^(id response, BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSMutableArray *dataArr = [NSMutableArray array];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *responseArr = response[@"data"];
                for (int i = 0; i < responseArr.count - 2; i++) {
                    NSDictionary *dataDic = responseArr[i];
                    for (NSDictionary *deviceDic in dataDic[@"device"]) {
                        if (deviceDic[@"name"]) {
                            [dataArr addObject: deviceDic[@"name"]];
                        }
                    }
                }
                NSDictionary *noGroupDic = responseArr[responseArr.count - 2];
                for (NSDictionary *deviceDic in noGroupDic[@"noGroup"]) {
                    if (deviceDic[@"name"]) {
                        [dataArr addObject: deviceDic[@"name"]];
                    }
                }
            }
        }
        blk(dataArr);
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
    }];
}

- (void)getProductSpecData:(void(^)(NSArray *productSepcArr, NSArray *productSepcIdArr))productSpecBlk {
    if (self.productSepcArr && self.productSepcArr.count > 0 &&
        self.productSepcIdArr && self.productSepcIdArr.count > 0) {
        productSpecBlk(self.productSepcArr, self.productSepcIdArr);
        return;
    }
    UIWindow *window = [UIApplication.sharedApplication keyWindow];
    [MBProgressHUD showHUDIcon:window animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"/productSpec/getInfo" params:@{} succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:window animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray<CBProductSpecModel *> *modelArr = [CBProductSpecModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                self.productSpecData = modelArr;
                for (CBProductSpecModel *model in modelArr) {
                    if (![self.productSepcArr containsObject:model.name]) {
                        [self.productSepcArr addObject:model.name];
                        [self.productSepcIdArr addObject:model.pId];
                    }
                }
                productSpecBlk(self.productSepcArr, self.productSepcIdArr);
            }
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
    }];
}

- (void)getGroupName:(void(^)(NSArray<NSString *> *groupNames))blk {
    UIWindow *window = [UIApplication.sharedApplication keyWindow];
    [MBProgressHUD showHUDIcon:window animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"personController/getMyDeviceList" params: @{} succeed:^(id response, BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSMutableArray *dataArr = [NSMutableArray array];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *responseArr = response[@"data"];
                for (int i = 0; i < responseArr.count - 2; i++) {
                    NSDictionary *dataDic = responseArr[i];
                    if (dataDic[@"groupName"]) {
                        [dataArr addObject:dataDic[@"groupName"]];
                    }
                }
//                NSDictionary *noGroupDic = responseArr[responseArr.count - 2];
                [dataArr addObject:Localized(@"默认分组")];
            }
        }
        blk(dataArr);
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
    }];
}

- (void)didChooseDevice:(CBHomeLeftMenuDeviceInfoModel *)currentModel {
    kWeakSelf(self);
    if (!currentModel.productSpecId || !currentModel.proto) {
        [self updateDeviceModelForProduct:currentModel finishCallback:^(CBHomeLeftMenuDeviceInfoModel *model) {
            [weakself didChooseDevice:model];
        }];
        return;
    }
    [self.productSepcArr removeAllObjects];
    [self.productSepcIdArr removeAllObjects];
    UIWindow *window = [UIApplication.sharedApplication keyWindow];
//    [MBProgressHUD showHUDIcon:window animated:YES];
    
    [[NetWorkingManager shared]postWithUrl:@"/productSpec/getInfo" params:@{} succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:window animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray<CBProductSpecModel *> *modelArr = [CBProductSpecModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                self.productSpecData = modelArr;
                CBProductSpecModel *defaultModel = nil;
                for (CBProductSpecModel *model in modelArr) {
                    if ([model.tbDevModelId isEqualToString:@"70"] && [model.proto isEqualToString:@"0"]) {
                        defaultModel = model;
                    }
                    if (![self.productSepcArr containsObject:model.name]) {
                        [self.productSepcArr addObject:model.name];
                        [self.productSepcIdArr addObject:model.pId];
                    }
                    if ([model.proto isEqualToString:currentModel.proto] && [model.tbDevModelId isEqualToString:currentModel.productSpecId]) {
                        self.currentProductSpec = model;
                    }
                }
                if (self.currentProductSpec == nil) {
                    self.currentProductSpec = defaultModel;
                }
            }
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
    }];
}

- (void)updateDeviceModelForProduct:(CBHomeLeftMenuDeviceInfoModel *)currentModel finishCallback:(void(^)(CBHomeLeftMenuDeviceInfoModel *model))blk {
    UIWindow *window = [UIApplication.sharedApplication keyWindow];
    [MBProgressHUD showHUDIcon:window animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"personController/getMyDeviceList" params: @{}succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:window animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *modelArr = [CBHomeLeftMenuDeviceGroupModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                for (CBHomeLeftMenuDeviceGroupModel *model in modelArr) {
                    if (model.device) {
                        for (CBHomeLeftMenuDeviceInfoModel *dModel in model.device) {
                            if ([dModel.dno isEqualToString:currentModel.dno]) {
                                blk(dModel);
                                return;
                            }
                        }
                    }
                    if (model.noGroup) {
                        for (CBHomeLeftMenuDeviceInfoModel *dModel in model.noGroup) {
                            if ([dModel.dno isEqualToString:currentModel.dno]) {
                                blk(dModel);
                                return;
                            }
                        }
                    }
                }
            }
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
    }];
}

- (CBProductSpecModel *)_getSpecModelWithDevice:(CBHomeLeftMenuDeviceInfoModel *)deviceModel {
    if (!self.productSpecData) {
        return nil;
    }
    CBProductSpecModel *targetModel = nil;
    CBProductSpecModel *defaultModel = nil;
    for (CBProductSpecModel *model in self.productSpecData) {
        if ([model.tbDevModelId isEqualToString:@"70"] && [model.proto isEqualToString:@"0"]) {
            defaultModel = model;
        }
        if ([model.proto isEqualToString:deviceModel.proto] && [model.tbDevModelId isEqualToString:deviceModel.productSpecId]) {
            targetModel = model;
            return targetModel;
        }
    }
    return defaultModel;
}

- (void)getControlData:(CBHomeLeftMenuDeviceInfoModel *)deviceModel blk:(void(^)(NSArray *arrayTitle ,NSArray *arrayTitleImage))blk {
    CBProductSpecModel *targetSpecModel = [self _getSpecModelWithDevice:deviceModel];
    NSMutableArray *titleMArr = [NSMutableArray new];
    NSMutableArray *imageMArr = [NSMutableArray new];
    [titleMArr addObjectsFromArray:@[
        _ControlConfigTitle_DCJW,
        _ControlConfigTitle_XMJWCL,
        _ControlConfigTitle_TT,
        _ControlConfigTitle_DYD,
        _ControlConfigTitle_HFYD,
        _ControlConfigTitle_TZBJ,
        _ControlConfigTitle_SDJ,
        _ControlConfigTitle_YCKZ,
        _ControlConfigTitle_BFCF,
        _ControlConfigTitle_HFCX,
        _ControlConfigTitle_CSBJ,
    ]];
    [imageMArr addObjectsFromArray:@[
        @"单次定位",
        @"休眠定位策略",
        @"听听",
        @"断油电",
        @"恢复油电",
        @"停止报警",
        @"锁电机",
        @"远程点火",
        @"布防撤防",
        @"话费查询",
        @"超速报警",
    ]];
    
    NSArray *showArr = @[
        @(targetSpecModel.singlePosition),
        @(targetSpecModel.autoPosition),
        @(targetSpecModel.callBack),
        @(targetSpecModel.oilElectricityControl),
        @(targetSpecModel.oilElectricityControl),
        @(targetSpecModel.arm),
        @(targetSpecModel.motorControl),
        @(targetSpecModel.remoteStart),
        @(targetSpecModel.arm),
        @(targetSpecModel.callChargeInquiry),
        @(targetSpecModel.isShowOverSpeed),
    ];
    
    if (!self.currentProductSpec) {
        blk(titleMArr, imageMArr);
        return;
    }
    NSMutableArray *waitToRemoveTitle = [NSMutableArray new];
    NSMutableArray *waitToRemoveImg = [NSMutableArray new];
    for (int i = 0; i < showArr.count; i++) {
        if ([showArr[i] boolValue] == NO) {
            [waitToRemoveTitle addObject:titleMArr[i]];
            [waitToRemoveImg addObject:imageMArr[i]];
        }
    }
    [titleMArr removeObjectsInArray:waitToRemoveTitle];
    [imageMArr removeObjectsInArray:waitToRemoveImg];
    
    blk(titleMArr, imageMArr);
    return;
}

- (void)getDeviceConfigData:(CBHomeLeftMenuDeviceInfoModel *)deviceModel blk:(void(^)(NSArray *arrayTitle ,NSArray *arrayTitleImage))blk {
    CBProductSpecModel *targetSpecModel = [self _getSpecModelWithDevice:deviceModel];
    NSMutableArray *titleMArr = [NSMutableArray new];
    NSMutableArray *imageMArr = [NSMutableArray new];
    [titleMArr addObjectsFromArray:@[
        _ControlConfigTitle_SQSZ,
        _ControlConfigTitle_SZDXMM,
        _ControlConfigTitle_SZSQHM,
        _ControlConfigTitle_SZYXRJ,
        _ControlConfigTitle_SZYLJZ,
        _ControlConfigTitle_SZLCCSZ,
        _ControlConfigTitle_ACCGZTZ,
        _ControlConfigTitle_PYYZ,
        _ControlConfigTitle_SZZWBBJD,
        _ControlConfigTitle_SZBJDXFSCS,
        _ControlConfigTitle_SZXTJG,
        _ControlConfigTitle_ZDLMD,
        _ControlConfigTitle_CSHSZ,
        _ControlConfigTitle_SBCQ,
    ]];
    [imageMArr addObjectsFromArray:@[
        @"时区设置",
        @"设置短信密码",
        @"设置授权号码",
        @"设置油箱容积",
        @"设置油量校准",
        @"设置里程初始值",
        @"ACC工作通知",
        @"漂移抑制",
        @"设置转弯补报角度",
        @"设置报警发送次数",
        @"设置心跳间隔",
        @"振动灵敏度",
        @"初始化设置",
        @"设备重启"
    ]];
    
    NSArray *showArr = @[
        @(targetSpecModel.timeSet),
        @(targetSpecModel.passwordSet),
        @(targetSpecModel.authCode),
        @(targetSpecModel.tankVolume),
        @(targetSpecModel.fuelSensorCalibration),
        @(targetSpecModel.mileageInitialValue),
        @(targetSpecModel.accWorkNotice),
        @(targetSpecModel.gpsDriftSuppression),
        @(targetSpecModel.turnSupplement),
        @(0), //一直不显示
        @(targetSpecModel.setGprsHeartbeat),
        @(targetSpecModel.sensitivitySet),
        @(targetSpecModel.initializeSet),
        @(targetSpecModel.hardwareReboot),
    ];
    
    if (!self.currentProductSpec) {
        blk(titleMArr, imageMArr);
        return;
    }
    NSMutableArray *waitToRemoveTitle = [NSMutableArray new];
    NSMutableArray *waitToRemoveImg = [NSMutableArray new];
    for (int i = 0; i < showArr.count; i++) {
        if ([showArr[i] boolValue] == NO) {
            [waitToRemoveTitle addObject:titleMArr[i]];
            [waitToRemoveImg addObject:imageMArr[i]];
        }
    }
    [titleMArr removeObjectsInArray:waitToRemoveTitle];
    [imageMArr removeObjectsInArray:waitToRemoveImg];
    
    blk(titleMArr, imageMArr);
    
}

- (void)getAlarmConfigData:(CBHomeLeftMenuDeviceInfoModel *)deviceModel blk:(void(^)(NSArray *arrayTitle ,NSArray *arrayTitleImage))blk {
    CBProductSpecModel *targetSpecModel = [self _getSpecModelWithDevice:deviceModel];
    NSMutableArray *titleMArr = [NSMutableArray new];
    NSMutableArray *imageMArr = [NSMutableArray new];
    [titleMArr addObjectsFromArray:@[
        Localized(@"掉电报警"),
        Localized(@"低电报警"),
        Localized(@"盲区报警") ,
        Localized(@"振动报警"),
        Localized(@"油量检测报警")
    ]];
    [imageMArr addObjectsFromArray:@[
        @"掉电报警",
        @"低电报警",
        @"盲区报警",
        @"振动报警",
        @"油量检测报警"
    ]];
    
    NSArray *showArr = @[
        @(targetSpecModel.isShowDiaodian),
        @(targetSpecModel.isShowDidian),
        @(targetSpecModel.isShowBlind),
        @(targetSpecModel.isShowZd),
        @(targetSpecModel.isShowOilCheck),
    ];
    
    if (!self.currentProductSpec) {
        blk(titleMArr, imageMArr);
        return;
    }
    NSMutableArray *waitToRemoveTitle = [NSMutableArray new];
    NSMutableArray *waitToRemoveImg = [NSMutableArray new];
    for (int i = 0; i < showArr.count; i++) {
        if ([showArr[i] boolValue] == NO) {
            [waitToRemoveTitle addObject:titleMArr[i]];
            [waitToRemoveImg addObject:imageMArr[i]];
        }
    }
    [titleMArr removeObjectsInArray:waitToRemoveTitle];
    [imageMArr removeObjectsInArray:waitToRemoveImg];
    
    blk(titleMArr, imageMArr);
}

- (void)getXiumianData:(CBHomeLeftMenuDeviceInfoModel *)deviceModel blk:(void(^)(NSArray *arrayTitle, NSArray *arrayId))blk {
    CBProductSpecModel *targetSpecModel = [self _getSpecModelWithDevice:deviceModel];
    NSMutableArray *titleMArr = [NSMutableArray new];
    NSMutableArray *imageMArr = [NSMutableArray new];
    [titleMArr addObjectsFromArray:@[
        Localized(@"长在线"),
        Localized(@"振动休眠"),
        Localized(@"时间休眠"),
        Localized(@"深度振动休眠"),
        Localized(@"定时报告"),
        Localized(@"定时报告+深度振动休眠")]];
    [imageMArr addObjectsFromArray:@[
        @0, @1, @2, @3, @4, @5
    ]];
    
    NSArray *showArr = @[
        @([targetSpecModel.hibernates containsString:@"0"]),
        @([targetSpecModel.hibernates containsString:@"1"]),
        @([targetSpecModel.hibernates containsString:@"2"]),
        @([targetSpecModel.hibernates containsString:@"3"]),
        @([targetSpecModel.hibernates containsString:@"4"]),
        @([targetSpecModel.hibernates containsString:@"5"]),
    ];
    
    if (!self.currentProductSpec) {
        blk(titleMArr, imageMArr);
        return;
    }
    NSMutableArray *waitToRemoveTitle = [NSMutableArray new];
    NSMutableArray *waitToRemoveImg = [NSMutableArray new];
    for (int i = 0; i < showArr.count; i++) {
        if ([showArr[i] boolValue] == NO) {
            [waitToRemoveTitle addObject:titleMArr[i]];
            [waitToRemoveImg addObject:imageMArr[i]];
        }
    }
    [titleMArr removeObjectsInArray:waitToRemoveTitle];
    [imageMArr removeObjectsInArray:waitToRemoveImg];
    
    blk(titleMArr, imageMArr);
}

- (void)getReportData:(CBHomeLeftMenuDeviceInfoModel *)deviceModel blk:(void(^)(NSArray *sectionArr, NSArray *sectionTitleArr, NSArray *sectionImageTitleArr, NSArray *oilTitleArr, NSArray *oilImageArr, NSArray *warnTitleArr, NSArray *warnImageArr, NSArray *electronicTitleArr, NSArray *electronicImageArr))blk {
    CBProductSpecModel *targetSpecModel = [self _getSpecModelWithDevice:deviceModel];
    NSMutableArray *sectionArr = [NSMutableArray new];
    NSMutableArray *sectionTitleArr = [NSMutableArray new];
    NSMutableArray *sectionImageTitleArr = [NSMutableArray new];
    NSMutableArray *oilTitleArr = [NSMutableArray new];
    NSMutableArray *oilImageArr = [NSMutableArray new];
    NSMutableArray *warnTitleArr = [NSMutableArray new];
    NSMutableArray *warnImageArr = [NSMutableArray new];
    NSMutableArray *electronicTitleArr = [NSMutableArray new];
    NSMutableArray *electronicImageArr = [NSMutableArray new];
    
    [sectionTitleArr addObjectsFromArray:@[
        Localized(@"速度报表"),
        Localized(@"怠速报表"),
        Localized(@"停留统计"),
        Localized(@"点火报表"),
        Localized(@"里程统计"),
        Localized(@"油量统计"),
        Localized(@"报警统计"),
        Localized(@"OBD报表"),
        Localized(@"电子围栏报表")
    ]];
    [sectionImageTitleArr addObjectsFromArray:@[
        @"速度报表", @"怠速报表", @"停留统计", @"点火报表", @"里程统计", @"油量统计", @"报警统计", @"OBD报表", @"电子围栏报表"
    ]];
    
    NSArray *sectionShowArr = @[
        @(targetSpecModel.devShowReport.curvesSpeed),
        @(targetSpecModel.devShowReport.reportIdle),
        @(targetSpecModel.devShowReport.reportStop),
        @(targetSpecModel.devShowReport.reportIgnition),
        @(targetSpecModel.devShowReport.reportMiles),
        @(targetSpecModel.devShowReport.reportOil),
        @(1),
        @(targetSpecModel.devShowReport.reportObd),
        @(targetSpecModel.devShowReport.reportFence),
    ];
    
   
    [oilTitleArr addObjectsFromArray:@[
        Localized(@"日里程耗油报表"), Localized(@"油量里程速度表"), Localized(@"加油报表"), Localized(@"漏油报表")
    ]];
    [oilImageArr addObjectsFromArray:@[
        @"日里程耗油报表",@"油量里程速度表",@"加油报表",@"漏油报表"
    ]];
    
    NSArray *oilShowArr = @[
        @(1),
        @(1),
        @(1),
        @(1),
    ];
    
    [warnTitleArr addObjectsFromArray:@[
        Localized(@"所有报警统计报表"),
        Localized(@"SOS报警统计报表"),
        Localized(@"超速报警统计报表"),
        Localized(@"疲劳驾驶统计报表"),
        Localized(@"欠压报警统计报表"),
        Localized(@"掉电报警统计报表"),
        Localized(@"振动报警统计报表"),
        Localized(@"开门报警统计报表"),
        Localized(@"点火报警统计报表"),
        Localized(@"位移报警统计报表"),
        Localized(@"偷油漏油报警统计报表"),
        Localized(@"碰撞报警报表")
    ]];
    [warnImageArr addObjectsFromArray:@[
        @"所有报警统计报表", @"SOS报警统计报表", @"超速报警统计报表", @"疲劳驾驶统计报表", @"欠压报警统计报表", @"掉电报警统计报表", @"振动报警统计报表", @"开门报警统计报表", @"点火报警统计报表", @"位移报警统计报表", @"偷油漏油报警统计报表", @"碰撞报警报表"
    ]];
    
    NSArray *warnShowArr = @[
        @(targetSpecModel.devShowReport.warmAll),
        @(targetSpecModel.devShowReport.warmSos),
        @(targetSpecModel.devShowReport.warmChaosu),
        @(targetSpecModel.devShowReport.warmTired),
        @(targetSpecModel.devShowReport.warmQianya),
        @(targetSpecModel.devShowReport.warmDiaodian),
        @(targetSpecModel.devShowReport.warmZhendong),
        @(targetSpecModel.devShowReport.warmKaimen),
        @(targetSpecModel.devShowReport.warmDianhuo),
        @(targetSpecModel.devShowReport.warmWeiyi),
        @(targetSpecModel.devShowReport.warmTouyou),
        @(targetSpecModel.devShowReport.warmPz),
    ];
    
    [electronicTitleArr addObjectsFromArray:@[
        Localized(@"入围栏报警报表"), Localized(@"出围栏报警报表"), Localized(@"出入围栏报警报表")
    ]];
    [electronicImageArr addObjectsFromArray:@[
        @"入围栏报警报表", @"出围栏报警报表", @"出入围栏报警报表"
    ]];
    
    NSArray *electronicShowArr = @[
        @(1),@(1),@(1),
    ];
    
    
    if (!self.currentProductSpec) {
        blk(sectionArr, sectionTitleArr, sectionImageTitleArr, oilTitleArr, oilImageArr, warnTitleArr, warnImageArr, electronicTitleArr, electronicImageArr);
        return;
    }
    [self processArrayData:sectionTitleArr withShowData:sectionShowArr];
    [self processArrayData:sectionImageTitleArr withShowData:sectionShowArr];
    for (id obj in sectionTitleArr) {
        [sectionArr addObject:@0];
    }
    
    [self processArrayData:oilTitleArr withShowData:oilShowArr];
    [self processArrayData:oilImageArr withShowData:oilShowArr];
    
    [self processArrayData:warnTitleArr withShowData:warnShowArr];
    [self processArrayData:warnImageArr withShowData:warnShowArr];
    
    [self processArrayData:electronicTitleArr withShowData:electronicShowArr];
    [self processArrayData:electronicImageArr withShowData:electronicShowArr];
    
    blk(sectionArr, sectionTitleArr, sectionImageTitleArr, oilTitleArr, oilImageArr, warnTitleArr, warnImageArr, electronicTitleArr, electronicImageArr);
}

- (void)processArrayData:(NSMutableArray *)arrayData withShowData:(NSArray<NSNumber *> *)showArray {
    NSMutableArray *waitToRemoveArr = [NSMutableArray new];
    for (int i = 0; i < showArray.count; i++) {
        if ([showArray[i] boolValue] == NO) {
            [waitToRemoveArr addObject:arrayData[i]];
        }
    }
    [arrayData removeObjectsInArray:waitToRemoveArr];
}

- (NSString *)getProductSpec:(CBHomeLeftMenuDeviceInfoModel *)devModel {
    CBProductSpecModel *defaultModel = nil;
    for (CBProductSpecModel *model in self.productSpecData) {
        if ([model.tbDevModelId isEqualToString:@"70"] && [model.proto isEqualToString:@"0"]) {
            defaultModel = model;
        }
        if ([devModel.proto isEqualToString:model.proto] && [devModel.productSpecId isEqualToString:model.tbDevModelId]) {
            return model.name;
        }
    }
        
    return defaultModel ? defaultModel.name : Localized(@"未知");
}
@end
