//
//  TimeRepeatTableViewCell.h
//  Watch
//
//  Created by lym on 2018/2/11.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WatchSettingModel.h"

@interface TimeRepeatTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *repeatTimeLabel;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic,strong) WatchSettingScreenTimeModel *model;

@end
