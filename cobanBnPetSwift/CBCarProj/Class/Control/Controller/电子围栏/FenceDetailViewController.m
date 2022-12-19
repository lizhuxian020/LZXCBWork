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
#import "CBFencyMenuView.h"
#import "CBSportAnnotation.h"
#import "MINAlertAnnotationView.h"

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
/** 圆形坐标数组容器 */
@property (nonatomic, strong) NSMutableArray<MINCoordinateObject *> *roundCoordinateArr;
@property (nonatomic, strong) NSMutableArray<MINCoordinateObject *> *rectangleCoordinateArr;
@property (nonatomic, strong) NSMutableArray<MINCoordinateObject *> *polygonCoordinateArr;
@property (nonatomic, strong) NSMutableArray *pathleCoordinateArr;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, assign) BOOL isCircle;
@property (nonatomic, assign) BOOL isRect;
@property (nonatomic, assign) BOOL isPolygon;

@property (nonatomic, strong) CBFencyMenuView *menuView;
@property (nonatomic, strong) BMKCircle *baiduCircleView;
@property (nonatomic, assign) CLLocationDistance radius;
@property (nonatomic, strong) MINAlertAnnotationView *baiduRadiusView;

@property (nonatomic, strong) CBHomeLeftMenuDeviceInfoModel *currentModel;
@property (nonatomic, strong) BMKPolygon *baiduRectPolygon;
@property (nonatomic, strong) BMKPolygon *baiduPolygon;

@property (nonatomic, strong) GMSCircle *gmsCircle;
@property (nonatomic, strong) UILabel *gmsRadiusLbl;
@property (nonatomic, assign) NSInteger gmsPolygonCurrentMark;
@property (nonatomic, strong) GMSPolygon *gmsRectPolygon;
@property (nonatomic, strong) GMSPolygon *gmsPolygon;
@end

@implementation FenceDetailViewController

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
    self.isPolygon = self.model.shape == 0;
    self.isCircle = self.model.shape == 1;
    self.isRect = self.model.shape == 2;
    
    self.roundCoordinateArr = [NSMutableArray new];
    self.rectangleCoordinateArr = [NSMutableArray array];
    self.polygonCoordinateArr = [NSMutableArray array];
    self.pathleCoordinateArr = [NSMutableArray array];
    [self createUI];
    [self addAction];
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
    kWeakSelf(self);
    [[CBCarAlertView viewWithAlertTips:Localized(@"删除后无法恢复 \n 确认删除?") title:Localized(@"提示") confrim:^(NSString * _Nonnull contentStr) {
        [weakself deleteBtnClick];
    }] pop];
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
            [CBTopAlertView alertSuccess:@"操作成功"];
            [weakSelf.navigationController popViewControllerAnimated: YES];
        } else {
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)saveBtnClick {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"data": _model.data ?: @"",
        @"deviceArr": [self.menuView getDeviceArr],
        @"deviceName": [self.menuView getDeviceName],
        @"name": [self.menuView getFenceName],
        @"shape": @(self.model.shape),
        @"sn": self.model.sn ?: @"",
        @"timeZone": @"8.0"
    }];;
    
    if (self.model.shape == 1) {
        CGFloat lat, lon, rad;
        NSArray *arr = [_model.data componentsSeparatedByString:@","];
        if (arr.count != 3) {
            return;
        }
        lat = [arr.firstObject doubleValue];
        lon = [arr[1] doubleValue];
        rad = [arr.lastObject doubleValue];
        [param addEntriesFromDictionary:@{
            @"centerPoint": [NSString stringWithFormat:@"%lf,%lf", lat, lon],
            @"radius": [NSString stringWithFormat:@"%lf", rad],
        }];
    }
    
    if (self.model.fid) {
        [param addEntriesFromDictionary:@{
            @"fenId": self.model.fid,
        }];
    }
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"/devControlController/saveBatchFence" params:param succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [CBTopAlertView alertSuccess:Localized(@"操作成功")];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
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
    [self initBarWithTitle:Localized(@"电子围栏") isBack: YES];
    [self addDeleteAndSave];
    [self setupMenuView];
    if (!self.isNewFence) {
        [self baiduMap];
        [self googleMap];
        
        //需要马上布局, 否则fence会按全屏去展示
        [self.view layoutIfNeeded];
        self.currentModel = [CBCommonTools CBdeviceInfo];
        [self showCurrentSelectedDeviceLocation];
        [self createFence];
    }
//    [self createBottomView];
}

