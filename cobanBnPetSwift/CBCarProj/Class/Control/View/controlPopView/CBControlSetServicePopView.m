//
//  CBControlSetServicePopView.m
//  Telematics
//
//  Created by coban on 2019/11/21.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBControlSetServicePopView.h"

@interface CBControlSetServicePopView ()
@property (nonatomic,strong) UIView *bgmView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIButton *certainBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UITextField *timeTF;
@property (nonatomic,strong) UITextField *mileageTF;
@end
@implementation CBControlSetServicePopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setupView {
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    
    [self bgmView];
    [self titleLb];
    [self cancelBtn];
    [self certainBtn];
    
    [self timeTF];
    [self mileageTF];
}
- (UIView *)bgmView {
    if (!_bgmView) {
        _bgmView = [UIView new];
        _bgmView.backgroundColor = [UIColor whiteColor];
        _bgmView.layer.masksToBounds = YES;
        _bgmView.layer.cornerRadius = 6*frameSizeRate;
        [self addSubview:_bgmView];
        [_bgmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30*frameSizeRate);
            make.right.mas_equalTo(-30*frameSizeRate);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(210*frameSizeRate);
        }];
    }
    return _bgmView;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [MINUtils createLabelWithText:Localized(@"保养通知")size: 18 * KFitWidthRate alignment: NSTextAlignmentCenter textColor:kRGB(51, 51, 51)];
        _titleLb.numberOfLines = 0;
        _titleLb.font = [UIFont fontWithName:CBPingFang_SC_Bold size:18];
        [self.bgmView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self.bgmView);
            make.height.mas_equalTo(45 * KFitHeightRate);
            make.left.right.equalTo(self.bgmView);
        }];
    }
    return _titleLb;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"取消") titleColor: kRGB(96, 96, 96) fontSize: 15 * KFitWidthRate backgroundColor: kRGB(215, 215, 215)];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self.bgmView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgmView.mas_left).offset(10);
            make.right.equalTo(self.certainBtn.mas_left).offset(-10);
            make.bottom.mas_equalTo(self.bgmView.mas_bottom).offset(-10);
            make.width.mas_equalTo(self.certainBtn.mas_width);
            make.height.mas_equalTo(45 * KFitHeightRate);
        }];
    }
    return _cancelBtn;
}
- (UIButton *)certainBtn {
    if (!_certainBtn) {
        _certainBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"确定") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: kBlueColor];
        [_certainBtn addTarget:self action:@selector(certain) forControlEvents:UIControlEventTouchUpInside];
        [self.bgmView addSubview:_certainBtn];
        [_certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancelBtn.mas_right).offset(10);
            make.right.equalTo(self.bgmView.mas_right).offset(-10);
            make.bottom.mas_equalTo(self.bgmView.mas_bottom).offset(-10);
            make.width.mas_equalTo(self.cancelBtn.mas_width);
            make.height.mas_equalTo(45 * KFitHeightRate);
        }];
    }
    return _certainBtn;
}
- (UITextField *)timeTF {
    if (!_timeTF) {
        _timeTF = [MINUtils createTextFieldWithHoldText:@""  fontSize: 15];
        _timeTF.keyboardType = UIKeyboardTypeDecimalPad;
        _timeTF.layer.masksToBounds = YES;
        _timeTF.layer.borderColor = kRGB(215, 215, 215).CGColor;
        _timeTF.layer.cornerRadius = 4;
        _timeTF.layer.borderWidth = 1.0f;
        _timeTF.textAlignment = NSTextAlignmentCenter;
        [self.bgmView addSubview:_timeTF];
        [_timeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bgmView.mas_right).offset(-10);
            make.top.mas_equalTo(self.titleLb.mas_bottom).offset(5);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(160);
        }];
        
        UILabel *lab = [MINUtils createLabelWithText:Localized(@"时间间隔(天):")size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor:kRGB(96, 96, 96)];
        lab.numberOfLines = 0;
        [self.bgmView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_timeTF.mas_centerY);
            make.left.mas_equalTo(self.bgmView.mas_left).offset(10);
        }];
    }
    return _timeTF;
}
- (UITextField *)mileageTF {
    if (!_mileageTF) {
        _mileageTF = [MINUtils createTextFieldWithHoldText:@""  fontSize: 15];
        _mileageTF.keyboardType = UIKeyboardTypeDecimalPad;
        _mileageTF.layer.masksToBounds = YES;
        _mileageTF.layer.borderColor = kRGB(215, 215, 215).CGColor;
        _mileageTF.layer.cornerRadius = 4;
        _mileageTF.layer.borderWidth = 1.0f;
        _mileageTF.textAlignment = NSTextAlignmentCenter;
        [self.bgmView addSubview:_mileageTF];
        [_mileageTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bgmView.mas_right).offset(-10);
            make.top.mas_equalTo(self.timeTF.mas_bottom).offset(10);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(160);
        }];
        
        UILabel *lab = [MINUtils createLabelWithText:Localized(@"里程间隔(公里):")size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor:kRGB(96, 96, 96)];
        lab.numberOfLines = 0;
        [self.bgmView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_mileageTF.mas_centerY);
            make.left.mas_equalTo(self.bgmView.mas_left).offset(10);
            
        }];
    }
    return _mileageTF;
}
- (void)cancel {
    [self dismiss];
}
- (void)certain {
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnTextFieldValueTimeStr:serviceFlagStr:)]) {
        [self.delegate returnTextFieldValueTimeStr:self.timeTF.text serviceFlagStr:self.mileageTF.text];
    }
    [self dismiss];
}
- (void)popView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.timeTF becomeFirstResponder];
}
- (void)dismiss {
    [self removeFromSuperview];
}
#pragma mark 键盘出现
- (void)keyboardWillShow:(NSNotification*)note {
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.bgmView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30*frameSizeRate);
        make.right.mas_equalTo(-30*frameSizeRate);
        //make.centerY.mas_equalTo(self.mas_centerY);
        make.bottom.mas_equalTo(-keyBoardRect.size.height-10);
        make.height.mas_equalTo(220*frameSizeRate);
    }];
}
#pragma mark 键盘消失
- (void)keyboardWillHide:(NSNotification*)note {
    [self.bgmView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30*frameSizeRate);
        make.right.mas_equalTo(-30*frameSizeRate);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(220*frameSizeRate);
    }];
}
@end
