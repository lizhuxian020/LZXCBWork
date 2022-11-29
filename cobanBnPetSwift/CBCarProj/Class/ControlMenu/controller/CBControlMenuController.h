//
//  CBControlMenuController.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/29.
//  Copyright © 2022 coban. All rights reserved.
//

#import "MINBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBControlMenuController : MINBaseViewController

/** 选中的设备  */
@property (nonatomic, strong) CBHomeLeftMenuDeviceInfoModel *deviceInfoModelSelect;

@end

NS_ASSUME_NONNULL_END
