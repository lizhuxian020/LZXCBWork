//
//  MINUtils.m
//  Telematics
//
//  Created by lym on 2017/10/25.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MINUtils.h"

@implementation MINUtils

+ (UIView *)createViewWithRadius:(CGFloat)radius {
    UIView *view = [[UIView alloc] init];
    view.layer.cornerRadius = radius;
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    view.layer.shadowRadius = radius*KFitWidthRate;
    view.layer.shadowOpacity = 0.3;
    view.backgroundColor = kCellBackColor;
    view.layer.shadowOffset  = CGSizeMake(0, 3);// 阴影的范围
    return view;
}

+ (UILabel *)createLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = kCellTextColor;
    label.font = [UIFont systemFontOfSize: 15 * KFitHeightRate];
    return label;
}

+ (UILabel *)createLabelWithText:(NSString *)text size:(CGFloat)size
{
    UILabel *label = [self createLabelWithText: text];
    label.font = [UIFont systemFontOfSize: size];
    return label;
}

+ (UILabel *)createLabelWithText:(NSString *)text size:(CGFloat)size alignment:(NSTextAlignment)alignment
{
    UILabel *label = [self createLabelWithText: text size: size];
    label.textAlignment = alignment;
    return  label;
}

+ (UILabel *)createLabelWithText:(NSString *)text size:(CGFloat)size alignment:(NSTextAlignment)alignment textColor:(UIColor *)color
{
    UILabel *label = [self createLabelWithText: text size: size alignment: alignment];
    label.textColor = color;
    return  label;
}

+ (UIButton *)createBtnWithRadius:(CGFloat)radius title:(NSString *)title
{
    UIButton *button = [[UIButton alloc] init];
    button.layer.cornerRadius = radius;
    [button setTitle: title forState: UIControlStateNormal];
    [button setTitle: title forState: UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize: 15 * KFitWidthRate];
    button.backgroundColor = kBlueColor;
    return  button;
}

+ (UIButton *)createBtnWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage: normalImage forState: UIControlStateNormal];
    [button setImage: selectedImage forState: UIControlStateSelected];
    return button;
}

+ (UITextField *)createTextFieldWithHoldText:(NSString *)holdText
{
    UITextField *textField = [[UITextField alloc] init];
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString: holdText];
    [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * KFitWidthRate] range:NSMakeRange(0, holdText.length)];
    [placeholder addAttribute:NSForegroundColorAttributeName value:kTextFieldColor range:NSMakeRange(0, holdText.length)];
//    NSMutableParagraphStyle *centerStyle = [textField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
//    centerStyle.minimumLineHeight = textField.font.lineHeight - (textField.font.lineHeight - [UIFont systemFontOfSize:12.0].lineHeight) / 2.0;
//    [placeholder addAttribute:NSParagraphStyleAttributeName value:centerStyle range:NSMakeRange(0, holdText.length)];
    textField.attributedPlaceholder = placeholder;
    textField.textColor = kTextFieldColor;
    textField.font = [UIFont systemFontOfSize: 12 * KFitWidthRate];
    textField.textAlignment = NSTextAlignmentLeft;
    return  textField;
}

+ (UITextField *)createTextFieldWithHoldText:(NSString *)holdText fontSize:(CGFloat)size
{
    UITextField *textField = [[UITextField alloc] init];
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString: holdText];
    [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, holdText.length)];
    [placeholder addAttribute:NSForegroundColorAttributeName value:kTextFieldColor range:NSMakeRange(0, holdText.length)];
    //    NSMutableParagraphStyle *centerStyle = [textField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    //    centerStyle.minimumLineHeight = textField.font.lineHeight - (textField.font.lineHeight - [UIFont systemFontOfSize:12.0].lineHeight) / 2.0;
    //    [placeholder addAttribute:NSParagraphStyleAttributeName value:centerStyle range:NSMakeRange(0, holdText.length)];
    textField.attributedPlaceholder = placeholder;
    textField.textColor = kRGB(96, 96, 96);
    textField.font = [UIFont systemFontOfSize: size];
    textField.textAlignment = NSTextAlignmentLeft;
    return  textField;
}

