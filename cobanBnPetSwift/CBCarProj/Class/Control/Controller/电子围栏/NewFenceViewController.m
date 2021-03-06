//
//  NewFenceViewController.m
//  Telematics
//
//  Created by lym on 2017/12/11.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "NewFenceViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <GoogleMaps/GoogleMaps.h>
//#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import <BMKLocationKit/BMKLocationComponent.h>
#import <BMKLocationKit/BMKLocationAuth.h>

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <CoreLocation/CoreLocation.h>

#import "ZCChinaLocation.h"
#import "TQLocationConverter.h"
#import "MINAlertView.h"
#import "MINCoordinateObject.h"
#import "FenceListModel.h"
#import "CBNewFenceMenuView.h"
#import "CBSportAnnotation.h"
#import "CBNewFencePickPointView.h"
#import "cobanBnPetSwift-Swift.h"

//@interface MINCoordinateObject : NSObject
//@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//@end
//
//@implementation MINCoordinateObject
//
//@end

@interface NewFenceViewController () <BMKMapViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate, BMKLocationManagerDelegate,CBNewFenceMenuViewDelegate>
@property (nonatomic, strong) BMKMapView *baiduMapView;
@property (nonatomic, strong) GMSMapView *googleMapView;
@property (nonatomic, strong) UIView *baiduView;
@property (nonatomic, strong) UIView *googleView;
@property (nonatomic, strong) BMKLocationManager *baiduLocationService;
@property (nonatomic, assign) CLLocationCoordinate2D myBaiduLocation;
@property (nonatomic, assign) CLLocationCoordinate2D myGoogleLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;

// 底部菜单按钮
@property (nonatomic, strong) UIButton *circleBtn;
@property (nonatomic, strong) UIButton *rectangleBtn;
@property (nonatomic, strong) UIButton *polygonBtn;
@property (nonatomic, strong) UIButton *pathBtn;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) CLLocationCoordinate2D circleCoordinate;
@property (nonatomic, copy) NSString *circleRadius;

/** 圆形坐标数组容器 */
@property (nonatomic, strong) NSMutableArray *roundCoordinateArr;
/** 矩形坐标数组容器 */
@property (nonatomic, strong) NSMutableArray *rectangleCoordinateArr;
/** 多边形坐标数组容器 */
@property (nonatomic, strong) NSMutableArray *polygonCoordinateArr;
/** 折线坐标数组容器 */
@property (nonatomic, strong) NSMutableArray *pathleCoordinateArr;
/** 底部按钮数组 */
@property (nonatomic, strong) NSMutableArray *arrayBtn;
/** 是否为多边形 */
@property (nonatomic, assign) BOOL isPolygonCreate;
/** 是否为创建路线 */
@property (nonatomic, assign) BOOL isPathCreate;
/** 是否为创建圆 */
@property (nonatomic, assign) BOOL isCircleCreate;
/** 是否为创建矩形 */
@property (nonatomic, assign) BOOL isRectangleCreate;
/** 右上角弹框 */
@property (nonatomic,strong) CBNewFenceMenuView *menuView;
/** 提交btn */
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic,strong) CBSportAnnotation *selectPointAnnotation;
@property (nonatomic,strong) CBNewFencePickPointView *selectPointAnnotationView;

@end

@implementation NewFenceViewController

-(void)viewWillAppear:(BOOL)animated
{
    [_baiduMapView viewWillAppear];
    _baiduMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _baiduLocationService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_baiduMapView viewWillDisappear];
    _baiduMapView.delegate = nil; // 不用时，置nil
    _baiduLocationService.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    // 显示mark在地图上，百度地图 http://www.cocoachina.com/bbs/read.php?tid=1719280
    // 谷歌地图显示所有标记 https://stackoverflow.com/questions/21615811/ios-how-to-use-gmscoordinatebounds-to-show-all-the-markers-of-the-map
