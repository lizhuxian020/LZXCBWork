//
//  CBDeviceTokenManager.h
//  cobanBnPetSwift
//
//  Created by zzer on 2023/4/20.
//  Copyright © 2023 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBDeviceTokenManager : NSObject

@property (nonatomic, copy) NSString *deviceToken;

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