- (void)addDeleteAndSave {
    NSString *title = Localized(@"保存");
    CGFloat width = [NSString getWidthWithText:title font:[UIFont boldSystemFontOfSize: 15] height:30*KFitHeightRate];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0,  width,  30 * KFitHeightRate)];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 15];
    [rightBtn setTitle: title forState: UIControlStateNormal];
    [rightBtn setTitle: title forState: UIControlStateHighlighted];
    [rightBtn setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:kAppMainColor forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView: rightBtn];
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = - 15 * KFitWidthRate;
    
    NSString *title1 = Localized(@"删除");
    CGFloat width1 = [NSString getWidthWithText:title1 font:[UIFont boldSystemFontOfSize: 15] height:30*KFitHeightRate];
    UIButton *rightBtn1 = [[UIButton alloc] initWithFrame: CGRectMake(0, 0,  width1,  30 * KFitHeightRate)];
    rightBtn1.titleLabel.font = [UIFont boldSystemFontOfSize: 15];
    [rightBtn1 setTitle: title1 forState: UIControlStateNormal];
    [rightBtn1 setTitle: title1 forState: UIControlStateHighlighted];
    [rightBtn1 setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [rightBtn1 setTitleColor:UIColor.redColor forState:UIControlStateHighlighted];
    [rightBtn1 addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem1 = [[UIBarButtonItem alloc] initWithCustomView: rightBtn1];
    
    self.navigationItem.rightBarButtonItems = _isNewFence ? @[spaceItem, barItem] : @[spaceItem, barItem, barItem1];
    
    
}

- (void)setupMenuView {
    self.menuView = [CBFencyMenuView new];
    self.menuView.model = self.model;
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(PPNavigationBarHeight));
        make.left.right.equalTo(@0);
    }];
}

- (void)save {
    if (!_isNewFence) {
        if (self.isCircle) {
            _model.shape = 1;
            _model.data = [NSString stringWithFormat:@"%lf,%lf,%lf", self.roundCoordinateArr.firstObject.coordinate.latitude, self.roundCoordinateArr.firstObject.coordinate.longitude, self.radius];
        }
        if (self.isRect) {
            _model.shape = 2;
            _model.data = [self getDataString:self.rectangleCoordinateArr];
        }
        if (self.isPolygon) {
            _model.shape = 0;
            _model.data = [self getDataString:self.polygonCoordinateArr];
        }
    }
    [self saveBtnClick];
}
- (NSString *)getDataString:(NSArray<MINCoordinateObject *> *)objArr {
    NSMutableArray *mArr = [NSMutableArray new];
    for (MINCoordinateObject *obj in objArr) {
        CLLocationCoordinate2D coor = obj.coordinate;
        NSString *coorStr = [NSString stringWithFormat:@"%lf,%lf", coor.latitude, coor.longitude];
        [mArr addObject:coorStr];
    }
    return [mArr componentsJoinedByString:@","];
}

- (void)delete {
    [self deleteDevicePop];
}

- (BOOL)showBaidu {
    return self.baiduView.hidden == NO;
}

- (void)showCurrentSelectedDeviceLocation {
    CBHomeLeftMenuDeviceInfoModel *deviceInfoModel = self.currentModel;
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(deviceInfoModel.lat.doubleValue,  deviceInfoModel.lng.doubleValue);
    if ([self showBaidu]) {
        // 小车定位图标
        MINNormalAnnotation *normalAnnotation = [[MINNormalAnnotation alloc] init];
        normalAnnotation.icon = [CBCommonTools returnDeveceLocationImageStr:deviceInfoModel.icon isOnline:deviceInfoModel.online isWarmed:deviceInfoModel.warmed];
        normalAnnotation.warmed = deviceInfoModel.warmed;
        normalAnnotation.coordinate = coor;
        normalAnnotation.isSelect = YES;// 选中设备显示最前
        [self.baiduMapView addAnnotation: normalAnnotation];
        
        // 小车定位上方信息
        MINNormalInfoAnnotation *normalInfoAnnotation = [[MINNormalInfoAnnotation alloc] init];
        normalInfoAnnotation.deviceName = deviceInfoModel.name?:@"";
        normalInfoAnnotation.speed = deviceInfoModel.speed?:@"";
        normalInfoAnnotation.warmed = deviceInfoModel.warmed;
        normalInfoAnnotation.coordinate = coor;
        normalInfoAnnotation.isSelect = YES;// 选中设备显示最前
        [self.baiduMapView addAnnotation: normalInfoAnnotation];
        
        [self.baiduMapView setCenterCoordinate:coor animated:YES];
    } else {
        // 小车定位图标
        GMSMarker *normalMarker = [[GMSMarker alloc] init];
        normalMarker.appearAnimation = kGMSMarkerAnimationNone;
        normalMarker.position = coor;
        UIImage *icon = [CBCommonTools returnDeveceLocationImageStr:deviceInfoModel.icon isOnline:deviceInfoModel.online isWarmed:deviceInfoModel.warmed];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, icon.size.width, icon.size.height)];
        imageView.image = icon;
        normalMarker.iconView = imageView;
        normalMarker.groundAnchor = CGPointMake(0.5, 0.5);
        normalMarker.map = self.googleMapView;
        // 选中设备显示最前
        self.googleMapView.selectedMarker = normalMarker;

        // 小车定位上方信息
        GMSMarker *normalInfoMarker = [[GMSMarker alloc] init];
        normalInfoMarker.appearAnimation = kGMSMarkerAnimationNone;
        normalInfoMarker.position = coor;

        normalInfoMarker.groundAnchor = CGPointMake(0.5f, 2.0f);
        UILabel *lbl = [MINUtils createLabelWithText:deviceInfoModel.name?:@"" size:14 alignment:NSTextAlignmentCenter textColor:kCellTextColor];
        [lbl sizeToFit];
        lbl.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        normalInfoMarker.iconView = lbl;
        normalInfoMarker.map = self.googleMapView;
        // 选中设备显示最前
        self.googleMapView.selectedMarker = normalMarker;
        self.googleMapView.camera = [GMSCameraPosition cameraWithLatitude:coor.latitude longitude:coor.longitude zoom:self.googleMapView.camera.zoom];
    }
}

