//
//  CBWtHomeViewController.m
//  Watch
//
//  Created by lym on 2018/2/5.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "CBWtHomeViewController.h"
#import "MINImageTextBtn.h"
#import "HomeWatchInfoView.h"
#import "FunctionViewController.h"
#import "PersonalViewController.h"
#import "NotifactionCenterViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <GoogleMaps/GoogleMaps.h>
#import "HomeModel.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "CBWtNormalAnnotation.h"
#import "HomeLocationViewController.h"

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "CBAvatarAnnotationView.h"
#import "CBAvatarMarkView.h"
#import "CBHomeTalkViewController.h"
#import "CBScanAddWatchViewController.h"

#import "CBHomeBindWatchView.h"
#import "CBHomeBindReusltView.h"
#import "CBTalkModel.h"
#import "MessageModel.h"

#import "CBChatFMDBManager.h"
#import "CBTalkListViewController.h"
#import "SwitchWatchViewController.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

@interface CBWtHomeViewController () <BMKMapViewDelegate, GMSMapViewDelegate, BMKGeoCodeSearchDelegate,CLLocationManagerDelegate>
/** 头像view */
@property (nonatomic,strong) UIImage *avatarImg;
@property (nonatomic,strong) UIView *customerAvatarView;
@property (nonatomic,strong) UIImageView *avtarImgView;
@property (nonatomic,strong) UILabel *userNameLb;
/** 顶部状态view */
@property (nonatomic, strong) UIView *statusView;
/** 底部菜单设备信息view */
@property (nonatomic, strong) HomeWatchInfoView *homeInfoView;
/** 底部菜单view */
@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) MINImageTextBtn *locationBtn;
@property (nonatomic, strong) MINImageTextBtn *phoneBtn;
@property (nonatomic, strong) MINImageTextBtn *chatBtn;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *powerBtn;
@property (nonatomic, strong) UIButton *functionBtn;
@property (nonatomic, strong) BMKMapView *baiduMapView;
@property (nonatomic, strong) GMSMapView *googleMapView;
@property (nonatomic, strong) UIView *baiduView;
@property (nonatomic, strong) UIView *googleView;
@property (nonatomic, strong) HomeModel *homeInfoModel;
@property (nonatomic, strong) BMKGeoCodeSearch *searcher;
@property (nonatomic, strong) MBProgressHUD *dataHud;

/** 绑定手表view */
@property (nonatomic,strong) CBHomeBindWatchView *bindWatchView;
/** 绑定手表申请已提交view */
@property (nonatomic,strong) CBHomeBindReusltView *bindResultWatchView;

@property (nonatomic, strong) CLLocationManager *locationManager;
/** google地图标注图 */
@property (nonatomic,strong) CBAvatarMarkView *avtarMarkView;
/** 定时器刷新 */
@property (nonatomic,strong) NSTimer *timerRefreshData;

@end

