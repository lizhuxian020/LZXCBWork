//
//  MainTabBarViewController.m
//  Telematics
//
//  Created by lym on 2017/10/25.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "MineViewController.h"
#import "FormViewController.h"
#import "ContorlViewController.h"
#import "MainMapViewController.h"

#import "CBBaseNavigationController.h"
#import "cobanBnPetSwift-Swift.h"
#import "NotificationKey.h"

@interface MainTabBarViewController () <UIGestureRecognizerDelegate>

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadViewControllers];
    [self createUI];
    [self addLongPressed];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textColorChangeNotification) name:K_TabBarColorChangeNotification object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)textColorChangeNotification {
    NSString *imageNorlStr_control;
    UIColor *normalColor_control;
    NSString *imageNorlStr_form;
    UIColor *normalColor_form;
    //UserLoginModel *userLogin = [UserLoginModel CBaccount];
    CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
    CBHomeLeftMenuDeviceInfoModel *deviceModelInfo = [CBCommonTools CBdeviceInfo];
    // 没有选中
    if (deviceModelInfo == nil) {
        imageNorlStr_control = @"控制";
        normalColor_control = RGB(210, 210, 210);
        imageNorlStr_form = @"报表";
        normalColor_form = RGB(210, 210, 210);
    } else {
        // 0为查看权限
        if ([userModel.auth isEqualToString:@"0"]) { //|| kStringIsEmpty(userLogin.auth)
            imageNorlStr_control = @"控制";
            normalColor_control = RGB(210, 210, 210);
            imageNorlStr_form = @"报表";
            normalColor_form = RGB(210, 210, 210);
        } else {
            imageNorlStr_control = @"控制";
            normalColor_control = kRGB(137, 137, 137);
            imageNorlStr_form = @"报表";
            normalColor_form = kRGB(137, 137, 137);
        }
    }
    ContorlViewController *ControlVC = self.viewControllers[1];
    FormViewController *formVC = self.viewControllers[2];
    ControlVC.tabBarItem = [self controller:ControlVC
                                      title:Localized(@"控制")
                                       size:12
                              selectedImage:@"控制-选中状态"
                              selectedColor:kRGB(26, 151, 251)
                                normalImage:imageNorlStr_control
                                normalColor:normalColor_control];
    formVC.tabBarItem = [self controller:formVC title:Localized(@"报表") size:12 selectedImage:@"报表-选中" selectedColor:kRGB(26, 151, 251) normalImage:imageNorlStr_form normalColor:normalColor_form];
    
    [self setUpTabBarItem:ControlVC selectedColor:kRGB(26, 151, 251) normalColor:normalColor_control];
    [self setUpTabBarItem:formVC selectedColor:kRGB(26, 151, 251) normalColor:normalColor_form];
}
- (void)addLongPressed {
    UILongPressGestureRecognizer *longRecog = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressed:)];
    longRecog.delegate = self;
    [self.tabBar addGestureRecognizer: longRecog];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // This will ensure the long press only occurs for the
    // tab bar item which has it's tag set to 1.
    // You can set this in Interface Builder or in code
    // wherever you are creating your tabs.
    if (self.tabBar.selectedItem.tag == 1) {
        return YES;
    } else {
        return NO;
    }
}

-(void)longPressed:(UILongPressGestureRecognizer *)press{
    //Long pressed Occures
    [[NSNotificationCenter defaultCenter] postNotificationName: kTabbarItemLongPress object: nil];
}

- (void)createUI
{
//    self.tabBar.backgroundColor = kRGB(255, 255, 255);
    self.tabBar.backgroundColor = kNavBarBgColor;
}

