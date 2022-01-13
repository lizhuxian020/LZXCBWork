//
//  CBHomeLeftMenuTableViewCell.h
//  Telematics
//
//  Created by coban on 2019/7/18.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBHomeLeftMenuModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBHomeLeftMenuTableViewCell : UITableViewCell
+ (instancetype)cellCopyTableView:(UITableView *)tableView;
@property (nonatomic,strong) CBHomeLeftMenuDeviceInfoModel *deviceInfoModel;
@end

NS_ASSUME_NONNULL_END
