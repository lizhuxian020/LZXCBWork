//
//  CBProductSpecModel.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/13.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBProductSpecModel.h"

@implementation CBProductSpecReportModel
@end

@implementation CBProductSpecModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"pId":@"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"devShowReport": CBProductSpecReportModel.class
    };
}

@end
