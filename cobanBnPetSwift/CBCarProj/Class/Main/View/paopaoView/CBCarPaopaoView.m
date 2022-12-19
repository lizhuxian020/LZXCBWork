//
//  CBCarPaopaoView.m
//  Telematics
//
//  Created by coban on 2020/5/22.
//  Copyright © 2020 coban. All rights reserved.
//

#import "CBCarPaopaoView.h"

#define __CarPaoTitle_Title @"标题"
#define __CarPaoTitle_Track Localized(@"跟踪")
#define __CarPaoTitle_PlayBack Localized(@"回放")
#define __CarPaoTitle_Move Localized(@"位移")

@interface CBCarPaopaoView ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
/** 背景view */
@property (nonatomic,strong) UIImageView *bgmView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIScrollView *middleView;
@property (nonatomic, strong) UIView *middleContentView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowView;

@property (nonatomic, strong) UIView *followBtn;
@property (nonatomic, strong) UIView *playBackBtn;
@property (nonatomic, strong) UIView *moveBtn;
//@property (nonatomic, strong) UIButton *deleteWarmBtn;
//@property (nonatomic, strong) UIButton *closeBtn;
//@property (nonatomic,strong) UIButton *navigationBtn;

@property (nonatomic, strong) UILabel *lngLb;
@property (nonatomic, strong) UILabel *statusLb;
/* 撤防：开*/
@property (nonatomic, strong) UILabel *cfLb;
/* acc状态*/
@property (nonatomic, strong) UILabel *accLb;
/* 门状态*/
@property (nonatomic, strong) UILabel *doorLb;
/* 电量*/
@property (nonatomic, strong) UILabel *electriLb;
/* 油量：0L 0%*/
@property (nonatomic, strong) UILabel *oilLb;
/* 休眠模式：时间休眠*/
@property (nonatomic, strong) UILabel *sleepModelLb;
/* gsm个数*/
@property (nonatomic, strong) UILabel *gsmNumberLb;
/* gps个数*/
@property (nonatomic, strong) UILabel *gpsNumberLb;
/* 上报策略*/
@property (nonatomic, strong) UILabel *reportLb;
/* 报警*/
@property (nonatomic, strong) UILabel *warmTypeLb;
/* 上报时间*/
@property (nonatomic, strong) UILabel *timeLb;
/* 当前位置*/
@property (nonatomic, strong) UILabel *addressLabel;
//@property (nonatomic, strong) UILabel *latLb;
//@property (nonatomic, strong) UILabel *speedLb;
//@property (nonatomic, strong) UILabel *offlineTimeLb;
//@property (nonatomic, strong) UILabel *stayTimeLb;
//@property (nonatomic, strong) UILabel *stayCountLb;


///* 内电：关*/
//@property (nonatomic, strong) UILabel *inElectriLb;
///* 外电：开*/
//@property (nonatomic, strong) UILabel *outElectriLb;
///* 布防：开*/
//@property (nonatomic, strong) UILabel *bfLb;

///* 当天里程：0km*/
//@property (nonatomic, strong) UILabel *mileageLb;

///* 低电报警：开*/
//@property (nonatomic, strong) UILabel *lowElectricWarmLb;
///* 盲区报警：开*/
//@property (nonatomic, strong) UILabel *mqWarmLb;
///* 掉电报警：开*/
//@property (nonatomic, strong) UILabel *ddWarmLb;
///* 超速报警：开*/
//@property (nonatomic, strong) UILabel *overSpeedWarmLb;
///* 振动报警：开*/
//@property (nonatomic, strong) UILabel *zdWarmLb;
///* 油量检测报警：开*/
//@property (nonatomic, strong) UILabel *yljcWarmLb;
///* 电子围栏：进/出*/
////@property (nonatomic, strong) UILabel *fenceStatusLb;
///* GPS漂移抑制：开*/
//@property (nonatomic, strong) UILabel *gpsDriftLb;
///* 油电控制：开*/
//@property (nonatomic, strong) UILabel *ydControlLb;
///* 振动灵敏度：高*/
//@property (nonatomic, strong) UILabel *vibrationLb;
///* ACC工作通知：关*/
//@property (nonatomic, strong) UILabel *accNoticeLb;
///* 终端时区：8*/
//@property (nonatomic, strong) UILabel *timeZone;







/* */
@property (nonatomic, strong) NSMutableArray *arrayLb;
/* */
//@property (nonatomic, strong) NSMutableArray *arrayTitles;

@property (nonatomic, strong) UIView *movePopView;
@end