+ (UITextField *)createBorderTextFieldWithHoldText:(NSString *)holdText fontSize:(CGFloat)size
{
    UITextField *textField = [[UITextField alloc] init];
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString: holdText];
    [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, holdText.length)];
    [placeholder addAttribute:NSForegroundColorAttributeName value:kTextFieldColor range:NSMakeRange(0, holdText.length)];
    //    NSMutableParagraphStyle *centerStyle = [textField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    //    centerStyle.minimumLineHeight = textField.font.lineHeight - (textField.font.lineHeight - [UIFont systemFontOfSize:12.0].lineHeight) / 2.0;
    //    [placeholder addAttribute:NSParagraphStyleAttributeName value:centerStyle range:NSMakeRange(0, holdText.length)];
    textField.attributedPlaceholder = placeholder;
    textField.textColor = kRGB(137, 137, 137);
    textField.font = [UIFont systemFontOfSize: size];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.layer.borderColor = kRGB(210, 210, 210).CGColor;
    textField.layer.borderWidth = 0.5;
    textField.layer.cornerRadius = 5 * KFitWidthRate;
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(12.5 * KFitWidthRate,0,12.5 * KFitWidthRate,30 * KFitHeightRate)];
    leftView.backgroundColor = UIColor.clearColor;
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(12.5 * KFitWidthRate,0,12.5 * KFitWidthRate,30 * KFitHeightRate)];
    lab.backgroundColor = [UIColor clearColor];
    [leftView addSubview:lab];
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return  textField;
}
+ (UITextField *)createTextFieldWithHoldText:(NSString *)holdText fontSize:(CGFloat)size leftImage:(UIImage *)leftImage leftImageSize:(CGSize)leftSize
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage: leftImage];
    imageView.frame = CGRectMake(0, 0, leftSize.width, leftSize.height);
    imageView.contentMode = UIViewContentModeCenter;
    UIView *leftView = [[UIView alloc]initWithFrame:imageView.frame];
    [leftView addSubview:imageView];
    UITextField *textField = [self createTextFieldWithHoldText: holdText fontSize: size leftView: leftView];
    return textField;
}
+ (UITextField *)createTextFieldWithHoldText:(NSString *)holdText fontSize:(CGFloat)size leftView:(UIView *)view
{
    UITextField *textField = [self createTextFieldWithHoldText: holdText fontSize: size];
    textField.textColor = kRGB(196, 196, 196);
    textField.leftView = view;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}
+ (UIButton *)createNoBorderBtnWithTitle:(NSString *)title
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle: title forState: UIControlStateNormal];
    [button setTitle: title forState: UIControlStateHighlighted];
    [button setTitleColor: kLoginPartColor forState: UIControlStateNormal];
    [button setTitleColor: kLoginPartColor forState: UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize: 12];
    return button;
}

+ (UIButton *)createNoBorderBtnWithTitle:(NSString *)title titleColor:(UIColor *)titleColor
{
    UIButton *button = [self createNoBorderBtnWithTitle: title];
    [button setTitleColor: titleColor forState: UIControlStateNormal];
    [button setTitleColor: titleColor forState: UIControlStateHighlighted];
    return button;
}

+ (UIButton *)createNoBorderBtnWithTitle:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)size
{
    UIButton *button = [self createNoBorderBtnWithTitle: title titleColor: titleColor];
    button.titleLabel.font = [UIFont systemFontOfSize: size];
    return button;
}

+ (UIButton *)createNoBorderBtnWithTitle:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)size backgroundColor:(UIColor *)backgroundColor
{
    UIButton *button = [self createNoBorderBtnWithTitle: title titleColor: titleColor fontSize: size];
    [button setBackgroundColor: backgroundColor];
    return button;
}

