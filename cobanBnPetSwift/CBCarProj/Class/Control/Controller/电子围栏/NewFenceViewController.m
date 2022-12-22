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
#import "MINNormalAnnotation.h"
#import "MINNormalInfoAnnotation.h"
#import "MINAnnotationView.h"
#import "MINAlertAnnotationView.h"
#import "FenceDetailViewController.h"

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

@property (nonatomic, strong) UILabel *tipsLbl;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) CLLocationCoordinate2D circleCoordinate;
@property (nonatomic, copy) NSString *circleRadius;

/** 圆形坐标数组容器 */
@property (nonatomic, strong) NSMutableArray<MINCoordinateObject *> *roundCoordinateArr;
/** 矩形坐标数组容器 */
@property (nonatomic, strong) NSMutableArray<MINCoordinateObject *> *rectangleCoordinateArr;
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

@property (nonatomic, strong) UIButton *barCircleBtn;
@property (nonatomic, strong) UIButton *barRectBtn;
@property (nonatomic, strong) UIButton *barPolygonBtn;
@property (nonatomic, assign) BOOL isCircle;
@property (nonatomic, assign) BOOL isRect;
@property (nonatomic, assign) BOOL isPolygon;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) CBHomeLeftMenuDeviceInfoModel *currentModel;
@property (nonatomic, strong) BMKCircle *baiduCircleView;
@property (nonatomic, strong) MINAlertAnnotationView *baiduRadiusView;
@property (nonatomic, assign) CLLocationDistance radius;

@property (nonatomic, strong) BMKPolygon *baiduRectPolygon;
@property (nonatomic, strong) BMKPolygon *baiduPolygon;

@property (nonatomic, strong) GMSCircle *gmsCircle;
@property (nonatomic, strong) UILabel *gmsRadiusLbl;
@property (nonatomic, assign) NSInteger gmsPolygonCurrentMark;
@property (nonatomic, strong) GMSPolygon *gmsRectPolygon;
@property (nonatomic, strong) GMSPolygon *gmsPolygon;
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
    
    self.radius = 1000;
    self.currentModel = [CBCommonTools CBdeviceInfo];
    [self createUI];
    // 显示mark在地图上，百度地图 http://www.cocoachina.com/bbs/read.php?tid=1719280
    // 谷歌地图显示所有标记 https://stackoverflow.com/questions/21615811/ios-how-to-use-gmscoordinatebounds-to-show-all-the-markers-of-the-map
