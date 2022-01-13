//
//  CBNewFenceMenuView.m
//  Telematics
//
//  Created by coban on 2020/1/2.
//  Copyright © 2020 coban. All rights reserved.
//

#import "CBNewFenceMenuView.h"

@interface CBNewFenceMenuView ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIView *bgmView;
@property (nonatomic,strong) UIButton *btnDone;
@property (nonatomic,strong) UIButton *btnCancel;
@property (nonatomic,strong) UIButton *btnReset;

@end

@implementation CBNewFenceMenuView

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
- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.bgmView.layer.shadowColor = [UIColor redColor].CGColor;//[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
//    self.bgmView.layer.shadowOffset = CGSizeMake(0,5);
//    self.bgmView.layer.shadowRadius = 10;
//    self.bgmView.layer.shadowOpacity = 1;
}
- (void)setupView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taphandle:)];
    [self addGestureRecognizer:tap];
    tap.delegate = self;
    [self bgmView];
    [self btnDone];
    [self btnCancel];
    [self btnReset];
}
- (UIView *)bgmView {
    if (!_bgmView) {
        _bgmView = [UIView new];
        _bgmView.backgroundColor = [UIColor whiteColor];
        _bgmView.layer.masksToBounds = YES;
        _bgmView.layer.cornerRadius = 4;
        
        _bgmView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
        _bgmView.layer.shadowOffset = CGSizeMake(0,5);
        _bgmView.layer.shadowRadius = 10;
        _bgmView.layer.shadowOpacity = 1;
        
        [self addSubview:_bgmView];
        [_bgmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo( - PPNavigationBarHeight - 140*KFitHeightRate);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(100, (10*KFitHeightRate + 30*KFitHeightRate)*3 + 10*KFitHeightRate));
        }];
    }
    return _bgmView;
}
- (UIButton *)btnDone {
    if (!_btnDone) {
        _btnDone = [MINUtils createNoBorderBtnWithTitle:Localized(@"完成")];
        [_btnDone setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _btnDone.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnDone addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnDone.tag = 100;
        [self.bgmView addSubview:_btnDone];
        [_btnDone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgmView);
            make.top.mas_equalTo(10*KFitHeightRate);
            make.height.mas_equalTo(30*KFitHeightRate);;
        }];
    }
    return _btnDone;
}
- (UIButton *)btnCancel {
    if (!_btnCancel) {
        _btnCancel = [MINUtils createNoBorderBtnWithTitle:Localized(@"撤销")];
        [_btnCancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _btnCancel.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnCancel addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnCancel.tag = 101;
        [self.bgmView addSubview:_btnCancel];
        [_btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgmView);
            make.top.mas_equalTo(self.btnDone.mas_bottom).offset(10*KFitHeightRate);
            make.height.mas_equalTo(30*KFitHeightRate);
        }];
    }
    return _btnCancel;
}
- (UIButton *)btnReset {
    if (!_btnReset) {
        _btnReset = [MINUtils createNoBorderBtnWithTitle:Localized(@"重置")];
        [_btnReset setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _btnReset.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnReset addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnReset.tag = 102;
        [self.bgmView addSubview:_btnReset];
        [_btnReset mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgmView);
            make.top.mas_equalTo(self.btnCancel.mas_bottom).offset(10*KFitHeightRate);
            make.height.mas_equalTo(30*KFitHeightRate);;
        }];
    }
    return _btnReset;
}
- (void)menuClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickType:)]) {
        [self.delegate clickType:sender.tag];
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
- (void)popView {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.bgmView.superview layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        [self.bgmView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(PPNavigationBarHeight + 5);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(100, (10*KFitHeightRate + 30*KFitHeightRate)*3 + 10*KFitHeightRate));
        }];
        [self.bgmView.superview layoutIfNeeded];
    }];
}
- (void)dismiss {
    [self.bgmView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo( - PPNavigationBarHeight - 140*KFitHeightRate);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(0, (10*KFitHeightRate + 30*KFitHeightRate)*3 + 10*KFitHeightRate));
    }];
    [self removeFromSuperview];
}
@end
