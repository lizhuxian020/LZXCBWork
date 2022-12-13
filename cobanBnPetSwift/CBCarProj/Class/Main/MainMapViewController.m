//
//  MainMapViewController.m
//  Telematics
//
//  Created by lym on 2017/12/6.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MainMapViewController.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BMKLocationKit/BMKLocationComponent.h>
#import <BMKLocationKit/BMKLocationAuth.h>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <GooglePlacePicker/GooglePlacePicker.h>

//#import "JSONKit.h"
#import "ZCChinaLocation.h"
#import "TQLocationConverter.h"
#import "MINPickerView.h"
#import "MINNormalAnnotation.h"
#import "MINMapPaoPaoView.h"
#import "MINNormalInfoAnnotation.h"
#import "MINMapPaopaoDetailView.h"
#import "MINPlayBackView.h"

#import "CBHomeLeftMenuView.h"
#import "CBHomeLeftMenuModel.h"

#import "MINCoordinateObject.h"

#import "MINAnnotationView.h"
#import "MINAlertAnnotationView.h"
#import "DeviceDetailModel.h"
#import "TrackModel.h"
#import "CBSportAnnotation.h"
#import "CBTrackSelectTimeView.h"
#import "CBTrackPointView.h"
#import "CBCarPaopaoView.h"
#import "AddDeviceViewController.h"
#import "cobanBnPetSwift-Swift.h"
#import "UIView+Badge.h"
#import "MainViewConfig.h"
#import "CBCarAlertMsgController.h"
#import "_CBMyInfoPopView.h"
#import "AboutUsViewController.h"
#import "CBPersonInfoController.h"
#import "CBControlMenuController.h"

@interface MainMapViewController ()
<BMKMapViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate,
MINPickerViewDelegate, BMKLocationManagerDelegate, BMKGeoCodeSearchDelegate,UIGestureRecognizerDelegate,UITabBarControllerDelegate,UITableViewDelegate>
{
    // 百度轨迹线
    BMKPolyline *pathPloyline;
    
    // 百度轨迹回放车头标注
    BMKPointAnnotation *sportAnnotation;
    // 百度轨迹回放车头view
    SportAnnotationView *sportAnnotationView;
    
    // 百度轨迹圆点标注
    CBSportAnnotation *sportPointAnnotation;
    // 百度轨迹圆点view
    SportPointAnnotationView *sportPointAnnotationView;
    
    NSMutableArray *sportNodes; //轨迹点
    NSInteger sportNodeNum;     //轨迹点数
    NSInteger currentIndex;     //当前结点
    NSInteger lastIndex;        // 上一个轨迹结点
    BOOL isAnimate;
    MINPickerView *longPressPickerView;
    MINPlayBackView *playBackView;
    
    //20s刷新 百度轨迹线
    BMKPolyline *pathPloyline_realTime;
    //20s刷新 百度轨迹圆点标注
    CBSportAnnotation *sportPointAnnotation_realTime;
    
    NSMutableArray *sportNodes_realTime; //20s刷新 轨迹点
    NSInteger sportNodeNum_realTime;     //20s刷新 轨迹点数
    NSInteger currentIndex_realTime;     //20s刷新 当前结点
    NSInteger lastIndex_realTime;        //20s刷新 上一个轨迹结点
}
@property (nonatomic,strong) NSTimer *homeTimer;//定时器
@property (nonatomic, strong) BMKMapView *baiduMapView;
@property (nonatomic, strong) GMSMapView *googleMapView;
@property (nonatomic, strong) UIView *baiduView;
@property (nonatomic, strong) UIView *googleView;
@property (nonatomic, strong) GMSPolyline *polyline;
@property (nonatomic, strong) GMSMutablePath *linePath;
@property (nonatomic, strong) GMSPlacesClient *placesClient; // 可以获取某个地方的信息

// 20s刷新一次的 轨迹和线
@property (nonatomic, strong) GMSPolyline *polyline_realTime;
@property (nonatomic, strong) GMSMutablePath *linePath_realTime;

@property (nonatomic, strong) BMKLocationManager *baiduLocationService;
@property (nonatomic, assign) CLLocationCoordinate2D myBaiduLocation;
@property (nonatomic, assign) CLLocationCoordinate2D myGoogleLocation;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, assign) CGFloat speed; // 速度
@property (nonatomic, assign) CGFloat totalTime;
@property (nonatomic, strong) NSMutableArray *currentTimeArr; //记录当前播放轨迹每段动画的开始时间。

@property (nonatomic, strong) DeviceDetailModel *selectDeviceDetailModel;
@property (nonatomic, strong) GMSMarker *marker;
@property (nonatomic, assign) BOOL isListViewShow;

@property (nonatomic, strong) BMKGeoCodeSearch *searcher;
/** 左侧弹窗我的设备列表view  */
@property (nonatomic, strong)  CBHomeLeftMenuView *sliderView;
/** 菜单数据源  */
@property (nonatomic, strong) NSMutableArray *slider_array;

/** 轨迹选中view  */
@property (nonatomic, strong) CBTrackSelectTimeView *playbackSelectTimeView;
@property (nonatomic, strong) CBBasePopView *playbackTimeBasePopView;
/**   */
@property (nonatomic, strong) NSTimer *playTrackTimer;
/**   */
@property (nonatomic, assign) CGFloat playTrackTimeInterval;

@property (nonatomic, assign) CLLocationCoordinate2D circleCoordinate;
@property (nonatomic, strong) NSMutableArray *rectangleCoordinateArr;
@property (nonatomic, strong) NSMutableArray *polygonCoordinateArr;
@property (nonatomic, strong) NSMutableArray *pathleCoordinateArr;
/* 地图设备详情弹框*/
@property (nonatomic,strong) CBCarPaopaoView *paopaoView;
@property (nonatomic,strong) CBNoDataView *noDeviceDataView;

//@property (nonatomic,strong) UIButton *switchMapType;
@property (nonatomic, strong) UIButton *deviceListBtn;
@property (nonatomic, strong) UIButton *qrScanBtn;
@property (nonatomic, strong) UIButton *alertBtn;
@property (nonatomic, strong) UIButton *personBtn;
@property (nonatomic, strong) UIButton *locateBtn;

//是否开始跟踪
@property (nonatomic, assign) BOOL isStartTrack;
@property (nonatomic, strong) _CBMyInfoPopView *infoPopView;

@end

@implementation MainMapViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [_baiduMapView viewWillAppear];
//    _baiduMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//    _baiduLocationService.delegate = self;
//    self.navigationItem.title = [CBCommonTools CBdeviceInfo].name?:@"";
    
    // 判断当前地区是国内还是国外
    [self showMyLocation];
    // 开启定时器，每20s刷新，各设备详情
    [self startTimer];
    [AppDelegate isShowGoogle];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [_baiduMapView viewWillDisappear];
