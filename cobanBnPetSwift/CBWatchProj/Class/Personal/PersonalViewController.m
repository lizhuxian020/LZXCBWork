//
//  PersonalViewController.m
//  Watch
//
//  Created by lym on 2018/2/27.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "PersonalViewController.h"
#import "MINClickCellView.h"
#import "SwitchWatchViewController.h"
#import "CBWtEditWtInfoViewController.h"
#import "BindOrUnbindViewController.h"
#import "CBWtMINAlertView.h"
#import "ChangeBindPhoneNumViewController.h"
#import "AppSettingViewController.h"
#import "HomeModel.h"
#import "CBScanAddWatchViewController.h"

@interface PersonalViewController ()
{
    MINClickCellView *watchNumView;
    MINClickCellView *bindView;
    MINClickCellView *appSettingView;
    UIView *watchNumBackView;
    UIView *bindBackView;
    UIView *appSettingBackView;
}
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIButton *headImageBtn;
@property (nonatomic, strong) UIImageView *avtarImageView;
@property (nonatomic, strong) UILabel *userNameLb;
@property (nonatomic, strong) UIButton *addWatchBtn;
@property (nonatomic, strong) UIButton *switchWatchBtn;
@end

@implementation PersonalViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"tabbar"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    // 刷新头像info
    [self initDataWithModel:[HomeModel CBDevice]];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.headImageBtn.layer.masksToBounds = YES;
    self.headImageBtn.layer.cornerRadius = (75*KFitWidthRate)/2;
    
    self.avtarImageView.layer.masksToBounds = YES;
    self.avtarImageView.layer.cornerRadius = (70*KFitWidthRate)/2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self addActionAndSetCellClickBlock];
}
- (void)initDataWithModel:(HomeModel *)model {
    [self.avtarImageView sd_setImageWithURL:[NSURL URLWithString:self.homeInfoModel.tbWatchMain.head] placeholderImage:[UIImage imageNamed:@"默认宝贝头像"] options:SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageRefreshCached];
    watchNumView.rightLabel.text = model.tbWatchMain.phone;
    self.userNameLb.text = model.tbWatchMain.name;
}
#pragma mark - CreateUI
- (void)setupView {
    [self initBarWithTitle:@"" isBack: YES];
    self.view.backgroundColor = KWtBackColor;
    [self headImageView];
    [self headImageBtn];
    [self avtarImageView];
    
    [self.avtarImageView sd_setImageWithURL:[NSURL URLWithString:self.homeInfoModel.tbWatchMain.head] placeholderImage:[UIImage imageNamed:@"默认宝贝头像"] options:SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageRefreshCached];
    
    UILabel *userNameLb = [UILabel new];
    userNameLb.text = self.homeInfoModel.tbWatchMain.name;
    userNameLb.textColor = [UIColor whiteColor];
    userNameLb.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:userNameLb];
    [userNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headImageBtn.mas_centerX);
        make.top.mas_equalTo(self.headImageBtn.mas_bottom).offset(5);
    }];
    self.userNameLb = userNameLb;
    
    UIImage *imageAdd = [UIImage imageNamed:@"添加手表"];
    self.addWatchBtn = [CBWtMINUtils createBtnWithImage:imageAdd];
    [self.view addSubview: self.addWatchBtn];
    [self.addWatchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headImageBtn.mas_left).with.offset(-40 * KFitWidthRate);
        make.centerY.equalTo(self.headImageBtn);
        make.size.mas_equalTo(CGSizeMake(imageAdd.size.width, imageAdd.size.height));
    }];
    UILabel *addLb = [UILabel new];
    addLb.text = Localized(@"添加手表");
    addLb.textColor = [UIColor whiteColor];
    addLb.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:addLb];
    [addLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.addWatchBtn.mas_centerX);
        make.top.mas_equalTo(self.addWatchBtn.mas_bottom).offset(5);
    }];
    
    UIImage *imageSwitch = [UIImage imageNamed:@"切换"];
    self.switchWatchBtn = [CBWtMINUtils createBtnWithImage:imageSwitch];
    [self.view addSubview: self.switchWatchBtn];
    [self.switchWatchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageBtn.mas_right).with.offset(40 * KFitWidthRate);
        make.centerY.equalTo(self.headImageBtn);
        make.size.mas_equalTo(CGSizeMake(imageSwitch.size.width, imageSwitch.size.height));
    }];
    UILabel *switchLb = [UILabel new];
    switchLb.text = Localized(@"切换");
    switchLb.textColor = [UIColor whiteColor];
    switchLb.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:switchLb];
    [switchLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.switchWatchBtn.mas_centerX);
        make.top.mas_equalTo(self.switchWatchBtn.mas_bottom).offset(5);
    }];
    
    watchNumBackView = [self createViewWithImage: [UIImage imageNamed: @"个人中心-手表号码"]];
    [CBWtMINUtils addLineToView: watchNumBackView isTop: NO hasSpaceToSide: YES];
    [self.view addSubview: watchNumBackView];
    [watchNumBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    
    watchNumView = [[MINClickCellView alloc] init];
    [watchNumView setLeftLabelText: Localized(@"手表号码") rightLabelText: @"18010525600"];
    [watchNumBackView addSubview: watchNumView];
    [watchNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(watchNumBackView).with.offset(45 * KFitWidthRate);
        make.top.right.bottom.equalTo(watchNumBackView);
    }];
    // 手表号码
    watchNumView.rightLabel.text = self.homeInfoModel.tbWatchMain.phone;
    
    bindBackView = [self createViewWithImage: [UIImage imageNamed: @"个人中心-绑定与解绑"]];
    [self.view addSubview: bindBackView];
    [bindBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(watchNumBackView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    bindView = [[MINClickCellView alloc] init];
    [bindView setLeftLabelText:Localized(@"绑定与解绑") rightLabelText: @""];
    [bindBackView addSubview: bindView];
    [bindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bindBackView).with.offset(45 * KFitWidthRate);
        make.top.right.bottom.equalTo(bindBackView);
    }];
    appSettingBackView = [self createViewWithImage: [UIImage imageNamed: @"个人中心-APP设置"]];
    [self.view addSubview: appSettingBackView];
    [appSettingBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bindBackView.mas_bottom).with.offset(12.5 * KFitWidthRate);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    appSettingView = [[MINClickCellView alloc] init];
    [appSettingView setLeftLabelText:Localized(@"APP设置") rightLabelText: @""];
    [appSettingBackView addSubview: appSettingView];
    [appSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(appSettingBackView).with.offset(45 * KFitWidthRate);
        make.top.right.bottom.equalTo(appSettingBackView);
    }];
}
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"wt_psnal_bgmImage"]];
        [self.view addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_equalTo(SCREEN_WIDTH * 4.3 / 7.5);
        }];
    }
    return _headImageView;
}
- (UIButton *)headImageBtn {
    if (!_headImageBtn) {
        _headImageBtn = [UIButton new];//[CBWtMINUtils createBtnWithImage: [UIImage imageNamed:@"哥哥"]];
        _headImageBtn.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:_headImageBtn];
        [_headImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(12.5 * KFitWidthRate);
            } else {
                // Fallback on earlier versions
                make.top.equalTo(self.view.mas_topMargin).with.offset(12.5 * KFitWidthRate + kNavAndStatusHeight);
            }
            make.size.mas_equalTo(CGSizeMake(75 * KFitWidthRate, 75 * KFitWidthRate));
        }];
    }
    return _headImageBtn;
}
- (UIImageView *)avtarImageView {
    if (!_avtarImageView) {
        _avtarImageView = [UIImageView new];
        _avtarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_avtarImageView];
        [_avtarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.headImageBtn);
            make.size.mas_equalTo(CGSizeMake(70 * KFitWidthRate, 70 * KFitWidthRate));
        }];
    }
    return _avtarImageView;
}
#pragma mark - Action Block
- (void)addActionAndSetCellClickBlock {
    [self.headImageBtn addTarget: self action: @selector(headImageBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.addWatchBtn addTarget: self action: @selector(addWatchBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.switchWatchBtn addTarget: self action: @selector(switchWatchBtnClick) forControlEvents: UIControlEventTouchUpInside];
    __weak __typeof__(self) weakSelf = self;
    watchNumView.clickBtnClickBlock = ^{
        [weakSelf showAlertView];
    };
    bindView.clickBtnClickBlock = ^{
        [weakSelf bindOrUnbindClick];
    };
    appSettingView.clickBtnClickBlock = ^{
        [weakSelf appSettingClick];
    };
}
#pragma mark -- 编辑账号信息
- (void)headImageBtnClick {
    CBWtCBWtEditWtInfoViewController *editWatchVC = [[CBWtCBWtEditWtInfoViewController alloc] init];
    [self.navigationController pushViewController: editWatchVC animated: YES];
}
#pragma mark -- 添加手表
- (void)addWatchBtnClick {
    CBScanAddWatchViewController *addWatchVC = [[CBScanAddWatchViewController alloc]init];
    //AddWatchViewController *addWatchVC = [[AddWatchViewController alloc] init];
    [self.navigationController pushViewController: addWatchVC animated: YES];
}
#pragma mark -- 切换手表
- (void)switchWatchBtnClick {
    SwitchWatchViewController *switchWatchVC = [[SwitchWatchViewController alloc] init];
    [self.navigationController pushViewController: switchWatchVC animated: YES];
}
- (UIView *)createViewWithImage:(UIImage *)image {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    imageView.contentMode = UIViewContentModeCenter;
    [view addSubview: imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(view);
        make.width.mas_equalTo(45 * KFitWidthRate);
    }];
    return view;
}
#pragma mark -- 手表号码
- (void)showAlertView {
    CBWtMINAlertView *alertView = [[CBWtMINAlertView alloc] init];
    [self.view addSubview: alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [alertView showRightCloseBtn];
    [alertView setContentViewHeight: 80 * KFitWidthRate];
    alertView.titleLabel.text = Localized(@"提示");
    UILabel *detailLabel  = [CBWtMINUtils createLabelWithText:Localized(@"请填写正确的手表号码，号码填写错误可能导致无法正常使用") size: 15 * KFitWidthRate alignment: NSTextAlignmentCenter textColor: KWt137Color];
    detailLabel.numberOfLines = 0;
    [alertView.contentView addSubview: detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertView.contentView);
        make.left.equalTo(alertView.contentView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(alertView.contentView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(70 * KFitWidthRate);
    }];
    [alertView.leftBottomBtn setTitle:Localized(@"确定") forState: UIControlStateNormal];
    [alertView.leftBottomBtn setTitle:Localized(@"确定") forState: UIControlStateHighlighted];
    __weak __typeof__(self) weakSelf = self;
    __weak __typeof__(CBWtMINAlertView *) weakAlertView = alertView;
    alertView.leftBtnClick = ^{
        ChangeBindPhoneNumViewController *changeBindPhoneNumVC = [[ChangeBindPhoneNumViewController alloc] init];
        [weakSelf.navigationController pushViewController: changeBindPhoneNumVC animated:YES];
        [weakAlertView hideView];
    };
}
#pragma mark -- 绑定与解绑
- (void)bindOrUnbindClick {
    BindOrUnbindViewController *bindOrUnbindVC = [[BindOrUnbindViewController alloc] init];
    [self.navigationController pushViewController:bindOrUnbindVC animated:YES];
}
#pragma mark -- APP设置
- (void)appSettingClick {
    AppSettingViewController *appSettingVC = [[AppSettingViewController alloc] init];
    [self.navigationController pushViewController: appSettingVC animated:YES];
}
#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
