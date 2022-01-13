//
//  WatchModel.h
//  Watch
//
//  Created by lym on 2018/4/16.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WatchModel : NSObject
@property (nonatomic, copy) NSString *sno;
@property (nonatomic, copy) NSString *isAutoConnect;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *relationId;
@property (nonatomic, copy) NSString *watchID;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@end
