//
//  CBWtBaseNavigationController.m
//  Telematics
//
//  Created by coban on 2019/7/17.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBWtBaseNavigationController.h"

@interface CBWtBaseNavigationController ()<UINavigationControllerDelegate>

@end
@implementation CBWtBaseNavigationController
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
}
- (void)dealloc {
    self.navigationController.delegate = nil;
}
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    
}
#pragma mark - UINavigationControllerDelegate
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // 判断如果是需要隐藏导航控制器的类，则隐藏
//    BOOL isHideNav = ([viewController isKindOfClass:[BDTMineController class]]  ||
//                      [viewController isKindOfClass:[BDTGoodsDetailViewController class]] //||
//                      //                      [viewController isKindOfClass:[HHMyAdvertismentSingleVC class]] ||
//                      //                      [viewController isKindOfClass:[HHMineViewController class] ]||
//                      //                      [viewController isKindOfClass:[HHCBWtHomeViewController class]] ||
//                      //                      [viewController isKindOfClass:[HHTransactionViewController class]] ||
//                      //                      [viewController isKindOfClass:[HHAssetsCBWtHomeViewController class]]
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
