//
//  SetGuardFenceViewController.m
//  Watch
//
//  Created by lym on 2018/4/19.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "SetGuardFenceViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <GoogleMaps/GoogleMaps.h>
#import "HomeModel.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
//BMKLocationKit
#import <CoreLocation/CoreLocation.h>
#import "HomeLocationView.h"
#import "CBWtSchoolAnnotation.h"
#import "CBWtCoordinateObject.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "GuardIndoModel.h"
#import "FenceInfoView.h"
#import "FenceAdreesInfoView.h"
#import "CBWtMINAlertView.h"

#import "CBGuardSearchResultTableViewCell.h"

#import "ZCChinaLocation.h"
#import "TQLocationConverter.h"
#import "CBGuardSliderView.h"
#import "CBGuardAnnotationView.h"
#import "CBGuardGSMarkView.h"

/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"


@interface SetGuardFenceViewController ()<BMKMapViewDelegate, GMSMapViewDelegate, BMKGeoCodeSearchDelegate,UITableViewDelegate,UITableViewDataSource,BMKPoiSearchDelegate,CLLocationManagerDelegate>
{
    FenceAdreesInfoView *homeInfoView;
    NSArray *_arrayResult;
}
@property (nonatomic, strong) BMKMapView *baiduMapView;
@property (nonatomic, strong) GMSMapView *googleMapView;
@property (nonatomic, strong) UIView *baiduView;
@property (nonatomic, strong) UIView *googleView;
@property (nonatomic, strong) BMKGeoCodeSearch *searcher;
@property (nonatomic, strong) MBProgressHUD *dataHud;
@property (nonatomic, strong) UIButton *navigationBtn; // 导航按钮
@property (nonatomic, strong) UIButton *zoomInBtn; // 放大按钮
@property (nonatomic, strong) UIButton *zoomOutBtn; // 缩小按钮

@property (nonatomic, strong) GMSMarker *schoolMarker;
@property (nonatomic, strong) GMSMarker *homeMarker;

@property (nonatomic, strong) CBWtSchoolAnnotation *schoolAnnotation;
@property (nonatomic, strong) CBWtSchoolAnnotation *homeAnnotation;

@property (nonatomic, strong) BMKPointAnnotation *myLocationAnnotation;

@property (nonatomic, strong) GMSCircle *googleFenceCircle;
@property (nonatomic, strong) BMKCircle *baiduFenceCircle;

/** 折线图点数组 */
@property (nonatomic, strong) NSMutableArray *polygonCoordinateArr;
/** 折线图点数组设置时存储 */
@property (nonatomic, strong) NSMutableArray *polygonCoordinateArrTemp;
/** 折线图点数组设置时存储 */
@property (nonatomic, strong) NSMutableArray *polygonCoordinateParamters;

/** 百度地图poi搜索 */
@property (nonatomic, strong) BMKPoiSearch *poiSearch;
/** 定位 */
@property (nonatomic, strong) CLLocationManager *locationManager;
/** 当前位置 */
@property (nonatomic, assign) CLLocationCoordinate2D curCoordinate2D;
/** 标记 更新当前位置 只更新一次 */
@property (nonatomic,assign) int tag;
/** 底部滑动改变围栏范围view */
@property (nonatomic, strong) CBGuardSliderView *sliderView;
/** 刷新按钮 */
@property (nonatomic,strong) UIButton *btnRefresh;
/** 标记刷新动作 */
@property (nonatomic,assign) BOOL isRefresh;
/** 设置学校或家庭围栏，中心点反地理编码 */
@property (nonatomic,assign) BOOL setSchoolOrHomeAddFlag;

@end

