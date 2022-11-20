//
//  MyDeviceViewController.h
//  Telematics
//
//  Created by lym on 2017/10/27.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MINBaseViewController.h"

@interface MyDeviceViewController : MINBaseViewController

- (void)requestDataWithHud:(MBProgressHUD *)hud;
- (void)addDeviceName;
@end
