//
//  FatigueDirvingModel.h
//  Telematics
//
//  Created by lym on 2017/12/25.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FatigueDirvingModel : NSObject
@property (nonatomic, copy) NSString *differ; // 疲劳驾驶预警差值(秒)
@property (nonatomic, copy) NSString *keepLimit; // 连续驾驶时间上限(秒
@property (nonatomic, copy) NSString *maxRest; // 最大停车时间(秒)
@property (nonatomic, copy) NSString *minRest; // 最小休息时间(秒)
@property (nonatomic, copy) NSString *todayLimit; // 当天累计驾驶时间上限(秒)
@end
