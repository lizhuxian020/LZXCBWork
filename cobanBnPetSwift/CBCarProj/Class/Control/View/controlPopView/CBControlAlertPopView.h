//
//  CBControlAlertPopView.h
//  Telematics
//
//  Created by coban on 2019/11/22.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CBControlAlertPopViewDelegate <NSObject>

- (void)clickType:(NSString *)title;

@end
@interface CBControlAlertPopView : UIView

@property (nonatomic,weak) id<CBControlAlertPopViewDelegate>delegate;

- (void)updateTitle:(NSString *)title msg:(NSString *)msgStr;
- (void)popView;//弹出视图
- (void)dismiss;//隐藏视图

@end

NS_ASSUME_NONNULL_END
