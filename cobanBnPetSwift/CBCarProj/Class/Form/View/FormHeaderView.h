//
//  FormHeaderView.h
//  Telematics
//
//  Created by lym on 2017/11/15.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormHeaderView : UIView
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *arrowImageBtn;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, copy) void (^headerBtnClick)(NSInteger section);
@property (nonatomic, strong) UILabel *exTitleLabel;
@property (nonatomic, strong) UIButton *exArrowImageBtn;
- (void)setDownforwardImage;
//- (void)setCornerWithSection:(NSInteger)section;
- (void)checkIfShowBottomLine:(NSArray *)imageArray currentIdx:(NSUInteger)index;
- (void)showExpandableView;
- (void)hideExpandableView;
@end
