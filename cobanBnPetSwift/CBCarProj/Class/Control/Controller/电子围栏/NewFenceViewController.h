//
//  NewFenceViewController.h
//  Telematics
//
//  Created by lym on 2017/12/11.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MINBaseViewController.h"
@class FenceListModel;
@interface NewFenceViewController : MINBaseViewController
@property (nonatomic, strong) FenceListModel *model;
@property (nonatomic, assign) BOOL isCreateFence;
@end
