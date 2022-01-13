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
- (void)reloadDataWithModel:(CBHomeLeftMenuSliderModel *)model;
@end

NS_ASSUME_NONNULL_END
