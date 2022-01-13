//
//  VideoTableViewCell.m
//  Telematics
//
//  Created by lym on 2017/11/24.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "VideoTableViewCell.h"
//#import "ZFPlayer.h"

@implementation VideoTableViewCell

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
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = kCellBackColor;
    backView.layer.cornerRadius = 5 * KFitWidthRate;
    backView.layer.masksToBounds = YES;
    [self.contentView addSubview: backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(self).with.offset(12.5 * KFitHeightRate);
        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(240 * KFitHeightRate);
    }];
    _videoDuration = [MINUtils createLabelWithText: @"视频时长: 15:25" size: 12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(96, 96,96)];
    [backView addSubview: _videoDuration];
    [_videoDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(backView);
        make.height.mas_equalTo(40 * KFitHeightRate);
        make.width.mas_equalTo(155 * KFitWidthRate);
    }];
    _timeLabel = [MINUtils createLabelWithText: @"2017-11-25 15:25:20" size: 12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(96, 96,96)];
    [backView addSubview: _timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).with.offset(-12.5 * KFitWidthRate);
        make.top.equalTo(backView);
        make.height.mas_equalTo(40 * KFitHeightRate);
        make.width.mas_equalTo(155 * KFitWidthRate);
    }];
    _picView = [[UIImageView alloc] init];
    _picView.userInteractionEnabled = YES;
    _picView.tag = 101;
    _picView.backgroundColor = [UIColor blackColor];
    [backView addSubview: _picView];
    [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(backView);
        make.top.equalTo(_videoDuration.mas_bottom);
    }];
    UIImage *image = [UIImage imageNamed:@"播放按钮"];
    self.playBtn = [[UIButton alloc] init];
    [self.playBtn setImage: image forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.picView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.picView);
        make.height.width.mas_equalTo(50 * KFitHeightRate);
    }];
//    [self.picView addSubview: self.playerView];
//    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.bottom.left.equalTo(self.picView);
//    }];
}

- (void)playBtnClick:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}



@end
