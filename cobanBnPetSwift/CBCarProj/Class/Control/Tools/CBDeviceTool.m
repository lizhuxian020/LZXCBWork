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
        @(_currentProductSpec.arm||_currentProductSpec.silentArm||_currentProductSpec.disarm),
        @(_currentProductSpec.callChargeInquiry),
        @(1), //TODO: lzxTODO 哪里的?
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


@end
