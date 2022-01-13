//
//  CBFriendListFootView.h
//  Watch
//
//  Created by coban on 2019/8/27.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBFriendListFootView : UIView
@property (nonatomic, copy) void (^checkAllBtnClickBlock)(BOOL isSelected);
@property (nonatomic, copy) void (^deleteBtnClickBlock)(void);
@end

NS_ASSUME_NONNULL_END
