//
//  PictureCollectionViewCell.m
//  Telematics
//
//  Created by lym on 2017/11/20.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "PictureCollectionViewCell.h"

@implementation PictureCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowRadius = 5 * KFitWidthRate;
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowOffset  = CGSizeMake(0, 3);// 阴影的范围
        self.layer.cornerRadius = 5 * KFitWidthRate;
        UIImage *image = [UIImage imageNamed: @"picture"];
        _imageView = [[UIImageView alloc] initWithImage: image];
        [self addSubview: _imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(80 * KFitWidthRate);
        }];
        _nameLabel = [MINUtils createLabelWithText: @"12:30:22" size: 12 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: kRGB(96, 96, 96)];
        [self addSubview: _nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(_imageView.mas_bottom);
        }];
    }
    return self;
}
@end
