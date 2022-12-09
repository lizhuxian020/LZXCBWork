//
//  MINPickerView.h
//  Telematics
//
//  Created by lym on 2017/11/1.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MINPickerView;

@protocol MINPickerViewDelegate <NSObject>

@optional
- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic;
- (void)minPickerViewdidSelectCancelBtn:(MINPickerView *)pickerView;
- (void)minPickerView:(MINPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end

@interface MINPickerView : UIView

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) NSInteger flag; // 标志
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, weak) id<MINPickerViewDelegate> delegate;
@property (nonatomic, assign) BOOL isPicturePickerView;

@property (nonatomic, copy) void(^didClickConfirm)(UIPickerView *pickerView);
- (void)showView;
- (void)hideView;

- (void)updateData:(NSArray *)data;
@end
