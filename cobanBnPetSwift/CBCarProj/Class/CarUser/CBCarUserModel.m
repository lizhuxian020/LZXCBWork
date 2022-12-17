//
//  CBCarUserModel.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/17.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBCarUserModel.h"

@implementation CBCarUserModel

@end

@implementation CBCarUserInstance

+(instancetype)shared {
    static CBCarUserInstance *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [CBCarUserInstance new];
    });
    return model;
}

@end
