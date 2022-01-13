//
//  HomeLocationViewController.m
//  Watch
//
//  Created by lym on 2018/4/17.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "HomeLocationViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <GoogleMaps/GoogleMaps.h>
#import "HomeModel.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "CBWtNormalAnnotation.h"
#import "HomeLocationView.h"
#import "CBWtSchoolAnnotation.h"
#import "CBWtCoordinateObject.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "GuardIndoModel.h"
#import "CBAvatarAnnotationView.h"
#import "CBAvatarMarkView.h"
#import "CBHomeLocationBottomView.h"

#import <MapKit/MapKit.h>
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

@interface HomeLocationViewController ()<BMKMapViewDelegate, GMSMapViewDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKMapView *baiduMapView;
@property (nonatomic, strong) GMSMapView *googleMapView;
@property (nonatomic, strong) UIView *baiduView;
@property (nonatomic, strong) UIView *googleView;
@property (nonatomic, strong) BMKGeoCodeSearch *searcher;
@property (nonatomic, strong) MBProgressHUD *dataHud;

@property (nonatomic, strong) UIButton *navigationBtn; // 导航按钮
@property (nonatomic, strong) UIButton *zoomInBtn;     // 放大按钮
@property (nonatomic, strong) UIButton *zoomOutBtn;    // 缩小按钮
@property (nonatomic, strong) UIButton *refreshBtn;    // 刷新定位按钮

@property (nonatomic, strong) HomeLocationView *homeTopInfoView;

@property (nonatomic, strong) GMSMarker *watchMarker;
@property (nonatomic, strong) GMSMarker *schoolMarker;
@property (nonatomic, strong) GMSMarker *homeMarker;
@property (nonatomic, strong) CBWtNormalAnnotation *watchAnnotation;
@property (nonatomic, strong) CBWtSchoolAnnotation *schoolAnnotation;
@property (nonatomic, strong) CBWtSchoolAnnotation *homeAnnotation;

/** 学校和家庭坐标模型 */
@property (nonatomic, strong) GuardIndoModel *guardModel;
@property (nonatomic,strong) UIImage *avatarImg;
@property (nonatomic,strong) NSTimer *timerRefreshData;
@property (nonatomic,assign) NSTimeInterval timerInterval;
@property (nonatomic, assign) BOOL isRefresh;

@property (nonatomic, strong) CBHomeLocationBottomView *bottomInfoView;
@property (nonatomic, assign) BOOL isPop;

/** google地图标注图 */
@property (nonatomic,strong) CBAvatarMarkView *avtarMarkView;
/** 折线图点数组学校 */
@property (nonatomic, strong) NSMutableArray *polygonCoordinateArrSchool;
/** 折线图点数组家庭 */
@property (nonatomic, strong) NSMutableArray *polygonCoordinateArrHome;

@end

@implementation HomeLocationViewController

