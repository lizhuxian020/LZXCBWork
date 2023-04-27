//
//  CBBasePopManager.m
//  cobanBnPetSwift
//
//  Created by zzer on 2023/4/27.
//  Copyright © 2023 coban. All rights reserved.
//

#import "CBBasePopManager.h"

@implementation CBBasePopManager

+ (instancetype)share {
    static CBBasePopManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [CBBasePopManager new];
    });
    return m;
}

@end
