//
//  CBFriendListTableViewCell.h
//  Watch
//
//  Created by coban on 2019/8/27.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBFriendModel;

NS_ASSUME_NONNULL_BEGIN

@interface CBFriendListTableViewCell : UITableViewCell
@property (nonatomic,strong) CBFriendModel *friendModel;
@property (nonatomic, copy) void (^selectFriendBlock)(id objc);
+ (instancetype)cellCopyTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
