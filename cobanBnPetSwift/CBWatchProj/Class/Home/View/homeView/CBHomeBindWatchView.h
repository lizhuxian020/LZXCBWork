//
//  CBHomeBindWatchView.h
//  Watch
//
//  Created by coban on 2019/8/19.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBHomeBindWatchView : UIView
@property (nonatomic,copy) void(^bindWatchBlock)(id objc);
@end

NS_ASSUME_NONNULL_END
