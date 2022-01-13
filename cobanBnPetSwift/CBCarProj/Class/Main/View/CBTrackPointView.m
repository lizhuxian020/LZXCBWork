//
//  CBTrackPointView.m
//  Telematics
//
//  Created by coban on 2019/8/7.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBTrackPointView.h"

@interface CBTrackPointView ()
@property (nonatomic,strong) UIView *bgmView;
@property (nonatomic,strong) UIView *blueView;
@end
@implementation CBTrackPointView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self bgmView];
        [self blueView];
    }
    return self;
}
- (UIView *)bgmView {
    if (!_bgmView) {
        _bgmView = [[UIView alloc]init];
        _bgmView.backgroundColor = [UIColor whiteColor];
        _bgmView.layer.masksToBounds = YES;
        _bgmView.layer.cornerRadius = 4;
        
        _bgmView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
        _bgmView.layer.shadowOffset = CGSizeMake(0,5);
        _bgmView.layer.shadowRadius = 10;
        _bgmView.layer.shadowOpacity = 1;
        _bgmView.layer.cornerRadius = 4;
        
        [self addSubview:_bgmView];
        [_bgmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
    }
    return _bgmView;
}
- (UIView *)blueView {
    if (!_blueView) {
        _blueView = [[UIView alloc]init];
        _blueView.layer.masksToBounds = YES;
        _blueView.backgroundColor = kBlueColor;
        _blueView.layer.cornerRadius = 2;
        [self addSubview:_blueView];
        [_blueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(4, 4));
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
