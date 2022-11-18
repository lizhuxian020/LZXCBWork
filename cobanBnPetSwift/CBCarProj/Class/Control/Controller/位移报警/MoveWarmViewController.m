//
//  MoveWarmViewController.m
//  Telematics
//
//  Created by lym on 2018/3/23.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "MoveWarmViewController.h"
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
#import "FenceListModel.h"
#import "MINCoordinateObject.h"
#import "ShareFenceViewController.h"
#import "cobanBnPetSwift-Swift.h"


@interface MoveWarmViewController () <BMKMapViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate, BMKLocationManagerDelegate>
@property (nonatomic, strong) FenceListModel *model;;
@property (nonatomic, strong) BMKMapView *baiduMapView;
@property (nonatomic, strong) GMSMapView *googleMapView;
@property (nonatomic, strong) UIView *baiduView;
@property (nonatomic, strong) UIView *googleView;
@property (nonatomic, strong) BMKLocationManager *baiduLocationService;
@property (nonatomic, assign) CLLocationCoordinate2D myBaiduLocation;
@property (nonatomic, assign) CLLocationCoordinate2D myGoogleLocation;
@property (nonatomic, assign) CLLocationCoordinate2D circleCoordinate;
@property (nonatomic, strong) NSMutableArray *rectangleCoordinateArr;
@property (nonatomic, strong) NSMutableArray *polygonCoordinateArr;
@property (nonatomic, strong) NSMutableArray *pathleCoordinateArr;
@end

@implementation MoveWarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self requestFence];
}

- (void)requestFence
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
//    MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
//    [hud hideAnimated:YES];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devControlController/getWyFence" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *arrayData = response[@"data"];
                if (arrayData.count > 0) {
                    weakSelf.model = [FenceListModel yy_modelWithDictionary:arrayData[0]];
                    [weakSelf createFence];
                } else {
                    [HUD showHUDWithText:[Utils getSafeString:Localized(@"暂无数据")] withDelay:1.2];
                }
            }
        } else {
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"位移报警") isBack: YES];
    [self baiduMap];
    [self googleMap];
//    [self createFence];
}

- (void)createFence
{
    NSString *dataString = self.model.data;
    if (self.model.shape == 0) { // 多边形
        self.polygonCoordinateArr = [self getModelArr: dataString];
        if (self.baiduView.hidden == NO) {
            [self addBaiduPolygon];
            [self baiduMapFitFence: self.polygonCoordinateArr];
        }else {
            [self addGooglePolygon];
            [self googleMapFitFence: self.polygonCoordinateArr];
        }
    }else if (self.model.shape == 1) { // 圆
        NSArray *dataArr = [dataString componentsSeparatedByString: @","];
        if (dataArr.count == 3) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake( [dataArr[0] doubleValue], [dataArr[1] doubleValue]);
            MINCoordinateObject *circleModel = [[MINCoordinateObject alloc] init];
            circleModel.coordinate = coordinate;
            self.circleCoordinate = coordinate;
            if (self.baiduView.hidden == NO) {
                [self addBaiduCircleMarkerWithRadius: dataArr.lastObject];
                [self baiduMapFitCircleFence: circleModel radius: [dataArr[2] doubleValue]];
            }else {
                [self addGoogleCircleMarkerWithRadius: dataArr.lastObject];
                [self googleMapFitCircleFence: circleModel radius: [dataArr[2] doubleValue]];
            }
        }
    }else if (self.model.shape == 2) { // 矩形
        self.rectangleCoordinateArr = [self getModelArr: dataString];
        if (self.baiduView.hidden == NO) {
            [self addBaiduRectangle];
            [self baiduMapFitFence: self.rectangleCoordinateArr];
        }else {
            [self addGoogleRectangle];
            [self googleMapFitFence: self.rectangleCoordinateArr];
        }
    }else if (self.model.shape == 3) { // 线路
        self.pathleCoordinateArr = [self getModelArr: dataString];
        if (self.baiduView.hidden == NO) {
            [self addBaiduPath];
            [self baiduMapFitFence: self.pathleCoordinateArr];
        }else {
            [self addGooglePath];
            [self googleMapFitFence: self.pathleCoordinateArr];
        }
    }
}

