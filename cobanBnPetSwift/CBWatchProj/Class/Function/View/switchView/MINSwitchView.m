//
//  MINSwitchView.m
//  Telematics
//
//  Created by lym on 2017/11/13.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MINSwitchView.h"

@interface MINSwitchView()

@property (nonatomic,copy) NSString *tagStr;

@end

@implementation MINSwitchView

+ (instancetype)switchWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage switchImage:(UIImage *)switchImage
{
    return [[self alloc] initWithOnImage: onImage offImage: offImage switchImage: switchImage];
}

- (instancetype)initWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage switchImage:(UIImage *)switchImage
{
    if (self = [super init]) {
        _onImage = onImage;
        _offImage = offImage;
        _switchImage = switchImage;
        _isON = NO;
        _switchImageBtn = [[UIButton alloc] init];
        [_switchImageBtn setImage: onImage forState: UIControlStateSelected];
        [_switchImageBtn setImage: offImage forState: UIControlStateNormal];
        //_switchImageBtn.backgroundColor = UIColor.greenColor;
        [self addSubview: _switchImageBtn];
        [_switchImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerY.equalTo(self);
            make.height.equalTo(self);
        }];
        _switchImageView = [[UIImageView alloc] initWithImage: switchImage];
        [self addSubview: _switchImageView];
        [_switchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(1);
            make.bottom.equalTo(self).with.offset(-1);
            make.width.equalTo(self.mas_height);
            make.right.equalTo(self).with.offset(-2);
        }];
        _switchBtn = [[UIButton alloc] init];
        [self addSubview: _switchBtn];
        [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self);
        }];
        [_switchBtn addTarget: self action: @selector(switchBtnClick) forControlEvents: UIControlEventTouchUpInside];
    }
    return self;
}

- (void)switchBtnClick
{
    if (self.switchImageBtn.selected == NO) {
        self.isON = YES;
    }else {
        self.isON = NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchView:stateChange:)]) {
        [self.delegate switchView: self stateChange: _isON];
    }
}
- (void)updateSwitchImageView:(NSString *)tag {
    self.tagStr = tag;
    if ([tag isEqualToString:@"断油断电"]) {
        [_switchImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(1);
            make.bottom.equalTo(self).with.offset(-1);
            make.width.equalTo(self.mas_height);
            make.left.equalTo(self).with.offset(2);
        }];
    } else {
        [_switchImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(1);
            make.bottom.equalTo(self).with.offset(-1);
            make.width.equalTo(self.mas_height);
            make.right.equalTo(self).with.offset(-2);
        }];
    }
}
- (void)setIsON:(BOOL)isON
{
    _isON = isON;
    if (isON == YES) {
        _switchImageBtn.selected = YES;
        if ([self.tagStr isEqualToString:@"断油断电"]) {
            [_switchImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(1);
                make.bottom.equalTo(self).with.offset(-1);
                make.width.equalTo(self.mas_height);
                make.left.equalTo(self).with.offset(2);
            }];
        } else {
            [_switchImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(1);
                make.bottom.equalTo(self).with.offset(-1);
                make.width.equalTo(self.mas_height);
                make.right.equalTo(self).with.offset(-2);
            }];
        }
        [_switchImageBtn.superview layoutIfNeeded];
    }else {
        _switchImageBtn.selected = NO;
        if ([self.tagStr isEqualToString:@"断油断电"]) {
            [_switchImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(1);
                make.bottom.equalTo(self).with.offset(-1);
                make.width.equalTo(self.mas_height);
                make.right.equalTo(self).with.offset(-2);
            }];
        } else {
            [_switchImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(1);
                make.bottom.equalTo(self).with.offset(-1);
                make.width.equalTo(self.mas_height);
                make.left.equalTo(self).with.offset(1);
            }];
        }
        [_switchImageBtn.superview layoutIfNeeded];
    }
}

@end
