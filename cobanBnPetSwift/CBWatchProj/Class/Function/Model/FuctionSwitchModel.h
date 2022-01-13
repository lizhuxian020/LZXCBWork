//
//  FuctionSwitchModel.h
//  Watch
//
//  Created by lym on 2018/4/3.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FuctionSwitchModel : NSObject
@property (nonatomic, assign) BOOL autoConnect;     //自动接通开关：0-关闭，1-打开
@property (nonatomic, assign) BOOL bodyFeel;        //体感开关，0-关闭，1-打开
@property (nonatomic, assign) BOOL callPosiAction;  //通话位置开关：0-关闭，1-打开
@property (nonatomic, copy) NSString *closeTime;    //定时关机时间
@property (nonatomic, assign) BOOL elecAction;      //预留电量开关：0-关闭，1-打开
@property (nonatomic, copy) NSString *openTime;     //定时开机时间
@property (nonatomic, assign) BOOL receiveMsg;      // 代收短信
@property (nonatomic, assign) BOOL shutdownAction;  //定时关机开关：0-关闭，1-打开
@property (nonatomic, assign) BOOL stepAction;      //记步开关：0-关闭，1-打开
@property (nonatomic, assign) BOOL voiceAction1;    //语音识别:0-关闭，1-打开
@property (nonatomic, assign) BOOL voiceAction2;    //语音播报：0-关闭，1-打开
@property (nonatomic, assign) BOOL wearAction;      //佩戴开关，0-关闭，1-打开
@property (nonatomic, assign) BOOL callBellAction;  //来电铃声开关:0-关闭，1-打开
@property (nonatomic, assign) BOOL callLibrateAction;  //来电振动开关：0-关闭，1-打开
@property (nonatomic, assign) BOOL msgBellAction;  //信息振动开关：0-关闭，1-打开
@property (nonatomic, assign) BOOL msgLibrateAction;  //来电振动开关：0-关闭，1-打开
@property (nonatomic, assign) BOOL refuseStrangers;  //拒绝陌生人，1-拒绝
@property (nonatomic, assign) BOOL reportingLoss;  //是否报失，1-报失
@property (nonatomic, assign) BOOL switchFlag;      //24小时制开关：0-关闭，1-打开
@property (nonatomic, copy) NSString *screenTime;  //亮屏时间，单位（秒）
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *sno;
@end
