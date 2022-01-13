//
//  NewElectronicFenceView.h
//  Telematics
//
//  Created by lym on 2017/12/11.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewElectronicFenceView : UIView
@property (nonatomic, strong) UITextField *fenceNameTextField;
@property (nonatomic, strong) UITextField *speedTextField;
@property (nonatomic, strong) UILabel *alramLabel;
@property (nonatomic, strong) UIButton *alramTypeBtn;
@property (nonatomic, copy) void (^alramTypeBtnClickBlock)();
@end
