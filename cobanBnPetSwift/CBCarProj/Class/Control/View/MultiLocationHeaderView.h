//
//  MultiLocationHeaderView.h
//  Telematics
//
//  Created by lym on 2017/11/27.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiLocationHeaderView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *timingImageBtn;
@property (nonatomic, strong) UIButton *distanceImageBtn;
@property (nonatomic, strong) UIButton *timingAndDistanceImageBtn;

@property (nonatomic, strong) UILabel *timetF;

@property (nonatomic, copy) void (^timingBtnClickBlock)();
@property (nonatomic, copy) void (^distanceBtnClickBlock)();
@property (nonatomic, copy) void (^timingAndDistanceBtnClickBlock)();
- (void)setSelectBtn:(int)type;// 0 定时 1 定距 2 定时定距
- (NSNumber *)getSelectBtn;
@end
