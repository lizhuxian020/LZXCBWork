//
//  HomeWatchInfoView.m
//  Watch
//
//  Created by lym on 2018/2/6.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "HomeWatchInfoView.h"

@interface HomeWatchInfoView()
{
    UIView *mainView;
}
@property (nonatomic, strong) UILabel *lastLocationLabel;
@property (nonatomic, strong) UILabel *todaySportLabel;
@end

@implementation HomeWatchInfoView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = KWtRGB(237, 237, 237);
        [self createMainView];
        [self createLocationPart];
        [self createTodaySportPart];
    }
    return self;
}

- (void)createTodaySportPart
{
    self.todaySportLabel = [CBWtMINUtils createLabelWithText:Localized(@"今日运动") size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
    self.todaySportLabel.numberOfLines = 0;
    [mainView addSubview: self.todaySportLabel];
    [self.todaySportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView).with.offset(12.5 * KFitWidthRate);
        make.bottom.equalTo(mainView);
        make.size.mas_equalTo(CGSizeMake(75 * KFitWidthRate, 50 * KFitWidthRate));
    }];
    self.stepCountLabel = [CBWtMINUtils createLabelWithText: @"10025步" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWt137Color];
    [mainView addSubview: self.stepCountLabel];
    [self.stepCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lastLocationLabel.mas_right).with.offset(5 * KFitWidthRate);
        make.bottom.equalTo(mainView);
        make.size.mas_equalTo(CGSizeMake(175 * KFitWidthRate, 50 * KFitWidthRate));
    }];
}

- (void)createLocationPart
{
    self.lastLocationLabel = [CBWtMINUtils createLabelWithText:Localized(@"最后位置") size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
    self.lastLocationLabel.numberOfLines = 0;
    [mainView addSubview: self.lastLocationLabel];
    [self.lastLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(mainView);
        make.size.mas_equalTo(CGSizeMake(75 * KFitWidthRate, 50 * KFitWidthRate));
    }];
    self.addressLabel = [CBWtMINUtils createLabelWithText: @"" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWt137Color];//成都市长虹科技大厦...
    self.addressLabel.numberOfLines = 0;
    [mainView addSubview: self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lastLocationLabel.mas_right).with.offset(5 * KFitWidthRate);
        make.top.equalTo(mainView);
        make.height.mas_equalTo(50*KFitWidthRate);
        //make.size.mas_equalTo(CGSizeMake(175 * KFitWidthRate, 50 * KFitWidthRate));
    }];
    self.lastTimeLabel = [CBWtMINUtils createLabelWithText: @"23分钟" size: 15 * KFitWidthRate alignment: NSTextAlignmentRight textColor: KWt137Color];
    [mainView addSubview: self.lastTimeLabel];
    [self.lastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(mainView).with.offset(-12.5 * KFitWidthRate);
        //make.top.equalTo(mainView);
        make.bottom.equalTo(mainView);
        make.height.mas_equalTo(50*KFitWidthRate);
        //make.size.mas_equalTo(CGSizeMake(80 * KFitWidthRate, 50 * KFitWidthRate));
    }];
}

- (void)createMainView
{
    mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview: mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self).with.offset(-12.5 * KFitWidthRate);
    }];
    UIView *topLineView = [CBWtMINUtils createLineView];
    [mainView addSubview: topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView);
        make.right.equalTo(mainView);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(mainView);
    }];
    UIView *middleLineView = [CBWtMINUtils createLineView];
    [mainView addSubview: middleLineView];
    [middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(mainView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(0.5);
        make.centerY.equalTo(mainView);
    }];
    UIView *bottomLineView = [CBWtMINUtils createLineView];
    [mainView addSubview: bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView);
        make.right.equalTo(mainView);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(mainView);
    }];
}

@end
