//
//  MINMapPaopaoDetailView.m
//  Telematics
//
//  Created by lym on 2017/12/8.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MINMapPaopaoDetailView.h"
#import "DeviceDetailModel.h"

@interface MINMapPaopaoDetailView ()
@property (nonatomic, strong) UILabel *latLabel;
@property (nonatomic, strong) UILabel *lngLabel;
@end

@implementation MINMapPaopaoDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
//        [self createUI];
//        [self addAction];
    }
    return self;
}

- (void)addAction {
    [self.playBackBtn addTarget: self action:@selector(playBackBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.closeBtn addTarget: self action: @selector(closeBtnClick) forControlEvents: UIControlEventTouchUpInside];
}
- (void)playBackBtnClick {
    if (self.playBackBtnClickBlock) {
        self.playBackBtnClickBlock(self.dno);
    }
}
- (void)closeBtnClick {
    if (self.closeBtnClickBlock) {
        self.closeBtnClickBlock();
    }
}
- (void)deleteWarmBlock {
    if (self.deleteWarmBtnClickBlock) {
        self.deleteWarmBtnClickBlock(self.dno);
    }
}
- (void)navigationBtnClick {
    if (self.navigationBtnClickBlock) {
        self.navigationBtnClickBlock();
    }
}
- (void)createUI
{
    UIImage *backImage = [UIImage imageNamed: @"弹框-正常"];
    _backImageView = [[UIImageView alloc] initWithImage:backImage];
    [self addSubview: _backImageView];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        //make.bottom.mas_equalTo(20);
        make.bottom.mas_equalTo(0);
    }];
    
    _titleView = [[UIView alloc] init];
    [self addSubview: _titleView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(13 * KFitWidthRate);
        make.top.equalTo(self).with.offset(6 * KFitHeightRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
        make.right.equalTo(self).with.offset(-12 * KFitWidthRate);
    }];
    
    _middleView = [[UIView alloc] init];
    [self addSubview: _middleView];
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleView);
        make.top.equalTo(_titleView.mas_bottom);
        make.height.mas_equalTo(245 * KFitHeightRate + 0);
    }];
    
    CGFloat padding = (245 *KFitHeightRate - 15*KFitHeightRate - 15*KFitHeightRate + 0) /7;
    _bottomView = [[UIView alloc] init];
    [self addSubview: _bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleView);
        make.height.mas_equalTo(50 * KFitHeightRate);
        make.top.equalTo(_middleView.mas_bottom);
    }];
    
