//
//  RelatioshipCollectionViewCell.m
//  Watch
//
//  Created by lym on 2018/2/8.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "RelatioshipCollectionViewCell.h"

@implementation RelatioshipCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"哥哥"]];
        [self.contentView addSubview: self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
            make.size.mas_equalTo(CGSizeMake(75 * KFitWidthRate, 75 * KFitWidthRate));
        }];
        self.selectImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"头像-选中框"]];
        [self.contentView addSubview: self.selectImageView];
        [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
            make.size.mas_equalTo(CGSizeMake(75 * KFitWidthRate, 75 * KFitWidthRate));
        }];
        self.selectImageView.hidden = YES;
        self.textLabel = [CBWtMINUtils createLabelWithText: @"哥哥" size: 15 * KFitWidthRate alignment: NSTextAlignmentCenter textColor: KWtRGB(73, 73, 73)];
        [self.contentView addSubview: self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.imageView.mas_bottom);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setSelectStatus:(BOOL)isSelect
{
    
    if (isSelect == YES) {
        self.selectImageView.hidden = NO;
    }else {
        self.selectImageView.hidden = YES;
    }
}
- (void)setModel:(AddressBookEditModel *)model {
    _model = model;
    if (model) {
        _textLabel.text = model.title?:@"";
        _imageView.image = [UIImage imageNamed:model.imgName?:@""];
        self.selectImageView.hidden = !model.isSelect;
    }
}
@end
