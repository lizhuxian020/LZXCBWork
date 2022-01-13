//
//  UIButton+ImageAndTitle.h
//  KCBuinessKey
//
//  Created by KC on 16/1/5.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ImageAndTitle)
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;
- (void) setRightImage:(UIImage *)image withLeftTitle:(NSString *)title forState:(UIControlState)stateType;
- (void) setImage:(UIImage *)image withTitle:(NSString *)title titleTopInset:(CGFloat)titleTopInset imageTopInset:(CGFloat)imageTopInset forState:(UIControlState)stateType;
@end
