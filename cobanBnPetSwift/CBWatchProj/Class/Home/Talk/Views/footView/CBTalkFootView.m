//
//  CBTalkFootView.m
//  Watch
//
//  Created by coban on 2019/8/26.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBTalkFootView.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioConverter.h"
#import "lame.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

#define kViewController_Audio_data @"kViewController_Audio_data"  //@"recordTest.caf"

@interface CBTalkFootView ()<UIGestureRecognizerDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    NSURL *recordedFile;
    NSInteger myTime;
}
/** 按住btn */
@property (nonatomic, strong) UIButton *holdBtn;
@property (nonatomic,assign) BOOL isEnd;
@property (nonatomic,strong) NSTimer *myTimer;

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, copy) NSString *audioTemporarySavePath;
@property (nonatomic, copy) NSString *lastRecordFilePath;
@end

@implementation CBTalkFootView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.audioTemporarySavePath = [NSString stringWithFormat:@"%@/tmp/temporaryRecord.wav", NSHomeDirectory()];
    }
    return self;
}
- (void)setupView {
    [self holdBtn];
}
#pragma mark -- setting && getting
- (UIButton *)holdBtn {
    if (!_holdBtn) {
        
        UIView *line = [UIView new];
        [self addSubview:line];
        line.backgroundColor = KWtRGB(210, 210, 210);
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        _holdBtn = [UIButton new];
        [_holdBtn setTitle:Localized(@"按住说话") forState:UIControlStateNormal];
        [_holdBtn setTitleColor:KWtCellTextColor forState:UIControlStateNormal];
        _holdBtn.layer.masksToBounds = YES;
        _holdBtn.layer.borderWidth = 1.0;
        _holdBtn.layer.cornerRadius = 20*frameSizeRate;
        _holdBtn.layer.borderColor = KWtRGB(210, 210, 210).CGColor;
        [self addSubview:_holdBtn];
        [_holdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 60*frameSizeRate, 40*frameSizeRate));
        }];
        
        //增加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 0.0;
        [_holdBtn addGestureRecognizer:longPress];
    }
    return _holdBtn;
}

- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    // 无录音权限，retrun
    if (![CBWtCommonTools checkMicrophonePermission]) {
        return;
    }
    CGPoint point = [gestureRecognizer locationInView:_holdBtn];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //NSLog(@"长按中开始");
        self.isEnd = NO;
        [self updateBtnTitle:Localized(@"松开结束") bgmColor:[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:0.8]];
        [self responseState:UIGestureRecognizerStateBegan];
        [self recordingClick];
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //NSLog(@"长按结束");
        [self updateBtnTitle:Localized(@"按住说话") bgmColor:[UIColor whiteColor]];
        if (myTime < 1) {
            [self responseState:UIGestureRecognizerStateEnded];
            // 录音时间过短 删除录音
            [self.audioRecorder stop];
            [self.audioRecorder deleteRecording];
            
        } else {
            [self responseState:UIGestureRecognizerStateEnded];
            // 结束录音
            [self.audioRecorder stop];
        }
    } else if(gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        //NSLog(@"长按中");
        //if ([_holdBtn.layer containsPoint:point]) {
        if (point.y > -10) {
            if (self.isEnd == NO) {
                [self updateBtnTitle:Localized(@"松开结束") bgmColor:[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:0.8]];
                [self responseState:UIGestureRecognizerStateChanged];
            }
        } else {
            // 上滑取消
            if (self.isEnd == NO) {
                self.isEnd = YES;
                // 完成、删除录音
                [self.audioRecorder stop];
                [self.audioRecorder deleteRecording];
                [self responseState:UIGestureRecognizerStateEnded];
                [HUD showHUDWithText: Localized(@"已取消")];
            } else {
                [self updateBtnTitle:Localized(@"按住说话") bgmColor:[UIColor whiteColor]];
                [self responseState:UIGestureRecognizerStateEnded];
            }
            self.lastRecordFilePath = nil;
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        //NSLog(@"失败");
        [self responseState:UIGestureRecognizerStateFailed];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        //NSLog(@"取消");
        [self responseState:UIGestureRecognizerStateCancelled];
    }
}
- (void)responseState:(UIGestureRecognizerState)state {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordingActionResponseEvent:)]) {
        [self.delegate recordingActionResponseEvent:state];
    }
}
- (void)updateBtnTitle:(NSString *)title bgmColor:(UIColor *)bgmColor {
    [_holdBtn setTitle:title forState:UIControlStateNormal];
    _holdBtn.backgroundColor = bgmColor;
}
- (void)timerMove {
    myTime ++;//NSLog(@"time : %ld",(long)myTime);
    if (myTime == 0) {//停止录音
        [_myTimer invalidate];
        _myTimer = nil;
        
    }
    [self setTotalTime:myTime];
}
- (void)resetMyTimerAction {
    [self.myTimer invalidate];
    self.myTimer = nil;
    myTime = 0;
    [self setTotalTime:myTime];
}
#pragma mark -- 录音
- (void)recordingClick {
    //停止当前的播放
    [self.audioPlayer stop];
    self.audioPlayer = nil;
/**为了不覆盖上次的录制内容，我们需要生成新的url，并传入AVAudioRecorder的对象中，由于这个参数只能在初始化AVAudioRecorder的对象的时候设置，所以每次需要创建一个新的音频录制对象。
*/
    //释放之前的对象
    [self.audioRecorder stop];
    self.audioRecorder = nil;
    
    //创建新的录制对象
    NSString *filePath = [self creatFilePath];
    //这里为了验证录制成功，并播放上一次的录制，我们记录一下这次的文件地址
    self.lastRecordFilePath = filePath;
    
#if TARGET_IPHONE_SIMULATOR
    NSURL *url = [NSURL fileURLWithPath:self.audioTemporarySavePath];
#elif TARGET_OS_IPHONE
    NSURL *url = [NSURL URLWithString:self.audioTemporarySavePath];
#endif
    NSError *outError = nil;
    NSDictionary *seetings = [self getAudioSetting];
    AVAudioRecorder *recorder = [[AVAudioRecorder alloc] initWithURL:url settings:seetings error:&outError];
    recorder.meteringEnabled = YES;
    //音频对象创建无误
    if (!outError) {
        //保存当前的音频录制对象
        self.audioRecorder = recorder;
        self.audioRecorder.delegate = self;
        //开启设备录音模式
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
        
        //开始录制
        if ([self.audioRecorder prepareToRecord]) {
            self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerMove) userInfo:nil repeats:YES];
            [self.audioRecorder record];
        }
    }
}
#pragma mark -- 创建文件路径
//创建文件路径
- (NSString *)creatFilePath {
    //为了不覆盖上次的录制内容，每次生成一个新的时间戳，作为新文件名
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%f.amr",timeStamp];//[NSString stringWithFormat:@"%f.aac",timeStamp];
    NSString *newFilePath = [[self audioDocmentPath] stringByAppendingPathComponent:timeStr];
    if (![[NSFileManager defaultManager] fileExistsAtPath:newFilePath]) {
        if ([[NSFileManager defaultManager] createFileAtPath:newFilePath contents:nil attributes:nil]) {
            NSLog(@"文件地址创建成功!");
        } else {
            NSLog(@"文件地址创建失败!");
        }
    }
    return newFilePath;
}
//获取存储音频数据的文件夹，如果是第一次，则直接创建
- (NSString *)audioDocmentPath {
    NSString *homePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *docPath = [homePath stringByAppendingPathComponent:kViewController_Audio_data];
    if ([[NSFileManager defaultManager] fileExistsAtPath:docPath]) {
        NSLog(@"文件夹已经存在,不需要创建");
    } else {
        NSError *error = nil;
        if ([[NSFileManager defaultManager] createDirectoryAtPath:docPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error]) {
            NSLog(@"创建文件夹成功");
        } else {
            NSLog(@"创建文件夹失败：%@",error);
        }
    }
    return docPath;
}
//取得录音文件设置
- (NSMutableDictionary *)getAudioSetting {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //设置录音格式
    //AVAudioFileTypeKey kAudioFormatLinearPCM
    [dict setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];//kAudioFormatMPEG4AAC  kAudioFormatMPEG4AAC_HE
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dict setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dict setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32  @(16)
    //[dict setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    // 质量
    [dict setObject:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    //是否使用浮点数采样 wav格式时 不设置这个
    //[dict setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dict;
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"结束录制，存储地址是%@", self.lastRecordFilePath);
    [self audioConvert];
    if (myTime >= 1 && self.lastRecordFilePath) {
        if (self.recordingDoneBlock) {
            self.recordingDoneBlock(self.lastRecordFilePath);
        }
    }
    if (self.lastRecordFilePath == nil) {
        //@"已取消"
    } else if (myTime < 1) {
        [HUD showHUDWithText: Localized(@"录音时间过短")];
    }
    // 重置录音弹窗时间,重置定时器
    [self resetMyTimerAction];
    
    //播放完成后，验证一下播放
    //[self playLastAudio];
}
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
    NSLog(@"出现了错误 = %@", error);
}
#pragma mark -- 播放录音
- (void)playLastAudio {
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    self.audioPlayer.delegate = nil;
    
    NSError *outError = nil;
    NSData *data = [NSData dataWithContentsOfFile:self.lastRecordFilePath];
    NSData *wavData = [AudioConverter getWAVEDataFrom:data];

    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:wavData error:&outError];
    self.audioPlayer.delegate = self;
    if (outError) {
        NSLog(@"音频播放器创建失败：%@",outError);
    } else {
        if ([self.audioPlayer prepareToPlay]) {
            [self.audioPlayer play];
        }
    }
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [player stop];
    self.audioPlayer = nil;
    NSLog(@"播放成功！");
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    [player stop];
}
- (void)setTotalTime:(CGFloat)totalTime {
    //_totalTime = totalTime;
    NSInteger ms = totalTime;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    if (totalTime <= 0) {
        totalTime = 0;
    }
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger hourMax = 0;
    if (day >= 1) {
        hourMax = 24 + hour;//时(超过24小时，不算天)
    } else {
        hourMax = hour;
    }
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    
    NSString *time = [NSString stringWithFormat:@"%02ld:%02ld", (long)minute, (long)second];
    
    NSLog(@"----------录音时间:------%@",time);
    if (self.returnBlock) {
        self.returnBlock(time);
    }
}
#pragma mark -- wav ---> amr
- (void)audioConvert {
    NSString *audioFileSavePath = self.lastRecordFilePath;
    int result = [AudioConverter wavToAmr:self.audioTemporarySavePath amrSavePath:audioFileSavePath];
    if (result == 1) {
        NSLog(@"==========wav转amr格式音频文件成功");
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