//    UIView *lineView = [MINUtils createLineView];
//    [_middleView addSubview: lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(_middleView);
//        make.height.mas_equalTo(0.5);
//    }];粤A35564
    _titleLabel = [MINUtils createLabelWithText: @"" size:15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: [UIColor whiteColor]];
    [_titleView addSubview: _titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleView).with.offset(15 * KFitWidthRate);
        make.top.bottom.equalTo(_titleView);
        make.width.mas_equalTo(200 * KFitWidthRate);
    }];
    
    _playBackBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"回放") titleColor: [UIColor whiteColor] fontSize:15 * KFitWidthRate];
    //_playBackBtn.backgroundColor = [UIColor greenColor];
    [_playBackBtn setImage: [UIImage imageNamed: @"回放"] forState: UIControlStateNormal];
    [_playBackBtn setImage: [UIImage imageNamed: @"回放"] forState: UIControlStateHighlighted];
    [_playBackBtn horizontalCenterImageAndTitle:5];
    //_playBackBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10 * KFitWidthRate);
    [_titleView addSubview: _playBackBtn];
    //CGFloat playBtnWidth = [NSString getWidthWithText:Localized(@"回放") font:[UIFont systemFontOfSize:15 * KFitWidthRate] height:30];
    [_playBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_titleView);
        make.right.equalTo(_titleView).with.offset(-40*KFitWidthRate);
        //make.width.mas_equalTo(60 * KFitWidthRate);//85
        //make.width.mas_equalTo(playBtnWidth + 10 * KFitWidthRate + 15*KFitWidthRate);//85
    }];
    _closeBtn = [[UIButton alloc] init];
    [_closeBtn setImage: [UIImage imageNamed: @"closeMain"] forState: UIControlStateNormal];
    [_closeBtn setImage: [UIImage imageNamed: @"closeMain"] forState: UIControlStateHighlighted];
    [_titleView addSubview: _closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_titleView);
        make.right.equalTo(_titleView);
        make.width.mas_equalTo(40 * KFitWidthRate);
    }];
    
    _latLabel = [self createLabelWithText: @"纬度: 22.551386"];//ic_marker_detail_addrs
    _lngLabel = [self createLabelWithText: @"经度: 113.908811"];
    _speedLabel = [self createLabelWithText: @"速度方向: 行驶 36Km/h"];
    _altitudeLabel = [self createLabelWithText: @"海拔高度: 1500米"];
    _timeLabel = [self createLabelWithText: @"2017-05-05 22:33:44"];
    _distanceLabel = [self createLabelWithText: @"当天里程: 15KM"];
    _stayLabel = [self createLabelWithText: @"停留时间: 15分钟"];
    _stayTimesLabel = [self createLabelWithText: @"停留次数: 10次"];
    _statusLabel = [self createLabelWithText: @"状态: ACC 开，门开，断油断电"];
    _alarmLabel = [self createLabelWithText: @"报警: 移位报警，非法点火报警，碰撞侧翻报警"];
    _alarmLabel.textColor = kRGB(255, 24, 0);
    _gpsLabel = [self createLabelWithText: @"GPS: 8颗"];
    _addressLabel = [self createLabelWithText: @"四川省成都市高新区长虹科技大厦"];
    UIImage *image_location = [UIImage imageNamed: @"地点"];
    UIImageView *imageView_location = [[UIImageView alloc] initWithImage:image_location];
    [_middleView addSubview: imageView_location];
    [imageView_location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_middleView.mas_left).with.offset(20 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(image_location.size.width * KFitWidthRate, image_location.size.height * KFitWidthRate));
        make.centerY.equalTo(_middleView.mas_top).with.offset(25*KFitHeightRate);
    }];
    [_middleView addSubview:_latLabel];
    [_latLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_middleView.mas_left).with.offset(40 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(130 * KFitWidthRate, 20 * KFitWidthRate));
        make.centerY.equalTo(_middleView.mas_top).with.offset(25 * KFitHeightRate);
    }];
    [_middleView addSubview:_lngLabel];
    [_lngLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_latLabel.mas_right).with.offset(14 * KFitWidthRate);
        make.height.mas_equalTo(20*KFitHeightRate);
        make.centerY.equalTo(_middleView.mas_top).with.offset(25 * KFitHeightRate);
    }];
    
    NSArray *leftLabelArr = @[_speedLabel, _timeLabel, _stayLabel, _statusLabel,_gpsLabel, _addressLabel];//_alarmLabel, _gpsLabel
    NSArray *rightLabelArr = @[_altitudeLabel, _distanceLabel, _stayTimesLabel];
    UIImageView *lastImageView = nil;
