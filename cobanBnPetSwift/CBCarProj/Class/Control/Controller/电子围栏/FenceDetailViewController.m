//
//  FenceDetailViewController.m
//  Telematics
//
//  Created by lym on 2017/12/18.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "FenceDetailViewController.h"
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

#import "MINAlertView.h"
#import "MINNormalAnnotation.h"
#import "MINAnnotationView.h"
#import "MINNormalInfoAnnotation.h"
#import "cobanBnPetSwift-Swift.h"

//@interface MINCoordinateObject : NSObject
//@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//@end
//
//@implementation MINCoordinateObject
//
//@end


@interface FenceDetailViewController () <BMKMapViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate,BMKLocationManagerDelegate>
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
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation FenceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self addAction];
    self.rectangleCoordinateArr = [NSMutableArray array];
    self.polygonCoordinateArr = [NSMutableArray array];
    self.pathleCoordinateArr = [NSMutableArray array];
}

#pragma mark - addAction
- (void)addAction
{
    [self.shareBtn addTarget: self action: @selector(shareBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.deleteBtn addTarget: self action: @selector(deleteDevicePop) forControlEvents: UIControlEventTouchUpInside];
}

- (void)shareBtnClick
{
    ShareFenceViewController *shareFenceVC = [[ShareFenceViewController alloc] init];
    shareFenceVC.model = self.model;
    [self.navigationController pushViewController: shareFenceVC animated: YES];
}
#pragma mark -- 删除设备围栏
- (void)deleteDevicePop {
    [self showAlertViewWithTitle:Localized(@"提示") datailText:Localized(@"删除后无法恢复 \n 确认删除?") indexPath:nil];
}
- (void)deleteBtnClick
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = self.model.dno;
    dic[@"fid"] = self.model.fid;
    dic[@"areaId"] = self.model.sn?:@""; // sn
    dic[@"shape"] = [NSString stringWithFormat:@"%@",@(self.model.shape)];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devControlController/deleteFence" params: dic succeed:^(id response,BOOL isSucceed) {
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

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle: self.model.name isBack: YES];
    [self baiduMap];
    [self googleMap];
    [self createBottomView];
    [self createFence];
}

