//
//  CBControlPickPopView.m
//  Telematics
//
//  Created by coban on 2019/11/21.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBControlPickPopView.h"
#import "MINUtils.h"

@interface CBControlPickPopView ()
@property (nonatomic,strong) UIView *bgmView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIButton *certainBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) NSMutableArray *arrayBtn;
@end
@implementation CBControlPickPopView

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
- (void)setupView {
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taphandle:)];
    //    [self addGestureRecognizer:tap];
    //    tap.delegate = self;
    
    [self bgmView];
    [self titleLb];
    [self cancelBtn];
    [self certainBtn];
    
    NSArray *arrayTitle = @[@"",@"",@""];//@[Localized(@"布防"),Localized(@"撤防"),Localized(@"静音布防")];
    for (int i = 0 ; i < arrayTitle.count ; i ++ ) {
        UIButton *btn = [MINUtils createBtnWithRadius:5 * KFitHeightRate title:arrayTitle[i]];
        [self.bgmView addSubview:btn];
        btn.backgroundColor = kRGB(215, 215, 215);
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = kRGB(210, 210, 210).CGColor;
        btn.layer.cornerRadius = 3 * KFitWidthRate;
        [btn setTitleColor: k137Color forState: UIControlStateNormal];
        [btn setTitleColor: [UIColor whiteColor] forState: UIControlStateSelected];
        btn.tag = 100 + i;
        [self.arrayBtn addObject:btn];
        [self.bgmView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLb.mas_bottom).offset(5 + (40*KFitHeightRate + 10)*i);
            make.left.equalTo(self.bgmView.mas_left).offset(10);
            make.right.equalTo(self.bgmView.mas_right).offset(-10);
            make.height.mas_equalTo(40 * KFitHeightRate);
        }];
        [btn addTarget:self action:@selector(armingClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0)
            [self armingClick:btn];
    }
}
- (UIView *)bgmView {
    if (!_bgmView) {
        _bgmView = [UIView new];
        _bgmView.backgroundColor = [UIColor whiteColor];
        _bgmView.layer.masksToBounds = YES;
        _bgmView.layer.cornerRadius = 6*frameSizeRate;
        [self addSubview:_bgmView];
        [_bgmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30*KFitWidthRate);
            make.right.mas_equalTo(-30*KFitWidthRate);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(270*KFitHeightRate);
        }];
    }
    return _bgmView;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [MINUtils createLabelWithText:Localized(@"")size: 18 * KFitWidthRate alignment: NSTextAlignmentCenter textColor:kRGB(51, 51, 51)];
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
- (NSMutableArray *)arrayBtn {
    if (!_arrayBtn) {
        _arrayBtn = [NSMutableArray array];
    }
    return _arrayBtn;
}
- (void)cancel {
    [self dismiss];
}
- (void)certain {
    for (UIButton *btn in self.arrayBtn) {
        if (btn.selected) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(pickerPopViewClickIndex:)]) {
                [self.delegate pickerPopViewClickIndex:btn.tag];
            }
        }
    }
    [self dismiss];
}
- (void)armingClick:(UIButton *)sender {
    for (UIButton *btn in self.arrayBtn) {
        if ([sender isEqual:btn]) {
            btn.selected = YES;
            btn.backgroundColor = kBlueColor;
        } else {
            btn.selected = NO;
            btn.backgroundColor = kRGB(215, 215, 215);
        }
    }
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
- (void)updateTitle:(NSString *)title menuArray:(NSArray *)array seletedTitle:(NSString *)seletedTitle {
    self.titleLb.text = title;
    [self.arrayBtn enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        [btn setTitle:array[idx] forState:UIControlStateNormal];
        if ([[NSString stringWithFormat:@"%@",array[idx]] isEqualToString:seletedTitle]) {
            btn.selected = YES;
            btn.backgroundColor = kBlueColor;
        } else {
            btn.selected = NO;
            btn.backgroundColor = kRGB(215, 215, 215);
        }
    }];
}
- (void)popView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    if (self.arrayBtn.count) {
        UIButton *btn = self.arrayBtn[0];
        [self armingClick:btn];
    }
}
- (void)dismiss {
    [self removeFromSuperview];
}
@end
