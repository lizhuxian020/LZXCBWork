//
//  CBScanAddWatchViewController.m
//  cobanBnWatch
//
//  Created by coban on 2019/12/10.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBScanAddWatchViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CBPickRelationshipVC.h"

@interface CBScanAddWatchViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    BOOL keyboardIsShown;
}
/** 设备 */
@property (nonatomic, strong) AVCaptureDevice * device;
/** 输入输出的中间桥梁 */
@property (nonatomic, strong) AVCaptureSession * session;
/** 相机图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;
/** 扫描支持的编码格式的数组 */
@property (nonatomic, strong) UIImageView *deviceImageView;
@property (nonatomic, strong) NSMutableArray * metadataObjectTypes;
@property (nonatomic, strong) UIButton *lightBtn;
// 扫描线
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UITextField *bindNumTextField;
@property (nonatomic, strong) UIButton *confirmBtn;
@end

@implementation CBScanAddWatchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开始捕获
    [self.session startRunning];
    /* 添加动画 */
    self.line.frame = CGRectMake(0, 0, 235 * KFitWidthRate, 9 * KFitWidthRate);
    [UIView animateWithDuration: 2.0 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        self.line.frame = CGRectMake(0, 224 * KFitWidthRate, 235 * KFitWidthRate, 9 * KFitWidthRate);
    } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //停止捕获
    [self.session stopRunning];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}
- (void)setupView {
    self.view.backgroundColor = UIColor.whiteColor;
    [self initBarWithTitle:Localized(@"扫一扫") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"相册") target: self action: @selector(rightBtnClick)];
    [self capture];
    [self addGesture];
    [self initFontView];
}
/**  初始化UI */
- (void)initFontView {
    // 设置中间的二维码框
    UIImage *qrImage = [UIImage imageNamed:@"扫描框"];
    UIImageView *qrImageView = [[UIImageView alloc] initWithImage: qrImage];
    [self.view addSubview: qrImageView];
    [qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(50 * KFitWidthRate + kNavAndStatusHeight);
        make.size.mas_equalTo(CGSizeMake(235 * KFitWidthRate, 235 * KFitWidthRate));
        make.centerX.equalTo(self.view);
    }];
    // 设置上下左右的阴影部分
    UIColor *backColor = [[UIColor blackColor] colorWithAlphaComponent: 0.3];
    UIView *topView =  [[UIView alloc] init];
    topView.backgroundColor = backColor;
    [self.view addSubview: topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
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
    self.line = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 235 * KFitWidthRate, 9 * KFitWidthRate)];
    self.line.image = [UIImage imageNamed:@"扫描-横条"];
    [qrImageView addSubview:self.line];
    
    UILabel *detailLabel = [CBWtMINUtils createLabelWithText:Localized(@"将二维码对准放入框内，既可扫描") size:12 * KFitWidthRate alignment: NSTextAlignmentCenter textColor: KWtRGB(188, 188, 188)];
    [self.view addSubview: detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(qrImageView.mas_bottom).with.offset(35 * KFitHeightRate);
        make.height.mas_equalTo(20 * KFitWidthRate);
    }];
    NSString *holdText = Localized(@"输入绑定号");
    self.bindNumTextField = [CBWtMINUtils createTextFieldWithHoldText: holdText fontSize: 12 * KFitWidthRate];
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString: holdText];
    [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize: 12 * KFitWidthRate] range:NSMakeRange(0, holdText.length)];
    [placeholder addAttribute:NSForegroundColorAttributeName value: [UIColor whiteColor] range:NSMakeRange(0, holdText.length)];
    //    NSMutableParagraphStyle *centerStyle = [textField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    //    centerStyle.minimumLineHeight = textField.font.lineHeight - (textField.font.lineHeight - [UIFont systemFontOfSize:12.0].lineHeight) / 2.0;
    //    [placeholder addAttribute:NSParagraphStyleAttributeName value:centerStyle range:NSMakeRange(0, holdText.length)];
    self.bindNumTextField.attributedPlaceholder = placeholder;
    self.bindNumTextField.textColor = [UIColor whiteColor];
    self.bindNumTextField.backgroundColor = KWtLineColor;
    self.bindNumTextField.layer.cornerRadius = 4 * KFitWidthRate;
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"标识类_条形码"]];
    leftImageView.contentMode = UIViewContentModeCenter;
    leftImageView.frame = CGRectMake(0, 0, 45 * KFitWidthRate, 40 * KFitWidthRate);
    self.bindNumTextField.leftView = leftImageView;
    self.bindNumTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview: self.bindNumTextField];
    [self.bindNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(detailLabel.mas_bottom).with.offset(40 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(190 * KFitWidthRate, 40 * KFitWidthRate));
    }];
    self.confirmBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"确定") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: KWtBlueColor Radius: 20 * KFitWidthRate];
    [self.view addSubview: self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.bindNumTextField.mas_bottom).with.offset(40 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(190 * KFitWidthRate, 40 * KFitWidthRate));
    }];
    [self.confirmBtn addTarget: self action: @selector(confirmBtnClick) forControlEvents: UIControlEventTouchUpInside];
}
#pragma mark -- 绑定手表
- (void)confirmBtnClick {
    if (self.bindNumTextField.text.length <= 0 ) {
        [CBWtMINUtils showProgressHudToView: self.view withText: @"请输入你要绑定的设备编号"];
        return;
    }
    [self checkSnoRequest];
}
#pragma mark -- 扫码校验
- (void)checkSnoRequest {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:self.bindNumTextField.text forKey:@"sno"];
    [[CBWtNetworkRequestManager sharedInstance] checkWatchSnoParamters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        if (baseModel.status == CBWtNetworkingStatus0) {
            NSString *hasAdmin = [NSString stringWithFormat:@"%@",baseModel.data[@"hasAdmin"]];
            NSLog(@"是否绑定过%@",hasAdmin);//0：代表手表没绑定过没有管理员    2：已绑定 
            if ([hasAdmin isEqualToString:@"0"]) {
                [self toSettingRelation:NO];
            } else if ([hasAdmin isEqualToString:@"2"]) {
                [self toSettingRelation:YES];
            }
        } else {
            [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"验证失败")];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark -- 验证手表信息后 去填写信息
- (void)toSettingRelation:(BOOL)hasAdmin {
    CBPickRelationshipVC *vc = [[CBPickRelationshipVC alloc]init];
    vc.hasAdmin = hasAdmin;
    vc.sno = self.bindNumTextField.text;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)rightBtnClick {
    //初始化UIImagePickerController
    UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
    //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
    //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
    //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
    PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //允许编辑，即放大裁剪
    PickerImage.allowsEditing = YES;
    //自代理
    PickerImage.delegate = self;
    //页面跳转
    [self presentViewController:PickerImage animated:YES completion:nil];
}
#pragma mark - addGesture
- (void)addGesture {
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}
- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}
/**
 *  扫描初始化
 */
