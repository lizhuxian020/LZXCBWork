//
//  SubAccountModel.h
//  Telematics
//
//  Created by lym on 2017/12/28.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SubAccountSubDeviceModel;

@interface SubAccountModel : NSObject
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *auth;
@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSArray *subDevice;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *create_time;

@end


@interface SubAccountSubDeviceModel : NSObject
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *ids;
@property (nonatomic, copy) NSString *userId;

@end

@interface SubAccountAddModel : NSObject

@property (nonatomic, copy) NSString *childName;
@property (nonatomic, copy) NSString *childNamePlacehold;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *namePlacehold;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, copy) NSString *pwdPlacehold;
@property (nonatomic, copy) NSString *secondPwd;
@property (nonatomic, copy) NSString *secondPwdPlacehold;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *phonePlacehold;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *emailPlacehold;

@property (nonatomic, copy) NSString *textStr;
@property (nonatomic, copy) NSString *textPlacehold;

@end
