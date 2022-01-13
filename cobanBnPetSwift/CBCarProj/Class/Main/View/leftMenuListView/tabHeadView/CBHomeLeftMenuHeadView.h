//
//  CBHomeLeftMenuHeadView.h
//  Telematics
//
//  Created by coban on 2019/7/18.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBHomeLeftMenuModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBHomeLeftMenuHeadView : UITableViewHeaderFooterView
@property (nonatomic,strong) CBHomeLeftMenuDeviceGroupModel *deviceGoupModel;
@property (nonatomic,copy) void(^headClickBlock)(id objc);
@end

NS_ASSUME_NONNULL_END
