//
//  CBPetWakeUpPopView.h
//  cobanBnPetSwift
//
//  Created by hsl on 2021/12/3.
//  Copyright © 2021 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CBPetWakeUpPopViewDelegate <NSObject>

- (void)updateTextFieldValue:(NSString *)inputStr returnTitle:(NSString *)title;

@end

@interface CBPetWakeUpPopView : UIView

@property (nonatomic,weak) id <CBPetWakeUpPopViewDelegate>delegate;
@property (nonatomic,strong) UITextField *inputTF;

/**
 输入弹出框

 @param title 标题
 @param placeholdStr 输入框占位字符
 @param isDigital 输入格式是否为数字
 */
- (void)updateTitle:(NSString *)title
          placehold:(NSString *)placeholdStr
          isDigital:(BOOL)isDigital;
- (void)popView;//弹出视图
- (void)dismiss;//隐藏视图

@end

NS_ASSUME_NONNULL_END
