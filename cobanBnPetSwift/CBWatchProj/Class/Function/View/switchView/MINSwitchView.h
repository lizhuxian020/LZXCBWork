//
//  MINSwitchView.h
//  Telematics
//
//  Created by lym on 2017/11/13.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MINSwitchView;
@protocol MINSwtichViewDelegate <NSObject>
@optional
- (void)switchView:(MINSwitchView *)switchView stateChange:(BOOL)isON;
@end

@interface MINSwitchView : UIView
@property (nonatomic, strong) UIButton *switchBtn;
@property (nonatomic, strong) UIImage *onImage;
@property (nonatomic, strong) UIImage *offImage;
@property (nonatomic, strong) UIImage *switchImage;
@property (nonatomic, strong) UIButton *switchImageBtn;
@property (nonatomic, strong) UIImageView *switchImageView;
@property (nonatomic, assign) BOOL isON;
@property (nonatomic, weak) id<MINSwtichViewDelegate> delegate;
- (instancetype)initWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage switchImage:(UIImage *)switchImage;
+ (instancetype)switchWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage switchImage:(UIImage *)switchImage;
- (void)updateSwitchImageView:(NSString *)tag;
@end
