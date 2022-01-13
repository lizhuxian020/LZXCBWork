//
//  CBAvatarAnnotationView.h
//  Watch
//
//  Created by coban on 2019/8/16.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapView.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBAvatarAnnotationView : BMKAnnotationView

@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, copy) NSString *statusStr;
@property (nonatomic, strong) HomeModel *homeModel;
@property (nonatomic,strong) void (^avtarClickBlock)(id objc);

@end

NS_ASSUME_NONNULL_END
