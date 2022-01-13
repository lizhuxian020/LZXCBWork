//
//  NotifactionDetailViewController.h
//  Watch
//
//  Created by lym on 2018/3/7.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "CBWtBaseViewController.h"
@class MessageModel;
@interface NotifactionDetailViewController : CBWtBaseViewController
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, weak) MessageModel *model;
@end
