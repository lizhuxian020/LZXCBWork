//
//  CBTalkMineTableViewCell.h
//  Watch
//
//  Created by coban on 2019/8/26.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBTalkModel;

NS_ASSUME_NONNULL_BEGIN

@interface CBTalkMineTableViewCell : UITableViewCell
@property (nonatomic,strong) CBTalkModel *talkModel;
@property (nonatomic,copy) void(^playBlock)(id objc);
+ (instancetype)cellCopyTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
