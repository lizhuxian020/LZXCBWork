//
//  CBHomeLeftMenuTableView.h
//  Telematics
//
//  Created by coban on 2019/7/18.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBHomeLeftMenuSliderModel;

NS_ASSUME_NONNULL_BEGIN

@interface CBHomeLeftMenuTableView : UITableView
@property (nonatomic,copy) void(^returnBlock)(id objc);
// 标记这个, 则该tableView有需要在特定情况下, 执行选中第一条
@property (nonatomic, assign) BOOL needToChooseFirst;
- (void)reloadDataWithModel:(CBHomeLeftMenuSliderModel *)model;
@end

NS_ASSUME_NONNULL_END
