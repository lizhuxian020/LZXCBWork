//
//  CBAlertBaseView.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/23.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBAlertBaseView : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) NSString *confirmText;
@property (nonatomic, copy) void (^didClickConfirm)(void);
@property (nonatomic, copy) void (^didClickCancel)(void);
- (instancetype)initWithContentView:(UIView *)contentView title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
