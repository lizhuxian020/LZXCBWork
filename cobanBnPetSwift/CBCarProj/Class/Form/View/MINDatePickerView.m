//
//  MINDatePickerView.m
//  Telematics
//
//  Created by lym on 2017/11/16.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MINDatePickerView.h"

@interface MINDatePickerView()
{
    UIView *contentView; // 显示pickerView和titleView的地方
    UIView *titleView; // 显示title和cancel、confirm的地方
    UIView *backView; // 背景
}
@end

@implementation MINDatePickerView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
        [self addAction];
    }
    return self;
}

- (void)showView
{
    if (contentView != nil) {
        self.hidden = NO;
        [contentView.superview layoutIfNeeded];
        [UIView animateWithDuration: 0.3 animations:^{
            [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(backView.mas_bottom).with.offset(-265 * KFitHeightRate);
            }];
            [contentView.superview layoutIfNeeded];
        }];
    }
}

- (void)hideView
{
    if (contentView != nil) {
        [contentView.superview layoutIfNeeded];
        [UIView animateWithDuration: 0.3 animations:^{
            [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(backView.mas_bottom);
            }];
            [contentView.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            //[self removeFromSuperview];
            self.hidden = YES;
        }];
    }
}

#pragma mark - createUI
- (void)createUI
{
    [self createBackViewAndContentView];
    [self createTitleView];
    [self createPickerView];
}

- (void)createPickerView
{
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    NSDate* minDate = [NSDate dateWithTimeIntervalSince1970: 24 * 60 * 60 * 365 * 70];
    NSDate* maxDate = [NSDate dateWithTimeIntervalSinceNow: 0];
    [_datePicker setDate: maxDate];
    [_datePicker setMinimumDate: minDate];
    [_datePicker setMaximumDate: maxDate];
    [contentView addSubview: _datePicker];
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(contentView);
        make.top.equalTo(titleView.mas_bottom);
    }];
}

- (void)createTitleView
{
    titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview: titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(contentView);
        make.height.mas_equalTo(50 * KFitHeightRate);
    }];
    _cancelBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"取消") titleColor: kCellTextColor fontSize: 15 * KFitWidthRate];
    [titleView addSubview: _cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(titleView);
        make.width.mas_equalTo(50 * KFitWidthRate);
    }];
    _confirmBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"完成") titleColor: kCellTextColor fontSize: 15 * KFitWidthRate];
    [titleView addSubview: _confirmBtn];
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(titleView);
        make.width.mas_equalTo(50 * KFitWidthRate);
    }];
    UIView *lineView = [MINUtils createLineView];
    [titleView addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(titleView);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(titleView).with.offset(-0.5);
    }];
}

- (void)createBackViewAndContentView
{
    backView = [[UIView alloc] init];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.3];
    [self addSubview: backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [backView addSubview: contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(backView.mas_bottom);
        make.height.mas_equalTo(265 * KFitHeightRate);
    }];
}



#pragma mark - Btn Action
- (void)addAction
{
    [self.cancelBtn addTarget: self action: @selector(cancelBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.confirmBtn addTarget: self action: @selector(confirmBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)cancelBtnClick
{
    [self hideView];
}

- (void)confirmBtnClick
{
    [self hideView];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
//    // 设置为东八区时区
//    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*3600];
//    [formatter setTimeZone:timeZone];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate: self.datePicker.date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate: self.datePicker.date]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate: self.datePicker.date] integerValue];
    NSString *dateString = [NSString stringWithFormat: @"%ld-%02ld-%02ld", currentYear, currentMonth, currentDay];
    if (self.delegate && [self.delegate respondsToSelector: @selector(datePicker:didSelectordate:date:)]) {
        [self.delegate datePicker: self didSelectordate: dateString date:self.datePicker.date];
    }
}

@end