@implementation SetGuardFenceViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [_baiduMapView viewWillAppear];
    _baiduMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    if ([AppDelegate shareInstance].IsShowGoogleMap == NO) {
        self.baiduView.hidden = NO;
        self.googleView.hidden = YES;
    } else {
        self.baiduView.hidden = YES;
        self.googleView.hidden = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [_baiduMapView viewWillDisappear];
    _baiduMapView.delegate = nil; // 不用时，置nil

    self.isRefresh = NO;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.tag = 0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    //[self addSchoolAndHomeMarkerFence];
    [self addSchoolAndHomeMarkerFence_polygon];
    
    _arrayResult = [NSMutableArray array];
    [self showMyLoaction];

    homeInfoView.addressLabel.text = self.isSetSchoolFence?self.guardModel.schoolAddress:self.guardModel.homeAddress;
    [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"请在地图选择至少三个点,组成多边形区域")];
}
#pragma mark - CreateUI
- (void)createUI {
    [self initBarWithTitle: Localized(@"设置地址") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"保存") target: self action: @selector(rightBtnClick)];
    [self baiduMap];
    [self googleMap];
    [self createHomeWatchInfoView];
    //    [self addNavigationBtnAndZoomBtn];
    [self sliderView];
}
- (void)createHomeWatchInfoView {
    homeInfoView = [[FenceAdreesInfoView alloc] init];
    homeInfoView.backgroundColor = KWtRGB(255, 255, 255);
    [self.view addSubview: homeInfoView];
    [homeInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        if ([AppDelegate shareInstance].IsShowGoogleMap == YES) {
            make.height.mas_equalTo(45);
        } else {
            make.height.mas_equalTo(45 + 40);
        }
    }];
    if ([AppDelegate shareInstance].IsShowGoogleMap == YES) {
        [homeInfoView updateInfoViewIsGoogle:YES];
    }
    kWeakSelf(self);
    homeInfoView.returnBlock = ^(id action, id objc) {
        kStrongSelf(self);
        [self dealWithTableView:action searchKey:objc];
    };
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(homeInfoView.mas_bottom).offset(-300);
        make.height.mas_equalTo(44*3);
    }];
}
- (void)baiduMap {
    _baiduView = [[UIView alloc] init];
    [self.view addSubview: _baiduView];
    [_baiduView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    _baiduView.hidden = [AppDelegate shareInstance].IsShowGoogleMap;
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
    //设定是否总让选中的annotaion置于最前面
    _baiduMapView.isSelectedAnnotationViewFront = YES;
}
- (void)googleMap {
    _googleView = [[UIView alloc] init];
    _googleView.hidden = ![AppDelegate shareInstance].IsShowGoogleMap;
    [self.view addSubview: _googleView];
    [_googleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.056898
                                                            longitude:116.307626
                                                                 zoom:16];
    _googleMapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) camera:camera];
    //    _googleMapView.myLocationEnabled = YES;
    _googleMapView.delegate = self;
    [_googleView addSubview: _googleMapView];
}
- (BMKPoiSearch *)poiSearch {
    if (!_poiSearch) {
        _poiSearch = [[BMKPoiSearch alloc]init];
        _poiSearch.delegate = self;
    }
    return _poiSearch;
}
- (CBGuardSliderView *)sliderView {
    if (!_sliderView) {
        UIImage *imgRefresh = [UIImage imageNamed:@"ic_refresh_location"];
        _btnRefresh = [[UIButton alloc]init];
        [_btnRefresh setImage:imgRefresh forState:UIControlStateNormal];
        [self.view addSubview:_btnRefresh];
        [_btnRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-TabPaddingBARHEIGHT-30);
            make.right.mas_equalTo(-15*frameSizeRate);
            make.size.mas_equalTo(CGSizeMake(60*frameSizeRate, 60));
        }];
        [_btnRefresh addTarget:self action:@selector(updateLocationClick) forControlEvents:UIControlEventTouchUpInside];

        [self.view bringSubviewToFront:_btnRefresh];
    }
    return _sliderView;
}
- (NSMutableArray *)polygonCoordinateArr {
    if (!_polygonCoordinateArr) {
        _polygonCoordinateArr = [NSMutableArray array];
    }
    return _polygonCoordinateArr;
}
- (NSMutableArray *)polygonCoordinateParamters {
    if (!_polygonCoordinateParamters) {
        _polygonCoordinateParamters = [NSMutableArray array];
    }
    return _polygonCoordinateParamters;
}
- (NSMutableArray *)polygonCoordinateArrTemp {
    if (!_polygonCoordinateArrTemp) {
        _polygonCoordinateArrTemp = [NSMutableArray array];
    }
    return _polygonCoordinateArrTemp;
}
- (void)showMyLoaction {
    //定位管理器
    _locationManager = [[CLLocationManager alloc]init];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
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
        NSLog(@"请打开定位权限");
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:Localized(@"提示") message:Localized(@"请到设置->隐私->定位服务中开启【巴诺手表 APP】定位服务，以便于能够准确获得你的位置信息") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
        }];
        UIAlertAction *actionSet = [UIAlertAction actionWithTitle:Localized(@"去设置") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [alertVC addAction:actionSet];
        [alertVC addAction:actionCancel];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}
