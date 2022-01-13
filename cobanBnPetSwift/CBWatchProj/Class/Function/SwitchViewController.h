//
//  SwitchViewController.h
//  Watch
//
//  Created by lym on 2018/2/8.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "CBWtBaseViewController.h"

typedef NS_ENUM(NSInteger, SwitchViewType){
    SwitchViewTypeWear,                 // 佩戴检测
    SwitchViewTypeCommunicatePostion,   // 通话位置
    SwitchViewTypeResercationPower,     // 预留电量
    SwitchViewTypeStep,                 // 计步
    SwitchViewTypeCalling,              // 拒绝陌生人来电
    SwitchViewTypeSomatosensory,        // 体感接听
    SwitchViewTypeWatchReportLoss       // 手表挂失
};

@class FuctionSwitchModel;
@interface SwitchViewController : CBWtBaseViewController
@property (nonatomic, assign) SwitchViewType switchType;
@property (nonatomic, weak) FuctionSwitchModel *model;
@end
