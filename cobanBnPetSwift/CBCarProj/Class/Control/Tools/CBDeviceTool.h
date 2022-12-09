//
//  CBDeviceTool.h
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/9.
//  Copyright © 2022 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBDeviceTool : NSObject
+ (instancetype)shareInstance;

- (void)getDeviceNames:(void(^)(NSArray<NSString *> *deviceNames))blk;

@end

NS_ASSUME_NONNULL_END
