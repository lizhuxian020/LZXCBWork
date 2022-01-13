//
//  MINLoginPartView.h
//  Telematics
//
//  Created by lym on 2017/10/26.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MINLoginPartView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, copy) void (^rightBtnClick)();
- (instancetype)initWithImageName:(NSString *)name holdText:(NSString *)holdText rightBtnTitle:(NSString *)title;
+ (instancetype)loginPartViewWithImageName:(NSString *)name holdText:(NSString *)holdText rightBtnTitle:(NSString *)title;
@end
