//
//  MultiplePhotoViewController.m
//  Telematics
//
//  Created by lym on 2017/12/4.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MultiplePhotoViewController.h"
#import "MINPickerView.h"
#import "MultiplePhotoModel.h"

@interface MultiplePhotoViewController ()<MINPickerViewDelegate>
{
    BOOL keyboardIsShown;
    UIView *photoQualityView;
    UIView *brightnessView;
    UIView *contrastView;
    UIView *saturationView; // 饱和度
    UIView *chromaView; // 色度
    UIView *timingPhotoView; // 定时拍照
    UIView *channelView1;
    UIView *channelView2;
    UIView *channelView3;
    UIView *channelView4;
    UIView *channelView5;
    MINPickerView *channelLeftPickerView;
    MINPickerView *channelRightPickerView;
}
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UISlider *photoQualitySlide;
@property (nonatomic, strong) UISlider *brightnessSlide;
@property (nonatomic, strong) UISlider *contrastSlide;
@property (nonatomic, strong) UISlider *saturationSlide;
@property (nonatomic, strong) UISlider *chromaSlide;
@property (nonatomic, strong) UIButton *timingSelectBtn;
@property (nonatomic, strong) UIButton *distanceSelectBtn;
@property (nonatomic, strong) UITextField *timingTextField;
@property (nonatomic, strong) UITextField *distanceTextField;
@property (nonatomic, strong) UIButton *channelLeftBtn1;
@property (nonatomic, strong) UIButton *channelRightBtn1;
@property (nonatomic, strong) UIButton *channelLeftBtn2;
@property (nonatomic, strong) UIButton *channelRightBtn2;
@property (nonatomic, strong) UIButton *channelLeftBtn3;
@property (nonatomic, strong) UIButton *channelRightBtn3;
@property (nonatomic, strong) UIButton *channelLeftBtn4;
@property (nonatomic, strong) UIButton *channelRightBtn4;
@property (nonatomic, strong) UIButton *channelLeftBtn5;
@property (nonatomic, strong) UIButton *channelRightBtn5;
@property (nonatomic, strong) UIButton *loadBtn;
@property (nonatomic, strong) UIButton *setBtn;
@property (nonatomic, weak) UIButton *currenSelectBtn;
@property (nonatomic, copy) NSArray *channelLeftArr;
@property (nonatomic, copy) NSArray *channelRightArr;
@property (nonatomic, strong) MultiplePhotoModel *photoModel;

@property (nonatomic, assign) BOOL isLoadData;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation MultiplePhotoViewController
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
    
    self.channelLeftArr = @[@[Localized(@"开"), Localized(@"关")]];
    self.channelRightArr = @[@[Localized(@"存储"), Localized(@"上传")]];
    [self createUI];
    [self addAction];
    [self addGesture];
    
    [self canEdit:NO];
}

#pragma mark - addGesture
- (void)addGesture
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.timingTextField resignFirstResponder];
    [self.distanceTextField resignFirstResponder];
}

