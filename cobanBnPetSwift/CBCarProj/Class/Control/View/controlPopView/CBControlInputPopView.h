//
//  CBControlInputPopView.h
//  Telematics
//
//  Created by coban on 2019/11/21.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CBControlInputPopViewDelegate <NSObject>

- (void)updateTextFieldValue:(NSString *)inputStr returnTitle:(NSString *)title;

@end
@interface CBControlInputPopView : UIView

@property (nonatomic,weak) id <CBControlInputPopViewDelegate>delegate;
@property (nonatomic,strong) UITextField *inputTF;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIButton *certainBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
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
