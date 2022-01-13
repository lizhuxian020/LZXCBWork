//
//  NetWorkConfigView.m
//  Telematics
//
//  Created by lym on 2017/11/29.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "NetWorkConfigView.h"

@interface NetWorkConfigView() <UITextFieldDelegate>
{
    UIView *titleLineView;
    UIView *ipLineView;
    UIView *domainNameLineView;
}
@property (nonatomic, strong) UIButton *hideOrShowBtn;
@property (nonatomic, strong) UIButton *hideOrShowImageViewBtn;
@end

@implementation NetWorkConfigView

- (instancetype)initWithType:(int)type
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowRadius = 5 * KFitWidthRate;
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowOffset  = CGSizeMake(0, 3);// 阴影的范围
        self.type = type;
        [self createUIWithtype: type];
    }
    return self;
}




-(void)keyboardHide {
    [self.ipOrApnTextField resignFirstResponder];
    [self.domainNameOrUserNameTextField resignFirstResponder];
    [self.passTextField resignFirstResponder];
    [self.tcpTextField resignFirstResponder];
    [self.udpTextField resignFirstResponder];
}

- (void)createUIWithtype:(int)type
{
    UIColor *textColor = kRGB(73, 73, 73);
    _titleLabel = [MINUtils createLabelWithText:Localized(@"主服务器") size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: textColor];
    [self addSubview: _titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(self);
        //make.height.mas_equalTo(50 * KFitHeightRate);
        make.height.mas_equalTo(0 * KFitHeightRate);
        make.width.mas_equalTo(225 * KFitWidthRate);
    }];
    titleLineView = [MINUtils createLineView];
    [self addSubview: titleLineView];
    [titleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    _ipOrApnLabel = [MINUtils createLabelWithText: @"ip:" size: 12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: textColor];
    [self addSubview: _ipOrApnLabel];
    [_ipOrApnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.height.mas_equalTo(50 * KFitHeightRate);
        make.width.mas_equalTo(1);
    }];
    _ipOrApnTextField = [MINUtils createTextFieldWithHoldText: @"" fontSize: 12 * KFitHeightRate];
    _ipOrApnTextField.delegate = self;
    [self addSubview: _ipOrApnTextField];
    [_ipOrApnTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ipOrApnLabel.mas_right).with.offset(12.5 * KFitWidthRate);
        make.centerY.equalTo(_ipOrApnLabel);
        make.size.mas_equalTo(CGSizeMake(300 * KFitWidthRate, 30 * KFitHeightRate));
    }];
    ipLineView = [MINUtils createLineView];
    [self addSubview: ipLineView];
    [ipLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
        make.top.equalTo(_ipOrApnLabel.mas_bottom).with.offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    _domainNameOrUserNameLabel = [MINUtils createLabelWithText:Localized(@"域名:") size: 12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: textColor];
    [self addSubview: _domainNameOrUserNameLabel];
    [_domainNameOrUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(_ipOrApnLabel.mas_bottom);
        make.height.mas_equalTo(50 * KFitHeightRate);
        make.width.mas_equalTo(1);
    }];
    _domainNameOrUserNameTextField = [MINUtils createTextFieldWithHoldText: @"" fontSize: 12 * KFitHeightRate];
    _domainNameOrUserNameTextField.delegate = self;
    [self addSubview: _domainNameOrUserNameTextField];
    [_domainNameOrUserNameTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_domainNameOrUserNameLabel.mas_right).with.offset(12.5 * KFitWidthRate);
        make.centerY.equalTo(_domainNameOrUserNameLabel);
        make.size.mas_equalTo(CGSizeMake(300 * KFitWidthRate, 30 * KFitHeightRate));
    }];
    domainNameLineView = [MINUtils createLineView];
    [self addSubview: domainNameLineView];
    [domainNameLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
        make.top.equalTo(_domainNameOrUserNameLabel.mas_bottom).with.offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    if (type == 3) {
        _passLabel = [MINUtils createLabelWithText:Localized(@"域名:") size: 12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: textColor];
        [self addSubview: _passLabel];
        [_passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
            make.top.equalTo(_domainNameOrUserNameLabel.mas_bottom);
            make.height.mas_equalTo(50 * KFitHeightRate);
            make.width.mas_equalTo(1);
        }];
        _passTextField = [MINUtils createTextFieldWithHoldText: @"" fontSize: 12 * KFitHeightRate];
        _passTextField.delegate = self;
        [self addSubview: _passTextField];
        [_passTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_passLabel.mas_right).with.offset(12.5 * KFitWidthRate);
            make.centerY.equalTo(_passLabel);
            make.size.mas_equalTo(CGSizeMake(300 * KFitWidthRate, 30 * KFitHeightRate));
        }];
    }else if (type == 1) {
        _tcpLabel = [MINUtils createLabelWithText:Localized(@"TCP 端口:") size: 12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: textColor];
        [self addSubview: _tcpLabel];
        [_tcpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
            make.top.equalTo(_domainNameOrUserNameLabel.mas_bottom);
            make.height.mas_equalTo(50 * KFitHeightRate);
            make.width.mas_equalTo(70 * KFitWidthRate);
        }];
        _tcpTextField = [MINUtils createBorderTextFieldWithHoldText: @"" fontSize: 12 * KFitHeightRate];
        _tcpTextField.delegate = self;
        [self addSubview: _tcpTextField];
        [_tcpTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tcpLabel.mas_right).with.offset(12.5 * KFitWidthRate);
            make.centerY.equalTo(_tcpLabel);
            make.size.mas_equalTo(CGSizeMake(90 * KFitWidthRate, 30 * KFitHeightRate));
        }];
        _udpLabel = [MINUtils createLabelWithText:Localized(@"UDP 端口:") size: 12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: textColor];
        [self addSubview: _udpLabel];
        [_udpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tcpTextField.mas_right).with.offset(25 * KFitWidthRate);
            make.top.equalTo(_domainNameOrUserNameLabel.mas_bottom);
            make.height.mas_equalTo(50 * KFitHeightRate);
            make.width.mas_equalTo(70 * KFitWidthRate);
        }];
        _udpTextField = [MINUtils createBorderTextFieldWithHoldText: @"" fontSize: 12 * KFitHeightRate];
        _udpTextField.delegate = self;
        [self addSubview: _udpTextField];
        [_udpTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_udpLabel.mas_right).with.offset(12.5 * KFitWidthRate);
            make.centerY.equalTo(_tcpLabel);
            make.size.mas_equalTo(CGSizeMake(90 * KFitWidthRate, 30 * KFitHeightRate));
        }];
    } else if (type == 2) {
        _tcpLabel = [MINUtils createLabelWithText:Localized(@"端口:") size: 12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: textColor];
        [self addSubview: _tcpLabel];
        [_tcpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
            make.top.equalTo(_domainNameOrUserNameLabel.mas_bottom);
            make.height.mas_equalTo(50 * KFitHeightRate);
            make.width.mas_equalTo(70 * KFitWidthRate);
        }];
        _tcpTextField = [MINUtils createBorderTextFieldWithHoldText: @"" fontSize: 12 * KFitHeightRate];
        _tcpTextField.delegate = self;
        [self addSubview: _tcpTextField];
        [_tcpTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tcpLabel.mas_right).with.offset(12.5 * KFitWidthRate);
            make.centerY.equalTo(_tcpLabel);
            make.size.mas_equalTo(CGSizeMake(90 * KFitWidthRate, 30 * KFitHeightRate));
        }];
    }
}

