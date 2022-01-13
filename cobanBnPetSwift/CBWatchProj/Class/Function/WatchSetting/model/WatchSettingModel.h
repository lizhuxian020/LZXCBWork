//
//  WatchSettingModel.h
//  Watch
//
//  Created by lym on 2018/4/12.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WatchSettingModel : NSObject
@property (nonatomic, copy) NSString *screenTime; // 亮屏时间
@property (nonatomic, assign) BOOL callBellAction; // 来电铃声开关
@property (nonatomic, assign) BOOL callLibrateAction; // 来电振动开关
@property (nonatomic, assign) BOOL msgBellAction; // 信息铃声开关
@property (nonatomic, assign) BOOL msgLibrateAction; // 信息振动开关
@end


@interface WatchSettingScreenTimeModel : NSObject
@property (nonatomic, copy) NSString *screenTime; // 亮屏时间
@property (nonatomic, assign) BOOL isSelect;      // 是否选择
@end
