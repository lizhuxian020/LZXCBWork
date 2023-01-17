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
#define __CarPaoTitle_EndTrack Localized(@"停止追踪")
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
@property (nonatomic, strong) UIImageView *followImgView;
@property (nonatomic, strong) UILabel *followLbl;
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
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didGetMQTT) name:@"CBCAR_NOTFICIATION_GETMQTT" object:nil];
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
            make.size.mas_equalTo(CGSizeMake(300, 378));
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
            make.height.mas_equalTo(50);
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
        _middleView.alwaysBounceHorizontal = NO;
        _middleView.bounces = NO;
        _middleView.delegate = self;
        [self.bgmView addSubview:_middleView];
        [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgmView).with.offset(13 * KFitWidthRate);
            make.right.equalTo(self.bgmView).with.offset(-12 * KFitWidthRate);
            make.top.equalTo(self.titleView.mas_bottom).offset(0);
//            make.height.mas_equalTo((245)*KFitHeightRate);
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
        _bottomView.backgroundColor = kRGB(247,247,247);
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@6);
            make.right.equalTo(@-5);
            make.height.mas_equalTo(50);
            make.top.equalTo(_middleView.mas_bottom);
            make.bottom.equalTo(@-20);
        }];
    }
    return _bottomView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [MINUtils createLabelWithText: @"2345" size:16 alignment: NSTextAlignmentLeft textColor: kCellTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
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
    if ([imgName isEqualToString:@"单次定位"]) {
        self.followImgView = imgv;
        self.followLbl = lbl;
    }
    return containV;
}
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
    
}
- (void)setupMiddleContentView {
    [self.middleContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *arrLbl = [NSMutableArray arrayWithArray:@[_lngLb,_statusLb,_cfLb,_accLb,_doorLb,_electriLb,_oilLb,_sleepModelLb,_gsmNumberLb,_gpsNumberLb,_reportLb,_warmTypeLb,_timeLb,_addressLabel]];
    [CBDeviceTool.shareInstance getPaoViewConfig:_deviceInfoModel blk:^(NSDictionary * _Nonnull configData) {
        BOOL cfbf = [configData[@"cfbf"] boolValue];
        BOOL acc = [configData[@"acc"] boolValue];
        BOOL tank = [configData[@"tank"] boolValue];
        if (!cfbf) {
            [arrLbl removeObject:_cfLb];
        }
        if (!acc) {
            [arrLbl removeObject:_accLb];
            [arrLbl removeObject:_doorLb];
        }
        if (!tank) {
            [arrLbl removeObject:_oilLb];
        }
    }];
    
    [self restMutableArray:self.arrayLb addFromArray:arrLbl];
    
    //同一行的放里面(不换行）
    NSArray *sameLineLb = @[
        _accLb,_doorLb,_oilLb,_gpsNumberLb
    ];

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
    }
    [lastLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-20);
        make.width.equalTo(self.middleView).mas_offset(-20);
    }];
    [_lngLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-5);
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
            self.clickBlock(CBCarPaopaoViewClickTypeTitle, self.deviceInfoModel);
        }
    }
    if ([title isEqualToString:__CarPaoTitle_Track]) {
        if (self.clickBlock) {
            self.clickBlock(CBCarPaopaoViewClickTypeTrack, self.deviceInfoModel);
        }
    }
    if ([title isEqualToString:__CarPaoTitle_PlayBack]) {
        if (self.clickBlock) {
            self.clickBlock(CBCarPaopaoViewClickTypePlayBack, self.deviceInfoModel);
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
            self.didClickMove(@"200", self.deviceInfoModel);
        }
    }
    if ([title containsString:@"500"]) {
        if (self.didClickMove) {
            self.didClickMove(@"500", self.deviceInfoModel);
        }
    }
    if ([title containsString:@"1000"]) {
        if (self.didClickMove) {
            self.didClickMove(@"1000", self.deviceInfoModel);
        }
    }
    if ([title containsString:Localized(@"取消")]) {
        if (self.didClickMove) {
            self.didClickMove(@"0", self.deviceInfoModel);
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
- (void)didGetMQTT {
    if (_deviceInfoModel) {
        [self setDeviceInfoModel:_deviceInfoModel];
    }
}
- (void)setDeviceInfoModel:(CBHomeLeftMenuDeviceInfoModel *)deviceInfoModel {
    _deviceInfoModel = deviceInfoModel;
    [self setupMiddleContentView];
    if (_deviceInfoModel) {
        _followImgView.image = deviceInfoModel.isTracking ? [UIImage imageNamed:@"跟踪-选中"] : [UIImage imageNamed:@"单次定位"];
        _followLbl.text = deviceInfoModel.isTracking ? __CarPaoTitle_EndTrack : __CarPaoTitle_Track;
        NSString *devModel = ([deviceInfoModel.devModel isEqualToString:@"(null)"] || kStringIsEmpty(deviceInfoModel.devModel)) ? [CBDeviceTool.shareInstance getProductSpec:deviceInfoModel] : deviceInfoModel.devModel;
        _titleLabel.text = [NSString stringWithFormat:@"%@",kStringIsEmpty(_deviceInfoModel.name)?Localized(@"未知"):
                            [_deviceInfoModel.name stringByAppendingFormat:@"(%@)", devModel]];
        
        _lngLb.attributedText = [self getAttStr:Localized(@"经纬度:") content:[NSString stringWithFormat:@"%.6f, %.6f", _deviceInfoModel.lng.doubleValue, _deviceInfoModel.lat.doubleValue]];
        
        _statusLb.attributedText = [self getAttStr:Localized(@"状态:")
                                           content:[self getStatusString:_deviceInfoModel]];
        _cfLb.attributedText = [self getAttStr:Localized(@"设备:")
                                       content:
                                _deviceInfoModel.cfbf.intValue == 0 ? Localized(@"撤防") : Localized(@"布防")];
        _accLb.attributedText = [self getAttStr:Localized(@"ACC:") content:[self returnStatus:_deviceInfoModel.acc]];
        _doorLb.attributedText = [self getAttStr:Localized(@"门:") content:[self returnStatus:_deviceInfoModel.door]];
        _electriLb.attributedText = [self getAttStr:Localized(@"电量:") content:_deviceInfoModel.battery  ? [_deviceInfoModel.battery stringByAppendingString:@"%"] : @"0%"];
        _oilLb.attributedText = [self getAttStr:Localized(@"油量:") content:[NSString stringWithFormat:@"%@L %@%@",_deviceInfoModel.oil,_deviceInfoModel.oil_prop,@"%"]];

        _sleepModelLb.attributedText = [self getAttStr:Localized(@"休眠模式:") content:[self returnSleepModel:_deviceInfoModel.restMod]];
        _gsmNumberLb.attributedText = [self getAttStr:@"GSM:" content:deviceInfoModel.gsm.intValue >= 15 ? Localized(@"强") : Localized(@"弱")];
        _gpsNumberLb.attributedText = [self getAttStr:@"GPS:" content:[NSString stringWithFormat:@"%@",(deviceInfoModel.gps.intValue >= 4 ? Localized(@"强") : Localized(@"弱"))]];
        _reportLb.attributedText = [self getAttStr:Localized(@"上报策略:") content:[self getReportString:deviceInfoModel]];
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
        _warmTypeLb.attributedText = [self getAttStr:Localized(@"报警类型:") content:kStringIsEmpty(warmTypeStr) ? Localized(@"无报警") : warmTypeStr contentColor:UIColor.redColor];
        
        NSString *createTimeStr = [Utils convertTimeWithTimeIntervalString:deviceInfoModel.createTime?:@"" timeZone:deviceInfoModel.timeZone?:@""];
        _timeLb.attributedText = [self getAttStr:Localized(@"上报时间:") content:createTimeStr];
        _addressLabel.attributedText = [self getAttStr:Localized(@"地址:") content:deviceInfoModel.address?:@"未知"];
    }
}


/*
 只有上线后才会收到code=21的推送
 一个完整的流程就是 先上线 然后上报位置（其中会产生不同的设备状态） 最后离线

 先收到code=6的推送 把图标和状态由离线更新成在线（静止类型图标）
 之后会到code=21的推送 把图标和状态由离线更新根据devstats判断展示（判断展示类型图标）
 最后会到code=1的推送代表设备离线状态更改为离线（离线类型图标）
 
 停留时间=当前时间戳-stopTime  再把停留时间显示成天 时 分
 例如  当前时间戳=1671589173000（ms）  stopTime=1671587742000(ms)

      把结果再转成天时分，先判断天 如果有天就显示几天 例如： 7天+
      不够1天 就显示小时  例如8小时
       不够1时 就显示分  例如8分
       不够1分 就显示秒  例如8秒
 停留时间 =1671589173000-1671587742000=1431000ms =1431s =23.85分有小数点就显示显示+       这个的话就是23分+

 */
- (NSString *)getStatusString:(CBHomeLeftMenuDeviceInfoModel *)model {
    if (model.mqttCode > 0) {
        if (model.mqttCode == 1) {
            return Localized(@"离线");
        }
        if (model.mqttCode == 6) {
            return Localized(@"静止");
        }
        if (model.mqttCode == 21) {
            NSString *appendTime = @"";
            if (!kStringIsEmpty(model.stopTime)) {
                NSTimeInterval currentTime = NSDate.date.timeIntervalSince1970 * 1000;
                NSTimeInterval stopTime = model.stopTime.doubleValue;
                if (currentTime > stopTime) {
                    NSTimeInterval duringTime = currentTime - stopTime;
                    appendTime = [self getTime:(duringTime / 1000) needAdd:YES];
                }
            }
            NSString *movingString = [NSString stringWithFormat:@"%@(%@km/h),%@(%@°)", Localized(@"速度"),model.speedInMqtt, Localized(@"方向"), model.directInMqtt];
            return model.devStatusInMQTT.intValue==0?Localized(@"未启用"):
            model.devStatusInMQTT.intValue==1?Localized(@"静止"):
            model.devStatusInMQTT.intValue==2?movingString:
            model.devStatusInMQTT.intValue==3?Localized(@"报警"):
            model.devStatusInMQTT.intValue==4?
            [Localized(@"停留") stringByAppendingFormat:@" %@", appendTime]:
            Localized(@"未知");
        }
    } else if (!kStringIsEmpty(model.online)) {
        return
        model.online.intValue==0?Localized(@"离线"):Localized(@"静止");
    }
    return Localized(@"未知");
}

- (NSString *)getReportString:(CBHomeLeftMenuDeviceInfoModel *)model {
    if (!kStringIsEmpty(model.reportWay)) {
        if (model.reportWay.intValue == 0) {
            return [NSString stringWithFormat:@"%@ %@, %@ %@", Localized(@"静止"), [self getTime:model.timeRest.intValue needAdd:NO], Localized(@"运动"), [self getTime:model.timeQs.intValue needAdd:NO]];
        }
        if (model.reportWay.intValue == 2) {
            return [NSString stringWithFormat:@"%@ %@, %@ %@%@", Localized(@"静止"), [self getTime:model.timeRest.intValue needAdd:NO], Localized(@"运动"), model.disQs, Localized(@"米")];
        }
    }
    return Localized(@"未知");
}

- (NSString *)getTime:(int)sec needAdd:(BOOL)needAdd{
    NSArray *secData= @[@"s", @"min", @"h", @"d"];
    int num, uidx;
    BOOL isHasAdd = NO;
    if (sec >= (60 * 60 * 24)) {
        uidx = 3;
        num = sec / (60 * 60 * 24);
        double pointValue = sec * 1.0f / (60.0f * 60 * 24.0f);
        isHasAdd = pointValue > num;
    } else if (sec >= (60 * 60)) {
        uidx = 2;
        num = sec / (60 * 60);
        double pointValue = sec * 1.0f / (60.0f * 60);
        isHasAdd = pointValue > num;
    } else if (sec >= (60)) {
        uidx = 1;
        num = sec / (60 );
        double pointValue = sec * 1.0f / (60.0f);
        isHasAdd = pointValue > num;
    } else {
        uidx = 0;
        num = sec;
    }
    return [NSString stringWithFormat:@"%d%@%@", num, secData[uidx], isHasAdd && needAdd ? @"+" : @""];
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