#pragma mark - addAction
- (void)addAction
{
    [self.timingSelectBtn addTarget: self action: @selector(timingSelectBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.distanceSelectBtn addTarget: self action: @selector(distanceSelectBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.channelLeftBtn1 addTarget: self action: @selector(channelLeftBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.channelLeftBtn2 addTarget: self action: @selector(channelLeftBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.channelLeftBtn3 addTarget: self action: @selector(channelLeftBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.channelLeftBtn4 addTarget: self action: @selector(channelLeftBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.channelLeftBtn5 addTarget: self action: @selector(channelLeftBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.channelRightBtn1 addTarget: self action: @selector(channelRightBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.channelRightBtn2 addTarget: self action: @selector(channelRightBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.channelRightBtn3 addTarget: self action: @selector(channelRightBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.channelRightBtn4 addTarget: self action: @selector(channelRightBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.channelRightBtn5 addTarget: self action: @selector(channelRightBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.loadBtn addTarget: self action: @selector(loadBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.setBtn addTarget: self action: @selector(setBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)hideKeyboard
{
    [self.timingTextField resignFirstResponder];
    [self.distanceTextField resignFirstResponder];
}
#pragma mark -- 读取设备多次拍照设置 数据
- (void)loadBtnClick
{
    [self hideKeyboard];
    [self clearData];
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
//    MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
//    [hud hideAnimated:YES];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devControlController/getMulPhotoParaList" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.isLoadData = YES;
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                MultiplePhotoModel *model = [MultiplePhotoModel yy_modelWithJSON: response[@"data"]];
                weakSelf.photoModel = model;
                weakSelf.photoQualitySlide.value = model.quality;//8 - model.quality;
                weakSelf.brightnessSlide.value = model.luminance;
                weakSelf.contrastSlide.value = model.contrast;
                weakSelf.saturationSlide.value = model.saturation;
                weakSelf.chromaSlide.value = model.chroma;
                if ([model.timePhoto isEqualToString: @"0"] == NO) {
                    weakSelf.timingTextField.text = model.timePhoto;
                    weakSelf.timingSelectBtn.selected = YES;
                }else {
                    weakSelf.timingSelectBtn.selected = NO;
                }
                if ([model.disPhoto isEqualToString: @"0"] == NO) {
                    weakSelf.distanceTextField.text = model.disPhoto;
                    weakSelf.distanceSelectBtn.selected = YES;
                }else {
                    weakSelf.distanceSelectBtn.selected = NO;
                }
                NSString *replaceLeftBracketString = [model.channel stringByReplacingOccurrencesOfString: @"(" withString: @""];
                NSString *replaceRightBracketString = [replaceLeftBracketString stringByReplacingOccurrencesOfString: @")" withString: @""];
                NSArray *channelArr = [replaceRightBracketString componentsSeparatedByString: @"."];
                NSString *leftOpenStr = weakSelf.channelLeftArr[0][0];
                for (NSString *channelString in  channelArr) {
                    NSArray *channelDataArr = [channelString componentsSeparatedByString: @","];
                    if ([channelDataArr.firstObject isEqualToString: @"1"]) {
                        [weakSelf.channelLeftBtn1 setTitle: leftOpenStr  forState: UIControlStateNormal];
                        [weakSelf.channelLeftBtn1 setTitle: leftOpenStr forState: UIControlStateHighlighted];
                        [weakSelf.channelRightBtn1 setTitle: weakSelf.channelRightArr[0][[channelDataArr.lastObject integerValue]] forState: UIControlStateNormal];
                        [weakSelf.channelRightBtn1 setTitle: weakSelf.channelRightArr[0][[channelDataArr.lastObject integerValue]] forState: UIControlStateHighlighted];
                    }else if ([channelDataArr.firstObject isEqualToString: @"2"]) {
                        [weakSelf.channelLeftBtn2 setTitle: leftOpenStr forState: UIControlStateNormal];
                        [weakSelf.channelLeftBtn2 setTitle: leftOpenStr forState: UIControlStateHighlighted];
                        [weakSelf.channelRightBtn2 setTitle: weakSelf.channelRightArr[0][[channelDataArr.lastObject integerValue]] forState: UIControlStateNormal];
                        [weakSelf.channelRightBtn2 setTitle: weakSelf.channelRightArr[0][[channelDataArr.lastObject integerValue]] forState: UIControlStateHighlighted];
                    }else if ([channelDataArr.firstObject isEqualToString: @"3"]) {
                        [weakSelf.channelLeftBtn3 setTitle: leftOpenStr forState: UIControlStateNormal];
                        [weakSelf.channelLeftBtn3 setTitle: leftOpenStr forState: UIControlStateHighlighted];
                        [weakSelf.channelRightBtn3 setTitle: weakSelf.channelRightArr[0][[channelDataArr.lastObject integerValue]] forState: UIControlStateNormal];
                        [weakSelf.channelRightBtn3 setTitle: weakSelf.channelRightArr[0][[channelDataArr.lastObject integerValue]] forState: UIControlStateHighlighted];
                    }else if ([channelDataArr.firstObject isEqualToString: @"4"]) {
                        [weakSelf.channelLeftBtn4 setTitle: leftOpenStr forState: UIControlStateNormal];
                        [weakSelf.channelLeftBtn4 setTitle: leftOpenStr forState: UIControlStateHighlighted];
                        [weakSelf.channelRightBtn4 setTitle: weakSelf.channelRightArr[0][[channelDataArr.lastObject integerValue]] forState: UIControlStateNormal];
                        [weakSelf.channelRightBtn4 setTitle: weakSelf.channelRightArr[0][[channelDataArr.lastObject integerValue]] forState: UIControlStateHighlighted];
                    }else if ([channelDataArr.firstObject isEqualToString: @"5"]) {
                        [weakSelf.channelLeftBtn5 setTitle: leftOpenStr forState: UIControlStateNormal];
                        [weakSelf.channelLeftBtn5 setTitle: leftOpenStr forState: UIControlStateHighlighted];
                        [weakSelf.channelRightBtn5 setTitle: weakSelf.channelRightArr[0][[channelDataArr.lastObject integerValue]] forState: UIControlStateNormal];
                        [weakSelf.channelRightBtn5 setTitle: weakSelf.channelRightArr[0][[channelDataArr.lastObject integerValue]] forState: UIControlStateHighlighted];
                    }
                }
               
            }else {
                
            }
        }else {
     
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)clearData
{
    self.timingTextField.text = @"";
    self.distanceTextField.text = @"";
    NSArray *channelLeftBtnArr = @[self.channelLeftBtn1, self.channelLeftBtn2, self.channelLeftBtn3, self.channelLeftBtn4, self.channelLeftBtn5];
    NSArray *channelRightBtnArr = @[self.channelRightBtn1, self.channelRightBtn2, self.channelRightBtn3, self.channelRightBtn4, self.channelRightBtn5];
    for (int i = 0; i < channelLeftBtnArr.count; i++) {
        UIButton *leftbutton = channelLeftBtnArr[i];
        UIButton *rightButton = channelRightBtnArr[i];
        [leftbutton setTitle: self.channelLeftArr[0][1] forState: UIControlStateNormal];
        [leftbutton setTitle: self.channelLeftArr[0][1] forState: UIControlStateHighlighted];
        [rightButton setTitle: self.channelRightArr[0][0] forState: UIControlStateNormal];
        [rightButton setTitle: self.channelRightArr[0][0] forState: UIControlStateHighlighted];
    }
}
#pragma mark -- 保存设备多次拍照设置
- (void)setBtnClick
{
    [self hideKeyboard];
    if (self.timingTextField.text.length < 1 && self.timingSelectBtn.selected == YES) {
        [HUD showHUDWithText:Localized(@"请输入时间拍照数据(秒)") withDelay:1.2];
        return;
    }
    if (self.distanceTextField.text.length < 1 && self.distanceSelectBtn.selected == YES) {
        [HUD showHUDWithText:Localized(@"请输入定距拍照数据(米)") withDelay:1.2];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    if (self.timingSelectBtn.selected == YES) {
        dic[@"time_photo"] = self.timingTextField.text;
    }else {
        dic[@"time_photo"] = @0;
    }
    if (self.distanceSelectBtn.selected == YES) {
        dic[@"dis_photo"] = self.distanceTextField.text;
    }else {
        dic[@"dis_photo"] = @0;
    }
    //dic[@"quality"] = [NSString stringWithFormat: @"%d", (int)(8 - self.photoQualitySlide.value)];
    dic[@"quality"] = [NSString stringWithFormat: @"%.f", self.photoQualitySlide.value];
    dic[@"luminance"] = [NSString stringWithFormat: @"%d", (int)self.brightnessSlide.value];
    dic[@"saturation"] = [NSString stringWithFormat: @"%d", (int)self.saturationSlide.value];
    dic[@"contrast"] = [NSString stringWithFormat: @"%d", (int)self.contrastSlide.value];
    dic[@"chroma"] = [NSString stringWithFormat: @"%d", (int)self.chromaSlide.value];
    NSMutableArray *channelDataArr = [NSMutableArray array];
    NSArray *channelLeftBtnArr = @[self.channelLeftBtn1, self.channelLeftBtn2, self.channelLeftBtn3, self.channelLeftBtn4, self.channelLeftBtn5];
    NSArray *channelRightBtnArr = @[self.channelRightBtn1, self.channelRightBtn2, self.channelRightBtn3, self.channelRightBtn4, self.channelRightBtn5];
    for (int i = 0; i < channelLeftBtnArr.count; i++) {
        UIButton *leftbutton = channelLeftBtnArr[i];
        UIButton *rightButton = channelRightBtnArr[i];
        if ([leftbutton.titleLabel.text isEqualToString: self.channelLeftArr[0][0]] == YES && [rightButton.titleLabel.text isEqualToString: self.channelRightArr[0][0]]) {
            [channelDataArr addObject: [NSString stringWithFormat: @"(%d,0)", i + 1]];
        }else if ([leftbutton.titleLabel.text isEqualToString: self.channelLeftArr[0][0]] == YES && [rightButton.titleLabel.text isEqualToString: self.channelRightArr[0][1]]) {
            [channelDataArr addObject: [NSString stringWithFormat: @"(%d,1)", i + 1]];
        }
    }
    if (channelDataArr.count >= 1) {
        dic[@"channel"] = [channelDataArr componentsJoinedByString: @"."];
    }
//    MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
//    [hud hideAnimated:YES];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devControlController/editMulPhotoPara" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [weakSelf.navigationController popViewControllerAnimated: YES];
        }else {
           
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)channelLeftBtnClick:(UIButton *)button
{
    [self hideKeyboard];
    self.currenSelectBtn = button;
    channelLeftPickerView = [[MINPickerView alloc] init];
    channelLeftPickerView.titleLabel.text = @"";
    channelLeftPickerView.dataArr = self.channelLeftArr;
    channelLeftPickerView.delegate = self;
    [self.view addSubview: channelLeftPickerView];
    [channelLeftPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    [channelLeftPickerView showView];
}

- (void)channelRightBtnClick:(UIButton *)button
{
    [self hideKeyboard];
    self.currenSelectBtn = button;
    channelRightPickerView = [[MINPickerView alloc] init];
    channelRightPickerView.titleLabel.text = @"";
    channelRightPickerView.dataArr = self.channelRightArr;
    channelRightPickerView.delegate = self;
    [self.view addSubview: channelRightPickerView];
    [channelRightPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    [channelRightPickerView showView];
}

- (void)timingSelectBtnClick
{
    if (self.timingSelectBtn.selected == YES) {
        self.timingSelectBtn.selected = NO;
    }else {
        self.timingSelectBtn.selected = YES;
    }
}

- (void)distanceSelectBtnClick
{
    if (self.distanceSelectBtn.selected == YES) {
        self.distanceSelectBtn.selected = NO;
    }else {
        self.distanceSelectBtn.selected = YES;
    }
}

- (void)rightBtnClick:(UIButton *)sender
{
    if (sender.selected) {
        [sender setTitle:Localized(@"编辑") forState:UIControlStateNormal];
        [self canEdit:NO];
    } else {
        
        if (self.isLoadData == NO) {
            [MINUtils showProgressHudToView:self.view withText:Localized(@"请先读取数据")];
            return;
        }
        [self canEdit:YES];
        [sender setTitle:Localized(@"完成") forState:UIControlStateNormal];
    }
    sender.selected = !sender.selected;
    [self hideKeyboard];
}
- (void)canEdit:(BOOL)canEdit {
    self.photoQualitySlide.userInteractionEnabled = canEdit;
    self.brightnessSlide.userInteractionEnabled = canEdit;
    self.contrastSlide.userInteractionEnabled = canEdit;
    self.saturationSlide.userInteractionEnabled = canEdit;
    self.chromaSlide.userInteractionEnabled = canEdit;
    self.timingSelectBtn.userInteractionEnabled = canEdit;
    self.distanceSelectBtn.userInteractionEnabled = canEdit;
    self.timingTextField.userInteractionEnabled = canEdit;
    self.distanceTextField.userInteractionEnabled = canEdit;
    channelView1.userInteractionEnabled = canEdit;
    channelView2.userInteractionEnabled = canEdit;
    channelView3.userInteractionEnabled = canEdit;
    channelView4.userInteractionEnabled = canEdit;
    channelView5.userInteractionEnabled = canEdit;
}
- (void)slideValueChangeed:(UISlider *)slide
{
    if (slide == self.photoQualitySlide) {
//        NSArray *numbers = @[@0, @1, @2, @3, @4, @5, @6, @7];
//        NSUInteger index = (NSUInteger)(slide.value + 0.5);
//        [slide setValue:index animated:NO];
//        NSNumber *number = numbers[index]; // <-- This numeric value you want
//        NSLog(@"sliderIndex: %i", (int)index);
//        NSLog(@"number: %@", number);
        
        [slide setValue:slide.value animated:NO];
    }
}

#pragma mark - createUI
- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self initBarWithTitle:Localized(@"多次拍照") isBack: YES];
    [self initBarRighBtnTitle: Localized(@"编辑") target: self action: @selector(rightBtnClick:)];
    [self createScrollView];
    // 图像质量
    photoQualityView = [self createViewWithTitle:Localized(@"图像质量")];
    [self.contentView addSubview: photoQualityView];
    [photoQualityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(self.contentView).with.offset(12.5 * KFitHeightRate);
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
    self.photoQualitySlide.maximumValue = 7.0;
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
    timingPhotoView = [self createViewWithTitle: @""];
    [self.contentView addSubview: timingPhotoView];
    [timingPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
        make.top.equalTo(chromaView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    
    CGFloat btnWidth = (SCREEN_WIDTH - 12.5*KFitWidthRate*3 - 50*KFitWidthRate*2 - 5*KFitWidthRate*4)/2;
    
    self.timingSelectBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"定时拍照") titleColor: kRGB(73, 73, 73) fontSize: 15 * KFitHeightRate backgroundColor: nil];
    self.timingSelectBtn.titleLabel.numberOfLines = 0;
    self.timingSelectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10 * KFitWidthRate);
    self.timingSelectBtn.selected = YES;
    self.timingSelectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10 * KFitWidthRate, 0, 0);
    [self.timingSelectBtn setImage: [UIImage imageNamed: @"单选-没选中"] forState: UIControlStateNormal];
    [self.timingSelectBtn setImage: [UIImage imageNamed: @"单选-选中"] forState: UIControlStateSelected];
    [timingPhotoView addSubview: self.timingSelectBtn];
    [self.timingSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timingPhotoView).with.offset(12.5 * KFitWidthRate * KFitWidthRate);
        make.top.bottom.equalTo(timingPhotoView);
        make.width.mas_equalTo(btnWidth);
    }];
    self.timingTextField =  [MINUtils createBorderTextFieldWithHoldText:Localized(@"秒") fontSize: 12 * KFitHeightRate];
    self.timingTextField.textAlignment = NSTextAlignmentCenter;
    self.timingTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.timingTextField.leftView = nil;
    [timingPhotoView addSubview: self.timingTextField];
    [self.timingTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timingSelectBtn.mas_right).offset(5*KFitWidthRate);
        make.centerY.equalTo(timingPhotoView);
        make.size.mas_equalTo(CGSizeMake(50 * KFitWidthRate, 30 * KFitHeightRate));
    }];
    self.distanceSelectBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"定距拍照") titleColor: kRGB(73, 73, 73) fontSize: 15 * KFitHeightRate backgroundColor: nil];
    self.distanceSelectBtn.titleLabel.numberOfLines = 0;
    self.distanceSelectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10 * KFitWidthRate);
    self.distanceSelectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10 * KFitWidthRate, 0, 0);
    [self.distanceSelectBtn setImage: [UIImage imageNamed: @"单选-没选中"] forState: UIControlStateNormal];
    [self.distanceSelectBtn setImage: [UIImage imageNamed: @"单选-选中"] forState: UIControlStateSelected];
    [timingPhotoView addSubview: self.distanceSelectBtn];
    [self.distanceSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timingTextField.mas_right).with.offset(5 * KFitWidthRate);
        make.top.bottom.equalTo(timingPhotoView);
        make.width.mas_equalTo(btnWidth);
    }];
    self.distanceTextField = [MINUtils createBorderTextFieldWithHoldText:Localized(@"米") fontSize: 12 * KFitHeightRate];
    self.distanceTextField.textAlignment = NSTextAlignmentCenter;
    self.distanceTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.distanceTextField.leftView = nil;
    [timingPhotoView addSubview: self.distanceTextField];
    [self.distanceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.distanceSelectBtn.mas_right).offset(5*KFitWidthRate);;
        make.centerY.equalTo(timingPhotoView);
        make.size.mas_equalTo(CGSizeMake(50 * KFitWidthRate, 30 * KFitHeightRate));
    }];
    
    channelView1 = [self createViewWithTitle:Localized(@"通道1")];
    channelView2 = [self createViewWithTitle:Localized(@"通道2")];
    channelView3 = [self createViewWithTitle:Localized(@"通道3")];
    channelView4 = [self createViewWithTitle:Localized(@"通道4")];
    channelView5 = [self createViewWithTitle:Localized(@"通道5")];
    NSArray *channelViewArr = @[channelView1, channelView2, channelView3, channelView4, channelView5];
    lastView = nil;
    for (int i = 0; i < channelViewArr.count; i++) {
        UIView *view = channelViewArr[i];
        [self.contentView addSubview: view];
        if (lastView == nil) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
                make.top.equalTo(timingPhotoView.mas_bottom).with.offset(12.5 * KFitHeightRate);
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
    NSString *leftCloseStr = self.channelLeftArr[0][1];
    NSString *rightSaveStr = self.channelRightArr[0][0];
    self.channelLeftBtn1 = [MINUtils createBorderBtnWithArrowImageWithTitle: leftCloseStr];
    self.channelLeftBtn2 = [MINUtils createBorderBtnWithArrowImageWithTitle: leftCloseStr];
    self.channelLeftBtn3 = [MINUtils createBorderBtnWithArrowImageWithTitle: leftCloseStr];
    self.channelLeftBtn4 = [MINUtils createBorderBtnWithArrowImageWithTitle: leftCloseStr];
    self.channelLeftBtn5 = [MINUtils createBorderBtnWithArrowImageWithTitle: leftCloseStr];
    self.channelRightBtn1 = [MINUtils createBorderBtnWithArrowImageWithTitle: rightSaveStr];
    self.channelRightBtn2 = [MINUtils createBorderBtnWithArrowImageWithTitle: rightSaveStr];
    self.channelRightBtn3 = [MINUtils createBorderBtnWithArrowImageWithTitle: rightSaveStr];
    self.channelRightBtn4 = [MINUtils createBorderBtnWithArrowImageWithTitle: rightSaveStr];
    self.channelRightBtn5 = [MINUtils createBorderBtnWithArrowImageWithTitle: rightSaveStr];
    NSArray *leftBtnArr = @[self.channelLeftBtn1, self.channelLeftBtn2, self.channelLeftBtn3, self.channelLeftBtn4, self.channelLeftBtn5];
    NSArray *rightBtnArr = @[self.channelRightBtn1, self.channelRightBtn2, self.channelRightBtn3, self.channelRightBtn4, self.channelRightBtn5];
    for (int i = 0; i < channelViewArr.count; i++) {
        UIView *view = channelViewArr[i];
        UIButton *leftBtn = leftBtnArr[i];
        UIButton *rightBtn = rightBtnArr[i];
        [view addSubview: leftBtn];
        [view addSubview: rightBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view).with.offset(97.5 * KFitWidthRate);
            make.right.equalTo(rightBtn.mas_left).with.offset(-20 * KFitWidthRate);
            make.height.mas_equalTo(30 * KFitHeightRate);
        }];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.right.equalTo(view).with.offset(-12.5 * KFitWidthRate);
            make.height.mas_equalTo(30 * KFitHeightRate);
            make.width.equalTo(leftBtn);
        }];
    }
    self.loadBtn = [MINUtils createBtnWithRadius: 5 * KFitWidthRate title:Localized(@"读取")];
    [self.contentView addSubview: self.loadBtn];
    [self.loadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(30 * KFitWidthRate);
        make.top.equalTo(channelView5.mas_bottom).with.offset(40 * KFitHeightRate);
        make.size.mas_equalTo(CGSizeMake(130 * KFitWidthRate, 40 * KFitHeightRate));
    }];
    self.setBtn = [MINUtils createBtnWithRadius: 5 * KFitWidthRate title:Localized(@"设置")];
    [self.setBtn setTitleColor: kBlueColor forState: UIControlStateNormal];
    [self.setBtn setTitleColor: kBlueColor forState: UIControlStateHighlighted];
    self.setBtn.backgroundColor = [UIColor whiteColor];
    self.setBtn.layer.borderColor = kBlueColor.CGColor;
    self.setBtn.layer.borderWidth = 0.5;
    [self.contentView addSubview: self.setBtn];
    [self.setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-30 * KFitWidthRate);
        make.top.equalTo(channelView5.mas_bottom).with.offset(40 * KFitHeightRate);
        make.size.mas_equalTo(CGSizeMake(130 * KFitWidthRate, 40 * KFitHeightRate));
    }];
    [self.scrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.loadBtn.mas_bottom).with.offset(12.5 * KFitHeightRate);
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
    slide.value = 0;
    slide.minimumValue = 0;
    slide.maximumValue = 100;
    //设置轨道的图片
    [slide setMinimumTrackImage: stetchLeftTrack forState:UIControlStateNormal];
    [slide setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    //设置滑块的图片
    [slide setThumbImage:thumbImage forState:UIControlStateNormal];
    [slide addTarget: self action: @selector(slideValueChangeed:) forControlEvents: UIControlEventValueChanged];
    slide.continuous = YES;
    return slide;
}

- (UIView *)createViewWithTitle:(NSString *)title
{
    UIView *view = [MINUtils createViewWithRadius: 5 * KFitWidthRate];
    UILabel *titleLabel = [MINUtils createLabelWithText: title size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(73, 73, 73)];
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
    if (pickerView == channelLeftPickerView) {
        [self.currenSelectBtn setTitle: self.channelLeftArr[0][[selectNum integerValue]] forState: UIControlStateNormal];
        [self.currenSelectBtn setTitle: self.channelLeftArr[0][[selectNum integerValue]] forState: UIControlStateHighlighted];
    }else if (pickerView == channelRightPickerView) {
        [self.currenSelectBtn setTitle: self.channelRightArr[0][[selectNum integerValue]] forState: UIControlStateNormal];
        [self.currenSelectBtn setTitle: self.channelRightArr[0][[selectNum integerValue]] forState: UIControlStateHighlighted];
    }
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
