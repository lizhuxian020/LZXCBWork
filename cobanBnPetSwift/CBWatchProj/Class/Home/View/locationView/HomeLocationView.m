//
//  HomeLocationView.m
//  Watch
//
//  Created by lym on 2018/4/18.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "HomeLocationView.h"

@interface HomeLocationView()
{
    UIView *mainView;
}

@property (nonatomic, strong) UILabel *addressTitleLabel;
@property (nonatomic, strong) UILabel *lastTimeLabel;
@property (nonatomic, strong) UILabel *accuracyLabel;
@property (nonatomic, strong) UIImageView *locationWayImgView;
@end


@implementation HomeLocationView
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
- (void)createMainView
{
    mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview: mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self).with.offset(0);
    }];
    mainView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    mainView.layer.shadowOffset = CGSizeMake(0,5);
    mainView.layer.shadowRadius = 10;
    mainView.layer.shadowOpacity = 1;
    mainView.layer.cornerRadius = 6;

    UIView *middleLineView = [CBWtMINUtils createLineView];
    [mainView addSubview: middleLineView];
    [middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(mainView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(0.5);
        make.centerY.equalTo(mainView);
    }];
}
- (void)createLocationPart
{
    UILabel *labelTitle = [CBWtMINUtils createLabelWithText:Localized(@"宝贝位置:") size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtBlackColor];//KWtBlackColor KWtRGB(73, 73, 73)
    CGFloat width = [NSString getWidthWithText:Localized(@"宝贝位置:") font:[UIFont systemFontOfSize:15 * KFitWidthRate] height:45*KFitWidthRate];
    [mainView addSubview: labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(mainView);
        make.height.mas_equalTo(45 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(width, 45 * KFitWidthRate));
    }];
    
    self.addressTitleLabel = [CBWtMINUtils createLabelWithText: @"" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtBlackColor];//KWt137Color
    self.addressTitleLabel.numberOfLines = 0;
    [mainView addSubview: self.addressTitleLabel];
    [self.addressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle.mas_right).with.offset(5*KFitWidthRate);
        make.top.equalTo(mainView);
        make.right.equalTo(mainView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(45 * KFitWidthRate);
    }];
}
- (void)createTodaySportPart
{
    self.locationWayImgView = [UIImageView new];//[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"wifi"]];
    //self.locationWayImgView.contentMode = UIViewContentModeCenter;
    [mainView addSubview: self.locationWayImgView];
    [self.locationWayImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView).with.offset(12.5 * KFitWidthRate);
        make.bottom.equalTo(mainView);
        make.size.mas_equalTo(CGSizeMake(50 * KFitWidthRate, 50 * KFitWidthRate));
    }];
    self.accuracyLabel = [CBWtMINUtils createLabelWithText:@"" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
    [mainView addSubview: self.accuracyLabel];  //精度23米
    [self.accuracyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationWayImgView.mas_right);
        make.bottom.equalTo(mainView);
        make.height.mas_equalTo(45*KFitWidthRate);
        //make.size.mas_equalTo(CGSizeMake(75 * KFitWidthRate, 45 * KFitWidthRate));
    }];

    self.lastTimeLabel = [CBWtMINUtils createLabelWithText:@"" size: 15 * KFitWidthRate alignment: NSTextAlignmentRight textColor: KWt137Color];
    [mainView addSubview: self.lastTimeLabel];  //23分钟
    [self.lastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(mainView).with.offset(-12.5 * KFitWidthRate);
        make.bottom.equalTo(mainView);
        make.height.mas_equalTo(45*KFitWidthRate);
    }];
}


- (void)setHomeInfoModel:(HomeModel *)homeInfoModel {
    _homeInfoModel = homeInfoModel;
    if (homeInfoModel) {
        
        _addressTitleLabel.text = homeInfoModel.address?:@"";
        _accuracyLabel.text = [NSString stringWithFormat:@"%@:%@%@",Localized(@"精度"),homeInfoModel.tbWatchMain.accuracy?:@"",Localized(@"米")];
        
        if (homeInfoModel.tbWatchMain.flag == 0) {
            //GPS
            UIImage *imageGPS = [UIImage imageNamed:@"GPS卫星"];
            self.locationWayImgView.image = imageGPS;
            [self.locationWayImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(mainView).with.offset(12.5 * KFitWidthRate);
                make.bottom.equalTo(mainView).with.offset(-(45*KFitWidthRate - imageGPS.size.height)/2);
                make.size.mas_equalTo(CGSizeMake(imageGPS.size.width,imageGPS.size.height));
            }];
            [self.accuracyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.locationWayImgView.mas_right).with.offset(5);
                make.bottom.equalTo(mainView);
                make.height.mas_equalTo(45*KFitWidthRate);
            }];
        } else if (homeInfoModel.tbWatchMain.flag == 1) {
            //WIFI
            UIImage *imageWIFI = [UIImage imageNamed:@"wifi"];
            self.locationWayImgView.image = imageWIFI;
            [self.locationWayImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(mainView).with.offset(12.5 * KFitWidthRate);
                make.bottom.equalTo(mainView).with.offset(-(45*KFitWidthRate - imageWIFI.size.height)/2);
                make.size.mas_equalTo(CGSizeMake(imageWIFI.size.width,imageWIFI.size.height));
            }];
            [self.accuracyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.locationWayImgView.mas_right).with.offset(5);;
                make.bottom.equalTo(mainView);
                make.height.mas_equalTo(45*KFitWidthRate);
            }];
        }
        
        NSDate *time = [CBWtMINUtils getDateFromTimestamp:homeInfoModel.tbWatchMain.updateTime];
        NSDate *nowTime = [NSDate date];
        NSTimeInterval timeInterval = [time timeIntervalSinceDate:nowTime];
        // 取绝对值
        timeInterval = fabs(timeInterval);
        NSString *timeString = nil;
        long temp = 0;
        if (timeInterval < 60) {
            timeString = Localized(@"刚刚");//@"1分钟以内";
        } else if ((temp = timeInterval/60)<60) {
            timeString = [NSString stringWithFormat:@"%ld%@",temp,Localized(@"分钟前")];
        } else if ((temp = timeInterval/(60*60))<24) {
            timeString = [NSString stringWithFormat:@"%ld%@",temp,Localized(@"小时前")];
        } else if ((temp = timeInterval/(24*60*60))<30) {
            timeString = [NSString stringWithFormat:@"%ld%@",temp,Localized(@"天前")];
        } else if (((temp = timeInterval/(24*60*60*30)))<12) {
            timeString = [NSString stringWithFormat:@"%ld%@",temp,Localized(@"月前")];
        } else {
            temp = timeInterval/(24*60*60*30*12);
            timeString = [NSString stringWithFormat:@"%ld%@",temp,Localized(@"年前")];
        }
        _lastTimeLabel.text = timeString;
    }
}
@end
