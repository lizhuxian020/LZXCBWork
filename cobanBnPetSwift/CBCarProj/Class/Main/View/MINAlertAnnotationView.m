//
//  MINAlertAnnotationView.m
//  Telematics
//
//  Created by lym on 2018/3/21.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "MINAlertAnnotationView.h"

@interface MINAlertAnnotationView ()

@end

@implementation MINAlertAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = [UIView new];
        [self addSubview:contentView];
        contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        
        self.textLbl = [MINUtils createLabelWithText:@"" size:14 alignment:NSTextAlignmentCenter textColor:kCellTextColor];
        [contentView addSubview:self.textLbl];
        [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerY.equalTo(@0);
        }];
        
        //CGRectMake(0, 0, 339 * KFitWidthRate, 377.5 * KFitHeightRate);
        //[self setFrame:CGRectMake(0, 0, 339 * KFitWidthRate, 377.5 * KFitHeightRate)];
//        [self setBounds:CGRectMake(0, 0, 339 * KFitWidthRate, 377.5 * KFitHeightRate)];
        //[self setBounds:CGRectMake(0.f, 0.f, 64 * KFitWidthRate, 31.5 * KFitWidthRate)];
//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f,  64 * KFitWidthRate, 31.5 * KFitWidthRate)];
//        _imageView.image = [UIImage imageNamed:@"小车-定位-报警"];
//        [self addSubview:_imageView];
    }
    return self;
}

@end
