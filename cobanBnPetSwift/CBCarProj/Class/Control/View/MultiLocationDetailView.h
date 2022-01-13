//
//  MultiLocationDetailView.h
//  Telematics
//
//  Created by lym on 2017/11/28.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiLocationDetailView : UIView
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *SOSLabel;
@property (nonatomic, strong) UILabel *staticLabel;
@property (nonatomic, strong) UIButton *distanceBtn;
@property (nonatomic, strong) UIButton *SOSBtn;
@property (nonatomic, strong) UIButton *staticBtn;

@property (nonatomic, strong) UITextField *distanceTF;
@property (nonatomic, strong) UITextField *SOSTF;
@property (nonatomic, strong) UITextField *staticTF;

@property (nonatomic, copy) void (^distanceBtnClickBlock)();
@property (nonatomic, copy) void (^SOSBtnClickBlock)();
@property (nonatomic, copy) void (^staticBtnClickBlock)();
- (void)setDistanceTitle:(NSString *)distanceTitle SOSTitle:(NSString *)SOSTitle staticTitle:(NSString *)staticTitle;
@end