//    _googleMapView cameraForBounds:<#(nonnull GMSCoordinateBounds *)#> insets:<#(UIEdgeInsets)#>
}
#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"新增围栏") isBack: YES];
    [self addRightBtns];
    [self createBottomView];
    
    [self baiduMap];
    [self googleMap];
    
    [self showCurrentSelectedDeviceLocation];
}
- (void)addRightBtns {
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setImage:[UIImage imageNamed:@"电子围栏-圆形"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickCircle) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView: rightBtn];
    self.barCircleBtn = rightBtn;
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = 30 * KFitWidthRate;
    UIBarButtonItem * spaceItem1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem1.width = 30 * KFitWidthRate;
    
    
    UIButton *rightBtn1 = [[UIButton alloc] init];
    [rightBtn1 setImage:[UIImage imageNamed:@"电子围栏-正方形-默认"] forState:UIControlStateNormal];
    [rightBtn1 addTarget:self action:@selector(clickRectangle) forControlEvents:UIControlEventTouchUpInside];
    self.barRectBtn = rightBtn1;
    UIBarButtonItem *barItem1 = [[UIBarButtonItem alloc] initWithCustomView: rightBtn1];
    
    UIButton *rightBtn2 = [[UIButton alloc] init];
    [rightBtn2 setImage:[UIImage imageNamed:@"电子围栏-多边形-默认"] forState:UIControlStateNormal];
    [rightBtn2 addTarget:self action:@selector(clickPolygon) forControlEvents:UIControlEventTouchUpInside];
    self.barPolygonBtn = rightBtn2;
    UIBarButtonItem *barItem2 = [[UIBarButtonItem alloc] initWithCustomView: rightBtn2];
    
    self.navigationItem.rightBarButtonItems = @[barItem2, spaceItem, barItem1, spaceItem1, barItem];
    self.isCircle = YES;
    self.isRect = NO;
    self.isPolygon = NO;
}
- (void)clickCircle {
    self.isCircle = YES;
    self.isRect = NO;
    self.isPolygon = NO;
    _tipsLbl.text = Localized(@"圆形围栏: 点击地图选择圆心, 长按拖动小方块缩放改变半径");
    [self.barCircleBtn setImage:[UIImage imageNamed:@"电子围栏-圆形"] forState:UIControlStateNormal];
    [self.barRectBtn setImage:[UIImage imageNamed:@"电子围栏-正方形-默认"] forState:UIControlStateNormal];
    [self.barPolygonBtn setImage:[UIImage imageNamed:@"电子围栏-多边形-默认"] forState:UIControlStateNormal];
    [self clearMap];
}
- (void)clickRectangle {
    self.isCircle = NO;
    self.isRect = YES;
    self.isPolygon = NO;
    _tipsLbl.text = Localized(@"矩形围栏: 点击地图选择两点, 自动形成矩形围栏");
    [self.barCircleBtn setImage:[UIImage imageNamed:@"电子围栏-圆形-默认"] forState:UIControlStateNormal];
    [self.barRectBtn setImage:[UIImage imageNamed:@"电子围栏-正方形"] forState:UIControlStateNormal];
    [self.barPolygonBtn setImage:[UIImage imageNamed:@"电子围栏-多边形-默认"] forState:UIControlStateNormal];
    [self clearMap];
}
- (void)clickPolygon {
    self.isCircle = NO;
    self.isRect = NO;
    self.isPolygon = YES;
    _tipsLbl.text = Localized(@"多边形围栏: 点击地图至少选取三点, 自动形成多边形围栏");
    [self.barCircleBtn setImage:[UIImage imageNamed:@"电子围栏-圆形-默认"] forState:UIControlStateNormal];
    [self.barRectBtn setImage:[UIImage imageNamed:@"电子围栏-正方形-默认"] forState:UIControlStateNormal];
    [self.barPolygonBtn setImage:[UIImage imageNamed:@"电子围栏-多边形"] forState:UIControlStateNormal];
    [self clearMap];
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
//- (UIButton *)commitBtn {
//    if (!_commitBtn) {
//        _commitBtn = [MINUtils createBtnWithRadius:4 title:Localized(@"提交")];
//        _commitBtn.backgroundColor = kBlueColor;
//        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        _commitBtn.hidden = YES;
//        [_commitBtn addTarget:self action:@selector(createFenceCommitClick) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_commitBtn];
//        [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.circleBtn.mas_top).offset(-10);
//            make.left.mas_equalTo(10);
//            make.right.mas_equalTo(-10);
//            make.height.mas_equalTo(44);
//        }];
//    }
//    return _commitBtn;
//}
- (void)createBottomView {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview: bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
    }];
    self.bottomView = bottomView;
    UIView *contentView = [UIView new];
    [bottomView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(@(-TabPaddingBARHEIGHT));
    }];
    
    UILabel *tipsLbl = [MINUtils createLabelWithText:Localized(@"圆形围栏: 点击地图选择圆心, 长按拖动小方块缩放改变半径") size:14 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
    [contentView addSubview:tipsLbl];
    tipsLbl.numberOfLines = 0;
    [tipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.right.equalTo(@-10);
    }];
    _tipsLbl = tipsLbl;
    
    UIButton *resetBtn = [UIButton new];
    resetBtn.backgroundColor = UIColor.whiteColor;
    resetBtn.layer.borderColor = kCellTextColor.CGColor;
    resetBtn.layer.borderWidth = 1;
    resetBtn.layer.cornerRadius = 20;
    [resetBtn setTitle:Localized(@"重置") forState:UIControlStateNormal];
    [resetBtn setTitleColor:kCellTextColor forState:UIControlStateNormal];
    [contentView addSubview:resetBtn];
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLbl.mas_bottom).mas_offset(5);
        make.left.equalTo(@15);
        make.bottom.equalTo(@-10);
        make.height.equalTo(@40);
    }];
    [resetBtn addTarget:self action:@selector(clickReset) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextBtn = [UIButton new];
    nextBtn.backgroundColor = kCellTextColor;
    nextBtn.layer.cornerRadius = 20;
    [nextBtn setTitle:Localized(@"下一步") forState:UIControlStateNormal];
    [nextBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [contentView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(resetBtn);
        make.left.equalTo(resetBtn.mas_right).mas_offset(20);
        make.height.width.equalTo(resetBtn);
        make.right.equalTo(@-15);
    }];
    [nextBtn addTarget:self action:@selector(clickNext) forControlEvents:UIControlEventTouchUpInside];
    
//    UIView *topLineView = [MINUtils createLineView];
//    [bottomView addSubview: topLineView];
//    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(0.5);
//        make.top.left.right.equalTo(bottomView);
//    }];
//    self.circleBtn = [self createBtnWithImage: @"椭圆-1" selectedImage: @"椭圆1-2" title:Localized(@"圆形")];
//    self.circleBtn.selected = YES;
//    self.circleBtn.backgroundColor = kBlueColor;
//    self.rectangleBtn = [self createBtnWithImage: @"矩形-1" selectedImage: @"矩形-2" title:Localized(@"矩形")];
//    self.polygonBtn = [self createBtnWithImage: @"多边形-1" selectedImage: @"多边形-2" title:Localized(@"多边形")];
//    self.pathBtn = [self createBtnWithImage: @"路线" selectedImage: @"形状-2" title:Localized(@"路线")];
//    UIButton *lastBtn = nil;
//    NSArray *arr = @[self.circleBtn, self.rectangleBtn, self.polygonBtn, self.pathBtn];
//    for (int i = 0; i < arr.count; i++) {
//        UIButton *button = arr[i];
//        [bottomView addSubview: button];
//        [self.arrayBtn addObject:button];
//        if (lastBtn == nil) {
//            [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.bottom.equalTo(bottomView);
//                make.left.equalTo(bottomView);
//                make.width.mas_equalTo(SCREEN_WIDTH/4);
//            }];
//        }else {
//            [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.bottom.equalTo(bottomView);
//                make.left.equalTo(lastBtn.mas_right);
//                make.width.mas_equalTo(SCREEN_WIDTH/4);
//            }];
//        }
//        lastBtn = button;
//    }
}
- (void)clickReset {
    [self clearMap];
}
- (void)clickNext {
    if (self.isCircle && (
                          ([self showBaidu] && !self.baiduCircleView) ||
                          (![self showBaidu] && !self.gmsCircle)
                          )
    ) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"至少需要指定1个点")];
        return;
    }
    if (self.isRect && (
                        ([self showBaidu] && !self.baiduRectPolygon) ||
                        (![self showBaidu] && !self.gmsRectPolygon)
                        )
    ) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"至少需要指定2个点")];
        return;
    }
    if (self.isPolygon && (
                           ([self showBaidu] && !self.baiduPolygon) ||
                           (![self showBaidu] && !self.gmsPolygon)
                           )
    ) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"至少需要指定3个点")];
        return;
    }
    FenceDetailViewController *vc = [FenceDetailViewController new];
    FenceListModel *model = [FenceListModel new];
    if (self.isCircle) {
        model.shape = 1;
        model.data = [NSString stringWithFormat:@"%lf,%lf,%lf", self.circleCoordinate.latitude, self.circleCoordinate.longitude, self.radius];
    }
    if (self.isRect) {
        model.shape = 2;
        model.data = [self getDataString:self.rectangleCoordinateArr];
    }
    if (self.isPolygon) {
        model.shape = 0;
        model.data = [self getDataString:self.polygonCoordinateArr];
    }
    
    model.deviceName = self.currentModel.name;
    model.dno = self.currentModel.dno;
    //新围栏, sn默认是当前时间戳
    model.sn = [NSString stringWithFormat:@"%.0lf", NSDate.date.timeIntervalSince1970];
    vc.model = model;
    vc.isNewFence = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(self.bottomView.mas_top);
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
    _baiduMapView.userTrackingMode = BMKUserTrackingModeNone;
    [_baiduView addSubview: _baiduMapView];
    [_baiduMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

- (void)googleMap {
    _googleView = [[UIView alloc] init];
    _googleView.hidden = ![AppDelegate shareInstance].IsShowGoogleMap;
    [self.view addSubview: _googleView];
    [_googleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.056898
                                                            longitude:116.307626
                                                                 zoom:14];
    _googleMapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) camera:camera];
    _googleMapView.delegate = self;
    [_googleView addSubview: _googleMapView];
    [_googleMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

- (void)clearMap {
    [self.roundCoordinateArr removeAllObjects];
    self.baiduCircleView = nil;
    self.gmsCircle = nil;
    [self.rectangleCoordinateArr removeAllObjects];
    self.baiduRectPolygon = nil;
    self.gmsRectPolygon = nil;
    [self.polygonCoordinateArr removeAllObjects];
    self.baiduPolygon = nil;
    self.gmsPolygon = nil;
    if (self.baiduView.hidden == NO) {
        [self.baiduMapView removeOverlays: self.baiduMapView.overlays];
        [self.baiduMapView removeAnnotations: self.baiduMapView.annotations];
    } else {
        [self.googleMapView clear];
    }
    [self showCurrentSelectedDeviceLocation];
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
//                [weakSelf addBaiduCircleMarkerWithRadius:weakSelf.textField.text];
            }else {
//                [weakSelf addGoogleCircleMarkerWithRadius:weakSelf.textField.text];
            }
            weakSelf.isCircleCreate = YES;
            weakSelf.circleRadius = weakSelf.textField.text;
        }
    };
    alertView.leftBtnClick = ^{
        [weakAlertView hideView];
    };
}
- (void)addGoogleCircleMarkerWithRadius:(CLLocationDistance)radius {
    GMSCircle *circ = [GMSCircle circleWithPosition:self.circleCoordinate
                                             radius:radius];
    circ.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
    circ.strokeWidth = 0;
    circ.map = _googleMapView;
    self.gmsCircle = circ;
    // 半径
    GMSMarker *normalInfoMarker = [[GMSMarker alloc] init];
    normalInfoMarker.appearAnimation = kGMSMarkerAnimationNone;
    normalInfoMarker.position = self.circleCoordinate;

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
    
    CBRadiusAnnotation *a = [CBRadiusAnnotation new];
    a.coordinate = coor;
    a.radius = radiusNum;
    [self.baiduMapView addAnnotation:a];
}
- (void)addGooglePolygon {
    GMSMutablePath *path = [GMSMutablePath path];
    for (int i = 0; i < self.polygonCoordinateArr.count; i++) {
        MINCoordinateObject *obj = self.polygonCoordinateArr[i];
        [path addLatitude: obj.coordinate.latitude longitude: obj.coordinate.longitude];
    }
    if (!self.gmsPolygon) {
        GMSPolygon *polygon = [GMSPolygon polygonWithPath: path];
        polygon.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
        polygon.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
        polygon.strokeWidth = 0;//2;
        polygon.map = _googleMapView;
        self.gmsPolygon = polygon;
    } else {
        self.gmsPolygon.path = path;
    }
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
    
    if (!self.baiduPolygon) {
        BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count: self.polygonCoordinateArr.count];
        [_baiduMapView addOverlay:polygon];
        self.baiduPolygon = polygon;
    } else {
        [self.baiduPolygon setPolygonWithCoordinates:coords count:self.polygonCoordinateArr.count];
    }
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
    
    if (!self.gmsRectPolygon) {
        GMSPolygon *polygon = [GMSPolygon polygonWithPath:rect];
        polygon.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
        polygon.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
        polygon.strokeWidth = 0;//2;
        polygon.map = _googleMapView;
        self.gmsRectPolygon = polygon;
    } else {
        self.gmsRectPolygon.path = rect;
    }
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
    
    if (!self.baiduRectPolygon) {
        self.baiduRectPolygon = [BMKPolygon polygonWithCoordinates:coords count:4];
        [_baiduMapView addOverlay:self.baiduRectPolygon];
    } else {
        [self.baiduRectPolygon setPolygonWithCoordinates:coords count:4];
    }
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
        self.radius = GMSGeometryDistance(self.circleCoordinate, marker.position);
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
        self.radius = GMSGeometryDistance(self.circleCoordinate, marker.position);
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
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    if (self.isCircle == YES) {
        [self clearMap];
        self.circleCoordinate = coordinate;
        [self.roundCoordinateArr removeAllObjects];
        [self.roundCoordinateArr addObject:[self getCoorObj:coordinate]];
        
        [self addGoogleCircleMarkerWithRadius:self.radius];
        
        CLLocationCoordinate2D dragCoor = GMSGeometryOffset(self.circleCoordinate, self.radius, 90);
        [self addPoint_GMS:dragCoor];
        
    } else if (self.isRect == YES) {
        if (self.rectangleCoordinateArr.count > 1) {
            [MINUtils showProgressHudToView:self.view withText:Localized(@"不能超过两个点")];
            return;
        }
        [self.rectangleCoordinateArr addObject:[self getCoorObj:coordinate]];
        [self addPoint_GMS:coordinate];
        if (self.rectangleCoordinateArr.count == 2) {
            [self addGoogleRectangle];
        }
        
    } else if (self.isPolygon == YES) {

        [self.polygonCoordinateArr addObject:[self getCoorObj:coordinate]];
        [self addPoint_GMS:coordinate];
        if (self.polygonCoordinateArr.count > 2) {
            [self addGooglePolygon];
        }
        
    }else if (self.pathBtn.selected == YES) {
        
        [self.pathleCoordinateArr addObject:[self getCoorObj:coordinate]];
        [self addPoint_GMS:coordinate];
    }
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

