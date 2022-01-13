//
//  HomeModel.m
//  Watch
//
//  Created by lym on 2018/3/29.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "HomeModel.h"

//首页设备信息保存地址
#define CBDeviceFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CBDevice.data"]


@implementation HomeModel
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ids":@"id"
             };
}

/***  存储首页设备信息  */
+ (BOOL)saveCBDevice:(HomeModel *)device {
    return  [NSKeyedArchiver archiveRootObject:device toFile:CBDeviceFile];
}

/** 返回存储的设备信息 */
+ (HomeModel *)CBDevice {
    // 取出设备信息
    @try {
        HomeModel *device = [NSKeyedUnarchiver unarchiveObjectWithFile:CBDeviceFile];
        return device;
    }
    @catch (NSException *exception) {
        NSLog(@"==异常");
        return nil;
    }
    @finally {
    }
}

/***  删除本地设备信息 */
+ (BOOL)deleteCBdevice {
    if (!CBDeviceFile) {
        return NO;
    } else {
        return [[NSFileManager defaultManager] removeItemAtPath:CBDeviceFile error:nil];
    }
}
@end


@implementation HomeInfoDetailModel
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ids":@"id"
             };
}

@end