//    NSArray *imageNameArr = @[@"速度方向", @"海拔高度", @"时间-首页", @"当天里程", @"停留时长", @"停留次数", @"状态", @"报警", @"gps"];
    NSArray *leftImageArr = @[@"速度方向", @"时间-首页", @"停留时长", @"状态", @"gps",@"地点"];
    NSArray *rightImageArr = @[@"海拔高度", @"当天里程", @"停留次数"];
    for (int i = 0; i < leftImageArr.count; i++) {
        UIImage *image = [UIImage imageNamed: leftImageArr[i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
        [_middleView addSubview: imageView];
        if (lastImageView == nil) {
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_middleView.mas_left).with.offset(20 * KFitWidthRate);
                make.size.mas_equalTo(CGSizeMake(image.size.width * KFitWidthRate, image.size.height * KFitWidthRate));
                make.centerY.equalTo(_middleView.mas_top).with.offset(20*KFitWidthRate + padding);
            }];
        }else {
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(lastImageView);
                make.size.mas_equalTo(CGSizeMake(image.size.width * KFitWidthRate, image.size.height * KFitWidthRate));
                make.centerY.equalTo(lastImageView).with.offset(padding);
            }];
        }
        UILabel *label = leftLabelArr[i];
        label.numberOfLines = 0;
        [_middleView addSubview: label];
        if (lastImageView == nil) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_middleView.mas_left).with.offset(40 * KFitWidthRate);
                make.size.mas_equalTo(CGSizeMake(130 * KFitWidthRate, 20 * KFitHeightRate));
                make.centerY.equalTo(_middleView.mas_top).with.offset(20*KFitHeightRate + padding);
            }];
        } else {
            if (i <= 2) {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_middleView.mas_left).with.offset(40 * KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(130 * KFitWidthRate, 20 * KFitHeightRate));
                    make.centerY.equalTo(lastImageView).with.offset(padding);
                }];
            }else {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_middleView.mas_left).with.offset(40 * KFitWidthRate);
                    //make.size.mas_equalTo(CGSizeMake(250 * KFitWidthRate, 20 * KFitWidthRate));
                    make.width.mas_equalTo(250 * KFitWidthRate);
                    make.centerY.equalTo(lastImageView).with.offset(padding);
                }];
            }
        }
        lastImageView = imageView;
    }
    lastImageView = nil;
    for (int i = 0; i < rightImageArr.count; i++) {
        UIImage *image = [UIImage imageNamed: rightImageArr[i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
        [_middleView addSubview: imageView];
        if (lastImageView == nil) {
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_speedLabel.mas_right).with.offset(20 * KFitWidthRate);
                make.size.mas_equalTo(CGSizeMake(image.size.width * KFitWidthRate, image.size.height * KFitWidthRate));
                make.centerY.equalTo(_middleView.mas_top).with.offset(20*KFitHeightRate + padding);
            }];
        }else {
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(lastImageView);
                make.size.mas_equalTo(CGSizeMake(image.size.width * KFitWidthRate, image.size.height * KFitWidthRate));
                make.centerY.equalTo(lastImageView).with.offset(padding);
            }];
        }
        UILabel *label = rightLabelArr[i];
        [_middleView addSubview: label];
        if (lastImageView == nil) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView.mas_centerX).with.offset(15 * KFitWidthRate);
                make.size.mas_equalTo(CGSizeMake(130 * KFitWidthRate, 20 * KFitWidthRate));
                make.centerY.equalTo(_middleView.mas_top).with.offset(20*KFitHeightRate + padding);
            }];
        }else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView.mas_centerX).with.offset(15 * KFitWidthRate);
                make.size.mas_equalTo(CGSizeMake(130 * KFitWidthRate, 20 * KFitHeightRate));
                make.centerY.equalTo(lastImageView).with.offset(padding);
            }];
        }
        lastImageView = imageView;
    }
//    UIImage *gpsPowerImage = [UIImage imageNamed: @"信号"];
//    UIImageView *gpsPowerImageView = [[UIImageView alloc] initWithImage: gpsPowerImage];
//    [_middleView addSubview: gpsPowerImageView];
//    [gpsPowerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_middleView.mas_left).with.offset(100 * KFitWidthRate);
//        make.size.mas_equalTo(CGSizeMake(gpsPowerImage.size.width * KFitWidthRate, gpsPowerImage.size.height * KFitWidthRate));
//        make.centerY.equalTo(_gpsLabel);
//    }];
    _powerLabel = [self createLabelWithText: @"电量"];//POWER
    [_middleView addSubview: _powerLabel];
    [_powerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(gpsPowerImageView.mas_centerX).with.offset(20 * KFitWidthRate);
        make.left.equalTo(_latLabel.mas_right).with.offset(14 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(85 * KFitWidthRate, 20 * KFitHeightRate));
        make.centerY.equalTo(_gpsLabel);
    }];
