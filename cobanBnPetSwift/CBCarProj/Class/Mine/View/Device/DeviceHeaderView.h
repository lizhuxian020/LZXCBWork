//
//  DeviceHeaderView.h
//  Telematics
//
//  Created by lym on 2017/11/6.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceHeaderView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *arrowImageBtn;
@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, copy) void (^headerBtnClick)(NSInteger section);
@property (nonatomic, copy) void (^deleteBtnClick)(NSInteger section);
@property (nonatomic, copy) void (^leftSwipeClick)(DeviceHeaderView *headView);
@property (nonatomic, copy) void (^headerLongPressGesture)(NSInteger section, DeviceHeaderView *headView);
- (void)addLeftGesture;
- (void)showDeleteBtn;
- (void)hideDeleteBtn;
@end
