//
//  CBGuardSliderView.h
//  Watch
//
//  Created by coban on 2019/9/2.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBGuardSliderView : UIView
@property (nonatomic,copy) void(^sliderValueChangeBlock)(id objc);
@property (nonatomic,assign) NSInteger currentValue;
@end

NS_ASSUME_NONNULL_END
