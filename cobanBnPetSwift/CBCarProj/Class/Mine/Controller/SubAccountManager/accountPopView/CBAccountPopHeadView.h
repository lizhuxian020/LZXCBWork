//
//  CBAccountPopHeadView.h
//  Telematics
//
//  Created by coban on 2019/12/26.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBHomeLeftMenuModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBAccountPopHeadView : UITableViewHeaderFooterView
@property (nonatomic,strong) CBHomeLeftMenuDeviceGroupModel *deviceGoupModel;
@property (nonatomic,copy) void(^headClickBlock)(id __nullable objc);
@end

NS_ASSUME_NONNULL_END
