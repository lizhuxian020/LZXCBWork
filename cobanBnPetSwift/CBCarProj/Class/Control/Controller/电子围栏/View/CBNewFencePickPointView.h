//
//  CBNewFencePickPointView.h
//  Telematics
//
//  Created by coban on 2020/1/9.
//  Copyright © 2020 coban. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "CBTrackPointView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBNewFencePickPointView : BMKAnnotationView
@property (nonatomic, strong) UIView *pointView;
@property (nonatomic, strong) CBTrackPointView *pointView_realTime;
@end

NS_ASSUME_NONNULL_END
