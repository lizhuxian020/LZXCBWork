//
//  CBTalkFootView.h
//  Watch
//
//  Created by coban on 2019/8/26.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CBTalkFootViewDelegate <NSObject>

- (void)recordingActionResponseEvent:(UIGestureRecognizerState)gestureState;

@end

@interface CBTalkFootView : UIView
@property (nonatomic,weak) id<CBTalkFootViewDelegate> delegate;
@property (nonatomic,copy) void(^returnBlock)(id objc);
@property (nonatomic,copy) void(^recordingDoneBlock)(id objc);
@end

NS_ASSUME_NONNULL_END
