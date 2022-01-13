//
//  CBControlSetRestPopView.h
//  Telematics
//
//  Created by coban on 2019/11/22.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CBControlSetRestPopViewDelegate <NSObject>

- (void)pickerRestPopViewClickIndex:(NSInteger)index time:(NSString *)time unit:(NSString *)unit;

@end

@interface CBControlSetRestPopView : UIView

@property (nonatomic,weak) id <CBControlSetRestPopViewDelegate>delegate;

- (void)updateType:(NSString *)type;
- (void)popView;//弹出视图
- (void)dismiss;//隐藏视图

@end

NS_ASSUME_NONNULL_END
