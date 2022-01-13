//
//  MultimediaHeaderView.m
//  Telematics
//
//  Created by lym on 2017/11/20.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MultimediaHeaderView.h"

@implementation MultimediaHeaderView
- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowRadius = 5 * KFitWidthRate;
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowOffset  = CGSizeMake(0, 3);// 阴影的范围
        UIView *picView = [self creaetViewWithTitle:Localized(@"已下载图片") imageStr: @"下载图片"];
        [self addSubview: picView];
        [picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self);
            make.width.mas_equalTo(100 * KFitWidthRate);
        }];
        _picBtn = [[UIButton alloc] init];;
        [self addSubview: _picBtn];
        [_picBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self);
            make.width.mas_equalTo(100 * KFitWidthRate);
        }];
        UIView *voiceView = [self creaetViewWithTitle:Localized(@"已下载音频") imageStr: @"音频"];
        [self addSubview: voiceView];
        [voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(100 * KFitWidthRate);
            make.centerX.equalTo(self);
        }];
        _voiceBtn = [[UIButton alloc] init];
        [self addSubview: _voiceBtn];
        [_voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(100 * KFitWidthRate);
            make.centerX.equalTo(self);
        }];
        UIView *videoView = [self creaetViewWithTitle:Localized(@"已下载视频") imageStr: @"已下载视频"];
        [self addSubview: videoView];
        [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(100 * KFitWidthRate);
            make.right.equalTo(self);
        }];
        _videoBtn = [[UIButton alloc] init];
        [self addSubview: _videoBtn];
        [_videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(100 * KFitWidthRate);
            make.right.equalTo(self);
        }];
        [_picBtn addTarget: self action: @selector(picBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [_voiceBtn addTarget: self action: @selector(voiceBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [_videoBtn addTarget: self action: @selector(videoBtnClick) forControlEvents: UIControlEventTouchUpInside];
    }
    return self;
}

- (void)picBtnClick
{
    if (self.picBtnClickBlock) {
        self.picBtnClickBlock();
    }
}

- (void)voiceBtnClick
{
    if (self.voiceBtnClickBlock) {
        self.voiceBtnClickBlock();
    }
}

- (void)videoBtnClick
{
    if (self.videoBtnClickBlock) {
        self.videoBtnClickBlock();
    }
}

- (UIView *)creaetViewWithTitle:(NSString *)title imageStr:(NSString *)imageStr
{
    UIView *view = [[UIView alloc] init];
    UIImage *image = [UIImage imageNamed: imageStr];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    [view addSubview: imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(10 * KFitHeightRate);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(image.size.width, image.size.height));
    }];
    UILabel *titleLabel = [MINUtils createLabelWithText: title size: 12 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: k137Color];
    titleLabel.numberOfLines = 0;
    [view addSubview: titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(imageView.mas_bottom).with.offset(5 * KFitHeightRate);
        make.bottom.equalTo(view).with.offset(-10 * KFitHeightRate);
        make.centerX.equalTo(view);
        make.width.equalTo(view);
        //make.height.mas_equalTo(15 * KFitHeightRate);
    }];
    return view;
}

@end
