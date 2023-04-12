//
//  CBRealTimeVideoController.h
//  cobanBnPetSwift
//
//  Created by zzer on 2023/4/11.
//  Copyright © 2023 coban. All rights reserved.
//

#import "MINBaseViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBRealTimeVideoController : MINBaseViewController

@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *dno;

@end

NS_ASSUME_NONNULL_END
