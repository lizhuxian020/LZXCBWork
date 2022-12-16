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
    [MBProgressHUD showHUDIcon:window animated:YES];
    
    [[NetWorkingManager shared]postWithUrl:@"/productSpec/getInfo" params:@{} succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:window animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray<CBProductSpecModel *> *modelArr = [CBProductSpecModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                for (CBProductSpecModel *model in modelArr) {
                    [self.productSepcArr addObject:model.name];
                    [self.productSepcIdArr addObject:model.pId];
                    if ([model.proto isEqualToString:currentModel.proto] && [model.tbDevModelId isEqualToString:currentModel.productSpecId]) {
                        self.currentProductSpec = model;
                    }
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

- (void)getControlData:(void(^)(NSArray *arrayTitle ,NSArray *arrayTitleImage))blk {
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
        @(_currentProductSpec.singlePosition),
        @(_currentProductSpec.autoPosition),
        @(_currentProductSpec.callBack),
        @(_currentProductSpec.oilElectricityControl),
        @(_currentProductSpec.oilElectricityControl),
        @(_currentProductSpec.arm),
        @(_currentProductSpec.motorControl),
        @(_currentProductSpec.remoteStart),
        @(_currentProductSpec.arm),
        @(_currentProductSpec.callChargeInquiry),
        @(_currentProductSpec.isShowOverSpeed),
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

- (void)getDeviceConfigData:(void(^)(NSArray *arrayTitle ,NSArray *arrayTitleImage))blk {
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
        @(_currentProductSpec.timeSet),
        @(_currentProductSpec.passwordSet),
        @(_currentProductSpec.authCode),
        @(_currentProductSpec.tankVolume),
        @(_currentProductSpec.fuelSensorCalibration),
        @(_currentProductSpec.mileageInitialValue),
        @(_currentProductSpec.accWorkNotice),
        @(_currentProductSpec.gpsDriftSuppression),
        @(_currentProductSpec.turnSupplement),
        @(0), //一直不显示
        @(_currentProductSpec.setGprsHeartbeat),
        @(_currentProductSpec.sensitivitySet),
        @(_currentProductSpec.initializeSet),
        @(_currentProductSpec.hardwareReboot),
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

- (void)getAlarmConfigData:(void(^)(NSArray *arrayTitle ,NSArray *arrayTitleImage))blk {
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
        @(_currentProductSpec.isShowDiaodian),
        @(_currentProductSpec.isShowDidian),
        @(_currentProductSpec.isShowBlind),
        @(_currentProductSpec.isShowZd),
        @(_currentProductSpec.isShowOilCheck),
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

- (void)getXiumianData:(void(^)(NSArray *arrayTitle, NSArray *arrayId))blk {
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
        @([_currentProductSpec.hibernates containsString:@"0"]),
        @([_currentProductSpec.hibernates containsString:@"1"]),
        @([_currentProductSpec.hibernates containsString:@"2"]),
        @([_currentProductSpec.hibernates containsString:@"3"]),
        @([_currentProductSpec.hibernates containsString:@"4"]),
        @([_currentProductSpec.hibernates containsString:@"5"]),
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
@end
