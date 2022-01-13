//
//  MessageServerViewController.m
//  Telematics
//
//  Created by lym on 2017/12/1.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MessageServerViewController.h"
#import "MINPickerView.h"

@interface MessageServerViewController () <UITextViewDelegate, MINPickerViewDelegate>
{
    UIView *topView;
    UIView *bottomView;
    MINPickerView *topPickerView;
    MINPickerView *bottomPickerView;
    BOOL keyboardIsShown;
}
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *topMessageLabel;
@property (nonatomic, strong) UITextView *topMessageTextView;
@property (nonatomic, strong) UIButton *topTypeBtn;
@property (nonatomic, strong) UIButton *topSendBtn;
@property (nonatomic, strong) UILabel *bottomQuestionLabel;
@property (nonatomic, strong) UITextView *bottomQuestionTextView;
@property (nonatomic, strong) UILabel *bottomAnswerLabel;
@property (nonatomic, strong) UITextView *bottomAnswerTextView;
@property (nonatomic, strong) UIButton *bottomTypeBtn;
@property (nonatomic, strong) UIButton *bottomSendBtn;
@property (nonatomic, copy) NSArray *topTypeArr;
@property (nonatomic, copy) NSArray *bottomTypeArr;
@property (nonatomic, assign) int topTypeSelectIndex;
@property (nonatomic, assign) int bottomTypeSelectIndex;
@end

@implementation MessageServerViewController
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
    [self addGesture];
    [self addAction];
    self.topTypeArr = @[@[Localized(@"紧急"), Localized(@"普通"), Localized(@"终端显示器显示"), Localized(@"终端TTS播读"), Localized(@"广告屏显示"), Localized(@"中心导航信息")]];
    self.bottomTypeArr = @[@[Localized(@"紧急"), Localized(@"终端显示器显示"), Localized(@"终端TTS播读"), Localized(@"广告屏显示")]];
    self.topTypeSelectIndex = 0;
    self.bottomTypeSelectIndex = 0;
}