//    _baiduMapView.delegate = nil; // 不用时，置nil
//    _baiduLocationService.delegate = nil;
    
    // 隐藏菜单栏
    [self hideListView];
    
    [self endTimer];
    
    [[CBPetTopSwitchBtnView share] removeView];
    [[CBPetBottomSwitchBtnView share] removeView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //更新一下值
    [AppDelegate shareInstance].IsShowGoogleMap = [AppDelegate isShowGoogle];
    
    [self createUI];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(tarbarLongPress) name: kTabbarItemLongPress object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(hidePlayBackView) name: @"kHidePlayBackView" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(requestDeviceSingleLocation) name: @"SingleLocationNoti" object: nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taphandle:)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
    // 轨迹数组初始化
    [self initTrackLine];
    // 获取左侧菜单设备列表
    [self requestListData];
    // 开启定时器，每20s刷新，各设备详情
    [self startTimer];
    //请求闹钟数量
    [self reqeustAlertNum];
    
    if ([[[UIApplication sharedApplication] keyWindow].rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabViewController = (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
        tabViewController.delegate = self;
    }
}
- (void)initTrackLine {
    // 轨迹数组初始化
    sportNodes = [NSMutableArray array];
    sportNodeNum = 0;
    sportNodes_realTime = [NSMutableArray array];
    sportNodeNum_realTime = 0;
    
    [self.playTrackTimer invalidate];
    self.playTrackTimer = nil;
    self.playTrackTimeInterval = 0;
    playBackView.playBtn.selected = NO;
    [playBackView.playTimeSlide setValue:0 animated: YES];
    [playBackView setCurrentTime:0];
    
    // 播放速度0
    playBackView.speedSlide.value = 0;
    self.speed = 0.0;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self endTimer];
    NSLog(@"MainMapViewController   销毁。。。。。");
}
- (void)showMyLocation {
    //启动定位
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization];
}
- (void)requestListData {
    [self sliderView];
    [self.sliderView requestData];
}
- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc]init];
        //设置代理
        _locationManager.delegate = self;
        //设置定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance = 10.0;//十米定位一次
        _locationManager.distanceFilter = distance;
        [_locationManager setDesiredAccuracy: kCLLocationAccuracyBest];
    }
    return _locationManager;
}
- (NSMutableArray *)slider_array {
    if (!_slider_array) {
        _slider_array = [NSMutableArray array];
        NSArray *arrayTitle = @[Localized(@"全部"),Localized(@"在线"),Localized(@"离线")];
        NSArray *arrayStatus = @[@"",@"1",@"0"];
        for (int i = 0 ; i < arrayTitle.count ; i ++ ) {
            CBHomeLeftMenuSliderModel *model = [[CBHomeLeftMenuSliderModel alloc]init];
            model.title = arrayTitle[i];
            model.status = arrayStatus[i];
            [_slider_array addObject:model];
        }
    }
    return _slider_array;
}
- (CBHomeLeftMenuView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[CBHomeLeftMenuView alloc]initWithFrame:CGRectMake(0, -415 * KFitHeightRate, 305 * KFitWidthRate, 415 * KFitHeightRate) withSlideArray:self.slider_array index:0];
        [self.view addSubview:_sliderView];
        kWeakSelf(self);
        _sliderView.leftMenuBlock = ^(id  _Nonnull objc) {
            kStrongSelf(self);
            CBHomeLeftMenuDeviceInfoModel *model = (CBHomeLeftMenuDeviceInfoModel *)objc;
            // 刷新本地存储的 选中设备
            model.zoomLevel = self.deviceInfoModelSelect.zoomLevel;
            model.devStatus = self.deviceInfoModelSelect.devStatus;
            self.deviceInfoModelSelect = model;
            [CBCommonTools saveCBdeviceInfo:model];
            // 左侧菜单隐藏
            [self hideListView];
            // 20s刷新轨迹数组,初始化
            [self initTrackLine];
            // 20s刷新的轨迹的line和路径
            self.polyline_realTime = [[GMSPolyline alloc] init];
            self.linePath_realTime = [GMSMutablePath path];
            [self.linePath_realTime removeAllCoordinates];
            [MBProgressHUD showHUDIcon:self.view animated:YES];
            //刷新设备信息数据
            [self getDeviceLocationInfoRequest];
            
            //与安卓同步，选中后不改变颜色
//            [[NSNotificationCenter defaultCenter] postNotificationName:K_TabBarColorChangeNotification object:nil];
        };
    }
    return _sliderView;
}
- (CBNoDataView *)noDeviceDataView {
    if (!_noDeviceDataView) {
        _noDeviceDataView = [[CBNoDataView alloc] initNoDeviceUI];
        _noDeviceDataView.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:_noDeviceDataView];
        _noDeviceDataView.center = self.view.center;
        _noDeviceDataView.hidden = YES;
        kWeakSelf(self);
        [_noDeviceDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf(self);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        }];
    }
    return _noDeviceDataView;
}
//- (UIButton *)switchMapType {
//    if (!_switchMapType) {
//        _switchMapType = [[UIButton alloc]init];
//        [_switchMapType setImage:[UIImage imageNamed:@"car_map_statellite_11"] forState:UIControlStateNormal];
//        _switchMapType.backgroundColor = UIColor.grayColor;
//        _switchMapType.layer.masksToBounds = YES;
//        _switchMapType.layer.cornerRadius = 20;
//        [_switchMapType addTarget:self action:@selector(switchMap:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_switchMapType];
//        [_switchMapType mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(PPNavigationBarHeight+15);
//            make.right.mas_equalTo(-15);
//            make.size.mas_equalTo(CGSizeMake(40, 40));
//        }];
//        if ([AppDelegate shareInstance].IsShowGoogleMap == YES) {
//            _switchMapType.hidden = false;
//        } else {
//            _switchMapType.hidden = false;
//        }
//    }
//    return _switchMapType;
//}
//- (void)switchMap:(UIButton *)sender {
//    if ([AppDelegate shareInstance].IsShowGoogleMap) {
//        if (_googleMapView.mapType == kGMSTypeHybrid) {
//            [_switchMapType setImage:[UIImage imageNamed:@"car_map_statellite_11"]forState:UIControlStateNormal];
//            _googleMapView.mapType = kGMSTypeNormal;
//        } else {
//            [_switchMapType setImage:[UIImage imageNamed:@"car_map_normal_11"]forState:UIControlStateNormal];
//            _googleMapView.mapType = kGMSTypeHybrid;
//        }
//    } else {
//        if (_baiduMapView.mapType == BMKMapTypeSatellite) {
//            [_switchMapType setImage:[UIImage imageNamed:@"car_map_statellite_11"]forState:UIControlStateNormal];
//            [_baiduMapView setMapType:BMKMapTypeStandard];
//        } else {
//            [_switchMapType setImage:[UIImage imageNamed:@"car_map_normal_11"]forState:UIControlStateNormal];
//            [_baiduMapView setMapType:BMKMapTypeSatellite];
//        }
//    }
//}
- (void)showSelectDevice:(CBHomeLeftMenuDeviceInfoModel *)deviceInfoModel {
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(deviceInfoModel.lat.doubleValue,  deviceInfoModel.lng.doubleValue);
    // 更新选中的设备在地图中位置
    if ([AppDelegate shareInstance].IsShowGoogleMap == NO) {
        [self.baiduMapView setCenterCoordinate:coor animated: YES];
    } else {
        [self.googleMapView setCamera:[GMSCameraPosition cameraWithLatitude:deviceInfoModel.lat.doubleValue longitude:deviceInfoModel.lng.doubleValue zoom:self.deviceInfoModelSelect.zoomLevel.integerValue]];
    }
}
- (CBBasePopView *)playbackTimeBasePopView {
    if (!_playbackTimeBasePopView) {
        
        
        CBAlertBaseView *alertContentView = [[CBAlertBaseView alloc] initWithContentView:self.playbackSelectTimeView title:@"选择时间"];
        kWeakSelf(self);
        [alertContentView setDidClickCancel:^{
            [weakself.playbackTimeBasePopView dismiss];
        }];
        [alertContentView setDidClickConfirm: ^{
            [weakself requestTrackDataWithModelReal];
        }];
        
        _playbackTimeBasePopView = [[CBBasePopView alloc] initWithContentView:alertContentView];
    }
    return _playbackTimeBasePopView;
}
- (CBTrackSelectTimeView *)playbackSelectTimeView {
    if (!_playbackSelectTimeView) {
        _playbackSelectTimeView = [[CBTrackSelectTimeView alloc] init];
    }
    return _playbackSelectTimeView;
}
- (NSMutableArray *)rectangleCoordinateArr {
    if (!_rectangleCoordinateArr) {
        _rectangleCoordinateArr = [NSMutableArray array];
    }
    return _rectangleCoordinateArr;
}
- (NSMutableArray *)polygonCoordinateArr {
    if (!_polygonCoordinateArr) {
        _polygonCoordinateArr = [NSMutableArray array];
    }
    return _polygonCoordinateArr;
}
- (NSMutableArray *)pathleCoordinateArr {
    if (!_pathleCoordinateArr) {
        _pathleCoordinateArr = [NSMutableArray array];
    }
    return _pathleCoordinateArr;
}
// 使百度地图展示完整的内容，位置位置并处于地图中心
- (void)baiduMapFitFence:(NSArray *)modelArr {
    MINCoordinateObject *firstModel = modelArr.firstObject;
    BMKMapPoint firstPoint = BMKMapPointForCoordinate( firstModel.coordinate);
    CGFloat leftX, leftY, rightX, rightY; // 最左或右边的X、Y
    rightX = leftX = firstPoint.x;
    rightY = leftY = firstPoint.y;
    for (int i = 1; i < modelArr.count; i++) {
        MINCoordinateObject *model = modelArr[i];
        BMKMapPoint modelPoint = BMKMapPointForCoordinate( model.coordinate);
        if (modelPoint.x < leftX) {
            leftX = modelPoint.x;
        }
        if (modelPoint.x > rightX) {
            rightX = modelPoint.x;
        }
        if (modelPoint.y > leftY) {
            leftY = modelPoint.y;
        }
        if (modelPoint.y < rightY) {
            rightY = modelPoint.y;
        }
    }
    BMKMapRect fitRect;
    fitRect.origin = BMKMapPointMake(leftX, leftY);
    fitRect.size = BMKMapSizeMake(rightX - leftX, rightY - leftY);
    [_baiduMapView setVisibleMapRect: fitRect];
    _baiduMapView.zoomLevel = _baiduMapView.zoomLevel - 0.3;
}
- (void)googleMapFitFence:(NSArray *)modelArr {
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    for (MINCoordinateObject *model in modelArr) {
        bounds = [bounds includingCoordinate: model.coordinate];
    }
    [_googleMapView animateWithCameraUpdate: [GMSCameraUpdate fitBounds: bounds withPadding: 30.0f]];
}
- (void)googleMapFitCircleFence:(MINCoordinateObject *)model radius:(double)radius {
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    bounds = [bounds includingCoordinate: model.coordinate];
    CGFloat zoomLevel = [GMSCameraPosition zoomAtCoordinate: model.coordinate forMeters: radius perPoints: 50];
    [_googleMapView animateWithCameraUpdate: [GMSCameraUpdate fitBounds: bounds withPadding: 30.0f]];
    [_googleMapView animateToZoom: zoomLevel];
}
- (void)baiduMap {
    if (!_baiduView) {
        _baiduView = [[UIView alloc] init];
        _baiduView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview: _baiduView];
        [_baiduView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self.view);
        }];
        _baiduView.hidden = [AppDelegate shareInstance].IsShowGoogleMap;
        _baiduMapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _baiduMapView.zoomLevel = 14;//18;//20;//18;//16;
        _baiduMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
        _baiduMapView.backgroundColor = [UIColor whiteColor];
        [_baiduView addSubview: _baiduMapView];
        // 百度地图全局转（国测局，谷歌等通用）
        [BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_COMMON];
        _baiduLocationService = [[BMKLocationManager alloc] init];
        self.baiduLocationService.delegate = self;
        [_baiduLocationService startUpdatingLocation];
        _baiduMapView.userTrackingMode = BMKUserTrackingModeNone;
        // 地理反编码
        self.searcher = [[BMKGeoCodeSearch alloc] init];
        self.searcher.delegate = self;
        //设定地图View能否支持俯仰角
        _baiduMapView.overlookEnabled = NO;//NO;
        //设定是否总让选中的annotaion置于最前面
        _baiduMapView.isSelectedAnnotationViewFront = YES;
    }
}
- (void)clearBaiduMap {
    [self.baiduMapView removeAnnotations: self.baiduMapView.annotations];
    [self.baiduMapView removeOverlays: self.baiduMapView.overlays];
}
- (void)googleMap {
    if (!_googleView) {
        _googleView = [[UIView alloc] init];
        _googleView.hidden = ![AppDelegate shareInstance].IsShowGoogleMap;
        [self.view addSubview: _googleView];
        [_googleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self.view);
        }];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.056898
                                                                longitude:116.307626
                                                                     zoom:18];
        _googleMapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_HEIGHT) camera:camera];
        //    _googleMapView.myLocationEnabled = YES;
        //_googleMapView.mapType = kGMSTypeHybrid;
        _googleMapView.delegate = self;
        [_googleView addSubview: _googleMapView];
        
        // 回放轨迹的line和路径
        // Creates a marker in the center of the map.
        self.polyline = [[GMSPolyline alloc] init];
        self.linePath = [GMSMutablePath path];
        [self.linePath removeAllCoordinates];
        
        // 20s刷新的轨迹的line和路径
        self.polyline_realTime = [[GMSPolyline alloc] init];
        self.linePath_realTime = [GMSMutablePath path];
        [self.linePath_realTime removeAllCoordinates];
        
        //    [self drawLineWithLocationArray: sportNodes];
        currentIndex = 0;
        isAnimate = NO;
        
        // 地理反编码
//        self.searcher = [[BMKGeoCodeSearch alloc] init];
//        self.searcher.delegate = self;
        
        //是否启用指南针
        _googleMapView.settings.compassButton = YES;
    }
}
- (CBCarPaopaoView *)paopaoView {
    if (!_paopaoView) {
        _paopaoView = [[CBCarPaopaoView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _paopaoView;
}
#pragma mark - Action
- (void)leftBtnClick {
    if (self.paopaoView.isAlertPaopaoView == YES) {
        // 弹框时，不点击
        return;
    }
    if ([AppDelegate shareInstance].isShowPlayBackView) {
    // 点击左侧菜单时，轨迹未隐藏，则隐藏并清除些信息
        [self hidePlayBackView];
    }
    [self.view endEditing:YES];
    [self sliderView];
    if (self.isListViewShow == NO) {
        [self showListView];
    } else {
        [self hideListView];
    }
}
- (void)showListView {
    self.isListViewShow = YES;
    [self.view bringSubviewToFront:self.sliderView];
    [UIView animateWithDuration: 0.3 animations:^{
        self.sliderView.frame = CGRectMake(0, kNavAndStatusHeight, HomeLeftMenu_Width, HomeLeftMenu_Height);
    }];
    [self.sliderView requestData];
}
- (void)hideListView {
    self.isListViewShow = NO;
    [UIView animateWithDuration: 0.3 animations:^{
        self.sliderView.frame = CGRectMake(0, -HomeLeftMenu_Height, HomeLeftMenu_Width, HomeLeftMenu_Height);
    }];
}
- (void)tarbarLongPress {
    if (longPressPickerView == nil) {
        longPressPickerView = [[MINPickerView alloc] init];
        longPressPickerView.titleLabel.text = @"";
        longPressPickerView.dataArr = @[@[Localized(@"单次定位"), Localized(@"多次定位"), Localized(@"取消")]];
        longPressPickerView.delegate = self;
        [self.view addSubview: longPressPickerView];
        [longPressPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_equalTo(SCREEN_HEIGHT);
        }];
        [longPressPickerView showView];
    }
}
#pragma mark - CreateUI
- (void)createUI {
//    [self initBarWithTitle: Localized(@"定位") isBack: NO];
//    if (self.deviceInfoModelSelect) {
//        self.navigationItem.title = self.deviceInfoModelSelect.name?:@"";
//    } else {
//        self.navigationItem.title = @"";
//    }
//    // 导航右侧按钮隐藏
//    UIImage *backImage = [UIImage imageNamed: @"列表"];
//    UIButton *backBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0,  44,  44)];
//    [backBtn addTarget: self action: @selector(leftBtnClick) forControlEvents: UIControlEventTouchUpInside];
//    [backBtn setImage: [UIImage imageNamed: @"列表-有状态"] forState: UIControlStateSelected];
//    [backBtn setImage: backImage forState: UIControlStateNormal];
//    [backBtn setImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 20)];
//    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView: backBtn];
//    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    //将宽度设为负值
//    spaceItem.width = 10 * KFitWidthRate;
//    self.navigationItem.leftBarButtonItems = @[barItem, spaceItem];
    
    
    self.deviceInfoModelSelect = [CBCommonTools CBdeviceInfo];
    [self baiduMap];
    [self googleMap];
//    [self switchMapType];
    [self createBtns];
    [self setupInfoPopView];
}

- (void)setDeviceInfoModelSelect:(CBHomeLeftMenuDeviceInfoModel *)deviceInfoModelSelect {
    if (!_deviceInfoModelSelect && deviceInfoModelSelect) {
        [CBDeviceTool.shareInstance didChooseDevice:deviceInfoModelSelect];
    } else if (_deviceInfoModelSelect && deviceInfoModelSelect && ![_deviceInfoModelSelect.dno isEqualToString:deviceInfoModelSelect.dno]) {
        [CBDeviceTool.shareInstance didChooseDevice:deviceInfoModelSelect];
    }
    _deviceInfoModelSelect = deviceInfoModelSelect;
}

- (void)setupInfoPopView {
    self.infoPopView = [_CBMyInfoPopView new];
    kWeakSelf(self);
    [self.infoPopView setDidClickPersonInfo:^{
        CBPersonInfoController *v = [CBPersonInfoController new];
        [weakself.navigationController pushViewController:v animated: YES];
    }];
    [self.infoPopView setDidClickAbout:^{
        AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
        [weakself.navigationController pushViewController: aboutUsVC animated: YES];
    }];
    [self.infoPopView setDidClickPwd:^{
        [weakself modifyPwdClick];
    }];
    [self.infoPopView setDidClickLogout:^{
        [weakself quitBtnClick];
    }];
}

- (void)createBtns {
    self.deviceListBtn = [self createBtn:@"设备列表"];
    [self.deviceListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kStatusBarHeight + 20));
        make.left.equalTo(@15);
        make.width.height.equalTo(@40);
    }];
    [self.deviceListBtn addTarget:self action:@selector(didClickDeviceListBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.qrScanBtn = [self createBtn:@"扫码"];
    [self.qrScanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deviceListBtn.mas_right).offset(15);
        make.top.width.height.equalTo(self.deviceListBtn);
    }];
    [self.qrScanBtn addTarget:self action:@selector(didClickScanBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.alertBtn = [self createBtn:@"报警信息"];
    [self.alertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.deviceListBtn);
        make.left.equalTo(self.qrScanBtn.mas_right).mas_offset(15);
    }];
    [self.alertBtn addTarget:self action:@selector(didClickAlertBtn) forControlEvents:UIControlEventTouchUpInside];