- (void)createFence
{
    NSString *dataString = self.model.data;
    if (self.isPolygon) { // 多边形
        self.polygonCoordinateArr = [self getModelArr:dataString];
        for (MINCoordinateObject *obj in self.polygonCoordinateArr) {
            if (self.baiduView.hidden == NO) {
                [self addRectAnnotation:obj.coordinate];
            } else {
                [self addPoint_GMS:obj.coordinate];
            }
        }
        if (self.baiduView.hidden == NO) {
            [self addBaiduPolygon];
            [self baiduMapFitFence: self.polygonCoordinateArr];
        } else {
            [self addGooglePolygon];
            [self googleMapFitFence: self.polygonCoordinateArr];
        }
    }else if (self.isCircle) { // 圆
        NSArray *dataArr = [dataString componentsSeparatedByString: @","];
        if (dataArr.count == 3) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake( [dataArr[0] doubleValue], [dataArr[1] doubleValue]);
            self.radius = [dataArr.lastObject doubleValue];
            
            if (self.baiduView.hidden == NO) {
                
                [self mapView:self.baiduMapView onClickedMapBlank:coordinate];
//                [self addAnnotation_baidu:coordinate];
//                [self addBaiduCircleMarkerWithRadius: dataArr.lastObject];
                [self baiduMapFitCircleFence:[self getCoorObj:coordinate] radius: [dataArr[2] doubleValue]];
            }else {
                [self mapView:self.googleMapView didTapAtCoordinate:coordinate];
//                [self addGoogleCircleMarkerWithRadius: dataArr.lastObject];
                [self googleMapFitCircleFence:coordinate radius:self.radius];
            }
//            [self updateMapCenter:coordinate];
        }
    }else if (self.isRect) { // 矩形
        self.rectangleCoordinateArr = [self getModelArr: dataString];
        for (MINCoordinateObject *obj in self.rectangleCoordinateArr) {
            if (self.baiduView.hidden == NO) {
                [self addRectAnnotation:obj.coordinate];
            } else {
                [self addPoint_GMS:obj.coordinate];
            }
        }
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
- (void)addRectAnnotation:(CLLocationCoordinate2D)coor {
    CBRectAnnotation *a = [CBRectAnnotation new];
    a.coordinate = coor;
    [self.baiduMapView addAnnotation:a];
}
- (void)addRadiusPoint_BMK:(CLLocationCoordinate2D)coordinate radius:(CGFloat)radius {
    CBRadiusAnnotation *a = [CBRadiusAnnotation new];
    a.coordinate = coordinate;
    a.radius = radius;
    [self.baiduMapView addAnnotation:a];
}
- (void)updateMapCenter:(CLLocationCoordinate2D)coordinate {
    if (self.baiduView.hidden == NO) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.baiduMapView setCenterCoordinate:coordinate animated: YES];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.googleMapView.camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:self.googleMapView.camera.zoom];
        });
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
    CBHomeLeftMenuDeviceInfoModel *deviceInfoModel = self.currentModel;
    CLLocationCoordinate2D currentDeviceCoor = CLLocationCoordinate2DMake(deviceInfoModel.lat.doubleValue,  deviceInfoModel.lng.doubleValue);
    NSMutableArray *coorArr = [NSMutableArray arrayWithArray:modelArr];
    [coorArr addObject:[self getCoorObj:currentDeviceCoor]];
    CGFloat leftX, leftY, rightX, rightY; // 最左或右边的X、Y
    leftX = CGFLOAT_MAX;
    leftY = CGFLOAT_MAX;
    rightX = CGFLOAT_MIN;
    rightY = CGFLOAT_MIN;
    for (int i = 0; i < coorArr.count; i++) {
        MINCoordinateObject *model = coorArr[i];
        BMKMapPoint modelPoint = BMKMapPointForCoordinate( model.coordinate);
        if (modelPoint.x < leftX) {
            leftX = modelPoint.x;
        }
        if (modelPoint.x > rightX) {
            rightX = modelPoint.x;
        }
        if (modelPoint.y < leftY) {
            leftY = modelPoint.y;
        }
        if (modelPoint.y > rightY) {
            rightY = modelPoint.y;
        }
    }
    BMKMapRect fitRect;
    double width = rightX - leftX;
    double height = rightY - leftY;
    fitRect.origin = BMKMapPointMake(leftX, leftY);
    fitRect.size = BMKMapSizeMake(width, height);
    [_baiduMapView setVisibleMapRect: fitRect];
    _baiduMapView.zoomLevel = _baiduMapView.zoomLevel - 0.3;
    
}
// 百度圆
- (void)baiduMapFitCircleFence:(MINCoordinateObject *)model radius:(double)radius {
    CBHomeLeftMenuDeviceInfoModel *deviceInfoModel = self.currentModel;
    CLLocationCoordinate2D currentDeviceCoor = CLLocationCoordinate2DMake(deviceInfoModel.lat.doubleValue,  deviceInfoModel.lng.doubleValue);
    BMKMapPoint devicePoint = BMKMapPointForCoordinate(currentDeviceCoor);
    
    // 一个点的长度是0.870096
    BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:model.coordinate radius:radius];
    BMKMapRect fitRect = circle.boundingMapRect;
    
    double x = devicePoint.x < fitRect.origin.x ? devicePoint.x : fitRect.origin.x;
    double y = devicePoint.y < fitRect.origin.y ? devicePoint.y : fitRect.origin.y;
    double offsetX = (devicePoint.x - fitRect.origin.x) < 0 ? (devicePoint.x - fitRect.origin.x) * -1 : (devicePoint.x - fitRect.origin.x);
    double offsetY = (devicePoint.y - fitRect.origin.y) < 0 ? (devicePoint.y - fitRect.origin.y) * -1 : (devicePoint.y - fitRect.origin.y);
    double w = offsetX > fitRect.size.width ? offsetX : fitRect.size.width;
    double h = offsetY > fitRect.size.height ? offsetY : fitRect.size.height;
    
    BMKMapRect finalRect = BMKMapRectMake(x, y, w, h);

    [_baiduMapView setVisibleMapRect: finalRect];
    _baiduMapView.zoomLevel = _baiduMapView.zoomLevel - 0.3;
}
- (void)googleMapFitFence:(NSArray *)modelArr
{
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    for (MINCoordinateObject *model in modelArr) {
        bounds = [bounds includingCoordinate: model.coordinate];
    }
    [_googleMapView animateWithCameraUpdate: [GMSCameraUpdate fitBounds: bounds withPadding: 110.0f]];//30.0f 面积距离屏幕宽
}
- (void)addPoint_GMS:(CLLocationCoordinate2D)coordinate {
    GMSMarker *mark_point = [[GMSMarker alloc] init];
    mark_point.appearAnimation = kGMSMarkerAnimationNone;//kGMSMarkerAnimationPop;
    mark_point.position = coordinate;
    mark_point.icon = [UIImage imageNamed:@"电子围栏-正方形-默认"];
    mark_point.draggable = true;
    mark_point.groundAnchor = CGPointMake(0.5f, 0.5f);
    mark_point.map = self.googleMapView;
}
- (void)googleMapFitCircleFence:(CLLocationCoordinate2D)coor radius:(double)radius {
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    bounds = [bounds includingCoordinate: GMSGeometryOffset(coor, radius, 0)];
    bounds = [bounds includingCoordinate: GMSGeometryOffset(coor, radius, 90)];
    bounds = [bounds includingCoordinate: GMSGeometryOffset(coor, radius, 180)];
    bounds = [bounds includingCoordinate: GMSGeometryOffset(coor, radius, 270)];
    [_googleMapView animateWithCameraUpdate: [GMSCameraUpdate fitBounds: bounds withPadding: 100.0f]];
}

