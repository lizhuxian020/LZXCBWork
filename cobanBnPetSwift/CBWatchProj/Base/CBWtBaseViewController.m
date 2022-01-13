//
//  CBWtBaseViewController.m
//  Telematics
//
//  Created by lym on 2017/10/24.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "CBWtBaseViewController.h"
// 圆角用了下
#import "UIImage+Category.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

@interface CBWtBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation CBWtBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置系统侧滑返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    [AppDelegate shareInstance].customizedStatusBar.backgroundColor = [UIColor clearColor];
}
- (void)dealloc {
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KWtBackColor;
    // 隐藏navigationBar 的下面的横线
    [self.navigationController.navigationBar setShadowImage: [[UIImage alloc] init]];
    
    [AppDelegate shareInstance].customizedStatusBar.backgroundColor = [UIColor clearColor];
    
//    // 设置系统侧滑返回收拾
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    }
}

- (void)setTitleColor:(UIColor *)color
{
    NSDictionary * dict = [NSDictionary dictionaryWithObject: color forKey: NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)initBarWithImage:(NSString *)image isBack:(BOOL)isBack
{
    UIImage *titleImage = [UIImage imageNamed: image];
    UIImageView *titleView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, titleImage.size.width, titleImage.size.height)];
    titleView.image = titleImage;
    self.navigationItem.titleView = titleView;
//    self.navigationController.navigationBar.barTintColor = KWtBlueColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"tabbar"] forBarMetrics: UIBarMetricsDefault];
    if (isBack == YES) {
        UIImage *backImage = [UIImage imageNamed: @"小箭头左边返回"];
        UIButton *backBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0,  30,  44)];
        [backBtn addTarget: self action: @selector(backBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [backBtn setImage: backImage forState: UIControlStateNormal];
        [backBtn setImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 20)];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView: backBtn];
        UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        //将宽度设为负值
        spaceItem.width = 10 * KFitWidthRate;
        self.navigationItem.leftBarButtonItems = @[barItem, spaceItem];
    }else {
        self.navigationItem.hidesBackButton = YES;
    }
}

- (void)initBarWithTitle:(NSString *)title isBack:(BOOL)isBack
{
//    self.navigationController.navigationBar.barTintColor = KWtBlueColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"tabbar"] forBarMetrics: UIBarMetricsDefault];
    self.title = title;
    if (isBack == YES) {
        UIImage *backImage = [UIImage imageNamed: @"小箭头左边返回"];
        UIButton *backBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0,  40,  44)];
        [backBtn addTarget: self action: @selector(backBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [backBtn setImage: backImage forState: UIControlStateNormal];
        [backBtn setImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 20)];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView: backBtn];
        UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        //将宽度设为负值
        spaceItem.width = 10 * KFitWidthRate;
        self.navigationItem.leftBarButtonItems = @[barItem, spaceItem];
    }else {
        self.navigationItem.hidesBackButton = YES;
    }
}

- (void)initBarRightImageName:(NSString *)name target:(id)target action:(SEL)action
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0,  27 * KFitHeightRate,  24 * KFitHeightRate)];
    [rightBtn addTarget:self action:action forControlEvents: UIControlEventTouchUpInside];
    [rightBtn setImage: [UIImage imageNamed: name] forState: UIControlStateNormal];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView: rightBtn];
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = - 5 * KFitWidthRate;
    self.navigationItem.rightBarButtonItems = @[spaceItem, barItem];
}

- (void)initBarLeftImageName:(NSString *)name title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0,  120 * KFitHeightRate,  32)];
    [leftBtn addTarget:self action:action forControlEvents: UIControlEventTouchUpInside];
    UIImage *originalImage = [UIImage imageNamed: name];
    UIImage *thubImage = [originalImage imageWithThumbnailForSize: CGSizeMake(32, 32)];
    UIImage *image = [thubImage imageByRoundCornerRadius: thubImage.size.height borderWidth: 1.5 borderColor: [UIColor whiteColor]];
    [leftBtn setImage: image  forState: UIControlStateNormal];
    [leftBtn setTitle: title forState: UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize: 15];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftBtn.imageView.contentMode = UIViewContentModeCenter;