//    self.alertBtn.BadgeValue = @"99";
    
    self.personBtn = [self createBtn:@"个人资料"];
    [self.personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.deviceListBtn);
        make.right.equalTo(@-15);
    }];
    [self.personBtn addTarget:self action:@selector(didClickPersonBtn) forControlEvents:UIControlEventTouchUpInside];
    CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
    kWeakSelf(self);
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:userModel.photo] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.personBtn setImage:image forState:UIControlStateNormal];
            });
        }
    }];
    
    self.locateBtn = [self createBtn:@"单次定位"];
    [self.locateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.width.height.equalTo(self.personBtn);
        make.bottom.equalTo(@(-20));
    }];
    [self.locateBtn addTarget:self action:@selector(didClickLocateBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)createBtn:(NSString *)imgName {
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    btn.backgroundColor = KWtCellBackColor;
//    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 20;
    [btn.layer setMasksToBounds:YES];
    [self.view addSubview:btn];
    return btn;
}

#pragma mark --InfoPopView
- (void)modifyPwdClick {
    CBPetUpdatePwdViewController *vc = [CBPetUpdatePwdViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)quitBtnClick
{
    // 退出登录提醒
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:Localized(@"是否退出登录") preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self logoutRequest];
        [self logoutAction];
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}
- (void)logoutRequest {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] logoutSuccess:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        switch (baseModel.status) {
            case CBWtNetworkingStatus0:
            {
                [self logoutAction];
            }
                break;
            default:
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [CBWtMINUtils showProgressHudToView:self.view withText:baseModel.resmsg];
            }
                break;
        }
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)logoutAction {
    // 清除本地选中的设备token
//    CBWtUserLoginModel *userModel = [CBWtUserLoginModel CBaccount];
//    userModel.token = nil;
//    [CBWtUserLoginModel saveCBAccount:userModel];
//    [[NSNotificationCenter defaultCenter] postNotificationName:KCBWt_SwitchCBWtLoginViewController object:nil];
    // 信鸽推送 解绑
    //[[XGPushTokenManager defaultTokenManager] unbindWithIdentifer:[NSString stringWithFormat:@"%@",@(userModel.uid)] type:XGPushTokenBindTypeAccount];
    
    CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
    userModel.token = nil;
    [CBPetLoginModelTool saveUser:userModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"K_SwitchLoginViewController" object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 按钮点击事件
- (void)didClickDeviceListBtn {
    [self leftBtnClick];
}

- (void)didClickScanBtn {
    AddDeviceViewController *bindVC = [[AddDeviceViewController alloc]init];
    bindVC.isBind = YES;
    [self.navigationController pushViewController:bindVC animated:YES];
}

- (void)didClickAlertBtn {
    NSLog(@"%s", __FUNCTION__);
    [self.navigationController pushViewController:CBCarAlertMsgController.new animated:YES];
}

- (void)didClickPersonBtn {
    NSLog(@"%s", __FUNCTION__);
    [self.infoPopView pop];
}

- (void)didClickLocateBtn {
    NSLog(@"%s", __FUNCTION__);
    [self requestDeviceSingleLocation];
}

- (void)reqeustAlertNum {
    kWeakSelf(self);
    [[NetWorkingManager shared] getWithUrl:@"/alarmDealController/getMyWarnListCount" params:nil succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        if (!isSucceed) {
            return;
        }
        if (response && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            NSNumber *num = response[@"data"][@"unReadCount"];
            if (num && [num intValue]) {
                self.alertBtn.BadgeValue = num.intValue >= 99 ? @"99" : num.description;
            } else {
                
            }
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark - GoogleMaps
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    /*在标记即将被选中时调用，并提供一个可选的自定义信息窗口来 如果此方法返回UIView，则用于该标记。*/
    return nil;
}
//点击大头针时调用
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    NSLog(@"点击大头针... mark.userData:%@",marker.userData);
    /* 返回YES，则不响应其他事件,NO 继续响应，比如上方的事件*/
    [self.paopaoView popView];
    CLLocationCoordinate2D anchor = marker.position;
    [_googleMapView addSubview: self.paopaoView];
    kWeakSelf(self);
    [self.paopaoView setDidClickMove:^(NSString * _Nonnull moveStr) {
        [weakself sendMoveRequest:moveStr];
    }];
    self.paopaoView.clickBlock = ^(CBCarPaopaoViewClickType type, id  _Nonnull obj) {
        kStrongSelf(self);
        switch (type) {
            case CBCarPaopaoViewClickTypePlayBack:
            {
                [self.paopaoView dismiss];
                [self requestTrackDataWithModel: obj];
            }
                break;
            case CBCarPaopaoViewClickTypeClose:
            {
                //[self getDeviceLocationInfoRequest];
            }
                break;
            case CBCarPaopaoViewClickTypeNavigationClick:
            {
                // 导航
                [self navigationClick];
            }
                break;
            case CBCarPaopaoViewClickTypeDeleteWarm:
            {
                [self.paopaoView dismiss];
                // 处理报警
                [self dealWithWarmedStatusRequestDeno:obj annotationView:nil];
            }
                break;
            default:
                break;
        }
    };
    
    DeviceDetailModel *deviceInfoModelPublic = nil;
    // 设备详情从本地取
    CBBaseNetworkModel *deviceInfoList = [CBCommonTools CBdeviceInfoList];
    for (NSDictionary *dic in deviceInfoList.data) {
        DeviceDetailModel *model = [DeviceDetailModel yy_modelWithJSON:dic];
        if (model.lat.doubleValue == anchor.latitude && model.lng.doubleValue == anchor.longitude) {
            self.selectDeviceDetailModel = model;
            deviceInfoModelPublic = model;
            break;
        }
    }
    
    if ([self.selectDeviceDetailModel.warmed isEqualToString:@"1"]) {
        // 报警
        [self.paopaoView setAlertStyleIsWarmed:YES];
    } else {
        [self.paopaoView setAlertStyleIsWarmed:NO];
    }
    self.paopaoView.dno = deviceInfoModelPublic.dno;
    self.paopaoView.deviceInfoModel = self.selectDeviceDetailModel;
    
    // 更新选中设备在地图中居中位置
    // 目标点到屏幕顶部距离
    CGFloat targetPt_y = (SCREEN_HEIGHT-377.5*KFitWidthRate)/2 + 377.5*KFitWidthRate + 50*KFitHeightRate;
    // 经纬度 转为坐标
    CLLocationCoordinate2D coorData = CLLocationCoordinate2DMake(deviceInfoModelPublic.lat.doubleValue, deviceInfoModelPublic.lng.doubleValue);
    CGPoint ppt = [_googleMapView.projection pointForCoordinate:coorData];
    
    // 调整后的坐标转为经纬度
    CLLocationCoordinate2D coor = [_googleMapView.projection coordinateForPoint:CGPointMake(ppt.x, ppt.y + SCREEN_HEIGHT/2 - targetPt_y)];
    [_googleMapView setCamera:[GMSCameraPosition cameraWithLatitude:coor.latitude longitude:coor.longitude zoom:self.deviceInfoModelSelect.zoomLevel.integerValue]];
    
    // 谷歌地图反向地理编码
    GMSGeocoder *geocoder = [[GMSGeocoder alloc]init];
    [geocoder reverseGeocodeCoordinate:CLLocationCoordinate2DMake(self.selectDeviceDetailModel.lat.doubleValue,self.selectDeviceDetailModel.lng.doubleValue) completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        kStrongSelf(self);
        if (response.results.count > 0) {
            GMSAddress *address = response.results[0];
            NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@%@",address.country,address.administrativeArea,address.locality,address.subLocality,address.thoroughfare];
            NSLog(@"位置::::%@",addressStr);
            self.selectDeviceDetailModel.address = addressStr;
            self.paopaoView.deviceInfoModel = self.selectDeviceDetailModel;
        }
    }];
    
    return YES;
}
//刷帧方法是这个：
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    // 本地保存地显示比例
    if (self.deviceInfoModelSelect) {
        self.deviceInfoModelSelect.zoomLevel = [NSString stringWithFormat:@"%ld",(long)mapView.camera.zoom];
        [CBCommonTools saveCBdeviceInfo:self.deviceInfoModelSelect];
    }
}
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    NSLog(@"点击大头针的弹出视窗时调用");
}
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self hideListView]; // 点击google 地图隐藏左侧设备列表
}
/**
 * Called when tiles have just been requested or labels have just started rendering.
 */
- (void)mapViewDidStartTileRendering:(GMSMapView *)mapView {
    //NSLog(@"------滑动---缩放---");
}
/**
 * Called when all tiles have been loaded (or failed permanently) and labels have been rendered.
 */
- (void)mapViewDidFinishTileRendering:(GMSMapView *)mapView {
}
#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    NSLog(@"heading is %@",userLocation.heading);
    self.myBaiduLocation = userLocation.location.coordinate;
    _baiduMapView.centerCoordinate = self.myBaiduLocation;
    [self.baiduMapView updateLocationData: userLocation];
    [self.baiduLocationService stopUpdatingLocation];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.myBaiduLocation = userLocation.location.coordinate;
    [self.baiduMapView updateLocationData: userLocation];
    _baiduMapView.centerCoordinate = self.myBaiduLocation;
    [self.baiduLocationService stopUpdatingLocation];
}

#pragma mark - BMKMapViewDelegate
/**
 *当点击一个annotation view时，调用此接口
 *每次点击BMKAnnotationView都会回调此接口。
 *@param mapView 地图View
 *@param view 点击的annotation view
 */
