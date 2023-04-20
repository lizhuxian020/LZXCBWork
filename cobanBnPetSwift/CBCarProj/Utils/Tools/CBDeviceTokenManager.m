//
//  CBDeviceTokenManager.m
//  cobanBnPetSwift
//
//  Created by zzer on 2023/4/20.
//  Copyright © 2023 coban. All rights reserved.
//

#import "CBDeviceTokenManager.h"
#import "cobanBnPetSwift-Swift.h"

@implementation CBDeviceTokenManager

+ (instancetype)shared {
    static CBDeviceTokenManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [CBDeviceTokenManager new];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //监听登录
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(uploadDeviceToken) name:@"NOTIFICATION_UPDATE_USER" object:nil];
    }
    return self;
}

- (void)uploadDeviceToken {
    CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
    if (kStringIsEmpty(userModel.token)) {
        return;
    }
    //上传Token给
    [[NetWorkingManager shared] getWithUrl:@"/userController/setPushInfo" params:@{
            @"mobileType": @"1",
            @"token": _deviceToken ?: @"",
        } succeed:^(id response, BOOL isSucceed) {
            
        } failed:^(NSError *error) {
            
        }];
}

- (void)setDeviceToken:(NSString *)deviceToken {
    _deviceToken = deviceToken;
    [self uploadDeviceToken];
}


@end