#pragma mark - addAction
- (void)addAction
{
    [self.topTypeBtn addTarget: self action: @selector(topTypeBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.bottomTypeBtn addTarget: self action: @selector(bottomTypeBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.topSendBtn addTarget: self action: @selector(topSendBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.bottomSendBtn addTarget: self action: @selector(bottomSendBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)topSendBtnClick
{
    [self endEidt];
    if (self.topMessageTextView.text.length < 1) {
        [HUD showHUDWithText: @"请输入文本消息内容" withDelay:1.2];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    dic[@"content"] = self.topMessageTextView.text;
    dic[@"text_type"] = [NSString stringWithFormat: @"%d", self.topTypeSelectIndex];
//    MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
//    [hud hideAnimated:YES];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devControlController/sendService" params: dic succeed:^(id response,BOOL isSucceed) {
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

- (void)bottomSendBtnClick
{
    [self endEidt];
    if (self.bottomQuestionTextView.text.length < 1) {
        [HUD showHUDWithText: @"请输入提问内容" withDelay:1.2];
        return;
    }
    if (self.bottomAnswerTextView.text.length < 1) {
        [HUD showHUDWithText: @"请输入答案内容" withDelay:1.2];
        return;
    }
        
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    dic[@"question"] = self.bottomQuestionTextView.text;
    dic[@"answer"] = self.bottomAnswerTextView.text;
    dic[@"ques_type"] = [NSString stringWithFormat: @"%d", self.bottomTypeSelectIndex];
//    MBProgressHUD *hud = [MINUtils hudToView: self.view withText: Localized(@"加载中...")];
//    [hud hideAnimated:YES];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devControlController/sendService" params: dic succeed:^(id response,BOOL isSucceed) {
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

- (void)topTypeBtnClick
{
    [self endEidt];
    topPickerView = [[MINPickerView alloc] init];
    topPickerView.titleLabel.text = @"";
    topPickerView.dataArr = self.topTypeArr;
    topPickerView.delegate = self;
    [self.view addSubview: topPickerView];
    [topPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    [topPickerView showView];
}

- (void)bottomTypeBtnClick
{
    [self endEidt];
    bottomPickerView = [[MINPickerView alloc] init];
    bottomPickerView.titleLabel.text = @"";
    bottomPickerView.dataArr = self.bottomTypeArr;
    bottomPickerView.delegate = self;
    [self.view addSubview: bottomPickerView];
    [bottomPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    [bottomPickerView showView];
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

- (void)endEidt
{
    [self.view endEditing:YES];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"信息服务下发") isBack: YES];
    [self showBackGround];
    [self createScrollView];
    [self createTopView];
    [self createBottomView];
}

- (void)createBottomView
{
    bottomView = [MINUtils createViewWithRadius:0];
    [self.contentView addSubview: bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(310 * KFitHeightRate);
    }];
    self.bottomQuestionLabel = [MINUtils createLabelWithText:Localized(@"提问") size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(73, 73, 73)];
    [bottomView addSubview: self.bottomQuestionLabel];
    [self.bottomQuestionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView);
        make.left.equalTo(bottomView).with.offset(12.5 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
        make.width.mas_equalTo(250 * KFitWidthRate);
    }];
    self.bottomQuestionTextView = [[UITextView alloc] init];
    self.bottomQuestionTextView.textColor = kRGB(137, 137, 137);
    self.bottomQuestionTextView.layer.borderColor = kRGB(210, 210, 210).CGColor;
    self.bottomQuestionTextView.layer.borderWidth = 0.5;
    self.bottomQuestionTextView.layer.cornerRadius = 5 * KFitWidthRate;
    self.bottomQuestionTextView.delegate = self;
    [bottomView addSubview: self.bottomQuestionTextView];
    [self.bottomQuestionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomQuestionLabel.mas_bottom);
        make.left.equalTo(bottomView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(bottomView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(80 * KFitHeightRate);
    }];
    self.bottomAnswerLabel = [MINUtils createLabelWithText:Localized(@"答案") size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(73, 73, 73)];
    [bottomView addSubview: self.bottomAnswerLabel];
    [self.bottomAnswerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomQuestionTextView.mas_bottom);
        make.left.equalTo(bottomView).with.offset(12.5 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
        make.width.mas_equalTo(250 * KFitWidthRate);
    }];
    self.bottomAnswerTextView = [[UITextView alloc] init];
    self.bottomAnswerTextView.textColor = kRGB(137, 137, 137);
    self.bottomAnswerTextView.layer.borderColor = kRGB(210, 210, 210).CGColor;
    self.bottomAnswerTextView.layer.borderWidth = 0.5;
    self.bottomAnswerTextView.layer.cornerRadius = 5 * KFitWidthRate;
    self.bottomAnswerTextView.delegate = self;
    [bottomView addSubview: self.bottomAnswerTextView];
    [self.bottomAnswerTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomAnswerLabel.mas_bottom);
        make.left.equalTo(bottomView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(bottomView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(80 * KFitHeightRate);
    }];
    self.bottomTypeBtn = [MINUtils createBorderBtnWithArrowImage];
    [self.bottomTypeBtn setTitle:Localized(@"紧急") forState: UIControlStateNormal];
    [self.bottomTypeBtn setTitle:Localized(@"紧急") forState: UIControlStateHighlighted];
    [self.bottomTypeBtn setTitleColor: k137Color forState: UIControlStateNormal];
    [self.bottomTypeBtn setTitleColor: k137Color forState: UIControlStateHighlighted];
    self.bottomTypeBtn.titleLabel.font = [UIFont systemFontOfSize: 12 * KFitHeightRate];
    [bottomView addSubview: self.bottomTypeBtn];
    [self.bottomTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomAnswerTextView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.left.equalTo(bottomView).with.offset(12.5 * KFitWidthRate);
        make.height.mas_equalTo(30 * KFitHeightRate);
        make.width.mas_equalTo(200 * KFitWidthRate);
    }];
    self.bottomSendBtn = [MINUtils createBtnWithRadius: 5 * KFitWidthRate title:Localized(@"发送")];
    [bottomView addSubview: self.bottomSendBtn];
    [self.bottomSendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomAnswerTextView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.right.equalTo(bottomView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(30 * KFitHeightRate);
        make.width.mas_equalTo(75 * KFitWidthRate);
    }];
    [self.scrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_bottom).with.offset(12.5 * KFitHeightRate);
    }];
}

- (void)createTopView
{
    topView = [MINUtils createViewWithRadius:0];
    [self.contentView addSubview: topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(12.5 * KFitHeightRate);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(245 * KFitHeightRate);
    }];
    self.topMessageLabel = [MINUtils createLabelWithText:Localized(@"文本消息") size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(73, 73, 73)];
    [topView addSubview: self.topMessageLabel];
    [self.topMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView);
        make.left.equalTo(topView).with.offset(12.5 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitHeightRate);
        make.width.mas_equalTo(250 * KFitWidthRate);
    }];
    self.topMessageTextView = [[UITextView alloc] init];
    self.topMessageTextView.textColor = kRGB(137, 137, 137);
    self.topMessageTextView.layer.borderColor = kRGB(210, 210, 210).CGColor;
    self.topMessageTextView.layer.borderWidth = 0.5;
    self.topMessageTextView.layer.cornerRadius = 5 * KFitWidthRate;
    [topView addSubview: self.topMessageTextView];
    [self.topMessageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topMessageLabel.mas_bottom);
        make.left.equalTo(topView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(topView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(140 * KFitHeightRate);
    }];
    self.topTypeBtn = [MINUtils createBorderBtnWithArrowImage];
    [self.topTypeBtn setTitle:Localized(@"紧急") forState: UIControlStateNormal];
    [self.topTypeBtn setTitle:Localized(@"紧急") forState: UIControlStateHighlighted];
    [self.topTypeBtn setTitleColor: k137Color forState: UIControlStateNormal];
    [self.topTypeBtn setTitleColor: k137Color forState: UIControlStateHighlighted];
    self.topTypeBtn.titleLabel.font = [UIFont systemFontOfSize: 12 * KFitHeightRate];
    [topView addSubview: self.topTypeBtn];
    [self.topTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topMessageTextView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.left.equalTo(topView).with.offset(12.5 * KFitWidthRate);
        make.height.mas_equalTo(30 * KFitHeightRate);
        make.width.mas_equalTo(200 * KFitWidthRate);
    }];
    self.topSendBtn = [MINUtils createBtnWithRadius: 5 * KFitWidthRate title:Localized(@"发送")];
    [topView addSubview: self.topSendBtn];
    [self.topSendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topMessageTextView.mas_bottom).with.offset(12.5 * KFitHeightRate);
        make.right.equalTo(topView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(30 * KFitHeightRate);
        make.width.mas_equalTo(75 * KFitWidthRate);
    }];
    //测试只有topView的时候用的