- (void)mapView:(BMKMapView *)mapView clickAnnotationView:(BMKAnnotationView *)view {
    if ([view isKindOfClass: [MINAnnotationView class]]) {
        NSLog(@"-----------点击了 点击了---------");
        [self setupMapZoomLevelMethod];
        // 调用此方法，才弹出paopaoView
        [self mapView:self.baiduMapView didSelectAnnotationView:view];
    }
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    NSLog(@"-----------点击了 大头针---------");
    // 此设置 才时刻调用此方法
    [mapView deselectAnnotation:view.annotation animated:YES];
    if ([view isKindOfClass: [MINAlertAnnotationView class]]) {//BMKPinAnnotationView
        // 点击图标上方信息标注
        [self clickPopAlertviewShowDeviceInfo:view];
    } else if ([view isKindOfClass: [MINAnnotationView class]]) {
        // 点击图标标注
        [self clickPopAlertviewShowDeviceInfo:view];
    }
}
/* 添加标注 会调此方法 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
   if ([annotation isKindOfClass: [MINNormalAnnotation class]]) {
    // 定位图标 设备图标标注
        MINNormalAnnotation *model = (MINNormalAnnotation *)annotation;
        static NSString *AnnotationViewID = @"NormalAnnationView";
        MINAnnotationView *annotationView = (MINAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (!annotationView) {
            annotationView = [[MINAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
       annotationView.image = nil;
       annotationView.model = model;
       if (model.isSelect) {
           annotationView.displayPriority = BMKFeatureDisplayPriorityDefaultHigh;
       }
       return annotationView;
   } else if ([annotation isKindOfClass: [MINNormalInfoAnnotation class]]) {
    // 定位图标上方信息  设备信息标注
       MINNormalInfoAnnotation *model = (MINNormalInfoAnnotation *)annotation;
       static NSString *AnnotationViewID = @"NormalInfoAnnotationView";
       MINAlertAnnotationView *annotationView = (MINAlertAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
       if (!annotationView) {
           annotationView = [[MINAlertAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
       }
//        MINMapPaoPaoView *imageView = [[MINMapPaoPaoView alloc] initWithFrame: CGRectMake(0, 0, 100 * KFitWidthRate, 30 * KFitWidthRate)];//53.5 * KFitWidthRate * 4
//        imageView.titleLabel.text = model.deviceName?:@"";
//        imageView.speedAndStayLabel.text = [NSString stringWithFormat:@"%@:%@Km/h",Localized(@"速度"),model.speed?:@""];
//        if ([model.warmed isEqualToString:@"1"]) {
//            imageView.backView.backgroundColor = [UIColor redColor];
//            imageView.titleLabel.textColor = [UIColor whiteColor];
//            imageView.speedAndStayLabel.textColor = [UIColor whiteColor];
//        } else {
//            imageView.backView.backgroundColor = [UIColor clearColor];
//            imageView.titleLabel.textColor = kBlueColor;
//            imageView.speedAndStayLabel.textColor = [UIColor blackColor];
//        }
//       UIImage *annotationImage = [self getImageFromView:imageView];
       annotationView.userInteractionEnabled = YES;
//       annotationView.image = annotationImage;
       annotationView.centerOffset = CGPointMake(0, -20*KFitHeightRate);//CGPointMake(0, -70 * KFitHeightRate); -40 * KFitHeightRate
       annotationView.textLbl.text = model.deviceName?:@"";
       annotationView.frame = CGRectMake(0, 0, 70 * KFitWidthRate,  30 * KFitWidthRate);
       if (model.isSelect) {
           annotationView.displayPriority = BMKFeatureDisplayPriorityDefaultHigh;
       }
        return annotationView;
    } else if (annotation == sportPointAnnotation) {
        // 轨迹圆点
        static NSString *SportsAnnotationViewID = @"sportsPointAnnotation";
        sportPointAnnotationView = (SportPointAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:SportsAnnotationViewID];
        if (!sportPointAnnotationView) {
            sportPointAnnotationView = [[SportPointAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:SportsAnnotationViewID];
        }
        sportPointAnnotationView.draggable = NO;
        return sportPointAnnotationView;
    }  else if (annotation == sportAnnotation) {
        // 轨迹车头
        sportAnnotationView = [[SportAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"sportsAnnotation"];
        sportAnnotationView.draggable = NO;
        sportAnnotationView.iconImage = [CBCommonTools returnDeveceLocationImageStr:self.selectDeviceDetailModel.icon isOnline:self.selectDeviceDetailModel.online isWarmed:self.selectDeviceDetailModel.warmed];
        BMKSportNode *node = [sportNodes firstObject];
        sportAnnotationView.imageView.transform = CGAffineTransformMakeRotation(node.angle);
        return sportAnnotationView;
    } else if (annotation == sportPointAnnotation_realTime) {
        // 20s刷新轨迹圆点
        static NSString *SportsAnnotationView_realTimeID = @"sportsPointAnnotation_realTime";
        sportPointAnnotationView = (SportPointAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:SportsAnnotationView_realTimeID];
        if (!sportPointAnnotationView) {
            sportPointAnnotationView = [[SportPointAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:SportsAnnotationView_realTimeID];
        }
        sportPointAnnotationView.draggable = NO;
        sportPointAnnotationView.pointView.hidden = YES;
        sportPointAnnotationView.pointView_realTime.hidden = NO;
        return sportPointAnnotationView;
    }
    return nil;
}
//*当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    NSLog(@"-----------点击view弹出的泡泡时，调用此接口---------");
}
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
}
//地图区域改变完成后会调用此接口
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"---地图比例---%f-----------",mapView.zoomLevel);
    // 本地保存地显示比例
    if (self.deviceInfoModelSelect) {
        self.deviceInfoModelSelect.zoomLevel = [NSString stringWithFormat:@"%ld",(long)mapView.zoomLevel];
        [CBCommonTools saveCBdeviceInfo:self.deviceInfoModelSelect];
    }
}
/**
 *点中底图空白处会回调此接口
 *@param mapView 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
}
//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay {
    if (overlay == pathPloyline) {
        // 设置轨迹线
        BMKPolylineView* polygonView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [UIColor orangeColor];//kBlueColor;
        polygonView.lineWidth = 2.0f;//4.0;
        return polygonView;
    } else if (overlay == pathPloyline_realTime) {
        // 20s刷新轨迹线
        BMKPolylineView* polygonView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = kRGB(128, 189, 86);
        polygonView.lineWidth = 2.0f;//4.0;
        return polygonView;
    } else if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        circleView.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        if ([self.deviceInfoModelSelect.warmed isEqualToString:@"1"]) {
            circleView.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
            circleView.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
        }
        return circleView;
    }else if ([overlay isKindOfClass:[BMKPolygon class]]){
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        polygonView.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        return polygonView;
    }else if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = kBlueColor;
        polylineView.lineWidth = 2.0 * KFitWidthRate;
        return polylineView;
    }
    return nil;
}
#pragma mark - 添加完线图
- (void)mapView:(BMKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews {
}
#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if ([AppDelegate shareInstance].IsShowGoogleMap) {
        //self.selectGoogleInfoView.addressLabel.text = result.address;
    } else {
        //self.selectBaiduInfoView.addressLabel.text = result.address;
    }
    self.selectDeviceDetailModel.address = result.address;
    self.paopaoView.deviceInfoModel = self.selectDeviceDetailModel;
}
#pragma mark -- 点击百度地图标注设备详情弹框
- (void)clickPopAlertviewShowDeviceInfo:(BMKAnnotationView *)view {
    [self.paopaoView popView];
    kWeakSelf(self);
    [self.paopaoView setDidClickMove:^(NSString * _Nonnull moveStr) {
        [weakself sendMoveRequest:moveStr];
    }];
    self.paopaoView.clickBlock = ^(CBCarPaopaoViewClickType type, id  _Nonnull obj) {
        kStrongSelf(self);
        switch (type) {
            case CBCarPaopaoViewClickTypePlayBack:
            {
                [self.paopaoView dismiss];
                [self requestTrackDataWithModel: obj];
            }
                break;
            case CBCarPaopaoViewClickTypeClose:
            {
                //
            }
                break;
            case CBCarPaopaoViewClickTypeNavigationClick:
            {
                [self.paopaoView dismiss];
                // 导航
                [self navigationClick];
            }
                break;
            case CBCarPaopaoViewClickTypeDeleteWarm:
            {
                [self.paopaoView dismiss];
                // 处理报警
                [self dealWithWarmedStatusRequestDeno:obj annotationView:view];
            }
                break;
            case CBCarPaopaoViewClickTypeTrack: {
                if (self.isStartTrack) {
                    [self setEndTrack];
                } else {
                    [self setCanStartTrack];
                }
            }
                break;
            case CBCarPaopaoViewClickTypeTitle: {
                [self.paopaoView dismiss];
                CBControlMenuController *vc = CBControlMenuController.new;
                vc.deviceInfoModelSelect = self.deviceInfoModelSelect;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    };
    
    MINAnnotationView *annotationView = (MINAnnotationView *)view;
    MINNormalAnnotation *alertAnnotation = (MINNormalAnnotation *)annotationView.annotation;
    DeviceDetailModel *deviceInfoModelPublic = nil;
    // 设备详情从本地取
    CBBaseNetworkModel *deviceInfoList = [CBCommonTools CBdeviceInfoList];
    for (NSDictionary *dic in deviceInfoList.data) {
        DeviceDetailModel *model = [DeviceDetailModel yy_modelWithJSON:dic];
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(model.lat.doubleValue, model.lng.doubleValue);
        if (coor.latitude == alertAnnotation.coordinate.latitude && coor.longitude == alertAnnotation.coordinate.longitude) {
            // 选中标注的设备信息模型
            deviceInfoModelPublic = model;
            self.selectDeviceDetailModel = model;
            break;
        }
    }
    if (kStringIsEmpty(self.selectDeviceDetailModel.lat) || kStringIsEmpty(self.selectDeviceDetailModel.lng)) {
        [HUD showHUDWithText:[Utils getSafeString:Localized(@"暂无数据")] withDelay:1.2];
        return ;
    }
    if ([self.selectDeviceDetailModel.warmed isEqualToString:@"1"]) {
        // 报警
        [self.paopaoView setAlertStyleIsWarmed:YES];
    } else {
        [self.paopaoView setAlertStyleIsWarmed:NO];
    }
    self.paopaoView.dno = deviceInfoModelPublic.dno;
    self.paopaoView.deviceInfoModel = self.selectDeviceDetailModel;
    
    // 更新选中设备在地图中居中位置
    // 目标点到屏幕顶部距离
    CGFloat targetPt_y = (SCREEN_HEIGHT -377.5*KFitWidthRate)/2 + 377.5*KFitWidthRate;
    
    CGPoint ppt = [self.baiduMapView convertCoordinate:CLLocationCoordinate2DMake(deviceInfoModelPublic.lat.doubleValue, deviceInfoModelPublic.lng.doubleValue) toPointToView:self.baiduView];
    
    CLLocationCoordinate2D coorData = CLLocationCoordinate2DMake(deviceInfoModelPublic.lat.doubleValue, deviceInfoModelPublic.lng.doubleValue);
    if ([AppDelegate shareInstance].IsShowGoogleMap == NO) {
        ppt = [self.baiduMapView convertCoordinate:coorData toPointToView:self.baiduView];
    }
    CLLocationCoordinate2D coor = [self.baiduMapView convertPoint:CGPointMake(ppt.x, (SCREEN_HEIGHT)/2 - (targetPt_y - ppt.y) - TabBARHEIGHT/2) toCoordinateFromView:self.baiduView];
    [self.baiduMapView setCenterCoordinate:coor animated:YES];
    
    // 地理位置反编码
    BMKReverseGeoCodeSearchOption *reverseGeoCodeOpetion = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeoCodeOpetion.location = coorData;
    BOOL flag = [self.searcher reverseGeoCode: reverseGeoCodeOpetion];
    if (flag) {
        NSLog(@"反geo检索发送成功");
    } else {
        NSLog(@"反geo检索发送失败");
    }
}

#pragma mark ------------paoViewActions------------
#pragma mark --位移
- (void)sendMoveRequest:(NSString *)moveStr {
    NSDictionary *param = @{
        @"dno": self.deviceInfoModelSelect.dno,
        @"data": [NSString stringWithFormat:@"%@,%@,%@", self.deviceInfoModelSelect.lat,self.deviceInfoModelSelect.lng, moveStr],
        @"shape": self.deviceInfoModelSelect.listFence.firstObject.shape?:@"",
        @"warmType": self.deviceInfoModelSelect.listFence.firstObject.warmType?:@"",
    };
    [[NetWorkingManager shared] postWithUrl:@"/devControlController/saveFence" params:param succeed:^(id response, BOOL isSucceed) {
        if (isSucceed) {
            [HUD showHUDWithText:@"成功"];
        }
        } failed:^(NSError *error) {
            
        }];
}
#pragma mark --跟踪
- (void)setCanStartTrack {
    self.isStartTrack = YES;
    [HUD showHUDWithText:Localized(@"开始跟踪") withDelay:2.0];
    [self getDeviceLocationInfoRequest];
}
- (void)setEndTrack {
    self.isStartTrack = NO;
    [HUD showHUDWithText:Localized(@"停止跟踪") withDelay:2.0];
    // 20s刷新轨迹数组,初始化
    [self initTrackLine];
    // 20s刷新的轨迹的line和路径
    self.polyline_realTime = [[GMSPolyline alloc] init];
    self.linePath_realTime = [GMSMutablePath path];
    [self.linePath_realTime removeAllCoordinates];
}
#pragma mark --处理报警
- (void)dealWithWarmedStatusRequestDeno:(NSString *)deno annotationView:(BMKAnnotationView *)annotationView {
    kWeakSelf(self);
    [MBProgressHUD showHUDIcon:self.googleView animated:YES];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:deno?:@"" forKey:@"dno"];
    [[CBNetworkRequestManager sharedInstance] dealWithWarmedParamters:paramters success:^(CBBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [HUD hideHud];
        [MBProgressHUD hideHUDForView:self.googleView animated:YES];
        switch (baseModel.status) {
            case CBNetworkingStatus0:
            {
                // 关闭泡泡
                [annotationView.paopaoView removeFromSuperview];
                
                // 清除百度地图标注和轨迹设置
                [self clearBaiduMap];
                [self.googleMapView clear];
                
                [self.sliderView requestData];
                
                [self getDeviceLocationInfoRequest];
            }
                break;
            default:
            {
                [HUD showHUDWithText:baseModel.resmsg withDelay:3.0];
            }
                break;
        }
        
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [HUD hideHud];
        [MBProgressHUD hideHUDForView:self.googleView animated:YES];
        [HUD showHUDWithText:Localized(@"请求超时") withDelay:3.0];
    }];
}
#pragma mark --导航
- (void)navigationClick {
    MKMapItem *myLocation = [MKMapItem mapItemForCurrentLocation];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(self.deviceInfoModelSelect.lat.doubleValue,self.deviceInfoModelSelect.lng.doubleValue);
    MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:coor]];
    
    //toLocation.name = @"Car location"
    NSArray *items = @[myLocation,toLocation];
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    [MKMapItem openMapsWithItems:items launchOptions:options];
}
#pragma mark --获取设备轨迹
- (void)requestTrackDataWithModel:(NSString *)dno {
    self.playbackSelectTimeView.dno = dno;
    [self.playbackTimeBasePopView pop];
}
- (void)requestTrackDataWithModelReal {
    __weak __typeof__(self) weakSelf = self;
    if (![self.playbackSelectTimeView readyToRequest]) {
        return;
    };
    [self.playbackTimeBasePopView dismiss];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = self.playbackSelectTimeView.dno;
    dic[@"startTime"] = self.playbackSelectTimeView.dateStrStar?:@"";//@"2019-07-31";
    dic[@"endTime"] = self.playbackSelectTimeView.dateStrEnd?:@"";//@"2019-08-01";
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[NetWorkingManager shared]getWithUrl:@"personController/getMyDeviceGPS" params: dic succeed:^(id response,BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                [sportNodes removeAllObjects];
                [weakSelf.currentTimeArr removeAllObjects];
                BMKSportNode *lastSportModel = nil;
                NSArray *dataArr = response[@"data"];
                weakSelf.totalTime = 0;
                if (dataArr.count <= 0 || dataArr == nil) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [HUD showHUDWithText:[Utils getSafeString:Localized(@"暂无数据")] withDelay:1.2];
                    return ;
                }
                NSInteger timeLast = 0;
                for (int i = 0; i < dataArr.count; i++) {
                    NSDictionary *dic = dataArr[i];
                    TrackModel *trackModel = [TrackModel yy_modelWithDictionary: dic];
                    BMKSportNode *sportModel = [[BMKSportNode alloc] init];
                    
                    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(trackModel.lat,trackModel.lng);
                    sportModel.coordinate = coor;
                    sportModel.speed = 30;//20;//8.5;//trackModel.speed;  默认速度
                    
                    NSInteger timeS = trackModel.create_time.integerValue;
                    
                    if (i == 0) {
                        sportModel.distance = 1;
                        sportModel.angle = 0;
                        [weakSelf.currentTimeArr addObject: [NSNumber numberWithFloat: 0]];
                    } else {
                        //sportModel.distance = GMSGeometryDistance(lastSportModel.coordinate, sportModel.coordinate);
                        BMKMapPoint pointS = BMKMapPointForCoordinate(lastSportModel.coordinate);
                        BMKMapPoint pointE = BMKMapPointForCoordinate(sportModel.coordinate);
                        CLLocationDistance distance = BMKMetersBetweenMapPoints(pointS,pointE);
                        sportModel.distance = distance;
                        // 谷歌的，用谷歌解析距离
                        if ([AppDelegate shareInstance].IsShowGoogleMap) {
                            sportModel.distance = GMSGeometryDistance(lastSportModel.coordinate, sportModel.coordinate);
                        }
                        
                        CLLocationDirection heading = GMSGeometryHeading(lastSportModel.coordinate, sportModel.coordinate);
                        sportModel.angle = heading;
                        
                        CGFloat second = (CGFloat)sportModel.distance / (CGFloat)sportModel.speed;
                        weakSelf.totalTime += second;
                        NSLog(@"----距离：%.f------速度:%.f------点到点需要的时间------%.f------",sportModel.distance,sportModel.speed,second);
                        [weakSelf.currentTimeArr addObject: [NSNumber numberWithFloat: weakSelf.totalTime]];
                    }
                    lastSportModel = sportModel;
                    timeLast = timeS;
                    [sportNodes addObject: sportModel];
                }
                sportNodeNum = sportNodes.count;
                [self showPlayBackView];
            }
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)showPlayBackView {
    if (self.baiduView.hidden == NO) {
        [self clearBaiduMap];
    } else {
        [self.googleMapView clear];
    }
    if (playBackView == nil) {
        playBackView =  [[MINPlayBackView alloc] init];
        [self.view addSubview: playBackView];
        [playBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
//            make.bottom.equalTo(self.view).with.offset(-self.tabBarController.tabBar.frame.size.height);
            make.height.mas_equalTo(120 * KFitHeightRate);
        }];
        __weak __typeof__(self) weakSelf = self;
        playBackView.playBtnClickBlock = ^(BOOL isSelected) {
            isAnimate = isSelected;
            if (isAnimate == YES) {
                if (weakSelf.baiduView.hidden == NO) {
                    [weakSelf running];
                }else {
                    __weak __typeof__(GMSMarker *)weakMarker = weakSelf.marker;
                    [weakSelf animateToNextCoord: weakMarker];
                }
            }
            if (weakSelf.playTrackTimer) {
                if (isAnimate == YES) {
                    // 继续定时器
                    [weakSelf.playTrackTimer setFireDate:[NSDate distantPast]];
                } else {
                    // 暂停定时器
                    [weakSelf.playTrackTimer setFireDate:[NSDate distantFuture]];
                }
            }
        };
        playBackView.playTimeSlideBlock = ^(CGFloat currentSecond) {
            int playIndex = 0;
            for (int i = 0; i < weakSelf.currentTimeArr.count; i++) {
                if (currentSecond < [weakSelf.currentTimeArr[i] floatValue]) {
                    if (i > 0) {
                        playIndex = i - 1;
                        break;
                    }else {
                        playIndex = i;
                    }
                }
            }
            currentIndex = playIndex;
            if (weakSelf.googleMapView.hidden == NO) {
                CoordsList *coordList = weakSelf.marker.userData;
                coordList.target = playIndex;
            }
        };
        playBackView.speedSlideBlock = ^(CGFloat currentSpeed) {
            weakSelf.speed = currentSpeed;
        };
    }
    playBackView.totalTime = self.totalTime;
    [AppDelegate shareInstance].isShowPlayBackView = YES;
    [playBackView show];
    [self initPlayBackLineAndMarker];
}
- (void)hidePlayBackView {
    // 轨迹数组初始化
    [self initTrackLine];
    [self getLocalDeviceInfoBaseModel];
    [AppDelegate shareInstance].isShowPlayBackView = NO;
    if (playBackView != nil) {
        [playBackView hide];
    }
    [self requestListData];
    currentIndex = 0;
    isAnimate = NO;
    [self setupMapZoomLevelMethod];
}
- (void)initPlayBackLineAndMarker {
    if (self.baiduView.hidden == NO) {
        CLLocationCoordinate2D paths[sportNodeNum];
        for (NSInteger i = 0; i < sportNodeNum ; i++) {
            BMKSportNode *node = sportNodes[i];
            paths[i] = node.coordinate;
        }
        isAnimate = YES;
        // 创建轨迹路径
        pathPloyline = [BMKPolyline polylineWithCoordinates: paths count: sportNodeNum];
        [self.baiduMapView addOverlay:pathPloyline];
        // 添加圆点标注
        for (NSInteger i = 0; i < sportNodeNum ; i++) {
            if (i > 0) {
                sportPointAnnotation = [[CBSportAnnotation alloc]init];
                sportPointAnnotation.coordinate = paths[i];
                [self.baiduMapView addAnnotation:sportPointAnnotation];
            }
        }
        // 添加轨迹车头标注
        sportAnnotation = [[BMKPointAnnotation alloc]init];
        sportAnnotation.coordinate = paths[0];
        [self.baiduMapView addAnnotation:sportAnnotation];
        
        currentIndex = 0;
        self.baiduMapView.centerCoordinate = paths[0];
        self.baiduMapView.zoomLevel = 20;//19;
        // 本地保存地显示比例
        if (self.deviceInfoModelSelect) {
            self.deviceInfoModelSelect.zoomLevel = [NSString stringWithFormat:@"%d",20];
            [CBCommonTools saveCBdeviceInfo:self.deviceInfoModelSelect];
        }
    } else {
        self.polyline.strokeColor = [UIColor orangeColor];
        self.polyline.strokeWidth = 2*KFitWidthRate;
        for(int idx = 0; idx < sportNodes.count; idx++)
        {
            BMKSportNode *node = [sportNodes objectAtIndex:idx];
            CLLocationCoordinate2D location = node.coordinate;
            [self.linePath addCoordinate:location];
            
            // 添加轨迹上的圆点
            if (idx > 0) {
                GMSMarker *mark_point = [[GMSMarker alloc] init];
                mark_point.appearAnimation = kGMSMarkerAnimationPop;
                mark_point.position = location;
                UIView *iconView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10*KFitWidthRate, 10*KFitWidthRate)];
                iconView.backgroundColor = kBlueColor;
                iconView.layer.masksToBounds = YES;
                iconView.layer.cornerRadius = 5*KFitWidthRate;
                mark_point.iconView = iconView;
                mark_point.groundAnchor = CGPointMake(0.5f, 0.5f);
    
                mark_point.map = self.googleMapView;
            }
        }
        BMKSportNode *firstNode = [sportNodes objectAtIndex: 0];
        CLLocationCoordinate2D coordinate = firstNode.coordinate;
        dispatch_async(dispatch_get_main_queue(), ^{
            _googleMapView.camera = [GMSCameraPosition cameraWithLatitude: coordinate.latitude longitude: coordinate.longitude zoom:self.deviceInfoModelSelect.zoomLevel.integerValue];
        });
        self.polyline.path = self.linePath;
        self.polyline.map = self.googleMapView;
        
        self.marker = [GMSMarker markerWithPosition:[self.linePath coordinateAtIndex:0]];
        self.marker.icon = [CBCommonTools returnDeveceLocationImageStr:self.selectDeviceDetailModel.icon isOnline:self.selectDeviceDetailModel.online isWarmed:self.selectDeviceDetailModel.warmed];
        self.marker.groundAnchor = CGPointMake(0.5f, 0.5f);
        self.marker.flat = YES;
        self.marker.map = _googleMapView;
        self.marker.userData = [[CoordsList alloc] initWithPath: self.linePath];
        CoordsList *coords = self.marker.userData;
        CLLocationCoordinate2D previous = [coords.path coordinateAtIndex: 0];
        CLLocationCoordinate2D coord = [coords.path coordinateAtIndex: 1];
        CLLocationDirection heading = GMSGeometryHeading(previous, coord);
        self.marker.rotation = heading;
    }
}
- (void)running {
    [self running_time];
    [self running_track];
}
- (void)running_time {
    kWeakSelf(self);
    self.playTrackTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        kStrongSelf(self);
        self.playTrackTimeInterval ++;
        [self sliderValueChange];
    }];
}
- (void)sliderValueChange {
    if (self.playTrackTimeInterval >= self.totalTime) {
        
        [self.playTrackTimer invalidate];
        self.playTrackTimer = nil;
        self.playTrackTimeInterval = 0;
        playBackView.playBtn.selected = NO;
        [playBackView.playTimeSlide setValue:0 animated: YES];
        [playBackView setCurrentTime:0];
        
    } else {
        
        [playBackView setCurrentTime:self.playTrackTimeInterval];
        CGFloat currentTime = [self.currentTimeArr[currentIndex] floatValue];
        if (currentTime > self.playTrackTimeInterval) {
            self.playTrackTimeInterval = currentTime;
        }
        // 播放速度为0的时候，进度条
        if ((13 - self.speed) == 13) {
            [playBackView.playTimeSlide setValue: self.playTrackTimeInterval/self.totalTime animated: YES];
        }
    }
}
- (void)running_track {
    if (currentIndex >= sportNodeNum - 1) {
        isAnimate = NO;
        playBackView.playBtn.selected = NO;
        playBackView.playTimeSlide.value = 0;
        currentIndex = 0;
        playBackView.starTimeLabel.text = @"00:00";
        
        [self.playTrackTimer invalidate];
        self.playTrackTimer = nil;
        self.playTrackTimeInterval = 0;
        return;
    }
    NSLog(@"%f", self.speed);
    BMKSportNode *node = [sportNodes objectAtIndex:currentIndex];
    sportAnnotationView.imageView.transform = CGAffineTransformMakeRotation(node.angle/180*M_PI);
    if (lastIndex != currentIndex) { // 轨迹跑完之后，重新开始
        BMKSportNode *node = [sportNodes objectAtIndex:currentIndex];
        sportAnnotation.coordinate = node.coordinate;
        lastIndex = currentIndex;
        if (isAnimate == YES) {
            [self running_track];
        }
    } else {
        CGFloat time = (13 - self.speed)/13.0 * (node.distance/node.speed);//(22 - self.speed)/10.0 * (node.distance/node.speed);
        //取绝对值
        time = time < 0?-time:time;
        // 定时器间隔是1s，所以超过1s，设置为1s
        time = time > 1?1:time;
        NSLog(@"----某段轨迹需要的时间---%f-------",time);
        [UIView animateWithDuration:time animations:^{
            if (currentIndex < sportNodeNum - 1) {
                currentIndex++;
                BMKSportNode *node = [sportNodes objectAtIndex:currentIndex];
                sportAnnotation.coordinate = node.coordinate;
                
                CGFloat currentTime = [self.currentTimeArr[currentIndex] floatValue];
                //时间进度显示
                //[playBackView setCurrentTime:currentTime];
                //进度条进度显示
                //[playBackView.playTimeSlide setValue: currentTime/self.totalTime animated: YES];
                // 播放速度为0的时候，不处理
                if ((13 - self.speed) == 13) {
                } else {
                    [playBackView.playTimeSlide setValue: currentTime/self.totalTime animated: YES];
                }
            } else {
                return ;
            }
        } completion:^(BOOL finished) {
            lastIndex = currentIndex;
            if (isAnimate) {
                [self running_track];
            }
        }];
    }
}
- (void)animateToNextCoord:(GMSMarker *)marker {
    CoordsList *coords = marker.userData;
    CLLocationCoordinate2D coord = [coords next];
    CLLocationCoordinate2D previous = marker.position;
    if (coord.latitude != -1 && coord.longitude != -1) {
        if (lastIndex != currentIndex) {
            CLLocationDirection heading = GMSGeometryHeading(previous, coord);
            marker.position = coord;
            if (marker.flat) {
                marker.rotation = heading;
            }
            [CATransaction begin];
            [CATransaction setAnimationDuration: 0.01];
            __weak MainMapViewController *weakSelf = self;
            [CATransaction setCompletionBlock:^{
                
                if (isAnimate == YES) {
                    [weakSelf animateToNextCoord:marker];
                }
            }];
            marker.position = coord;
            [CATransaction commit];
            [self.googleMapView.superview layoutIfNeeded];
            currentIndex = coords.target;
            lastIndex = coords.target;
            
        } else {
            CLLocationDirection heading = GMSGeometryHeading(previous, coord);
            CLLocationDistance distance = GMSGeometryDistance(previous, coord);
            // Use CATransaction to set a custom duration for this animation. By default, changes to the
            // position are already animated, but with a very short default duration. When the animation is
            // complete, trigger another animation step.
            [CATransaction begin];
            //CGFloat time = (13 - self.speed)/13.0 * (node.distance/node.speed);
            // 速度默认30
            CGFloat time = (distance/(self.speed?self.speed:30));
            time = time > 1?1:time;
            time = (13 - self.speed)/13.0 * time;
            [CATransaction setAnimationDuration:time];//(distance / (22 + self.speed * 2))
            __weak MainMapViewController *weakSelf = self;
            [CATransaction setCompletionBlock:^{
                
                if (isAnimate == YES) {
                    [weakSelf animateToNextCoord:marker];
                }
            }];
            marker.position = coord;
            [CATransaction commit];
            // If this marker is flat, implicitly trigger a change in rotation, which will finish quickly.
            if (marker.flat) {
                marker.rotation = heading;
            }
            if (currentIndex < sportNodes.count - 1) {
                //BMKSportNode *node = sportNodes[currentIndex];
                //NSString *timeString = [MINUtils getTimeFromTimestamp: node.create_time formatter: @"YYYY-MM-dd HH:mm:ss"];
                //playBackView.timeSpeedDistanceLabel.text = @"";//[NSString stringWithFormat: @"%@ 速度:%.0fKm/h 里程:%.2fKm", timeString, node.speed, node.distance / 1000];
                [UIView animateWithDuration:time animations:^{ //(distance / (22 + self.speed * 2))
                    [playBackView.playTimeSlide setValue: [self.currentTimeArr[currentIndex] floatValue] / self.totalTime animated: YES];
                }];
                [playBackView setCurrentTime: [self.currentTimeArr[currentIndex] floatValue]];
            }
            currentIndex = coords.target;
            lastIndex = coords.target;
        }
        
    } else {
        marker = [GMSMarker markerWithPosition:[self.linePath coordinateAtIndex:0]];
        playBackView.playBtn.selected = NO;
        playBackView.playTimeSlide.value = 0;
        playBackView.starTimeLabel.text = @"00:00";
        isAnimate = NO;
        
        CoordsList *coords = marker.userData;
        coords.target = 0;
        currentIndex = 0;
        lastIndex = 0;
    }
}
- (UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - MINPickerViewDelegate
- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic {
    NSNumber *selectNum = dic[@"0"];
    if (pickerView == longPressPickerView) {
        if ([selectNum integerValue] == 0) { // 单次定位命令
            [self requestDeviceSingleLocation];
        }else if ([selectNum integerValue] == 1) { // 多次定位命令
            [self requestDeviceMultiplePositioning];
        }else {
            
        }
        longPressPickerView = nil;
    }
}
- (void)requestDeviceSingleLocation {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    __weak __typeof__(self) weakSelf = self;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl: @"devControlController/getDevPos" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [MINUtils showProgressHudToView: weakSelf.view withText:Localized(@"单次定位成功")];
        } else {
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)requestDeviceMultiplePositioning {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    __weak __typeof__(self) weakSelf = self;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl: @"devControlController/getDevMulPos" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [MINUtils showProgressHudToView: weakSelf.view withText:Localized(@"多次定位成功")];
        } else {
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)minPickerViewdidSelectCancelBtn:(MINPickerView *)pickerView {
    longPressPickerView = nil;
}
#pragma mark -- 手势代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (CGRectContainsPoint(self.sliderView.frame, [gestureRecognizer locationInView:self.view]) ) {
        return NO;
    } else {
        return YES;
    }
}
- (void)taphandle:(UITapGestureRecognizer*)sender {
    [self.view endEditing:YES];
    [self hideListView];
}
#pragma mark -- 每20s刷新各设备详情
- (void)getDeviceLocationInfoRequest {
    if (self.paopaoView.isAlertPaopaoView == YES) {
        // 打开设备详情窗口时候，bu刷新数据,即不重置标注导致标注移动
        NSLog(@"弹出弹框时，不刷新不刷新不刷新不刷新不刷新不刷新");
        return;
    }
    
    if ([AppDelegate shareInstance].isShowPlayBackView == YES) {
        // 回放轨迹的时候 不刷新设备位置
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    kWeakSelf(self);
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [[CBNetworkRequestManager sharedInstance] getSingeDeviceInfoDataParamters:paramters success:^(CBBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD hideHUDForView:self.baiduView animated:YES];
        self.baiduView.hidden = [AppDelegate shareInstance].IsShowGoogleMap;
        self.googleView.hidden = ![AppDelegate shareInstance].IsShowGoogleMap;
        if ([[self getCurrentVC] isKindOfClass:[MainMapViewController class]]) {
            [[CBPetTopSwitchBtnView share] showCtrlPanelWithResultBlock:^{
            }];
            [[CBPetBottomSwitchBtnView share] showCtrlPanelWithResultBlock:^{
            }];
        }
        NSLog(@"----单个设备列表:--%@------",baseModel.data);
        switch (baseModel.status) {
            case CBNetworkingStatus0:
            {
                // 清除地图标注和轨迹
                [self clearBaiduMap];
                [self.googleMapView clear];
                self.googleMapView.selectedMarker = nil;
                
                // 设备信息存储到本地
                [CBCommonTools saveCBdeviceInfoList:baseModel];
                
                // 本地读取存储的 选择过的信息
                self.deviceInfoModelSelect = [CBCommonTools CBdeviceInfo];
                CBHomeLeftMenuDeviceInfoModel *deviceInfoModel;
                NSMutableDictionary *deviceDic = [NSMutableDictionary dictionary];
                for (NSDictionary *dic in baseModel.data) {
                    CBHomeLeftMenuDeviceInfoModel *model = [CBHomeLeftMenuDeviceInfoModel mj_objectWithKeyValues:dic];
                    if ([model.dno isEqualToString:self.deviceInfoModelSelect.dno]) {
                        deviceInfoModel = model;
                        // 选中设备添加围栏,百度地图添加围栏中心点会变
                        [self createFenceMethod:model];
                    }
                    // 添加地图标注
                    [self filterAnnotation:model];
        
                    DeviceDetailModel *modelDetail = [DeviceDetailModel yy_modelWithJSON:dic];
                    [deviceDic setValue:modelDetail forKey:modelDetail.dno?:@""];
                }
                // 存储选中的设备
                [CBCommonTools saveCBdeviceInfoListDic:deviceDic];
                if (((NSArray *)baseModel.data).count ==0) {
                    self.noDeviceDataView.hidden = NO;
                    self.baiduView.hidden = YES;
                    self.googleView.hidden = YES;
                } else {
                    self.noDeviceDataView.hidden = YES;
                }
                
                kWeakSelf(self);
                self.noDeviceDataView.noDataBlock = ^{
                    kStrongSelf(self);
                    AddDeviceViewController *bindVC = [[AddDeviceViewController alloc]init];
                    bindVC.isBind = YES;
                    [self.navigationController pushViewController:bindVC animated:YES];
                };
                
                if (self.isStartTrack) {
                    [self startTrack:deviceInfoModel];
                }
                
                self.navigationItem.title = self.deviceInfoModelSelect.name?:@"";
                if (self.deviceInfoModelSelect.dno == nil) {
                    return;
                }
                if (deviceInfoModel.dno) {
                    deviceInfoModel.zoomLevel = self.deviceInfoModelSelect.zoomLevel;
                    deviceInfoModel.devStatus = self.deviceInfoModelSelect.devStatus;
                    deviceInfoModel.productSpecId = self.deviceInfoModelSelect.productSpecId;
                    deviceInfoModel.proto = self.deviceInfoModelSelect.proto;
                    self.deviceInfoModelSelect = deviceInfoModel;
                    [CBCommonTools saveCBdeviceInfo:self.deviceInfoModelSelect];
                }
                
                //更新中心位置
                [self updateMapCenter];
//                [self saveTrackInfo:deviceInfoModel];
            }
                break;
            default:
            {
                [HUD showHUDWithText:baseModel.resmsg withDelay:3.0];
            }
                break;
        }
        self.baiduView.hidden = [AppDelegate shareInstance].IsShowGoogleMap;
        self.googleView.hidden = ![AppDelegate shareInstance].IsShowGoogleMap;
        if ([[self getCurrentVC] isKindOfClass:[MainMapViewController class]]) {
            [[CBPetTopSwitchBtnView share] showCtrlPanelWithResultBlock:^{
            }];
            [[CBPetBottomSwitchBtnView share] showCtrlPanelWithResultBlock:^{
            }];
        }
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD hideHUDForView:self.baiduView animated:YES];
        self.baiduView.hidden = [AppDelegate shareInstance].IsShowGoogleMap;
        self.googleView.hidden = ![AppDelegate shareInstance].IsShowGoogleMap;
        if ([[self getCurrentVC] isKindOfClass:[MainMapViewController class]]) {
            [[CBPetTopSwitchBtnView share] showCtrlPanelWithResultBlock:^{
            }];
            [[CBPetBottomSwitchBtnView share] showCtrlPanelWithResultBlock:^{
            }];
        }
    }];
}
//- (void)saveTrackInfo:(CBHomeLeftMenuDeviceInfoModel *)deviceInfoModel {
//
//}
- (void)startTrack:(CBHomeLeftMenuDeviceInfoModel *)deviceInfoModel {
    TrackModel *trackModel = [[TrackModel alloc]init];//[TrackModel yy_modelWithDictionary:baseModel.data];
    trackModel.lat = deviceInfoModel.lat.doubleValue;
    trackModel.lng = deviceInfoModel.lng.doubleValue;
    trackModel.speed = deviceInfoModel.speed.doubleValue;
    BMKSportNode *sportModel = [[BMKSportNode alloc] init];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(trackModel.lat,trackModel.lng);
    
    if ([AppDelegate shareInstance].IsShowGoogleMap) {
        // google地图
        sportModel.coordinate = coor;
        //[sportNodes_realTime addObject:sportModel];
        if (!(deviceInfoModel.lat.doubleValue == self.deviceInfoModelSelect.lat.doubleValue && deviceInfoModel.lng.doubleValue == self.deviceInfoModelSelect.lng.doubleValue)) {
            // 位置不变
            //CGFloat distance = [_googleMapView getd];
            // 第二个点有距离的时候再打点
            [self->sportNodes_realTime addObject:sportModel];
        }
        sportNodeNum_realTime = sportNodes_realTime.count;
        
        // 有两点时，创建轨迹
        if (sportNodes_realTime.count > 1) {
            self.polyline_realTime.strokeColor = kRGB(128, 189, 86);
            self.polyline_realTime.strokeWidth = 2*KFitWidthRate;
            for(int idx = 0; idx < sportNodes_realTime.count; idx++)
            {
                BMKSportNode *node = [sportNodes_realTime objectAtIndex:idx];
                CLLocationCoordinate2D location = node.coordinate;
                [self.linePath_realTime addCoordinate:location];
                
                // 添加轨迹上的圆点
                if (idx > 0 && idx < (sportNodes_realTime.count - 1)) {
                    
                    GMSMarker *mark_point = [[GMSMarker alloc] init];
                    mark_point.appearAnimation = kGMSMarkerAnimationNone;//kGMSMarkerAnimationPop;
                    mark_point.position = location;
                    CBTrackPointView *iconView = [[CBTrackPointView alloc]initWithFrame:CGRectMake(0, 0, 10*KFitWidthRate, 10*KFitWidthRate)];
                    mark_point.iconView = iconView;
                    mark_point.groundAnchor = CGPointMake(0.5, 0.5);
                    mark_point.map = self.googleMapView;
                }
            }
//            BMKSportNode *firstNode = [sportNodes_realTime objectAtIndex:0];
//            CLLocationCoordinate2D coordinate = firstNode.coordinate;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                _googleMapView.camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:self.deviceInfoModelSelect.zoomLevel.integerValue];
//            });
            self.polyline_realTime.path = self.linePath_realTime;
            self.polyline_realTime.map = _googleMapView;
        }
        //更新中心位置
        [self.googleMapView setCamera:[GMSCameraPosition cameraWithLatitude:self.deviceInfoModelSelect.lat.doubleValue longitude:self.deviceInfoModelSelect.lng.doubleValue zoom:self.deviceInfoModelSelect.zoomLevel.integerValue]];
    } else {
        // 百度地图
        [self setupMapZoomLevelMethod];
        sportModel.coordinate = coor;
        if (!(deviceInfoModel.lat.doubleValue == self.deviceInfoModelSelect.lat.doubleValue && deviceInfoModel.lng.doubleValue == self.deviceInfoModelSelect.lng.doubleValue)) {
            // 位置不变 不打点
            [sportNodes_realTime addObject:sportModel];
        }
        sportNodeNum_realTime = sportNodes_realTime.count;
        
        // 有两点时，创建轨迹
        if (sportNodes_realTime.count > 1) {
            CLLocationCoordinate2D paths[sportNodeNum_realTime];
            for (NSInteger i = 0; i < sportNodeNum_realTime ; i++) {
                BMKSportNode *node = sportNodes_realTime[i];
                paths[i] = node.coordinate;
            }
            // 添加圆点标注
            for (NSInteger i = 0; i < sportNodeNum_realTime ; i++) {
                sportPointAnnotation_realTime = [[CBSportAnnotation alloc]init];
                sportPointAnnotation_realTime.coordinate = paths[i];
                [self.baiduMapView addAnnotation:sportPointAnnotation_realTime];
            }
            // 创建轨迹路径
            pathPloyline_realTime = [BMKPolyline polylineWithCoordinates: paths count:sportNodeNum_realTime];
            [self.baiduMapView addOverlay:pathPloyline_realTime];
        }
        //更新中心位置
        CLLocationCoordinate2D coorData = CLLocationCoordinate2DMake(self.deviceInfoModelSelect.lat.doubleValue, self.deviceInfoModelSelect.lng.doubleValue);
        [self.baiduMapView setCenterCoordinate:coorData animated: YES];
    }
}
#pragma mark -- 从缓存里获取设备详情，并居中显示,刷新地图
- (void)getLocalDeviceInfoBaseModel {
    // 清除地图标注和轨迹
    [self clearBaiduMap];
    [self.googleMapView clear];
    self.googleMapView.selectedMarker = nil;
    // 设备详情从本地取
    CBBaseNetworkModel *deviceInfoList = [CBCommonTools CBdeviceInfoList];
    CBHomeLeftMenuDeviceInfoModel *deviceInfoModel;
    for (NSDictionary *dic in deviceInfoList.data) {
        CBHomeLeftMenuDeviceInfoModel *model = [CBHomeLeftMenuDeviceInfoModel yy_modelWithJSON:dic];
        if ([model.dno isEqualToString:self.deviceInfoModelSelect.dno]) {
            deviceInfoModel = model;
        }
        // 添加地图标注
        [self filterAnnotation:model];
    }
    if ([AppDelegate shareInstance].IsShowGoogleMap) {
        //更新中心位置
        [self.googleMapView setCamera:[GMSCameraPosition cameraWithLatitude:self.deviceInfoModelSelect.lat.doubleValue longitude:self.deviceInfoModelSelect.lng.doubleValue zoom:self.deviceInfoModelSelect.zoomLevel.integerValue]];
    } else {
        //更新中心位置
        CLLocationCoordinate2D coorData = CLLocationCoordinate2DMake(self.deviceInfoModelSelect.lat.doubleValue, self.deviceInfoModelSelect.lng.doubleValue);
        [self.baiduMapView setCenterCoordinate:coorData animated:YES];
    }
}
- (void)startTimer {
    if (!self.homeTimer || ![self.homeTimer isValid]) {
        [self getDeviceLocationInfoRequest];
        kWeakSelf(self);
        if (@available(iOS 10.0, *)) {
            self.homeTimer = [NSTimer scheduledTimerWithTimeInterval:20.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
                kStrongSelf(self);
                [self getDeviceLocationInfoRequest];
            }];
        } else {
            // Fallback on earlier versions
        }
    }
}
- (void)endTimer {
    if ([self.homeTimer isValid]) {
        [self.homeTimer invalidate];
        self.homeTimer = nil;
    }
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //定位失败，作相应处理。
    NSLog(@"定位失败");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // 定位失败的话，默认使用百度地图，国内
    [AppDelegate shareInstance].IsShowGoogleMap = NO;
    [self baiduMap];
    [self googleMap];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.locationManager stopUpdatingLocation];
    CLLocation *curLocation = [locations firstObject];
    //通过location得到当前位置的经纬度
    CLLocationCoordinate2D curCoordinate2D = curLocation.coordinate;
    if ([CBCommonTools checkIsChina:CLLocationCoordinate2DMake(curCoordinate2D.latitude,curCoordinate2D.longitude)]) {
        curCoordinate2D = [TQLocationConverter transformFromWGSToGCJ:curCoordinate2D];
    }
    NSLog(@"latitude = %f, longitude = %f dd%@", curCoordinate2D.latitude, curCoordinate2D.longitude,[AppDelegate shareInstance].IsShowGoogleMap?@"yes":@"no");

    /* 确定当前地区是国内还是国外后，选择使用地图的类型 */