//    _googleMapView cameraForBounds:<#(nonnull GMSCoordinateBounds *)#> insets:<#(UIEdgeInsets)#>
}
#pragma mark - CreateUI
- (void)createUI
{
    if (self.isCreateFence) {
        [self initBarWithTitle:Localized(@"新增围栏") isBack: YES];
    } else {
        [self initBarWithTitle:Localized(@"编辑") isBack: YES];
    }
    [self initBarRightImageName:@"gengduo" target:self action:@selector(showMenuViewClick)];
    
    [self baiduMap];
    [self googleMap];
    [self createBottomView];
    [self commitBtn];
}
- (NSMutableArray *)roundCoordinateArr {
    if (!_roundCoordinateArr) {
        _roundCoordinateArr = [NSMutableArray array];
    }
    return _roundCoordinateArr;
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
- (NSMutableArray *)arrayBtn {
    if (!_arrayBtn) {
        _arrayBtn = [NSMutableArray array];
    }
    return _arrayBtn;
}
-(CBNewFenceMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[CBNewFenceMenuView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        _menuView.delegate = self;
    }
    return _menuView;
}
- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [MINUtils createBtnWithRadius:4 title:Localized(@"提交")];
        _commitBtn.backgroundColor = kBlueColor;
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _commitBtn.hidden = YES;
        [_commitBtn addTarget:self action:@selector(createFenceCommitClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_commitBtn];
        [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.circleBtn.mas_top).offset(-10);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(44);
        }];
    }
    return _commitBtn;
}
- (void)createBottomView {
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview: bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    UIView *topLineView = [MINUtils createLineView];
    [bottomView addSubview: topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.left.right.equalTo(bottomView);
    }];
    self.circleBtn = [self createBtnWithImage: @"椭圆-1" selectedImage: @"椭圆1-2" title:Localized(@"圆形")];
    self.circleBtn.selected = YES;
    self.circleBtn.backgroundColor = kBlueColor;
    self.rectangleBtn = [self createBtnWithImage: @"矩形-1" selectedImage: @"矩形-2" title:Localized(@"矩形")];
    self.polygonBtn = [self createBtnWithImage: @"多边形-1" selectedImage: @"多边形-2" title:Localized(@"多边形")];
    self.pathBtn = [self createBtnWithImage: @"路线" selectedImage: @"形状-2" title:Localized(@"路线")];
    UIButton *lastBtn = nil;
    NSArray *arr = @[self.circleBtn, self.rectangleBtn, self.polygonBtn, self.pathBtn];
    for (int i = 0; i < arr.count; i++) {
        UIButton *button = arr[i];
        [bottomView addSubview: button];
        [self.arrayBtn addObject:button];
        if (lastBtn == nil) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(bottomView);
                make.left.equalTo(bottomView);
                make.width.mas_equalTo(SCREEN_WIDTH/4);
            }];
        }else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(bottomView);
                make.left.equalTo(lastBtn.mas_right);
                make.width.mas_equalTo(SCREEN_WIDTH/4);
            }];
        }
        lastBtn = button;
    }
}
- (UIButton *)createBtnWithImage:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle: title forState: UIControlStateNormal];
    [button setTitle: title forState: UIControlStateSelected];
    [button setTitleColor: kRGB(73, 73, 73) forState: UIControlStateNormal];
    [button setTitleColor: [UIColor whiteColor] forState: UIControlStateSelected];
    [button setImage: [UIImage imageNamed: image] forState: UIControlStateNormal];
    [button setImage: [UIImage imageNamed: selectedImage] forState: UIControlStateSelected];
    [button setImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 10 * KFitWidthRate)];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize: 12];
    [button addTarget: self action: @selector(bottomBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    return button;
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
    
    // 百度地图全局转（国测局，谷歌等通用）
    [BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_COMMON];
    _baiduMapView.overlookEnabled = NO;//NO;
    //设定是否总让选中的annotaion置于最前面
    _baiduMapView.isSelectedAnnotationViewFront = YES;
    
    _baiduMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _baiduLocationService = [[BMKLocationManager alloc] init];
    [_baiduLocationService startUpdatingLocation];
    _baiduMapView.userTrackingMode = BMKUserTrackingModeNone;
    [_baiduView addSubview: _baiduMapView];
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
    _googleMapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_HEIGHT) camera:camera];
    //    _googleMapView.myLocationEnabled = YES;
    _googleMapView.delegate = self;
    [_googleView addSubview: _googleMapView];
    //定位管理器
    _locationManager = [[CLLocationManager alloc]init];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways){
        if (self.locationManager.delegate == nil) {
            //设置代理
            _locationManager.delegate = self;
            //设置定位精度
            _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
            //定位频率,每隔多少米定位一次
            CLLocationDistance distance = 10.0;//十米定位一次
            _locationManager.distanceFilter = distance;
            [_locationManager setDesiredAccuracy: kCLLocationAccuracyBest];
            //启动跟踪定位
            [_locationManager startUpdatingLocation];
        }
    }
}

