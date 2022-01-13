//
//  NetWorkConfigView.h
//  Telematics
//
//  Created by lym on 2017/11/29.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetWorkConfigView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *ipOrApnLabel;
@property (nonatomic, strong) UILabel *domainNameOrUserNameLabel;
@property (nonatomic, strong) UILabel *passLabel;
@property (nonatomic, strong) UILabel *tcpLabel;
@property (nonatomic, strong) UILabel *udpLabel;
@property (nonatomic, strong) UITextField *ipOrApnTextField;
@property (nonatomic, strong) UITextField *domainNameOrUserNameTextField;
@property (nonatomic, strong) UITextField *passTextField;
@property (nonatomic, strong) UITextField *tcpTextField;
@property (nonatomic, strong) UITextField *udpTextField;
@property (nonatomic, copy) void (^textFieldDidEdit)(UITextField *textField);
@property (nonatomic, assign) int type; // 1 有端口 2 无端口 3 用户名密码
- (instancetype)initWithType:(int)type;
- (void)showHideBtn;
- (void)setIpOrApnLabelText:(NSString *)text;
- (void)setDomainNameOrUserNameLabelText:(NSString *)text;
- (void)setPassLabelText:(NSString *)text;
-(void)keyboardHide;
@end