- (void)capture {
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
    self.previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    //设置扫描支持的编码格式(如下设置条形码和二维码兼容)
    metadataOutput.metadataObjectTypes = self.metadataObjectTypes;
    //    CGRect size = CGRectMake((SCREEN_WIDTH - 235) / 2.0 * KFitWidthRate / SCREEN_WIDTH, (100.0 * KFitHeightRate + 64) / SCREEN_HEIGHT, (235 * KFitHeightRate) / SCREEN_WIDTH, (235 * KFitHeightRate) / SCREEN_HEIGHT);
    //    CGRect size1 = [_previewLayer metadataOutputRectOfInterestForRect:CGRectMake((SCREEN_WIDTH - 235)/2 * KFitWidthRate , 50 * KFitHeightRate + 64, 300 * KFitWidthRate, 300 * KFitHeightRate)];
    CGRect size1 = CGRectMake( (50 * KFitWidthRate + kNavAndStatusHeight) / SCREEN_HEIGHT,  ((SCREEN_WIDTH - 235)/2 * KFitWidthRate) / SCREEN_WIDTH, (250 * KFitWidthRate) / SCREEN_HEIGHT, (250 * KFitWidthRate) / SCREEN_WIDTH);
    metadataOutput.rectOfInterest = size1;
    
}

- (NSMutableArray *)metadataObjectTypes{
    if (!_metadataObjectTypes) {
        _metadataObjectTypes = [NSMutableArray arrayWithObjects:AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode, nil];
        // >= iOS 8
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            [_metadataObjectTypes addObjectsFromArray:@[AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode]];
        }
    }
    return _metadataObjectTypes;
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects.firstObject;
        NSLog(@"%@", metadataObject.stringValue);
        self.bindNumTextField.text = metadataObject.stringValue?:@"";
        [self confirmBtnClick];
    }
}
#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context: nil options: @{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSData *imageData = UIImagePNGRepresentation(newPhoto);
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    NSArray *features = [detector featuresInImage:ciImage];
    
    if (features.count <= 0) {
        //照片中 没有识别到w二维码信息
        [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"没有识别到二维码信息")];
        
    } else {
        CIQRCodeFeature*feature = [features objectAtIndex:0];
        
        NSString*scannedResult = feature.messageString;
        
        NSLog(@"%@", scannedResult);
        
        self.bindNumTextField.text = scannedResult?:@"";
        [self confirmBtnClick];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
