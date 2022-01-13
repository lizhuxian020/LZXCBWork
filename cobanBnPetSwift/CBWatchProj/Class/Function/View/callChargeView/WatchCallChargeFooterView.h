//
//  WatchCallChargeFooterView.h
//  Watch
//
//  Created by lym on 2018/2/23.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatchCallChargeFooterView : UIView
@property (nonatomic, strong) UIButton *queryBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *checkAllBtn;
@property (nonatomic, copy) void (^checkAllBtnClickBlock)(BOOL isSelected);
@property (nonatomic, copy) void (^deleteBtnClickBlock)(void);
@property (nonatomic, copy) void (^queryBtnClickBlock)(void);
- (void)changeStatus:(BOOL)isEdit;
@end
