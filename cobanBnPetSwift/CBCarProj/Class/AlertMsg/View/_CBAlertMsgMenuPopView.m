//
//  _CBAlertMsgMenuPopView.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/26.
//  Copyright © 2022 coban. All rights reserved.
//

#import "_CBAlertMsgMenuPopView.h"

@interface _CBAlertMsgMenuPopView ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation _CBAlertMsgMenuPopView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.frame = UIScreen.mainScreen.bounds;
    kWeakSelf(self);
    [self bk_whenTapped:^{
        [weakself dismiss];
    }];
    
    self.contentView = [UIView new];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
//        make.width.height.equalTo(@210);
    }];
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.contentView.alpha = 0;
    self.contentView.layer.borderColor = KCarLineColor.CGColor;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    
    UIView *allRead = [self viewWithImg:@"一键确认报警" title:Localized(@"全部已读")];
    [self.contentView addSubview:allRead];
    [allRead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
    }];
    
    UIView *checkAll = [self viewWithImg:@"查看全部报警" title:Localized(@"查看所有报警")];
    [self.contentView addSubview:checkAll];
    [checkAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(allRead.mas_bottom);
    }];
    
    [allRead bk_whenTapped:^{
        [weakself dismiss];
        weakself.didClick();
    }];
    
    [checkAll bk_whenTapped:^{
        [weakself dismiss];
        weakself.didClickCheck();
    }];
    
    [self layoutIfNeeded];
}

- (UIView *)viewWithImg:(NSString *)imgName title:(NSString *)title {
    UIView *c = [UIView new];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    [c addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.width.height.equalTo(@15);
        make.bottom.equalTo(@-10);
    }];
    UILabel *lbl = [MINUtils createLabelWithText:title size:14 alignment:NSTextAlignmentLeft textColor:UIColor.blackColor];
    [c addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgV);
        make.right.equalTo(@-10);
        make.left.equalTo(imgV.mas_right).mas_offset(5);
    }];
    return c;
}

- (void)pop {
    NSLog(@"%s", __FUNCTION__);
    
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(PPNavigationBarHeight));
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.alpha = 1;
        [self layoutIfNeeded];
    }];
}

- (void)dismiss {
    NSLog(@"%s", __FUNCTION__);
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
@end
