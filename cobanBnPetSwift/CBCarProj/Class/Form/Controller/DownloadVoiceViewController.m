//
//  DownloadVoiceViewController.m
//  Telematics
//
//  Created by lym on 2017/11/20.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "DownloadVoiceViewController.h"
#import "VoiceTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "MINFileObject.h"

@interface DownloadVoiceViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;
@property (nonatomic, strong) id timeObserve;
@property (nonatomic, copy) NSArray *dataArr;
@end

@implementation DownloadVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self loadData];
}

- (void)loadData
{
//    NSString *picPath = [[MINFileManager sharedInstance] getVoiceFolderPath];
//    self.dataArr = [[MINFileManager sharedInstance] getFilesWithPath: picPath];
//    [self.tableView reloadData];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"已下载音频") isBack: YES];
    [self showBackGround];
    [self createTableView];
}

- (void)createTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - tableView dataSource & delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"VoiceCellIndentify";
    VoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
    if (cell == nil) {
        cell = [[VoiceTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIndentify];
    }
    if (self.lastSelectedIndexPath != nil && self.lastSelectedIndexPath.row == indexPath.row) {
        cell.startBtn.selected = YES;
    }else {
        cell.startBtn.selected = NO;
        cell.slider.value = 0.0;
    }
    MINFileObject *fileObj = self.dataArr[indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd hh:mm:ss"];
    NSString * language = [[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"];
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier: language];
    [formatter setLocale:locale];
    NSString * dateString = [formatter stringFromDate: fileObj.fileCreateTime];
    cell.createTimeLabel.text = dateString;
    cell.durationLabel.text = [NSString stringWithFormat:@"音频时长: %@", fileObj.fileTime];
    cell.indexPath = indexPath;
    __weak typeof (self) weakself = self;
    cell.startBtnClickBlock = ^(NSIndexPath *indexPath) {
        [weakself startBtnClickWith: indexPath];
    };
    cell.slideValueChangedBlock = ^(NSIndexPath *indexPath, float value) {
        [weakself slideValueChangedWith: indexPath value: value];
    };
    return cell;
}

- (void)slideValueChangedWith:(NSIndexPath *)indexPath value:(float)value
{
    if (self.lastSelectedIndexPath.row == indexPath.row && self.lastSelectedIndexPath != nil) {
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            [self.player seekToTime: CMTimeMake(CMTimeGetSeconds(self.player.currentItem.duration) * value, 1)];
        }
    }
}

- (void)startBtnClickWith:(NSIndexPath *)indexPath
{
    if (self.player == nil) {
        self.player = [[AVPlayer alloc] init];
    }
    if (self.lastSelectedIndexPath.row == indexPath.row && self.lastSelectedIndexPath != nil) {
        VoiceTableViewCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
        if (cell != nil) {
            if (cell.startBtn.selected == YES) {
                cell.startBtn.selected = NO;
                [self.player pause];
            }else {
                cell.startBtn.selected = YES;
                [self.player play];
            }
            self.lastSelectedIndexPath = indexPath;
        }
        
    }else {
        NSString *audioPath = nil;
        MINFileObject *fileObj = self.dataArr[indexPath.row];
        audioPath = fileObj.filePath;
        NSURL *url = [NSURL fileURLWithPath: audioPath];
        AVPlayerItem *songItem = [[AVPlayerItem alloc] initWithURL: url];
        [self.player replaceCurrentItemWithPlayerItem: songItem];
        [self.player play];
        VoiceTableViewCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
        if (self.lastSelectedIndexPath == nil) {
            self.lastSelectedIndexPath = indexPath;
            if (cell != nil) {
                cell.startBtn.selected = YES;
            }
        }else {
            VoiceTableViewCell *lastCell = [self.tableView cellForRowAtIndexPath: self.lastSelectedIndexPath];
            if (self.timeObserve != nil) {
                [self.player removeTimeObserver: self.timeObserve];
                self.timeObserve = nil;
            }
            if (lastCell != nil) {
                lastCell.startBtn.selected = NO;
            }
            cell.startBtn.selected = YES;
            self.lastSelectedIndexPath = indexPath;
        };
        __weak typeof (VoiceTableViewCell *) weakCell = cell;
        __weak typeof (self) weakself = self;
        self.timeObserve = [self.player addPeriodicTimeObserverForInterval: CMTimeMake(1.0, 1.0) queue: dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float current = CMTimeGetSeconds(time);
            float total = CMTimeGetSeconds(songItem.duration);
            if (current) {
                weakCell.slider.value = current / total;
            }
            int currentTime = (int)current;
            int totalTime = (int)total;
            if (currentTime == totalTime) {
                weakCell.slider.value = 0;
                weakCell.startBtn.selected = NO;
                NSString *audioPath = nil;
                MINFileObject *fileObj = weakself.dataArr[indexPath.row];
                audioPath = fileObj.filePath;
                NSURL *url = [NSURL fileURLWithPath: audioPath];
                AVPlayerItem *songItem = [[AVPlayerItem alloc] initWithURL: url];
                [weakself.player replaceCurrentItemWithPlayerItem: songItem];
                [weakself.player pause];
            }
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102.5 * KFitHeightRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