//    UIImage *powerImage = [UIImage imageNamed: @"电量3"];
//    UIImageView *powerImageView = [[UIImageView alloc] initWithImage: powerImage];
//    [_middleView addSubview: powerImageView];
//    [powerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_powerLabel.mas_right);
//        make.size.mas_equalTo(CGSizeMake(powerImage.size.width * KFitWidthRate, powerImage.size.height * KFitWidthRate));
//        make.centerY.equalTo(_gpsLabel);
//    }];
//    UIImage *addressImage = [UIImage imageNamed:@"地点"];
//    UIImageView *addressImageView = [[UIImageView alloc] initWithImage: addressImage];
//    [_bottomView addSubview: addressImageView];
//    [addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_bottomView.mas_left).with.offset(20 * KFitWidthRate);
//        make.size.mas_equalTo(CGSizeMake(addressImage.size.width * KFitWidthRate, addressImage.size.height * KFitWidthRate));
//        make.centerY.equalTo(_bottomView.mas_top).with.offset(25 * KFitWidthRate);
//    }];
//    [_bottomView addSubview: _addressLabel];
//    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_bottomView.mas_left).with.offset(40 * KFitWidthRate);
//        make.size.mas_equalTo(CGSizeMake(250 * KFitWidthRate, 20 * KFitWidthRate));
//        make.centerY.equalTo(_bottomView.mas_top).with.offset(25 * KFitWidthRate);
//    }];
    
    UIButton *btnNavigation = [MINUtils createNoBorderBtnWithTitle:Localized(@"导航") titleColor: [UIColor whiteColor] fontSize:15*KFitWidthRate];
    btnNavigation.backgroundColor = kRGB(26, 151, 251);
    [btnNavigation setTitle:Localized(@"导航") forState:UIControlStateNormal];
    [btnNavigation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomView addSubview: btnNavigation];
    CGFloat width = [NSString getWidthWithText:Localized(@"导航") font:[UIFont systemFontOfSize:15*KFitWidthRate] height:30*KFitHeightRate];
    [btnNavigation addTarget: self action: @selector(navigationBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [btnNavigation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bottomView.mas_right).offset(-15*KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(width + 25*KFitWidthRate, 30*KFitHeightRate));
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
    }];
}
- (void)createUI_warmed
{
    UIImage *backImage = [UIImage imageNamed: @"弹框-报警"];
    _backImageView = [[UIImageView alloc] initWithImage:backImage];
    [self addSubview: _backImageView];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    _titleView = [[UIView alloc] init];
    [self addSubview: _titleView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(13 * KFitWidthRate);
        make.top.equalTo(self).with.offset(6 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
        make.right.equalTo(self).with.offset(-12 * KFitWidthRate);
    }];
    
    _middleView = [[UIView alloc] init];
    //_middleView.backgroundColor = [UIColor redColor];
    [self addSubview: _middleView];
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleView);
        make.top.equalTo(_titleView.mas_bottom);
        make.height.mas_equalTo(245 * KFitHeightRate + 0);
    }];
    
    CGFloat padding = (245 *KFitHeightRate - 8*KFitHeightRate - 8*KFitHeightRate + 0) /8;
    
    _bottomView = [[UIView alloc] init];
    [self addSubview: _bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleView);
        make.height.mas_equalTo(50 * KFitHeightRate);
        make.top.equalTo(_middleView.mas_bottom);
    }];
    
    //    UIView *lineView = [MINUtils createLineView];
    //    [_middleView addSubview: lineView];
    //    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.bottom.equalTo(_middleView);
    //        make.height.mas_equalTo(0.5);
    //    }];粤A35564
    _titleLabel = [MINUtils createLabelWithText: @"" size:15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: [UIColor whiteColor]];
    [_titleView addSubview: _titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleView).with.offset(15 * KFitWidthRate);
        make.top.bottom.equalTo(_titleView);
        //make.width.mas_equalTo(200 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    
    _deleteWarmBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"处理报警") titleColor: [UIColor whiteColor] fontSize:15 * KFitWidthRate];
    _deleteWarmBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //_playBackBtn.backgroundColor = [UIColor greenColor];
    [_deleteWarmBtn setImage: [UIImage imageNamed: @"ic_handle_alarm"] forState: UIControlStateNormal];
    [_deleteWarmBtn setImage: [UIImage imageNamed: @"ic_handle_alarm"] forState: UIControlStateHighlighted];
    //_deleteWarmBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5 * KFitWidthRate);
    [_deleteWarmBtn horizontalCenterImageAndTitle:5*KFitWidthRate];
    [_titleView addSubview: _deleteWarmBtn];
    //CGFloat widthDealWith = [NSString getWidthWithText:Localized(@"处理报警") font:[UIFont systemFontOfSize:15*KFitWidthRate] height:20*KFitHeightRate];
    [_deleteWarmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(0*KFitWidthRate);
        //make.width.mas_equalTo(widthDealWith + 10*KFitWidthRate + 20*KFitWidthRate);//85
        make.height.mas_equalTo(20*KFitHeightRate);
    }];
    [_deleteWarmBtn addTarget: self action:@selector(deleteWarmBlock) forControlEvents: UIControlEventTouchUpInside];
    
    _playBackBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"回放") titleColor: [UIColor whiteColor] fontSize:15 * KFitWidthRate];
    //_playBackBtn.backgroundColor = [UIColor greenColor];
    [_playBackBtn setImage: [UIImage imageNamed: @"回放"] forState: UIControlStateNormal];
    [_playBackBtn setImage: [UIImage imageNamed: @"回放"] forState: UIControlStateHighlighted];
    //_playBackBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10 * KFitWidthRate);
    [_playBackBtn horizontalCenterImageAndTitle:5];
    [_titleView addSubview: _playBackBtn];
    
    //CGFloat playBtnWidth = [NSString getWidthWithText:Localized(@"回放") font:[UIFont systemFontOfSize:15 * KFitWidthRate] height:30];
    [_playBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_titleView);
        make.right.equalTo(_titleView).with.offset(-40*KFitWidthRate);
        //make.width.mas_equalTo(playBtnWidth + 10*KFitWidthRate + 15*KFitWidthRate);//85
    }];
    _closeBtn = [[UIButton alloc] init];
    [_closeBtn setImage: [UIImage imageNamed: @"closeMain"] forState: UIControlStateNormal];
    [_closeBtn setImage: [UIImage imageNamed: @"closeMain"] forState: UIControlStateHighlighted];
    [_titleView addSubview: _closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_titleView);
        make.right.equalTo(_titleView);
        make.width.mas_equalTo(40 * KFitWidthRate);
    }];
    
