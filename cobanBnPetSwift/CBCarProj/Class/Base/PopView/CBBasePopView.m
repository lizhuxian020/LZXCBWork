//
//  CBBasePopView.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/23.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBBasePopView.h"

@interface CBBasePopView ()

@property (nonatomic,strong) UIView *bgmView;

@end

@implementation CBBasePopView

- (instancetype)initWithContentView:(UIView *)content {
    self = [super init];
    if (self) {
        self.contentView = content;
        [self createUI];
    }
    return  self;;
}

- (void)createUI {
    self.frame = UIScreen.mainScreen.bounds;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
    kWeakSelf(self);
    [self bk_whenTapped:^{
        [weakself dismiss];
    }];
    [self.contentView bk_whenTapped:^{
        NSLog(@"%s", __FUNCTION__);
    }];
    
    CGFloat horMargin = 30;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(horMargin));
        make.right.equalTo(@(-horMargin));
        make.centerY.equalTo(@-100);
    }];
    self.contentView.alpha = 0;
    
    [self layoutIfNeeded];
}

- (void)pop {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.alpha = 1;
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        [self layoutIfNeeded];
    }];
}

-(void)dismiss {
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@-100);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.alpha = 0;
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end