//    [AppDelegate shareInstance].IsShowGoogleMap = ![CBCommonTools checkIsChina:CLLocationCoordinate2DMake(curCoordinate2D.latitude,curCoordinate2D.longitude)];
    
    [self baiduMap];
    [self googleMap];
    
    if ([AppDelegate shareInstance].isShowPlayBackView) {
        // 回看轨迹页面，不刷新
        return;
    }
    
    CLLocationCoordinate2D realCoor = curCoordinate2D;
    // 更新选中的设备在地图中位置
    if ([AppDelegate shareInstance].IsShowGoogleMap == NO) {
        [self.baiduMapView setCenterCoordinate:realCoor animated: YES];
    } else {
        [self.googleMapView setCamera:[GMSCameraPosition cameraWithLatitude:realCoor.latitude longitude:realCoor.longitude zoom:16]];
    }
    
    self.deviceInfoModelSelect = [CBCommonTools CBdeviceInfo];
    if (self.deviceInfoModelSelect) {
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(self.deviceInfoModelSelect.lat.doubleValue,  self.deviceInfoModelSelect.lng.doubleValue);
        self.navigationItem.title = self.deviceInfoModelSelect.name?:@"";
        // 更新选中的设备在地图中位置
        if ([AppDelegate shareInstance].IsShowGoogleMap == NO) {
            [self.baiduMapView setCenterCoordinate:coor animated: YES];
        } else {
            [self.googleMapView setCamera:[GMSCameraPosition cameraWithLatitude:self.deviceInfoModelSelect.lat.doubleValue longitude:self.deviceInfoModelSelect.lng.doubleValue zoom:self.deviceInfoModelSelect.zoomLevel.integerValue]];
        }
    }
}
- (void)filterAnnotation:(CBHomeLeftMenuDeviceInfoModel*)deviceInfoModel {
    [self updateMapMarkMethod:deviceInfoModel];
}
#pragma mark -- 添加标注
- (void)updateMapMarkMethod:(CBHomeLeftMenuDeviceInfoModel *)deviceInfoModel {
    [self setupMapZoomLevelMethod];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(deviceInfoModel.lat.doubleValue,  deviceInfoModel.lng.doubleValue);
    // 小车定位图标
    MINNormalAnnotation *normalAnnotation = [[MINNormalAnnotation alloc] init];
    normalAnnotation.icon = [CBCommonTools returnDeveceLocationImageStr:deviceInfoModel.icon isOnline:deviceInfoModel.online isWarmed:deviceInfoModel.warmed];
    normalAnnotation.warmed = deviceInfoModel.warmed;
    normalAnnotation.coordinate = coor;
    if ([deviceInfoModel.dno isEqualToString:self.deviceInfoModelSelect.dno]) {
        normalAnnotation.isSelect = YES;// 选中设备显示最前
    }
    [self.baiduMapView addAnnotation: normalAnnotation];
    
    // 小车定位上方信息
    MINNormalInfoAnnotation *normalInfoAnnotation = [[MINNormalInfoAnnotation alloc] init];
    normalInfoAnnotation.deviceName = deviceInfoModel.name?:@"";
    normalInfoAnnotation.speed = deviceInfoModel.speed?:@"";
    normalInfoAnnotation.warmed = deviceInfoModel.warmed;
    normalInfoAnnotation.coordinate = coor;
    if ([deviceInfoModel.dno isEqualToString:self.deviceInfoModelSelect.dno]) {
        normalInfoAnnotation.isSelect = YES;// 选中设备显示最前
    }
    [self.baiduMapView addAnnotation: normalInfoAnnotation];
    
    // 小车定位图标
    GMSMarker *normalMarker = [[GMSMarker alloc] init];
    normalMarker.appearAnimation = kGMSMarkerAnimationPop;
    normalMarker.position = coor;
    //normalMarker.title = @"marker";
    UIImage *icon = [CBCommonTools returnDeveceLocationImageStr:deviceInfoModel.icon isOnline:deviceInfoModel.online isWarmed:deviceInfoModel.warmed];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, icon.size.width, icon.size.height)];
    imageView.image = icon;
    normalMarker.iconView = imageView;
    normalMarker.groundAnchor = CGPointMake(0.5, 0.5);
    normalMarker.map = self.googleMapView;
    if ([deviceInfoModel.dno isEqualToString:self.deviceInfoModelSelect.dno]) {
        // 选中设备显示最前
        //normalMarker.map.selectedMarker = normalMarker;
        self.googleMapView.selectedMarker = normalMarker;
    }
    
    // 小车定位上方信息
    GMSMarker *normalInfoMarker = [[GMSMarker alloc] init];
    normalInfoMarker.appearAnimation = kGMSMarkerAnimationPop;
    normalInfoMarker.position = coor;
    //normalInfoMarker.groundAnchor = CGPointMake(0.5f, 0.5f);
    normalInfoMarker.groundAnchor = CGPointMake(0.5f, 1.5f);
    MINMapPaoPaoView *iconView = [[MINMapPaoPaoView alloc] initWithNormalFrame: CGRectMake(0, 0, 147 * KFitWidthRate, 53.5 * KFitWidthRate)];
    iconView.titleLabel.text = deviceInfoModel.name?:@"";
