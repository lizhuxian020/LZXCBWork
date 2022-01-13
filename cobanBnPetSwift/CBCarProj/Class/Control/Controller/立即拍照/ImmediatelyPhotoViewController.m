//
//  ImmediatelyPhotoViewController.m
//  Telematics
//
//  Created by lym on 2017/12/4.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "ImmediatelyPhotoViewController.h"
#import "MINPickerView.h"
#import "ImmediatelyPhotoModel.h"

@interface ImmediatelyPhotoViewController () <MINPickerViewDelegate>
{
    BOOL keyboardIsShown;
    UIView *channelIDView;
    UIView *photoSpaceView;
    UIView *videoTimeView;
    UIView *saveSignView;
    UIView *resolutionView;
    UIView *photoQualityView;
    UIView *brightnessView;
    UIView *contrastView;
    UIView *saturationView; // 饱和度
    UIView *chromaView; // 色度
    MINPickerView *channelPickerView;
    MINPickerView *resolutionPickerView;
}
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *channaelBtn;
@property (nonatomic, strong) UITextField *photoSpaceTextField;
@property (nonatomic, strong) UITextField *photoCountTextField;
@property (nonatomic, strong) UITextField *videoTimeTextField;
@property (nonatomic, strong) UIButton *uploadSelectBtn;
@property (nonatomic, strong) UIButton *saveSelectBtn;
@property (nonatomic, strong) UIButton *resolutionBtn;
@property (nonatomic, strong) UISlider *photoQualitySlide;
@property (nonatomic, strong) UISlider *brightnessSlide;
@property (nonatomic, strong) UISlider *contrastSlide;
@property (nonatomic, strong) UISlider *saturationSlide;
@property (nonatomic, strong) UISlider *chromaSlide;
@property (nonatomic, copy) NSArray *channelArr;
@property (nonatomic, copy) NSArray *resolutionArr;
@property (nonatomic, strong) ImmediatelyPhotoModel *photoModel;
@end

@implementation ImmediatelyPhotoViewController

-(void) viewWillAppear:(BOOL)animated{
    //键盘弹起的通知
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
}

//键盘弹起后处理scrollView的高度使得textfield可见
-(void)keyboardWillShow:(NSNotification *)notification{
    if (keyboardIsShown) {
        return;
    }
    NSDictionary * info = [notification userInfo];
    NSValue *avalue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[avalue CGRectValue] fromView:nil];
    [UIView animateWithDuration: 0.3 animations:^{
        [self.scrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).with.offset(-keyboardRect.size.height - 10 * KFitHeightRate);
        }];
        [self.scrollerView.superview layoutIfNeeded];
    }];
    keyboardIsShown = YES;
}


