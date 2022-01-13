//
//  CBNewFenceMenuView.h
//  Telematics
//
//  Created by coban on 2020/1/2.
//  Copyright © 2020 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CBNewFenceMenuViewDelegate <NSObject>

- (void)clickType:(NSInteger)index;

@end

@interface CBNewFenceMenuView : UIView

@property (nonatomic,weak) id<CBNewFenceMenuViewDelegate>delegate;

- (void)popView;//弹出视图
- (void)dismiss;//隐藏视图

@end

NS_ASSUME_NONNULL_END
