//
//  MINClickCellView.h
//  Watch
//
//  Created by lym on 2018/2/8.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MINClickCellView : UIView
@property (nonatomic, strong) UIImageView *leftImageView; // 左边头像
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIButton *clickBtn;
@property (nonatomic, copy) void (^clickBtnClickBlock)(void);
- (void)setLeftImageUrlString:(NSString *)leftImageUrlStirng rightLabelText:(NSString *)text;
- (void)setLeftLabelText:(NSString *)leftText rightLabelText:(NSString *)rightText;
- (void)addBottomLine;
@end
