//
//  TimePeriodView.h
//  Watch
//
//  Created by lym on 2018/2/9.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimePeriodView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *timeSelectBtn;
@property (nonatomic, copy) void (^timeSelectBtnClickBlock)(void);
- (void)setLeftRGB73WithoutDetailImageTitleLabelText:(NSString *)titleText timeLabelText:(NSString *)timeText;
- (void)setLeftRGB137WithDetailImageTitleLabelText:(NSString *)titleText timeLabelText:(NSString *)timeText;
- (void)setLeftRGB73WithDetailImageTitleLabelText:(NSString *)titleText timeLabelText:(NSString *)timeText;
- (void)setLeftRGB73BigFontRightWithoutDetailImageTitleLabelText:(NSString *)titleText timeLabelText:(NSString *)timeText;
@end
