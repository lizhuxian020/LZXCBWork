//
//  _CBTSTChooseTimeView.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/24.
//  Copyright © 2022 coban. All rights reserved.
//

#import "_CBTSTChooseTimeView.h"

@interface _CBTSTChooseTimeView ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *contentLbl;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, assign) int lastDays;
@end

@implementation _CBTSTChooseTimeView

- (instancetype)initWithTitle:(NSString *)title last:(int)lastDays{
    self = [super init];
    if (self) {
        _lastDays = lastDays;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.titleLbl = [MINUtils createLabelWithText:@"开始时间" size:17 alignment:NSTextAlignmentCenter textColor:kCellTextColor];
    [self addSubview:self.titleLbl];

    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0);
    }];
    [self.titleLbl setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    self.contentLbl = [MINUtils createLabelWithText:@"2022-22-22 22:22:22" size:17 alignment:NSTextAlignmentCenter textColor:UIColor.lightGrayColor];
    [self addSubview:self.contentLbl];
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(@0);
        make.left.equalTo(self.titleLbl.mas_right).mas_offset(20);
        make.height.equalTo(@40);
    }];
    self.contentLbl.layer.borderWidth = 1;
    self.contentLbl.layer.cornerRadius = 5;
    self.contentLbl.layer.borderColor = KCarLineColor.CGColor;
    self.contentLbl.userInteractionEnabled = YES;


    self.textView = [UITextView new];
    [self addSubview:self.textView];
    self.textView.hidden = YES;

    UIDatePicker *picker = [UIDatePicker new];
    [picker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    if (@available(iOS 13.4, *)) {
        picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
    self.textView.inputView = picker;


    kWeakSelf(self);
    [self.contentLbl bk_whenTapped:^{
        NSLog(@"%s", __FUNCTION__);
        [weakself.textView becomeFirstResponder];
    }];
    
    [self inactivate];
    NSDate *lastDate = [NSDate.date dateByAddingTimeInterval:-24*60*60*_lastDays];
    picker.date = lastDate;
    [self dateChange:picker];
}

- (void)dateChange:(UIDatePicker *)sender {
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*3600];
    [formatter setTimeZone:timeZone];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    
    NSString *str = [formatter stringFromDate: sender.date];
    self.contentLbl.text = str;
}

- (void)activate {
    self.userInteractionEnabled = YES;
    self.contentLbl.textColor = kCellTextColor;
}

- (void)inactivate {
    self.userInteractionEnabled = NO;
    self.contentLbl.textColor = UIColor.lightGrayColor;
}

- (NSString *)timeStr {
    return self.contentLbl.text;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
