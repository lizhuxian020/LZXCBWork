//
//  CBTalkModel.m
//  Watch
//
//  Created by coban on 2019/9/5.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBTalkModel.h"

@implementation CBTalkModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ids":@"id"
             };
}
@end

@implementation CBTalkMemberModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ids":@"id"
             };
}
@end

@implementation CBTalkListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ids":@"id"
             };
}
@end

