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
@property (nonatomic, strong) UILabel *editLabel;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) MyDeviceModel *editDeviceModel;

- (void)setEditLabelText:(NSString *)text;
- (void)setSelectLabelText:(NSString *)text;
@end