- (void)hideOrShowBtnClick
{
    if (self.hideOrShowImageViewBtn.selected == YES) {
        self.hideOrShowImageViewBtn.selected = NO;
        [self showView];
    }else {
        self.hideOrShowImageViewBtn.selected = YES;
        [self hideView];
    }
}

- (void)hideView
{
    self.ipOrApnLabel.hidden = YES;
    self.domainNameOrUserNameLabel.hidden = YES;
    self.tcpLabel.hidden = YES;
    self.udpLabel.hidden = YES;
    self.passLabel.hidden = YES;
    self.ipOrApnTextField.hidden = YES;
    self.domainNameOrUserNameTextField.hidden = YES;
    self.passTextField.hidden = YES;
    self.tcpTextField.hidden = YES;
    self.udpTextField.hidden = YES;
    titleLineView.hidden = YES;
    ipLineView.hidden = YES;
    domainNameLineView.hidden = YES;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    [self.superview layoutIfNeeded];
}

- (void)showView
{
    self.ipOrApnLabel.hidden = NO;
    self.domainNameOrUserNameLabel.hidden = NO;
    self.tcpLabel.hidden = NO;
    self.udpLabel.hidden = NO;
    self.passLabel.hidden = NO;
    self.ipOrApnTextField.hidden = NO;
    self.domainNameOrUserNameTextField.hidden = NO;
    self.passTextField.hidden = NO;
    self.tcpTextField.hidden = NO;
    self.udpTextField.hidden = NO;
    titleLineView.hidden = NO;
    ipLineView.hidden = NO;
    domainNameLineView.hidden = NO;
    if (self.type == 1 || self.type == 3) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(200 * KFitHeightRate);
        }];
    }else {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(150 * KFitHeightRate);
        }];
    }
    [self.superview layoutIfNeeded];
}

