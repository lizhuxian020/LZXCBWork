//
//  VoiceModel.h
//  Telematics
//
//  Created by lym on 2017/12/22.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceModel : NSObject
@property (nonatomic, copy) NSString *dno;
@property (nonatomic, assign) int flag; // 保存标志；0-实时上传，1-保存
@property (nonatomic, assign) int sample; // 音频采样;0-8K,1-11K,2-23K，3-32K
@property (nonatomic, assign) int time; // 录音时长
@end
