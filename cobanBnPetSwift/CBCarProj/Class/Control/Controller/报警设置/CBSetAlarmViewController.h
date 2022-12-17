//
//  CBSetAlarmViewController.h
//  Telematics
//
//  Created by coban on 2019/11/18.
//  Copyright © 2019 coban. All rights reserved.
//

#import "MINBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBSetAlarmViewController : MINBaseViewController

/** 选中的设备  */
@property (nonatomic, strong) CBHomeLeftMenuDeviceInfoModel *deviceInfoModelSelect;

@end

NS_ASSUME_NONNULL_END
