//
//  _CBWIFIModel.m
//  cobanBnPetSwift
//
//  Created by zzer on 2023/4/3.
//  Copyright © 2023 coban. All rights reserved.
//

#import "_CBWIFIModel.h"

@implementation _CBWIFIModel_WIFI

@end

@implementation _CBWIFIModel_ROW

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"idd":@"id"
             };
}

@end

@implementation _CBWIFIModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"row": _CBWIFIModel_ROW.class
    };
}

@end
