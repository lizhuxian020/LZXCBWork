//
//  MyDeviceDetailViewController.h
//  Telematics
//
//  Created by lym on 2017/11/8.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MINBaseViewController.h"

@class MyDeviceModel;
@interface MyDeviceDetailViewController : MINBaseViewController
@property (nonatomic, copy) NSArray *deviceInfoTitleArr;
@property (nonatomic, copy) NSArray *deviceInfoContentArr;
@property (nonatomic, copy) NSArray *deviceInfoPlaceholderArr;
@property (nonatomic, copy) NSArray *carColorArr;
@property (nonatomic, copy) NSArray *purposeArr;
@property (nonatomic, strong) MyDeviceModel *model;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSArray *groupNameArray;
@property (nonatomic, copy) NSArray *groupIdArray;
@property (nonatomic, assign) BOOL isAddDevice;
@property (nonatomic, assign) BOOL isBind;
@end