//键盘隐藏后处理scrollview的高度，使其还原为本来的高度
-(void)keyboardWillHide:(NSNotification *)notification{
    //    NSDictionary *info = [notification userInfo];
    //    NSValue *avalue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGRect keyboardRect = [self.view convertRect:[avalue CGRectValue] fromView:nil];
    [UIView animateWithDuration: 0.3 animations:^{
        [self.scrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).with.offset(0);
        }];
        [self.scrollerView.superview layoutIfNeeded];
    }];
    keyboardIsShown = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self addAction];
    [self addGesture];
    self.channelArr = @[@[@"1", @"2", @"3", @"4", @"5"]];
    self.resolutionArr = @[@[@"320*240", @"640*480", @"800*600", @"1024*768", @"176*144[Qcif]", @"352*288[Cif]", @"704*288[HALF D1]", @"704*576[D1]"]];
    [self requestData];
}
#pragma mark -- 获取拍照返回数据
- (void)requestData
{
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [[NetWorkingManager shared]getWithUrl:@"devControlController/getPhotoParamList" params: dic succeed:^(id response,BOOL isSucceed) {
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                ImmediatelyPhotoModel *model = [ImmediatelyPhotoModel yy_modelWithJSON: response[@"data"]];
                weakSelf.photoModel = model;
                if (model.channelId <= 5 && model.channelId > 0) {
                    [weakSelf.channaelBtn setTitle: weakSelf.channelArr[0][model.channelId - 1] forState: UIControlStateNormal];
                    [weakSelf.channaelBtn setTitle: weakSelf.channelArr[0][model.channelId - 1] forState: UIControlStateHighlighted];
                }
                weakSelf.photoSpaceTextField.text = model.pzSpec;
                weakSelf.photoCountTextField.text = model.pzCount;
                weakSelf.videoTimeTextField.text = model.lxTime;
                if (model.flag == 0) {
                    [weakSelf selectBtnClick: weakSelf.uploadSelectBtn];
                }else {
                    [weakSelf selectBtnClick: weakSelf.saveSelectBtn];
                }
                [weakSelf.resolutionBtn setTitle: weakSelf.resolutionArr[0][model.resolve] forState: UIControlStateNormal];
                [weakSelf.resolutionBtn setTitle: weakSelf.resolutionArr[0][model.resolve] forState: UIControlStateHighlighted];
                weakSelf.photoQualitySlide.value = model.quality;//8 - model.quality;
                weakSelf.brightnessSlide.value = model.luminance;
                weakSelf.contrastSlide.value = model.contrast;
                weakSelf.saturationSlide.value = model.saturation;
                weakSelf.chromaSlide.value = model.chroma;
                [hud hideAnimated:YES];
            }else {
                [hud hideAnimated:YES];
            }
        }else {
            [hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

#pragma mark - addGesture
- (void)addGesture
{
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

#pragma mark - addAction
- (void)addAction
{
    [self.uploadSelectBtn addTarget: self  action: @selector(selectBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.saveSelectBtn addTarget: self  action: @selector(selectBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.channaelBtn addTarget: self  action: @selector(channaelBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.resolutionBtn addTarget: self  action: @selector(resolutionBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)channaelBtnClick
{
    channelPickerView = [[MINPickerView alloc] init];
    channelPickerView.titleLabel.text = @"";
    channelPickerView.dataArr = self.channelArr;
    channelPickerView.delegate = self;
    [self.view addSubview: channelPickerView];
    [channelPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    [channelPickerView showView];
}

- (void)resolutionBtnClick
{
    resolutionPickerView = [[MINPickerView alloc] init];
    resolutionPickerView.titleLabel.text = @"";
    resolutionPickerView.dataArr = self.resolutionArr;
    resolutionPickerView.delegate = self;
    [self.view addSubview: resolutionPickerView];
    [resolutionPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    [resolutionPickerView showView];
}

- (void)selectBtnClick:(UIButton *)button
{
    if (button == self.uploadSelectBtn) {
        self.photoModel.flag = 0;
        self.uploadSelectBtn.selected = YES;
        self.saveSelectBtn.selected = NO;
    }else {
        self.photoModel.flag = 1;
        self.uploadSelectBtn.selected = NO;
        self.saveSelectBtn.selected = YES;
    }
}

//- (void)saveSelectBtnClick
//{
//    if (self.saveSelectBtn.selected == YES) {
//        self.saveSelectBtn.selected = NO;
//    }else {
//        self.saveSelectBtn.selected = YES;
//    }
//}

#pragma mark - Action
- (void)rightBtnClick
{
    if (self.photoSpaceTextField.text.length < 1) {
        [HUD showHUDWithText: @"请输入拍照间隔时间(秒)" withDelay:1.2];
        return;
    }
    if (self.photoCountTextField.text.length < 1) {
        [HUD showHUDWithText: @"请输入拍照次数" withDelay:1.2];
        return;
    }
    if (self.videoTimeTextField.text.length < 1) {
        [HUD showHUDWithText: @"请输入时间(秒)" withDelay:1.2];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    dic[@"channel_id"] = self.channaelBtn.titleLabel.text;
    dic[@"pz_spec"] = self.photoSpaceTextField.text;
    dic[@"pz_count"] = self.photoCountTextField.text;
    dic[@"lx_time"] = self.videoTimeTextField.text;
    dic[@"flag"] = [NSString stringWithFormat: @"%d", self.photoModel.flag];
    dic[@"resolve"] = [NSString stringWithFormat: @"%d", self.photoModel.resolve];
    //dic[@"quality"] = [NSString stringWithFormat: @"%d", (int)(8 - self.photoQualitySlide.value)];
    dic[@"quality"] = [NSString stringWithFormat: @"%.f", self.photoQualitySlide.value];
    dic[@"luminance"] = [NSString stringWithFormat: @"%d", (int)self.brightnessSlide.value];
    dic[@"saturation"] = [NSString stringWithFormat: @"%d", (int)self.saturationSlide.value];
    dic[@"contrast"] = [NSString stringWithFormat: @"%d", (int)self.contrastSlide.value];
    dic[@"chroma"] = [NSString stringWithFormat: @"%d", (int)self.chromaSlide.value];
    MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
    [[NetWorkingManager shared]postWithUrl:@"devControlController/editPhotoPara" params: dic succeed:^(id response,BOOL isSucceed) {
        if (isSucceed) {
            [hud hideAnimated:YES];
            [weakSelf.navigationController popViewControllerAnimated: YES];
        }else {
            [hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

- (void)slideValueChangeed:(UISlider *)slide
{
    NSLog(@"slide value %f", slide.value);
    if (slide == self.photoQualitySlide) {
//        NSArray *numbers = @[@0, @1, @2, @3, @4, @5, @6, @7];
//        NSUInteger index = (NSUInteger)(slide.value + 0.5);
//        [slide setValue:index animated: YES];
//        NSNumber *number = numbers[index]; // <-- This numeric value you want
//        NSLog(@"sliderIndex: %i", (int)index);
//        NSLog(@"number: %@", number);
        
        [slide setValue:slide.value animated: YES];
        NSLog(@"number: %.f", slide.value);
    }
}

#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self initBarWithTitle:Localized(@"拍照") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"确定") target: self action: @selector(rightBtnClick)];
    [self createScrollView];
    // 通道
    channelIDView = [self createViewWithTitle:Localized(@"通道ID")];
    [self.contentView addSubview: channelIDView];
    [channelIDView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(self.contentView).with.offset(12.5 * KFitHeightRate);
        make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    self.channaelBtn = [MINUtils createBorderBtnWithArrowImageWithTitle: @"1"];
    [channelIDView addSubview: self.channaelBtn];
    [self.channaelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(channelIDView).with.offset(-12.5 * KFitWidthRate);
        make.centerY.equalTo(channelIDView);
        make.size.mas_equalTo(CGSizeMake(80 * KFitWidthRate, 30 * KFitHeightRate));
    }];
    // 拍照间隔
    photoSpaceView = [self createViewWithTitle:Localized(@"拍照间隔")];
    [self.contentView addSubview: photoSpaceView];
    [photoSpaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(channelIDView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    self.photoSpaceTextField = [MINUtils createBorderTextFieldWithHoldText:Localized(@"秒") fontSize: 12 * KFitHeightRate];
    self.photoSpaceTextField.textAlignment = NSTextAlignmentCenter;
    self.photoSpaceTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.photoSpaceTextField.leftView = nil;
    [photoSpaceView addSubview: self.photoSpaceTextField];
    [self.photoSpaceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(photoSpaceView).with.offset(97.5 * KFitWidthRate);
        make.centerY.equalTo(photoSpaceView);
        make.size.mas_equalTo(CGSizeMake(80 * KFitWidthRate, 30 * KFitHeightRate));
    }];
    UILabel *photoCountLabel = [MINUtils createLabelWithText:Localized(@"拍照次数") size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(73, 73, 73)];
    //photoCountLabel.backgroundColor = [UIColor redColor];
    [photoSpaceView addSubview: photoCountLabel];
    [photoCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photoSpaceTextField.mas_right).with.offset(20 * KFitWidthRate);
        make.top.bottom.equalTo(photoSpaceView);
        make.width.mas_equalTo(85 * KFitWidthRate);
    }];
    
    self.photoCountTextField =  [MINUtils createBorderTextFieldWithHoldText:Localized(@"张") fontSize: 12 * KFitHeightRate];
    self.photoCountTextField.textAlignment = NSTextAlignmentCenter;
    self.photoCountTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.photoCountTextField.leftView = nil;
    [photoSpaceView addSubview: self.photoCountTextField];
    [self.photoCountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(photoCountLabel.mas_right).with.offset(0 * KFitWidthRate);
        make.centerY.equalTo(photoSpaceView);
        make.right.mas_equalTo(photoSpaceView.mas_right).offset(-12.5*KFitWidthRate);
        //make.size.mas_equalTo(CGSizeMake(80 * KFitWidthRate, 30 * KFitHeightRate));
        make.height.mas_equalTo(30*KFitHeightRate);
    }];
    // 录像时间
    videoTimeView = [self createViewWithTitle:Localized(@"录像时间")];
    [self.contentView addSubview: videoTimeView];
    [videoTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(photoSpaceView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    self.videoTimeTextField = [MINUtils createBorderTextFieldWithHoldText:Localized(@"秒 (0表示一直录音)") fontSize: 12 * KFitHeightRate];
    self.videoTimeTextField.textAlignment = NSTextAlignmentCenter;
    self.videoTimeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.videoTimeTextField.leftView = nil;
    [videoTimeView addSubview: self.videoTimeTextField];
    [self.videoTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(videoTimeView).with.offset(97.5 * KFitWidthRate);
        make.right.equalTo(videoTimeView).with.offset(-12.5 * KFitWidthRate);
        make.centerY.equalTo(videoTimeView);
        make.height.mas_equalTo( 30 * KFitHeightRate);
    }];
    // 保存标志
    saveSignView = [self createViewWithTitle:Localized(@"保存标志")];
    [self.contentView addSubview: saveSignView];
    [saveSignView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(videoTimeView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    self.uploadSelectBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"实时上传") titleColor: k137Color fontSize: 12 * KFitHeightRate backgroundColor: nil];
    self.uploadSelectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10 * KFitWidthRate);
    self.uploadSelectBtn.selected = YES;
    self.uploadSelectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10 * KFitWidthRate, 0, 0);
    [self.uploadSelectBtn setImage: [UIImage imageNamed: @"单选-没选中"] forState: UIControlStateNormal];
    [self.uploadSelectBtn setImage: [UIImage imageNamed: @"单选-选中"] forState: UIControlStateSelected];
    [saveSignView addSubview: self.uploadSelectBtn];
    [self.uploadSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(saveSignView).with.offset(97.5 * KFitWidthRate);
        make.top.bottom.equalTo(saveSignView);
        make.width.mas_equalTo(120 * KFitWidthRate);
    }];
    self.saveSelectBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"保存") titleColor: k137Color fontSize: 12 * KFitHeightRate backgroundColor: nil];
    self.saveSelectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10 * KFitWidthRate);
    self.saveSelectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10 * KFitWidthRate, 0, 0);
    [self.saveSelectBtn setImage: [UIImage imageNamed: @"单选-没选中"] forState: UIControlStateNormal];
    [self.saveSelectBtn setImage: [UIImage imageNamed: @"单选-选中"] forState: UIControlStateSelected];
    [saveSignView addSubview: self.saveSelectBtn];
    [self.saveSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uploadSelectBtn.mas_right).with.offset(0 * KFitWidthRate);
        make.top.bottom.equalTo(saveSignView);
        make.width.mas_equalTo(100 * KFitWidthRate);
    }];
    // 分辨率
    resolutionView = [self createViewWithTitle:Localized(@"分辨率")];
    [self.contentView addSubview: resolutionView];
    [resolutionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(saveSignView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    self.resolutionBtn = [MINUtils createBorderBtnWithArrowImageWithTitle: @"320 X 240"];
    [resolutionView addSubview: self.resolutionBtn];
    [self.resolutionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(resolutionView);
        make.centerY.equalTo(resolutionView);
        make.size.mas_equalTo(30 * KFitHeightRate);
        make.left.equalTo(resolutionView).with.offset(97.5 * KFitWidthRate);
    }];
    // 图像质量
    photoQualityView = [self createViewWithTitle:Localized(@"图像质量")];
    [self.contentView addSubview: photoQualityView];
    [photoQualityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(resolutionView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(75 * KFitHeightRate);
    }];
//    UILabel *lowLabel = [MINUtils createLabelWithText:Localized(@"低") size: 10 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: k137Color];
//    [photoQualityView addSubview: lowLabel];
//    [lowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(photoQualityView);
//        make.left.equalTo(photoQualityView).with.offset(97.5 * KFitWidthRate);
//        make.width.mas_equalTo(35 * KFitWidthRate);
//        make.height.mas_equalTo(30 * KFitHeightRate);
//    }];
//    UILabel *hightLabel = [MINUtils createLabelWithText:Localized(@"高") size: 10 * KFitHeightRate alignment: NSTextAlignmentRight textColor: k137Color];
//    [photoQualityView addSubview: hightLabel];
//    [hightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(photoQualityView);
//        make.right.equalTo(photoQualityView).with.offset(-20 * KFitWidthRate);
//        make.width.mas_equalTo(35 * KFitWidthRate);
//        make.height.mas_equalTo(30 * KFitHeightRate);
//    }];
    
    NSArray *arrayQualityStr = @[@"差",@"较差",@"一般",@"良",@"良好",@"标清",@"高清",@"超清"];
    CGFloat point_x = (SCREEN_WIDTH - 12.5*KFitWidthRate*2 - 117.5*KFitWidthRate)/(arrayQualityStr.count - 1);
    for (int i = 0 ; i < arrayQualityStr.count ; i ++ ) {
        UILabel *label = [MINUtils createLabelWithText:Localized(arrayQualityStr[i]) size: 10 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: k137Color];
        [photoQualityView addSubview: label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(photoQualityView.mas_top);
            make.centerX.mas_equalTo(-(SCREEN_WIDTH-12.5*KFitWidthRate*2)/2 + 97.5*KFitWidthRate + i*point_x);
            make.height.mas_equalTo(30*KFitHeightRate);
        }];
    }
    
    UIImageView *qualityImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"尺寸"]];
    [photoQualityView addSubview: qualityImageView];
    [qualityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(photoQualityView);
        make.left.equalTo(photoQualityView).with.offset(97.5 * KFitWidthRate);
        make.right.equalTo(photoQualityView).with.offset(-20 * KFitWidthRate);
        make.height.mas_equalTo(10 * KFitHeightRate);
    }];
    self.photoQualitySlide = [self createSliderWithSlideImage: @"播放速度按钮"];
    self.photoQualitySlide.maximumValue = 7.0;//100;//7.0;
    [self.photoQualitySlide addTarget: self action: @selector(slideValueChangeed:) forControlEvents: UIControlEventValueChanged];
    [photoQualityView addSubview: self.photoQualitySlide];
    [self.photoQualitySlide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(photoQualityView).with.offset(-15 * KFitHeightRate);
        make.left.equalTo(photoQualityView).with.offset(97.5 * KFitWidthRate);
        make.right.equalTo(photoQualityView).with.offset(-20 * KFitWidthRate);
        make.height.mas_equalTo(15 * KFitHeightRate);
    }];
    brightnessView = [self createViewWithTitle:Localized(@"亮度")];
    contrastView = [self createViewWithTitle:Localized(@"对比度")];
    saturationView = [self createViewWithTitle:Localized(@"饱和度")];
    chromaView = [self createViewWithTitle:Localized(@"色度")];
    NSArray *array = @[brightnessView, contrastView, saturationView, chromaView];
    UIView *lastView = nil;
    for (int i = 0; i < array.count; i++) {
        UIView *view = array[i];
        [self.contentView addSubview: view];
        if (lastView == nil) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
                make.top.equalTo(photoQualityView.mas_bottom).with.offset(12.5 * KFitHeightRate);
                make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
                make.height.mas_equalTo(50 * KFitHeightRate);
            }];
        }else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
                make.top.equalTo(lastView.mas_bottom).with.offset(12.5 * KFitHeightRate);
                make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
                make.height.mas_equalTo(50 * KFitHeightRate);
            }];
        }
        lastView = view;
    }
    self.brightnessSlide = [self createSliderWithSlideImage: @"播放条-按钮"];
    self.contrastSlide = [self createSliderWithSlideImage: @"播放条-按钮"];
    self.saturationSlide = [self createSliderWithSlideImage: @"播放条-按钮"];
    self.chromaSlide = [self createSliderWithSlideImage: @"播放条-按钮"];
    NSArray *slideArr = @[self.brightnessSlide, self.contrastSlide, self.saturationSlide, self.chromaSlide];
    for (int i = 0 ; i < array.count; i++) {
        UIView *view = array[i];
        UISlider *slide = slideArr[i];
        [view addSubview: slide];
        [slide mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view).with.offset(97.5 * KFitWidthRate);
            make.right.equalTo(view).with.offset(-20 * KFitWidthRate);
            make.height.mas_equalTo(15 * KFitHeightRate);
        }];
    }
    [self.scrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(chromaView.mas_bottom).with.offset(12.5 * KFitHeightRate);
    }];
}

