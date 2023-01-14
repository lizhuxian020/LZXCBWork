//
//  CBFencyMenuView.m
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/9.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBFencyMenuView.h"
#import "MINPickerView.h"
#import "CBDoubleTimePicker.h"

@interface CBFencyMenuView ()

@property (nonatomic, strong) UILabel *fenceNameLbl;

@property (nonatomic, strong) UILabel *deviceNameLbl;

@property (nonatomic, strong) UISwitch *inSwitch;

@property (nonatomic, strong) UISwitch *outSwitch;

@property (nonatomic, strong) NSDate *alarm1StartTime;
@property (nonatomic, strong) NSDate *alarm1EndTime;
@property (nonatomic, strong) UILabel *alarm1TimeLbl;
@property (nonatomic, strong) UISwitch *alarm1Switch;

@property (nonatomic, strong) NSDate *alarm2StartTime;
@property (nonatomic, strong) NSDate *alarm2EndTime;
@property (nonatomic, strong) UILabel *alarm2TimeLbl;
@property (nonatomic, strong) UISwitch *alarm2Switch;

@property (nonatomic, strong) UITextField *overTF;
@property (nonatomic, strong) UISwitch *overSwitch;

@property (nonatomic, strong) NSArray *deviceArr;
@property (nonatomic, strong) NSArray *dnoArr;
@property (nonatomic, copy) NSString *currentSelectedDno;
@property (nonatomic, strong) CBDoubleTimePicker *timePickerDelegate;
@end

@implementation CBFencyMenuView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UILabel *lbl = nil;
    UIView *fenceView = [self viewWithTitle:Localized(@"围栏名称") placeholder:Localized(@"请输入") cLbl:&lbl];
    self.fenceNameLbl = lbl;
    [self addSubview:fenceView];
    [fenceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
    }];
    
    UIView *deviceView = [self viewWithTitle:Localized(@"关联设备") placeholder:Localized(@"请输入") cLbl:&lbl];
    self.deviceNameLbl = lbl;
    [self addSubview:deviceView];
    [deviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fenceView.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    
    UISwitch *switchView = nil;
    UIView *inView = [self viewWithTitle:Localized(@"进围栏报警") subView:nil  switchView:&switchView];
    self.inSwitch = switchView;
    [self addSubview:inView];
    [inView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceView.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    
    UIView *outView = [self viewWithTitle:Localized(@"出围栏报警") subView:nil switchView:&switchView];
    self.outSwitch = switchView;
    [self addSubview:outView];
    [outView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inView.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    
    UIView *alarm1SubView = [self timeView:&lbl];
    self.alarm1TimeLbl = lbl;
    UIView *alarm1View = [self viewWithTitle:Localized(@"时段1报警") subView:alarm1SubView switchView:&switchView];
    self.alarm1Switch = switchView;
    [self addSubview:alarm1View];
    [alarm1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(outView.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    
    UIView *alarm2SubView = [self timeView:&lbl];
    self.alarm2TimeLbl = lbl;
    UIView *alarm2View = [self viewWithTitle:Localized(@"时段2报警") subView:alarm2SubView switchView:&switchView];
    self.alarm2Switch = switchView;
    [self addSubview:alarm2View];
    [alarm2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alarm1View.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    
    UITextField *tf = nil;
    UIView *overSubView = [self speedView:&tf];
    self.overTF = tf;
    UIView *overView = [self viewWithTitle:Localized(@"超速报警") subView:overSubView switchView:&switchView];
    self.overSwitch = switchView;
    [self.overSwitch addTarget:self action:@selector(overOnChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:overView];
    [overView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alarm2View.mas_bottom);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    kWeakSelf(self);
    [fenceView bk_whenTapped:^{
        [weakself popFenceNameView];
    }];
    [deviceView bk_whenTapped:^{
        [weakself showSelectDevice];
    }];
    [alarm1SubView bk_whenTapped:^{
        [weakself showChooseTime:weakself.alarm1TimeLbl];
    }];
    [alarm2SubView bk_whenTapped:^{
        [weakself showChooseTime:weakself.alarm2TimeLbl];
    }];
    
    self.timePickerDelegate = [CBDoubleTimePicker new];
}

- (void)overOnChange:(UISwitch *)sender {
    self.overTF.text = sender.isOn ? @"60": @"";
}

- (UIView *)speedView:(UITextField **)targetTF {
    UIView *view = [UIView new];
    view.layer.borderColor = KCarLineColor.CGColor;
    view.layer.cornerRadius = 3;
    view.layer.borderWidth = 1;
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"超速阈值-不可点击-"]];
    [view addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.bottom.equalTo(@-10);
    }];
    
    UILabel *uniLbl = [MINUtils createLabelWithText:@"km/h" size:13 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
    [view addSubview:uniLbl];
    [uniLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@-10);
    }];
    
    UITextField *tf = [UITextField new];
    tf.placeholder = Localized(@"请输入");
    tf.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(img.mas_right).mas_offset(5);
        make.right.equalTo(uniLbl.mas_left).mas_offset(-5);
    }];
    *targetTF = tf;
    
    return view;
}

