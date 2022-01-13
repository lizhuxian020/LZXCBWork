//
//  CBTalkListTableViewCell.h
//  cobanBnWatch
//
//  Created by coban on 2019/12/4.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBTalkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBTalkListTableViewCell : UITableViewCell
@property (nonatomic,strong) CBTalkListModel *talkListModel;
+ (instancetype)cellCopyTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
