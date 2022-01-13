//
//  MINAnnotationView.m
//  Telematics
//
//  Created by lym on 2018/3/20.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "MINAnnotationView.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "MINNormalAnnotation.h"

@implementation MINAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        MINNormalAnnotation *model = (MINNormalAnnotation *)annotation;
//        [self setBounds:CGRectMake(0.f, 0.f, 64 * KFitWidthRate, 31.5 * KFitWidthRate)];
//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f,  64 * KFitWidthRate, 31.5 * KFitWidthRate)];
//        _imageView.image = [UIImage imageNamed:@"playBack"];
//        [self addSubview:_imageView];
        
        [self setBounds:CGRectMake(0.f, 0.f,  model.icon.size.width, model.icon.size.height)];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f,  model.icon.size.width, model.icon.size.height)];
        _imageView.image = nil;//[UIImage imageNamed:@"playBack"];
        //_imageView.backgroundColor = [UIColor redColor];
        //_imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
    }
    return self;
}
- (void)setModel:(MINNormalAnnotation *)model {
    _model = model;
    if (model) {
        [self setBounds:CGRectMake(0.f, 0.f,  model.icon.size.width, model.icon.size.height)];
        //_imageView.backgroundColor = [UIColor redColor];
        _imageView.image = model.icon;// 32 62  28 56 24 48
        _imageView.frame = CGRectMake(0.f, 0.f,  model.icon.size.width, model.icon.size.height);
    }
}
@end
