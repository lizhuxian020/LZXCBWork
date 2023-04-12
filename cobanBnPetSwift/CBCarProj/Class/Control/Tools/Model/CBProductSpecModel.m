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

- (BOOL)isShowOverSpeed {
    return [_alarmSwitch containsString:@"6"];
}
- (BOOL)isShowDiaodian {
    return [_alarmSwitch containsString:@"1"];
}
- (BOOL)isShowDidian {
    return [_alarmSwitch containsString:@"2"];
}
- (BOOL)isShowBlind {
    return [_alarmSwitch containsString:@"3"];
}
- (BOOL)isShowZd {
    return [_alarmSwitch containsString:@"8"];
}
- (BOOL)isShowOilCheck {
    return [_alarmSwitch containsString:@"7"];
}

- (BOOL)isShowChaiChu {
    return [_alarmSwitch containsString:@"9"];
}

@end