@implementation CBCarPaopaoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)dealloc {
}
- (void)layoutSubviews {
    [super layoutSubviews];
//    self.middleView.contentSize = CGSizeMake(0, (self.arrayLb.count/2 + 2)*20*KFitHeightRate);
}
- (UIView *)movePopView {
    if (!_movePopView) {
        _movePopView = [UIView new];
        _movePopView.backgroundColor = UIColor.whiteColor;
        UILabel *lbl200 = [MINUtils createLabelWithText:@"200m" size:14 alignment:NSTextAlignmentCenter textColor:UIColor.blackColor];
        UILabel *lbl500 = [MINUtils createLabelWithText:@"500m" size:14 alignment:NSTextAlignmentCenter textColor:UIColor.blackColor];
        UILabel *lbl1000 = [MINUtils createLabelWithText:@"1000m" size:14 alignment:NSTextAlignmentCenter textColor:UIColor.blackColor];
        UILabel *lblCancel = [MINUtils createLabelWithText:Localized(@"取消") size:14 alignment:NSTextAlignmentCenter textColor:UIColor.blackColor];
        UILabel *lastLbl = nil;
        for (UILabel *lbl in @[lbl200, lbl500, lbl1000, lblCancel]) {
            [_movePopView addSubview:lbl];
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(@0);
                if (lastLbl) {
                    make.top.equalTo(lastLbl.mas_bottom);
                } else {
                    make.top.equalTo(@0);
                }
                make.height.equalTo(@30);
            }];
            lbl.userInteractionEnabled = YES;
            NSString *text = lbl.text;
            kWeakSelf(self);
            [lbl bk_whenTapped:^{
                [weakself didClickMove:text];
            }];
            lastLbl = lbl;
        }
        [lastLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
        }];
    }
    return _movePopView;
}
- (NSMutableArray *)arrayLb {
    if (!_arrayLb) {
        _arrayLb = [NSMutableArray array];
    }
    return _arrayLb;
}
//- (NSMutableArray *)arrayTitles {
//    if (!_arrayTitles) {
//        _arrayTitles = [NSMutableArray array];
//    }
//    return _arrayTitles;
//}
- (UIImageView *)bgmView {
    if (!_bgmView) {
        _bgmView = [[UIImageView alloc]init];
        _bgmView.image = [UIImage imageNamed:@"弹框-正常"];
        _bgmView.layer.masksToBounds = YES;
        _bgmView.userInteractionEnabled = YES;
        _bgmView.layer.cornerRadius = 6*frameSizeRate;
        [self addSubview:_bgmView];
        [_bgmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(340*KFitWidthRate, 378*KFitHeightRate));
        }];
    }
    return _bgmView;
}
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
        [self.bgmView addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgmView).with.offset(13 * KFitWidthRate);
            make.top.equalTo(self.bgmView).with.offset(6 * KFitHeightRate);
            make.height.mas_equalTo(50 * KFitHeightRate);
            make.right.equalTo(self.bgmView).with.offset(-12 * KFitWidthRate);
        }];
        kWeakSelf(self);
        [_titleView bk_whenTapped:^{
            [weakself didClickBtn:__CarPaoTitle_Title];
        }];
    }
    return _titleView;
}
- (UIScrollView *)middleView {
    if (!_middleView) {
        _middleView = [[UIScrollView alloc]init];
        _middleView.delegate = self;
        [self.bgmView addSubview:_middleView];
        [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgmView).with.offset(13 * KFitWidthRate);
            make.right.equalTo(self.bgmView).with.offset(-12 * KFitWidthRate);
            make.top.equalTo(self.titleView.mas_bottom).offset(0);
            make.height.mas_equalTo((245)*KFitHeightRate);
        }];
        _middleContentView = [UIView new];
        [_middleView addSubview:_middleContentView];
        [_middleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
            make.width.equalTo(_middleView);
        }];
        [_middleContentView bk_whenTapped:^{
            //加个点击事件。免得点击消失
            NSLog(@"加个点击事件。免得点击消失");
        }];
    }
    return _middleView;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        [self.bgmView addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_titleView);
            make.height.mas_equalTo(50 * KFitHeightRate);
            make.top.equalTo(_middleView.mas_bottom);
        }];
    }
    return _bottomView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [MINUtils createLabelWithText: @"2345" size:15*KFitHeightRate alignment: NSTextAlignmentLeft textColor: [UIColor whiteColor]];
        [self.titleView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleView).with.offset(15*KFitWidthRate);
            make.top.bottom.equalTo(_titleView);
            make.width.mas_equalTo(200*KFitWidthRate);
        }];
    }
    return _titleLabel;
}
- (UIImageView *)arrowView {
    if (!_arrowView) {
        UIImage *img = [UIImage imageNamed:@"右边"];
        _arrowView = [[UIImageView alloc] initWithImage:img];
        [self.titleView addSubview:_arrowView];
        [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.right.equalTo(@-10);
            make.size.mas_equalTo(img.size);
        }];
    }
    return _arrowView;
}
- (UIView *)createBtn:(NSString *)title img:(NSString *)imgName {
    UIView *view = [UIView new];
    UIImage *img = [UIImage imageNamed:imgName];
    UIImageView *imgv = [[UIImageView alloc] initWithImage:img];
    [view addSubview:imgv];
    UILabel *lbl = [MINUtils createLabelWithText:title size:14 alignment:NSTextAlignmentCenter textColor:UIColor.blackColor];
    [view addSubview:lbl];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.centerX.equalTo(@0);
        make.width.height.equalTo(@20);
        make.left.greaterThanOrEqualTo(@0);
        make.right.lessThanOrEqualTo(@0);
    }];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgv.mas_bottom).mas_offset(5);
        make.centerX.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.greaterThanOrEqualTo(@0);
        make.right.lessThanOrEqualTo(@0);
    }];
    
    UIView *containV = [UIView new];
    [containV addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(@0);
    }];
    kWeakSelf(self);
    [containV bk_whenTapped:^{
        [weakself didClickBtn:title];
    }];
    return containV;
}
//- (UIButton *)playBackBtn {
//    if (!_playBackBtn) {
//        _playBackBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"回放") titleColor: [UIColor whiteColor] fontSize:15 * KFitWidthRate];
//        [_playBackBtn setImage: [UIImage imageNamed: @"回放"] forState: UIControlStateNormal];
//        [_playBackBtn setImage: [UIImage imageNamed: @"回放"] forState: UIControlStateHighlighted];
//        [_playBackBtn horizontalCenterImageAndTitle:5];
//        [self.titleView addSubview:_playBackBtn];
//        [_playBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(_titleView);
//            make.right.equalTo(_titleView).with.offset(-40*KFitWidthRate);
//        }];
//        [_playBackBtn addTarget: self action:@selector(btnClickType:) forControlEvents: UIControlEventTouchUpInside];
//    }
//    return _playBackBtn;
//}
//- (UIButton *)deleteWarmBtn {
//    if (!_deleteWarmBtn) {
//        _deleteWarmBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"处理报警") titleColor: [UIColor whiteColor] fontSize:15 * KFitWidthRate];
//        _deleteWarmBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [_deleteWarmBtn setImage: [UIImage imageNamed: @"ic_handle_alarm"] forState: UIControlStateNormal];
//        [_deleteWarmBtn setImage: [UIImage imageNamed: @"ic_handle_alarm"] forState: UIControlStateHighlighted];
//        [_deleteWarmBtn horizontalCenterImageAndTitle:5*KFitWidthRate];
//        [self.titleView addSubview:_deleteWarmBtn];
//        [_deleteWarmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
//            make.left.mas_equalTo(self.titleLabel.mas_right).offset(0*KFitWidthRate);
//            make.height.mas_equalTo(20*KFitHeightRate);
//        }];
//        [_deleteWarmBtn addTarget: self action:@selector(btnClickType:) forControlEvents: UIControlEventTouchUpInside];
//    }
//    return _deleteWarmBtn;
//}
//- (UIButton *)closeBtn {
//    if (!_closeBtn) {
//        _closeBtn = [[UIButton alloc] init];
//        [_closeBtn setImage: [UIImage imageNamed: @"closeMain"] forState: UIControlStateNormal];
//        [_closeBtn setImage: [UIImage imageNamed: @"closeMain"] forState: UIControlStateHighlighted];
//        [_titleView addSubview: _closeBtn];
//        [self.titleView addSubview:_closeBtn];
//        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(_titleView);
//            make.right.equalTo(_titleView);
//            make.width.mas_equalTo(40*KFitWidthRate);
//        }];
//        [_closeBtn addTarget: self action: @selector(btnClickType:) forControlEvents: UIControlEventTouchUpInside];
//    }
//    return _closeBtn;
//}
//- (UIButton *)navigationBtn {
//    if (!_navigationBtn) {
//        _navigationBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"导航") titleColor: [UIColor whiteColor] fontSize:15*KFitWidthRate];
//        _navigationBtn.backgroundColor = kRGB(26, 151, 251);
//        [_navigationBtn setTitle:Localized(@"导航") forState:UIControlStateNormal];
//        [_navigationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_bottomView addSubview: _navigationBtn];
//        CGFloat width = [NSString getWidthWithText:Localized(@"导航") font:[UIFont systemFontOfSize:15*KFitWidthRate] height:30*KFitHeightRate];
//        [_navigationBtn addTarget: self action: @selector(btnClickType:) forControlEvents: UIControlEventTouchUpInside];
//        [_navigationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.bottomView.mas_right).offset(-15*KFitWidthRate);
//            make.size.mas_equalTo(CGSizeMake(width + 25*KFitWidthRate, 30*KFitHeightRate));
//            make.centerY.mas_equalTo(self.bottomView.mas_centerY);
//        }];
//    }
//    return _navigationBtn;
//}
- (void)setupMovePopView {
    [self addSubview:self.movePopView];
    [self.movePopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgmView.mas_bottom).mas_offset(-100);
//        make.right.equalTo(self.bgmView);
        make.centerX.equalTo(self.moveBtn);
        make.width.equalTo(self.moveBtn);
    }];
    self.movePopView.alpha = 0;
}
- (void)showMovePopView {
    [self.movePopView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgmView.mas_bottom).mas_offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        self.movePopView.alpha = 1;
    }];
}
- (void)hideMovePopView {
    [self.movePopView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgmView.mas_bottom).mas_offset(-100);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        self.movePopView.alpha = 0;
    }];
}
- (void)setupBottom {
    self.followBtn = [self createBtn:__CarPaoTitle_Track img:@"单次定位"];
    self.playBackBtn = [self createBtn:__CarPaoTitle_PlayBack img:@"回放"];
    self.moveBtn = [self createBtn:__CarPaoTitle_Move img:@"电子围栏-未点击"];
    [self.bottomView addSubview:self.followBtn];
    [self.bottomView addSubview:self.playBackBtn];
    [self.bottomView addSubview:self.moveBtn];
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(@0);
    }];
    [self.playBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(self.followBtn.mas_right);
        make.width.equalTo(self.followBtn);
    }];
    [self.moveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(self.playBackBtn.mas_right);
        make.width.equalTo(self.playBackBtn);
        make.right.equalTo(@0);
    }];
}
- (void)setupView {
    self.backgroundColor = UIColor.clearColor;//[UIColor colorWithHexString:@"#000000" alpha:0.5];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taphandle:)];
    [self addGestureRecognizer:gesture];
    
    [self bgmView];
    [self titleView];
    [self middleView];
    [self bottomView];
    
    [self titleLabel];
    [self arrowView];
    [self setupBottom];
    [self setupMovePopView];
//    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_titleView).with.offset(15 * KFitWidthRate);
//        make.top.bottom.equalTo(_titleView);
//        make.width.mas_equalTo(200 * KFitWidthRate);
//    }];
//    [self playBackBtn];
//    [self closeBtn];
//    [self navigationBtn];
    
    _lngLb = [self createLbTitle:@"经纬度:"];
    _statusLb = [self createLbTitle:@"状态:"];
    _cfLb = [self createLbTitle:@"撤防:开"];
    _accLb = [self createLbTitle:@"acc状态：关"];
    _doorLb = [self createLbTitle:@"门状态:关"];
    _electriLb = [self createLbTitle:@"电量:0"];
    _oilLb = [self createLbTitle:@"油量:0L 0%"];
    _sleepModelLb = [self createLbTitle:@"休眠模式：时间休眠"];
    _gsmNumberLb = [self createLbTitle:@"GSM:27"];
    _gpsNumberLb = [self createLbTitle:@"GPS:0颗"];
    _reportLb = [self createLbTitle:@"上报策略"];
    _warmTypeLb = [self createLbTitle:@"报警类型:8"];
    _timeLb = [self createLbTitle:@"上报时间:2020-05-18 13:35:32"];
    _addressLabel = [self createLbTitle:@"四川省成都市高新区长虹科技大厦"];
//    _latLb = [self createLbTitle:@"维度:"];
//    _speedLb = [self createLbTitle:@"速度:"];
//    _offlineTimeLb = [self createLbTitle:@"离线时长:0分"];
//    _stayTimeLb = [self createLbTitle:@"停留时长:0分"];
//    _stayCountLb = [self createLbTitle:@"停留次数:0分"];

    
//    _inElectriLb = [self createLbTitle:@"内电:关"];
//    _outElectriLb = [self createLbTitle:@"外电:开"];
    
//    _mileageLb = [self createLbTitle:@"当天里程:0km"];
//    _bfLb = [self createLbTitle:@"布防:开"];
    
//
//    _lowElectricWarmLb = [self createLbTitle:@"低电报警:开"];
//    _mqWarmLb = [self createLbTitle:@"盲区报警:开"];
//    _ddWarmLb = [self createLbTitle:@"掉电报警:开"];
//    _overSpeedWarmLb = [self createLbTitle:@"超速报警:开"];
//    _zdWarmLb = [self createLbTitle:@"振动报警:开"];
//    _yljcWarmLb = [self createLbTitle:@"油量检测报警:开"];
//    _gpsDriftLb = [self createLbTitle:@"GPS漂移抑制:开"];
//
//    _ydControlLb = [self createLbTitle:@"油电控制:开"];
//    _vibrationLb = [self createLbTitle:@"振动灵敏度:高"];
//    _accNoticeLb = [self createLbTitle:@"ACC工作通知:开"];
//    _timeZone = [self createLbTitle:@"终端时区:8"];
//

    
    
  
    
    
    
    NSArray *arrLb = @[_lngLb,_statusLb,_cfLb,_accLb,_doorLb,_electriLb,_oilLb,_sleepModelLb,_gsmNumberLb,_gpsNumberLb,_reportLb,_warmTypeLb,_timeLb,_addressLabel
//                       _latLb,_speedLb,_offlineTimeLb,_stayTimeLb,_stayCountLb,_doorLb,_accLb,_oilLb,_mileageLb,_inElectriLb,
//        _outElectriLb,_bfLb,_cfLb,_lowElectricWarmLb,_mqWarmLb,_ddWarmLb,_overSpeedWarmLb,_zdWarmLb,_yljcWarmLb,
//                             _gpsDriftLb,_ydControlLb,_vibrationLb,_accNoticeLb,_timeZone,_sleepModelLb,_gpsNumberLb,_gsmNumberLb,_timeLb,_addressLabel
    ];//_warmTypeLb
    [self restMutableArray:self.arrayLb addFromArray:arrLb];
    
    //同一行的放里面(不换行）
    NSArray *sameLineLb = @[
        _accLb,_doorLb,_oilLb,_gsmNumberLb,_gpsNumberLb
    ];

//    NSArray *arrT = @[@"经纬度:",
////                      @"纬度:",@"速度:",@"离线时长:0分",@"停留时长:0分",@"停留次数:0分",@"门状态:关",@"acc状态：关",@"油量:0L 0%",@"当天里程:0km",@"内电:关",@"外电:开",@"布防:开",@"撤防:开",@"低电报警:开",@"盲区报警:开",@"掉电报警:开",@"超速报警:开",@"振动报警:开",@"油量检测报警:开",@"GPS漂移抑制:开",@"油电控制:开",@"振动灵敏度:高",@"ACC工作通知:开",@"终端时区:8",@"休眠模式：时间休眠",@"GPS:0颗",@"GSM:27",@"上报时间:2020-05-18 13:35:32",@"四川省成都市高新区长虹科技大厦"
//    ];//@"报警类型:8"
//    [self restMutableArray:self.arrayTitles addFromArray:arrT];
    
//    // 地址lb换行，即在它这插个空
//    [self insertArrLbAndArrTitle:self.arrayTitles.count-1];
    // 获取subView frame
    [self.bgmView layoutIfNeeded];
    UILabel *lastLbl = nil;
    for (int i = 0; i < self.arrayLb.count ; i ++) {
        UILabel *lb = self.arrayLb[i];
//        lb.text = self.arrayTitles[i];
        [self.middleContentView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([sameLineLb containsObject:lb]) {
                make.left.equalTo(lastLbl.mas_right).mas_offset(3);
                make.top.equalTo(lastLbl);
                return;;
            }
            make.left.equalTo(@10);
            if (lastLbl) {
                make.top.equalTo(lastLbl.mas_bottom).mas_offset(10);
            } else {
                make.top.equalTo(@10);
            }
        }];
        lastLbl = lb;
//        if (i%2 == 0 && i != 0) {
//            // 第二个起，偶数(即左边)，k加1(即y坐标下移)
//            k ++;
//        }
//        CGFloat rate_y = 20*KFitHeightRate*k;
//        CGFloat rate_x = i%2;
//        lb.frame = CGRectMake(20*KFitWidthRate + rate_x*CGRectGetWidth(self.middleView.frame)/2, rate_y, 340*KFitWidthRate, 20*KFitHeightRate);
    }
    [lastLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.width.equalTo(self.middleView).mas_offset(-20);
    }];
}
- (void)insertArrLbAndArrTitle:(NSInteger)index {
    [self.arrayLb insertObject:[self createLbTitle:@""] atIndex:index];
//    [self.arrayTitles insertObject:@"" atIndex:index];
}
- (void)restMutableArray:(NSMutableArray *)mutableArray addFromArray:(NSArray *)array {
    [mutableArray removeAllObjects];
    [mutableArray addObjectsFromArray:array];
}
- (void)setupView_warmed {
    self.backgroundColor = UIColor.clearColor;//[UIColor colorWithHexString:@"#000000" alpha:0.5];
    
    [self bgmView];
    self.bgmView.image = [UIImage imageNamed:@"弹框-报警"];
    [self titleView];
    [self middleView];
    [self bottomView];
    
    [self titleLabel];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleView).with.offset(15 * KFitWidthRate);
        make.top.bottom.equalTo(_titleView);
        make.height.mas_equalTo(50*KFitHeightRate);
    }];
