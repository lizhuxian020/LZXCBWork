//
//  CBTrackSelectTimeView.m
//  Telematics
//
//  Created by coban on 2019/8/1.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBTrackSelectTimeView.h"

@interface CBTrackSelectTimeView ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *bgmView;
@property (nonatomic,strong) UIButton *selectBtn;
@end
@implementation CBTrackSelectTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taphandle:)];
    [self addGestureRecognizer:tap];
    tap.delegate = self;
    
    [self bgmView];
    
    NSArray *arrayTitle = @[Localized(@"今天"),Localized(@"昨天"),Localized(@"近三天")];
    //CGFloat btnWidthCust = [NSString getWidthWithText:Localized(@"近三天") font:[UIFont systemFontOfSize:14] height:40*KFitHeightRate];
    CGFloat btnWidth = (SCREEN_WIDTH - 40*KFitWidthRate*2 - 10*KFitWidthRate*2 - 15*KFitWidthRate*2)/arrayTitle.count;
    for (int i = 0 ; i < arrayTitle.count ; i ++ ) {
        UIButton *btn = [UIButton new];
        btn.tag = 100 + i;
        [btn setTitle:arrayTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 6*KFitHeightRate;//40*KFitHeightRate/2;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = kRGB(223, 223, 223).CGColor;//kBackColor.CGColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_bgmView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10*KFitWidthRate + i*(btnWidth + 15*KFitWidthRate));
            make.top.mas_equalTo(35*KFitHeightRate*2);
            make.size.mas_equalTo(CGSizeMake(btnWidth, 40*KFitHeightRate));
        }];
        [btn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            _selectBtn = btn;
        }
    }
    
    CGFloat btnctionWidth = (SCREEN_WIDTH - 40*KFitWidthRate*2 - 10*KFitWidthRate*2 - 20*KFitWidthRate)/2;
    UIButton *btnCancel = [UIButton new];
    btnCancel.layer.masksToBounds = YES;
    btnCancel.layer.cornerRadius = 10*KFitHeightRate;
    [btnCancel setTitle:Localized(@"取消") forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor colorWithHexString:@"606060"] forState:UIControlStateNormal];
    btnCancel.backgroundColor = kRGB(206, 206, 206);
    [_bgmView addSubview:btnCancel];
    [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35*KFitHeightRate*2 + 40*KFitHeightRate + 10*KFitHeightRate);
        make.left.mas_equalTo(10*KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(btnctionWidth, 45*KFitHeightRate));
    }];
    [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnCertain = [UIButton new];
    btnCertain.layer.masksToBounds = YES;
    btnCertain.layer.cornerRadius = 10*KFitHeightRate;
    [btnCertain setTitle:Localized(@"确定") forState:UIControlStateNormal];
    [btnCertain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCertain.backgroundColor = kBlueColor;
    [_bgmView addSubview:btnCertain];
    [btnCertain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35*KFitHeightRate*2 + 40*KFitHeightRate + 10*KFitHeightRate);
        make.right.mas_equalTo(-10*KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(btnctionWidth, 45*KFitHeightRate));
    }];
    [btnCertain addTarget:self action:@selector(certain) forControlEvents:UIControlEventTouchUpInside];
}
- (UIView *)bgmView {
    if (!_bgmView) {
        _bgmView = [UIView new];
        _bgmView.backgroundColor = [UIColor whiteColor];
        _bgmView.frame = CGRectMake(40*KFitWidthRate, 0, SCREEN_WIDTH - 40*KFitWidthRate*2, 175*KFitHeightRate);
        _bgmView.alpha = 0;
        _bgmView.layer.masksToBounds = YES;
        _bgmView.layer.cornerRadius = 4*KFitHeightRate;
        [self addSubview:_bgmView];
//        [_bgmView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(self.mas_centerX);
//            make.centerY.mas_equalTo(self.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40*KFitWidthRate*2, 175*KFitHeightRate));
//        }];
        UILabel *labelTitle = [MINUtils createLabelWithText:Localized(@"选择时间") size:18*KFitWidthRate alignment: NSTextAlignmentCenter textColor: [UIColor colorWithHexString:@"333333"]];
        labelTitle.font = [UIFont fontWithName:@"PingFang SC" size:18*KFitWidthRate];
        [_bgmView addSubview:labelTitle];
        [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15*KFitHeightRate);
            make.centerX.mas_equalTo(self->_bgmView.mas_centerX);
            make.height.mas_equalTo(20*KFitHeightRate);
        }];
        
    }
    return _bgmView;
}
- (void)cancel {
    if (self.btnClickBlick) {
        self.btnClickBlick(@"");
    }
    [self dismiss];
}
- (void)certain {
    if (self.btnClickBlick) {
        self.btnClickBlick(@"1");
    }
    [self dismiss];
}
- (void)selectTime:(UIButton *)sender {
    if ([sender isEqual:_selectBtn]) {
        // 点击了默认默认第一个
        _selectBtn.layer.borderColor = kBlueColor.CGColor;
        [_selectBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
        
    } else {
        sender.layer.borderColor = kBlueColor.CGColor;
        [sender setTitleColor:kBlueColor forState:UIControlStateNormal];
        
        _selectBtn.layer.borderColor = kRGB(223, 223, 223).CGColor;
        [_selectBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    _selectBtn = sender;
    
    NSDate *nowDate = [NSDate date];
    NSDate *yesterdayDate = [nowDate dateByAddingTimeInterval:-24*60*60];
    NSDate *bfYesterdayDate = [nowDate dateByAddingTimeInterval:-24*60*60*2];

    switch (sender.tag) {
        case 100:
        {
            NSDictionary *dicTodayTime = [CBCommonTools getSomeDayPeriod:[NSDate date]];
            self.dateStrStar = [NSString stringWithFormat:@"%@",dicTodayTime[@"startTime"]];
            self.dateStrEnd = [NSString stringWithFormat:@"%@",dicTodayTime[@"endTime"]];
            
        }
            break;
        case 101:
        {
            NSDictionary *dicYesterdayTime = [CBCommonTools getSomeDayPeriod:yesterdayDate];
            self.dateStrStar = [NSString stringWithFormat:@"%@",dicYesterdayTime[@"startTime"]];
            self.dateStrEnd = [NSString stringWithFormat:@"%@",dicYesterdayTime[@"endTime"]];
            
        }
            break;
        case 102:
        {
            NSDictionary *dicYesterdayTime = [CBCommonTools getSomeDayPeriod:yesterdayDate];
            NSDictionary *dicBfYesterdayDateTime = [CBCommonTools getSomeDayPeriod:bfYesterdayDate];
            self.dateStrStar = [NSString stringWithFormat:@"%@",dicBfYesterdayDateTime[@"startTime"]];
            self.dateStrEnd = [NSString stringWithFormat:@"%@",dicYesterdayTime[@"endTime"]];
            
        }
            break;
        default:
            break;
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
    if (self.tapClickBlock) {
        self.tapClickBlock(@"");
    }
    [self dismiss];
}
-(void)popView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.bgmView.alpha = 1;
        self.bgmView.frame = CGRectMake(40*KFitWidthRate, (SCREEN_HEIGHT-175*KFitWidthRate)/2, SCREEN_WIDTH - 40*KFitWidthRate*2, 175*KFitHeightRate);
    }];
}
-(void)dismiss {
    self.bgmView.alpha = 0;
    self.bgmView.frame = CGRectMake(40*KFitWidthRate, 0, SCREEN_WIDTH - 40*KFitWidthRate*2, 175*KFitHeightRate);
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
