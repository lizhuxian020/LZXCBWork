//
//  CBGuardSliderView.m
//  Watch
//
//  Created by coban on 2019/9/2.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBGuardSliderView.h"
#import "UIImage+YLImage.h"

@interface CBGuardSliderView ()
@property (nonatomic,strong) UILabel *fenLb;
@property (nonatomic,strong) UISlider *sliderView;
@end
@implementation CBGuardSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    [self fenLb];
    [self sliderView];
}
- (UILabel *)fenLb {
    if (!_fenLb) {
        _fenLb = [UILabel new];
        _fenLb.textAlignment = NSTextAlignmentCenter;
        _fenLb.textColor = [UIColor redColor];
        _fenLb.text = [NSString stringWithFormat:@"0%@",Localized(@"米")];//@"0 米";
        [self addSubview:_fenLb];
        [_fenLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
    }
    return _fenLb;
}
- (UISlider *)sliderView {
    if (!_sliderView) {
        UIImage *img = [UIImage imageWithText:@"" fontSize:6 size:CGSizeMake(14, 14) textColor:[UIColor whiteColor] backgroundColor:[UIColor greenColor] radius:7];
        UIImage *imgHighlight = [UIImage imageWithText:@"" fontSize:6 size:CGSizeMake(18, 18) textColor:[UIColor whiteColor] backgroundColor:[UIColor greenColor] radius:9];
        _sliderView = [[UISlider alloc]init];
        _sliderView.maximumTrackTintColor = UIColor.grayColor;
        _sliderView.minimumTrackTintColor = UIColor.greenColor;
        [_sliderView setThumbImage:img forState:UIControlStateNormal];
        [_sliderView setThumbImage:imgHighlight forState:UIControlStateHighlighted];
        _sliderView.value = 0.0;
        _sliderView.minimumValue = 0.0f;
        _sliderView.maximumValue = 1000.0f;//1000.0;
        _sliderView.continuous = YES;  // 设置可连续变化
        [_sliderView addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法 UIControlEventTouchUpInside
        [self addSubview:_sliderView];
        [_sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-5);
            make.height.mas_equalTo(45);
        }];
    }
    return _sliderView;
}
- (void)sliderValueChange:(UISlider*)slide {
    
    NSInteger value = (NSInteger)_sliderView.value;
    // 取个位
    value = value/10;
    // 值为10的倍数
    value = value*10;
    _fenLb.text = [NSString stringWithFormat:@"%ld %@",(long)value,Localized(@"米")];
    if (self.sliderValueChangeBlock) {
        self.sliderValueChangeBlock([NSString stringWithFormat:@"%ld",(long)value]);
    }
}
- (void)setCurrentValue:(NSInteger)currentValue {
    _currentValue = currentValue;
    if (currentValue) {
        [_sliderView setValue:currentValue];
        _fenLb.text = [NSString stringWithFormat:@"%ld %@",(long)currentValue,Localized(@"米")];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
