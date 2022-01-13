//
//  MINListHeaderView.h
//  Telematics
//
//  Created by lym on 2017/12/12.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MINListHeaderView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *arrowImageBtn;
@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, copy) void (^headerBtnClick)(NSInteger section);
@end
