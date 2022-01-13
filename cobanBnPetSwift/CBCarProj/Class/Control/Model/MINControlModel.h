//
//  MINControlModel.h
//  Telematics
//
//  Created by lym on 2017/12/14.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface MINControlModel : NSObject <YYModel>
@property (nonatomic, assign) int backTel; // 电话回拨
@property (nonatomic, assign) int cfbf; // 撤防布防
@property (nonatomic, assign) long createTime;
@property (nonatomic, assign) int dydd;
@property (nonatomic, assign) int fence;
@property (nonatomic, copy) NSString *controlID;
@property (nonatomic, assign) int localize;
@property (nonatomic, assign) int luggage;
@property (nonatomic, assign) int morePhoto;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int obd;
@property (nonatomic, assign) int online;
@property (nonatomic, copy) NSString *proto;
@property (nonatomic, assign) int rest;
@property (nonatomic, assign) int sendMsg;
@property (nonatomic, assign) int setParam;
@property (nonatomic, assign) int takePhoto;
@property (nonatomic, assign) int track;
@property (nonatomic, assign) int voice;
@property (nonatomic, assign) int warmDiaodian;
@property (nonatomic, assign) int warmDidian;
@property (nonatomic, assign) int warmSpeed;
@property (nonatomic, assign) int warmYiwei;
@property (nonatomic, assign) int warmZhendong;
@property (nonatomic, assign) int yuntai;
- (NSArray *)getStateArr;
@end