// 使百度地图展示完整的围栏，位置位置并处于地图中心
- (void)baiduMapFitFence:(NSArray *)modelArr
{
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

- (void)googleMapFitFence:(NSArray *)modelArr
{
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    for (MINCoordinateObject *model in modelArr) {
        bounds = [bounds includingCoordinate: model.coordinate];
    }
    [_googleMapView animateWithCameraUpdate: [GMSCameraUpdate fitBounds: bounds withPadding: 30.0f]];
}

- (void)googleMapFitCircleFence:(MINCoordinateObject *)model radius:(double)radius
{
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    bounds = [bounds includingCoordinate: model.coordinate];
    CGFloat zoomLevel = [GMSCameraPosition zoomAtCoordinate: model.coordinate forMeters: radius perPoints: 50];
    [_googleMapView animateWithCameraUpdate: [GMSCameraUpdate fitBounds: bounds withPadding: 30.0f]];
    [_googleMapView animateToZoom: zoomLevel];
}

- (void)baiduMapFitCircleFence:(MINCoordinateObject *)model radius:(double)radius
{
    // 一个点的长度是0.870096
    BMKMapPoint circlePoint = BMKMapPointForCoordinate(model.coordinate);
    BMKMapRect fitRect;
    double pointRadius = radius / 0.870096;
    fitRect.origin = BMKMapPointMake(circlePoint.x - pointRadius, circlePoint.y - pointRadius);
    fitRect.size = BMKMapSizeMake(pointRadius * 2, pointRadius * 2);
    [_baiduMapView setVisibleMapRect: fitRect];
    _baiduMapView.zoomLevel = _baiduMapView.zoomLevel - 0.3;
}

- (NSMutableArray *)getModelArr:(NSString *)dataString
{
    NSArray *dataArr = [dataString componentsSeparatedByString: @","];
    NSMutableArray *modelArr = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i = i + 2) {
        MINCoordinateObject *model = [[MINCoordinateObject alloc] init];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake( [dataArr[i] doubleValue], [dataArr[i + 1] doubleValue]);
        model.coordinate = coordinate;
        [modelArr addObject: model];
    }
    return modelArr;
}

- (void)addGoogleRectangle
{
    [self clearMap];
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
    polygon.strokeWidth = 2;
    polygon.map = _googleMapView;
}

- (void)addBaiduRectangle
{
    [self clearMap];
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

- (void)addGoogleCircleMarkerWithRadius:(NSString *)radius
{
    CGFloat radiusNum = [radius floatValue];
    GMSCircle *circ = [GMSCircle circleWithPosition:self.circleCoordinate
                                             radius:radiusNum];
    circ.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    //    circ.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    //    circ.strokeWidth = 5;
    circ.map = _googleMapView;
}

- (void)addBaiduCircleMarkerWithRadius:(NSString *)radius
{
    CGFloat radiusNum = [radius floatValue];
    BMKCircle *circle = [BMKCircle circleWithCenterCoordinate: self.circleCoordinate radius: radiusNum];
    [_baiduMapView addOverlay: circle];
}

- (void)addGooglePath
{
    [self clearMap];
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

- (void)addBaiduPath
{
    [self clearMap];
    CLLocationCoordinate2D coords[self.pathleCoordinateArr.count];
    for (int i = 0; i < self.pathleCoordinateArr.count; i++) {
        MINCoordinateObject *obj = self.pathleCoordinateArr[i];
        coords[i] = obj.coordinate;
    }
    BMKPolyline *polygon = [BMKPolyline polylineWithCoordinates:coords count: self.pathleCoordinateArr.count];
    [_baiduMapView addOverlay:polygon];
}

- (void)addGooglePolygon
{
    [self clearMap];
    GMSMutablePath *path = [GMSMutablePath path];
    for (int i = 0; i < self.polygonCoordinateArr.count; i++) {
        MINCoordinateObject *obj = self.polygonCoordinateArr[i];
        [path addLatitude: obj.coordinate.latitude longitude: obj.coordinate.longitude];
    }
    GMSPolygon *polygon = [GMSPolygon polygonWithPath: path];
    polygon.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    polygon.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    polygon.strokeWidth = 2;
    polygon.map = _googleMapView;
}

- (void)addBaiduPolygon
{
    [self clearMap];
    CLLocationCoordinate2D coords[self.polygonCoordinateArr.count];
    for (int i = 0; i < self.polygonCoordinateArr.count; i++) {
        MINCoordinateObject *obj = self.polygonCoordinateArr[i];
        coords[i] = obj.coordinate;
    }
    BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count: self.polygonCoordinateArr.count];
    [_baiduMapView addOverlay:polygon];
}

- (void)clearMap
{
    if (self.baiduView.hidden == NO) {
        [self.baiduMapView removeOverlays: self.baiduMapView.overlays];
        [self.baiduMapView removeAnnotations: self.baiduMapView.annotations];
    }else {
        [self.googleMapView clear];
    }
}

- (UIButton *)createBtnWithImage:(NSString *)image title:(NSString *)title
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle: title forState: UIControlStateNormal];
    [button setTitle: title forState: UIControlStateHighlighted];
    [button setTitleColor: kRGB(73, 73, 73) forState: UIControlStateNormal];
    [button setImage: [UIImage imageNamed: image] forState: UIControlStateNormal];
    [button setImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 15 * KFitWidthRate)];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize: 18 * KFitWidthRate];
    return button;
}

- (void)baiduMap
{
    _baiduView = [[UIView alloc] init];
    [self.view addSubview: _baiduView];
    [_baiduView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    _baiduView.hidden = [AppDelegate shareInstance].IsShowGoogleMap;
    _baiduMapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    _baiduMapView.zoomLevel = 16;
    _baiduMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _baiduLocationService = [[BMKLocationManager alloc] init];
    _baiduLocationService.delegate = self;
    //    [_baiduLocationService startUserLocationService];
    _baiduMapView.userTrackingMode = BMKUserTrackingModeNone;
    [_baiduView addSubview: _baiduMapView];
    
    // 百度地图全局转（国测局，谷歌等通用）
    [BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_COMMON];
}

- (void)googleMap
{
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
    _googleMapView.delegate = self;
    [_googleView addSubview: _googleMapView];
}

#pragma mark - GMSMapViewDelegate
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        circleView.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
