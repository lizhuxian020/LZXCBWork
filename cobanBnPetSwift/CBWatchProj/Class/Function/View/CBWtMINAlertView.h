//
//  CBWtMINAlertView.h
//  Telematics
//
//  Created by lym on 2017/11/2.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBWtMINAlertView : UIView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *leftBottomBtn;
//@property (nonatomic, strong) UIButton *rightBottomBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) void (^leftBtnClick)(void);
//@property (nonatomic, copy) void (^rightBtnClick)();
- (void)showRightCloseBtn;
- (void)setContentViewHeight:(CGFloat)height;
- (void)hideView;
@end
