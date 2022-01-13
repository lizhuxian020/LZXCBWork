//
//  CBControlAlertPopView.m
//  Telematics
//
//  Created by coban on 2019/11/22.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBControlAlertPopView.h"

@interface CBControlAlertPopView ()
@property (nonatomic,strong) UIView *bgmView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *msgLb;
@property (nonatomic,strong) UIButton *certainBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@end
@implementation CBControlAlertPopView

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
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taphandle:)];
    //    [self addGestureRecognizer:tap];
    //    tap.delegate = self;
    
    [self bgmView];
    [self titleLb];
    [self msgLb];
    [self cancelBtn];
    [self certainBtn];
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
            make.height.mas_equalTo(200*frameSizeRate);
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
- (UILabel *)msgLb {
    if (!_msgLb) {
        _msgLb = [MINUtils createLabelWithText:Localized(@"布防/撤防")size: 16 * KFitWidthRate alignment: NSTextAlignmentCenter textColor:kTextFieldColor];
        _msgLb.numberOfLines = 0;
        [self.bgmView addSubview:_msgLb];
        [_msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self.bgmView);
            //make.height.mas_equalTo(45 * KFitHeightRate);
            make.centerY.mas_equalTo(self.bgmView.mas_centerY).offset(-10);
            //make.left.right.equalTo(self.bgmView);
        }];
    }
    return _msgLb;
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
- (void)cancel {
    [self dismiss];
}
- (void)certain {
//    if (self.btnBlock) {
//        self.btnBlock(@"");
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickType:)]) {
        [self.delegate clickType:self.titleLb.text];
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
- (void)updateTitle:(NSString *)title msg:(NSString *)msgStr {
    self.titleLb.text = title;
    self.msgLb.text = msgStr;
}
- (void)popView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)dismiss {
    [self removeFromSuperview];
}
@end
