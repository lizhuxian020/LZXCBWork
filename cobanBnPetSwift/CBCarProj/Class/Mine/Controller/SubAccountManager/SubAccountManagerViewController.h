//
//  SubAccountManagerViewController.h
//  Telematics
//
//  Created by lym on 2017/11/10.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MINBaseViewController.h"

@interface SubAccountManagerViewController : MINBaseViewController

//外部wrapper的滑动手势
@property (nonatomic, strong) UIGestureRecognizer *scrollGesture;

- (void)rightBtnClick;
@end