- (UIView *)timeView:(UILabel **)timeLbl {
    UIView *view = [UIView new];
    view.layer.borderColor = KCarLineColor.CGColor;
    view.layer.cornerRadius = 3;
    view.layer.borderWidth = 1;
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"回放时间段"]];
    [view addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.bottom.equalTo(@-10);
    }];
    
    UILabel *lbl = [MINUtils createLabelWithText:@"00:00 - 23:59" size:13 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
    [view addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).mas_offset(5);
        make.centerY.equalTo(@0);
        make.right.equalTo(@-10);
    }];
    *timeLbl = lbl;
    
    return view;
}

- (UIView *)viewWithTitle:(NSString *)title
                  subView:(UIView *)subView
               switchView:(UISwitch **)switchView {
    UIView *view = [UIView new];
    
    UILabel *tLbl = [MINUtils createLabelWithText:title size:15 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
    [view addSubview:tLbl];
    [tLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@15);
        make.bottom.equalTo(@-15);
    }];
    
    UISwitch *s = [UISwitch new];
    [view addSubview:s];
    [s mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@-15);
    }];
    *switchView = s;
    
    if (subView) {
        [view addSubview:subView];
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.right.equalTo(s.mas_left).mas_offset(-5);
        }];
    }
    
    return view;
}

- (UIView *)viewWithTitle:(NSString *)title
              placeholder:(NSString *)placeholder cLbl:(UILabel **)targetLbl{
    UIView *view = [UIView new];
    
    UILabel *tLbl = [MINUtils createLabelWithText:title size:15 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
    [view addSubview:tLbl];
    [tLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@15);
        make.bottom.equalTo(@-15);
    }];
    
    UIImageView *arr = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"查看"]];
    [view addSubview:arr];
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@-15);
    }];
    
    UILabel *cLbl = [MINUtils createLabelWithText:placeholder size:15 alignment:NSTextAlignmentLeft textColor:k137Color];
    [view addSubview:cLbl];
    [cLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arr.mas_left).mas_offset(-5);
        make.centerY.equalTo(@0);
    }];
    *targetLbl = cLbl;
    
    return view;
}

- (void)popFenceNameView {
    kWeakSelf(self);
    [[CBCarAlertView viewWithMultiInput:@[Localized(@"请输入围栏名称")] title:Localized(@"围栏名称") isDigital:NO maxLength:100 confirmCanDismiss:nil confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
        weakself.fenceNameLbl.text = contentStr.firstObject;
        weakself.fenceNameLbl.textColor = kCellTextColor;
    }] pop];;
}

- (void)showSelectDevice {
    kWeakSelf(self);
    [CBDeviceTool.shareInstance getDeviceNames:^(NSArray<NSString *> * _Nonnull deviceNames, NSArray<NSString *> *dnoArr) {
        weakself.deviceArr = deviceNames;
        weakself.dnoArr = dnoArr;
        [weakself showPickView:deviceNames];
    }];
}

