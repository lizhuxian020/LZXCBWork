//
//  MINPlayBackView.m
//  Telematics
//
//  Created by lym on 2017/12/8.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MINPlayBackView.h"

@implementation MINPlayBackView

- (instancetype)init
{
    if (self = [super init]) {
        [self createUI];
        [self addAction];
    }
    return self;
}

- (void)addAction
{
    [self.playBtn addTarget: self action: @selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)playBtnClick
{
    if (self.playBtn.selected == YES) {
        self.playBtn.selected = NO;
    }else {
        self.playBtn.selected = YES;
    }
    if (self.playBtnClickBlock) {
        self.playBtnClickBlock(self.playBtn.isSelected);
    }
}

- (void)slideValueChangeed:(UISlider * )slide
{
    if (slide == self.speedSlide) {
        NSInteger num = (NSUInteger)(slide.value + 0.5);
        [self.speedSlide setValue: num];
        if (self.speedSlideBlock) {
            self.speedSlideBlock(num);
        }
    }else if (slide == self.playTimeSlide){
        int currentSecond = self.playTimeSlide.value * self.totalTime;
        int minute = currentSecond / 60;
        int second = currentSecond % 60;
        self.starTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minute, second];
        if (self.playTimeSlideBlock) {
            self.playTimeSlideBlock(self.playTimeSlide.value * self.totalTime);
        }
    }
}

- (void)createUI
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.7];
    _playBtn = [[UIButton alloc] init];
    [_playBtn setImage: [UIImage imageNamed: @"Volume-btn"] forState: UIControlStateNormal];
    [_playBtn setImage: [UIImage imageNamed: @"播放音频按钮-暂停"] forState: UIControlStateSelected];
    //playBtn.backgroundColor = [UIColor redColor];
    [self addSubview: _playBtn];
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50 * KFitHeightRate, 50 * KFitHeightRate));
    }];
    _starTimeLabel = [MINUtils createLabelWithText: @"00:00" size: 11 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: [UIColor whiteColor ]];
    [self addSubview: _starTimeLabel];
    [_starTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(_playBtn);
        make.left.equalTo(_playBtn.mas_right);
        make.width.mas_equalTo(40 * KFitWidthRate);
    }];
    _endTimeLabel = [MINUtils createLabelWithText: @"13:42" size: 11 * KFitHeightRate alignment: NSTextAlignmentRight textColor: [UIColor whiteColor ]];
    [self addSubview: _endTimeLabel];
    [_endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(_playBtn);
        make.right.equalTo(self).with.offset(-10 * KFitWidthRate);
        make.width.mas_equalTo(40 * KFitWidthRate);
    }];
    _playTimeSlide = [self createSliderWithSlideImage: @"播放条-按钮"];
    [self addSubview: _playTimeSlide];
    [_playTimeSlide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_starTimeLabel.mas_right).with.offset(5 * KFitWidthRate);
        make.right.equalTo(_endTimeLabel.mas_left).with.offset(-5 * KFitWidthRate);
        make.centerY.equalTo(_playBtn);
        make.height.mas_equalTo(15 * KFitHeightRate);
    }];
    _playLabel = [MINUtils createLabelWithText: Localized(@"播放速度") size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: [UIColor whiteColor ]];
    //_playLabel.backgroundColor = [UIColor redColor];
    [self addSubview: _playLabel];
    [_playLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerY.equalTo(self);
        make.top.mas_equalTo(_playBtn.mas_bottom).offset(15*KFitHeightRate);
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.height.mas_equalTo(20 * KFitHeightRate);
        make.width.mas_equalTo(80 * KFitWidthRate);
    }];
    _speedImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"尺度"]];
    [self addSubview: _speedImageView];
    [_speedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_playLabel).with.offset(-10 * KFitHeightRate);
//        make.left.equalTo(_playLabel.mas_right).with.offset(5 * KFitWidthRate);
//        make.right.equalTo(self).with.offset(-45 * KFitWidthRate);
        make.left.right.equalTo(_playTimeSlide);
        make.height.mas_equalTo(10 * KFitHeightRate);
    }];
    _speedSlide = [self createSliderWithSlideImage: @"播放速度按钮"];
    _speedSlide.maximumValue = 12.0;
    [self addSubview: _speedSlide];
    [_speedSlide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_speedImageView.mas_bottom).with.offset(5 * KFitHeightRate);
        make.right.left.equalTo(_speedImageView);
        make.height.mas_equalTo(15 * KFitHeightRate);
    }];