//    iconView.speedAndStayLabel.text = [NSString stringWithFormat:@"%@:%@Km/h",Localized(@"速度"),deviceInfoModel.speed?:@"0"];
    normalInfoMarker.iconView = iconView;
//    if ([deviceInfoModel.warmed isEqualToString:@"1"]) {
//        iconView.backView.backgroundColor = [UIColor redColor];
//        iconView.titleLabel.textColor = [UIColor whiteColor];;
//        iconView.speedAndStayLabel.textColor = [UIColor whiteColor];
//    } else if ([deviceInfoModel.warmed isEqualToString:@"0"]) {
//        iconView.backView.backgroundColor = [UIColor clearColor];
//        iconView.titleLabel.textColor = kBlueColor;
//        iconView.speedAndStayLabel.textColor = [UIColor blackColor];
//    } else {
//        iconView.backgroundColor = [UIColor clearColor];
//        iconView.titleLabel.textColor = kBlueColor;
//        iconView.speedAndStayLabel.textColor = [UIColor blackColor];
//    }
    normalInfoMarker.map = self.googleMapView;
    if ([deviceInfoModel.dno isEqualToString:self.deviceInfoModelSelect.dno]) {
        // 选中设备显示最前
        //normalMarker.map.selectedMarker = normalMarker;
        self.googleMapView.selectedMarker = normalMarker;
    }
}
#pragma mark -- 创建围栏
- (void)createFenceMethod:(CBHomeLeftMenuDeviceInfoModel*)deviceInfoModel {
    if (deviceInfoModel.listFence.count > 0) {
        for (CBHomeLeftMenuDeviceInfoModelFenceModel *model in deviceInfoModel.listFence) {
            [self createFence:model];
        }
    }
}
- (NSMutableArray *)getModelArr:(NSString *)dataString {
    NSArray *dataArr = [dataString componentsSeparatedByString: @","];
    NSMutableArray *modelArr = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i = i + 2  ) {//i = i + 2
        if ((i + 1 ) < dataArr.count) {
            MINCoordinateObject *model = [[MINCoordinateObject alloc] init];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake( [dataArr[i] doubleValue], [dataArr[i + 1] doubleValue]);
            model.coordinate = coordinate;
            [modelArr addObject: model];
        }
    }
    return modelArr;
}
- (void)createFence:(CBHomeLeftMenuDeviceInfoModelFenceModel *)model {
    NSString *dataString = model.data;
    switch (model.shape.integerValue) {
        case 0:
        {// 多边形
            self.polygonCoordinateArr = [self getModelArr:dataString];
            if (self.baiduView.hidden == NO) {
                [self addBaiduPolygon];
                [self baiduMapFitFence: self.polygonCoordinateArr];
            } else {
                [self addGooglePolygon];
                [self googleMapFitFence: self.polygonCoordinateArr];
            }
        }
            break;
        case 1:
        {// 圆
            NSArray *dataArr = [dataString componentsSeparatedByString: @","];
            if (dataArr.count == 3) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake( [dataArr[0] doubleValue], [dataArr[1] doubleValue]);
                MINCoordinateObject *circleModel = [[MINCoordinateObject alloc] init];
                circleModel.coordinate = coordinate;
                self.circleCoordinate = coordinate;
                if (self.baiduView.hidden == NO) {
                    //[self addAnnotation_baidu:coordinate];
                    [self addBaiduCircleMarkerWithRadius: dataArr.lastObject];
                    [self baiduMapFitCircleFence: circleModel radius: [dataArr[2] doubleValue]];
                }else {
                    [self addGoogleCircleMarkerWithRadius: dataArr.lastObject];
                    [self googleMapFitCircleFence: circleModel radius: [dataArr[2] doubleValue]];
                }
            }
        }
            break;
        case 2:
        {// 矩形
            self.rectangleCoordinateArr = [self getModelArr:dataString];
            if (self.baiduView.hidden == NO) {
                [self addBaiduRectangle];
                [self baiduMapFitFence: self.rectangleCoordinateArr];
            }else {
                [self addGoogleRectangle];
                [self googleMapFitFence: self.rectangleCoordinateArr];
            }
        }
            break;
        case 3:
        {// 线路
            self.pathleCoordinateArr = [self getModelArr:dataString];
            if (self.baiduView.hidden == NO) {
                [self addBaiduPath];
                [self baiduMapFitFence: self.pathleCoordinateArr];
            }else {
                [self addGooglePath];
                [self googleMapFitFence: self.pathleCoordinateArr];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark -- 设置地图比例
- (void)setupMapZoomLevelMethod {
    if (self.deviceInfoModelSelect.zoomLevel) {
        self.baiduMapView.zoomLevel = self.deviceInfoModelSelect.zoomLevel.integerValue;//20;
    }
}
- (void)updateMapCenter {
    if (!self.deviceInfoModelSelect) {
        return;
    }
    if ([AppDelegate shareInstance].IsShowGoogleMap) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.googleMapView.camera = [GMSCameraPosition cameraWithLatitude:self.deviceInfoModelSelect.lat.doubleValue longitude:self.deviceInfoModelSelect.lng.doubleValue zoom:self.deviceInfoModelSelect.zoomLevel.integerValue];
        });
    } else {
        //更新中心位置
        CLLocationCoordinate2D coorData = CLLocationCoordinate2DMake(self.deviceInfoModelSelect.lat.doubleValue, self.deviceInfoModelSelect.lng.doubleValue);
        [self.baiduMapView setCenterCoordinate:coorData animated: YES];
    }
}
#pragma mark -- UITabBarViewController delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    // 未选中设备时，控制模块和报表模块不能点击
    if ([viewController.tabBarItem.title isEqualToString:Localized(@"控制")] || [viewController.tabBarItem.title isEqualToString:Localized(@"报表")]) {
        CBPetLoginModel *userLogin = [CBPetLoginModelTool getUser];
        CBHomeLeftMenuDeviceInfoModel *deviceModelInfo = [CBCommonTools CBdeviceInfo];
        // 没有选中
        if (deviceModelInfo == nil) {
            [HUD showHUDWithText:Localized(@"请在左上角菜单选择设备") withDelay:2.0];
            return NO;
        } else {
            // 0为查看权限
            if ([userLogin.auth isEqualToString:@"0"]) {
                [HUD showHUDWithText:Localized(@"无权限访问") withDelay:2.0];
                return NO;
            } else {
                return YES;
            }
        }
    } else {
        return YES;
    }
}
#pragma mark - Other Method
- (void)addBaiduPolygon {
    //[self clearMap];
    CLLocationCoordinate2D coords[self.polygonCoordinateArr.count];
    for (int i = 0; i < self.polygonCoordinateArr.count; i++) {
        MINCoordinateObject *obj = self.polygonCoordinateArr[i];
        coords[i] = obj.coordinate;
    }
    BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count: self.polygonCoordinateArr.count];
    [_baiduMapView addOverlay:polygon];
}
- (void)addGooglePolygon {
    //[self clearMap];
    GMSMutablePath *path = [GMSMutablePath path];
    for (int i = 0; i < self.polygonCoordinateArr.count; i++) {
        MINCoordinateObject *obj = self.polygonCoordinateArr[i];
        [path addLatitude: obj.coordinate.latitude longitude: obj.coordinate.longitude];
    }
    GMSPolygon *polygon = [GMSPolygon polygonWithPath: path];
    polygon.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    polygon.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    polygon.strokeWidth = 0;//2;
    polygon.map = _googleMapView;
}
- (void)addBaiduCircleMarkerWithRadius:(NSString *)radius {
    CGFloat radiusNum = [radius floatValue];
    BMKCircle *circle = [BMKCircle circleWithCenterCoordinate: self.circleCoordinate radius: radiusNum];
    [_baiduMapView addOverlay: circle];
}
- (void)addGoogleCircleMarkerWithRadius:(NSString *)radius {
    CGFloat radiusNum = [radius floatValue];
    GMSCircle *circ = [GMSCircle circleWithPosition:self.circleCoordinate
                                             radius:radiusNum];
    circ.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    circ.strokeColor = [UIColor clearColor];
    //circ.strokeWidth = 0;
    circ.map = _googleMapView;
}
// 百度圆
- (void)baiduMapFitCircleFence:(MINCoordinateObject *)model radius:(double)radius {
    // 一个点的长度是0.870096
    BMKMapPoint circlePoint = BMKMapPointForCoordinate(model.coordinate);
    BMKMapRect fitRect;
    double pointRadius = radius / 0.6;//0.870096;
    fitRect.origin = BMKMapPointMake(circlePoint.x - pointRadius, circlePoint.y - pointRadius);
    fitRect.size = BMKMapSizeMake(pointRadius * 2, pointRadius * 2);
    [_baiduMapView setVisibleMapRect: fitRect];
    //_baiduMapView.zoomLevel = 16;////_baiduMapView.zoomLevel - 0.3;
    [_baiduMapView setCenterCoordinate:model.coordinate];
}
- (void)addGoogleRectangle {
    //[self clearMap];
    MINCoordinateObject *firstObj = self.rectangleCoordinateArr.firstObject;
    MINCoordinateObject *lastObj = self.rectangleCoordinateArr.lastObject;
    CLLocationCoordinate2D firstCoor = firstObj.coordinate;
    CLLocationCoordinate2D lastCoor = lastObj.coordinate;
    CLLocationCoordinate2D leftTop;
    CLLocationCoordinate2D leftBottom;
    CLLocationCoordinate2D rightTop;
    CLLocationCoordinate2D rightBottom;
    if (firstCoor.latitude > lastCoor.latitude && firstCoor.longitude < lastCoor.longitude) {
        leftTop = firstCoor;
        rightBottom = lastCoor;
        leftBottom.latitude = lastCoor.latitude;
        leftBottom.longitude = firstCoor.longitude;
        rightTop.latitude = firstCoor.latitude;
        rightTop.longitude = lastCoor.longitude;
    }else if (firstCoor.latitude > lastCoor.latitude && firstCoor.longitude > lastCoor.longitude) {
        rightTop = firstCoor;
        leftBottom = lastCoor;
        leftTop.latitude = firstCoor.latitude;
        leftTop.longitude = lastCoor.longitude;
        rightBottom.latitude = lastCoor.latitude;
        rightBottom.longitude = firstCoor.longitude;
    }else if (firstCoor.latitude < lastCoor.latitude && firstCoor.longitude < lastCoor.longitude) {
        leftBottom = firstCoor;
        rightTop = lastCoor;
        leftTop.latitude = lastCoor.latitude;
        leftTop.longitude = firstCoor.longitude;
        rightBottom.latitude = firstCoor.latitude;
        rightBottom.longitude = lastCoor.longitude;
    }else {
        leftTop = lastCoor;
        rightBottom = firstCoor;
        leftBottom.latitude = firstCoor.latitude;
        leftBottom.longitude = lastCoor.longitude;
        rightTop.latitude = lastCoor.latitude;
        rightTop.longitude = firstCoor.longitude;
    }
    GMSMutablePath *rect = [GMSMutablePath path];
    [rect addCoordinate: leftTop];
    [rect addCoordinate: rightTop];
    [rect addCoordinate: rightBottom];
    [rect addCoordinate: leftBottom];
    
    GMSPolygon *polygon = [GMSPolygon polygonWithPath:rect];
    polygon.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    polygon.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    polygon.strokeWidth = 0;//2;
    polygon.map = _googleMapView;
}