- (void)showCurrentSelectedDeviceLocation {
    CBHomeLeftMenuDeviceInfoModel *deviceInfoModel = self.currentModel;
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(deviceInfoModel.lat.doubleValue,  deviceInfoModel.lng.doubleValue);
    if ([self showBaidu]) {
        // 小车定位图标
        MINNormalAnnotation *normalAnnotation = [[MINNormalAnnotation alloc] init];
        normalAnnotation.icon = [CBCommonTools returnDeveceLocationImageStr:deviceInfoModel.icon isOnline:deviceInfoModel.online isWarmed:deviceInfoModel.warmed mqttCode:deviceInfoModel.mqttCode devStatusInMqtt:deviceInfoModel.devStatusInMQTT];
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
        UIImage *icon = [CBCommonTools returnDeveceLocationImageStr:deviceInfoModel.icon isOnline:deviceInfoModel.online isWarmed:deviceInfoModel.warmed mqttCode:deviceInfoModel.mqttCode devStatusInMqtt:deviceInfoModel.devStatusInMQTT];
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

- (BOOL)showBaidu {
    return self.baiduView.hidden == NO;
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

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"---- 点击的坐标 ----%.f   %.f",coordinate.latitude,coordinate.longitude);
    
    if (self.isCircle == YES) {
        [self clearMap];
        [self.roundCoordinateArr removeAllObjects];
        self.circleCoordinate = coordinate;
        
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
        
    }else if (self.isRect == YES) {

        if (self.rectangleCoordinateArr.count > 1) {
            [MINUtils showProgressHudToView:self.view withText:Localized(@"不能超过两个点")];
            return;
        }
        [self.rectangleCoordinateArr addObject:[self getCoorObj:coordinate]];
        [self addRectAnnotation:coordinate];
        if (self.rectangleCoordinateArr.count == 2) {
            [self addBaiduRectangle];
        }
        
    } else if (self.isPolygon == YES) {

        [self.polygonCoordinateArr addObject:[self getCoorObj:coordinate]];
        [self addRectAnnotation:coordinate];
        if (self.polygonCoordinateArr.count > 2) {
            [self addBaiduPolygon];
        }
        
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
    return nil;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
        circleView.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
        return circleView;
    } else if ([overlay isKindOfClass:[BMKPolygon class]]){
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
        polygonView.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
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
