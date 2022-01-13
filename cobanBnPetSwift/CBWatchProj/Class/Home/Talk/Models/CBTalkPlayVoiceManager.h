//
//  CBTalkPlayVoiceManager.h
//  Watch
//
//  Created by coban on 2019/9/6.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBTalkModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 使用单例
#define kPlayTalkVoiceManager [CBTalkPlayVoiceManager sharedInstance]

@interface CBTalkPlayVoiceManager : NSObject

@property (nonatomic,assign) BOOL isEnd;

@property (nonatomic,copy) void(^playTalkVoiceEndBlock)(id objc);

+ (instancetype)sharedInstance;

/** 播放语音  */
- (void)playVoiceUrl:(CBTalkModel *)talkModel;

@end

NS_ASSUME_NONNULL_END
