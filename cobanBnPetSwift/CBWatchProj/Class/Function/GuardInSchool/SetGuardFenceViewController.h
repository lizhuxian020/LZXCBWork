//
//  SetGuardFenceViewController.h
//  Watch
//
//  Created by lym on 2018/4/19.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "CBWtBaseViewController.h"
@class GuardIndoModel;
@interface SetGuardFenceViewController : CBWtBaseViewController
@property (nonatomic, strong) GuardIndoModel *guardModel;
@property (nonatomic, assign) BOOL isSetSchoolFence;
@end