//    [self.scrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(topView.mas_bottom).with.offset(12.5 * KFitHeightRate);
//    }];
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
        // insets // 内边距
        make.top.left.bottom.and.right.equalTo(self.scrollerView).with.insets(UIEdgeInsetsZero);
        make.width.equalTo(self.scrollerView);
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == self.bottomAnswerTextView) {
        [self.scrollerView setContentOffset: CGPointMake(0, 185 * KFitHeightRate)];
    }else if (textView == self.bottomQuestionTextView) {
        [self.scrollerView setContentOffset: CGPointMake(0, 50 * KFitHeightRate)];
    }
}

#pragma mark - MINPickerViewDelegate
- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic
{
    NSNumber *selectNum = dic[@"0"];
    if (pickerView == topPickerView) {
        self.topTypeSelectIndex = [selectNum intValue];
        [self.topTypeBtn setTitle: self.topTypeArr[0][[selectNum integerValue]] forState: UIControlStateNormal];
        [self.topTypeBtn setTitle: self.topTypeArr[0][[selectNum integerValue]] forState: UIControlStateHighlighted];
    }else if (pickerView == bottomPickerView) {
        self.bottomTypeSelectIndex = [selectNum intValue];
        [self.bottomTypeBtn setTitle: self.bottomTypeArr[0][[selectNum integerValue]] forState: UIControlStateNormal];
        [self.bottomTypeBtn setTitle: self.bottomTypeArr[0][[selectNum integerValue]] forState: UIControlStateHighlighted];
    }
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
