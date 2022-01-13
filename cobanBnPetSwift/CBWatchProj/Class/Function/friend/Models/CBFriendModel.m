//
//  CBFriendModel.m
//  Watch
//
//  Created by coban on 2019/8/27.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBFriendModel.h"

@implementation CBFriendModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ids":@"id"
             };
}
@end