- (void)addGoogleRectangle
{
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
    
    if (!self.gmsRectPolygon) {
        GMSPolygon *polygon = [GMSPolygon polygonWithPath:rect];
        polygon.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        polygon.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        polygon.strokeWidth = 0;//2;
        polygon.map = _googleMapView;
        self.gmsRectPolygon = polygon;
    } else {
        self.gmsRectPolygon.path = rect;
    }
}

- (void)addBaiduRectangle
{
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
    
    if (!self.baiduRectPolygon) {
        self.baiduRectPolygon = [BMKPolygon polygonWithCoordinates:coords count:4];
        [_baiduMapView addOverlay:self.baiduRectPolygon];
    } else {
        [self.baiduRectPolygon setPolygonWithCoordinates:coords count:4];
    }
}

- (void)addGoogleCircleMarkerWithRadius:(CLLocationDistance)radius {
    GMSCircle *circ = [GMSCircle circleWithPosition:self.roundCoordinateArr.firstObject.coordinate
                                             radius:radius];
    circ.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    circ.strokeWidth = 0;
    circ.map = _googleMapView;
    self.gmsCircle = circ;
    // 半径
    GMSMarker *normalInfoMarker = [[GMSMarker alloc] init];
    normalInfoMarker.appearAnimation = kGMSMarkerAnimationNone;
    normalInfoMarker.position = self.roundCoordinateArr.firstObject.coordinate;

//    normalInfoMarker.groundAnchor = CGPointMake(0.5f, 2.0f);
    UILabel *lbl = [MINUtils createLabelWithText:[NSString stringWithFormat:@"%.0lf", radius] size:14 alignment:NSTextAlignmentCenter textColor:kCellTextColor];
    [lbl sizeToFit];
    lbl.width += 30;
    lbl.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    normalInfoMarker.iconView = lbl;
    normalInfoMarker.map = self.googleMapView;
    self.gmsRadiusLbl = lbl;
}

