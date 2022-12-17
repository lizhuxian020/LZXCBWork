//
//  CBAppUpdateManager.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/17.
//  Copyright © 2022 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBAppUpdateManager : NSObject

+ (instancetype)shared;

- (void)check;

@end

NS_ASSUME_NONNULL_END
