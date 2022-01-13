//
//  MINMapPaopaoDetailView.h
//  Telematics
//
//  Created by lym on 2017/12/8.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeviceDetailModel;
@interface MINMapPaopaoDetailView : UIView
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *deleteWarmBtn;
@property (nonatomic, strong) UIButton *playBackBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *altitudeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *stayLabel;
@property (nonatomic, strong) UILabel *stayTimesLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *alarmLabel;
@property (nonatomic, strong) UILabel *gpsLabel;
@property (nonatomic, strong) UILabel *powerLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, copy) NSString *dno;
@property (nonatomic, copy) void (^playBackBtnClickBlock)(NSString *dno);
@property (nonatomic, copy) void (^deleteWarmBtnClickBlock)(NSString *dno);
@property (nonatomic, copy) void (^closeBtnClickBlock)();
@property (nonatomic,copy) void(^navigationBtnClickBlock)();
@property (nonatomic,strong) DeviceDetailModel *deviceInfoModel;
- (void)setAlertStyleIsWarmed:(BOOL)isWarmed;

@end
