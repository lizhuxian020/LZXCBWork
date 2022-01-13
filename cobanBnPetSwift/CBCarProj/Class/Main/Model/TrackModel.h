//
//  TrackModel.h
//  Telematics
//
//  Created by lym on 2018/3/22.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface TrackModel : NSObject
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, assign) float speed;
//@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *mileage;
@end


// 运动结点信息类
@interface BMKSportNode : NSObject

//经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//方向（角度）
@property (nonatomic, assign) CGFloat angle;
//距离
@property (nonatomic, assign) CGFloat distance;
//速度
@property (nonatomic, assign) CGFloat speed;
// 上报时间
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *create_time;

@end


@interface CoordsList : NSObject
@property(nonatomic, readonly, copy) GMSPath *path;
@property(nonatomic, assign) NSUInteger target;

- (id)initWithPath:(GMSPath *)path;

- (CLLocationCoordinate2D)next;

@end
