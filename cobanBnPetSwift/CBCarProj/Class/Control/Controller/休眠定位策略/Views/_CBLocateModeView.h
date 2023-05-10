//
//  _CBLocateModeView.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/30.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiLocationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface _CBLocateModeView : UIView

@property (nonatomic, strong) MultiLocationModel *locationModel;

- (NSNumber *)getSpeed;
- (NSNumber *)getReportWay;
- (NSString *)getTimeQSUnit;
- (NSNumber *)getTimeQS;
- (NSString *)getTimeRestUnit;
- (NSNumber *)getTimeRest;

- (BOOL)isALess5Min;
- (BOOL)isBLess5Min;
@end

NS_ASSUME_NONNULL_END
