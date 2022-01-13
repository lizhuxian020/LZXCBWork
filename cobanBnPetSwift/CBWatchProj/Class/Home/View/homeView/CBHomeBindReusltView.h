//
//  CBHomeBindReusltView.h
//  Watch
//
//  Created by coban on 2019/8/19.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBHomeBindReusltView : UIView
@property (nonatomic,copy) void(^bindWatchResultBlock)(id objc);
@end

NS_ASSUME_NONNULL_END
