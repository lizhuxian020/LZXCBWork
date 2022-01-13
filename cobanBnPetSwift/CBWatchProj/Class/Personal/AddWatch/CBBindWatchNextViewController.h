//
//  CBBindWatchNextViewController.h
//  cobanBnWatch
//
//  Created by coban on 2019/11/27.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBWtBaseViewController.h"
@class AddressBookEditModel;

NS_ASSUME_NONNULL_BEGIN

@interface CBBindWatchNextViewController : CBWtBaseViewController
@property (nonatomic,copy) NSString *sno;
@property (nonatomic,assign) BOOL hasAdmin;
@property (nonatomic, strong) AddressBookEditModel *model;
@end

NS_ASSUME_NONNULL_END
