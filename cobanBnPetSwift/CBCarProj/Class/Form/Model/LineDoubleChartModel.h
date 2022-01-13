//
//  LineDoubleChartModel.h
//  Telematics
//
//  Created by lym on 2017/12/27.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineDoubleChartModel : NSObject <YYModel>
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *lineId;
@property (nonatomic, assign) float mileage;
@property (nonatomic, assign) float speed;
@property (nonatomic, assign) float use_oil;
@end
