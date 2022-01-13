//
//  CBFriendModel.h
//  Watch
//
//  Created by coban on 2019/8/27.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBFriendModel : NSObject

@property (nonatomic, copy) NSString *ids;
@property (nonatomic, copy) NSString *bindTime;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *friendBlueAddress;
@property (nonatomic, copy) NSString *friendSno;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *myBlueAddress;
@property (nonatomic, copy) NSString *mySno;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, assign) BOOL isCheck;
@property (nonatomic, assign) BOOL isEdit;

@end

NS_ASSUME_NONNULL_END
