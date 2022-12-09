//
//  CBFencyMenuView.m
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/9.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBFencyMenuView.h"
#import "MINPickerView.h"

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
    
    UIView *outView = [self viewWithTitle:Localized(@"进围栏报警") subView:nil switchView:&switchView];
    self.outSwitch = switchView;
    [self addSubview:outView];
    [outView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inView.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    
    UIView *subView = [self timeView:&lbl];
    self.alarm1TimeLbl = lbl;
    UIView *alarm1View = [self viewWithTitle:Localized(@"时段1报警") subView:subView switchView:&switchView];
    self.alarm1Switch = switchView;
    [self addSubview:alarm1View];
    [alarm1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(outView.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    
    subView = [self timeView:&lbl];
    self.alarm2TimeLbl = lbl;
    UIView *alarm2View = [self viewWithTitle:Localized(@"时段2报警") subView:subView switchView:&switchView];
    self.alarm2Switch = switchView;
    [self addSubview:alarm2View];
    [alarm2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alarm1View.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    
    UITextField *tf = nil;
    subView = [self speedView:&tf];
    self.overTF = tf;
    UIView *overView = [self viewWithTitle:Localized(@"超速报警") subView:subView switchView:&switchView];
    self.overSwitch = switchView;
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
    [CBDeviceTool.shareInstance getDeviceNames:^(NSArray<NSString *> * _Nonnull deviceNames) {
        weakself.deviceArr = deviceNames;
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
}

- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic {
    NSLog(@"%@", dic);
    NSNumber *index = dic[@"0"];
    self.deviceNameLbl.text = self.deviceArr[index.intValue];
    self.deviceNameLbl.textColor = kCellTextColor;
}

@end
