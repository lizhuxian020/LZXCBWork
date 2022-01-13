//
//  MultiLocationDetailView.m
//  Telematics
//
//  Created by lym on 2017/11/28.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MultiLocationDetailView.h"

@implementation MultiLocationDetailView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowRadius = 5 * KFitWidthRate;
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowOffset  = CGSizeMake(0, 3);// 阴影的范围
        [self createUI];
        [self addAction];
    }
    return self;
}
- (void)setDistanceTitle:(NSString *)distanceTitle SOSTitle:(NSString *)SOSTitle staticTitle:(NSString *)staticTitle
{
//    [self.distanceBtn setTitle: distanceTitle forState: UIControlStateNormal];
//    [self.distanceBtn setTitle: distanceTitle forState: UIControlStateHighlighted];
//    [self.SOSBtn setTitle: SOSTitle forState: UIControlStateNormal];
//    [self.SOSBtn setTitle: SOSTitle forState: UIControlStateHighlighted];
//    [self.staticBtn setTitle: staticTitle forState: UIControlStateNormal];
//    [self.staticBtn setTitle: staticTitle forState: UIControlStateHighlighted];
    
    self.distanceTF.text = distanceTitle?:@"";
    self.SOSTF.text = SOSTitle?:@"";
    self.staticTF.text = staticTitle?:@"";
}

- (void)createUI
{
    _distanceLabel = [MINUtils createLabelWithText:[NSString stringWithFormat:@"%@(%@)",Localized(@"运动汇报间隔"),Localized(@"米")] size: 12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: k137Color];
    [self addSubview: _distanceLabel];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(self);
        make.height.mas_equalTo(50 * KFitHeightRate);
        make.width.mas_equalTo(200 * KFitWidthRate);
    }];
//    _distanceBtn = [self createBtnWithName: @"200"];
//    [self addSubview: _distanceBtn];
//    [_distanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
//        make.centerY.equalTo(_distanceLabel);
//        make.size.mas_equalTo(CGSizeMake(90 * KFitWidthRate, 30 * KFitHeightRate));
//    }];
    
    _distanceTF = [self createTFWithName: @"200"];
    [self addSubview: _distanceTF];
    [_distanceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
        make.centerY.equalTo(_distanceLabel);
        make.size.mas_equalTo(CGSizeMake(90 * KFitWidthRate, 30 * KFitHeightRate));
    }];
    
    UIView *lineView = [MINUtils createLineView];
    [self addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self).with.offset(- 12.5 * KFitWidthRate);
        make.top.equalTo(_distanceLabel.mas_bottom).with.offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    _SOSLabel = [MINUtils createLabelWithText:[NSString stringWithFormat:@"%@(%@)",Localized(@"SOS汇报间隔"),Localized(@"米")] size: 12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: k137Color];
    [self addSubview: _SOSLabel];
    [_SOSLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(_distanceLabel.mas_bottom);
        make.height.mas_equalTo(50 * KFitHeightRate);
        make.width.mas_equalTo(200 * KFitWidthRate);
    }];
//    _SOSBtn = [self createBtnWithName: @"200"];
//    [self addSubview: _SOSBtn];
//    [_SOSBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
//        make.centerY.equalTo(_SOSLabel);
//        make.size.mas_equalTo(CGSizeMake(90 * KFitWidthRate, 30 * KFitHeightRate));
//    }];
    
    _SOSTF = [self createTFWithName: @"200"];
    [self addSubview: _SOSTF];
    [_SOSTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
        make.centerY.equalTo(_SOSLabel);
        make.size.mas_equalTo(CGSizeMake(90 * KFitWidthRate, 30 * KFitHeightRate));
    }];
    
    UIView *lineView1 = [MINUtils createLineView];
    [self addSubview: lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self).with.offset(- 12.5 * KFitWidthRate);
        make.top.equalTo(_SOSLabel.mas_bottom).with.offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    _staticLabel = [MINUtils createLabelWithText:[NSString stringWithFormat:@"%@(%@)",Localized(@"静止汇报间隔"),Localized(@"米")] size: 12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: k137Color];
    [self addSubview: _staticLabel];
    [_staticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(_SOSLabel.mas_bottom);
        make.height.mas_equalTo(50 * KFitHeightRate);
        make.width.mas_equalTo(200 * KFitWidthRate);
    }];
//    _staticBtn = [self createBtnWithName: @"200"];
//    [self addSubview: _staticBtn];
//    [_staticBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
//        make.centerY.equalTo(_staticLabel);
//        make.size.mas_equalTo(CGSizeMake(90 * KFitWidthRate, 30 * KFitHeightRate));
//    }];
    
    _staticTF = [self createTFWithName: @"200"];
    [self addSubview: _staticTF];
    [_staticTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
        make.centerY.equalTo(_staticLabel);
        make.size.mas_equalTo(CGSizeMake(90 * KFitWidthRate, 30 * KFitHeightRate));
    }];
}

- (void)addAction
{
    [_distanceBtn addTarget: self action: @selector(distanceBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [_SOSBtn addTarget: self action: @selector(SOSBtnBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [_staticBtn addTarget: self action: @selector(staticBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)distanceBtnClick
{
    if (self.distanceBtnClickBlock) {
        self.distanceBtnClickBlock();
    }
}

- (void)SOSBtnBtnClick
{
    if (self.SOSBtnClickBlock) {
        self.SOSBtnClickBlock();
    }
}

- (void)staticBtnClick
{
    if (self.staticBtnClickBlock) {
        self.staticBtnClickBlock();
    }
}

- (UIButton *)createBtnWithName:(NSString *)name
{
    UIImage *arrowImage = [UIImage imageNamed: @"下拉三角"];
    UIButton *button = [[UIButton alloc] init];
    [button setTitle: name forState: UIControlStateNormal];
    [button setTitle: name forState: UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize: 12 * KFitHeightRate];
    [button setTitleColor: k137Color forState: UIControlStateNormal];
    [button setTitleColor: k137Color  forState: UIControlStateHighlighted];
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = kRGB(210, 210, 210).CGColor;
    button.layer.cornerRadius = 3 * KFitWidthRate;
    UIImageView *districtImageView = [[UIImageView alloc] initWithImage: arrowImage];
    [button addSubview: districtImageView];
    [districtImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(button);
        make.right.equalTo(button).with.offset(-12 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake( arrowImage.size.width,  arrowImage.size.height));
    }];
    return button;
}
- (UITextField *)createTFWithName:(NSString *)name {
    UITextField *tf = [UITextField new];
    tf = [UITextField new];
    //tf.backgroundColor = [UIColor colorWithHexString:@"#F6F8FA"];
    tf.placeholder = @"";
    tf.keyboardType = UIKeyboardTypeNumberPad;
    
    tf.layer.masksToBounds = YES;
    tf.layer.cornerRadius = 3*KFitWidthRate;
    tf.layer.borderWidth = 0.5;
    tf.layer.borderColor = kRGB(210, 210, 210).CGColor;
    
    tf.font = [UIFont systemFontOfSize: 12 * KFitHeightRate];//[UIFont fontWithName:BDTPingFangSC_Regular size:15*fontRate];
    tf.textColor = k137Color;
    //tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.tintColor = kBlueColor;
    
    return tf;
}
@end