//    [self deleteWarmBtn];
//    [self playBackBtn];
//    [self closeBtn];
//    [self navigationBtn];
    
    _lngLb = [self createLbTitle:@"经度:"];
//    _latLb = [self createLbTitle:@"维度:"];
//    _speedLb = [self createLbTitle:@"速度:"];
//    _offlineTimeLb = [self createLbTitle:@"离线时长:0分"];
//    _stayTimeLb = [self createLbTitle:@"停留时长:0分"];
//    _stayCountLb = [self createLbTitle:@"停留次数:0分"];
//    _doorLb = [self createLbTitle:@"门状态:关"];
//    _accLb = [self createLbTitle:@"acc状态：关"];
//    _inElectriLb = [self createLbTitle:@"内电:关"];
//    _outElectriLb = [self createLbTitle:@"外电:开"];
//    _oilLb = [self createLbTitle:@"油量:0L 0%"];
//    _mileageLb = [self createLbTitle:@"当天里程:0km"];
//    _bfLb = [self createLbTitle:@"布防:开"];
//    _cfLb = [self createLbTitle:@"撤防:开"];
//
//    _lowElectricWarmLb = [self createLbTitle:@"低电报警:开"];
//    _mqWarmLb = [self createLbTitle:@"盲区报警:开"];
//    _ddWarmLb = [self createLbTitle:@"掉电报警:开"];
//    _overSpeedWarmLb = [self createLbTitle:@"超速报警:开"];
//    _zdWarmLb = [self createLbTitle:@"振动报警:开"];
//    _yljcWarmLb = [self createLbTitle:@"油量检测报警:开"];
//    //_fenceStatusLb = [self createLbTitle:@"电子围栏:进/出"];
//    _gpsDriftLb = [self createLbTitle:@"GPS漂移抑制:开"];
//
//    _ydControlLb = [self createLbTitle:@"油电控制:开"];
//    _vibrationLb = [self createLbTitle:@"振动灵敏度:高"];
//    _accNoticeLb = [self createLbTitle:@"ACC工作通知:开"];
//    _timeZone = [self createLbTitle:@"终端时区:8"];
//
//    _sleepModelLb = [self createLbTitle:@"休眠模式：时间休眠"];
//    _gpsNumberLb = [self createLbTitle:@"GPS:0颗"];
//    _gsmNumberLb = [self createLbTitle:@"GSM:27"];
//    _warmTypeLb = [self createLbTitle:@"报警类型:8"];
//    _timeLb = [self createLbTitle:@"上报时间:2020-05-18 13:35:32"];
//    _addressLabel = [self createLbTitle:@"四川省成都市高新区长虹科技大厦"];
    
    NSArray *arrLb = @[_lngLb,
//                       _latLb,_speedLb,_offlineTimeLb,_stayTimeLb,_stayCountLb,_doorLb,_accLb,_oilLb,_mileageLb,_inElectriLb,
//        _outElectriLb,_bfLb,_cfLb,_lowElectricWarmLb,_mqWarmLb,_ddWarmLb,_overSpeedWarmLb,_zdWarmLb,_yljcWarmLb,
//                             _gpsDriftLb,_ydControlLb,_vibrationLb,_accNoticeLb,_timeZone,_sleepModelLb,_gpsNumberLb,_gsmNumberLb,_warmTypeLb,_timeLb,_addressLabel
    ];
    [self restMutableArray:self.arrayLb addFromArray:arrLb];