- (void)clearMap {
    if (self.baiduView.hidden == NO) {
        [self.baiduMapView removeOverlays: self.baiduMapView.overlays];
        [self.baiduMapView removeAnnotations: self.baiduMapView.annotations];
    } else {
        [self.googleMapView clear];
    }
}
- (void)showAlertViewWithTitle:(NSString *)title placeHold:(NSString *)placeHold {
    [self clearMap];
    __weak __typeof__(self) weakSelf = self;
    MINAlertView *alertView = [[MINAlertView alloc] init];
    __weak MINAlertView *weakAlertView = alertView;
    alertView.titleLabel.text = title;
    [weakSelf.view addSubview: alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    weakSelf.textField = [MINUtils createTextFieldWithHoldText: placeHold  fontSize: 15];
    weakSelf.textField.keyboardType = UIKeyboardTypeDecimalPad;
    [alertView.contentView addSubview: weakSelf.textField];
    [weakSelf.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView.contentView);
        make.centerY.equalTo(alertView.contentView).with.offset(-5 * KFitHeightRate);
        make.height.mas_equalTo(40 * KFitHeightRate);
        make.width.mas_equalTo(250 * KFitWidthRate);
    }];
    alertView.rightBtnClick = ^{
        if (weakSelf.textField.text.length > 0) {
            weakSelf.commitBtn.hidden = NO;
            [weakAlertView hideView];
            // 修改model的数据，不要忘记了
            if (weakSelf.baiduView.hidden == NO) {
                [weakSelf addBaiduCircleMarkerWithRadius:weakSelf.textField.text];
            }else {
                [weakSelf addGoogleCircleMarkerWithRadius:weakSelf.textField.text];
            }
            weakSelf.isCircleCreate = YES;
            weakSelf.circleRadius = weakSelf.textField.text;
        }
    };
    alertView.leftBtnClick = ^{
        [weakAlertView hideView];
    };
}
- (void)addGoogleCircleMarkerWithRadius:(NSString *)radius {
    CGFloat radiusNum = [radius floatValue];
    GMSCircle *circ = [GMSCircle circleWithPosition:self.circleCoordinate
                                             radius:radiusNum];
    circ.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    circ.strokeWidth = 0;
    circ.map = _googleMapView;
}

