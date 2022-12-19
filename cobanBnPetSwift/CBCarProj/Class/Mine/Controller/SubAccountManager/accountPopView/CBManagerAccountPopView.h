//
//  CBManagerAccountPopView.h
//  Telematics
//
//  Created by coban on 2019/12/25.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubAccountModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CBManagerAccountPopViewDelegate <NSObject>

- (void)accountPopViewClickType:(NSInteger)index;

@end

@interface CBManagerAccountPopView : UIView
@property (nonatomic,strong) UITableView *deviceTableView;
@property (nonatomic,weak) id<CBManagerAccountPopViewDelegate> delegate;
@property (nonatomic,copy) void(^popViewBlock)(id objc);
- (void)popView:(SubAccountModel *)subDeviceModel;//弹出视图
- (void)certain;
@end

NS_ASSUME_NONNULL_END
