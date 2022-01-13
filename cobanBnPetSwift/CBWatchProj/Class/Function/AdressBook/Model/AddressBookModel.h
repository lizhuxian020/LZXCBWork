//
//  AddressBookModel.h
//  Watch
//
//  Created by lym on 2018/3/30.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBookModel : NSObject
//@property (nonatomic, copy) NSString *ids;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *relation;
@property (nonatomic, copy) NSString *relationId;
@property (nonatomic, copy) NSString *sno;
@property (nonatomic, copy) NSString *reUserId;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *family; //0-校讯通，1-家庭
@property (nonatomic, assign) BOOL flag;  //是否第一授权人：0-否，1-是
@property (nonatomic, assign) BOOL autoConnect; //是否自动接通：0-否，1-是
@property (nonatomic, assign) int status; //0,状态：0-待审核（拒绝），1-通过 （第一授权人默认为通过)
@property (nonatomic, assign) int type; //类型：0-家庭成员，1-校友
@property (nonatomic, assign) int userId; //监护人id
@property (nonatomic, assign) BOOL isAutoConnect;
@property (nonatomic, assign) BOOL isBindAction;
@end

@interface AddressBookEditModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int famlily;
@property (nonatomic, assign) BOOL isSelect;

@end
