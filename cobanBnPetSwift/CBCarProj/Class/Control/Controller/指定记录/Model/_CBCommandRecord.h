//
//  _CBCommandRecord.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/3.
//  Copyright © 2022 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface _CBCommandRecord : NSObject

@property(nonatomic, copy) NSString *cmd;
@property (nonatomic, assign) NSInteger status;//0：发送中，1：发送成功，2发送失败
@property (nonatomic, copy) NSString *createTime;

- (NSString *)cmdName;
- (NSString *)statusName;

//{
//        "cmd": "TIME_ZONE",
//        "comment": null,
//        "createTime": 1670037913000,
//        "dno": "585965120000101",
//        "id": 1598881008683433985,
//        "param": "{\"methordName\":\"updateDeviceStatusCommand\",\"timeZone\":\"+8\"}",
//        "status": 0,
//        "uid": 188,
//        "userName": "18702777364"
//    }, {
@end

NS_ASSUME_NONNULL_END
