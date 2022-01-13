//
//  FunctionHeaderCollectionReusableView.m
//  Watch
//
//  Created by lym on 2018/2/7.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "FunctionHeaderCollectionReusableView.h"

@implementation FunctionHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = KWtRGB(237, 237, 237);
        UIView *mainView = [[UIView alloc] init];
        mainView.backgroundColor = [UIColor whiteColor];
        [self addSubview: mainView];
        [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self).with.offset(12.5 * KFitWidthRate);
        }];
        self.titleLabel = [CBWtMINUtils createLabelWithText:@"常见功能" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
        [mainView addSubview: self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mainView).with.offset(12.5 * KFitWidthRate);
            make.top.bottom.equalTo(mainView);
            make.right.equalTo(mainView).with.offset(-12.5 * KFitWidthRate);
        }];
        UIView *lineView = [CBWtMINUtils createLineView];
        [self addSubview: lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mainView).with.offset(12.5 * KFitWidthRate);
            make.bottom.equalTo(mainView);
            make.right.equalTo(mainView).with.offset(-12.5 * KFitWidthRate);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

@end
