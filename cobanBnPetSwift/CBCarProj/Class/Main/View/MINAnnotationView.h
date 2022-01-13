//
//  MINAnnotationView.h
//  Telematics
//
//  Created by lym on 2018/3/20.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "MINNormalAnnotation.h"

@interface MINAnnotationView : BMKAnnotationView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) MINNormalAnnotation *model;
@end
