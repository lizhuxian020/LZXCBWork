//
//  CBPetWakeUpPopView.m
//  cobanBnPetSwift
//
//  Created by hsl on 2021/12/3.
//  Copyright © 2021 coban. All rights reserved.
//

#import "CBPetWakeUpPopView.h"

@interface CBPetWakeUpPopView ()<UITextFieldDelegate>
@property (nonatomic,strong) UIView *bgmView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIButton *certainBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIView *line_horizonl;
@property (nonatomic,strong) UIView *line_vertical;
//@property (nonatomic,strong) UITextField *inputTF;
@property (nonatomic,assign) BOOL isDigital;
@end

@implementation CBPetWakeUpPopView

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
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taphandle:)];
    //    [self addGestureRecognizer:tap];
    //    tap.delegate = self;
    
    [self bgmView];
    [self titleLb];
    [self cancelBtn];
    [self certainBtn];
    [self line_horizonl];
    [self line_vertical];
}
- (UIView *)bgmView {
    if (!_bgmView) {
        _bgmView = [UIView new];
        _bgmView.backgroundColor = [UIColor whiteColor];
        _bgmView.layer.masksToBounds = YES;
        _bgmView.layer.cornerRadius = 16*frameSizeRate;
        [self addSubview:_bgmView];
        [_bgmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(SCREEN_WIDTH-106*frameSizeRate);
            make.height.mas_equalTo(150*frameSizeRate);
        }];
    }
    return _bgmView;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [MINUtils createLabelWithText:Localized(@"布防/撤防")size: 18 * KFitWidthRate alignment: NSTextAlignmentCenter textColor:kRGB(51, 51, 51)];
        _titleLb.numberOfLines = 0;
        _titleLb.font = [UIFont fontWithName:CBPingFang_SC_Bold size:18*KFitWidthRate];
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
        _cancelBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"取消") titleColor: [UIColor colorWithHexString:@"#999999"] fontSize: 15 * KFitWidthRate backgroundColor: [UIColor whiteColor]];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self.bgmView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) { 
            make.left.equalTo(self.bgmView.mas_left).offset(0);
            make.right.equalTo(self.certainBtn.mas_left).offset(-0);
            make.bottom.mas_equalTo(self.bgmView.mas_bottom).offset(-0);
            make.width.mas_equalTo(self.certainBtn.mas_width);
            make.height.mas_equalTo(45 * KFitHeightRate);
        }];
    }
    return _cancelBtn;
}
- (UIButton *)certainBtn { 
    if (!_certainBtn) {
        _certainBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"确定") titleColor: [UIColor colorWithHexString:@"#2DDFAF"] fontSize: 15 * KFitWidthRate backgroundColor: [UIColor whiteColor]];
        [_certainBtn addTarget:self action:@selector(certain) forControlEvents:UIControlEventTouchUpInside];
        [self.bgmView addSubview:_certainBtn];
        [_certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancelBtn.mas_right).offset(0);
            make.right.equalTo(self.bgmView.mas_right).offset(-0);
            make.bottom.mas_equalTo(self.bgmView.mas_bottom).offset(-0);
            make.width.mas_equalTo(self.cancelBtn.mas_width);
            make.height.mas_equalTo(45 * KFitHeightRate);
        }];
    }
    return _certainBtn;
}
- (UIView *)line_horizonl {
    if (!_line_horizonl) {
        _line_horizonl = [[UIView alloc]init];
        _line_horizonl.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
        [self.bgmView addSubview:_line_horizonl];
        [_line_horizonl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.certainBtn.mas_top).offset(0);
            make.height.mas_equalTo(1);
            make.left.mas_equalTo(self.bgmView.mas_left).offset(0);
            make.right.mas_equalTo(self.bgmView.mas_right).offset(0);
        }];
    }
    return _line_horizonl;
}
- (UIView *)line_vertical {
    if (!_line_vertical) {
        _line_vertical = [[UIView alloc]init];
        _line_vertical.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
        [self.bgmView addSubview:_line_vertical];
        [_line_vertical mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.bgmView.mas_bottom).offset(-0);
            make.centerX.mas_equalTo(self.bgmView.mas_centerX);
            make.top.mas_equalTo(self.certainBtn.mas_top).offset(0);
            make.width.mas_equalTo(1);
        }];
    }
    return _line_vertical;
}

- (UITextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [MINUtils createTextFieldWithHoldText:@"" fontSize: 15];
        _inputTF.delegate = self;
        [self.bgmView addSubview:_inputTF];
        [_inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgmView.mas_left).offset(10);
            make.centerY.equalTo(self.bgmView).with.offset(-5 * KFitHeightRate);
            make.height.mas_equalTo(40 * KFitHeightRate);
            make.width.mas_equalTo(250 * KFitWidthRate);
        }];
    }
    return _inputTF;
}
- (void)cancel {
    [self dismiss];
}
- (void)certain {
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateTextFieldValue:returnTitle:)]) {
        [self.delegate updateTextFieldValue:self.inputTF.text returnTitle:self.titleLb.text];
    }
    [self dismiss];
}
#pragma mark -------------- 手势代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (CGRectContainsPoint(self.bgmView.frame, [gestureRecognizer locationInView:self]) ) {
        return NO;
    } else {
        return YES;
    }
}
- (void)taphandle:(UITapGestureRecognizer*)sender {
    [self dismiss];
}
#pragma mark -- UITextField 代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.isDigital) {
        BOOL isDigital = [string isOnlyNumber];
        return isDigital;
    }
    return YES;
}
- (void)updateTitle:(NSString *)title placehold:(NSString *)placeholdStr isDigital:(BOOL)isDigital {
    self.isDigital = isDigital;
    self.titleLb.text = title;
    self.inputTF.placeholder = placeholdStr;
    
}
- (void)popView {
    [self.inputTF becomeFirstResponder];
    self.inputTF.text = @"";
    if (self.isDigital) {
        self.inputTF.keyboardType = UIKeyboardTypeNumberPad;
        [self.inputTF limitTextFieldTextLength:18];
    } else {
        self.inputTF.keyboardType = UIKeyboardTypeNamePhonePad;//UIKeyboardTypeASCIICapable;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)dismiss {
    [self removeFromSuperview];
}
#pragma mark 键盘出现
- (void)keyboardWillShow:(NSNotification*)note {
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.bgmView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyBoardRect.size.height-10);
        make.height.mas_equalTo(150*frameSizeRate);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH-106*frameSizeRate);
    }];
}
#pragma mark 键盘消失
- (void)keyboardWillHide:(NSNotification*)note {
    [self.bgmView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(150*frameSizeRate);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH-106*frameSizeRate);
    }];
}

@end
