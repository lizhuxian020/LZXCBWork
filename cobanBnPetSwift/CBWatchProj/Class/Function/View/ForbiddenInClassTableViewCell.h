//
//  ForbiddenInClassTableViewCell.h
//  Watch
//
//  Created by lym on 2018/2/11.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SwitchView;
@interface ForbiddenInClassTableViewCell : UITableViewCell
@property (nonatomic, strong) SwitchView *switchView;
@property (nonatomic, strong) UILabel *timePeriodLabel;
@property (nonatomic, strong) UILabel *repeatLabel;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, copy) void (^switchStatusChange)(BOOL isOn);
@property (nonatomic, copy) void (^editBtnClickBlock)(void);
@end
