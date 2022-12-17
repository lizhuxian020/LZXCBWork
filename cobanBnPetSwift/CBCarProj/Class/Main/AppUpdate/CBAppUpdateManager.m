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
            if ([self checkCanshow]) {
                [[CBCarAlertView viewWithAlertTips:comment
                                             title:Localized(@"有升级")
                                            cancel:^{
                    
                }
                                           confrim:^(NSString * _Nonnull contentStr) {
                    [UIApplication.sharedApplication openURL:[NSURL URLWithString:@"https://apps.apple.com/cn/app/asd"]]; //TODO: lzxTODO appid
                }] pop];;
            }
        }
//        else {
//            if ([self checkCanshow]) {
//                [[CBCarAlertView viewWithAlertTips:comment
//                                             title:Localized(@"有升级test")
//                                            cancel:^{
//                    
//                }
//                                           confrim:^(NSString * _Nonnull contentStr) {
//                    [UIApplication.sharedApplication openURL:[NSURL URLWithString:@"https://apps.apple.com/cn/app/asd"]]; //TODO: lzxTODO appid
//                }] pop];;
//            }
//        }
    } failed:^(NSError *error) {
        
    }];
}

- (BOOL)checkCanshow {
    NSNumber *time = [[NSUserDefaults standardUserDefaults] objectForKey:@"__APP_UPDATE_TIME"];
    if (!time) {
        [[NSUserDefaults standardUserDefaults] setObject:@(NSDate.date.timeIntervalSince1970) forKey:@"__APP_UPDATE_TIME"];
        return YES;
    }
    NSTimeInterval timeLast = time.doubleValue;
    if ((NSDate.date.timeIntervalSince1970 - timeLast) > 60 *60*24*7) {
        [[NSUserDefaults standardUserDefaults] setObject:@(NSDate.date.timeIntervalSince1970) forKey:@"__APP_UPDATE_TIME"];
        return YES;
    }
    return NO;
}
@end
