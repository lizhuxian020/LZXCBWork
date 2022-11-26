//
//  _CBMyInfoPopView.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/26.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface _CBMyInfoPopView : UIView

@property (nonatomic, copy) void (^didClickPersonInfo)(void);
@property (nonatomic, copy) void (^didClickAbout)(void);
@property (nonatomic, copy) void (^didClickPwd)(void);
@property (nonatomic, copy) void (^didClickLogout)(void);

- (void)pop;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
