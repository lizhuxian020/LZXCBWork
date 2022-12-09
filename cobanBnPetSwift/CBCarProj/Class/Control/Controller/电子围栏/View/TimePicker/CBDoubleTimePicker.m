//
//  CBDoubleTimePicker.m
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/9.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBDoubleTimePicker.h"

@interface CBDoubleTimePicker ()

@property (nonatomic, strong) NSMutableArray *hourArr;

@property (nonatomic, strong) NSMutableArray *minArr;
@end

@implementation CBDoubleTimePicker

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hourArr = [NSMutableArray new];
        for (int i = 0; i < 24; i++) {
            NSString *hour = [NSString stringWithFormat:@"%02d", i];
            [self.hourArr addObject:hour];
        }
        self.minArr = [NSMutableArray new];
        for (int i = 0; i < 60; i++) {
            NSString *min = [NSString stringWithFormat:@"%02d", i];
            [self.minArr addObject:min];
        }
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 6;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 1 || component == 4) {
        return 1;
    }
    if (component == 0 || component == 3) {
        return self.hourArr.count;
    }
    return self.minArr.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *lbl = [UILabel new];
    if (component == 1 || component == 4) {
        lbl.text = @":";
        lbl.textAlignment = NSTextAlignmentCenter;
    }
    if (component == 0 || component == 3) {
        lbl.text = self.hourArr[row];
        lbl.textAlignment = NSTextAlignmentRight;
    }
    if (component == 2 || component == 5) {
        lbl.text = self.minArr[row];
    }
    return lbl;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 1 || component == 4) {
        return 10;
    }
    if (component == 2 || component == 3) {
        return (SCREEN_WIDTH - 2*10) * 0.2;
    }
    return (SCREEN_WIDTH - 2*10) * 0.3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}
@end