- (void)addBaiduRectangle {
    //[self clearMap];
    MINCoordinateObject *firstObj = self.rectangleCoordinateArr.firstObject;
    MINCoordinateObject *lastObj = self.rectangleCoordinateArr.lastObject;
    CLLocationCoordinate2D firstCoor = firstObj.coordinate;
    CLLocationCoordinate2D lastCoor = lastObj.coordinate;
    CLLocationCoordinate2D leftTop;
    CLLocationCoordinate2D leftBottom;
    CLLocationCoordinate2D rightTop;
    CLLocationCoordinate2D rightBottom;
    if (firstCoor.latitude > lastCoor.latitude && firstCoor.longitude < lastCoor.longitude) {
        leftTop = firstCoor;
        rightBottom = lastCoor;
        leftBottom.latitude = lastCoor.latitude;
        leftBottom.longitude = firstCoor.longitude;
        rightTop.latitude = firstCoor.latitude;
        rightTop.longitude = lastCoor.longitude;
    }else if (firstCoor.latitude > lastCoor.latitude && firstCoor.longitude > lastCoor.longitude) {
        rightTop = firstCoor;
        leftBottom = lastCoor;
        leftTop.latitude = firstCoor.latitude;
        leftTop.longitude = lastCoor.longitude;
        rightBottom.latitude = lastCoor.latitude;
        rightBottom.longitude = firstCoor.longitude;
    }else if (firstCoor.latitude < lastCoor.latitude && firstCoor.longitude < lastCoor.longitude) {
        leftBottom = firstCoor;
        rightTop = lastCoor;
        leftTop.latitude = lastCoor.latitude;
        leftTop.longitude = firstCoor.longitude;
        rightBottom.latitude = firstCoor.latitude;
        rightBottom.longitude = lastCoor.longitude;
    }else {
        leftTop = lastCoor;
        rightBottom = firstCoor;
        leftBottom.latitude = firstCoor.latitude;
        leftBottom.longitude = lastCoor.longitude;
        rightTop.latitude = lastCoor.latitude;
        rightTop.longitude = firstCoor.longitude;
    }
    CLLocationCoordinate2D coords[4];
    coords[0] = leftTop;
    coords[1] = rightTop;
    coords[2] = rightBottom;
    coords[3] = leftBottom;
    BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count:4];
    [_baiduMapView addOverlay:polygon];
}
- (void)addGooglePath {
    //[self clearMap];
    GMSMutablePath *path = [GMSMutablePath path];
    for (int i = 0; i < self.pathleCoordinateArr.count; i++) {
        MINCoordinateObject *obj = self.pathleCoordinateArr[i];
        [path addLatitude: obj.coordinate.latitude longitude: obj.coordinate.longitude];
    }
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 4 * KFitWidthRate;
    polyline.strokeColor = kBlueColor;
    polyline.geodesic = YES;
    polyline.map = _googleMapView;
}
- (void)addBaiduPath {
    //[self clearMap];
    CLLocationCoordinate2D coords[self.pathleCoordinateArr.count];
    for (int i = 0; i < self.pathleCoordinateArr.count; i++) {
        MINCoordinateObject *obj = self.pathleCoordinateArr[i];
        coords[i] = obj.coordinate;
    }
    BMKPolyline *polygon = [BMKPolyline polylineWithCoordinates:coords count: self.pathleCoordinateArr.count];
    [_baiduMapView addOverlay:polygon];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
