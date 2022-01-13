//
//  MultiLocationModel.h
//  Telematics
//
//  Created by lym on 2017/12/18.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultiLocationModel : NSObject <YYModel>
@property (nonatomic, copy) NSString *disQs;
@property (nonatomic, copy) NSString *disRest;
@property (nonatomic, copy) NSString *disSos;
@property (nonatomic, assign) int reportWay;
@property (nonatomic, copy) NSString *timeQs;
@property (nonatomic, copy) NSString *timeRest;
@property (nonatomic, copy) NSString *timeSos;
@property (nonatomic, copy) NSString *dno;
@end
