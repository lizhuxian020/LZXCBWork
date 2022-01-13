//
//  MINNormalInfoAnnotation.h
//  Telematics
//
//  Created by lym on 2017/12/8.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface MINNormalInfoAnnotation : BMKPointAnnotation
@property (nonatomic,copy) NSString *deviceName;
@property (nonatomic,copy) NSString *speed;
@property (nonatomic,copy) NSString *warmed;
@property (nonatomic,assign) BOOL isSelect;
@end
