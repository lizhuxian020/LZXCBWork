//
//  SwitchHeaderView.m
//  Watch
//
//  Created by lym on 2018/2/8.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "SwitchHeaderView.h"
#import "SwitchView.h"
#import "MINSwitchView.h"

@interface SwitchHeaderView() <MINSwtichViewDelegate>

@end

@implementation SwitchHeaderView

- (instancetype)init
{
    if (self = [super init]) {
        self.imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"上课禁用"]];
        [self addSubview: self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(self.imageView.mas_width).multipliedBy(4.0/7.5);
        }];
        self.swtichView = [[SwitchView alloc] init];
        [self addSubview: self.swtichView];
        [self.swtichView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.imageView.mas_bottom);
            make.height.mas_equalTo(50 * KFitWidthRate);
        }];
        self.swtichView.switchView.delegate = self;
    }
    return self;
}

#pragma mark - MINSwtichViewDelegate
- (void)switchView:(MINSwitchView *)switchView stateChange:(BOOL)isON
{
    if (isON == YES) {
        self.swtichView.statusLabel.text = Localized(@"已开启");
    }else {
        self.swtichView.statusLabel.text = Localized(@"已关闭");
    }
    if (self.switchStatusChange) {
        self.switchStatusChange(isON);
    }
}

@end