- (void)showPickView:(NSArray *)data {
    MINPickerView *pickerView = [[MINPickerView alloc] init];
    pickerView.titleLabel.text = @"";
    pickerView.dataArr = @[data];
    pickerView.delegate = self;
    [UIApplication.sharedApplication.keyWindow addSubview: pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    [pickerView showView];
    
    NSString *currentDeviceName = self.deviceNameLbl.text;
    NSUInteger index = [data indexOfObject:currentDeviceName];
    if (index == NSNotFound) {
        return;
    }
    [pickerView.pickerView selectRow:index inComponent:0 animated:NO];
}

- (void)showChooseTime:(UILabel *)lbl {
    MINPickerView *pickerView = [[MINPickerView alloc] init];
    pickerView.titleLabel.text = @"";
    pickerView.pickerView.delegate = _timePickerDelegate;
    pickerView.pickerView.dataSource = _timePickerDelegate;
    [UIApplication.sharedApplication.keyWindow addSubview: pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    NSCalendar *c = [NSCalendar currentCalendar];
    NSUInteger unitF = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *component = [c components:unitF fromDate:[NSDate date]];
    NSInteger min = [component minute];
    NSInteger hour = [component hour];
    NSInteger nMin = min + 1 >= 60 ? 0 : min;
    NSInteger nHour = hour + 1 >= 24 ? 0 : hour + 1;
    
    [pickerView.pickerView selectRow:hour inComponent:0 animated:NO];
    [pickerView.pickerView selectRow:min inComponent:2 animated:NO];
    [pickerView.pickerView selectRow:nHour inComponent:3 animated:NO];
    [pickerView.pickerView selectRow:nMin inComponent:5 animated:NO];
    kWeakSelf(self);
    [pickerView setDidClickConfirm:^(UIPickerView *pickerView) {
        int hour1 = [pickerView selectedRowInComponent:0];
        int min1 = [pickerView selectedRowInComponent:2];
        int hour2 = [pickerView selectedRowInComponent:3];
        int min2 = [pickerView selectedRowInComponent:5];
        NSString *text = [NSString stringWithFormat:@"%02d:%02d - %02d:%02d", hour1, min1, hour2, min2];
        lbl.text = text;
    }];
    [pickerView showView];
}

- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic {
    NSLog(@"%@", dic);
    NSNumber *index = dic[@"0"];
    self.deviceNameLbl.text = self.deviceArr[index.intValue];
    self.currentSelectedDno = self.dnoArr[index.intValue];
    self.deviceNameLbl.textColor = kCellTextColor;
}

- (void)setModel:(FenceListModel *)model {
    _model = model;
    if (model.name) {
        self.fenceNameLbl.text = model.name;
        self.fenceNameLbl.textColor  = kCellTextColor;
    }
    self.deviceNameLbl.text = model.deviceName;
    self.currentSelectedDno = model.dno;
    self.deviceNameLbl.textColor  = kCellTextColor;
    
    if ([model.useTimes componentsSeparatedByString:@","].count == 2) {
        self.alarm1TimeLbl.text = [model.useTimes stringByReplacingOccurrencesOfString:@"," withString:@" - "];
    }
    if ([model.useTimes2 componentsSeparatedByString:@","].count == 2) {
        self.alarm2TimeLbl.text = [model.useTimes2 stringByReplacingOccurrencesOfString:@"," withString:@" - "];
    }
    
    self.alarm1Switch.on = YES;
    self.alarm2Switch.on = YES;
    
    self.inSwitch.on = model.warmType == 1 || model.warmType == 2;
    self.outSwitch.on = model.warmType == 0 || model.warmType == 2;
    
    if (model.speed && model.speed.intValue > 0) {
        self.overTF.text = model.speed;
        self.overSwitch.on = YES;
    } else {
        self.overTF.text = nil;
        self.overSwitch.on = NO;
    }
}

- (NSString *)getDeviceArr {
    NSDictionary *param = @{
        @"dno": self.currentSelectedDno ?: @"",
        @"speed": @(self.overTF.text.intValue).description,
        @"useTimes": [self.alarm1TimeLbl.text stringByReplacingOccurrencesOfString:@" - " withString:@","],
        @"useTimes2": [self.alarm2TimeLbl.text stringByReplacingOccurrencesOfString:@" - " withString:@","],
        @"warmType": (self.inSwitch.isOn && self.outSwitch.isOn) ? @"2" : self.inSwitch.on ? @"1": @"0",
    };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:@[param] options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)getDeviceName {
    return self.deviceNameLbl.text;
}
- (NSString *)getFenceName {
    return self.fenceNameLbl.text;
}
@end
