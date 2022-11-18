//
//  UIView+Badge.m
//  Base
//
//  Created by Main on 2020/11/19.
//

#import "UIView+Badge.h"
#import <objc/runtime.h>

NSString const *Badge_View = @"Badge_View";
NSString const *Badge_Value = @"Badge_Value";
NSString const *Badge_View_Height = @"Badge_View_Height";
NSString const *Badge_Constraint = @"Badge_Constraint";
NSString const *Badge_ConstraintMaker = @"Badge_ConstraintMaker";

@interface BadgeView ()

@property (nonatomic, strong) UILabel *textView;

@end

@implementation BadgeView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}


- (void)createView {
    self.textView.textAlignment = NSTextAlignmentCenter;
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(@0);
    }];
    self.backgroundColor = UIColor.redColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.mj_h/2.0f;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textView.text = text;
    [self setupFrame];
}

- (void)setupFrame {
    [self.textView sizeToFit];
    //label自带上下边距
    CGFloat height = self.superview.BadgeHeight;
    if (height <= 0) {
        height = 17;
    }
    //左右边距3
    CGFloat width = (self.textView.mj_w + 6) > height ? (self.textView.mj_w + 6) : height;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
    }];
}

- (UILabel *)textView {
    if (!_textView) {
        _textView = [[UILabel alloc] init];
        _textView.font = [UIFont systemFontOfSize:12];
        _textView.textColor = UIColor.whiteColor;
        [self addSubview:_textView];
    }
    return _textView;
}

@end

@implementation UIView (Badge)

- (void)CreateBadge {
    self.BadgeView = [BadgeView new];
    
    [self addSubview:self.BadgeView];
    [self.BadgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.badgeContraintMaker) {
            self.badgeContraintMaker(make, self.BadgeView, self);
        } else {
            make.centerX.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_top);
        }
    }];
}

- (void)setBadgeView:(BadgeView *)BadgeView {
    objc_setAssociatedObject(self, &Badge_View, BadgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)BadgeView {
    return objc_getAssociatedObject(self, &Badge_View);
}

- (void)setBadgeValue:(NSString *)BadgeValue {
    if (!self.BadgeView) {
        [self CreateBadge];
    }
    self.BadgeView.text = BadgeValue;
    self.BadgeView.hidden = !BadgeValue || ![BadgeValue length] || [BadgeValue isEqualToString:@"0"];
}

- (NSString *)BadgeValue {
    if (!self.BadgeView) {
        [self CreateBadge];
    }
    return self.BadgeView.text;
}

- (void)setBadgeContraintMaker:(void (^)(MASConstraintMaker * _Nonnull, BadgeView * _Nonnull, UIView * _Nonnull))badgeContraintMaker {
    objc_setAssociatedObject(self, &Badge_ConstraintMaker, badgeContraintMaker, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(MASConstraintMaker * _Nonnull, BadgeView * _Nonnull, UIView * _Nonnull))badgeContraintMaker {
    return objc_getAssociatedObject(self, &Badge_ConstraintMaker);
}

- (void)setBadgeHeight:(double)BadgeHeight {
    objc_setAssociatedObject(self, &Badge_View_Height, @(BadgeHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (double)BadgeHeight {
    return [objc_getAssociatedObject(self, &Badge_View_Height) doubleValue];
}

@end
