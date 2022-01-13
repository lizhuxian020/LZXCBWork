//
//  VideoTableViewCell.h
//  Telematics
//
//  Created by lym on 2017/11/24.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFPlayerView;
@interface VideoTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *videoDuration;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *picView;
@property (nonatomic, strong) UIButton *playBtn;
/** 播放按钮block */
@property (nonatomic, copy) void(^playBlock)(UIButton *);
@end
