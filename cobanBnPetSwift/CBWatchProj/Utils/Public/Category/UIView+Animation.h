//
//  UIView+Animation.h
//  PowerBank
//
//  Created by 麦鱼科技 on 2017/7/12.
//  Copyright © 2017年 麦鱼科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)


/**
 旋转动画

 @param time 动画时长
 */
- (void)rotateAnimationWithTime:(NSTimeInterval)time;

- (void)endAnimation;

- (void)alertAnimationWithDuration:(CFTimeInterval)duration;

@end