- (void)addBaiduCircle:(CLLocationCoordinate2D)coor radius:(CGFloat)radius {
    CGFloat radiusNum = radius;
    BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coor radius: radiusNum];
    [_baiduMapView addOverlay: circle];
    self.baiduCircleView = circle;
    NSLog(@"---lzx: 生成新的: %@", self.baiduCircleView);
    
    CBRadiusAnnotation *a = [CBRadiusAnnotation new];
    a.coordinate = coor;
    a.radius = radiusNum;
    [self.baiduMapView addAnnotation:a];
}

- (void)addGooglePath
{
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
    GMSMutablePath *path = [GMSMutablePath path];
    for (int i = 0; i < self.polygonCoordinateArr.count; i++) {
        MINCoordinateObject *obj = self.polygonCoordinateArr[i];
        [path addLatitude: obj.coordinate.latitude longitude: obj.coordinate.longitude];
    }
    if (!self.gmsPolygon) {
        GMSPolygon *polygon = [GMSPolygon polygonWithPath: path];
        polygon.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        polygon.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        polygon.strokeWidth = 0;//2;
        polygon.map = _googleMapView;
        self.gmsPolygon = polygon;
    } else {
        self.gmsPolygon.path = path;
    }
}

- (void)addBaiduPolygon
{
    CLLocationCoordinate2D coords[self.polygonCoordinateArr.count];
    for (int i = 0; i < self.polygonCoordinateArr.count; i++) {
        MINCoordinateObject *obj = self.polygonCoordinateArr[i];
        coords[i] = obj.coordinate;
    }
    if (!self.baiduPolygon) {
        BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count: self.polygonCoordinateArr.count];
        [_baiduMapView addOverlay:polygon];
        self.baiduPolygon = polygon;
    } else {
        [self.baiduPolygon setPolygonWithCoordinates:coords count:self.polygonCoordinateArr.count];
    }
}

- (void)clearMap
{
    [self.roundCoordinateArr removeAllObjects];
    self.baiduCircleView = nil;
    self.gmsCircle = nil;
    [self.rectangleCoordinateArr removeAllObjects];
    [self.polygonCoordinateArr removeAllObjects];
    if (self.baiduView.hidden == NO) {
        [self.baiduMapView removeOverlays: self.baiduMapView.overlays];
        [self.baiduMapView removeAnnotations: self.baiduMapView.annotations];
    }else {
        [self.googleMapView clear];
    }
    [self showCurrentSelectedDeviceLocation];
}

