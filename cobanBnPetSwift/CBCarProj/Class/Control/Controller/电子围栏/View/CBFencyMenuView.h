//
//  CBFencyMenuView.h
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/9.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FenceListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBFencyMenuView : UIView

@property (nonatomic, strong) FenceListModel *model;

- (NSString *)getDeviceArr;
- (NSString *)getDeviceName;
- (NSString *)getFenceName;
@end

NS_ASSUME_NONNULL_END
