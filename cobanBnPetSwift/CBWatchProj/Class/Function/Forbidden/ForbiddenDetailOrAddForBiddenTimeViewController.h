//
//  ForbiddenDetailOrAddForBiddenTimeViewController.h
//  Watch
//
//  Created by lym on 2018/2/22.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "CBWtBaseViewController.h"

@class ForbiddenInClassModel;
@interface ForbiddenDetailOrAddForBiddenTimeViewController : CBWtBaseViewController
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, weak) ForbiddenInClassModel *model;
@end