#pragma mark -- 创建围栏 （多边形）
- (void)addSchoolAndHomeMarkerFence_polygon {
    NSString *dataString;
    if (self.isSetSchoolFence == YES) {
        dataString = self.guardModel.schoolData;
        self.polygonCoordinateArr = [self getModelArr:dataString];
        if (self.baiduView.hidden == NO) {
            [self addBaiduPolygon];
            [self baiduMapFitFence:self.polygonCoordinateArr isConvert:YES];
        } else {
            [self addGooglePolygon];
            [self googleMapFitFence:self.polygonCoordinateArr];
            _googleMapView.camera = [GMSCameraPosition cameraWithLatitude:self.guardModel.centerlLat
                                                                longitude:self.guardModel.centerLng
                                                                     zoom:_googleMapView.camera.zoom - 2];
        }
    } else {
        dataString = self.guardModel.homeData;
        self.polygonCoordinateArr = [self getModelArr:dataString];
        if (self.baiduView.hidden == NO) {
            [self addBaiduPolygon];
            [self baiduMapFitFence: self.polygonCoordinateArr isConvert:YES];
        } else {
            [self addGooglePolygon];
            [self googleMapFitFence: self.polygonCoordinateArr];
            _googleMapView.camera = [GMSCameraPosition cameraWithLatitude:self.guardModel.centerlLat
                                                                longitude:self.guardModel.centerLng
                                                                     zoom:_googleMapView.camera.zoom - 2];
        }
    }
    // 添加标注
    [self addHomeAndSchoolAnnotation];
}
- (void)addBaiduPolygon {
    //[self clearMap];
    CLLocationCoordinate2D coords[self.polygonCoordinateArr.count];
    for (int i = 0; i < self.polygonCoordinateArr.count; i++) {
        CBWtCoordinateObject *obj = self.polygonCoordinateArr[i];
        coords[i] = obj.coordinate;
    }
    BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count:self.polygonCoordinateArr.count];
    [_baiduMapView addOverlay:polygon];
}
- (void)addGooglePolygon {
    //[self clearMap];
    GMSMutablePath *path = [GMSMutablePath path];
    for (int i = 0; i < self.polygonCoordinateArr.count; i++) {
        CBWtCoordinateObject *obj = self.polygonCoordinateArr[i];
        [path addLatitude: obj.coordinate.latitude longitude: obj.coordinate.longitude];
    }
    GMSPolygon *polygon = [GMSPolygon polygonWithPath: path];
    polygon.fillColor = [UIColor colorWithRed:15.0/255.0 green:126.0/255.0 blue:255.0/255.0 alpha:0.6];
    polygon.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    polygon.strokeWidth = 0;
    polygon.map = _googleMapView;
}
- (void)addHomeAndSchoolAnnotation {
    NSLog(@"添加中心位置标注次数");
    if (self.isSetSchoolFence == YES) {
        // 学校标注
        [self schoolAnnotation];
        [self schoolMarker];
    } else {
        [self homeAnnotation];
        [self homeMarker];
    }
}
- (CBWtSchoolAnnotation *)schoolAnnotation {
    if (!_schoolAnnotation) {
        _schoolAnnotation = [[CBWtSchoolAnnotation alloc] init];
        _schoolAnnotation.coordinate = CLLocationCoordinate2DMake(self.guardModel.centerlLat , self.guardModel.centerLng);
        [self.baiduMapView addAnnotation:_schoolAnnotation];
        [self.baiduMapView setCenterCoordinate:_schoolAnnotation.coordinate animated:YES];
    }
    return _schoolAnnotation;
}
- (GMSMarker *)schoolMarker {
    if (!_schoolMarker) {
        _schoolMarker = [GMSMarker markerWithPosition: CLLocationCoordinate2DMake(self.guardModel.centerlLat,self.guardModel.centerLng)];
        _schoolMarker.map = self.googleMapView;
        _schoolMarker.groundAnchor = CGPointMake(0.5, 0);
        _schoolMarker.icon = [UIImage imageNamed: @"学校"];
    }
    return _schoolMarker;
}
- (CBWtSchoolAnnotation *)homeAnnotation {
    if (!_homeAnnotation) {
        _homeAnnotation = [[CBWtSchoolAnnotation alloc] init];
        _homeAnnotation.coordinate = CLLocationCoordinate2DMake(self.guardModel.centerlLat , self.guardModel.centerLng);
        [self.baiduMapView addAnnotation:_homeAnnotation];
        [self.baiduMapView setCenterCoordinate:_homeAnnotation.coordinate animated:YES];
    }
    return _homeAnnotation;
}
- (GMSMarker *)homeMarker {
    if (!_homeMarker) {
        _homeMarker = [GMSMarker markerWithPosition: CLLocationCoordinate2DMake(self.guardModel.centerlLat,self.guardModel.centerLng)];
        _homeMarker.map = self.googleMapView;
        _homeMarker.icon = [UIImage imageNamed: @"家"];
        _homeMarker.groundAnchor = CGPointMake(0.5, 0);
    }
    return _homeMarker;
}
// 使百度地图展示完整的围栏，位置位置并处于地图中心 多边形，矩形，线路 isConvert 是否要转换百度坐标系
- (void)baiduMapFitFence:(NSArray *)modelArr isConvert:(BOOL)isConvert {
    CBWtCoordinateObject *firstModel = modelArr.firstObject;
    BMKMapPoint firstPoint = BMKMapPointForCoordinate(firstModel.coordinate);
    CGFloat leftX, leftY, rightX, rightY; // 最左或右边的X、Y
    rightX = leftX = firstPoint.x;
    rightY = leftY = firstPoint.y;
    NSDecimalNumber *latCenterD = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    NSDecimalNumber *lngCenterD = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    for (int i = 0; i < modelArr.count; i++) {
        CBWtCoordinateObject *model = modelArr[i];
        BMKMapPoint modelPoint = BMKMapPointForCoordinate(model.coordinate);
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
//        NSDecimalNumber *latD = [[NSDecimalNumber alloc]initWithDouble:isConvert?coorReal.latitude:model.coordinate.latitude];
//        NSDecimalNumber *lngD = [[NSDecimalNumber alloc]initWithDouble:isConvert?coorReal.longitude:model.coordinate.longitude];
        NSDecimalNumber *latD = [[NSDecimalNumber alloc]initWithDouble:model.coordinate.latitude];
        NSDecimalNumber *lngD = [[NSDecimalNumber alloc]initWithDouble:model.coordinate.longitude];
        latCenterD = [latCenterD decimalNumberByAdding:latD];
        lngCenterD = [lngCenterD decimalNumberByAdding:lngD];
    }
    if (isConvert) {
        BMKMapRect fitRect;
        fitRect.origin = BMKMapPointMake(leftX, leftY);
        fitRect.size = BMKMapSizeMake(rightX - leftX, rightY - leftY);
        [_baiduMapView setVisibleMapRect: fitRect];
        _baiduMapView.zoomLevel = _baiduMapView.zoomLevel - 2;//0.3;
    }
    NSDecimalNumber *countD = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",@(modelArr.count == 0?1:modelArr.count)]];
    NSDecimalNumber *rLatD = [latCenterD decimalNumberByDividingBy:countD];
    NSDecimalNumber *rLngD = [lngCenterD decimalNumberByDividingBy:countD];
    NSLog(@"dddddd::%@  %@",rLatD,rLngD);
    self.guardModel.centerlLat = rLatD.doubleValue;
    self.guardModel.centerLng = rLngD.doubleValue;
}
- (void)googleMapFitFence:(NSArray *)modelArr {
    NSDecimalNumber *latCenterD = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    NSDecimalNumber *lngCenterD = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    for (int i = 0 ; i < modelArr.count ; i ++ ) {
        CBWtCoordinateObject *model = modelArr[i];
        NSDecimalNumber *latD = [[NSDecimalNumber alloc]initWithDouble:model.coordinate.latitude];
        NSDecimalNumber *lngD = [[NSDecimalNumber alloc]initWithDouble:model.coordinate.longitude];
        latCenterD = [latCenterD decimalNumberByAdding:latD];
        lngCenterD = [lngCenterD decimalNumberByAdding:lngD];
    }
    NSDecimalNumber *countD = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",@(modelArr.count == 0?1:modelArr.count)]];
    NSDecimalNumber *rLatD = [latCenterD decimalNumberByDividingBy:countD];
    NSDecimalNumber *rLngD = [lngCenterD decimalNumberByDividingBy:countD];
    self.guardModel.centerlLat = rLatD.doubleValue;
    self.guardModel.centerLng = rLngD.doubleValue;
    NSLog(@"dddddd::%@  %@",rLatD,rLngD);
}
- (NSMutableArray *)getModelArr:(NSString *)dataString {
    NSArray *dataArr = [dataString componentsSeparatedByString: @","];
    NSMutableArray *modelArr = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i = i + 2  ) {//i = i + 2
        if ((i + 1 ) < dataArr.count) {
            CBWtCoordinateObject *model = [[CBWtCoordinateObject alloc] init];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dataArr[i] doubleValue], [dataArr[i + 1] doubleValue]);
            model.coordinate = coordinate;
            [modelArr addObject: model];
        }
    }
    return modelArr;
}
- (void)clearMap {
    if (self.baiduView.hidden == NO) {
        [self.baiduMapView removeOverlays: self.baiduMapView.overlays];
        [self.baiduMapView removeAnnotations: self.baiduMapView.annotations];
    } else {
        [self.googleMapView clear];
    }
}
#pragma mark -- 修改上学守护信息
- (void)rightBtnClick {
    if (self.polygonCoordinateArrTemp.count < 3) {
        [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"请在地图选择至少三个点,组成多边形区域")];
        return;
    }
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
    if (self.isSetSchoolFence == YES) {
        paramters[@"schoolData"] = self.guardModel.schoolData;
        paramters[@"schoolAddress"] = self.guardModel.schoolAddress;
        NSLog(@"============%@====%@==%@====",paramters,paramters[@"schoolData"],paramters[@"schoolAddress"]);
    } else {
        paramters[@"homeData"] = self.guardModel.homeData;
        paramters[@"homeAddress"] = self.guardModel.homeAddress;
        NSLog(@"============%@====%@==%@====",paramters,paramters[@"homeData"],paramters[@"homeAddress"]);
    }
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl:@"watch/watch/updGoShcool" params:paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed ) {
            [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"修改成功")];
            [self.navigationController popViewControllerAnimated: YES];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)sliderValueChangeAction_updateFence:(NSInteger)radius {
    self.baiduFenceCircle.radius = radius;
    self.googleFenceCircle.radius = radius;
    if (self.isSetSchoolFence == YES) {
        self.guardModel.schoolRange = (NSInteger)radius;
    } else {
        self.guardModel.homeRange = (NSInteger)radius;
    }
}
- (void)updateLocationClick {
    self.isRefresh = YES;
    //更新定位
    [_locationManager startUpdatingLocation];
    [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"刷新成功")];
}
#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if (self.dataHud != nil) {
        [self.dataHud hideAnimated: YES];
    }
    if (error == BMK_SEARCH_NO_ERROR) {
        if (!self.isRefresh) {
            if (self.isSetSchoolFence == YES) {
                self.guardModel.schoolAddress = result.address;
            } else {
                self.guardModel.homeAddress = result.address;
            }
        }
        // 四边形反向地理编码
        if (self.setSchoolOrHomeAddFlag) {
            NSLog(@"位置::::%@",result.address);
            if (self.isSetSchoolFence == YES) {
                self.guardModel.schoolAddress = result.address;
                self.guardModel.schoolData = [self.polygonCoordinateParamters componentsJoinedByString:@","];
            } else {
                self.guardModel.homeAddress = result.address;
                self.guardModel.homeData = [self.polygonCoordinateParamters componentsJoinedByString:@","];
            }
            homeInfoView.addressLabel.text = self.isSetSchoolFence?self.guardModel.schoolAddress:self.guardModel.homeAddress;
        }
    } else {
        NSLog(@"未找到结果");
        homeInfoView.addressLabel.text = @"";
    }
}
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPOISearchResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        _arrayResult = poiResult.poiInfoList;
    } else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        _arrayResult = @[];
    } else {
        _arrayResult = @[];
    }
    [self.tableView reloadData];
}
#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass: [CBWtSchoolAnnotation class]]) {
        NSString *AnnotationViewID = @"SchoolOrHomeAnnationView";
        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    annotationView.centerOffset = CGPointMake(0, 0.1);//5 0.1
        //annotationView.calloutOffset = CGPointMake(0.5, 0.5);
        if ([annotation isEqual:_schoolAnnotation]) {
            annotationView.image = [UIImage imageNamed: @"学校"];
        } else {
            annotationView.image = [UIImage imageNamed: @"家"];
        }
        return annotationView;
    } else if (annotation == self.myLocationAnnotation) {
        NSString *AnnotationViewID = @"myLocationAnnationView";
        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annotationView.image = [UIImage imageNamed:@"定位-当前自己位置"];
        return annotationView;
    } else if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier111";
        CBGuardAnnotationView *annotationView = (CBGuardAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[CBGuardAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.image = [UIImage imageNamed:@""];
        return annotationView;
    }
    return nil;
}
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView *circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [UIColor colorWithRed:15.0/255 green:126.0/255 blue:255.0/255 alpha:0.3];
        return circleView;
    } else if ([overlay isKindOfClass:[BMKPolygon class]]) {
        BMKPolygonView *polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [UIColor blackColor];
        polygonView.fillColor = [UIColor colorWithRed:15.0/255.0 green:126.0/255.0 blue:255.0/255.0 alpha:0.6];
        return polygonView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    if (_arrayResult.count > 0) {
        _arrayResult = @[];
        [self.tableView reloadData];
    }
    NSLog(@"-------------百度地图点击空白处-----------");
    // 四边形标注
    BMKPointAnnotation *annotationMarker = [[BMKPointAnnotation alloc]init];
    annotationMarker.coordinate = coordinate;
    [_baiduMapView addAnnotation:annotationMarker];
    
    // 四边形线
    CBWtCoordinateObject *coorObj = [[CBWtCoordinateObject alloc] init];
    coorObj.coordinate = coordinate;
    [self.polygonCoordinateArrTemp addObject:coorObj];
    [self.polygonCoordinateParamters addObject:[NSString stringWithFormat:@"%@",@(coordinate.latitude)]];
    [self.polygonCoordinateParamters addObject:[NSString stringWithFormat:@"%@",@(coordinate.longitude)]];
    
    if (self.polygonCoordinateArrTemp.count > 2) {
        [self.baiduMapView removeOverlays: self.baiduMapView.overlays];
        CLLocationCoordinate2D coords[self.polygonCoordinateArrTemp.count];
        for (int i = 0; i < self.polygonCoordinateArrTemp.count; i++) {
            CBWtCoordinateObject *obj = self.polygonCoordinateArrTemp[i];
            coords[i] = obj.coordinate;
        }
        BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count:self.polygonCoordinateArrTemp.count];
        [_baiduMapView addOverlay:polygon];
        
        [self baiduMapFitFence:self.polygonCoordinateArrTemp isConvert:NO];
        if (self.isSetSchoolFence == YES) {
            // 学校标注
            self.schoolAnnotation.coordinate = CLLocationCoordinate2DMake(self.guardModel.centerlLat, self.guardModel.centerLng);
        
        } else {
            self.homeAnnotation.coordinate = CLLocationCoordinate2DMake(self.guardModel.centerlLat, self.guardModel.centerLng);
        }
        BMKReverseGeoCodeSearchOption *reverseGeoCodeOpetion = [[BMKReverseGeoCodeSearchOption alloc]init];
        reverseGeoCodeOpetion.location = CLLocationCoordinate2DMake(self.guardModel.centerlLat, self.guardModel.centerLng);
        self.setSchoolOrHomeAddFlag = [self.searcher reverseGeoCode:reverseGeoCodeOpetion];
        if (self.setSchoolOrHomeAddFlag) {
            NSLog(@"设置学校或者家庭中心位置经纬度反geo检索发送成功");
        } else {
            NSLog(@"设置学校或者家庭中心位置经纬度反geo检索发送失败");
        }
    }
}
- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"-------------双击空白处-----------");
    if (_arrayResult.count > 0) {
        _arrayResult = @[];
        [self.tableView reloadData];
    }
    [self reverseGeoCodeWithCoordinate: coordinate];
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
}
- (void)reverseGeoCodeWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self.isRefresh = NO;
    // 谷歌地图坐标中 上传参数无需转换
    if (self.isSetSchoolFence == YES) {
        self.guardModel.schoolLat = coordinate.latitude;
        self.guardModel.schoolLng = coordinate.longitude;
    } else {
        self.guardModel.homeLat = coordinate.latitude;
        self.guardModel.homeLng = coordinate.longitude;
    }
    CLLocationCoordinate2D realCoor = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude);
    BMKReverseGeoCodeSearchOption *reverseGeoCodeOpetion = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeoCodeOpetion.location = realCoor;
    BOOL flag = [self.searcher reverseGeoCode: reverseGeoCodeOpetion];
    if (flag) {
        NSLog(@"反geo检索发送成功");
    } else {
        NSLog(@"反geo检索发送失败");
    }
    // 百度地图坐标中 上传参数要将百度坐标系转为通用
    if (self.isSetSchoolFence == YES) {
        self.guardModel.schoolLat = realCoor.latitude;
        self.guardModel.schoolLng = realCoor.longitude;
    } else {
        self.guardModel.homeLat = realCoor.latitude;
        self.guardModel.homeLng = realCoor.longitude;
    }
    
    self.baiduFenceCircle.coordinate = coordinate;
    self.schoolAnnotation.coordinate = coordinate;
    if (self.isSetSchoolFence == YES) {
        self.schoolAnnotation.coordinate = coordinate;
    } else {
        self.homeAnnotation.coordinate = coordinate;
    }
    //[self.baiduMapView setCenterCoordinate:coordinate];
}
#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    CBWtCoordinateObject *coorObj = [[CBWtCoordinateObject alloc] init];
    coorObj.coordinate = coordinate;
    [self.polygonCoordinateArrTemp addObject:coorObj];
    [self.polygonCoordinateParamters addObject:[NSString stringWithFormat:@"%@",@(coordinate.latitude)]];
    [self.polygonCoordinateParamters addObject:[NSString stringWithFormat:@"%@",@(coordinate.longitude)]];
  
    CBGuardGSMarkView *pointView = [[CBGuardGSMarkView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
    pointView.backgroundColor = UIColor.clearColor;
    GMSMarker *polygonMarker = [GMSMarker markerWithPosition:coordinate];
    polygonMarker.map = self.googleMapView;
    polygonMarker.iconView = pointView;
    polygonMarker.groundAnchor = CGPointMake(0.5, 0);
    
    if (self.polygonCoordinateArrTemp.count > 2) {
        [self.googleMapView clear];
        GMSMutablePath *path = [GMSMutablePath path];
        for (int i = 0; i < self.polygonCoordinateArrTemp.count; i++) {
            CBWtCoordinateObject *obj = self.polygonCoordinateArrTemp[i];
            [path addLatitude:obj.coordinate.latitude longitude:obj.coordinate.longitude];
            // 添加标注
            CBGuardGSMarkView *pointViewAgain = [[CBGuardGSMarkView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
            pointViewAgain.backgroundColor = UIColor.clearColor;
            GMSMarker *polygonMarkerAgain = [GMSMarker markerWithPosition:obj.coordinate];
            polygonMarkerAgain.map = self.googleMapView;
            polygonMarkerAgain.iconView = pointViewAgain;
            polygonMarkerAgain.groundAnchor = CGPointMake(0.5, 0);
        }
        GMSPolygon *polygon = [GMSPolygon polygonWithPath:path];
        polygon.fillColor = [UIColor colorWithRed:15.0/255.0 green:126.0/255.0 blue:255.0/255.0 alpha:0.6];
        polygon.strokeColor = UIColor.clearColor;
        polygon.strokeWidth = 0;
        polygon.map = _googleMapView;
        
        [self googleMapFitFence:self.polygonCoordinateArrTemp];
        if (self.isSetSchoolFence == YES) {
            // 学校标注
            self.schoolMarker = [GMSMarker markerWithPosition: CLLocationCoordinate2DMake(self.guardModel.centerlLat,self.guardModel.centerLng)];
            self.schoolMarker.map = self.googleMapView;
            self.schoolMarker.groundAnchor = CGPointMake(0.5, 0);
            self.schoolMarker.icon = [UIImage imageNamed: @"学校"];
        } else {
            self.homeMarker = [GMSMarker markerWithPosition: CLLocationCoordinate2DMake(self.guardModel.centerlLat,self.guardModel.centerLng)];
            self.homeMarker.map = self.googleMapView;
            self.homeMarker.icon = [UIImage imageNamed: @"家"];
            self.homeMarker.groundAnchor = CGPointMake(0.5, 0);
        }
        // 当前位置
        GMSMarker *myLocationMarker = [GMSMarker markerWithPosition:self.curCoordinate2D];
        myLocationMarker.map = self.googleMapView;
        myLocationMarker.groundAnchor = CGPointMake(0.5, 0);
        myLocationMarker.icon = [UIImage imageNamed:@"定位-当前自己位置"];
        
        // 谷歌地图反向地理编码
        GMSGeocoder *geocoder = [[GMSGeocoder alloc]init];
        [geocoder reverseGeocodeCoordinate:CLLocationCoordinate2DMake(self.guardModel.centerlLat,self.guardModel.centerLng) completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
            if (response.results.count > 0) {
                GMSAddress *address = response.results[0];
                NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@%@",address.country,address.administrativeArea,address.locality,address.subLocality,address.thoroughfare];
                NSLog(@"位置::::%@",addressStr);
                if (self.isSetSchoolFence == YES) {
                    self.guardModel.schoolAddress = addressStr;
                    self.guardModel.schoolData = [self.polygonCoordinateParamters componentsJoinedByString:@","];
                } else {
                    self.guardModel.homeAddress = addressStr;
                    self.guardModel.homeData = [self.polygonCoordinateParamters componentsJoinedByString:@","];
                }
                homeInfoView.addressLabel.text = self.isSetSchoolFence?self.guardModel.schoolAddress:self.guardModel.homeAddress;
            }
        }];
    }
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    return YES;
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //定位失败，作相应处理。
    NSLog(@"定位失败----:%@",error);
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [manager stopUpdatingLocation]; //取到定位即可停止刷新，没有必要一直刷新，耗电。
    [self.locationManager stopUpdatingLocation];
    CLLocation *curLocation = [locations firstObject];
    //通过location得到当前位置的经纬度
    self.curCoordinate2D = curLocation.coordinate;
    self.curCoordinate2D = BMKCoordTrans(CLLocationCoordinate2DMake(self.curCoordinate2D.latitude, self.curCoordinate2D.longitude), BMK_COORDTYPE_GPS, BMK_COORDTYPE_COMMON);
    self.isRefresh = YES;
    // 反向地理编码,转为百度地图坐标系，然后用百度地图反向地理编码
    BMKReverseGeoCodeSearchOption *reverseGeoCodeOpetion = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeoCodeOpetion.location = self.curCoordinate2D;
    BOOL flag = [self.searcher reverseGeoCode: reverseGeoCodeOpetion];
    if(flag) {
        NSLog(@"反geo检索发送成功");
    }else {
        NSLog(@"反geo检索发送失败");
    }
    if (self.tag == 0) {
        self.myLocationAnnotation = [[BMKPointAnnotation alloc] init];
        self.myLocationAnnotation.coordinate = self.curCoordinate2D;
        [self.baiduMapView addAnnotation: self.myLocationAnnotation];;
        self.tag = 1;
        [self.baiduMapView setCenterCoordinate:self.curCoordinate2D];
        //self.curCoordinate2D =
        
        GMSMarker *myLocationMarker = [GMSMarker markerWithPosition:self.curCoordinate2D];
        myLocationMarker.map = self.googleMapView;
        myLocationMarker.groundAnchor = CGPointMake(0.5, 0);
        myLocationMarker.icon = [UIImage imageNamed:@"定位-当前自己位置"];
        // 添加围栏后，居中
        self.googleMapView.camera = [GMSCameraPosition cameraWithLatitude:self.curCoordinate2D.latitude longitude:self.curCoordinate2D.longitude zoom:14];
    }
}
#pragma mark -- tableView datasource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayResult.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBGuardSearchResultTableViewCell *cell;
    cell = [CBGuardSearchResultTableViewCell cellCopyTableView:tableView];
    if (_arrayResult.count > indexPath.row) {
        BMKPoiInfo *poiInModel = _arrayResult[indexPath.row];
        cell.textLabel.text = poiInModel.name;//address;//@"666";
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_arrayResult.count > indexPath.row) {
        BMKPoiInfo *poiInModel = _arrayResult[indexPath.row];
        //告知需要更改约束
        [self.view setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(0);
                make.top.mas_equalTo(homeInfoView.mas_bottom).offset(-300);
                make.height.mas_equalTo(44*3);
            }];
            //告知父类控件绘制
            [self.tableView.superview layoutIfNeeded];
        }];
        [self.view endEditing:YES];
        [self reverseGeoCodeWithCoordinate:poiInModel.pt];
    }
}
- (void)dealWithTableView:(id)action searchKey:(NSString *)key {
    if ([action isEqualToString:@"beginEdit"]) {
        //告知需要更改约束
        [self.view setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(0);
                make.top.mas_equalTo(homeInfoView.mas_bottom).offset(0);
                make.height.mas_equalTo(44*3);
            }];
            //告知父类控件绘制
            //[self.tableView.superview layoutIfNeeded];必须添加在动画的block中，不然就会导致动画无法实现。
            [self.tableView.superview layoutIfNeeded];
        }];
        [self baiduPIOsearchKey:key];
    } else if ([action isEqualToString:@"endEdit"]) {
    } else if ([action isEqualToString:@"valueChage"]) {
        NSLog(@"+++++++++变化+++%@++++++++++++",key);
        [self baiduPIOsearchKey:key];
    }
}
#pragma mark -- 百度地图PIO检索
- (void)baiduPIOsearchKey:(NSString *)key {
    BMKPOINearbySearchOption *geoCodeOpetionNearby = [[BMKPOINearbySearchOption alloc]init];
    geoCodeOpetionNearby.location = self.curCoordinate2D;
    geoCodeOpetionNearby.pageSize = 50;
    geoCodeOpetionNearby.isRadiusLimit = YES;
    geoCodeOpetionNearby.radius = 100000000;//100000000; //搜索范围;
    geoCodeOpetionNearby.keywords = @[key?:@""];
    BOOL flag = [self.poiSearch poiSearchNearBy:geoCodeOpetionNearby];
    if (flag) {
        NSLog(@"geo检索发送成功");
    } else {
        NSLog(@"geo检索发送失败");
    }
}
#pragma mark -- 谷歌地图PIO检索(检索有问题，中文不能检索)
//- (void)googlePIOsearchKey:(NSString *)key {
//    self.placeClient = [GMSPlacesClient sharedClient];//获取某个地点的具体信息
//    [self.placeClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
//        if (error != nil) {
//            NSLog(@"PIO位置%@==",[error description]);
//            return ;
//        }
//        //这里就可以获取到POI的名字了
//        //这里做一些你想做的事
//        for (GMSPlaceLikelihood *likelihood in likelihoodList.likelihoods) {
//            GMSPlace* place = likelihood.place;
//            NSLog(@"Current Place name %@ at likelihood %g", place.name, likelihood.likelihood);
//            NSLog(@"Current Place address %@", place.formattedAddress);
//            NSLog(@"Current Place attributions %@", place.attributions);
//            NSLog(@"Current PlaceID %@", place.placeID);
//        }
//    }];
//}
//- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//- (void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    NSLog(@"出现反复调用%@==",[error description]);
//}
#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