- (void)showHideBtn
{
    self.hideOrShowBtn = [[UIButton alloc] init];
    [self addSubview: self.hideOrShowBtn];
    [self.hideOrShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    [self.hideOrShowBtn addTarget: self action: @selector(hideOrShowBtnClick) forControlEvents: UIControlEventTouchUpInside];
    self.hideOrShowImageViewBtn = [[UIButton alloc] init];
    UIImage *image = [UIImage imageNamed:@"上边"];
    UIImage *seletedImage = [UIImage imageNamed: @"下边"];
    [self.hideOrShowImageViewBtn setImage: image forState: UIControlStateNormal];
    [self.hideOrShowImageViewBtn setImage: seletedImage forState: UIControlStateSelected];
    [self addSubview: self.hideOrShowImageViewBtn];
    [self.hideOrShowImageViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
        make.centerY.equalTo(self.mas_top).with.offset(25 * KFitHeightRate);
        make.size.mas_equalTo(CGSizeMake(image.size.width * KFitHeightRate,  image.size.height * KFitHeightRate));
    }];
}

// 下面是根据传入的文本设定Label的宽度
- (void)setIpOrApnLabelText:(NSString *)text
{
    CGSize textSize = [text sizeWithAttributes: @{NSFontAttributeName : [UIFont systemFontOfSize: 12 * KFitHeightRate]}];
    if (self.ipOrApnLabel != nil) {
        self.ipOrApnLabel.text = text;
        [self.ipOrApnLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textSize.width + 5 * KFitWidthRate);
        }];
        [self.superview layoutIfNeeded];
    }
}

- (void)setDomainNameOrUserNameLabelText:(NSString *)text
{
    CGSize textSize = [text sizeWithAttributes: @{NSFontAttributeName : [UIFont systemFontOfSize: 12 * KFitHeightRate]}];
    if (self.domainNameOrUserNameLabel != nil) {
        self.domainNameOrUserNameLabel.text = text;
        [self.domainNameOrUserNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textSize.width + 5 * KFitWidthRate);
        }];
        [self.superview layoutIfNeeded];
    }
}

- (void)setPassLabelText:(NSString *)text
{
    CGSize textSize = [text sizeWithAttributes: @{NSFontAttributeName : [UIFont systemFontOfSize: 12 * KFitHeightRate]}];
    if (self.passLabel != nil) {
        self.passLabel.text = text;
        [self.passLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textSize.width + 5 * KFitWidthRate);
        }];
        [self.superview layoutIfNeeded];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.textFieldDidEdit) {
        self.textFieldDidEdit(textField);
    }
}

@end
