//
//  AlamSettingView.h
//  Telematics
//
//  Created by lym on 2017/11/13.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MINSwitchView;
@interface AlamSettingView : UIView
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *detailBtn;
@property (nonatomic, strong) MINSwitchView *alramSwitch;
- (void)changeViewType;
@end
