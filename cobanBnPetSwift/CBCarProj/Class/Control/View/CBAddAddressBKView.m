//
//  CBAddAddressBKView.m
//  Telematics
//
//  Created by coban on 2019/8/6.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBAddAddressBKView.h"

@interface CBAddAddressBKView ()<UITextFieldDelegate>

@end
@implementation CBAddAddressBKView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    [self nameTextField];
    [self mobileTextField];
    [self alramLabel];
    [self alramTypeBtn];
}
- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [MINUtils createBorderTextFieldWithHoldText:Localized(@"姓名") fontSize: 12 * KFitHeightRate];
        //_nameTextField.font = [UIFont systemFontOfSize:12*KFitHeightRate];
        //[_mobileTextField setValue:[UIFont systemFontOfSize:12*KFitHeightRate] forKeyPath:@"_placeholderLabel.font"];
        [self addSubview: _nameTextField];
        [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).with.offset(12.5 * KFitHeightRate);
            make.right.equalTo(self).with.offset(-12.5 * KFitHeightRate);
            make.height.mas_equalTo(30*KFitHeightRate);
        }];
    }
    return _nameTextField;
}
- (UITextField *)mobileTextField {
    if (!_mobileTextField) {
        _mobileTextField = [MINUtils createBorderTextFieldWithHoldText:Localized(@"电话号码") fontSize: 12 * KFitHeightRate];
        //_mobileTextField.font = [UIFont systemFontOfSize:12*KFitHeightRate];
        //[_mobileTextField setValue:[UIFont systemFontOfSize:12*KFitHeightRate] forKeyPath:@"_placeholderLabel.font"];
        _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
        _mobileTextField.delegate = self;
        [self addSubview: _mobileTextField];
        [_mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameTextField.mas_bottom).with.offset(20 * KFitHeightRate);
            make.left.equalTo(self).with.offset(12.5 * KFitHeightRate);
            make.right.equalTo(self).with.offset(-12.5 * KFitHeightRate);
            make.height.mas_equalTo(30 * KFitHeightRate);
        }];
    }
    return _mobileTextField;
}
- (UILabel *)alramLabel {
    if (!_alramLabel) {
        _alramLabel = [MINUtils createLabelWithText:Localized(@"授权号码类型") size: 12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(73, 73, 73)];
        [self addSubview: _alramLabel];
        [_alramLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_mobileTextField.mas_bottom).with.offset(20 * KFitHeightRate);
            make.left.equalTo(self).with.offset(12.5 * KFitHeightRate);
            make.right.mas_equalTo(70 * KFitWidthRate);
            make.height.mas_equalTo(30 * KFitHeightRate);
        }];
    }
    return _alramLabel;
}
- (UIButton *)alramTypeBtn {
    if (!_alramTypeBtn) {
        _alramTypeBtn = [MINUtils createBorderBtnWithArrowImageWithTitle:Localized(@"入围栏报警")];
        [self addSubview: _alramTypeBtn];
        [_alramTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_mobileTextField.mas_bottom).with.offset(20 * KFitHeightRate);
            make.width.mas_equalTo(170 * KFitWidthRate);
            make.right.equalTo(self).with.offset(-12.5 * KFitHeightRate);
            make.height.mas_equalTo(30 * KFitHeightRate);
        }];
        [_alramTypeBtn addTarget: self action: @selector(alarmTypeBtnClick) forControlEvents: UIControlEventTouchUpInside];
    }
    return _alramTypeBtn;
}
- (void)alarmTypeBtnClick {
    if (self.alramTypeBtnClickBlock) {
        self.alramTypeBtnClickBlock();
    }
}
#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL result = [string isOnlyNumber];
    return result;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
