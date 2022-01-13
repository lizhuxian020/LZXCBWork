//
//  CBEditWatchInfoTableViewCell.h
//  Watch
//
//  Created by coban on 2019/9/4.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBEditWatchInfoTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *selectBtn;
@end

NS_ASSUME_NONNULL_END
