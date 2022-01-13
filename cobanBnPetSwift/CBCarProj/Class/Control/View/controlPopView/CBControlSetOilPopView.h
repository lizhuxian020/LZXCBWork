//
//  CBControlSetOilPopView.h
//  Telematics
//
//  Created by coban on 2019/11/22.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CBControlSetOilPopViewDelegate <NSObject>

- (void)selectOilValueType:(NSString *)oilVale;

@end

@interface CBControlSetOilPopView : UIView

@property (nonatomic,weak) id <CBControlSetOilPopViewDelegate>delegate;

- (void)popView;//弹出视图
- (void)dismiss;//隐藏视图

@end

NS_ASSUME_NONNULL_END
