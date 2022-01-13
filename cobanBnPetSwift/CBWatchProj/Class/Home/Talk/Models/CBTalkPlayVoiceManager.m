//
//  CBTalkPlayVoiceManager.m
//  Watch
//
//  Created by coban on 2019/9/6.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBTalkPlayVoiceManager.h"
#import <AVFoundation/AVFoundation.h>
#import <FSAudioStream.h>
#import "AudioConverter.h"

@interface CBTalkPlayVoiceManager ()<AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,strong) FSAudioStream *audioStream;
@property (nonatomic,strong) CBTalkModel *talkModel;
@end
@implementation CBTalkPlayVoiceManager

+ (instancetype)sharedInstance {
    static id obj = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        obj = [[self alloc] init];
    });
    return  obj;
}
- (FSAudioStream *)audioStream {
    if (!_audioStream) {
        _audioStream = [[FSAudioStream alloc]init];
        // 不进行检测格式 <开启检测之后，有些网络音频链接无法播放>
        _audioStream.strictContentTypeChecking = NO;
        _audioStream.defaultContentType = @"audio/mpeg";
    }
    return _audioStream;
}
- (void)playFailed {
    // 不可以播放
    self.isEnd = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_stop",self.talkModel.create_time] object:nil];
    [CBWtMINUtils showProgressHudToView:[UIApplication sharedApplication].keyWindow withText:Localized(@"播放失败")];
}
- (void)playEnd {
    //播放百分比为1表示已经播放完毕
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_stop",self.talkModel.create_time] object:nil];
    self.isEnd = YES;
    if (self.playTalkVoiceEndBlock) {
        self.playTalkVoiceEndBlock(self.talkModel);
    }
}
/** 播放语音  */
- (void)playVoiceUrl:(CBTalkModel *)talkModel {
    _talkModel = talkModel;
    //开启设备播放音频模式
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    NSLog(@"播放的链接-------%@-------",talkModel.voiceUrl);

    kWeakSelf(self);
//    self.audioStream.onFailure = ^(FSAudioStreamError error,NSString *description){
//        NSLog(@"播放过程中发生错误，错误信息：%@",description);
//        kStrongSelf(self);
//        [self playFailed];
//    };
//    self.audioStream.onCompletion = ^(){
//        NSLog(@"播放完成!");
//        kStrongSelf(self);
//        [self playEnd];
//    };
//    [self.audioStream setVolume:1.0];//设置声音
    
    
//    if ([talkModel.voiceUrl containsString:@".aac"]) {
//        // 可以播放
//        [self.audioStream playFromURL:[NSURL URLWithString:talkModel.voiceUrl]];
//        self.isEnd = NO;
//        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_begin",talkModel.create_time] object:nil];
//    } else {
//        // 不可以播放
//        self.isEnd = YES;
//        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_stop",talkModel.create_time] object:nil];
//        [CBWtMINUtils showProgressHudToView:[UIApplication sharedApplication].keyWindow withText:Localized(@"语音格式不正确")];
//    }
    
    [[CBWtNetworkRequestManager sharedInstance] downloadChatAudioWithUrl:talkModel.voiceUrl success:^(NSString * _Nonnull filePath) {
        kStrongSelf(self);
        // wav ,aac,(amr不能)
        NSData *wavAndAnyData = [NSData dataWithContentsOfFile:filePath];
        
        [self.audioPlayer stop];
        self.audioPlayer = nil;
        self.audioPlayer.delegate = nil;
        
        NSError * error = nil;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:wavAndAnyData error:&error];
        self.audioPlayer.delegate = self;
        BOOL isPlay = [self.audioPlayer prepareToPlay];
        if (isPlay) {
            [self.audioPlayer play];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_begin",talkModel.create_time] object:nil];
    } failure:^{
        [CBWtMINUtils showProgressHudToView:[UIApplication sharedApplication].keyWindow withText:Localized(@"播放失败")];
    }];
    
//    //开启设备播放音频模式
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [audioSession setActive:YES error:nil];
//
//    NSLog(@"播放的链接-------%@-------",talkModel.voiceUrl);
//    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:talkModel.voiceUrl]];
//    self.player = [[AVPlayer alloc]initWithPlayerItem:item];
//    //[self.player play];
//    //self.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:talkModel.voiceUrl]];
//    //播放监听，可以监听到播放完毕，每秒处发一次,从播放后的第一秒触发，不是一播放就出发
//    kWeakSelf(self);
//    [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.2, NSEC_PER_SEC) queue:NULL usingBlock:^(CMTime time) {
//        kStrongSelf(self);
//        //进度 当前时间/总时间
//        CGFloat progress = CMTimeGetSeconds(self.player.currentItem.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
//        NSLog(@"播放进度-------%.6f-------",progress);
//        NSLog(@"播放总时长-------%.6f-------",CMTimeGetSeconds(self.player.currentItem.duration));
//        if (progress >= 1) {
//            //播放百分比为1表示已经播放完毕
//            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_stop",talkModel.create_time] object:nil];
//            self.isEnd = YES;
//            if (self.playTalkVoiceEndBlock) {
//                self.playTalkVoiceEndBlock(talkModel);
//            }
//        }
//    }];
//
//    if ([talkModel.voiceUrl containsString:@".aac"]) {
//        // 可以播放
//        [self.player play];
//        self.isEnd = NO;
//        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_begin",talkModel.create_time] object:nil];
//    } else {
//        // 不可以播放
//        self.isEnd = YES;
//        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_stop",talkModel.create_time] object:nil];
//        [CBWtMINUtils showProgressHudToView:[UIApplication sharedApplication].keyWindow withText:@"语音格式不正确"];
//    }
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"播放完了");
    [self playEnd];
    [player stop];
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    NSLog(@"播放错误");
    [self playFailed];
    [player stop];
}
@end