+ (UIButton *)createBorderBtnWithArrowImage
{
    UIImage *arrowImage = [UIImage imageNamed: @"下拉三角"];
    UIButton *button = [[UIButton alloc] init];
    //    [button setTitle: name forState: UIControlStateNormal];
    //    [button setTitle: name forState: UIControlStateHighlighted];
    //    button.titleLabel.font = [UIFont systemFontOfSize: 12 * KFitHeightRate];
    //    [button setTitleColor: k137Color forState: UIControlStateNormal];
    //    [button setTitleColor: k137Color  forState: UIControlStateHighlighted];
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

+ (UIButton *)createBorderBtnWithArrowImageWithTitle:(NSString *)title
{
    UIImage *arrowImage = [UIImage imageNamed: @"下拉三角"];
    UIButton *button = [[UIButton alloc] init];
    //    [button setTitle: name forState: UIControlStateNormal];
    //    [button setTitle: name forState: UIControlStateHighlighted];
    //    button.titleLabel.font = [UIFont systemFontOfSize: 12 * KFitHeightRate];
    //    [button setTitleColor: k137Color forState: UIControlStateNormal];
    //    [button setTitleColor: k137Color  forState: UIControlStateHighlighted];
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = kRGB(210, 210, 210).CGColor;
    button.layer.cornerRadius = 3 * KFitWidthRate;
    [button setTitle: title forState: UIControlStateNormal];
    [button setTitle: title forState: UIControlStateHighlighted];
    [button setTitleColor: k137Color forState: UIControlStateNormal];
    [button setTitleColor: k137Color forState: UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize: 12 * KFitHeightRate];
    UIImageView *districtImageView = [[UIImageView alloc] initWithImage: arrowImage];
    [button addSubview: districtImageView];
    [districtImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(button);
        make.right.equalTo(button).with.offset(-12 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake( arrowImage.size.width,  arrowImage.size.height));
    }];
    return button;
}

+ (UIView *)createLineView
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor: KCarLineColor];
    return view;
}

+ (MBProgressHUD *)hudToView:(UIView *)view withText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo: view animated: YES];
    hud.mode = MBProgressHUDModeText;
//    hud.minSize = CGSizeMake(296.5 * KFitWidthRate, 153 * KFitWidthRate);
    hud.label.text = text;
    hud.label.numberOfLines = NO;
    hud.label.textColor = UIColor.whiteColor;
//    hud.label.textColor = [UIColor colorWithRed:127.0 / 255 green:128.0 / 255 blue:129.0 / 255 alpha:1.0];
    hud.label.font = [UIFont systemFontOfSize:15 * KFitWidthRate];
    hud.bezelView.backgroundColor = kCellTextColor;
    hud.bezelView.alpha = 1.0;
//    hud.backgroundColor = [kBrownColor colorWithAlphaComponent: 0.3];
    hud.label.text = text;
    return hud;
}

+ (void)showProgressHudToView:(UIView *)view withText:(NSString *)text
{
    MBProgressHUD *signUpHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    signUpHUD.mode = MBProgressHUDModeText;
//    signUpHUD.minSize = CGSizeMake(296.5 * KFitWidthRate, 153 * KFitWidthRate);
    signUpHUD.label.text = text;
    signUpHUD.label.numberOfLines = NO;
    signUpHUD.label.textColor = UIColor.whiteColor;
//    signUpHUD.label.textColor = [UIColor colorWithRed:127.0 / 255 green:128.0 / 255 blue:129.0 / 255 alpha:1.0];
    signUpHUD.label.font = [UIFont systemFontOfSize:15 * KFitWidthRate];
    signUpHUD.bezelView.backgroundColor = kCellTextColor;
    signUpHUD.bezelView.alpha = 1.0;
//    signUpHUD.backgroundColor = [kBrownColor colorWithAlphaComponent: 0.3];
    [signUpHUD hideAnimated:YES afterDelay:2.0f];//0/8
}

+ (NSString *)getTimeFromTimestamp:(NSString *)timestamp formatter:(NSString *)formatterString
{
    if (timestamp.length <= 0) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: formatterString];
//    NSString * language = [[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"];
//    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier: language];
//    [formatter setLocale:locale];
    NSDate * date = [self getDateFromTimestamp: timestamp];
    NSString * dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSDate *)getDateFromTimestamp:(NSString *)timestamp
{
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue] / 1000];
    return date;
}
+ (void)addLineToView:(UIView *)view isTop:(BOOL)isTop hasSpaceToSide:(BOOL)hasSpace {
    UIView *lineView = [self createLineView];
    [view addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isTop == YES) {
            make.top.equalTo(view);
        }else {
            make.bottom.equalTo(view);
        }
        if (hasSpace == YES) {
            make.left.equalTo(view).with.offset(12.5 * KFitWidthRate);
            make.right.equalTo(view).with.offset(-12.5 * KFitWidthRate);
        }else {
            make.right.left.equalTo(view);
        }
        make.height.mas_equalTo(0.5);
    }];
}
@end
