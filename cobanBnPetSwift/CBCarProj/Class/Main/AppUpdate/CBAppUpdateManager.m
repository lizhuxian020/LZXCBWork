//
//  CBAppUpdateManager.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/17.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBAppUpdateManager.h"

@implementation CBAppUpdateManager

+ (instancetype)shared {
    static CBAppUpdateManager *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [CBAppUpdateManager new];
    });
    return model;
}

- (void)check {
    [[NetWorkingManager shared] getWithUrl:@"/systemController/getSystemConfig" params:@{
        @"type" : @1
    } succeed:^(id response, BOOL isSucceed) {
        if (!isSucceed || !response || !response[@"data"]) {
            return;
        }
        NSString *version = response[@"data"][@"version"];
        NSString *download = response[@"data"][@"download"];
        NSString *comment = response[@"data"][@"comment"];
        NSString *isForce = response[@"data"][@"isForce"];
        if (kStringIsEmpty(version) || kStringIsEmpty(download)) {
            return;
        }
        NSString *appVersion = [CBWtCommonTools appVersion];
        if ([version hasPrefix:@"v"]) {
            version = [version stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        }
        double versionD = version.doubleValue;
        double appD = appVersion.doubleValue;
        if (versionD > appD) {
        [[CBCarAlertView viewWithAlertTips:comment title:Localized(@"有升级") confrim:^(NSString * _Nonnull contentStr) {
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:download]];
        }] pop];;
        }
//        else {
//            [[CBCarAlertView viewWithAlertTips:comment title:Localized(@"有升级test") confrim:^(NSString * _Nonnull contentStr) {
//                [UIApplication.sharedApplication openURL:[NSURL URLWithString:download]];
//            }] pop];
//        }
    } failed:^(NSError *error) {
        
    }];
}
@end
