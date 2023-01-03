//
//  CBPhoneBookHeaderView.m
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/3.
//  Copyright © 2023 coban. All rights reserved.
//

#import "CBPhoneBookHeaderView.h"

@implementation CBPhoneBookHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = kBackColor;
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = kRGB(238, 238, 238);
    [self addSubview: backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    NSArray *titleArr = @[
        Localized(@"设备名称"),
        Localized(@"电话"),
        Localized(@"类型"),
    ];
    
    UIView *lastView = nil;
    for (int i = 0; i < titleArr.count; i++) {
        NSString *title = titleArr[i];
        UILabel *lbl = [self createLabelWithText:title];
        [backView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
            } else {
                make.left.equalTo(@0);
            }
            if (i == 0) {
                make.width.equalTo(backView).multipliedBy(0.3);
            }
            if (i == 1) {
                make.width.equalTo(backView).multipliedBy(0.3);
            }
            if (i == 2) {
                make.width.equalTo(backView).multipliedBy(0.4);
            }
        }];
        lastView = lbl;
    }
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
    }];
    
}

- (UILabel *)createLabelWithText:(NSString *)text
{
    UILabel *label = [MINUtils createLabelWithText: text size:14 alignment: NSTextAlignmentLeft textColor: kCellTextColor];
    return label;
}

@end
