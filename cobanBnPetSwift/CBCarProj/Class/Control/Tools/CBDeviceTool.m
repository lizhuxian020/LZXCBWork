//
//  CBDeviceTool.m
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/9.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBDeviceTool.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface CBDeviceTool ()

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

@end
