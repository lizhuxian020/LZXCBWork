//
//  LineSingleChartModel.h
//  Telematics
//
//  Created by lym on 2018/3/22.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineSingleChartModel : NSObject
//@property (nonatomic, copy) NSString *create_time;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic, copy) NSString *dno;
@property (nonatomic, assign) float speed;
@property (nonatomic, assign) float use_oil;
@property (nonatomic, assign) float mileage;

@end
