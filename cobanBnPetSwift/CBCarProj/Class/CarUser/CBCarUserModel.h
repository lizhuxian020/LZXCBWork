//
//  CBCarUserModel.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/17.
//  Copyright © 2022 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBCarUserModel : NSObject

@property(nonatomic, copy) NSString *account;// "18702777364",
@property(nonatomic, copy) NSString *address;// null,
@property(nonatomic, copy) NSString *auth;// 2,
@property(nonatomic, copy) NSString *city;// null,
@property(nonatomic, copy) NSString *code;// "86",
@property(nonatomic, copy) NSString *comment;// null,
@property(nonatomic, copy) NSString *createTime;// 1591922638000,
@property(nonatomic, copy) NSString *email;// "99999",
@property(nonatomic, copy) NSString *fatherId;// null,
@property(nonatomic, copy) NSString *id;// 188,
@property(nonatomic, copy) NSString *level;// 0,
@property(nonatomic, copy) NSString *loginTime;// 1671173507000,
@property(nonatomic, copy) NSString *name;// "18702777364",
@property(nonatomic, copy) NSString *password;// "dc483e80a7a0bd9ef71d8cf973673924",
@property(nonatomic, copy) NSString *phone;// "18702777364",
@property(nonatomic, copy) NSString *photo;// "http://cdn.clw.gpstrackerxy.com/Picture/20221216/1671176652HUWFo7Oq.jpg",
@property(nonatomic, copy) NSString *prov;// null,
@property(nonatomic, copy) NSString *region;// null,
@property(nonatomic, copy) NSString *status;// 0,
@property(nonatomic, copy) NSString *terminalType;// 1,
@property(nonatomic, copy) NSString *token;// null,
@property(nonatomic, copy) NSString *typeInfo;// null



@end

@interface CBCarUserInstance : NSObject

@property (nonatomic, strong) CBCarUserModel *userModel;

+(instancetype)shared;

@end

NS_ASSUME_NONNULL_END
