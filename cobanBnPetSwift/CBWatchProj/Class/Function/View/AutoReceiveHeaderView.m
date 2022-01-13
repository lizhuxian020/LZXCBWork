//
//  AutoReceiveHeaderView.m
//  Watch
//
//  Created by lym on 2018/2/27.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "AutoReceiveHeaderView.h"

@implementation AutoReceiveHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        UIView *mainView = [[UIView alloc] init];
        mainView.backgroundColor = [UIColor whiteColor];
        [CBWtMINUtils addLineToView: mainView isTop: NO hasSpaceToSide: NO];
        [self addSubview: mainView];
        [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self).with.offset(12.5 * KFitWidthRate);
        }];
        self.titleLabel = [CBWtMINUtils createLabelWithText: @"手表管理员" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
        [mainView addSubview: self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mainView).with.offset(12.5 * KFitWidthRate);
            make.top.bottom.equalTo(mainView);
            make.right.equalTo(mainView);
        }];
    }
    return self;
}

@end
