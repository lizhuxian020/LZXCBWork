//
//  GuardIndoModel.h
//  Watch
//
//  Created by lym on 2018/4/2.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuardIndoModel : NSObject
@property (nonatomic, assign) BOOL action;
@property (nonatomic, copy) NSString *backTime;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *homeAddress;
@property (nonatomic, assign) double homeLat;
@property (nonatomic, assign) double homeLng;
@property (nonatomic, assign) double homeRange; // 范围，围栏范围
@property (nonatomic, copy) NSString *guardId;
@property (nonatomic, copy) NSString *inAm;
@property (nonatomic, copy) NSString *inPm;
@property (nonatomic, copy) NSString *outAm;
@property (nonatomic, copy) NSString *outPm;
@property (nonatomic, copy) NSString *repeat;
@property (nonatomic, copy) NSString *schoolAddress;
@property (nonatomic, assign) double schoolLat;
@property (nonatomic, assign) double schoolLng;
@property (nonatomic, assign) double schoolRange; // 范围，围栏范围
@property (nonatomic, copy) NSString *sno;
@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString *wifi;
@property (nonatomic, copy) NSString *wifiPwd;

@property (nonatomic, copy) NSString *schoolData;
@property (nonatomic, copy) NSString *homeData;
@property (nonatomic, assign) double centerlLat; // 多边形中心
@property (nonatomic, assign) double centerLng;  // 多边形中心
@property (nonatomic, assign) double schoolCenterlLat; // 学校多边形中心
@property (nonatomic, assign) double schoolCenterLng;  // 学校多边形中心
@property (nonatomic, assign) double homeCenterlLat; // 家庭多边形中心
@property (nonatomic, assign) double homeCenterLng;  // 家庭多边形中心
@end
