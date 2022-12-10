//
//  CBSportAnnotation.h
//  Telematics
//
//  Created by coban on 2019/7/31.
//  Copyright © 2019 coban. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "CBTrackPointView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBRadiusAnnotation : BMKPointAnnotation

@property (nonatomic, assign) CGFloat radius;

@end

@interface CBRectAnnotation : BMKPointAnnotation

@end

@interface CBSportAnnotation : BMKPointAnnotation
// 是否隐藏
@property (nonatomic, assign) BOOL isHiddenCar;

@end

// 自定义BMKAnnotationView，用于显示运动者
@interface SportAnnotationView : BMKAnnotationView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *iconImage;
@end


// 自定义BMKAnnotationView，用于显示百度轨迹圆点
@interface SportPointAnnotationView : BMKAnnotationView
@property (nonatomic, strong) UIView *pointView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CBTrackPointView *pointView_realTime;
@end

NS_ASSUME_NONNULL_END
