//
//  MultimediaHeaderView.h
//  Telematics
//
//  Created by lym on 2017/11/20.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultimediaHeaderView : UIView
@property (nonatomic, strong) UIButton *picBtn;
@property (nonatomic, copy) void (^picBtnClickBlock)();
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, copy) void (^voiceBtnClickBlock)();
@property (nonatomic, strong) UIButton *videoBtn;
@property (nonatomic, copy) void (^videoBtnClickBlock)();
@end
