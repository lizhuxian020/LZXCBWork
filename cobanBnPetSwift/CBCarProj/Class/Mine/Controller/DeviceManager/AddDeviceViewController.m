//
//  AddDeviceViewController.m
//  Telematics
//
//  Created by lym on 2017/11/9.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "AddDeviceViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MyDeviceDetailViewController.h"
#import "MyDeviceModel.h"
#import "cobanBnPetSwift-Swift.h"

@interface AddDeviceViewController ()<AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate>
/** 设备 */
@property (nonatomic, strong) AVCaptureDevice * device;
/** 输入输出的中间桥梁 */
@property (nonatomic, strong) AVCaptureSession * session;
/** 相机图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;
/** 扫描支持的编码格式的数组 */
// 扫描线
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) NSMutableArray * metadataObjectTypes;
@property (nonatomic,strong) AVCaptureSession * captureSession;
@property (nonatomic,strong) AVCaptureDevice * captureDevice;

// 输入框
@property (nonatomic,strong) UIView *deviceInputView;
@property (nonatomic, strong) UITextField *deviceTextField;
@property (nonatomic, copy) NSString *scanContentStr ;
@end

@implementation AddDeviceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开始捕获
    [self.session startRunning];
    /* 添加动画 */
    self.line.frame = CGRectMake(27.5 * KFitWidthRate, 0, 180 * KFitHeightRate, 2 * KFitHeightRate);
    [UIView animateWithDuration: 2.0 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        
        self.line.frame = CGRectMake(27.5 * KFitWidthRate, 224 * KFitHeightRate, 180 * KFitHeightRate, 2 * KFitHeightRate);
        
    } completion:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:self.view.window];
    //键盘隐藏的通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
    
    [AppDelegate setNavigationBGColor:nil :self.navigationController.navigationBar];
}

//键盘弹起后处理scrollView的高度使得textfield可见
-(void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary * info = [notification userInfo];
    NSValue *avalue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[avalue CGRectValue] fromView:nil];
    [UIView animateWithDuration: 0.3 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y = SCREEN_HEIGHT - CGRectGetMaxY(self.deviceTextField.superview.frame) - keyboardRect.size.height;
        self.view.frame = rect;
    }];
}


//键盘隐藏后处理scrollview的高度，使其还原为本来的高度
-(void)keyboardWillHide:(NSNotification *)notification{
    //    NSDictionary *info = [notification userInfo];
    //    NSValue *avalue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGRect keyboardRect = [self.view convertRect:[avalue CGRectValue] fromView:nil];
    [UIView animateWithDuration: 0.3 animations:^{
        self.view.frame = self.view.bounds;
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //停止捕获
    [self.session stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self capture];
    [self initFontView];
    [self addGesture];
}
/*
 *  初始化UI
 */
- (void)initFontView {
    [self initBarWithTitle:Localized(@"添加设备") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"手动添加") target: self action: @selector(rightBtnClick)];
    // 设置中间的二维码框
    UIImage *qrImage = [UIImage imageNamed:@"扫一扫框"];
    UIImageView *qrImageView = [[UIImageView alloc] initWithImage: qrImage];
    [self.view addSubview: qrImageView];
    [qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(100 * KFitHeightRate + kStautsRectHeight + 44);
        //make.centerY.mas_equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(235*KFitHeightRate, 235*KFitHeightRate));
        make.centerX.equalTo(self.view);
    }];
    // 设置上下左右的阴影部分
    UIColor *backColor = [[UIColor blackColor] colorWithAlphaComponent: 0.3];
    UIView *topView =  [[UIView alloc] init];
    topView.backgroundColor = backColor;
    [self.view addSubview: topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(qrImageView.mas_top);
    }];
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = backColor;
    [self.view addSubview: leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(self.view);
        make.bottom.equalTo(qrImageView);
        make.right.equalTo(qrImageView.mas_left);
    }];
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = backColor;
    [self.view addSubview: rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(qrImageView);
        make.left.equalTo(qrImageView.mas_right);
    }];
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = backColor;
    [self.view addSubview: bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrImageView.mas_bottom);
        make.right.left.bottom.equalTo(self.view);
    }];
    
    // 扫描线
    self.line = [[UIImageView alloc] initWithFrame: CGRectMake(27.5 * KFitWidthRate, 0, 180 * KFitHeightRate, 2 * KFitHeightRate)];
    self.line.image = [UIImage imageNamed:@"扫一扫-横线"];
    [qrImageView addSubview:self.line];
    
    _deviceInputView = [[UIView alloc] init];
//    _deviceInputView.layer.cornerRadius = 5 * KFitWidthRate;
    _deviceInputView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:_deviceInputView];
    [_deviceInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(qrImageView.mas_bottom).with.offset(35 * KFitHeightRate);
        make.size.mas_equalTo(CGSizeMake(260 * KFitWidthRate,  40 * KFitHeightRate));
    }];
    _deviceTextField = [MINUtils createTextFieldWithHoldText:Localized(@"输入设备编号添加") fontSize: 13 * KFitWidthRate];
    _deviceTextField.textAlignment = NSTextAlignmentCenter;
    [_deviceInputView addSubview: _deviceTextField];
    [_deviceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_deviceInputView);
        make.size.mas_equalTo(CGSizeMake(200 * KFitWidthRate,  30 * KFitHeightRate));
    }];
    _deviceTextField.text = Localized(@"请对准设备的二维码");
    _deviceTextField.userInteractionEnabled = NO;
    _deviceTextField.textColor = KCarLineColor;
}

