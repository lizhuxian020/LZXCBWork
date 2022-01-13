//
//  DownloadVideoViewController.m
//  Telematics
//
//  Created by lym on 2017/11/24.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "DownloadVideoViewController.h"
#import "VideoTableViewCell.h"
//#import "ZFPlayer.h"
#import "MINFileObject.h"

@interface DownloadVideoViewController () <UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic, strong) ZFPlayerView *playerView;
//@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, copy) NSArray *dataArr;
@end

@implementation DownloadVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self loadData];
}

- (void)loadData
{
//    NSString *picPath = [[MINFileManager sharedInstance] getVideoFolderPath];
//    self.dataArr = [[MINFileManager sharedInstance] getFilesWithPath: picPath];
//    [self.tableView reloadData];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"已下载视频") isBack: YES];
    [self showBackGround];
    [self createTableView];
}

- (void)createTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"VideoTableViewIndentify";
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
    if (cell == nil) {
        cell = [[VideoTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIndentify];
    }
    MINFileObject *obj = self.dataArr[indexPath.row];
    cell.videoDuration.text = [NSString stringWithFormat: @"视频时长：%@", obj.fileTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd hh:mm:ss"];
    NSString * language = [[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"];
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier: language];
    [formatter setLocale:locale];
    NSString * dateString = [formatter stringFromDate: obj.fileCreateTime];
    cell.timeLabel.text = dateString;
    __block NSIndexPath *weakIndexPath = indexPath;
    __block VideoTableViewCell *weakCell = cell;
    __weak typeof(self)  weakSelf = self;
    // 点击播放的回调
    cell.playBlock = ^(UIButton *btn){
        
        NSURL *videoUrl = [NSURL fileURLWithPath: obj.filePath];
        
//        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
//        playerModel.title            = @"";
//        playerModel.videoURL         = videoUrl;
////        playerModel.placeholderImageURLString = model.coverForFeed;
//        playerModel.scrollView       = weakSelf.tableView;
//        playerModel.indexPath        = weakIndexPath;
//        // player的父视图tag
//        playerModel.fatherViewTag    = weakCell.picView.tag;
//        // 设置播放控制层和model
//        [weakSelf.playerView playerControlView: nil playerModel:playerModel];
////        // 下载功能
////        weakSelf.playerView.hasDownload = YES;
//        // 自动播放
//        [weakSelf.playerView autoPlayTheVideo];
       
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 252.5 * KFitHeightRate;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 1)];
}

#pragma mark - setter & getter
//- (ZFPlayerView *)playerView {
//    if (!_playerView) {
//        _playerView = [ZFPlayerView sharedPlayerView];
//        //        _playerView.delegate = self;
//        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
////        _playerView.cellPlayerOnCenter = NO;
////        _playerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT - 50 * KFitWidthRate, 200 * KFitHeightRate);
//        // 当cell划出屏幕的时候停止播放
//        // _playerView.stopPlayWhileCellNotVisable = YES;
//        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
//        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
//        // 静音
//        // _playerView.mute = YES;
//        // 移除屏幕移除player
//        // _playerView.stopPlayWhileCellNotVisable = YES;
//    }
//    return _playerView;
//}
//
//- (ZFPlayerControlView *)controlView {
//    if (!_controlView) {
//        _controlView = [[ZFPlayerControlView alloc] init];
//    }
//    return _controlView;
//}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
