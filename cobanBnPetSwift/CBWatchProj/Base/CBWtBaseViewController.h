//
//  CBWtBaseViewController.h
//  Telematics
//
//  Created by lym on 2017/10/24.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBWtNoDataView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBWtBaseViewController : UIViewController
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic,strong) CBWtNoDataView *noDataView;

//- (BOOL)checkLogionState;
- (UIViewController *_Nullable)getCurrentVC;
- (void)setTitleColor:(UIColor *_Nullable)color;
- (void)initBarWithImage:(NSString *_Nullable)image isBack:(BOOL)isBack;
- (void)initBarWithTitle:(NSString *_Nullable)title isBack:(BOOL)isBack;
- (void)initBarRightImageName:(nullable NSString *)name target:(nullable id)target action:(nullable SEL)action;
- (void)initBarLeftImageName:(nullable NSString *)name title:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action;
- (void)initBarRighBtnTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action;
- (void)initBarRighBtnTitle:(NSString *)title selectTitle:(NSString *)selectTitle target:(nullable id)target action:(nullable SEL)action;
- (void)initBarRighWhiteBackBtnTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action;
- (void)showBackGround;
- (void)popToControllerClass:(__unsafe_unretained Class _Nullable )controllerClass;
@end

NS_ASSUME_NONNULL_END
