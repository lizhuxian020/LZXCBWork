//
//  CBTopAlertView.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/3.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBTopAlertView.h"

@interface CBTopAlertView ()


@property (nonatomic, assign) BOOL isSuccess;

@property(nonatomic, copy) NSString *title;

@end

@implementation CBTopAlertView

- (instancetype)initWithTitle:(NSString *)title isSuccess:(BOOL)isSuccess {
    self = [super init];
    if (self) {
        self.title = title;
        self.isSuccess = isSuccess;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.frame = CGRectMake(0, -PPNavigationBarHeight, SCREEN_WIDTH, PPNavigationBarHeight);
    self.backgroundColor = _isSuccess ? UIColor.blueColor : UIColor.redColor;
    
    UILabel *lbl = [MINUtils createLabelWithText:_title size:20 alignment:NSTextAlignmentLeft textColor:UIColor.whiteColor];
    lbl.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    [self addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-10);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
    }];
    lbl.numberOfLines = 2;
}

- (void)pop {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
    
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, PPNavigationBarHeight);
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, -PPNavigationBarHeight, SCREEN_WIDTH, PPNavigationBarHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (void)alertSuccess:(NSString *)title {
    CBTopAlertView *view = [[CBTopAlertView alloc] initWithTitle:title isSuccess:YES];
    [view pop];
}
+ (void)alertFail:(NSString *)title {
    CBTopAlertView *view = [[CBTopAlertView alloc] initWithTitle:title isSuccess:NO];
    [view pop];
}

@end
