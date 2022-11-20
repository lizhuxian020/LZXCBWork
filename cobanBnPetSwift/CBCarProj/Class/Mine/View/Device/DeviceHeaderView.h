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
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, copy) void (^headerBtnClick)(NSInteger section);
@property (nonatomic, copy) void (^deleteBtnClick)(NSInteger section);
@property (nonatomic, copy) void (^editBtnClick)(NSInteger section,DeviceHeaderView *headView);
@property (nonatomic, copy) void (^leftSwipeClick)(DeviceHeaderView *headView);
@property (nonatomic, copy) void (^headerLongPressGesture)(NSInteger section, DeviceHeaderView *headView);
@property (nonatomic, strong) UISwipeGestureRecognizer *gesture;
- (void)addLeftGesture;
- (void)showDeleteBtn;
- (void)hideDeleteBtn;
@end
