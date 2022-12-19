//
//  MINNormalAnnotation.h
//  Telematics
//
//  Created by lym on 2017/12/7.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface MINNormalAnnotation : BMKPointAnnotation
@property (nonatomic,strong) UIImage *icon;
@property (nonatomic,copy) NSString *warmed;
@property (nonatomic,assign) BOOL isSelect;
@property(nonatomic, copy) NSString *dno;
@end