//    NSArray *arrT = @[@"经纬度:",
////                      @"纬度:",@"速度:",@"离线时长:0分",@"停留时长:0分",@"停留次数:0分",@"门状态:关",@"acc状态：关",@"油量:0L 0%",@"当天里程:0km",@"内电:关",@"外电:开",@"布防:开",@"撤防:开",@"低电报警:开",@"盲区报警:开",@"掉电报警:开",@"超速报警:开",@"振动报警:开",@"油量检测报警:开",@"GPS漂移抑制:开",@"油电控制:开",@"振动灵敏度:高",@"ACC工作通知:开",@"终端时区:8",@"休眠模式：时间休眠",@"GPS:0颗",@"GSM:27",@"报警类型:8",@"上报时间:2020-05-18 13:35:32",@"四川省成都市高新区长虹科技大厦"
//    ];
//    [self restMutableArray:self.arrayTitles addFromArray:arrT];

//    // 上报时间lb换行，即在它这插个空
//    [self insertArrLbAndArrTitle:self.arrayTitles.count-2];
//    // 地址lb换行，即在它这插个空
//    [self insertArrLbAndArrTitle:self.arrayTitles.count-1];
    /* 获取subView frame*/
    [self.bgmView layoutIfNeeded];
    
    for (int i = 0 ,k = 0; i < self.arrayLb.count ; i ++) {
        UILabel *lb = self.arrayLb[i];
//        lb.text = self.arrayTitles[i];
        [self.middleView addSubview:lb];
//        if (i%2 == 0 && i != 0) {
//            // 偶数，左边
//            k ++;
//        }
//        CGFloat rate_y = 20*KFitHeightRate*k;
//        CGFloat rate_x = i%2;
//        lb.frame = CGRectMake(20*KFitWidthRate + rate_x*CGRectGetWidth(self.middleView.frame)/2, rate_y, 340*KFitWidthRate, 20*KFitHeightRate);
//        //报警-设备列表
//        if ([self.arrayTitles[i] isEqualToString:@"报警类型:8"]) {
//            UIImage *alarmImage = [UIImage imageNamed:@"报警"];
//            UIImageView *alarmImageV = UIImageView.alloc.init;
//            alarmImageV.frame = CGRectMake(20*KFitWidthRate + rate_x*CGRectGetWidth(self.middleView.frame)/2, rate_y + (20*KFitHeightRate-alarmImage.size.height)/2, alarmImage.size.width, alarmImage.size.height);
//            lb.frame = CGRectMake(20*KFitWidthRate + rate_x*CGRectGetWidth(self.middleView.frame)/2 + alarmImage.size.width + 5, rate_y, 140*KFitWidthRate, 20*KFitHeightRate);\
//            alarmImageV.image = alarmImage;
//            [self.middleView addSubview:alarmImageV];
//        }
    }
