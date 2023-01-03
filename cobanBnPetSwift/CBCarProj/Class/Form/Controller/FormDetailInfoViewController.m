//
//  FormDetailInfoViewController.m
//  Telematics
//
//  Created by lym on 2017/12/26.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "FormDetailInfoViewController.h"
#import "FormTableViewCell.h"
#import "downloadTaskObject.h"

@interface FormDetailInfoViewController () <UITableViewDelegate, UITableViewDataSource, DownLoadDelegate>
@property (nonatomic, strong) UIButton *downloadBtn;
@end

@implementation FormDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

#pragma mark - Action
- (void)downloadBtnClick
{
//    if ([MINNetManager sharedInstance].downTaskArr.count > 0) {
//        [MINUtils showProgressHudToView: self.view withText: @"已有下载任务，请等上一个任务下载完成"];
//        return;
//    }
//    NSLog(@"downloadBtnClick");
//    if (self.type == 0) { // 多媒体类型；0-图像，1-音频，2-视频
//        [[MINNetManager sharedInstance] downPicWithUrl: @"http://ckplayer-video.oss-cn-shanghai.aliyuncs.com/ckplayer-sample/mydream_zh_768-432.mp4"];
//    }else if (self.type == 1) {
//        [[MINNetManager sharedInstance] downVoiceWithUrl:@"http://ckplayer-video.oss-cn-shanghai.aliyuncs.com/ckplayer-sample/mydream_zh_768-432.mp4"];
//    }else {
//        [[MINNetManager sharedInstance] downVideoWithUrl:@"http://ckplayer-video.oss-cn-shanghai.aliyuncs.com/ckplayer-sample/mydream_zh_768-432.mp4"];
//    }
//    downloadTaskObject *obj = [MINNetManager sharedInstance].downTaskArr.firstObject;
//    obj.delegate = self;
//    [obj.downloadTask resume];
//    self.downloadBtn.enabled = NO;
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle: @"查看记录" isBack: YES];
    [self createTableView];
}

- (void)createTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kRGB(236, 236, 236);
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.view);
    }];
}

#pragma tableview delegate & datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"FormTableViewCell";
    static NSString *cellIndentifyLast = @"FormTableViewCellLast";
    static NSString *cellIndentifyFirst = @"FormTableViewCellFirst";
    FormTableViewCell *cell = nil;
    NSInteger numNumOfRow = [tableView numberOfRowsInSection: indexPath.section];
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifyFirst];
        if (cell == nil) {
            cell = [[FormTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: cellIndentifyFirst];
            [cell addBottomLineView];
        }
    }else if (numNumOfRow == indexPath.row + 1) {
        cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifyLast];
        if (cell == nil) {
            cell = [[FormTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: cellIndentifyLast];
        }
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
        if (cell == nil) {
            cell = [[FormTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: cellIndentify];
            [cell addBottomLineView];
        }
    }
    [cell hideRightImage];
    cell.nameLabel.text = self.dataArr[indexPath.row];
    [cell.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@0);
    }];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.isShowDownloadBtn == YES) {
        UIView *view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_HEIGHT, 65 * KFitHeightRate)];
        self.downloadBtn = [MINUtils createBtnWithRadius:5 * KFitHeightRate title: @"下载"];
        [self.downloadBtn addTarget: self action: @selector(downloadBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [view addSubview: self.downloadBtn];
        [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).with.offset(15 * KFitWidthRate);
            make.right.equalTo(view).with.offset(-15 * KFitWidthRate);
            make.height.mas_equalTo(40 * KFitHeightRate);
            make.bottom.equalTo(view).with.offset(-12.5 * KFitHeightRate);
        }];
        return view;
    }
    return [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_HEIGHT, 12.5 * KFitHeightRate)];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.isShowDownloadBtn == YES) {
        return 80 * KFitHeightRate;
    }
    return 12.5 * KFitWidthRate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50 * KFitHeightRate;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.5 * KFitHeightRate;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT,  12.5 * KFitHeightRate)];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    FormTableViewCell *deviceCell = (FormTableViewCell *)cell;
    if (deviceCell.isCreate == NO) {
        CGFloat cornerRadius = 5.f * KFitHeightRate;
        //        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectMake(0, 0, SCREEN_HEIGHT - 12.5 * KFitWidthRate - 12.5 * KFitWidthRate, 50 * KFitHeightRate);
        if (indexPath.row == 0) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds) - 1, CGRectGetMinY(bounds), CGRectGetMaxX(bounds) -1, CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds) -1, CGRectGetMaxY(bounds));
        }else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds) - 1, CGRectGetMaxY(bounds), CGRectGetMaxX(bounds) -1, CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds) -1, CGRectGetMinY(bounds));
        }else { // 中间的view
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds)-1, CGRectGetMinY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds)-1, CGRectGetMaxY(bounds));
        }
        layer.path = pathRef;
        //颜色修改
        layer.fillColor = kCellBackColor.CGColor;
        layer.strokeColor = kCellBackColor.CGColor;
        CFRelease(pathRef);
        [deviceCell.backView.layer insertSublayer: layer atIndex: 0];
        deviceCell.isCreate = YES;
    }
}

#pragma mark - DownLoadDelegate
- (void)downLaodDidCompletedTask:(downloadTaskObject *)task
{
    self.downloadBtn.enabled = YES;
    //[[MINNetManager sharedInstance].downTaskArr removeAllObjects];
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)downLoadTask:(downloadTaskObject *)task WithProgressCompletedUnitCount:(int64_t)completedUnitCount andTotalUnitCount:(int64_t)totalUnitCount
{
    NSString *title = [NSString stringWithFormat: @"已下载 %d%%", (int)(completedUnitCount * 1.0 / totalUnitCount * 100)];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.downloadBtn setTitle: title forState: UIControlStateNormal];
        [self.downloadBtn setTitle: title forState: UIControlStateHighlighted];
        [self.downloadBtn.superview layoutIfNeeded];
    });
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