- (void)createFence
{
    NSString *dataString = self.model.data;
    if (self.model.shape == 0) { // 多边形
        self.polygonCoordinateArr = [self getModelArr:dataString];
        if (self.baiduView.hidden == NO) {
            [self addBaiduPolygon];
            [self baiduMapFitFence: self.polygonCoordinateArr];
        } else {
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
                //[self addAnnotation_baidu:coordinate];
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
//- (void)addAnnotation_baidu:(CLLocationCoordinate2D)coor {
//    // 围栏定位图标
//    MINNormalAnnotation *normalAnnotation = [[MINNormalAnnotation alloc] init];
//    normalAnnotation.icon = [UIImage imageNamed:@"-定位"];
//    normalAnnotation.coordinate = coor;
//    [_baiduMapView addAnnotation: normalAnnotation];
//    
//    // 围栏定位上方名字
//    MINNormalInfoAnnotation *normalInfoAnnotation = [[MINNormalInfoAnnotation alloc] init];
////    normalInfoAnnotation.deviceName = deviceInfoModel.name?:@"";
////    normalInfoAnnotation.speed = deviceInfoModel.speed?:@"";
//    normalInfoAnnotation.coordinate = coor;
//    [_baiduMapView addAnnotation: normalInfoAnnotation];
//}
// 使百度地图展示完整的围栏，位置位置并处于地图中心 多边形，矩形，线路
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
// 百度圆
- (void)baiduMapFitCircleFence:(MINCoordinateObject *)model radius:(double)radius
{
    // 一个点的长度是0.870096
    BMKMapPoint circlePoint = BMKMapPointForCoordinate(model.coordinate);
    BMKMapRect fitRect;
    double pointRadius = radius / 0.6;//0.870096;
    fitRect.origin = BMKMapPointMake(circlePoint.x - pointRadius, circlePoint.y - pointRadius);
    fitRect.size = BMKMapSizeMake(pointRadius * 2, pointRadius * 2);
    [_baiduMapView setVisibleMapRect: fitRect];
    //_baiduMapView.zoomLevel = _baiduMapView.zoomLevel - 0.3;
    [_baiduMapView setCenterCoordinate:model.coordinate];
}
- (void)googleMapFitFence:(NSArray *)modelArr
{
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    for (MINCoordinateObject *model in modelArr) {
        bounds = [bounds includingCoordinate: model.coordinate];
    }
    [_googleMapView animateWithCameraUpdate: [GMSCameraUpdate fitBounds: bounds withPadding: 110.0f]];//30.0f 面积距离屏幕宽
}

- (void)googleMapFitCircleFence:(MINCoordinateObject *)model radius:(double)radius
{
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    bounds = [bounds includingCoordinate: model.coordinate];
    CGFloat zoomLevel = [GMSCameraPosition zoomAtCoordinate: model.coordinate forMeters: radius perPoints: 50];
    [_googleMapView animateWithCameraUpdate: [GMSCameraUpdate fitBounds: bounds withPadding: 30.0f]];
    [_googleMapView animateToZoom: zoomLevel];
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
    polygon.strokeWidth = 0;//2;
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
    circ.strokeColor = [UIColor clearColor];
    //circ.strokeWidth = 0;
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
    polygon.strokeWidth = 0;//2;
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

- (void)createBottomView
{
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
    self.shareBtn = [self createBtnWithImage:@"分享" title:Localized(@"分享")];
    self.deleteBtn = [self createBtnWithImage:@"删-除" title:Localized(@"删除")];
    UIButton *lastBtn = nil;
    NSArray *arr = @[self.shareBtn, self.deleteBtn];
    for (int i = 0; i < arr.count; i++) {
        UIButton *button = arr[i];
        [bottomView addSubview: button];
        if (lastBtn == nil) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(bottomView);
                make.left.equalTo(bottomView);
                make.width.mas_equalTo(SCREEN_WIDTH/2);
            }];
        }else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(bottomView);
                make.left.equalTo(lastBtn.mas_right);
                make.width.mas_equalTo(SCREEN_WIDTH/2);
            }];
        }
        lastBtn = button;
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
    
    // 百度地图全局转（国测局，谷歌等通用）
    [BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_COMMON];
    _baiduMapView.overlookEnabled = NO;//NO;
    //设定是否总让选中的annotaion置于最前面
    _baiduMapView.isSelectedAnnotationViewFront = YES;
    
    _baiduMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _baiduLocationService = [[BMKLocationManager alloc] init];
    _baiduMapView.userTrackingMode = BMKUserTrackingModeNone;
    [_baiduView addSubview: _baiduMapView];
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
                                                                 zoom:16];
    _googleMapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50*KFitHeightRate) camera:camera];
    //    _googleMapView.myLocationEnabled = YES;
    _googleMapView.delegate = self;
    [_googleView addSubview: _googleMapView];
}
#pragma mark - BMKMapViewDelegate
/* 添加标注 会调此方法 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
     if ([annotation isKindOfClass: [MINNormalAnnotation class]]) {
        // 围栏定位图标
        MINNormalAnnotation *model = (MINNormalAnnotation *)annotation;
        static NSString *AnnotationViewIDD = @"NormalAnnationVieww";
        MINAnnotationView *annotationView = (MINAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewIDD];
        if (!annotationView) {
            annotationView = [[MINAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewIDD];
        }
        annotationView.imageView.image = model.icon;
        return annotationView;
     } else if ([annotation isKindOfClass: [MINNormalInfoAnnotation class]]) {
         // 围栏方名字
         //MINNormalInfoAnnotation *model = (MINNormalInfoAnnotation *)annotation;
         static NSString *AnnotationViewID = @"NormalInfoAnnotationView";
         BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
         if (!annotationView) {
             annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
         }
        
         UILabel *label = [Utils createLbWithFrame:CGRectMake(0, 0, 147 * KFitWidthRate,  48 * KFitHeightRate) title:@"1122" aliment:NSTextAlignmentCenter color:[UIColor colorWithHexString:@"494949"] size:30*KFitHeightRate];
         label.text = self.model.name?:@"";
         UIImage *annotationImage = [self getImageFromView:label];
         annotationView.image = annotationImage;
         annotationView.centerOffset = CGPointMake(0, 40 * KFitHeightRate);//CGPointMake(0, -70 * KFitHeightRate);
         annotationView.frame = CGRectMake(0, 0, 147 * KFitWidthRate,  48 * KFitHeightRate);
         annotationView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];//[UIColor greenColor];
         return annotationView;
         
     }
    return nil;
}
- (UIImage *)getImageFromView:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//#pragma mark - GMSMapViewDelegate
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
- (void)showAlertViewWithTitle:(NSString *)title datailText:(NSString *)text indexPath:(NSIndexPath *)indexPath
{
    __weak __typeof__(self) weakSelf = self;
    MINAlertView *alertView = [[MINAlertView alloc] init];
    __weak MINAlertView *weakAlertView = alertView;
    alertView.titleLabel.text = title;
    [weakSelf.view addSubview: alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    [alertView setContentViewHeight:100*KFitHeightRate];
    
    UILabel *detailLabel = [MINUtils createLabelWithText: text size: 15 * KFitHeightRate alignment:NSTextAlignmentCenter textColor: kRGB(96, 96, 96)];
    [detailLabel setRowSpace:8];
    detailLabel.numberOfLines = 0;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [alertView.contentView addSubview: detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView.contentView);
        make.centerY.equalTo(alertView.contentView).with.offset(-5 * KFitHeightRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
        make.width.mas_equalTo(250 * KFitWidthRate);
    }];
    if (indexPath.row == 7) {
        [alertView showRightCloseBtn];
        [alertView.rightBottomBtn setTitle: @"满值" forState: UIControlStateNormal];
        [alertView.rightBottomBtn setTitle: @"满值" forState: UIControlStateHighlighted];
        [alertView.leftBottomBtn setTitle: @"零值" forState: UIControlStateNormal];
        [alertView.leftBottomBtn setTitle: @"零值" forState: UIControlStateHighlighted];
        [alertView.leftBottomBtn setBackgroundColor: [UIColor whiteColor]];
        UIView *lineView = [MINUtils createLineView];
        [lineView setBackgroundColor: kBlueColor];
        [alertView.leftBottomBtn addSubview: lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertView.leftBottomBtn).with.offset(0.5);
            make.left.equalTo(alertView.leftBottomBtn);
            make.right.equalTo(alertView.leftBottomBtn);
            make.height.mas_equalTo(0.5);
        }];
    }
    alertView.rightBtnClick = ^{
        [weakAlertView hideView];
        [weakSelf deleteBtnClick];
    };
    alertView.leftBtnClick = ^{
        [weakAlertView hideView];
    };
}
#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