//    /* 滚动到底部*/
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.middleView setContentOffset:CGPointMake(0, self.middleView.contentSize.height - self.middleView.bounds.size.height)];
//    });
}
- (UILabel *)createLbTitle:(NSString *)text {
    UILabel *label = [MINUtils createLabelWithText:text size:10*KFitHeightRate alignment:NSTextAlignmentLeft textColor: k137Color];
    label.numberOfLines = 0;
    return label;
}
#pragma mark -- button点击事件
- (void)didClickBtn:(NSString *)title {
    NSLog(@"%@", title);
    if ([title isEqualToString:__CarPaoTitle_Title]) {
        if (self.clickBlock) {
            self.clickBlock(CBCarPaopaoViewClickTypeTitle, self.dno);
        }
    }
    if ([title isEqualToString:__CarPaoTitle_Track]) {
        if (self.clickBlock) {
            self.clickBlock(CBCarPaopaoViewClickTypeTrack, self.dno);
        }
    }
    if ([title isEqualToString:__CarPaoTitle_PlayBack]) {
        if (self.clickBlock) {
            self.clickBlock(CBCarPaopaoViewClickTypePlayBack, self.dno);
        }
    }
    if ([title isEqualToString:__CarPaoTitle_Move]) {
        if (self.movePopView.alpha == 0) {
            [self showMovePopView];
        }
    }
}
- (void)didClickMove:(NSString *)title {
    NSLog(@"%@", title);
    if ([title containsString:@"200"]) {
        if (self.didClickMove) {
            self.didClickMove(@"200");
        }
    }
    if ([title containsString:@"500"]) {
        if (self.didClickMove) {
            self.didClickMove(@"500");
        }
    }
    if ([title containsString:@"1000"]) {
        if (self.didClickMove) {
            self.didClickMove(@"1000");
        }
    }
    [self hideMovePopView];
}
- (void)btnClickType:(UIButton *)sender {
//    if ([sender isEqual:self.playBackBtn]) {
//        if (self.clickBlock) {
//            self.clickBlock(CBCarPaopaoViewClickTypePlayBack, self.dno);
//        }
//    } else
//    if ([sender isEqual:self.deleteWarmBtn]) {
//        if (self.clickBlock) {
//            self.clickBlock(CBCarPaopaoViewClickTypeDeleteWarm, self.dno);
//        }
//    } else
//        if ([sender isEqual:self.closeBtn]) {
//        self.isAlertPaopaoView = NO;
//        if (self.clickBlock) {
//            self.clickBlock(CBCarPaopaoViewClickTypeClose, self.dno);
//        }
//        [self dismiss];
//    } else
//    if ([sender isEqual:self.navigationBtn]) {
//        if (self.clickBlock) {
//            self.clickBlock(CBCarPaopaoViewClickTypeNavigationClick, self.dno);
//        }
//    }
}
- (void)setAlertStyleIsWarmed:(BOOL)isWarmed {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self toEmpty];
//    if (isWarmed) {
//        [self setupView_warmed];
//    } else {
    [self setupView];
