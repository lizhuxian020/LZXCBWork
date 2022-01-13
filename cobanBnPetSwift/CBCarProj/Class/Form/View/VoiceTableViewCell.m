//
//  VoiceTableViewCell.m
//  Telematics
//
//  Created by lym on 2017/11/21.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "VoiceTableViewCell.h"

@implementation VoiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kBackColor;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UIView *backView = [MINUtils createViewWithRadius: 5];
    [self addSubview: backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).with.offset(12.5 * KFitHeightRate);
        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(90 * KFitHeightRate);
    }];
    UIImage *image = [UIImage imageNamed: @"Microphone"];
    _voiceImageView = [[UIImageView alloc] initWithImage: image];
    [backView addSubview: _voiceImageView];
    [_voiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).with.offset(25 * KFitWidthRate);
        make.top.equalTo(backView).with.offset(10 * KFitHeightRate);
        make.size.mas_equalTo(CGSizeMake(image.size.width * KFitHeightRate, image.size.height * KFitHeightRate));
    }];
    _durationLabel = [MINUtils createLabelWithText: @"音频时长: 12:20" size:12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: k137Color];
    [backView addSubview: _durationLabel];
    [_durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_voiceImageView.mas_right).with.offset(25 * KFitWidthRate);
        make.top.equalTo(backView).with.offset(10 * KFitHeightRate);
        make.size.mas_equalTo(CGSizeMake(200 * KFitWidthRate, 15 * KFitHeightRate));
    }];
    _createTimeLabel = [MINUtils createLabelWithText: @"2015-12-20 12:00:00" size:12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: k137Color];
    [backView addSubview: _createTimeLabel];
    [_createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_voiceImageView.mas_right).with.offset(25 * KFitWidthRate);
        make.top.equalTo(_durationLabel.mas_bottom).with.offset(10 * KFitHeightRate);
        make.size.mas_equalTo(CGSizeMake(200 * KFitWidthRate, 15 * KFitHeightRate));
    }];
    UIImage *unstartImage = [UIImage imageNamed: @"播放音频按钮-开始"];
    UIImage *startingImage = [UIImage imageNamed: @"播放音频按钮-暂停"];
    _startBtn = [[UIButton alloc] init];
    [_startBtn setImage: unstartImage forState: UIControlStateNormal];
    [_startBtn setImage: startingImage forState: UIControlStateSelected];
    [backView addSubview: _startBtn];
    [_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).with.offset(-25 * KFitWidthRate);
        make.centerY.equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(unstartImage.size.width * KFitHeightRate, unstartImage.size.height * KFitHeightRate));
    }];
    [_startBtn addTarget: self action: @selector(startBtnClick) forControlEvents: UIControlEventTouchUpInside];
    //轨道图片
    UIImage *stetchLeftTrack = [UIImage imageNamed:@"滑动条-进度"];
    stetchLeftTrack =  [stetchLeftTrack resizableImageWithCapInsets: UIEdgeInsetsMake(2 * KFitHeightRate, 10 * KFitWidthRate, 2 * KFitHeightRate, 10 * KFitWidthRate)];
    UIImage *stetchRightTrack = [UIImage imageNamed:@"滑动条-底层"];
    stetchRightTrack = [stetchRightTrack resizableImageWithCapInsets: UIEdgeInsetsMake(2 * KFitHeightRate, 10 * KFitWidthRate, 2 * KFitHeightRate, 10 * KFitWidthRate)];
    //滑块图片
    UIImage *thumbImage = [UIImage imageNamed:@"播放条-按钮"];
    _slider = [[UISlider alloc] init];
    _slider.value = 1.0;
    _slider.minimumValue = 0;
    _slider.maximumValue = 1.0;
    _slider = [[UISlider alloc] init];
    //设置轨道的图片
    [_slider setMinimumTrackImage: stetchLeftTrack forState:UIControlStateNormal];
    [_slider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    //设置滑块的图片
    [_slider setThumbImage:thumbImage forState:UIControlStateNormal];
    [_slider addTarget: self action: @selector(slideValueChangeed:) forControlEvents: UIControlEventValueChanged];
    [backView addSubview: _slider];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView).with.offset(-10 * KFitHeightRate);
        make.left.equalTo(backView).with.offset(12.5 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(260 * KFitWidthRate, 15 * KFitHeightRate));
    }];
}

- (void)slideValueChangeed:(UISlider *)slide
{
    NSLog(@"%f", slide.value);
    if (self.slideValueChangedBlock) {
        self.slideValueChangedBlock(self.indexPath, slide.value);
    }
}

- (void)startBtnClick
{
    if (self.startBtnClickBlock) {
        self.startBtnClickBlock(self.indexPath);
    }
}

@end
