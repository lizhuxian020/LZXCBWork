//
//  AutoReceiveTableViewCell.h
//  Watch
//
//  Created by lym on 2018/2/27.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressBookModel;

@interface AutoReceiveTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic,strong) AddressBookModel *model;
@property (nonatomic,copy) void(^clickBlock)(void);

@end
