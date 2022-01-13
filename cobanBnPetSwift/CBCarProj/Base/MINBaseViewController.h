//
//  MINBaseViewController.h
//  Telematics
//
//  Created by lym on 2017/10/24.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBNoDataView.h"
#import "CBNetworkBadView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MINBaseViewController : UIViewController
@property (nonatomic, strong) UITableView * _Nonnull tableView;
@property (nonatomic,strong) CBNoDataView *noDataView;
@property (nonatomic,strong) CBNetworkBadView *noNetworkView;

- (void)hiddenPromptView:(BOOL)isHidden;
- (BOOL)checkLogionState;
- (UIViewController *)getCurrentVC;

- (void)initBarWithTitle:(NSString *)title isBack:(BOOL)isBack;
- (void)initBarRightImageName:(nullable NSString *)name target:(nullable id)target action:(nullable SEL)action;
- (void)initBarRighBtnTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action;
- (void)initBarRighBtnTitle:(NSString *)title selectTitle:(NSString *)selectTitle target:(nullable id)target action:(nullable SEL)action;
- (void)initBarRighWhiteBackBtnTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action;
- (void)showBackGround;
- (void)popToControllerClass:(__unsafe_unretained Class _Nullable )controllerClass;
@end


NS_ASSUME_NONNULL_END
