//
//  CBControlPickPopView.h
//  Telematics
//
//  Created by coban on 2019/11/21.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CBControlPickPopViewDelegate <NSObject>

- (void)pickerPopViewClickIndex:(NSInteger)index;

@end

@interface CBControlPickPopView : UIView

@property (nonatomic,weak) id <CBControlPickPopViewDelegate>delegate;

- (void)updateTitle:(NSString *)title menuArray:(NSArray *)array seletedTitle:(NSString *)seletedTitle;
- (void)popView;//弹出视图
- (void)dismiss;//隐藏视图
@end

NS_ASSUME_NONNULL_END
