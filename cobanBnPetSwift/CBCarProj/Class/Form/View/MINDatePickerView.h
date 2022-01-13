//
//  MINDatePickerView.h
//  Telematics
//
//  Created by lym on 2017/11/16.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MINDatePickerView;
@protocol MINDatePickerViewDelegare <NSObject>

@optional
- (void)datePicker:(MINDatePickerView *)pickerView didSelectordate:(NSString *)dateString date:(NSDate *)date;

@end


@interface MINDatePickerView : UIView
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, weak) id<MINDatePickerViewDelegare> delegate;

- (void)showView;
- (void)hideView;
@end
