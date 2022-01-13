//
//  CBSportAnnotation.m
//  Telematics
//
//  Created by coban on 2019/7/31.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBSportAnnotation.h"

@implementation CBSportAnnotation

@end

@implementation SportAnnotationView
@synthesize imageView = _imageView;
- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 64 * KFitWidthRate, 31.5 * KFitHeightRate)];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f,  64 * KFitWidthRate, 31.5 * KFitHeightRate)];
        _imageView.image = nil;
        [self addSubview:_imageView];
    }
    return self;
}
- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    if (iconImage) {
        [self setBounds:CGRectMake(0.f, 0.f,  iconImage.size.width, iconImage.size.height)];
        _imageView.frame = CGRectMake(0.f, 0.f,  iconImage.size.width, iconImage.size.height);
        _imageView.image = iconImage;
    }
}
@end


@implementation SportPointAnnotationView
- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 10*KFitWidthRate, 10*KFitWidthRate)];
        _pointView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10*KFitWidthRate, 10*KFitWidthRate)];
        _pointView.backgroundColor = kBlueColor;
        _pointView.layer.masksToBounds = YES;
        _pointView.layer.cornerRadius = 5*KFitWidthRate;
        [self addSubview:_pointView];
        
        _pointView_realTime = [[CBTrackPointView alloc]initWithFrame:CGRectMake(0, 0, 10*KFitWidthRate, 10*KFitWidthRate)];
        [self addSubview:_pointView_realTime];
        _pointView_realTime.hidden = YES;
    }
    return self;
}
@end