@implementation CBWtHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [_baiduMapView viewWillAppear];
    _baiduMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

    // 开始/继续定时器
    [self resumeTimer_notice];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [_baiduMapView viewWillDisappear];
    _baiduMapView.delegate = nil; // 不用时，置nil
    
    // 暂停定时器
    [self pauseTimer_notice];
    
    [[CBPetTopSwitchBtnView share] removeView];
    [[CBPetBottomSwitchBtnView share] removeView];
}
- (void)dealloc {
    [self.timerRefreshData invalidate];
    self.timerRefreshData = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initBarWithTitle:@"" isBack:NO];
    
    [self setupView];
}
- (void)start_reloadData {
    if (!self.timerRefreshData) {
        self.timerRefreshData = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(timer_reload) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timerRefreshData forMode:NSRunLoopCommonModes];
    }
    // 判断当前地区是国内还是国外
    [self showMyLoaction];
}
#pragma mark -- 20s 刷一次数据
- (void)timer_reload {
    [self showMyLoaction];
}
// 暂停
- (void)pauseTimer_notice {
    if (!self.timerRefreshData) {
        return ;
    }
    [self.timerRefreshData setFireDate:[NSDate distantFuture]];//很远的将来
}
// 继续
- (void)resumeTimer_notice {
    if (!self.timerRefreshData) {
        [self start_reloadData];
        return ;
    }
    [self.timerRefreshData setFireDate:[NSDate date]];
}
- (void)showMyLoaction {
    //定位管理器
    _locationManager = [[CLLocationManager alloc]init];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }
    if([CBWtCommonTools checkWhetherAllowPosition] == YES) {
        if (self.locationManager.delegate == nil) {
            //设置代理
            _locationManager.delegate = self;
            //设置定位精度
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            //定位频率,每隔多少米定位一次
            CLLocationDistance distance = 10.0;//十米定位一次
            _locationManager.distanceFilter = distance;
            [_locationManager setDesiredAccuracy: kCLLocationAccuracyBest];
            //启动跟踪定位
            [_locationManager startUpdatingLocation];
        }
    } else {
        NSLog(@"请打开获取位置权限");
        [self requestInfoData];
    }
}
#pragma mark -- 获取首页信息
- (void)requestInfoData {
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] getHomePageInfoSuccess:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"首页信息:%@",baseModel.data);
        self.homeInfoModel = [HomeModel mj_objectWithKeyValues:baseModel.data];
        if (!kStringIsEmpty(self.homeInfoModel.tbWatchMain.sno)) {
            // 将首页设备信息本地存储
            [HomeModel saveCBDevice:self.homeInfoModel];
        }
        
        if (self.homeInfoModel.hasMessage.integerValue > 0) {
            // 有未读的
            [self initBarRightImageName: @"信息-提醒" target: self action: @selector(toMessageClick)];
        } else {
            // 没有未读的
            [self initBarRightImageName: @"信息-正常" target: self action: @selector(toMessageClick)];
        }
        if (self.homeInfoModel.allChatCount.integerValue <= 0) {
            self.chatBtn.lbNumberUnRead.text = [NSString stringWithFormat:@""];
        } else if (self.homeInfoModel.allChatCount.integerValue > 99) {
            self.chatBtn.lbNumberUnRead.text = [NSString stringWithFormat:@"99+"];
        } else {
            self.chatBtn.lbNumberUnRead.text = [NSString stringWithFormat:@"%@",self.homeInfoModel.allChatCount];
        }
        switch (baseModel.status) {
            case CBWtNetworkingStatus0:
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                // 待处理状态
                [self bindResultWatchView];
                
                self.customerAvatarView.hidden = YES;
                [self initBarRightImageName:@"切换-小号" target:nil action: @selector(swtichWatchClick)];
                
                [self viewIsHidder:YES];
                _bindResultWatchView.hidden = NO;
                _bindWatchView.hidden = YES;
            }
                break;
            case CBWtNetworkingStatus1:
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                // 接受状态
                [self setupView];
                [self viewIsHidder:NO];
                _bindResultWatchView.hidden = YES;
                _bindWatchView.hidden = YES;
            }
                break;
            case CBWtNetworkingStatus2:
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"需要绑定手表才能正常使用")];
                // 拒绝状态，跳转绑定手表页面
                [self bindWatchView];
                
                self.customerAvatarView.hidden = YES;
                [self initBarRightImageName:@"切换-小号" target:nil action: @selector(swtichWatchClick)];
                
                [self viewIsHidder:YES];
                _bindResultWatchView.hidden = YES;
                self.bindWatchView.hidden = NO;
            }
                break;
            default:
            {
                // 接受状态
                [self setupView];
                [CBWtMINUtils showProgressHudToView:self.view withText:baseModel.resmsg];
                
                [self viewIsHidder:NO];
                self.bindResultWatchView.hidden = YES;
                self.bindWatchView.hidden = YES;
            }
                break;
        }
        self.baiduView.hidden = [AppDelegate shareInstance].IsShowGoogleMap;
        self.googleView.hidden = ![AppDelegate shareInstance].IsShowGoogleMap;
        if ([[self getCurrentVC] isKindOfClass:[CBWtHomeViewController class]]) {
            [[CBPetTopSwitchBtnView share] showCtrlPanelWithResultBlock:^{
            }];
            [[CBPetBottomSwitchBtnView share] showCtrlPanelWithResultBlock:^{
            }];
        }
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.baiduView.hidden = [AppDelegate shareInstance].IsShowGoogleMap;
        self.googleView.hidden = ![AppDelegate shareInstance].IsShowGoogleMap;
        if ([[self getCurrentVC] isKindOfClass:[CBWtHomeViewController class]]) {
            [[CBPetTopSwitchBtnView share] showCtrlPanelWithResultBlock:^{
            }];
            [[CBPetBottomSwitchBtnView share] showCtrlPanelWithResultBlock:^{
            }];
        }
    }];
}
- (void)viewIsHidder:(BOOL)isHidden {
    self.statusView.hidden = isHidden;
    self.barView.hidden = isHidden;
    self.homeInfoView.hidden = isHidden;
}
#pragma mark -- 更新视图
- (void)updateModelDataToViewWithHud:(MBProgressHUD *)hud {
    if ([[self getCurrentVC] isKindOfClass:[CBWtHomeViewController class]]) {
        [[CBPetTopSwitchBtnView share] showCtrlPanelWithResultBlock:^{
        }];
        [[CBPetBottomSwitchBtnView share] showCtrlPanelWithResultBlock:^{
        }];
    }
    UIImage *originalImage = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: self.homeInfoModel.tbWatchMain.head]]];
    UIImage *thubImage = [UIImage imageByScalingAndCroppingForSourceImage:originalImage targetSize:CGSizeMake(92, 92)];
    thubImage = [thubImage imageByRoundCornerRadius:thubImage.size.height borderWidth: 1.5 borderColor: [UIColor whiteColor]];
    self.avatarImg = originalImage?thubImage:nil;
    [self customerAvatarView];
    self.customerAvatarView.hidden = NO;
    
    self.avtarImgView.image = self.avatarImg?:[UIImage imageNamed:@"默认宝贝头像"];
    self.userNameLb.text = self.homeInfoModel.tbWatchMain.name?:@"";
    
    NSString *powerString = [NSString stringWithFormat:@"%@%%", self.homeInfoModel.tbWatchMain.electric?:@"0"];
    [self.powerBtn setTitle: powerString forState: UIControlStateNormal];
    if (self.homeInfoModel.tbWatchMain.isLink == YES) {
        self.statusLabel.text = Localized(@"已连接");
    }else {
        self.statusLabel.text = Localized(@"未连接");
    }
    self.homeInfoView.stepCountLabel.text = [NSString stringWithFormat: @"%@ %@", self.homeInfoModel.tbWatchMain.stepSport?:@"0",Localized(@"步")];
    NSDate *time = [CBWtMINUtils getDateFromTimestamp: self.homeInfoModel.tbWatchMain.updateTime];
    NSDate *nowTime = [NSDate date];
    NSTimeInterval timeInterval = [time timeIntervalSinceDate:nowTime];
    NSLog(@"--------%f------  秒前",timeInterval);
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
    self.homeInfoView.lastTimeLabel.text = timeString;
    
    if ([AppDelegate shareInstance].IsShowGoogleMap == YES) {
        // 谷歌地图反向地理编码
        GMSGeocoder *geocoder = [[GMSGeocoder alloc]init];
        [geocoder reverseGeocodeCoordinate:CLLocationCoordinate2DMake(self.homeInfoModel.tbWatchMain.lat,self.homeInfoModel.tbWatchMain.lng) completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
            if (response.results.count > 0) {
                GMSAddress *address = response.results[0];
                NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@%@",address.country,address.administrativeArea,address.locality,address.subLocality,address.thoroughfare];
                NSLog(@"位置::::%@",addressStr);
                self.homeInfoView.addressLabel.text = addressStr;//result.address;
            }
        }];
    } else {
        // 谷歌反向地理编码的不准确,故用百度地图解析
        CLLocationCoordinate2D realCoor = CLLocationCoordinate2DMake(self.homeInfoModel.tbWatchMain.lat, self.homeInfoModel.tbWatchMain.lng);
        BMKReverseGeoCodeSearchOption *reverseGeoCodeOpetion = [[BMKReverseGeoCodeSearchOption alloc]init];
        reverseGeoCodeOpetion.location = realCoor;//coorData;
        BOOL flag = [self.searcher reverseGeoCode: reverseGeoCodeOpetion];
        if(flag) {
            NSLog(@"反geo检索发送成功");
        }else {
            NSLog(@"反geo检索发送失败");
        }
    }
    [self addMarker];
}
- (void)addMarker {
    
    if (self.homeInfoModel == nil) return;
    
    [self.baiduMapView removeAnnotations: self.baiduMapView.annotations];
    [self.googleMapView clear];
    
    self.googleMapView.camera = [GMSCameraPosition cameraWithLatitude: self.homeInfoModel.tbWatchMain.lat longitude: self.homeInfoModel.tbWatchMain.lng zoom: 18];
    [self.baiduMapView setCenterCoordinate:CLLocationCoordinate2DMake(self.homeInfoModel.tbWatchMain.lat, self.homeInfoModel.tbWatchMain.lng) animated: YES];
    
    GMSMarker *marker = [GMSMarker markerWithPosition: CLLocationCoordinate2DMake( self.homeInfoModel.tbWatchMain.lat,  self.homeInfoModel.tbWatchMain.lng)];
    marker.map = self.googleMapView;
    marker.iconView = self.avtarMarkView;
    self.avtarMarkView.iconImage = self.avatarImg?:[UIImage imageNamed:@"默认宝贝头像"];  //默认宝贝头像  宝贝定位头像-默认头像
    self.avtarMarkView.homeModel = self.homeInfoModel;
    
    CBWtNormalAnnotation *normailAnnotation = [[CBWtNormalAnnotation alloc] init];
    normailAnnotation.coordinate = CLLocationCoordinate2DMake(self.homeInfoModel.tbWatchMain.lat, self.homeInfoModel.tbWatchMain.lng);
    normailAnnotation.title = nil;
    [self.baiduMapView addAnnotation:normailAnnotation];
}
#pragma mark - Action
- (void)addAction {
    [self.locationBtn addTarget: self action: @selector(locationBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.phoneBtn addTarget: self action: @selector(phoneBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.chatBtn addTarget: self action: @selector(chatBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.functionBtn addTarget: self action: @selector(functionBtnClick) forControlEvents: UIControlEventTouchUpInside];
}
- (void)locationBtnClick {
    HomeLocationViewController *homeLocationVC = [[HomeLocationViewController alloc] init];
    homeLocationVC.homeInfoModel = self.homeInfoModel;
    [self.navigationController pushViewController:homeLocationVC animated: YES];
}
- (void)phoneBtnClick {
    // 拨打电话
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.homeInfoModel.tbWatchMain.phone?:@""];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
            //
        }];
    } else {
        // Fallback on earlier versions
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
    }
}
- (void)chatBtnClick {
    CBTalkListViewController *vc = [[CBTalkListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)functionBtnClick {
    FunctionViewController *functionVC = [[FunctionViewController alloc] init];
    functionVC.homeInfoModel = self.homeInfoModel;
    [self.navigationController pushViewController: functionVC animated: YES];
}
- (void)toMessageClick {
    NotifactionCenterViewController *notifactionCenterVC = [[NotifactionCenterViewController alloc] init];
    notifactionCenterVC.homeInfoModel = self.homeInfoModel;
    [self.navigationController pushViewController: notifactionCenterVC animated: YES];
}
- (void)swtichWatchClick {
    SwitchWatchViewController *switchWatchVC = [[SwitchWatchViewController alloc] init];
    kWeakSelf(self);
    switchWatchVC.returnBlock = ^(id objc) {
        kStrongSelf(self);
        [self requestInfoData];
    };
    [self.navigationController pushViewController: switchWatchVC animated: YES];
}
- (void)personalInfoClick {
    PersonalViewController *personVC = [[PersonalViewController alloc] init];
    personVC.homeInfoModel = self.homeInfoModel;
    [self.navigationController pushViewController:personVC animated: YES];
}
- (void)bindWatchClick {
    CBScanAddWatchViewController *addWatchVC = [[CBScanAddWatchViewController alloc] init];
    [self.navigationController pushViewController: addWatchVC animated: YES];
}
#pragma mark - CreateUI_normal
- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self initBarWithTitle:Localized(@"首页") isBack: NO];
    
    [self baiduView];
    [self googleView];
    [self statusView];
    
    [self barView];
    [self homeInfoView];
    // 刷新UI
    [self updateModelDataToViewWithHud:nil];
    
    [self addAction];
}
- (UIView *)customerAvatarView {
    if (!_customerAvatarView) {
        _customerAvatarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 40)];
        _customerAvatarView.userInteractionEnabled = YES;
        _customerAvatarView.hidden = YES;

        _avtarImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5/2, 35, 35)];
        _avtarImgView.userInteractionEnabled = YES;
        _avtarImgView.backgroundColor = [UIColor whiteColor];
        _avtarImgView.image = self.avatarImg;
        [_customerAvatarView addSubview:_avtarImgView];
        _avtarImgView.layer.masksToBounds = NO;
        _avtarImgView.layer.cornerRadius = 35/2;
        _avtarImgView.contentMode = UIViewContentModeScaleAspectFill;
        
        _userNameLb = [[UILabel alloc]initWithFrame:CGRectMake(45, 5/2, 100, 35)];
        _userNameLb.textColor = [UIColor whiteColor];
        _userNameLb.font = [UIFont systemFontOfSize:16*KFitWidthRate];
        [_customerAvatarView addSubview:_userNameLb];
        _userNameLb.userInteractionEnabled = YES;
        
        UIButton *btnLeftAction = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3/2, 40)];
        [btnLeftAction addTarget:self action:@selector(personalInfoClick) forControlEvents:UIControlEventTouchUpInside];
        [_customerAvatarView addSubview:btnLeftAction];
        
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:_customerAvatarView];
        self.navigationItem.leftBarButtonItem = barItem;
    }
    return _customerAvatarView;
}
- (UIView *)baiduView {
    if (!_baiduView) {
        _baiduView = [[UIView alloc] init];
        [self.view addSubview: _baiduView];
        [_baiduView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _baiduView.hidden = YES;//[AppDelegate shareInstance].IsShowGoogleMap;
        _baiduMapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
        _baiduMapView.zoomLevel = 16;
        _baiduMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
        [_baiduView addSubview: _baiduMapView];
        self.searcher = [[BMKGeoCodeSearch alloc] init];
        self.searcher.delegate = self;
        
        // 百度地图全局转（国测局，谷歌等通用）
        [BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_COMMON];
        
        //设定地图View能否支持俯仰角
        _baiduMapView.overlookEnabled = NO;//NO;
    }
    return _baiduView;
}
- (UIView *)googleView {
    if (!_googleView) {
        _googleView = [[UIView alloc] init];
        _googleView.hidden = ![AppDelegate shareInstance].IsShowGoogleMap;
        [self.view addSubview: _googleView];
        [_googleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.056898
                                                                longitude:116.307626
                                                                     zoom:18];
        _googleMapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) camera:camera];
        //    _googleMapView.myLocationEnabled = YES;
        _googleMapView.delegate = self;
        [_googleView addSubview: _googleMapView];
    }
    return _googleView;
}
- (CBAvatarMarkView *)avtarMarkView {
    if (!_avtarMarkView) {
        UIImage *imageDefault = [UIImage imageNamed:@"宝贝定位头像-空"];
        _avtarMarkView = [[CBAvatarMarkView alloc]initWithFrame:CGRectMake(0.f, 0.f, imageDefault.size.width, imageDefault.size.height)];
    }
    return _avtarMarkView;
}
- (HomeWatchInfoView *)homeInfoView {
    if (!_homeInfoView) {
        _homeInfoView = [[HomeWatchInfoView alloc] init];
        [self.view addSubview:_homeInfoView];
        [_homeInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.barView.mas_top);
            make.height.mas_equalTo(112.5*KFitWidthRate);
        }];
        _homeInfoView.hidden = YES;
    }
    return _homeInfoView;
}
- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [UIView new];
        _statusView.layer.cornerRadius = 20 * KFitHeightRate;
        _statusView.layer.borderColor = KWtRGB(210, 210, 210).CGColor;
        _statusView.layer.borderWidth = 0.5;
        _statusView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_statusView];
        [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(12.5 * KFitWidthRate);
            make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
            make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
            make.height.mas_equalTo(40*KFitHeightRate);
        }];
        
        UIView *leftLineView = [CBWtMINUtils createLineView];
        [_statusView addSubview: leftLineView];
        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_statusView.mas_right).multipliedBy(1.0/3);
            make.height.mas_equalTo(12.5 * KFitWidthRate);
            make.width.mas_equalTo(0.5);
            make.centerY.equalTo(_statusView);
        }];
        UIView *rightLineView = [CBWtMINUtils createLineView];
        [_statusView addSubview: rightLineView];
        [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_statusView.mas_right).multipliedBy(2.0/3);
            make.height.mas_equalTo(12.5 * KFitWidthRate);
            make.width.mas_equalTo(0.5);
            make.centerY.equalTo(_statusView);
        }];
        self.statusLabel = [CBWtMINUtils createLabelWithText: @"已连接" size: 13 * KFitWidthRate alignment: NSTextAlignmentCenter textColor: KWtBlueColor];
        [_statusView addSubview: self.statusLabel];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_statusView);
            make.width.equalTo(_statusView).multipliedBy(1.0/3);
        }];
        self.powerBtn = [self createStatusBtnWithImage: [UIImage imageNamed: @"首页-电量"] title: @"60%"];
        [_statusView addSubview: self.powerBtn];
        [self.powerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.bottom.equalTo(_statusView);
            make.width.equalTo(_statusView).multipliedBy(1.0/3);
        }];
        self.functionBtn = [self createStatusBtnWithImage: [UIImage imageNamed: @"首页-手表功能"] title:Localized(@"功能")];
        [_statusView addSubview: self.functionBtn];
        [self.functionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(_statusView);
            make.width.equalTo(_statusView).multipliedBy(1.0/3);
        }];

        _statusView.hidden = YES;
    }
    return _statusView;
}
- (void)createStatusView {
    _statusView = [[UIView alloc] init];
    _statusView.layer.cornerRadius = 20 * KFitWidthRate;
    _statusView.layer.borderColor = KWtRGB(210, 210, 210).CGColor;
    _statusView.layer.borderWidth = 0.5;
    _statusView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: _statusView];
    [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(12.5*KFitWidthRate);
        make.left.equalTo(self.view).with.offset(35 * KFitWidthRate);
        make.right.equalTo(self.view).with.offset(-35 * KFitWidthRate);
        make.height.mas_equalTo(40 * KFitWidthRate);
    }];
    UIView *leftLineView = [CBWtMINUtils createLineView];
    [_statusView addSubview: leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_statusView.mas_right).multipliedBy(1.0/3);
        make.height.mas_equalTo(12.5 * KFitWidthRate);
        make.width.mas_equalTo(0.5);
        make.centerY.equalTo(_statusView);
    }];
    UIView *rightLineView = [CBWtMINUtils createLineView];
    [_statusView addSubview: rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_statusView.mas_right).multipliedBy(2.0/3);
        make.height.mas_equalTo(12.5 * KFitWidthRate);
        make.width.mas_equalTo(0.5);
        make.centerY.equalTo(_statusView);
    }];
    self.statusLabel = [CBWtMINUtils createLabelWithText: @"已连接" size: 13 * KFitWidthRate alignment: NSTextAlignmentCenter textColor: KWtBlueColor];
    [_statusView addSubview: self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_statusView);
        make.width.equalTo(_statusView).multipliedBy(1.0/3);
    }];
    self.powerBtn = [self createStatusBtnWithImage: [UIImage imageNamed: @"首页-电量"] title: @"60%"];
    [_statusView addSubview: self.powerBtn];
    [self.powerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.bottom.equalTo(_statusView);
        make.width.equalTo(_statusView).multipliedBy(1.0/3);
    }];
    self.functionBtn = [self createStatusBtnWithImage: [UIImage imageNamed: @"首页-手表功能"] title:Localized(@"功能")];
    [_statusView addSubview: self.functionBtn];
    [self.functionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(_statusView);
        make.width.equalTo(_statusView).multipliedBy(1.0/3);
    }];
    
    _statusView.hidden = YES;
}
- (UIButton *)createStatusBtnWithImage:(UIImage *)image title:(NSString *)title {
    UIButton *button = [[UIButton alloc] init];
    [button setImage: image forState: UIControlStateNormal];
    [button setImage: image forState: UIControlStateHighlighted];
    [button setTitle: title forState: UIControlStateNormal];
    [button setImageEdgeInsets: UIEdgeInsetsMake(5 * KFitWidthRate, 0, 5 * KFitWidthRate, 5 * KFitWidthRate)];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button setTitleEdgeInsets: UIEdgeInsetsMake(0, 5 * KFitWidthRate, 0, 0)];
    button.titleLabel.font = [UIFont systemFontOfSize: 13 * KFitWidthRate];
    [button setTitleColor: KWt137Color forState: UIControlStateNormal];
    return button;
}
- (UIView *)barView {
    if (!_barView) {
        _barView = [[UIView alloc] init];
        _barView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_barView];
        [_barView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                // Fallback on earlier versions
                make.bottom.equalTo(self.view.mas_bottomMargin);
            }
            make.height.mas_equalTo(100 * KFitWidthRate);
        }];
        // iPhone X的适配,添加一个白色的View，免得看到有空的.
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview: bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(_barView.mas_bottom);
        }];
        UIView *lineView = [CBWtMINUtils createLineView];
        [_barView addSubview: lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_barView);
            make.height.mas_equalTo(0.5);
        }];
        
        self.locationBtn = [[MINImageTextBtn alloc] initWithImage: [UIImage imageNamed: @"首页-定位"] title:Localized(@"定位-首页")];
        [_barView addSubview: self.locationBtn];
        [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_barView);
            make.left.equalTo(_barView).with.offset(30 * KFitWidthRate);
        }];
        self.phoneBtn = [[MINImageTextBtn alloc] initWithImage: [UIImage imageNamed: @"首页-电话"] title:Localized(@"电话-首页")];
        [_barView addSubview: self.phoneBtn];
        [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_barView);
            make.centerX.equalTo(_barView);
        }];
        self.chatBtn = [[MINImageTextBtn alloc] initWithImage: [UIImage imageNamed: @"首页-语聊"] title:Localized(@"语聊")];
        [_barView addSubview: self.chatBtn];//首页-语聊
        [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_barView);
            make.right.equalTo(_barView).with.offset(-30 * KFitWidthRate);
        }];
        _barView.hidden = YES;
    }
    return _barView;
}
#pragma mark - CreateUI_bind
- (CBHomeBindWatchView *)bindWatchView {
    if (!_bindWatchView) {
        _bindWatchView = [[CBHomeBindWatchView alloc]init];
        [self.view addSubview:_bindWatchView];
        [_bindWatchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        kWeakSelf(self);
        _bindWatchView.bindWatchBlock = ^(id  _Nonnull objc) {
            kStrongSelf(self);
            [self bindWatchClick];
        };
        [self initBarWithTitle:Localized(@"绑定手表") isBack: NO];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return _bindWatchView;
}
- (CBHomeBindReusltView *)bindResultWatchView {
    if (!_bindResultWatchView) {
        _bindResultWatchView = [[CBHomeBindReusltView alloc]init];
        [self.view addSubview:_bindResultWatchView];
        [_bindResultWatchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        // 重新绑定
        kWeakSelf(self);
        _bindResultWatchView.bindWatchResultBlock = ^(id  _Nonnull objc) {
            kStrongSelf(self);
            [self bindWatchClick];
        };
        [self initBarWithTitle:Localized(@"首页") isBack: NO];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return _bindResultWatchView;
}
#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if (self.dataHud != nil) {
        [self.dataHud hideAnimated: YES];
    }
    if (error == BMK_SEARCH_NO_ERROR) {
        if (self.homeInfoView != nil) {
            self.homeInfoView.addressLabel.text = result.address;
        }
    } else {
        NSLog(@"未找到结果");
        self.homeInfoView.addressLabel.text = @"";
    }
}
#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass: [CBWtNormalAnnotation class]]) {
        static NSString *AnnotationViewID = @"NormalAnnationView";
        CBAvatarAnnotationView *annotationView = (CBAvatarAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[CBAvatarAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
        annotationView.iconImage = self.avatarImg?:[UIImage imageNamed: @"默认宝贝头像"];// 默认宝贝头像  宝贝定位头像-默认头像
        annotationView.homeModel = self.homeInfoModel;
        UIImage *imageDefault = [UIImage imageNamed:@"宝贝定位头像-空"];
        annotationView.centerOffset = CGPointMake(0, -imageDefault.size.height/2);
        return annotationView;
    }
    return nil;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
}
- (void)mapView:(BMKMapView *)mapView clickAnnotationView:(BMKAnnotationView *)view {
    HomeLocationViewController *homeLocationVC = [[HomeLocationViewController alloc] init];
    homeLocationVC.homeInfoModel = self.homeInfoModel;
    [self.navigationController pushViewController: homeLocationVC animated: YES];
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    HomeLocationViewController *homeLocationVC = [[HomeLocationViewController alloc] init];
    homeLocationVC.homeInfoModel = self.homeInfoModel;
    [self.navigationController pushViewController: homeLocationVC animated: YES];
    return YES;
}
- (void)toDetailLocation {
    HomeLocationViewController *homeLocationVC = [[HomeLocationViewController alloc] init];
    homeLocationVC.homeInfoModel = self.homeInfoModel;
    [self.navigationController pushViewController: homeLocationVC animated: YES];
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败++++++++:%@++++++++",error);
    //定位失败，作相应处理。
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    // 定位失败的话，默认使用百度地图，国内
    [AppDelegate shareInstance].IsShowGoogleMap = NO;
    [self requestInfoData];
//    _baiduView.hidden = [AppDelegate shareInstance].IsShowGoogleMap;
//    _googleView.hidden = ![AppDelegate shareInstance].IsShowGoogleMap;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.locationManager stopUpdatingLocation];
    CLLocation *curLocation = [locations firstObject];
    //通过location得到当前位置的经纬度
    CLLocationCoordinate2D curCoordinate2D = curLocation.coordinate;
    if ([CBWtCommonTools checkIsChina:CLLocationCoordinate2DMake(curCoordinate2D.latitude,curCoordinate2D.longitude)]) {
        curCoordinate2D = [TQLocationConverter transformFromWGSToGCJ:curCoordinate2D];
    }
    NSLog(@"latitude = %f, longitude = %f", curCoordinate2D.latitude, curCoordinate2D.longitude);
    // 确定当前地区是国内还是国外后，选择使用地图的类型
    [AppDelegate shareInstance].IsShowGoogleMap = ![CBWtCommonTools checkIsChina:CLLocationCoordinate2DMake(curCoordinate2D.latitude,curCoordinate2D.longitude)];
    
    [self requestInfoData];
    
//    _baiduView.hidden = [AppDelegate shareInstance].IsShowGoogleMap;
//    _googleView.hidden = ![AppDelegate shareInstance].IsShowGoogleMap;
}
#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
