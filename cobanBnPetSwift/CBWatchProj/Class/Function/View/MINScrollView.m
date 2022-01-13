//
//  MINScrollView.m
//  Watch
//
//  Created by lym on 2018/2/9.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "MINScrollView.h"

@implementation MINScrollView

- (instancetype)init
{
    if (self = [super init]) {
        self.scrollView = [[UIScrollView alloc] init];
        [self addSubview: self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self);
            make.bottom.equalTo(self).with.offset(0);
        }];
        self.contentView = [[UIView alloc] init];
        [self.scrollView addSubview: self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            // insets // 内边距
            make.top.left.bottom.and.right.equalTo(self.scrollView).with.insets(UIEdgeInsetsZero);
            make.width.equalTo(self.scrollView);
        }];
    }
    return self;
}

@end
