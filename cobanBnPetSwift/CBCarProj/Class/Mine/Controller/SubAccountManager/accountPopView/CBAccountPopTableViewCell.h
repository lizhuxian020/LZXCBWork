//
//  CBAccountPopTableViewCell.h
//  Telematics
//
//  Created by coban on 2019/12/26.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBHomeLeftMenuModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBAccountPopTableViewCell : UITableViewCell

+ (instancetype)cellCopyTableView:(UITableView *)tableView;
@property (nonatomic,copy) void(^cellClickBlock)(id objc);
@property (nonatomic,strong) CBHomeLeftMenuDeviceInfoModel *deviceInfoModel;
@end

NS_ASSUME_NONNULL_END
