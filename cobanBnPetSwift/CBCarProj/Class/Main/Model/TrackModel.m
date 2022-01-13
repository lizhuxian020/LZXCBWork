//
//  TrackModel.m
//  Telematics
//
//  Created by lym on 2018/3/22.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "TrackModel.h"

@implementation TrackModel

@end


@implementation BMKSportNode

@end


@implementation CoordsList

- (id)initWithPath:(GMSPath *)path {
    if ((self = [super init])) {
        _path = [path copy];
        _target = 0;
    }
    return self;
}

- (CLLocationCoordinate2D)next {
    ++_target;
    if (_target == _path.count) {
        _target = 0;
        CLLocationCoordinate2D coor;
        coor.latitude = -1;
        coor.longitude = -1;
        return coor;
    }
    return [_path coordinateAtIndex:_target];
}

@end
