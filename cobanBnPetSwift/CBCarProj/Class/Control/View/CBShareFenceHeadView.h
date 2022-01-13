//
//  CBShareFenceHeadView.h
//  Telematics
//
//  Created by coban on 2019/7/26.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBHomeLeftMenuModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBShareFenceHeadView : UITableViewHeaderFooterView
@property (nonatomic, copy) void (^headerBtnClick)(id objc);
@property (nonatomic, copy) void (^selectBtnClick)(id objc, BOOL isSelected);
@property (nonatomic, strong) CBHomeLeftMenuDeviceGroupModel *deveiceGroup;
@end

NS_ASSUME_NONNULL_END