//    }
}
- (void)toEmpty {
    _bgmView = nil;
    _titleView = nil;
    _middleView = nil;
    _bottomView = nil;
    _titleLabel = nil;
    _arrowView = nil;
//    _deleteWarmBtn = nil;
//    _playBackBtn = nil;
//    _closeBtn = nil;
//    _navigationBtn = nil;
}
- (void)taphandle:(UITapGestureRecognizer*)tap {
    if (self.clickBlock) {
        self.clickBlock(CBCarPaopaoViewClickTypeTap, @"");
    }
    [self dismiss];
}
- (void)popView {
    self.isAlertPaopaoView = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)dismiss {
    if (self.movePopView.alpha == 1) {
        [self hideMovePopView];
        return;
    }
    self.isAlertPaopaoView = NO;
    [self removeFromSuperview];
}
- (void)setDeviceInfoModel:(CBHomeLeftMenuDeviceInfoModel *)deviceInfoModel {
    _deviceInfoModel = deviceInfoModel;
    if (_deviceInfoModel) {
        _titleLabel.text = [NSString stringWithFormat:@"%@",kStringIsEmpty(_deviceInfoModel.carNum)?Localized(@"未知"):_deviceInfoModel.name];
        
        _lngLb.attributedText = [self getAttStr:Localized(@"经纬度:") content:[NSString stringWithFormat:@"%@, %@", _deviceInfoModel.lng, _deviceInfoModel.lat]];
        
        _statusLb.attributedText = [self getAttStr:Localized(@"状态:")
                                           content:
                                    _deviceInfoModel.devStatus.intValue==1?@"行驶中":
                                    _deviceInfoModel.devStatus.intValue==2?@"静止":@"未启用"];
        _cfLb.attributedText = [self getAttStr:Localized(@"设备:")
                                       content:
                                _deviceInfoModel.cfbf.intValue == 0 ? Localized(@"撤防") : Localized(@"布防")];
        _accLb.attributedText = [self getAttStr:Localized(@"ACC状态:") content:[self returnStatus:_deviceInfoModel.acc]];
        _doorLb.attributedText = [self getAttStr:Localized(@"门状态:") content:[self returnStatus:_deviceInfoModel.door]];
        _electriLb.attributedText = [self getAttStr:Localized(@"电量:") content:_deviceInfoModel.battery  ? [_deviceInfoModel.battery stringByAppendingString:@"%"] : @"0%"];
        _oilLb.attributedText = [self getAttStr:Localized(@"油量:") content:[NSString stringWithFormat:@"%@L %@%@",_deviceInfoModel.oil,_deviceInfoModel.oil_prop,@"%"]];

        _sleepModelLb.attributedText = [self getAttStr:Localized(@"休眠模式:") content:[self returnSleepModel:_deviceInfoModel.restMod]];
        _gsmNumberLb.attributedText = [self getAttStr:@"GSM:" content:deviceInfoModel.gsm.intValue >= 15 ? Localized(@"强") : Localized(@"弱")];
        _gpsNumberLb.attributedText = [self getAttStr:@"GPS:" content:[NSString stringWithFormat:@"%@",(deviceInfoModel.gps.intValue >= 4 ? Localized(@"强") : Localized(@"弱"))]];
        _reportLb.attributedText = [self getAttStr:Localized(@"上报策略:") content:@"xxx"];
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
        _warmTypeLb.attributedText = [self getAttStr:Localized(@"报警类型:") content:warmTypeStr contentColor:UIColor.redColor];
        
        NSString *createTimeStr = [Utils convertTimeWithTimeIntervalString:deviceInfoModel.createTime?:@"" timeZone:deviceInfoModel.timeZone?:@""];
        _timeLb.attributedText = [self getAttStr:Localized(@"上报时间:") content:createTimeStr];
        _addressLabel.attributedText = [self getAttStr:Localized(@"地址:") content:deviceInfoModel.address?:@"未知"];
    }
}