//    _timeSpeedDistanceLabel = [MINUtils createLabelWithText: @"2017-05-05 10:20:11 速度: 29Km/h 里程: 1.2Km" size: 13 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: [UIColor whiteColor ]];
//    [self addSubview: _timeSpeedDistanceLabel];
//    [_timeSpeedDistanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self).with.offset(-10 * KFitHeightRate);
//        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
//        make.height.mas_equalTo(20 * KFitHeightRate);
//        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
//    }];
}

- (UISlider *)createSliderWithSlideImage:(NSString *)slideImage
{
    //轨道图片
    UIImage *stetchLeftTrack = [UIImage imageNamed:@"滑动条-进度"];
    stetchLeftTrack =  [stetchLeftTrack resizableImageWithCapInsets: UIEdgeInsetsMake(2 * KFitHeightRate, 10 * KFitWidthRate, 2 * KFitHeightRate, 10 * KFitWidthRate)];
    UIImage *stetchRightTrack = [UIImage imageNamed:@"滑动条-底层"];
    stetchRightTrack = [stetchRightTrack resizableImageWithCapInsets: UIEdgeInsetsMake(2 * KFitHeightRate, 10 * KFitWidthRate, 2 * KFitHeightRate, 10 * KFitWidthRate)];
    //滑块图片 @"播放条-按钮"
    UIImage *thumbImage = [UIImage imageNamed: slideImage];
    UISlider *slide = [[UISlider alloc] init];
    slide.value = 0;
    slide.minimumValue = 0;
    slide.maximumValue = 1.0;
    slide = [[UISlider alloc] init];
    //设置轨道的图片
    [slide setMinimumTrackImage: stetchLeftTrack forState:UIControlStateNormal];
    [slide setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    //设置滑块的图片
    [slide setThumbImage:thumbImage forState:UIControlStateNormal];
    [slide addTarget: self action: @selector(slideValueChangeed:) forControlEvents: UIControlEventValueChanged];
    slide.continuous = YES;
    return slide;
}

- (void)show
{
//    UITabBarController *tabBarController = [[UITabBarController alloc] init];
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.superview).with.offset(-tabBarController.tabBar.frame.size.height);
//    }];
    self.hidden = NO;
}

- (void)hide
{
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.superview).with.offset(140 * KFitHeightRate);
//    }];
    self.hidden = YES;
}

- (void)setCurrentTime:(CGFloat)currentTime
{
//    int currentSecond = (int)currentTime;
//    int minute = currentSecond / 60;
//    int second = currentSecond % 60;
//
//    _starTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    if (currentTime < 0) {
        currentTime = - currentTime;
    }
    NSInteger ms = currentTime;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    if (currentTime <= 0) {
        //        self.hourLabel.text = [NSString stringWithFormat:@"%d",0];
        //        self.minuesLabel.text = [NSString stringWithFormat:@"%d",0];
        //        self.secondsLabel.text = [NSString stringWithFormat:@"%d",0];
        //        if (self.timerStopBlock) {
        //            self.timerStopBlock();
        //        }
        //        return;
        currentTime = 0;
    }
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger hourMax = 0;
    if (day >= 1) {
        hourMax = 24 + hour;//时(超过24小时，不算天)
    } else {
        hourMax = hour;
    }
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    
    _starTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minute, (long)second];
}

- (void)setTotalTime:(CGFloat)totalTime
{
    _totalTime = totalTime;
//    int currentSecond = (int)totalTime;
//    int minute = currentSecond / 60;
//    int second = currentSecond % 60;
//    _endTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    
    NSInteger ms = totalTime;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    if (totalTime <= 0) {
        //        self.hourLabel.text = [NSString stringWithFormat:@"%d",0];
        //        self.minuesLabel.text = [NSString stringWithFormat:@"%d",0];
        //        self.secondsLabel.text = [NSString stringWithFormat:@"%d",0];
        //        if (self.timerStopBlock) {
        //            self.timerStopBlock();
        //        }
        //        return;
        totalTime = 0;
    }
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger hourMax = 0;
    if (day >= 1) {
        hourMax = 24 + hour;//时(超过24小时，不算天)
    } else {
        hourMax = hour;
    }
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    
    _endTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minute, (long)second];
}

@end
