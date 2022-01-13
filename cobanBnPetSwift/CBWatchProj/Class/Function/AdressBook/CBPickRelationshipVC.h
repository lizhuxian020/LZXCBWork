//
//  CBPickRelationshipVC.h
//  cobanBnWatch
//
//  Created by coban on 2019/12/11.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBWtBaseViewController.h"
@class AddressBookModel;

NS_ASSUME_NONNULL_BEGIN

@interface CBPickRelationshipVC : CBWtBaseViewController

/** 是否已被绑定，被绑定则有管理员 */
@property (nonatomic, assign) BOOL hasAdmin;
/** 是否为添加联系人 NO 绑定手表 */
@property (nonatomic, assign) BOOL isAddContact;
/** 是否为修改联系人 */
@property (nonatomic, assign) BOOL isModifyRelation; 
@property (nonatomic, strong) AddressBookModel *model;
/** 绑定的手表sno */
@property (nonatomic, copy) NSString *sno;

@end

NS_ASSUME_NONNULL_END