#pragma mark - action
- (void)rightBtnClick
{
    MyDeviceDetailViewController *MyDeviceDetailVC = [[MyDeviceDetailViewController alloc] init];
    MyDeviceDetailVC.model = [[MyDeviceModel alloc]init];
    MyDeviceDetailVC.groupNameArray = self.groupNameArray;
    MyDeviceDetailVC.groupIdArray = self.groupIdArray;
    MyDeviceDetailVC.isAddDevice = YES;
    MyDeviceDetailVC.isBind = YES;
    [self.navigationController pushViewController: MyDeviceDetailVC animated:YES];
//    if (self.deviceTextField.text.length <= 0) {
//        [MINUtils showProgressHudToView: self.view withText:Localized(@"请输入设备编号")];
//        return;
//    }
//    [self.deviceTextField resignFirstResponder];
//    [self checkDeviceReqeust:self.deviceTextField.text];
}
#pragma mark -- 校验设备编号合法性
- (void)checkDeviceReqeust:(NSString *)dno {
    // 校验设备编号合法性
    // personController/imeiValidation
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:dno forKey:@"imei"];
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl:@"personController/imeiValidation" params:paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        if (isSucceed) {
            [self requestDeviceMessageWithDno:dno];
        } else {
            [HUD showHUDWithText:Localized(@"设备号错误") withDelay:1.5];
        }
    } failed:^(NSError *error) {
    }];
}
#pragma mark -- 获取设备编号信息
- (void)requestDeviceMessageWithDno:(NSString *)dno {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = dno;
    //MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"personController/getDevDetail" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            MyDeviceModel *model = [MyDeviceModel yy_modelWithDictionary: response[@"data"]];
            if (!model) {
                model = [[MyDeviceModel alloc]init];
            }
            MyDeviceDetailViewController *MyDeviceDetailVC = [[MyDeviceDetailViewController alloc] init];
            model.dno = dno?:@"";
            MyDeviceDetailVC.model = model;
            MyDeviceDetailVC.groupNameArray = self.groupNameArray;
            MyDeviceDetailVC.groupIdArray = self.groupIdArray;
            MyDeviceDetailVC.isAddDevice = YES;
            MyDeviceDetailVC.isBind = YES;
            [self.navigationController pushViewController: MyDeviceDetailVC animated:YES];
        } else {
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - gesture
- (void)addGesture
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.deviceTextField resignFirstResponder];
}
/**
 *  扫描初始化
 */
- (void)capture{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        //        [HUD showHUDWithText:@"请在设置中开启相机权限"];
        NSLog(@"请在设置中开启相机权限");
        return;
    }
    
    //获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!self.device) {
        //        [HUD showHUDWithText:@"请在设置中开启相机权限"];
        NSLog(@"请在设置中开启相机权限");
        return;
    }
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //设置代理 在主线程里刷新
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    if ([self.session canAddOutput:metadataOutput]) {
        [self.session addOutput:metadataOutput];
    }
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, PPNavigationBarHeight, SCREEN_HEIGHT, SCREEN_HEIGHT - PPNavigationBarHeight);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    //设置扫描支持的编码格式(如下设置条形码和二维码兼容)
    metadataOutput.metadataObjectTypes = self.metadataObjectTypes;
    //优化扫描区域
    //设置扫描范围区域 CGRectMake（y的起点/屏幕的高，x的起点/屏幕的宽，扫描的区域的高/屏幕的高，扫描的区域的宽/屏幕的宽）
//    CGFloat x,y,width,height;
//    x = (100*KFitHeightRate + kStautsRectHeight + 44)/SCREEN_HEIGHT;
//    y = ((SCREEN_WIDTH - 235*KFitHeightRate)/2)/SCREEN_WIDTH;
//    width = 235*KFitHeightRate/SCREEN_HEIGHT;
//    height = 235*KFitHeightRate/SCREEN_WIDTH;
//    CGRect rect = CGRectMake(x, y, width, height);
//    metadataOutput.rectOfInterest = rect;// 扫描框居中的话，不用设置rectOfInterest，rectOfInterest默认局中
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
        fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects.firstObject;
        NSLog(@"%@", metadataObject.stringValue);
        self.scanContentStr = metadataObject.stringValue;
        [self checkDeviceReqeust:metadataObject.stringValue];
    }
}

#pragma mark - setter & getter
- (NSMutableArray *)metadataObjectTypes {
    if (!_metadataObjectTypes) {
        ////设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        _metadataObjectTypes = [NSMutableArray arrayWithObjects:
                                AVMetadataObjectTypeQRCode,
                                AVMetadataObjectTypeAztecCode,
                                AVMetadataObjectTypeCode128Code,
                                AVMetadataObjectTypeCode39Code,
                                AVMetadataObjectTypeCode39Mod43Code,
                                AVMetadataObjectTypeCode93Code,
                                AVMetadataObjectTypeEAN13Code,
                                AVMetadataObjectTypeEAN8Code,
                                AVMetadataObjectTypePDF417Code,
                                AVMetadataObjectTypeUPCECode, nil];
        // >= iOS 8
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            [_metadataObjectTypes addObjectsFromArray:@[AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode]];
        }
    }
    return _metadataObjectTypes;
}

-(AVCaptureSession *)captureSesion
{
    if(_captureSession == nil)
    {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}

-(AVCaptureDevice *)captureDevice
{
    if(_captureDevice == nil)
    {
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _captureDevice;
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
