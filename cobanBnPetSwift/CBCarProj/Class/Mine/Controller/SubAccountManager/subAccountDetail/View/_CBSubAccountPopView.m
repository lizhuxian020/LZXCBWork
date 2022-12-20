//
//  _CBSubAccountPopView.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/19.
//  Copyright © 2022 coban. All rights reserved.
//

#import "_CBSubAccountPopView.h"

@interface _CBSubAccountPopView ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation _CBSubAccountPopView

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
    
    NSArray *titleArr = @[Localized(@"编辑"), Localized(@"权限查看"), Localized(@"修改密码"), Localized(@"删除")];
    NSArray *imgArr = @[@"编辑-黑色",@"设置权限",@"修改密码",@"删除-黑色"];
    
    UIView *lastView = nil;
    for (int i = 0; i < titleArr.count; i++) {
        UIView *view = [self viewWithImg:imgArr[i] title:titleArr[i]];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            } else {
                make.top.equalTo(@0);
            }
            make.left.right.equalTo(@0);
        }];
        lastView = view;
        [view bk_whenTapped:^{
            [weakself clickBtn:i];
            [weakself dismiss];
        }];
    }
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
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

- (void)clickBtn:(int)index {
    _didClick(index);
}
@end