//- (void)createBottomView
//{
//    UIView *bottomView = [[UIView alloc] init];
//    [self.view addSubview: bottomView];
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.equalTo(self.view);
//        make.height.mas_equalTo(50 * KFitHeightRate);
//    }];
//    UIView *topLineView = [MINUtils createLineView];
//    [bottomView addSubview: topLineView];
//    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(0.5);
//        make.top.left.right.equalTo(bottomView);
//    }];
//    self.shareBtn = [self createBtnWithImage:@"分享" title:Localized(@"分享")];
//    self.deleteBtn = [self createBtnWithImage:@"删-除" title:Localized(@"删除")];
//    UIButton *lastBtn = nil;
//    NSArray *arr = @[self.shareBtn, self.deleteBtn];
//    for (int i = 0; i < arr.count; i++) {
//        UIButton *button = arr[i];
//        [bottomView addSubview: button];
//        if (lastBtn == nil) {
//            [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.bottom.equalTo(bottomView);
//                make.left.equalTo(bottomView);
//                make.width.mas_equalTo(SCREEN_WIDTH/2);
//            }];
//        }else {
//            [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.bottom.equalTo(bottomView);
//                make.left.equalTo(lastBtn.mas_right);
//                make.width.mas_equalTo(SCREEN_WIDTH/2);
//            }];
//        }
//        lastBtn = button;
//    }
//}

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
        make.top.equalTo(self.menuView.mas_bottom);
        make.left.right.bottom.equalTo(@0);
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
    [_baiduMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

- (void)googleMap
{
    _googleView = [[UIView alloc] init];
    _googleView.hidden = ![AppDelegate shareInstance].IsShowGoogleMap;
    [self.view addSubview: _googleView];
    [_googleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom);
        make.left.right.bottom.equalTo(@0);
    }];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.056898
                                                            longitude:116.307626
                                                                 zoom:14];
    _googleMapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50*KFitHeightRate) camera:camera];
    //    _googleMapView.myLocationEnabled = YES;
    _googleMapView.delegate = self;
    [_googleView addSubview: _googleMapView];
    [_googleMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}
