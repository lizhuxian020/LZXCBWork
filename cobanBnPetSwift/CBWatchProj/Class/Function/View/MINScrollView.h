//
//  MINScrollView.h
//  Watch
//
//  Created by lym on 2018/2/9.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 创建好这个MINScrollView之后，需要调整约束
 [self.scrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(bottomView.mas_bottom).with.offset(12.5 * KFitHeightRate);
 }];
 */

@interface MINScrollView : UIView
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@end
