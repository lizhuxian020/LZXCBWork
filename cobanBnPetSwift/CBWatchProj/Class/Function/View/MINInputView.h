//
//  MINInputView.h
//  Watch
//
//  Created by lym on 2018/2/8.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MINInputView : UIView
@property (nonatomic, strong) UITextField *textField;

//- (void)setTextFieldPlaceHold:(NSString *)placeHold;
- (void)updateLeftTitle:(NSString *)titleStr
                   text:(NSString *)textStr
              placehold:(NSString *)placeHoldStr;
@end
