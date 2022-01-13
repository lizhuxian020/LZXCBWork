//
//  CBVoicePopView.m
//  Watch
//
//  Created by coban on 2019/9/5.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBVoicePopView.h"

@interface CBVoicePopView ()
@property (nonatomic,strong) UIImageView *voiceImgView;
//@property (nonatomic,strong) UILabel *timeLb;
@end

@implementation CBVoicePopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    [self.voiceImgView startAnimating];
    [self timeLb];
}
#pragma mark -- setting && getting
- (UIImageView *)voiceImgView {
    if (!_voiceImgView) {
        _voiceImgView = [UIImageView new];
        UIImage *img_normal = [UIImage imageNamed:@"icon_microphone_normal"];
        UIImage *img_recording = [UIImage imageNamed:@"icon_microphone_recoding"];
        _voiceImgView.image = img_normal;
        [self addSubview:_voiceImgView];
        [_voiceImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        // 动画图片组
        _voiceImgView.animationImages = @[img_normal,img_recording];
        // 播放一次所需时长
        _voiceImgView.animationDuration = 1.0f;
        // 图片播放次数，0 表示无限
        _voiceImgView.animationRepeatCount = 0;
    }
    return _voiceImgView;
}
- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UILabel new];
        _timeLb.font = [UIFont fontWithName:CBPingFangSC_Regular size:16];
        _timeLb.textAlignment = NSTextAlignmentCenter;
        _timeLb.textColor = [UIColor whiteColor];
        _timeLb.numberOfLines = 0;
        _timeLb.text = @"00:00";
        [self addSubview:_timeLb];
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.voiceImgView.mas_bottom).offset(15);
            make.height.mas_equalTo(20);
        }];
    }
    return _timeLb;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
