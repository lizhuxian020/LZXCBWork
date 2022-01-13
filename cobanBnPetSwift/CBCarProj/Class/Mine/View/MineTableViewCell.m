//
//  MineTableViewCell.m
//  Telematics
//
//  Created by lym on 2017/10/25.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kBackColor;
        UIView *backView = [MINUtils createViewWithRadius:5*KFitHeightRate];
        [self addSubview: backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).with.offset(12.5*KFitHeightRate);
            make.right.equalTo(self).with.offset(-12.5*KFitHeightRate);
            make.bottom.equalTo(self);
        }];
        _nameLabel = [MINUtils createLabelWithText: @"设备管理"];
        [backView addSubview: _nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView);
            make.left.equalTo(backView).with.offset(12.5 * KFitHeightRate);
            make.height.mas_equalTo(20 * KFitHeightRate);
        }];
        UIButton *detailBtn = [[UIButton alloc] init];
        [detailBtn setImage: [UIImage imageNamed: @"右边"] forState: UIControlStateNormal];
        [detailBtn setImage: [UIImage imageNamed: @"右边"] forState: UIControlStateHighlighted];
        [backView addSubview: detailBtn];
        [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView);
            make.right.equalTo(backView).with.offset(-12.5*KFitHeightRate);
            make.size.mas_equalTo(CGSizeMake(16*KFitHeightRate, 16*KFitHeightRate));
        }];
    }
    return self;
}
@end
