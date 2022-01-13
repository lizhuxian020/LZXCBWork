//
//  MINPlayBackView.h
//  Telematics
//
//  Created by lym on 2017/12/8.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MINPlayBackView : UIView
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *starTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UISlider *playTimeSlide;
@property (nonatomic, strong) UILabel *playLabel;
@property (nonatomic, strong) UIImageView *speedImageView;
@property (nonatomic, strong) UISlider *speedSlide;
//@property (nonatomic, strong) UILabel *timeSpeedDistanceLabel;
@property (nonatomic, assign) CGFloat totalTime;
@property (nonatomic, copy) void (^playBtnClickBlock)(BOOL isSelected);
@property (nonatomic, copy) void (^playTimeSlideBlock)(CGFloat currentSecond);
@property (nonatomic, copy) void (^speedSlideBlock)(CGFloat currentSpeed);
- (void)show;
- (void)hide;
- (void)setCurrentTime:(CGFloat)currentTime;
@end
