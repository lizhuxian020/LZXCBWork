//
//  _CBSubAccountPopView.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/19.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface _CBSubAccountPopView : UIView

@property (nonatomic, copy) void (^didClick)(void);

@property (nonatomic, copy) void (^didClickCheck)(void);

- (void)pop;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
