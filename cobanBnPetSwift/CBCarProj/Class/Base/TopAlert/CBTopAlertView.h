//
//  CBTopAlertView.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/3.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBTopAlertView : UIView

+ (void)alertSuccess:(NSString *)title;
+ (void)alertFail:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