- (void)loadViewControllers {
    
    UIColor *normalColor = kTextFieldColor;
    UIColor *selectedColor = UIColor.whiteColor;
    
    
    MainMapViewController *locationVC = [[MainMapViewController alloc] init];
    CBBaseNavigationController *locationNavControl = [[CBBaseNavigationController alloc] initWithRootViewController: locationVC];
    locationVC.tabBarItem = [self controller:locationVC title:Localized(@"首页") size:12 selectedImage:@"定位-选中状态" normalImage:@"定位"];
//    CBPetLoginModel *userLogin = [CBPetLoginModelTool getUser];
//    CBHomeLeftMenuDeviceInfoModel *deviceModelInfo = [CBCommonTools CBdeviceInfo];
//    // 没有选中
//    if (deviceModelInfo == nil) {
//        imageNorlStr_control = @"控制";
//        normalColor_control = RGB(210, 210, 210);
//        imageNorlStr_form = @"报表";
//        normalColor_form = RGB(210, 210, 210);
//    } else {
//        // 0为查看权限
//        if ([userLogin.auth isEqualToString:@"0"]) { //|| kStringIsEmpty(userLogin.auth)
//            imageNorlStr_control = @"控制";
//            normalColor_control = RGB(210, 210, 210);
//            imageNorlStr_form = @"报表";
//            normalColor_form = RGB(210, 210, 210);
//        } else {
//            imageNorlStr_control = @"控制";
//            normalColor_control = kRGB(137, 137, 137);
//            imageNorlStr_form = @"报表";
//            normalColor_form = kRGB(137, 137, 137);
//        }
//    }
    ContorlViewController *ControlVC = [[ContorlViewController alloc] init];
    CBBaseNavigationController *ControlNavControl = [[CBBaseNavigationController alloc] initWithRootViewController: ControlVC];
    ControlVC.tabBarItem = [self controller:ControlVC
                                      title:Localized(@"电子围栏")
                                       size:12
                              selectedImage:@"控制-选中状态"
                                normalImage:@"控制"];
    
    FormViewController *formVC = [[FormViewController alloc] init];
    CBBaseNavigationController *formNavControl = [[CBBaseNavigationController alloc] initWithRootViewController: formVC];
    formVC.tabBarItem = [self controller:formVC
                                   title:Localized(@"报表")
                                    size:12
                           selectedImage:@"报表-选中"
                            normalImage:@"报表"];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    CBBaseNavigationController *mineNavControl = [[CBBaseNavigationController alloc] initWithRootViewController: mineVC];
    mineVC.tabBarItem = [self controller:mineVC
                                   title:Localized(@"我的")
                                    size:12
                           selectedImage:@"我的-选中"
                             normalImage:@"我的"];
    
    NSArray *controllersArrs = @[locationNavControl, ControlNavControl, formNavControl, mineNavControl];
    self.viewControllers = controllersArrs;
    
    [self setUpTabBarItem:locationVC selectedColor:selectedColor normalColor:normalColor];
    [self setUpTabBarItem:ControlVC selectedColor:selectedColor normalColor:normalColor];
    [self setUpTabBarItem:formVC selectedColor:selectedColor normalColor:normalColor];
    [self setUpTabBarItem:mineVC selectedColor:selectedColor normalColor:normalColor];
}
- (UITabBarItem *)controller:(UIViewController *)controller
             title:(NSString *)title
              size:(CGFloat)size
     selectedImage:(NSString *)selectedImage
       normalImage:(NSString *)normalImage {
    controller.title = title;
    UIImage *imageSelect = [UIImage imageNamed:selectedImage];
    UIImage *imageNormal = [UIImage imageNamed:normalImage];
    imageSelect = [imageSelect imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageNormal = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:imageNormal selectedImage:imageSelect];
    /* iOS13以上，设置颜色 UITabBarItem 的 standardAppearance 属性设置*/
//    if (@available(iOS 13.0, *)) {
//        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
//        // 未选中时候标题颜色
//        appearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:UIColor.redColor};
//        // 选中时候标题的颜色
//        appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:selectedColor};
//        //tabBarItem.standardAppearance = appearance;
//        //self.tabBar.standardAppearance = appearance;
//        controller.tabBarItem.standardAppearance = appearance;
//    } else {
//        // Fallback on earlier versions
//        [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size],NSForegroundColorAttributeName:selectedColor} forState:UIControlStateSelected];
//        [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size],NSForegroundColorAttributeName:normalColor} forState:UIControlStateNormal];
//    }
    return tabBarItem;
}
- (void)setUpTabBarItem:(UIViewController *)controller
                 selectedColor:(UIColor *)selectedColor
                   normalColor:(UIColor *)normalColor {
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        // 未选中时候标题颜色
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:normalColor};
        // 选中时候标题的颜色
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:selectedColor};
        UITabBarAppearance *appearanceccccc = [[UITabBarAppearance alloc] initWithBarAppearance:appearance];
        controller.tabBarItem.standardAppearance = appearanceccccc;//appearance;

    } else {
        // Fallback on earlier versions
        [controller.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:selectedColor} forState:UIControlStateSelected];
        [controller.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:normalColor} forState:UIControlStateNormal];
    }
}
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