- (void)viewWillAppear:(BOOL)animated {
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
    [self requestInfoData];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [_baiduMapView viewWillDisappear];
    _baiduMapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 关掉定时器
    [self.timerRefreshData invalidate];
    self.timerRefreshData = nil;
    self.timerInterval = 60;
    self.isRefresh = NO;
}
- (void)dealloc {
    [self.timerRefreshData invalidate];
    self.timerRefreshData = nil;
    self.timerInterval = 60;
    self.isRefresh = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    /* 更新手表位置*/
    [self updateWatchInfoRequest];
}
- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self initBarWithTitle:Localized(@"定位") isBack: YES];
    [self baiduView];
    [self googleView];
    [self homeTopInfoView];
    [self bottomInfoView];
    [self addNavigationBtnAndZoomBtn];
    [self refreshBtn];
    
    [self.navigationBtn addTarget: self action: @selector(navigationBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.zoomInBtn addTarget: self action: @selector(zoomInBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.zoomOutBtn addTarget: self action: @selector(zoomOutBtnClick) forControlEvents: UIControlEventTouchUpInside];
}
#pragma mark - Getting && Setting Method
- (HomeLocationView *)homeTopInfoView {
    if (!_homeTopInfoView) {
        _homeTopInfoView = [[HomeLocationView alloc] init];
        [self.view addSubview: _homeTopInfoView];
        [_homeTopInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(12.5 * KFitWidthRate);
            make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
            make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
            make.height.mas_equalTo(90 * KFitWidthRate);
        }];
    }
    return _homeTopInfoView;
}
- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        UIImage *refreshImg = [UIImage imageNamed:@"刷新"];
        _refreshBtn = [UIButton new];
        [_refreshBtn setImage:refreshImg forState:UIControlStateNormal];
        [_refreshBtn addTarget:self action:@selector(refreshDataClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_refreshBtn];
        [self.view bringSubviewToFront:_refreshBtn];
        [_refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15*KFitWidthRate);
            make.size.mas_equalTo(CGSizeMake(refreshImg.size.width, refreshImg.size.height));
            make.bottom.mas_equalTo(-20*KFitHeightRate - TabPaddingBARHEIGHT);
        }];
        self.timerInterval = 60;
        self.isRefresh = NO;
    }
    return _refreshBtn;
}
- (UIView *)baiduView {
    if (!_baiduView) {
        _baiduView = [[UIView alloc] init];
        [self.view addSubview: _baiduView];
        [_baiduView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self.view);
        }];
        _baiduView.hidden = [AppDelegate shareInstance].IsShowGoogleMap;
        
        _baiduMapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
        _baiduMapView.zoomLevel = 16;
        _baiduMapView.centerCoordinate = CLLocationCoordinate2DMake(40.056898, 116.307626);
        _baiduMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
        [_baiduView addSubview: _baiduMapView];
        self.searcher = [[BMKGeoCodeSearch alloc] init];
        self.searcher.delegate = self;
        
        // 百度地图全局转（国测局，谷歌等通用）
        [BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_COMMON];
        
        //设定是否总让选中的annotaion置于最前面
        _baiduMapView.isSelectedAnnotationViewFront = YES;
        //设定地图View能否支持俯仰角
        _baiduMapView.overlookEnabled = NO;
    }
    return _baiduView;
}
- (UIView *)googleView {
    if (!_googleView) {
        _googleView = [[UIView alloc] init];
        _googleView.hidden = ![AppDelegate shareInstance].IsShowGoogleMap;
        [self.view addSubview: _googleView];
        [_googleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self.view);
        }];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.056898
                                                                longitude:116.307626
                                                                     zoom:14];
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
        _avtarMarkView.userInteractionEnabled = YES;
    }
    return _avtarMarkView;
}
- (CBHomeLocationBottomView *)bottomInfoView {
    if (!_bottomInfoView) {
        _bottomInfoView = [CBHomeLocationBottomView new];
        _bottomInfoView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomInfoView];
        [_bottomInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_bottom).offset(TabPaddingBARHEIGHT+10);
            make.left.and.right.mas_equalTo(0);
            make.height.mas_equalTo(70*frameSizeRate);
        }];
        [self.view bringSubviewToFront:_bottomInfoView];
        self.isPop = YES;
    }
    return _bottomInfoView;
}
- (NSMutableArray *)polygonCoordinateArrSchool {
    if (!_polygonCoordinateArrSchool) {
        _polygonCoordinateArrSchool = [NSMutableArray array];
    }
    return _polygonCoordinateArrSchool;
}
- (NSMutableArray *)polygonCoordinateArrHome {
    if (!_polygonCoordinateArrHome) {
        _polygonCoordinateArrHome = [NSMutableArray array];
    }
    return _polygonCoordinateArrHome;
}
- (void)addNavigationBtnAndZoomBtn {
    self.navigationBtn = [CBWtMINUtils createBtnWithImage: [UIImage imageNamed:@"ic_navigation"]];//导航 ic_navigation
    self.navigationBtn.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview: self.navigationBtn];
    [self.navigationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.homeTopInfoView.mas_bottom).with.offset(25 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(50 * KFitWidthRate, 50 * KFitWidthRate));
        make.right.equalTo(self.homeTopInfoView);
    }];
    UIImageView *zoomImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"地图缩放"]];
    zoomImageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview: zoomImageView];
    [zoomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBtn.mas_bottom).with.offset(25 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(50 * KFitWidthRate, 100 * KFitWidthRate));
        make.right.equalTo(self.homeTopInfoView);
    }];
    self.zoomInBtn = [[UIButton alloc] init];
    [self.view addSubview: self.zoomInBtn];
    [self.zoomInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBtn.mas_bottom).with.offset(25 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(50 * KFitWidthRate, 50 * KFitWidthRate));
        make.right.equalTo(self.homeTopInfoView);
    }];
    self.zoomOutBtn = [[UIButton alloc] init];
    [self.view addSubview: self.zoomOutBtn];
    [self.zoomOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zoomInBtn.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(50 * KFitWidthRate, 50 * KFitWidthRate));
        make.right.equalTo(self.homeTopInfoView);
    }];
}
#pragma mark -- 获取手表首页信息
- (void)requestInfoData {
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] getHomePageInfoSuccess:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.homeInfoModel = [HomeModel mj_objectWithKeyValues:baseModel.data];
        
