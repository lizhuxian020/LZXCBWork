//
//  CBHomeLeftMenuView.h
//  Telematics
//
//  Created by coban on 2019/7/17.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBHomeLeftMenuView : UIView
@property (nonatomic,copy) void(^leftMenuBlock)(id objc);
- (instancetype)initWithFrame:(CGRect)frame withSlideArray:(NSMutableArray *)slideArray index:(NSInteger)index;
- (void)requestData;
@end

NS_ASSUME_NONNULL_END
