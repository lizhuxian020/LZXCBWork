//
//  FunctionCollectionViewCell.m
//  Watch
//
//  Created by lym on 2018/2/7.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "FunctionCollectionViewCell.h"

@implementation FunctionCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"代收短信"]];
        [self.contentView addSubview: self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
            make.size.mas_equalTo(CGSizeMake(40 * KFitWidthRate, 40 * KFitWidthRate));
        }];
        self.textLabel = [CBWtMINUtils createLabelWithText: @"短信" size: 15 * KFitWidthRate alignment: NSTextAlignmentCenter textColor: KWtRGB(73, 73, 73)];
        self.textLabel.numberOfLines = 0;
        [self.contentView addSubview: self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.imageView.mas_bottom);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}
@end
