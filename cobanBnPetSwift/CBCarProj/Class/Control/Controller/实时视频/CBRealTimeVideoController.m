//
//  CBRealTimeVideoController.m
//  cobanBnPetSwift
//
//  Created by zzer on 2023/4/11.
//  Copyright © 2023 coban. All rights reserved.
//

#import "CBRealTimeVideoController.h"
#import "CBVideoControlView.h"

@interface CBRealTimeVideoController ()

@property (nonatomic, strong) UIView *videoContainer;

@property (nonatomic, strong) CBVideoControlView *controlView;

@property(atomic, retain) id<IJKMediaPlayback> player;

@property (nonatomic, copy) NSString *urlStr;

@property (nonatomic, strong) NSTimer *heartbeatTimer;
@end

@implementation CBRealTimeVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _urlStr = [NSString stringWithFormat:@"rtmp://mqtt.baanool.com:1935/%@/%@", _dno, _channelId];
    [self createUI];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(moviePlayBackDidFinish:) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(isFinishPreparedToPlay:) name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:nil];
    
}

- (void)isFinishPreparedToPlay:(NSNotification *)notification {
    NSLog(@"--lzx%s", __FUNCTION__);
    [self startHeartBeat];
}

- (void)startHeartBeat {
    [self endHeartBeat];
    
    _heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(heartbeat) userInfo:nil repeats:YES];
    
}

- (void)endHeartBeat {
    if (_heartbeatTimer) {
        [_heartbeatTimer invalidate];
        _heartbeatTimer = nil;
    }
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification {
    int reason = [[notification.userInfo valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    [self endHeartBeat];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"--lzx: ijk: 正常结束");
            break;
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"--lzx: ijk: 用户结束");
            break;
        case IJKMPMovieFinishReasonPlaybackError: {
            NSLog(@"--lzx: ijk: 错误结束");
            //重新播放时无推流, 或者播放时, 断推流
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removePlay];
                [self addPlay];
            });
            break;
        }
            
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self installMovieNotificationObservers];

    [self.player prepareToPlay];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.player shutdown];
    [self endHeartBeat];
//    [self removeMovieNotificationObservers];
}

- (void)createUI {
    [self initBarWithTitle:Localized(@"实时视频") isBack: YES];
    self.view.backgroundColor = UIColor.darkGrayColor;
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:_urlStr] withOptions:[IJKFFOptions optionsByDefault]];
    
    self.videoContainer = [UIView new];
    [self.view addSubview:self.videoContainer];
    [self.videoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.centerY.equalTo(@0);
        make.height.equalTo(@(SCREEN_WIDTH*9/16));
    }];
    
    [self.videoContainer addSubview:self.player.view];
    
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    self.controlView = [CBVideoControlView new];
    [self.view addSubview:self.controlView];
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.bottom.equalTo(@(-10-TabPaddingBARHEIGHT));
    }];
    kWeakSelf(self);
    self.controlView.didClickCapture = ^{
        [weakself doCapture];
    };
    
    self.controlView.didTop = ^{
        [weakself doControl:@"2"];
    };
    self.controlView.didLeft = ^{
        [weakself doControl:@"3"];
    };
    self.controlView.didRight = ^{
        [weakself doControl:@"4"];
    };
    self.controlView.didBottom = ^{
        [weakself doControl:@"1"];
    };
    
}

- (void)doCapture {
//    [MBProgressHUD showHUDIcon:self.view animated:YES];
//    kWeakSelf(self);
//    [[NetWorkingManager shared] postWithUrl: @"/cameraController/photograph" params: @{
//        @"dno": _dno?:@"",
//        @"channel_id": _channelId ?: @"",
//        @"pz_count": @"1", //拍照张数
//        @"resolve": @"0" //分辨率 0：流畅 1：高清 2超清
//    } succeed:^(id response, BOOL isSucceed) {
//        kStrongSelf(self);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    } failed:^(NSError *error) {
//        kStrongSelf(self);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
    if ([self.player.view conformsToProtocol:@protocol(IJKSDLGLViewProtocol)]) {
        id<IJKSDLGLViewProtocol> p = self.player.view;
        UIImage *img = [p snapshot];
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        [HUD showHUDWithText:Localized(@"截图成功") withDelay:2.0];
    }
    
}

#pragma mark 获取截屏图片
- (UIImage *)captureScreenForView:(UIView *)currentView {
    UIGraphicsBeginImageContextWithOptions(currentView.frame.size, YES, 0.0f);
    [currentView.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (void)removePlay {
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    self.player = nil;
}

- (void)addPlay {
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:_urlStr] withOptions:[IJKFFOptions optionsByDefault]];
    [self.videoContainer addSubview:self.player.view];
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.player prepareToPlay];
}

/*
 摄像头角度调整 1：向下；2：向上； 3：向左；4：向右；
 */
- (void)doControl:(NSString *)angle {
//    [MBProgressHUD showHUDIcon:self.view animated:YES];
//    kWeakSelf(self);
//    [[NetWorkingManager shared] postWithUrl: @"/cameraController/cameraControl" params: @{
//        @"dno": _dno?:@"",
//        @"channel_id": _channelId ?: @"",
//        @"angle": angle ?: @""
//    } succeed:^(id response, BOOL isSucceed) {
//        kStrongSelf(self);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    } failed:^(NSError *error) {
//        kStrongSelf(self);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
}

- (void)heartbeat {
    NSLog(@"--lzx%s", __FUNCTION__);
    [[NetWorkingManager shared] getWithUrl:@"userController/liveVideoHeartbeat" params:@{
        @"dno": _dno ?: @""
    } succeed:^(id response, BOOL isSucceed) {
        
    } failed:^(NSError *error) {
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