//    [leftBtn setTitleColor: KWtBlackColor forState: UIControlStateNormal];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView: leftBtn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = - 10 * KFitWidthRate;
    self.navigationItem.leftBarButtonItems = @[barItem, spaceItem];
}

- (void)initBarRighBtnTitle:(NSString *)title target:(nullable id)target action:(nullable SEL)action
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0,  50 * KFitWidthRate,  30 * KFitHeightRate)];
    if (title.length > 4) {
        rightBtn.width = 100 * KFitWidthRate;
    }
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 15];
    [rightBtn setTitle: title forState: UIControlStateNormal];
    [rightBtn setTitle: title forState: UIControlStateHighlighted];
//    [rightBtn setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
//    [rightBtn setTitleColor: [UIColor blackColor] forState: UIControlStateHighlighted];
    [rightBtn addTarget:self action:action forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView: rightBtn];
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = - 15 * KFitWidthRate;
    self.navigationItem.rightBarButtonItems = @[spaceItem, barItem];
}

- (void)initBarRighBtnTitle:(NSString *)title selectTitle:(NSString *)selectTitle target:(nullable id)target action:(nullable SEL)action
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0,  50 * KFitWidthRate,  30 * KFitHeightRate)];
    if (title.length > 4) {
        rightBtn.width = 100 * KFitWidthRate;
    }
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 15];
    [rightBtn setTitle: title forState: UIControlStateNormal];
//    [rightBtn setTitle: title forState: UIControlStateHighlighted];
    [rightBtn setTitle: selectTitle forState: UIControlStateSelected];
    //    [rightBtn setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    //    [rightBtn setTitleColor: [UIColor blackColor] forState: UIControlStateHighlighted];
    [rightBtn addTarget:self action:action forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView: rightBtn];
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = - 15 * KFitWidthRate;
    self.navigationItem.rightBarButtonItems = @[spaceItem, barItem];
}

- (void)initBarRighWhiteBackBtnTitle:(NSString *)title target:(nullable id)target action:(nullable SEL)action
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0,  60 * KFitWidthRate,  30 * KFitHeightRate)];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 15];
    rightBtn.backgroundColor = [UIColor whiteColor];
    [rightBtn setTitle: title forState: UIControlStateNormal];
    [rightBtn setTitle: title forState: UIControlStateHighlighted];
    [rightBtn setTitleColor: KWtBlueColor forState: UIControlStateNormal];
    [rightBtn setTitleColor: KWtBlueColor forState: UIControlStateHighlighted];
    [rightBtn addTarget:self action:action forControlEvents: UIControlEventTouchUpInside];
    rightBtn.layer.cornerRadius = 5 * KFitWidthRate;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize: 15 * KFitHeightRate];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView: rightBtn];
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = - 15 * KFitWidthRate;
    self.navigationItem.rightBarButtonItems = @[spaceItem, barItem];
}

- (void)showBackGround
{
    self.view.backgroundColor = KWtRGB(247, 247, 247);
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated: YES];
}

//- (BOOL)checkLogionState
//{
//    if ([AppDelegate shareInstance].isLogin) {
//        return YES;
//    }else{
//        return NO;
//    }
//}

- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    }else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    }else {
        currentVC = rootVC;
    }
    return currentVC;
}

- (void)popToControllerClass:(__unsafe_unretained Class)controllerClass
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass: controllerClass]) {
            [self.navigationController popToViewController: controller animated: YES];
        }
    }
}

#pragma mark - Others Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = KWtBackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (CBWtNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[CBWtNoDataView alloc] initWithGrail];
        [self.tableView addSubview:_noDataView];
        _noDataView.center = self.tableView.center;
        _noDataView.hidden = YES;
        kWeakSelf(self);
        [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf(self);
            make.size.mas_equalTo(CGSizeMake(200, 200));
            make.centerX.equalTo(self.tableView.mas_centerX);
            make.centerY.equalTo(self.tableView.mas_centerY).offset(-20);
        }];
    }
    return _noDataView;
}
#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return (self.navigationController.viewControllers.count > 1);
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return (self.navigationController.viewControllers.count > 1);
}
@end
