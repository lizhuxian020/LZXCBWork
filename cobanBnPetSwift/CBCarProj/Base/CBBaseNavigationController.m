//
//  CBBaseNavigationController.m
//  Telematics
//
//  Created by coban on 2019/7/17.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBBaseNavigationController.h"

@interface CBBaseNavigationController ()<UINavigationControllerDelegate>

@end
@implementation CBBaseNavigationController
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    UIViewController* topVC = self.topViewController;
//    return [topVC preferredStatusBarStyle];
//}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;

    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *app = [UINavigationBarAppearance new];
        [app configureWithOpaqueBackground];  // 重置背景和阴影颜色
        [app setTitleTextAttributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:18],
            NSForegroundColorAttributeName: UIColor.whiteColor
        }];
        app.backgroundColor = [UIColor colorWithHexString:@"#2E2F41"];
        [app setShadowColor:UIColor.clearColor];
        [[UINavigationBar appearance] setScrollEdgeAppearance:app];
        [[UINavigationBar appearance] setStandardAppearance:app];
    }
}
- (void)dealloc {
    self.navigationController.delegate = nil;
}
#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    
}
#pragma mark - UINavigationControllerDelegate
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // 判断如果是需要隐藏导航控制器的类，则隐藏
//    BOOL isHideNav = ([viewController isKindOfClass:[BDTMineController class]]  ||
//                      [viewController isKindOfClass:[BDTGoodsDetailViewController class]] //||
//                      //                      [viewController isKindOfClass:[HHMyAdvertismentSingleVC class]] ||
//                      //                      [viewController isKindOfClass:[HHMineViewController class] ]||
//                      //                      [viewController isKindOfClass:[HHHomeViewController class]] ||
//                      //                      [viewController isKindOfClass:[HHTransactionViewController class]] ||
//                      //                      [viewController isKindOfClass:[HHAssetsHomeViewController class]]
//
//                      //                        [viewController isKindOfClass:[HHMineViewController class]] ||
//                      //                        [viewController isKindOfClass:[HHMineViewController class]] ||
//                      //                        [viewController isKindOfClass:[HHMineViewController class]] ||
//                      //                        [viewController isKindOfClass:[HHMineViewController class]] ||
//                      //                        [viewController isKindOfClass:[HHMineViewController class]] ||
//                      //                        [viewController isKindOfClass:[HHMineViewController class]] ||
//                      //                        [viewController isKindOfClass:[HHMineViewController class]] ||
//                      //                        [viewController isKindOfClass:[HHMineViewController class]]
//                      );
//
//    [self setNavigationBarHidden:isHideNav animated:YES];
//}
@end
