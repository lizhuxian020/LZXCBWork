//
//  AddressBookTableViewCell.h
//  Watch
//
//  Created by lym on 2018/2/7.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressBookModel;

@interface AddressBookTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *managerLabel;
@property (nonatomic, strong) UIImageView *relationTypeImageView;
@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) AddressBookModel *addressModel;

@end
