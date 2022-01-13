//
//  MINInputView.m
//  Watch
//
//  Created by lym on 2018/2/8.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "MINInputView.h"

@interface MINInputView ()
@property (nonatomic, strong) UILabel *leftLabel;
@end
@implementation MINInputView

- (instancetype)init
{
    if (self = [super init]) {
        self.layer.borderColor = KWtLineColor.CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 5 * KFitWidthRate;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = UIColor.whiteColor;
    self.leftLabel = [CBWtMINUtils createLabelWithText:[NSString stringWithFormat:@"%@:",Localized(@"联系人")] size:15 alignment: NSTextAlignmentLeft textColor: KWt137Color];
    [self addSubview: self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.width.mas_equalTo(80 * KFitWidthRate);
        make.height.mas_equalTo(40);
    }];
    self.textField = [CBWtMINUtils createTextFieldWithHoldText:@"哥哥" fontSize:15];
    self.textField.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 25 * KFitWidthRate,  40 * KFitWidthRate)];
    [self addSubview: self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftLabel.mas_centerY);
        make.height.mas_equalTo(40);
        make.left.equalTo(self.leftLabel.mas_right);
        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
    }];
}

- (void)setTextFieldPlaceHold:(NSString *)placeHold
{
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString: placeHold];
    [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize: 15] range:NSMakeRange(0, placeHold.length)];
    [placeholder addAttribute:NSForegroundColorAttributeName value:KWtTextFieldColor range:NSMakeRange(0, placeHold.length)];
    //    NSMutableParagraphStyle *centerStyle = [textField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    //    centerStyle.minimumLineHeight = textField.font.lineHeight - (textField.font.lineHeight - [UIFont systemFontOfSize:12.0].lineHeight) / 2.0;
    //    [placeholder addAttribute:NSParagraphStyleAttributeName value:centerStyle range:NSMakeRange(0, holdText.length)];
    self.textField.attributedPlaceholder = placeholder;
}
- (void)updateLeftTitle:(NSString *)titleStr
                   text:(NSString *)textStr
              placehold:(NSString *)placeHoldStr {
    CGFloat titleWidth = [NSString getWidthWithText:titleStr font:[UIFont systemFontOfSize:15] height:40];
    [self.leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).with.offset(15*frameSizeRate);
        make.width.mas_equalTo(titleWidth);
        make.height.mas_equalTo(40);
    }];
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftLabel.mas_centerY);
        make.height.mas_equalTo(40);
        make.left.equalTo(self.leftLabel.mas_right).offset(5);
        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
    }];
    
    self.leftLabel.text = titleStr;
    self.textField.text = textStr;
    self.textField.placeholder = placeHoldStr;
}
@end
