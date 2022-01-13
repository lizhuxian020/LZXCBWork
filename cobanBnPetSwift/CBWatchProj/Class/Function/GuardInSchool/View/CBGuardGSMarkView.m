//
//  CBGuardGSMarkView.m
//  cobanBnWatch
//
//  Created by coban on 2019/12/3.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBGuardGSMarkView.h"

@interface CBGuardGSMarkView ()
@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) UIView *blueView;
@end
@implementation CBGuardGSMarkView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.whiteView.layer.cornerRadius = 6;
    self.whiteView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.whiteView.layer.shadowRadius = 6;//10;//5 * KFitWidthRate;
    self.whiteView.layer.shadowOpacity = 0.8;//0.3;
    self.whiteView.layer.shadowOffset  = CGSizeMake(0, 5);//CGSizeMake(0, 5);// 阴影的范围
    
    self.blueView.layer.cornerRadius = 4;
    
    self.layer.cornerRadius = 6;
}
- (void)setupView {
    [self whiteView];
    [self blueView];
}
- (UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [UIView new];
        _whiteView.backgroundColor = UIColor.whiteColor;
        [self addSubview:_whiteView];
        [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(12, 12));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return _whiteView;
}
- (UIView *)blueView {
    if (!_blueView) {
        _blueView = [UIView new];
        _blueView.backgroundColor = KWtBlueColor;
        [self addSubview:_blueView];
        [_blueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 8));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return _blueView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
