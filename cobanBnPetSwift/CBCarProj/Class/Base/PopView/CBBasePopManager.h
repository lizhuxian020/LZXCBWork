//
//  CBBasePopManager.h
//  cobanBnPetSwift
//
//  Created by zzer on 2023/4/27.
//  Copyright © 2023 coban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBBasePopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBBasePopManager : NSObject

+(instancetype)share;

@property (nonatomic, strong) CBBasePopView *currentPopView;

@end

NS_ASSUME_NONNULL_END
