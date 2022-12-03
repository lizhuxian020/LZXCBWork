//
//  _CBControlMenuCell.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/29.
//  Copyright © 2022 coban. All rights reserved.
//

#import "_CBControlMenuCell.h"

@interface _CBControlMenuCell ()

@property (nonatomic, strong) UIImageView *iconV;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIImageView *arrowV;

@end

@implementation _CBControlMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _iconV = [UIImageView new];
    [self.contentView addSubview:self.iconV];
    [self.iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.top.equalTo(@15);
        make.left.equalTo(@15);
        make.bottom.equalTo(@-15);
    }];
    
    self.titleLbl = [MINUtils createLabelWithText:@"" size:14 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
    [self.contentView addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(self.iconV.mas_right).mas_offset(15);
    }];
    
    self.arrowV = [UIImageView new];
    self.arrowV.image = [UIImage imageNamed:@"detail"];
    [self.contentView addSubview:self.arrowV];
    [self.arrowV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(@0);
        make.right.equalTo(@-15);
    }];
    
    UIView *line = [UIView new];
    [self.contentView addSubview:line];
    line.backgroundColor = KCarLineColor;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.height.equalTo(@1);
    }];
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    self.imageView.image = [UIImage imageNamed:data[@"icon"]];
    self.titleLbl.text = data[@"title"];
}
@end
