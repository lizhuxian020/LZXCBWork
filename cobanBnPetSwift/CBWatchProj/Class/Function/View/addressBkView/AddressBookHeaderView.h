//
//  AddressBookHeaderView.h
//  Watch
//
//  Created by lym on 2018/2/7.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface AddressBookHeaderView : UIView
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, copy) void (^editBtnClickBlock)();
@end
