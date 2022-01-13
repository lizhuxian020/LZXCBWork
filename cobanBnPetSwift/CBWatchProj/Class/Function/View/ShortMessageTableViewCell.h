//
//  ShortMessageTableViewCell.h
//  Watch
//
//  Created by lym on 2018/2/23.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShortMessageTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *senderLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *messageLabel;
//@property (nonatomic, assign) BOOL isSelected;
@end
