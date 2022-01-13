//
//  CBControlSetServicePopView.h
//  Telematics
//
//  Created by coban on 2019/11/21.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CBControlSetServicePopViewDelegate <NSObject>

- (void)returnTextFieldValueTimeStr:(NSString *)timeStr serviceFlagStr:(NSString *)serviceFlagStr;

@end

@interface CBControlSetServicePopView : UIView

@property (nonatomic,weak) id <CBControlSetServicePopViewDelegate>delegate;

- (void)popView;//弹出视图
- (void)dismiss;//隐藏视图

@end

NS_ASSUME_NONNULL_END
