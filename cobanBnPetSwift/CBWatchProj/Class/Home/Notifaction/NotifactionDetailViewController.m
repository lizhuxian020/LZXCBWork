//
//  NotifactionDetailViewController.m
//  Watch
//
//  Created by lym on 2018/3/7.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "NotifactionDetailViewController.h"
#import "MessageModel.h"

@interface NotifactionDetailViewController ()
{
    UIView *infoView;
}
@end

@implementation NotifactionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    self.titleLabel.text = self.model.title;
    self.timeLabel.text = [CBWtMINUtils getTimeFromTimestamp: self.model.createTime formatter: @"yyyy-MM-dd HH:mm:ss"];
    self.detailLabel.text = self.model.content;
}

#pragma mark - 删除信息
- (void)rightBtnClick
{
    __weak __typeof__(self) weakSelf = self;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"ids"] = self.model.messageId;
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/persion/delMyMessage" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [weakSelf.navigationController popViewControllerAnimated: YES];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"信息详情") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"删除") target: self action: @selector(rightBtnClick)];
    [self createInfoView];
}

-(void)createInfoView
{
    infoView = [[UIView alloc] init];
    infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_topMargin);
        }
    }];
    self.titleLabel = [CBWtMINUtils createLabelWithText: @"小璐璐" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
    [infoView addSubview: self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(infoView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(infoView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(20 * KFitWidthRate);
    }];
    self.timeLabel = [CBWtMINUtils createLabelWithText: @"2017-12-12 12:12" size: 12 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(137, 137, 137)];
    [infoView addSubview: self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(infoView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(20 * KFitWidthRate);
    }];
    UIView *lineView = [CBWtMINUtils createLineView];
    [infoView addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(infoView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(0.5);
    }];
    self.detailLabel = [CBWtMINUtils createLabelWithText: @"2017-12-12 12:12 2017-12-12 12:122017-12-12 12:122017-12-12 12:122017-12-12 12:122017-12-12 12:122017-12-12 12:122017-12-12 12:122017-12-12 12:122017-12-12 12:122017-12-12 12:122017-12-12 12:122017-12-12 12:122017-12-12 12:122017-12-12 12:122017-12-12 12:122017-12-12 12:122017-12-12 12:122017-12-12 12:122017-12-12 12:12" size: 12 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(137, 137, 137)];
    [self.detailLabel setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisVertical];
    self.detailLabel.numberOfLines = 0;
    [infoView addSubview: self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(lineView.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(infoView).with.offset(-12.5 * KFitWidthRate);
        make.bottom.equalTo(infoView).with.offset(-30 * KFitWidthRate);
    }];
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
