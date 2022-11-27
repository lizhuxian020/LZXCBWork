//
//  MINBaseViewController.m
//  Telematics
//
//  Created by lym on 2017/10/24.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MINBaseViewController.h"
#import "cobanBnPetSwift-Swift.h"

@interface MINBaseViewController ()<UIGestureRecognizerDelegate>

//@property (nonatomic, strong) UIView *customizedStatusBar;

@end

@implementation MINBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置系统侧滑返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
//    [AppDelegate shareInstance].customizedStatusBar.backgroundColor = [UIColor blackColor];
}
- (void)dealloc {
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    if (@available(iOS 13.0, *)) {
        //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kBackColor;
    /** 去掉导航栏下边的黑线  */
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    // 设置系统侧滑返回收拾
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    }
    
    // 状态栏字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if (@available(iOS 13.0, *)) {// iOS 13 不能直接获取到statusbar 手动添加个view到window上当做statusbar背景
         if (![AppDelegate shareInstance].customizedStatusBar) {
             //获取keyWindow
             UIWindow *keyWindow = [self getKeyWindow];
             [AppDelegate shareInstance].customizedStatusBar = [[UIView alloc] initWithFrame:keyWindow.windowScene.statusBarManager.statusBarFrame];
//             [AppDelegate shareInstance].customizedStatusBar.backgroundColor = [UIColor blackColor];
             [keyWindow addSubview:[AppDelegate shareInstance].customizedStatusBar];
         }
//        [AppDelegate shareInstance].customizedStatusBar.backgroundColor = [UIColor blackColor];
     } else {
         [AppDelegate shareInstance].customizedStatusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
         if ([[AppDelegate shareInstance].customizedStatusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//             [AppDelegate shareInstance].customizedStatusBar.backgroundColor = [UIColor blackColor];
         }
    }
}
- (UIWindow *)getKeyWindow {
    // 获取keywindow
    NSArray *array = [UIApplication sharedApplication].windows;
    UIWindow *window = [array objectAtIndex:0];
    if (!window.hidden || window.isKeyWindow) { //  判断取到的window是不是keywidow
        return window;
    }
    //  如果上面的方式取到的window 不是keywidow时  通过遍历windows取keywindow
    for (UIWindow *window in array) {
        if (!window.hidden || window.isKeyWindow) {
            return window;
        }
    }
    return nil;
}
- (void)initBarWithTitle:(NSString *)title isBack:(BOOL)isBack
{
    self.navigationController.navigationBar.barTintColor = kNavBarBgColor;//kRGB(26, 151, 251);
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;//UIBarStyleBlack;
    
    //self.title = title;
    self.navigationItem.title = title;
    if (isBack == YES) {
        UIImage *backImage = [UIImage imageNamed: @"小箭头左边"];
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

- (void)initBarRighBtnTitle:(NSString *)title target:(nullable id)target action:(nullable SEL)action
{
    CGFloat width = [NSString getWidthWithText:title font:[UIFont boldSystemFontOfSize: 15] height:30*KFitHeightRate];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0,  width,  30 * KFitHeightRate)];//50 * KFitWidthRate
    if (title.length > 4) {
        //rightBtn.width = 100 * KFitWidthRate;
    }
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 15];
    [rightBtn setTitle: title forState: UIControlStateNormal];
    [rightBtn setTitle: title forState: UIControlStateHighlighted];
    [rightBtn setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:kAppMainColor forState:UIControlStateHighlighted];
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
    [rightBtn setTitleColor: kRGB(26, 151, 251) forState: UIControlStateNormal];
    [rightBtn setTitleColor: kRGB(26, 151, 251) forState: UIControlStateHighlighted];
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
    self.view.backgroundColor = kRGB(247, 247, 247);
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
        _tableView.backgroundColor = kBackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (CBNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[CBNoDataView alloc] initWithGrail];
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
- (CBNetworkBadView *)noNetworkView {
    if (!_noNetworkView) {
        _noNetworkView = [[CBNetworkBadView alloc] initWithGrail];
        [self.tableView addSubview:_noNetworkView];
        _noNetworkView.center = self.tableView.center;
        _noNetworkView.hidden = YES;
        kWeakSelf(self);
        [_noNetworkView mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf(self);
            make.size.mas_equalTo(CGSizeMake(200, 200));
            make.centerX.equalTo(self.tableView.mas_centerX);
            make.centerY.equalTo(self.tableView.mas_centerY).offset(-20);
        }];
    }
    return _noNetworkView;
}
- (void)hiddenPromptView:(BOOL)isHidden {
    self.noDataView.hidden = isHidden;
    self.noNetworkView.hidden = isHidden;
}
#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return (self.navigationController.viewControllers.count > 1);
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return (self.navigationController.viewControllers.count > 1);
}
@end
