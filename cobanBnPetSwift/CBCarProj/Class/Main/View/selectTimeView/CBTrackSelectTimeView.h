//
//  CBTrackSelectTimeView.h
//  Telematics
//
//  Created by coban on 2019/8/1.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBTrackSelectTimeView : UIView

@property (nonatomic,copy) void (^tapClickBlock)(id obj);
@property (nonatomic,copy) void (^btnClickBlick)(id obj);
@property (nonatomic,copy) NSString *dno;
@property (nonatomic,copy) NSString *dateStrStar;
@property (nonatomic,copy) NSString *dateStrEnd;
- (void)popView;//弹出视图
- (void)dismiss;//隐藏视图
@end

NS_ASSUME_NONNULL_END
