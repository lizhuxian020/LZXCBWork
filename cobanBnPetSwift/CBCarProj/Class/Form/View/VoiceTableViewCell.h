//
//  VoiceTableViewCell.h
//  Telematics
//
//  Created by lym on 2017/11/21.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *voiceImageView;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *createTimeLabel;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^startBtnClickBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^slideValueChangedBlock)(NSIndexPath *indexPath, float value);
@end
