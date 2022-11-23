//
//  _CBTSTChooseTimeView.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/24.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface _CBTSTChooseTimeView : UIView

- (instancetype)initWithTitle:(NSString *)title;

- (void)activate;
- (void)inactivate;

- (NSString *)timeStr;
@end

NS_ASSUME_NONNULL_END