#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    if (self.isCircle == YES) {
        [self clearMap];
        [self.roundCoordinateArr removeAllObjects];
        [self.roundCoordinateArr addObject:[self getCoorObj:coordinate]];
        
        [self addGoogleCircleMarkerWithRadius:self.radius];
        
        CLLocationCoordinate2D dragCoor = GMSGeometryOffset(coordinate, self.radius, 90);
        [self addPoint_GMS:dragCoor];
        
    }
}
- (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker {
    if (self.isRect) {
        self.gmsPolygonCurrentMark = [self getCorrectIndexFromArray:self.rectangleCoordinateArr withTargetCoor:marker.position];
    }
    if (self.isPolygon) {
        self.gmsPolygonCurrentMark = [self getCorrectIndexFromArray:self.polygonCoordinateArr withTargetCoor:marker.position];
    }
}

- (void)mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker {
    if (self.isCircle) {
        self.radius = GMSGeometryDistance(self.roundCoordinateArr.firstObject.coordinate, marker.position);
        self.gmsCircle.radius = self.radius;
        self.gmsRadiusLbl.text = [NSString stringWithFormat:@"%.0lf", self.radius];
    }
    if (self.isRect) {
        [self.rectangleCoordinateArr replaceObjectAtIndex:self.gmsPolygonCurrentMark withObject:[self getCoorObj:marker.position]];
        [self addGoogleRectangle];
    }
    if (self.isPolygon) {
        [self.polygonCoordinateArr replaceObjectAtIndex:self.gmsPolygonCurrentMark withObject:[self getCoorObj:marker.position]];
        [self addGooglePolygon];
    }
}

- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker {
    if (self.isCircle) {
        self.radius = GMSGeometryDistance(self.roundCoordinateArr.firstObject.coordinate, marker.position);
        self.gmsCircle.radius = self.radius;
        self.gmsRadiusLbl.text = [NSString stringWithFormat:@"%.0lf", self.radius];
    }
    if (self.isRect) {
        [self.rectangleCoordinateArr replaceObjectAtIndex:self.gmsPolygonCurrentMark withObject:[self getCoorObj:marker.position]];
        [self addGoogleRectangle];
    }
    if (self.isPolygon) {
        [self.polygonCoordinateArr replaceObjectAtIndex:self.gmsPolygonCurrentMark withObject:[self getCoorObj:marker.position]];
        [self addGooglePolygon];
    }
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
     }
    if ([annotation isKindOfClass: [MINNormalInfoAnnotation class]]) {
     // 定位图标上方信息  设备信息标注
        MINNormalInfoAnnotation *model = (MINNormalInfoAnnotation *)annotation;
        static NSString *AnnotationViewID = @"NormalInfoAnnotationView";
        MINAlertAnnotationView *annotationView = (MINAlertAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (!annotationView) {
            annotationView = [[MINAlertAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
        annotationView.userInteractionEnabled = YES;
        annotationView.centerOffset = CGPointMake(0, -20*KFitHeightRate);
        annotationView.textLbl.text = model.deviceName?:@"";
        annotationView.frame = CGRectMake(0, 0, 70 * KFitWidthRate,  30 * KFitWidthRate);
        if (model.isSelect) {
            annotationView.displayPriority = BMKFeatureDisplayPriorityDefaultHigh;
        }
         return annotationView;
     }
    if ([annotation isKindOfClass: [CBRectAnnotation class]]) {
        CBRectAnnotation *model = (CBRectAnnotation *)annotation;
        static NSString *AnnotationViewID = @"BMKRectAnnotationView";
        
        BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (!annotationView) {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
        annotationView.draggable = YES;
        annotationView.image = [UIImage imageNamed:@"电子围栏-正方形-默认"];
        return annotationView;
    }
    if ([annotation isKindOfClass: [CBRadiusAnnotation class]]) {
        CBRadiusAnnotation *model = (CBRadiusAnnotation *)annotation;
        static NSString *AnnotationViewID = @"NormalInfoAnnotationView";
        MINAlertAnnotationView *annotationView = (MINAlertAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (!annotationView) {
            annotationView = [[MINAlertAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
        annotationView.userInteractionEnabled = YES;
        annotationView.centerOffset = CGPointMake(0, -20*KFitHeightRate);
        annotationView.textLbl.text = [NSString stringWithFormat:@"%.0lf", model.radius];
        annotationView.frame = CGRectMake(0, 0, 70 * KFitWidthRate,  30 * KFitWidthRate);
        annotationView.displayPriority = BMKFeatureDisplayPriorityDefaultHigh;
        self.baiduRadiusView = annotationView;
         return annotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState fromOldState:(BMKAnnotationViewDragState)oldState {
    
    static NSInteger rectDragIndex = 0;
    switch (newState) {
        case 1:
            NSLog(@"---lzx: 开始拖拽");
            CLLocationCoordinate2D viewCoor = [self.baiduMapView convertPoint:view.center toCoordinateFromView:self.baiduMapView];
            if (self.isRect) {
                rectDragIndex = [self getCorrectIndexFromArray:self.rectangleCoordinateArr withTargetCoor:viewCoor];
            }
            if (self.isPolygon) {
                rectDragIndex = [self getCorrectIndexFromArray:self.polygonCoordinateArr withTargetCoor:viewCoor];
            }
            break;
        case 2: {
            NSLog(@"---lzx: 拖拽中: %d", rectDragIndex);
            if (self.isCircle) {
                MINCoordinateObject *coorObj = self.roundCoordinateArr.firstObject;
                CLLocationCoordinate2D center = coorObj.coordinate;
                CLLocationCoordinate2D viewCoor = [self.baiduMapView convertPoint:view.center toCoordinateFromView:self.baiduMapView];
                CLLocationDistance distance = BMKMetersBetweenMapPoints(BMKMapPointForCoordinate(center), BMKMapPointForCoordinate(viewCoor));
                self.radius = distance;
                BOOL success = [self.baiduCircleView setCircleWithCenterCoordinate:self.baiduCircleView.coordinate radius:distance];
                NSLog(@"---lzx: %@, ra: %lf, dis:%lf, succ: %d",  self.baiduCircleView, self.baiduCircleView.radius, distance, success);
                self.baiduRadiusView.textLbl.text = [NSString stringWithFormat:@"%.0lf", distance];
            }
            if (self.isRect) {
                CLLocationCoordinate2D viewCoor = [self.baiduMapView convertPoint:view.center toCoordinateFromView:self.baiduMapView];
                MINCoordinateObject *obj1 = self.rectangleCoordinateArr[rectDragIndex];
                obj1.coordinate = viewCoor;
                [self addBaiduRectangle];
            }
            if (self.isPolygon) {
                CLLocationCoordinate2D viewCoor = [self.baiduMapView convertPoint:view.center toCoordinateFromView:self.baiduMapView];
                MINCoordinateObject *obj1 = self.polygonCoordinateArr[rectDragIndex];
                obj1.coordinate = viewCoor;
                [self addBaiduPolygon];
            }
            break;
        }
        case 4: {
            NSLog(@"---lzx: 拖拽结束");
            if (self.isCircle) {
                MINCoordinateObject *coorObj = self.roundCoordinateArr.firstObject;
                CLLocationCoordinate2D center = coorObj.coordinate;
                CLLocationCoordinate2D viewCoor = [self.baiduMapView convertPoint:view.center toCoordinateFromView:self.baiduMapView];
                CLLocationDistance distance = BMKMetersBetweenMapPoints(BMKMapPointForCoordinate(center), BMKMapPointForCoordinate(viewCoor));
                self.radius = distance;
                self.baiduCircleView.radius = distance;
                self.baiduRadiusView.textLbl.text = [NSString stringWithFormat:@"%.0lf", distance];
                
            }
            if (self.isRect) {
                CLLocationCoordinate2D viewCoor = [self.baiduMapView convertPoint:view.center toCoordinateFromView:self.baiduMapView];
                MINCoordinateObject *obj1 = self.rectangleCoordinateArr[rectDragIndex];
                obj1.coordinate = viewCoor;
                [self addBaiduRectangle];
            }
            if (self.isPolygon) {
                CLLocationCoordinate2D viewCoor = [self.baiduMapView convertPoint:view.center toCoordinateFromView:self.baiduMapView];
                MINCoordinateObject *obj1 = self.polygonCoordinateArr[rectDragIndex];
                obj1.coordinate = viewCoor;
                [self addBaiduPolygon];
            }
            
            break;
        }
    }
}

- (NSUInteger)getCorrectIndexFromArray:(NSArray<MINCoordinateObject *> *)objArr withTargetCoor:(CLLocationCoordinate2D)targetCoor {
    NSUInteger targetIdx = 0;
    double minOffset = CGFLOAT_MAX;
    for(int i = 0; i < objArr.count; i++) {
        MINCoordinateObject *obj = objArr[i];
        CLLocationCoordinate2D coor = obj.coordinate;
        double lat1 = coor.latitude - targetCoor.latitude;
        lat1 = (lat1 > 0) ? lat1 : lat1 * -1;
        double lon1 = coor.longitude - targetCoor.longitude;
        lon1 = (lon1 > 0) ? lon1 : lon1 * -1;
        if (minOffset > (lat1+lon1)) {
            minOffset = (lat1+lon1);
            targetIdx = i;
        }
    }
    
    return targetIdx;
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
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    if (self.isCircle) {
        [self clearMap];
        [self.roundCoordinateArr removeAllObjects];
        [self.roundCoordinateArr addObject:[self getCoorObj:coordinate]];
        //添加可移动小方块
        BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coordinate radius: self.radius];
        BMKMapRect mapRect = circle.boundingMapRect;
        CLLocationCoordinate2D rectCoor = BMKCoordinateForMapPoint(BMKMapPointMake(BMKMapRectGetMaxX(mapRect), mapRect.origin.y+mapRect.size.height/2.0));
        [self addRectAnnotation:rectCoor];
//        //添加公里数
//        [self addRadiusPoint_BMK:coordinate radius:self.radius];
        
        //添加圆形
        [self addBaiduCircle:coordinate radius:self.radius];
    } else if (self.isRect) {
        
        //进页面时就画好, 不能再点击空白
//        if (self.rectangleCoordinateArr.count > 1) {
//            [MINUtils showProgressHudToView:self.view withText:Localized(@"不能超过两个点")];
//            return;
//        }
//        [self.rectangleCoordinateArr addObject:[self getCoorObj:coordinate]];
//        [self addRectAnnotation:coordinate];
//        if (self.rectangleCoordinateArr.count == 2) {
//            if (self.baiduView.hidden == NO) {
//                [self addBaiduRectangle];
//            } else {
//                [self addGoogleRectangle];
//            }
//        }
        
    } else if (self.isPolygon) {
        
        //进页面时就画好, 不能再点击空白
//
//        [self.polygonCoordinateArr addObject:[self getCoorObj:coordinate]];
//        [self addRectAnnotation:coordinate];
//        if (self.polygonCoordinateArr.count > 2) {
//            if (self.baiduView.hidden == NO) {
//                [self addBaiduPolygon];
//            } else {
//                [self addGooglePolygon];
//            }
//        }
//
    }
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
#pragma mark -- CLLocationCoordinate2D 转为对象
- (MINCoordinateObject *)getCoorObj:(CLLocationCoordinate2D)coordinate {
    MINCoordinateObject *coorObj = [[MINCoordinateObject alloc] init];
    coorObj.coordinate = coordinate;
    return coorObj;
}
@end
