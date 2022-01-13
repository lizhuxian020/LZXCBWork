//
//  CBAvatarMarkView.h
//  Watch
//
//  Created by coban on 2019/9/17.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBAvatarMarkView : UIView

@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, copy) NSString *statusStr;
@property (nonatomic, strong) HomeModel *homeModel;

@end

NS_ASSUME_NONNULL_END