- (UISlider *)createSliderWithSlideImage:(NSString *)slideImage
{
    //轨道图片
    UIImage *stetchLeftTrack = [UIImage imageNamed:@"滑动条-进度"];
    stetchLeftTrack =  [stetchLeftTrack resizableImageWithCapInsets: UIEdgeInsetsMake(2 * KFitHeightRate, 10 * KFitWidthRate, 2 * KFitHeightRate, 10 * KFitWidthRate)];
    UIImage *stetchRightTrack = [UIImage imageNamed:@"滑动条-底层"];
    stetchRightTrack = [stetchRightTrack resizableImageWithCapInsets: UIEdgeInsetsMake(2 * KFitHeightRate, 10 * KFitWidthRate, 2 * KFitHeightRate, 10 * KFitWidthRate)];
    //滑块图片 @"播放条-按钮"
    UIImage *thumbImage = [UIImage imageNamed: slideImage];
    UISlider *slide = [[UISlider alloc] init];
    slide.value = 0.0;
    slide.minimumValue = 0.0;
    slide.maximumValue = 100.0;
    //设置轨道的图片
    [slide setMinimumTrackImage: stetchLeftTrack forState:UIControlStateNormal];
    [slide setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    //设置滑块的图片
    [slide setThumbImage:thumbImage forState:UIControlStateNormal];
    slide.continuous = YES;
    return slide;
}

- (UIView *)createViewWithTitle:(NSString *)title
{
    UIView *view = [MINUtils createViewWithRadius: 5 * KFitWidthRate];
    UILabel *titleLabel = [MINUtils createLabelWithText: title size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(73, 73, 73)];
    //titleLabel.adjustsFontSizeToFitWidth = YES;
    [view addSubview: titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.left.equalTo(view).with.offset(12.5 * KFitWidthRate);
        make.width.mas_equalTo(85 * KFitWidthRate);
    }];
    return view;
}

- (void)createScrollView
{
    self.scrollerView = [[UIScrollView alloc] init];
    [self.view addSubview: self.scrollerView];
    [self.scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(0);
    }];
    self.contentView = [[UIView alloc] init];
    [self.scrollerView addSubview: self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(self.scrollerView).with.insets(UIEdgeInsetsZero);
        make.width.equalTo(self.scrollerView);
    }];
}

#pragma mark - MINPickerViewDelegate
- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic
{
    NSNumber *selectNum = dic[@"0"];
    if (pickerView == channelPickerView) {
        [self.channaelBtn setTitle: self.channelArr[0][[selectNum integerValue]] forState: UIControlStateNormal];
        [self.channaelBtn setTitle: self.channelArr[0][[selectNum integerValue]] forState: UIControlStateHighlighted];
    }else if (pickerView == resolutionPickerView) {
        self.photoModel.resolve = [selectNum intValue];
        [self.resolutionBtn setTitle: self.resolutionArr[0][[selectNum integerValue]] forState: UIControlStateNormal];
        [self.resolutionBtn setTitle: self.resolutionArr[0][[selectNum integerValue]] forState: UIControlStateHighlighted];
    }
}


#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