//    _titleLabel.backgroundColor = [UIColor greenColor];
//    _closeBtn.backgroundColor = [UIColor greenColor];
//    _playBackBtn.backgroundColor = [UIColor purpleColor];
//    _deleteWarmBtn.backgroundColor = [UIColor orangeColor];
    
    _latLabel = [self createLabelWithText: @"纬度: 22.551386"];//ic_marker_detail_addrs
    _lngLabel = [self createLabelWithText: @"经度: 113.908811"];
    _speedLabel = [self createLabelWithText: @"速度方向: 行驶 36Km/h"];
    _altitudeLabel = [self createLabelWithText: @"海拔高度: 1500米"];
    _timeLabel = [self createLabelWithText: @"2017-05-05 22:33:44"];
    _distanceLabel = [self createLabelWithText: @"当天里程: 15KM"];
    _stayLabel = [self createLabelWithText: @"停留时间: 15分钟"];
    _stayTimesLabel = [self createLabelWithText: @"停留次数: 10次"];
    _statusLabel = [self createLabelWithText: @"状态: ACC 开，门开，断油断电"];
    _alarmLabel = [self createLabelWithText: @"报警: 移位报警，非法点火报警，碰撞侧翻报警"];
    _alarmLabel.textColor = kRGB(255, 24, 0);
    _gpsLabel = [self createLabelWithText: @"GPS: 8颗"];
    _addressLabel = [self createLabelWithText: @"四川省成都市高新区长虹科技大厦"];
    _addressLabel.numberOfLines = 0;
    UIImage *image_location = [UIImage imageNamed: @"地点"];
    UIImageView *imageView_location = [[UIImageView alloc] initWithImage:image_location];
    [_middleView addSubview: imageView_location];
    [imageView_location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_middleView.mas_left).with.offset(20 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(image_location.size.width * KFitWidthRate, image_location.size.height * KFitWidthRate));
        make.centerY.equalTo(_middleView.mas_top).with.offset(25*KFitHeightRate);
    }];
    [_middleView addSubview:_latLabel];
    [_latLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_middleView.mas_left).with.offset(40 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(130 * KFitWidthRate, 20 * KFitHeightRate));
        make.centerY.equalTo(_middleView.mas_top).with.offset(25 * KFitHeightRate);
    }];
    [_middleView addSubview:_lngLabel];
    [_lngLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_latLabel.mas_right).with.offset(14 * KFitWidthRate);
        make.height.mas_equalTo(20*KFitHeightRate);
        make.centerY.equalTo(_middleView.mas_top).with.offset(25 * KFitHeightRate);
    }];
    
    NSArray *leftLabelArr = @[_speedLabel, _timeLabel, _stayLabel, _statusLabel,_alarmLabel,_gpsLabel, _addressLabel];//_alarmLabel, _gpsLabel
    NSArray *rightLabelArr = @[_altitudeLabel, _distanceLabel, _stayTimesLabel];
    UIImageView *lastImageView = nil;
    //    NSArray *imageNameArr = @[@"速度方向", @"海拔高度", @"时间-首页", @"当天里程", @"停留时长", @"停留次数", @"状态", @"报警", @"gps"];
    NSArray *leftImageArr = @[@"速度方向", @"时间-首页", @"停留时长", @"状态", @"报警-定位",@"gps",@"地点"];
    NSArray *rightImageArr = @[@"海拔高度", @"当天里程", @"停留次数"];
    for (int i = 0; i < leftImageArr.count; i++) {
        UIImage *image = [UIImage imageNamed: leftImageArr[i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
        [_middleView addSubview: imageView];
        if (lastImageView == nil) {
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_middleView.mas_left).with.offset(20 * KFitWidthRate);
                make.size.mas_equalTo(CGSizeMake(image.size.width * KFitWidthRate, image.size.height * KFitWidthRate));
                make.centerY.equalTo(_middleView.mas_top).with.offset(20*KFitWidthRate + padding);
            }];
        }else {
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(lastImageView);
                make.size.mas_equalTo(CGSizeMake(image.size.width * KFitWidthRate, image.size.height * KFitWidthRate));
                make.centerY.equalTo(lastImageView).with.offset(padding);
            }];
        }
        UILabel *label = leftLabelArr[i];
        label.numberOfLines = 0;
        [_middleView addSubview: label];
        if (lastImageView == nil) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_middleView.mas_left).with.offset(40 * KFitWidthRate);
                make.size.mas_equalTo(CGSizeMake(130 * KFitWidthRate, 20 * KFitHeightRate));
                make.centerY.equalTo(_middleView.mas_top).with.offset(20*KFitHeightRate + padding);
            }];
        }else {
            if (i <= 2) {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_middleView.mas_left).with.offset(40 * KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(130 * KFitWidthRate, 20 * KFitHeightRate));
                    make.centerY.equalTo(lastImageView).with.offset(padding);
                }];
            }else {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_middleView.mas_left).with.offset(40 * KFitWidthRate);
                    //make.size.mas_equalTo(CGSizeMake(250 * KFitWidthRate, 20 * KFitWidthRate));
                    make.width.mas_equalTo(250 * KFitWidthRate);
                    make.centerY.equalTo(lastImageView).with.offset(padding);
                }];
            }
            
        }
        lastImageView = imageView;
    }
    lastImageView = nil;
    for (int i = 0; i < rightImageArr.count; i++) {
        UIImage *image = [UIImage imageNamed: rightImageArr[i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
        [_middleView addSubview: imageView];
        if (lastImageView == nil) {
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_speedLabel.mas_right).with.offset(20 * KFitWidthRate);
                make.size.mas_equalTo(CGSizeMake(image.size.width * KFitWidthRate, image.size.height * KFitWidthRate));
                make.centerY.equalTo(_middleView.mas_top).with.offset(20*KFitHeightRate + padding);
            }];
        }else {
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(lastImageView);
                make.size.mas_equalTo(CGSizeMake(image.size.width * KFitWidthRate, image.size.height * KFitWidthRate));
                make.centerY.equalTo(lastImageView).with.offset(padding);
            }];
        }
        UILabel *label = rightLabelArr[i];
        [_middleView addSubview: label];
        if (lastImageView == nil) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView.mas_centerX).with.offset(15 * KFitWidthRate);
                make.size.mas_equalTo(CGSizeMake(130 * KFitWidthRate, 20 * KFitHeightRate));
                make.centerY.equalTo(_middleView.mas_top).with.offset(20*KFitHeightRate + padding);
            }];
        }else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView.mas_centerX).with.offset(15 * KFitWidthRate);
                make.size.mas_equalTo(CGSizeMake(130 * KFitWidthRate, 20 * KFitHeightRate));
                make.centerY.equalTo(lastImageView).with.offset(padding);
            }];
        }
        lastImageView = imageView;
    }
    //    UIImage *gpsPowerImage = [UIImage imageNamed: @"信号"];
    //    UIImageView *gpsPowerImageView = [[UIImageView alloc] initWithImage: gpsPowerImage];
    //    [_middleView addSubview: gpsPowerImageView];
    //    [gpsPowerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(_middleView.mas_left).with.offset(100 * KFitWidthRate);
    //        make.size.mas_equalTo(CGSizeMake(gpsPowerImage.size.width * KFitWidthRate, gpsPowerImage.size.height * KFitWidthRate));
    //        make.centerY.equalTo(_gpsLabel);
    //    }];
    _powerLabel = [self createLabelWithText: @"电量"];//POWER
    [_middleView addSubview: _powerLabel];
    [_powerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(gpsPowerImageView.mas_centerX).with.offset(20 * KFitWidthRate);
        make.left.equalTo(_latLabel.mas_right).with.offset(14 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(85 * KFitWidthRate, 20 * KFitHeightRate));
        make.centerY.equalTo(_gpsLabel);
    }];
    //    UIImage *powerImage = [UIImage imageNamed: @"电量3"];
    //    UIImageView *powerImageView = [[UIImageView alloc] initWithImage: powerImage];
    //    [_middleView addSubview: powerImageView];
    //    [powerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(_powerLabel.mas_right);
    //        make.size.mas_equalTo(CGSizeMake(powerImage.size.width * KFitWidthRate, powerImage.size.height * KFitWidthRate));
    //        make.centerY.equalTo(_gpsLabel);
    //    }];
    //    UIImage *addressImage = [UIImage imageNamed:@"地点"];
    //    UIImageView *addressImageView = [[UIImageView alloc] initWithImage: addressImage];
    //    [_bottomView addSubview: addressImageView];
    //    [addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(_bottomView.mas_left).with.offset(20 * KFitWidthRate);
    //        make.size.mas_equalTo(CGSizeMake(addressImage.size.width * KFitWidthRate, addressImage.size.height * KFitWidthRate));
    //        make.centerY.equalTo(_bottomView.mas_top).with.offset(25 * KFitWidthRate);
    //    }];
    //    [_bottomView addSubview: _addressLabel];
    //    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(_bottomView.mas_left).with.offset(40 * KFitWidthRate);
    //        make.size.mas_equalTo(CGSizeMake(250 * KFitWidthRate, 20 * KFitWidthRate));
    //        make.centerY.equalTo(_bottomView.mas_top).with.offset(25 * KFitWidthRate);
    //    }];
    
    UIButton *btnNavigation = [MINUtils createNoBorderBtnWithTitle:Localized(@"导航") titleColor: [UIColor whiteColor] fontSize:15*KFitWidthRate];
    btnNavigation.backgroundColor = kRGB(26, 151, 251);
    [btnNavigation setTitle:Localized(@"导航") forState:UIControlStateNormal];
    [btnNavigation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomView addSubview: btnNavigation];
    [btnNavigation addTarget: self action: @selector(navigationBtnClick) forControlEvents: UIControlEventTouchUpInside];
    CGFloat width = [NSString getWidthWithText:Localized(@"导航") font:[UIFont systemFontOfSize:15*KFitWidthRate] height:30*KFitHeightRate];
    [btnNavigation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bottomView.mas_right).offset(-15*KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(width + 25*KFitWidthRate, 30*KFitHeightRate));
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
    }];
}

