//
//  TimeRepeatViewController.h
//  Watch
//
//  Created by lym on 2018/2/10.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "CBWtBaseViewController.h"

@protocol TimeRepeatViewControllerDelegate
- (void)timeRepeatViewControllerDidSelectTime:(NSString *)time;
@end

@interface TimeRepeatViewController : CBWtBaseViewController
@property (nonatomic, weak) id<TimeRepeatViewControllerDelegate> delegate;
@end
