//
//  DeviceDetailTableViewCell.h
//  Telematics
//
//  Created by lym on 2017/11/8.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDeviceModel.h"

@interface DeviceDetailTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *nameLabel;
//@property (nonatomic, strong) UILabel *editLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIView *iconSelectView;
@property (nonatomic, strong) NSMutableArray *iconViewArr;
/// 图标索引
@property (nonatomic, assign) NSInteger iconIndex;
- (void)showTextView;
- (void)showSelectView;
- (void)showIcon:(NSInteger)selectedIndex;
@end