- (void)setAlertStyleIsWarmed:(BOOL)isWarmed {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (isWarmed) {
        //if (!_backImageView) {
            [self createUI_warmed];
            [self addAction];
        //}
    } else {
        
        //if (!_backImageView) {
            [self createUI];
            [self addAction];
        //}
    }
}
- (UILabel *)createLabelWithText:(NSString *)text {
    UILabel *label = [MINUtils createLabelWithText:text size:10 * KFitWidthRate alignment:NSTextAlignmentLeft textColor: k137Color];
    return label;
}
- (void)setDeviceInfoModel:(DeviceDetailModel *)deviceInfoModel {
    _deviceInfoModel = deviceInfoModel;
    if (deviceInfoModel) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@",kStringIsEmpty(deviceInfoModel.carNum)?Localized(@"未知"):deviceInfoModel.carNum];
        //[Utils getSafeString:deviceInfoModel.carNum];
        self.latLabel.text = [NSString stringWithFormat:@"%@: %@",Localized(@"纬度"), deviceInfoModel.lat];
        self.lngLabel.text = [NSString stringWithFormat:@"%@: %@",Localized(@"经度"), deviceInfoModel.lng];
        self.speedLabel.text = [NSString stringWithFormat:@"%@: %@Km/h",Localized(@"速度"), deviceInfoModel.speed];
        self.altitudeLabel.text = [NSString stringWithFormat: @"%@: %@%@",Localized(@"海拔高度"),deviceInfoModel.altitude,Localized(@"米")];
        NSString *createTimeStr = [Utils convertTimeWithTimeIntervalString:deviceInfoModel.createTime?:@"" timeZone:deviceInfoModel.timeZone?:@""];//[Utils timeWithTimeIntervalString:deviceInfoModel.createTime?:@""];
        self.timeLabel.text = createTimeStr;
        self.distanceLabel.text = [NSString stringWithFormat: @"%@: %@KM",Localized(@"当天里程"), deviceInfoModel.mileage];
        self.stayLabel.text = [NSString stringWithFormat: @"%@: %@",Localized(@"停留时间"), deviceInfoModel.remainTime?:@"0"];
        self.stayTimesLabel.text = [NSString stringWithFormat: @"%@: %@%@",Localized(@"停留次数"), deviceInfoModel.remainCount?:@"0",Localized(@"次")];
        self.statusLabel.text = [NSString stringWithFormat: @"%@: %@",Localized(@"状态"), deviceInfoModel.status];
        if (_alarmLabel) {
            // sos 超速    疲劳     低电   掉电        振动    开门       点火   位移   偷油漏油    碰撞       进出区域  出围栏报警 入围栏报警
            // SOS Speed Fatigue LowBat  PowerDown  Shock  OpenDoor   Acc   Move  OilAlarm  Collision  Area     Out_Fence_Alarm    In_Fence_Alarm
            // 0    1       2       7     8          12      17        16   15      25        27        20      32        33
            NSArray *arrayWarmType = [deviceInfoModel.warmType componentsSeparatedByString:@","];
            NSMutableArray *arrTemp = [NSMutableArray array];
            if (arrayWarmType.count > 0) {
                for (NSString *typeStr in arrayWarmType) {
                    if (!kStringIsEmpty(typeStr)) {
                        [arrTemp addObject:[self returnWarmDescriptionType:typeStr]];
                    }
                }
            }
            NSString *warmTypeStr = [arrTemp componentsJoinedByString:@","];
            self.alarmLabel.text = [NSString stringWithFormat: @"%@: %@",Localized(@"报警"), warmTypeStr];//ss;
        }
        self.gpsLabel.text = [NSString stringWithFormat: @"%@: %@%@",Localized(@"卫星"), deviceInfoModel.gps,Localized(@"颗")];
        self.powerLabel.text = [NSString stringWithFormat: @"%@: %@",Localized(@"电量"),deviceInfoModel.power];
        self.addressLabel.text = [Utils getSafeString:deviceInfoModel.address];
    }
}
- (NSString *)returnWarmDescriptionType:(NSString *)status {
    switch (status.integerValue) {
        case 0:
            return Localized(@"sos");
            break;
        case 1:
            return Localized(@"超速 ");
            break;
        case 2:
            return Localized(@"疲劳");
            break;
        case 7:
            return Localized(@"低电");
            break;
        case 8:
            return Localized(@"掉电");
            break;
        case 12:
            return Localized(@"振动");
            break;
        case 15:
            return Localized(@"位移");
            break;
        case 16:
            return Localized(@"点火");
            break;
        case 17:
            return Localized(@"开门");
            break;
        case 20:
            return Localized(@"进出区域");
            break;
        case 25:
            return Localized(@"偷油漏油");
            break;
        case 27:
            return Localized(@"碰撞");
            break;
        case 32:
            return Localized(@"进围栏");
        break;
        case 33:
            return Localized(@"出围栏");
        break;
        default:
            return Localized(@"未知");
            break;
    }
}
@end
