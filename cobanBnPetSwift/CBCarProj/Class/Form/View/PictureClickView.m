//
//  PictureClickView.m
//  Telematics
//
//  Created by lym on 2017/11/20.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "PictureClickView.h"

@implementation PictureClickView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.3];
        UIImage *image = [UIImage imageNamed: @"picture"];
        _imageView = [[UIImageView alloc] initWithImage: image];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview: _imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        [self addGesture];
    }
    return self;
}

#pragma mark - gesture
- (void)addGesture
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureRecognizer];
}


-(void)hideView:(UITapGestureRecognizer*)tap{
    [self removeFromSuperview];
}

@end
