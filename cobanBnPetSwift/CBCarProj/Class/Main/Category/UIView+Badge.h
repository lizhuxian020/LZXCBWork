//
//  UIView+Badge.h
//  Base
//
//  Created by Main on 2020/11/19.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN


/// 这个是角标的view
@interface BadgeView : UIView
@property (nonatomic, copy) NSString *text;
@end

/*
 默认@"0",@"",nil的时候不显示,
 badgeContraintMaker用来设置红点约束
 */
@interface UIView (Badge)

@property (nonatomic, strong) BadgeView *BadgeView;

@property (nonatomic, copy) NSString *BadgeValue;

@property (nonatomic, assign) double BadgeHeight;

@property (nonatomic, copy) void (^badgeContraintMaker)(MASConstraintMaker *make, BadgeView *badgeView, UIView* container);

@end

NS_ASSUME_NONNULL_END
