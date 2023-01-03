//
//  CBPhoneBookAlertView.h
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/3.
//  Copyright © 2023 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBPhoneBookAlertView : UIView

@property (nonatomic, strong) PhoneBookModel *phoneModel;

- (BOOL)canDismiss;

- (NSDictionary *)getRequestParam;

@end

NS_ASSUME_NONNULL_END
