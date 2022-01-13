//
//  MINAlertAnnotationView.m
//  Telematics
//
//  Created by lym on 2018/3/21.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "MINAlertAnnotationView.h"

@implementation MINAlertAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        //CGRectMake(0, 0, 339 * KFitWidthRate, 377.5 * KFitHeightRate);
        //[self setFrame:CGRectMake(0, 0, 339 * KFitWidthRate, 377.5 * KFitHeightRate)];
        [self setBounds:CGRectMake(0, 0, 339 * KFitWidthRate, 377.5 * KFitHeightRate)];
        //[self setBounds:CGRectMake(0.f, 0.f, 64 * KFitWidthRate, 31.5 * KFitWidthRate)];
//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f,  64 * KFitWidthRate, 31.5 * KFitWidthRate)];
//        _imageView.image = [UIImage imageNamed:@"小车-定位-报警"];
//        [self addSubview:_imageView];
    }
    return self;
}

@end