- (void)addBaiduCircleMarkerWithRadius:(NSString *)radius {
    CGFloat radiusNum = [radius floatValue];
    BMKCircle *circle = [BMKCircle circleWithCenterCoordinate: self.circleCoordinate radius: radiusNum];
    [_baiduMapView addOverlay: circle];
}
- (void)addGooglePolygon {
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
- (void)addGooglePath {
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
    CLLocationCoordinate2D coords[self.pathleCoordinateArr.count];
    for (int i = 0; i < self.pathleCoordinateArr.count; i++) {
        MINCoordinateObject *obj = self.pathleCoordinateArr[i];
        coords[i] = obj.coordinate;
    }
    BMKPolyline *polygon = [BMKPolyline polylineWithCoordinates:coords count: self.pathleCoordinateArr.count];
    [_baiduMapView addOverlay:polygon];
}

- (void)addBaiduPolygon {
    CLLocationCoordinate2D coords[self.polygonCoordinateArr.count];
    for (int i = 0; i < self.polygonCoordinateArr.count; i++) {
        MINCoordinateObject *obj = self.polygonCoordinateArr[i];
        coords[i] = obj.coordinate;
    }
    BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count: self.polygonCoordinateArr.count];
    [_baiduMapView addOverlay:polygon];
}

- (void)addGoogleRectangle {
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
#pragma mark -- 右上角更多操作
- (void)showMenuViewClick {
    [self.menuView popView];
}
#pragma mark -- 创建围栏提交
- (void)createFenceCommitClick {
    if (self.circleBtn.selected == YES && self.isCircleCreate == YES) {
        [self requestAddFenceWithType: 1];
    } else if (self.circleBtn.selected == YES && self.isCircleCreate == NO) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请先创建围栏")];
    } else if (self.rectangleBtn.selected == YES && self.isRectangleCreate == YES) {
        [self requestAddFenceWithType: 2];
    } else if (self.rectangleBtn.selected == YES && self.isRectangleCreate == NO) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请先创建围栏")];
    } else if (self.polygonBtn.selected == YES && self.isPolygonCreate == YES) {
        [self requestAddFenceWithType: 0];
    } else if (self.polygonBtn.selected == YES && self.isPolygonCreate == NO) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请先创建围栏")];
    } else if (self.pathBtn.selected == YES && self.isPathCreate == YES) {
        [self requestAddFenceWithType: 3];
    } else if (self.pathBtn.selected == YES && self.isPathCreate == NO) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请先创建围栏")];
    }
}
- (void)requestAddFenceWithType:(int)type {
    // 0-多边形 1-圆 2-矩形 3-路线
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithCapacity:1];
    paramters[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    paramters[@"name"] = self.model.name;
    paramters[@"speed"] = self.model.speed;
    paramters[@"shape"] = [NSNumber numberWithInt: type];
    paramters[@"warmType"] = [NSNumber numberWithInt: self.model.warmType];
    paramters[@"sn"] = [CBCommonTools getCurrentTimeString];//@"当前时间时间戳10位";
    NSString *dataString = nil;
    if (type == 0) { // 多边形
        dataString = [self getDataStringWithArr: self.polygonCoordinateArr];
    } else if (type == 1) { // 圆
        NSArray *dataArr = [NSArray arrayWithObjects: [NSNumber numberWithDouble: self.circleCoordinate.latitude], [NSNumber numberWithDouble: self.circleCoordinate.longitude], self.circleRadius, nil];
        dataString = [dataArr componentsJoinedByString: @","];
    } else if (type == 2) { // 矩形
        dataString = [self getDataStringWithArr: self.rectangleCoordinateArr];
    } else {     // 路线
        dataString = [self getDataStringWithArr: self.pathleCoordinateArr];
    }
    paramters[@"data"] = dataString;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devControlController/saveFence" params:paramters succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [weakSelf.navigationController popViewControllerAnimated: YES];
        } else {
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 底部菜单点击事件click
- (void)bottomBtnClick:(UIButton *)button {
    [self clearMap];
    self.isPolygonCreate = NO;
    self.isPathCreate = NO;
    self.isCircleCreate = NO;
    self.isRectangleCreate = NO;
    
    // 更改底部按钮颜色状态
    if (button == self.circleBtn) {
        [self updateBtnStatus:self.circleBtn];
        self.commitBtn.hidden = self.roundCoordinateArr.count > 0?NO:YES;
    } else if (button == self.rectangleBtn) {
        [self updateBtnStatus:self.rectangleBtn];
        self.commitBtn.hidden = self.rectangleCoordinateArr.count == 2?NO:YES;
    } else if (button == self.polygonBtn) {
        [self updateBtnStatus:self.polygonBtn];
        self.commitBtn.hidden = self.polygonCoordinateArr.count > 2?NO:YES;
    } else if (button == self.pathBtn) {
        [self updateBtnStatus:self.pathBtn];
        self.commitBtn.hidden = self.pathleCoordinateArr.count > 0?NO:YES;
    }
    self.commitBtn.hidden = YES;
}
- (void)updateBtnStatus:(UIButton *)sender {
    for (UIButton *btn in self.arrayBtn) {
        if (sender == btn) {
            // 选中
            btn.selected = YES;
            btn.backgroundColor = kBlueColor;
        } else {
            btn.selected = NO;
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
}
#pragma mark -- MenuView delegate
- (void)clickType:(NSInteger)index {
    switch (index) {
        case 100:
            // 完成
        {
            if (self.circleBtn.selected == YES) {
                if (self.roundCoordinateArr.count > 0) {
                    [self showAlertViewWithTitle:Localized(@"围栏半径") placeHold:Localized(@"请输入围栏的半径 (米)")];
                }
            } else if (self.rectangleBtn.selected == YES) {
                if (self.rectangleCoordinateArr.count == 2) {
                    if (self.baiduView.hidden == NO) {
                        [self addBaiduRectangle];
                    } else {
                        [self addGoogleRectangle];
                    }
                    self.isRectangleCreate = YES;
                    self.commitBtn.hidden = NO;
                }
            } else if (self.polygonBtn.selected == YES) {
                if (self.polygonCoordinateArr.count > 2) {
                    self.isPolygonCreate = YES;
                    self.commitBtn.hidden = NO;
                    if (self.baiduView.hidden == NO) {
                        [self addBaiduPolygon];
                    } else {
                        [self addGooglePolygon];
                    }
                } else {
                    [MINUtils showProgressHudToView:self.view withText:Localized(@"至少选择三个点")];
                }
            } else if (self.pathBtn.selected == YES) {
                if (self.pathleCoordinateArr.count > 1) {
                    self.isPathCreate = YES;
                    self.commitBtn.hidden = NO;
                    if (self.baiduView.hidden == NO) {
                        [self addBaiduPath];
                    } else {
                        [self addGooglePath];
                    }
                }
            }
        }
            break;
        case 101:
            // 撤销
        {
            self.commitBtn.hidden = YES;
            if (self.circleBtn.selected == YES) {
                [self.roundCoordinateArr removeAllObjects];
                [self clearMap];
            } else if (self.rectangleBtn.selected == YES) {
                [self clearMap];
                if (self.rectangleCoordinateArr.count > 0) {
                    [self.rectangleCoordinateArr removeLastObject];
                    for (MINCoordinateObject *coorObj in self.rectangleCoordinateArr) {
                        if (self.baiduView.hidden == NO) {
                            [self addPoint_BMK:coorObj.coordinate];
                        } else {
                            [self addPoint_GMS:coorObj.coordinate];
                        }
                    }
                }
            } else if (self.polygonBtn.selected == YES) {
                [self clearMap];
                if (self.polygonCoordinateArr.count > 0) {
                    [self.polygonCoordinateArr removeLastObject];
                    for (MINCoordinateObject *coorObj in self.polygonCoordinateArr) {
                        if (self.baiduView.hidden == NO) {
                            [self addPoint_BMK:coorObj.coordinate];
                        } else {
                            [self addPoint_GMS:coorObj.coordinate];
                        }
                    }
                }
            } else if (self.pathBtn.selected == YES) {
                [self clearMap];
                if (self.pathleCoordinateArr.count > 0) {
                    [self.pathleCoordinateArr removeLastObject];
                    for (MINCoordinateObject *coorObj in self.pathleCoordinateArr) {
                        if (self.baiduView.hidden == NO) {
                            [self addPoint_BMK:coorObj.coordinate];
                        } else {
                            [self addPoint_GMS:coorObj.coordinate];
                        }
                    }
                }
            }
        }
            break;
        case 102:
            // 重置
        {
            self.commitBtn.hidden = YES;
            if (self.circleBtn.selected == YES) {
                [self.roundCoordinateArr removeAllObjects];
            } else if (self.rectangleBtn.selected == YES) {
                [self.rectangleCoordinateArr removeAllObjects];
            } else if (self.polygonBtn.selected == YES) {
                [self.polygonCoordinateArr removeAllObjects];
            } else if (self.pathBtn.selected == YES) {
                [self.pathleCoordinateArr removeAllObjects];
            }
            [self clearMap];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - GoogleMaps
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    if (self.circleBtn.selected == YES) {
        self.circleCoordinate = coordinate;
        if (self.roundCoordinateArr.count > 0) {
            [MINUtils showProgressHudToView:self.view withText:@"不能超过一个点"];
            return;
        }
        [self.roundCoordinateArr addObject:[self getCoorObj:coordinate]];
        [self addPoint_GMS:coordinate];
        
    } else if (self.rectangleBtn.selected == YES) {
        if (self.rectangleCoordinateArr.count > 1) {
            [MINUtils showProgressHudToView:self.view withText:@"不能超过两个点"];
            return;
        }
        [self.rectangleCoordinateArr addObject:[self getCoorObj:coordinate]];
        [self addPoint_GMS:coordinate];
        
    } else if (self.polygonBtn.selected == YES) {

        [self.polygonCoordinateArr addObject:[self getCoorObj:coordinate]];
        [self addPoint_GMS:coordinate];
        
    }else if (self.pathBtn.selected == YES) {
        
        [self.pathleCoordinateArr addObject:[self getCoorObj:coordinate]];
        [self addPoint_GMS:coordinate];
    }
}
- (void)addPoint_GMS:(CLLocationCoordinate2D)coordinate {
    GMSMarker *mark_point = [[GMSMarker alloc] init];
    mark_point.appearAnimation = kGMSMarkerAnimationNone;//kGMSMarkerAnimationPop;
    CBTrackPointView *iconView = [[CBTrackPointView alloc]initWithFrame:CGRectMake(0, 0, 10*KFitWidthRate, 10*KFitWidthRate)];
    mark_point.position = coordinate;
    mark_point.iconView = iconView;
    mark_point.groundAnchor = CGPointMake(0.5, 0.5);
    mark_point.map = self.googleMapView;
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    [_locationManager stopUpdatingLocation];
    CLLocation *curLocation = [locations firstObject];
    //    通过location  或得到当前位置的经纬度
    CLLocationCoordinate2D curCoordinate2D = curLocation.coordinate;
    if ([CBCommonTools checkIsChina:CLLocationCoordinate2DMake(curCoordinate2D.latitude,curCoordinate2D.longitude)]) {
        curCoordinate2D = [TQLocationConverter transformFromWGSToGCJ:curCoordinate2D];
    }
    NSLog(@"latitude = %f, longitude = %f", curCoordinate2D.latitude, curCoordinate2D.longitude);
    self.myGoogleLocation = curCoordinate2D;
    [self showMyLocation];
}

- (void)showMyLocation {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_googleMapView clear];
        NSLog(@"%f, %f", self.myGoogleLocation.latitude, self.myGoogleLocation.longitude);
        _googleMapView.camera = [GMSCameraPosition cameraWithLatitude:self.myGoogleLocation.latitude longitude:self.myGoogleLocation.longitude zoom: 16];
        [_baiduMapView setCenterCoordinate:CLLocationCoordinate2DMake(self.myGoogleLocation.latitude,self.myGoogleLocation.longitude) animated:YES];
    });
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    _baiduMapView.centerCoordinate = self.myBaiduLocation;
    [self.baiduMapView updateLocationData: userLocation];
    [self.baiduLocationService stopUpdatingLocation];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.myBaiduLocation = userLocation.location.coordinate;
    [self.baiduMapView updateLocationData: userLocation];
    _baiduMapView.centerCoordinate = self.myBaiduLocation;
    [self.baiduLocationService stopUpdatingLocation];
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"---- 点击的坐标 ----%.f   %.f",coordinate.latitude,coordinate.longitude);
    if (self.circleBtn.selected == YES) {
        self.circleCoordinate = coordinate;
        
        if (self.roundCoordinateArr.count > 0) {
            [MINUtils showProgressHudToView:self.view withText:Localized(@"不能超过一个点")];
            return;
        }
        [self.roundCoordinateArr addObject:[self getCoorObj:coordinate]];
        [self addPoint_BMK:coordinate];
        
    }else if (self.rectangleBtn.selected == YES) {

        if (self.rectangleCoordinateArr.count > 1) {
            [MINUtils showProgressHudToView:self.view withText:Localized(@"不能超过两个点")];
            return;
        }
        [self.rectangleCoordinateArr addObject:[self getCoorObj:coordinate]];
        [self addPoint_BMK:coordinate];
        
    } else if (self.polygonBtn.selected == YES) {

        [self.polygonCoordinateArr addObject:[self getCoorObj:coordinate]];
        [self addPoint_BMK:coordinate];
        
    } else if (self.pathBtn.selected == YES) {
        
        [self.pathleCoordinateArr addObject:[self getCoorObj:coordinate]];
        [self addPoint_BMK:coordinate];
    }
}
- (void)addPoint_BMK:(CLLocationCoordinate2D)coordinate {
    self.selectPointAnnotation = [[CBSportAnnotation alloc]init];
    self.selectPointAnnotation.coordinate = coordinate;
    [self.baiduMapView addAnnotation:self.selectPointAnnotation];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if (annotation == self.selectPointAnnotation) {
        // 轨迹圆点
        static NSString *SportsAnnotationViewID = @"sportsPointAnnotation";
        CBNewFencePickPointView *selectPointAnnotationView = (CBNewFencePickPointView *)[mapView dequeueReusableAnnotationViewWithIdentifier:SportsAnnotationViewID];
        if (!selectPointAnnotationView) {
            selectPointAnnotationView = [[CBNewFencePickPointView alloc] initWithAnnotation:annotation reuseIdentifier:SportsAnnotationViewID];
        }
        selectPointAnnotationView.image = nil;
        selectPointAnnotationView.draggable = NO;
        selectPointAnnotationView.pointView.hidden = YES;
        selectPointAnnotationView.pointView_realTime.hidden = NO;
        return selectPointAnnotationView;
    }
    return nil;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        circleView.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        return circleView;
    } else if ([overlay isKindOfClass:[BMKPolygon class]]){
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        polygonView.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        return polygonView;
    } else if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = kBlueColor;
        polylineView.lineWidth = 2.0 * KFitWidthRate;
        return polylineView;
    }
    return nil;
}
#pragma mark -- 数组以逗号分隔，转为字符串
- (NSString *)getDataStringWithArr:(NSArray *)arr {
    NSMutableArray *polygonArr = [NSMutableArray array];
    for (MINCoordinateObject *model in arr) {
        [polygonArr addObject: [NSNumber numberWithDouble: model.coordinate.latitude]];
        [polygonArr addObject: [NSNumber numberWithDouble: model.coordinate.longitude]];
    }
    NSString *dataString = [polygonArr componentsJoinedByString:@","];
    return dataString;
}
#pragma mark -- CLLocationCoordinate2D 转为对象
- (MINCoordinateObject *)getCoorObj:(CLLocationCoordinate2D)coordinate {
    MINCoordinateObject *coorObj = [[MINCoordinateObject alloc] init];
    coorObj.coordinate = coordinate;
    return coorObj;
}
#pragma mark - Other Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