//        [AppDelegate shareInstance].currentSno = self.homeInfoModel.tbWatchMain.sno;
//        [AppDelegate shareInstance].currentWatchModel = self.homeInfoModel;
        
        self.homeTopInfoView.homeInfoModel = self.homeInfoModel;
        
        UIImage *originalImage = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: self.homeInfoModel.tbWatchMain.head]]];
        UIImage *thubImage = [UIImage imageByScalingAndCroppingForSourceImage:originalImage targetSize:CGSizeMake(92, 92)];
        thubImage = [thubImage imageByRoundCornerRadius:thubImage.size.height borderWidth: 1.5 borderColor: [UIColor whiteColor]];
        self.avatarImg = originalImage?thubImage:nil;
        
        [self updateModelDataToViewWithHud];
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 更新手表位置
- (void)updateWatchInfoRequest {
    kWeakSelf(self);
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setValue:[HomeModel CBDevice].tbWatchMain.sno?:@"" forKey:@"sno"];
    [[CBWtNetworkRequestManager sharedInstance] updateWatchPositionParmters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        switch (baseModel.status) {
            case CBWtNetworkingStatus0:
            {
                if (self.isRefresh) {
                    [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"刷新成功")];
                }
            }
                break;
                
            default:
                break;
        }
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)timerAction {
    self.timerInterval --;
    if (self.timerInterval == 50 || self.timerInterval == 30) {
        /* 刷新发送指令后 ，两个时间点刷新一次数据,第一次10秒*/
        [self requestInfoData];
    }
    if (self.timerInterval < 0) {
        /* 重置时间*/
        self.timerInterval = 60;
    }
}
- (void)updateModelDataToViewWithHud {
    if ([AppDelegate shareInstance].IsShowGoogleMap == YES) {
        // 谷歌地图反向地理编码
        GMSGeocoder *geocoder = [[GMSGeocoder alloc]init];
        [geocoder reverseGeocodeCoordinate:CLLocationCoordinate2DMake(self.homeInfoModel.tbWatchMain.lat,self.homeInfoModel.tbWatchMain.lng) completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
            if (response.results.count > 0) {
                GMSAddress *address = response.results[0];
                NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@%@",address.country,address.administrativeArea,address.locality,address.subLocality,address.thoroughfare];
                NSLog(@"位置::::%@",addressStr);
                if (_homeTopInfoView != nil) {
                    self.homeInfoModel.address = addressStr;//result.address;
                    self.homeTopInfoView.homeInfoModel = self.homeInfoModel;
                    [self requestFenceDataWithHud:self.dataHud];
                }
            }
        }];
    } else {
        // 谷歌反地理编码不准确，故用百度地图转
        CLLocationCoordinate2D realCoor = CLLocationCoordinate2DMake(self.homeInfoModel.tbWatchMain.lat, self.homeInfoModel.tbWatchMain.lng);
        // 反向地理编码,转为百度地图坐标系，然后用百度地图反向地理编码
        BMKReverseGeoCodeSearchOption *reverseGeoCodeOpetion = [[BMKReverseGeoCodeSearchOption alloc]init];
        reverseGeoCodeOpetion.location = realCoor;//coorData;
        BOOL flag = [self.searcher reverseGeoCode: reverseGeoCodeOpetion];
        if (flag) {
            NSLog(@"反geo检索发送成功");
        } else {
            NSLog(@"反geo检索发送失败");
        }
    }
    [self addMarkerAndAnnotation];
}
- (void)addMarkerAndAnnotation {
    [self.baiduMapView removeAnnotations: self.baiduMapView.annotations];
    [self.baiduMapView removeOverlays:self.baiduMapView.overlays];
    [self.googleMapView clear];
    
    self.watchMarker = [GMSMarker markerWithPosition: CLLocationCoordinate2DMake( self.homeInfoModel.tbWatchMain.lat,  self.homeInfoModel.tbWatchMain.lng)];
    self.watchMarker.map = self.googleMapView;
    //self.watchMarker.icon = [UIImage imageNamed: @"宝贝定位头像-默认头像"];
    self.watchMarker.iconView = self.avtarMarkView;
    self.avtarMarkView.statusStr = [NSString stringWithFormat:@"%@",self.homeInfoModel.tbWatchMain.status];
    self.avtarMarkView.iconImage = self.avatarImg?:[UIImage imageNamed: @"默认宝贝头像"];//默认宝贝头像 //宝贝定位头像-默认头像
    self.avtarMarkView.homeModel = self.homeInfoModel;
    
    //常用地图坐标系h转百度地图坐标系
    CLLocationCoordinate2D realCoor = CLLocationCoordinate2DMake(self.homeInfoModel.tbWatchMain.lat, self.homeInfoModel.tbWatchMain.lng);
    self.watchAnnotation = [[CBWtNormalAnnotation alloc] init];
    self.watchAnnotation.coordinate = realCoor;
    self.watchAnnotation.title = nil;
    [self.baiduMapView addAnnotation: self.watchAnnotation];
}
#pragma mark -- 获取学校和家庭的坐标定位
- (void)requestFenceDataWithHud:(MBProgressHUD *)hud {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:self.homeInfoModel.tbWatchMain.sno?:@"" forKey:@"sno"];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] getSchoolAndHomePositionParamters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"获取学校和家庭的信息:%@",baseModel.data);
        self.guardModel = [GuardIndoModel mj_objectWithKeyValues:baseModel.data];
        [self addSchoolAndHomeMarkerFence];
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)addSchoolAndHomeMarkerFence {
    self.polygonCoordinateArrSchool = [self getModelArr:self.guardModel.schoolData];
    self.polygonCoordinateArrHome = [self getModelArr:self.guardModel.homeData];
    if (self.baiduView.hidden == NO) {
        [self addBaiduPolygonSchoolAndHome];
        [self baiduMapFitFence:self.polygonCoordinateArrSchool isConvert:YES isSchool:YES];
        [self baiduMapFitFence:self.polygonCoordinateArrHome isConvert:YES isSchool:NO];
    } else {
        [self addGooglePolygonSchoolAndHome];
        [self googleMapFitFence:self.polygonCoordinateArrSchool isSchool:YES];
        [self googleMapFitFence:self.polygonCoordinateArrHome isSchool:NO];
    }
    NSLog(@"学校fffffff::%f  %f",self.guardModel.schoolCenterlLat,self.guardModel.schoolCenterLng);
    NSLog(@"家庭fffffff::%f  %f",self.guardModel.homeCenterlLat,self.guardModel.schoolCenterLng);
    self.schoolMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(self.guardModel.schoolCenterlLat,self.guardModel.schoolCenterLng)];
    self.schoolMarker.map = self.googleMapView;
    self.schoolMarker.groundAnchor = CGPointMake(0.5, 0);
    self.schoolMarker.icon = [UIImage imageNamed:@"学校"];
    
    self.schoolAnnotation = [[CBWtSchoolAnnotation alloc] init];
    self.schoolAnnotation.coordinate = CLLocationCoordinate2DMake(self.guardModel.schoolCenterlLat, self.guardModel.schoolCenterLng);
    self.schoolAnnotation.title = nil;
    [self.baiduMapView addAnnotation: self.schoolAnnotation];
    
    self.homeMarker = [GMSMarker markerWithPosition: CLLocationCoordinate2DMake(self.guardModel.homeCenterlLat,  self.guardModel.homeCenterLng)];
    self.homeMarker.map = self.googleMapView;
    self.homeMarker.groundAnchor = CGPointMake(0.5, 0);
    self.homeMarker.icon = [UIImage imageNamed:@"家"];
    
    self.homeAnnotation = [[CBWtSchoolAnnotation alloc] init];
    self.homeAnnotation.coordinate = CLLocationCoordinate2DMake(self.guardModel.homeCenterlLat, self.guardModel.homeCenterLng);//realCoor_home;
    self.homeAnnotation.title = nil;
    [self.baiduMapView addAnnotation: self.homeAnnotation];
    
    // 添加围栏后，居中
    self.googleMapView.camera = [GMSCameraPosition cameraWithLatitude:self.homeInfoModel.tbWatchMain.lat longitude:self.homeInfoModel.tbWatchMain.lng zoom: 14];
    [self.baiduMapView setCenterCoordinate:CLLocationCoordinate2DMake(self.homeInfoModel.tbWatchMain.lat,self.homeInfoModel.tbWatchMain.lng) animated: YES];
    // 选中标注
    [self.baiduMapView selectAnnotation:self.watchAnnotation animated:YES];
}
- (void)addBaiduPolygonSchoolAndHome {
    //[self clearMap];
    CLLocationCoordinate2D coords_school[self.polygonCoordinateArrSchool.count];
    for (int i = 0; i < self.polygonCoordinateArrSchool.count; i++) {
        CBWtCoordinateObject *obj = self.polygonCoordinateArrSchool[i];
        coords_school[i] = obj.coordinate;//coorReal;
    }
    BMKPolygon *polygon_school = [BMKPolygon polygonWithCoordinates:coords_school count:self.polygonCoordinateArrSchool.count];
    [_baiduMapView addOverlay:polygon_school];
    
    CLLocationCoordinate2D coords_home[self.polygonCoordinateArrHome.count];
    for (int i = 0; i < self.polygonCoordinateArrHome.count; i++) {
        CBWtCoordinateObject *obj = self.polygonCoordinateArrHome[i];
        coords_home[i] = obj.coordinate;//coorReal;
    }
    BMKPolygon *polygon_home = [BMKPolygon polygonWithCoordinates:coords_home count:self.polygonCoordinateArrHome.count];
    [_baiduMapView addOverlay:polygon_home];
}
// 使百度地图展示完整的围栏，位置位置并处于地图中心 多边形，矩形，线路 isConvert 是否要转换百度坐标系
- (void)baiduMapFitFence:(NSArray *)modelArr isConvert:(BOOL)isConvert isSchool:(BOOL)isSchool {
    CBWtCoordinateObject *firstModel = modelArr.firstObject;
    BMKMapPoint firstPoint = BMKMapPointForCoordinate(firstModel.coordinate);
    CGFloat leftX, leftY, rightX, rightY; // 最左或右边的X、Y
    rightX = leftX = firstPoint.x;
    rightY = leftY = firstPoint.y;

    NSDecimalNumber *latCenterD = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    NSDecimalNumber *lngCenterD = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    for (int i = 0; i < modelArr.count; i++) {
        CBWtCoordinateObject *model = modelArr[i];
        NSLog(@"纬度========:%.8f   ,经度======%.8f",model.coordinate.latitude,model.coordinate.longitude);
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
        _baiduMapView.zoomLevel = _baiduMapView.zoomLevel - 1;
    }
    NSDecimalNumber *countD = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",@(modelArr.count == 0?1:modelArr.count)]];
    NSDecimalNumber *rLatD = [latCenterD decimalNumberByDividingBy:countD];
    NSDecimalNumber *rLngD = [lngCenterD decimalNumberByDividingBy:countD];
    //if ()
    if (isSchool) {
        NSLog(@"学校dddddd::%@  %@",rLatD,rLngD);
        self.guardModel.schoolCenterlLat = rLatD.doubleValue;
        self.guardModel.schoolCenterLng = rLngD.doubleValue;
    } else {
        NSLog(@"家庭dddddd::%@  %@",rLatD,rLngD);
        self.guardModel.homeCenterlLat = rLatD.doubleValue;
        self.guardModel.homeCenterLng = rLngD.doubleValue;
    }
}
- (void)addGooglePolygonSchoolAndHome {
    //[self clearMap];
    GMSMutablePath *path_school = [GMSMutablePath path];
    for (int i = 0; i < self.polygonCoordinateArrSchool.count; i++) {
        CBWtCoordinateObject *obj = self.polygonCoordinateArrSchool[i];
        [path_school addLatitude: obj.coordinate.latitude longitude: obj.coordinate.longitude];
    }
    GMSPolygon *polygon_school = [GMSPolygon polygonWithPath:path_school];
    polygon_school.fillColor =[UIColor colorWithRed:15.0/255.0 green:126.0/255.0 blue:255.0/255.0 alpha:0.6];
    polygon_school.strokeColor = [UIColor colorWithRed:15.0/255.0 green:126.0/255.0 blue:255.0/255.0 alpha:0.6];
    polygon_school.strokeWidth = 0;
    polygon_school.map = _googleMapView;
    
    GMSMutablePath *path_home = [GMSMutablePath path];
    for (int i = 0; i < self.polygonCoordinateArrHome.count; i++) {
        CBWtCoordinateObject *obj = self.polygonCoordinateArrHome[i];
        [path_home addLatitude: obj.coordinate.latitude longitude: obj.coordinate.longitude];
    }
    GMSPolygon *polygon_home = [GMSPolygon polygonWithPath:path_home];
    polygon_home.fillColor = [UIColor colorWithRed:15.0/255.0 green:126.0/255.0 blue:255.0/255.0 alpha:0.6];
    polygon_home.strokeColor =[UIColor colorWithRed:15.0/255.0 green:126.0/255.0 blue:255.0/255.0 alpha:0.6];
    polygon_home.strokeWidth = 0;
    polygon_home.map = _googleMapView;
}
- (void)googleMapFitFence:(NSArray *)modelArr isSchool:(BOOL)isSchool {
    NSDecimalNumber *latCenterD = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    NSDecimalNumber *lngCenterD = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    for (int i = 0 ; i < modelArr.count ; i ++ ) {
        CBWtCoordinateObject *model = modelArr[i];
        bounds = [bounds includingCoordinate: model.coordinate];
        NSDecimalNumber *latD = [[NSDecimalNumber alloc]initWithDouble:model.coordinate.latitude];
        NSDecimalNumber *lngD = [[NSDecimalNumber alloc]initWithDouble:model.coordinate.longitude];
        latCenterD = [latCenterD decimalNumberByAdding:latD];
        lngCenterD = [lngCenterD decimalNumberByAdding:lngD];
    }
    [_googleMapView animateWithCameraUpdate: [GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
    NSDecimalNumber *countD = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",@(modelArr.count == 0?1:modelArr.count)]];
    NSDecimalNumber *rLatD = [latCenterD decimalNumberByDividingBy:countD];
    NSDecimalNumber *rLngD = [lngCenterD decimalNumberByDividingBy:countD];
    if (isSchool) {
        //22.5666932525345581511111111111111111111  113.906306461894489884444444444444444444
        NSLog(@"学校dddddd::%@  %@",rLatD,rLngD);
        self.guardModel.schoolCenterlLat = rLatD.doubleValue;
        self.guardModel.schoolCenterLng = rLngD.doubleValue;
    } else {
        //dddddd::22.5407317719386171733333333333333333333  113.901124116549686613333333333333333333
        NSLog(@"家庭dddddd::%@  %@",rLatD,rLngD);
        self.guardModel.homeCenterlLat = rLatD.doubleValue;
        self.guardModel.homeCenterLng = rLngD.doubleValue;
    }
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
#pragma mark -- click事件
- (void)refreshDataClick {
    if (self.timerInterval < 60) {
        [HUD showHUDWithText:Localized(@"你刚刚已经刷新过了，请等待结果一分钟后再试")];
        return;
    }
    self.isRefresh = YES;
    // 开启定时器，每隔一分钟点击才能刷新
    self.timerRefreshData = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timerRefreshData forMode:NSRunLoopCommonModes];
    [self.timerRefreshData fire];
    [self updateWatchInfoRequest];
}
- (void)navigationBtnClick {
    MKMapItem *myLocation = [MKMapItem mapItemForCurrentLocation];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(self.homeInfoModel.tbWatchMain.lat,self.self.homeInfoModel.tbWatchMain.lng);
    MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coor]];
    NSArray *items = @[myLocation,toLocation];
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    [MKMapItem openMapsWithItems:items launchOptions:options];
}
- (void)zoomInBtnClick {
    if ([AppDelegate shareInstance].IsShowGoogleMap == YES) {
        [self.googleMapView animateToZoom: self.googleMapView.camera.zoom + 0.5];
    } else {
        self.baiduMapView.zoomLevel = self.baiduMapView.zoomLevel + 0.5;
    }
}
- (void)zoomOutBtnClick {
    if ([AppDelegate shareInstance].IsShowGoogleMap == YES) {
        [self.googleMapView animateToZoom: self.googleMapView.camera.zoom - 0.5];
    }else {
        self.baiduMapView.zoomLevel = self.baiduMapView.zoomLevel - 0.5;
    }
}
- (void)popStatusViewClick:(BOOL)isPop {
    if (isPop) {
        [self.view setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.3 animations:^{
            [_bottomInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.view.mas_bottom);
                make.left.and.right.mas_equalTo(0);
                make.height.mas_equalTo(70*frameSizeRate);
            }];
            [self.bottomInfoView.superview layoutIfNeeded];
            
            UIImage *refreshImg = [UIImage imageNamed:@"刷新"];
            [_refreshBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15*KFitWidthRate);
                make.size.mas_equalTo(CGSizeMake(refreshImg.size.width, refreshImg.size.height));
                make.bottom.mas_equalTo(-20*KFitHeightRate - TabPaddingBARHEIGHT - 70*frameSizeRate);
            }];
            [self.refreshBtn.superview layoutIfNeeded];
        }];
    } else {
        [self.view setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.3 animations:^{
            [_bottomInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.mas_bottom).offset(TabPaddingBARHEIGHT+10);
                make.left.and.right.mas_equalTo(0);
                make.height.mas_equalTo(70*frameSizeRate);
            }];
            [self.bottomInfoView.superview layoutIfNeeded];
            
            UIImage *refreshImg = [UIImage imageNamed:@"刷新"];
            [_refreshBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15*KFitWidthRate);
                make.size.mas_equalTo(CGSizeMake(refreshImg.size.width, refreshImg.size.height));
                make.bottom.mas_equalTo(-20*KFitHeightRate - TabPaddingBARHEIGHT);
            }];
            [self.refreshBtn.superview layoutIfNeeded];
        }];
        
    }
    self.isPop =  !self.isPop;
    self.bottomInfoView.homeInfoModel = self.homeInfoModel;
}
#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        if (_homeTopInfoView != nil) {
            self.homeInfoModel.address = result.address;
            self.homeTopInfoView.homeInfoModel = self.homeInfoModel;
            [self requestFenceDataWithHud:self.dataHud];
        }
    } else {
        NSLog(@"未找到结果");
        self.homeInfoModel.address = @"";
        self.homeTopInfoView.homeInfoModel = self.homeInfoModel;
    }
}
#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass: [CBWtNormalAnnotation class]]) {
        NSString *AnnotationViewID = @"NormalAnnationView";
        CBAvatarAnnotationView *annotationView = [[CBAvatarAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annotationView.iconImage = self.avatarImg?:[UIImage imageNamed:@"默认宝贝头像"];//默认宝贝头像  宝贝定位头像-默认头像
        annotationView.statusStr = [NSString stringWithFormat:@"%@",self.homeInfoModel.tbWatchMain.status];//@"状态正常";
        annotationView.homeModel = self.homeInfoModel;
        UIImage *imageDefault = [UIImage imageNamed:@"宝贝定位头像-空"];
        annotationView.centerOffset = CGPointMake(0, -(36+5+imageDefault.size.height)/2);
        kWeakSelf(self);
        annotationView.avtarClickBlock = ^(id  _Nonnull objc) {
            // 点击标注 弹出详细状态
            kStrongSelf(self);
            [self popStatusViewClick:self.isPop];
        };
        return annotationView;
    } else if ([annotation isKindOfClass: [CBWtSchoolAnnotation class]]) {
        NSString *AnnotationViewID = @"SchoolOrHomeAnnationView";
        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        if ([annotation isEqual: self.schoolAnnotation]) {
            UIImage *imageSchool = [UIImage imageNamed:@"学校"];
            annotationView.centerOffset = CGPointMake(0, 0.1);
            annotationView.image = imageSchool;
        } else {
            UIImage *imageHome = [UIImage imageNamed:@"家"];
            annotationView.centerOffset = CGPointMake(0, 0.1);
            annotationView.image = imageHome;
        }
        return annotationView;
    }
    return nil;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
}
- (void)mapView:(BMKMapView *)mapView clickAnnotationView:(BMKAnnotationView *)view {
    // 点击标注 弹出详细状态
    [self popStatusViewClick:self.isPop];
}
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
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
#pragma mark - GMSMapViewDelegate
// 点击大头针时调用
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    NSLog(@"点击大头针... mark.userData:%@",marker.userData);
    if (marker == self.watchMarker) {
        [self popStatusViewClick:self.isPop];
    }
    return NO;
}
#pragma mark - Other Method
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
