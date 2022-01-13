//
//  NotifactionCenterFooterView.h
//  Watch
//
//  Created by lym on 2018/3/7.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifactionCenterFooterView : UIView
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *checkAllBtn;
@property (nonatomic, copy) void (^checkAllBtnClickBlock)(BOOL isSelected);
@property (nonatomic, copy) void (^deleteBtnClickBlock)(void);
//- (void)changeStatus:(BOOL)isEdit;
@end