- (NSAttributedString *)getAttStr:(NSString *)title
                          content:(NSString *)content {
    return [self getAttStr:title content:content contentColor:nil];
}

- (NSAttributedString *)getAttStr:(NSString *)title
                          content:(NSString *)content
                     contentColor:(nullable UIColor *)contentColor{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", title, content]];
    [str setAttributes:@{
        NSForegroundColorAttributeName: contentColor ?: UIColor.blackColor,
        NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightRegular]
    } range:NSMakeRange(0, str.length)];
    [str setAttributes:@{
        NSForegroundColorAttributeName: UIColor.blackColor,
        NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightBold]
    } range:NSMakeRange(0, title.length)];
    return str;
}

- (NSString *)returnSensitivity:(NSString *)str {
    if ([str isEqualToString:@"1"]) {
        return Localized(@"高");
    } else if ([str isEqualToString:@"2"]) {
        return Localized(@"中");
    } else if ([str isEqualToString:@"3"]) {
        return Localized(@"低");
    }
    return Localized(@"未知");
}
- (NSString *)returnStatus:(NSString *)str {
    if ([str isEqualToString:@"0"]) {
        return Localized(@"关");
    } else if ([str isEqualToString:@"1"]) {
        return Localized(@"开");
    }
    return Localized(@"未知");
}
- (NSString *)returnDyddStatus:(NSString *)str {
    if ([str isEqualToString:@"0"]) {
        return Localized(@"恢复油电");//Localized(@"断开油电");
    } else if ([str isEqualToString:@"1"]) {
        return Localized(@"断开油电");
    }
    return Localized(@"恢复油电");
}
- (NSString *)returnSleepModel:(NSString *)str {
    //0-长在线，1-时间休眠，2-振动休眠，3-深度振动休眠，4-定时报告，5-深度振动+定时报告休眠
    if ([str isEqualToString:@"0"]) {
        return Localized(@"长在线");
    } else if ([str isEqualToString:@"1"]) {
        return Localized(@"时间休眠");
    } else if ([str isEqualToString:@"2"]) {
        return Localized(@"振动休眠");
    } else if ([str isEqualToString:@"3"]) {
        return Localized(@"深度振动休眠");
    } else if ([str isEqualToString:@"4"]) {
        return Localized(@"定时报告");
    } else if ([str isEqualToString:@"5"]) {
        return Localized(@"深度振动+定时报告休眠");
    }
    return Localized(@"未知");
}
- (NSString *)returnWarmDescriptionType:(NSString *)status {
    NSDictionary *dic = @{
    @"0":Localized(@"SOS报警"),
    @"1":Localized(@"超速报警"),
    @"2":Localized(@"疲劳驾驶"),
    @"3":Localized(@"未按时到家"),
    @"4":Localized(@"GNSS发生故障"),
    @"5":Localized(@"GNSS天线被剪或未接"),
    @"6":Localized(@"轮动报警"),
    @"7":Localized(@"低电报警"),
    @"8":Localized(@"外电断电报警"),
    @"9":Localized(@"区域超速报警"),
    @"10":Localized(@"拆除报警"),
    @"11":Localized(@"摄像头故障"),
    @"12":Localized(@"震动报警"),
    @"13":Localized(@"超速报警"),
    @"14":Localized(@"疲劳驾驶报警"),
    @"15":Localized(@"非法移位报警"),
    @"16":Localized(@"非法点火报警"),
    @"17":Localized(@"非法开门报警"),
    @"18":Localized(@"当天累计驾驶超时报警"),
    @"25":Localized(@"偷油/漏油报警"),
    @"26":Localized(@"温度异常报警"),
    @"27":Localized(@"碰撞报警"),
    @"28":Localized(@"侧翻报警"),
    @"32":Localized(@"出围栏报警"),
    @"33":Localized(@"入围栏报警"),
    };

    return dic[status] ?: Localized(@"未知");
}
//#pragma mark -- UIGestureRecognizer
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if ( CGRectContainsPoint(self.bgmView.frame, [gestureRecognizer locationInView:self])) {
//        return NO;
//    } else {
//        return YES;
//    }
//    return YES;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
