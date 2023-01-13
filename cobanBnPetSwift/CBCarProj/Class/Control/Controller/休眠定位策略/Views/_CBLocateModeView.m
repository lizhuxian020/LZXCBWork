//
//  _CBLocateModeView.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/30.
//  Copyright © 2022 coban. All rights reserved.
//

#import "_CBLocateModeView.h"
#import "MINPickerView.h"

@interface _CBLocateModeView ()

@property (nonatomic, strong) UILabel *modeLbl;

@property (nonatomic, strong) UIView *contentAView;
@property (nonatomic, strong) UIView *contentBView;
@property (nonatomic, strong) NSArray *unitData;
@property (nonatomic, strong) NSArray *currentData;
@property (nonatomic, strong) UILabel *currentEditLbl;
@property (nonatomic, strong) UILabel *AALbl;
@property (nonatomic, assign) NSInteger numberAA;
@property (nonatomic, strong) UILabel *ABLbl;
@property (nonatomic, assign) NSInteger numberAB;

@property (nonatomic, strong) UILabel *BALbl;
@property (nonatomic, assign) NSInteger numberBA;
@property (nonatomic, strong) UITextField *bTF;

@property (nonatomic, strong) UISwitch *AASwitch;
@property (nonatomic, strong) UISwitch *ABSwitch;
@property (nonatomic, strong) UISwitch *BASwitch;
@property (nonatomic, strong) UISwitch *BBSwitch;

@end

@implementation _CBLocateModeView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.unitData = @[@"s", @"min", @"h", @"d"];
        [self createView];
    }
    return self;
}

- (void)createView {
    UILabel *titleLbl = [MINUtils createLabelWithText:Localized(@"定位策略") size:14];
    [self addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0);
    }];
    
    UIImageView *arrV = [UIImageView new];
    arrV.image = [UIImage imageNamed:@"右边"];
    [self addSubview:arrV];
    [arrV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLbl);
        make.right.equalTo(@0);
    }];
    
    self.modeLbl = [MINUtils createLabelWithText:Localized(@"定时汇报") size:14];
    [self addSubview:self.modeLbl];
    [self.modeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrV.mas_left).mas_offset(-10);
        make.centerY.equalTo(arrV);
    }];
    
    [self setupAView];
    [self addSubview:self.contentAView];
    [self.contentAView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLbl.mas_bottom).mas_offset(10);
        make.left.equalTo(titleLbl);
        make.right.equalTo(arrV);
        make.bottom.equalTo(@-10);
    }];
    
    [self setupBView];
    [self addSubview:self.contentBView];
    [self.contentBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentAView);
    }];
    self.contentBView.hidden = YES;
    
    [self addClick];
}

- (void)setupAView {
    UIView *view = [UIView new];
    UILabel *lblA = [MINUtils createLabelWithText:Localized(@"静止时的时间间隔") size:14];
    [view addSubview:lblA];
    [lblA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@10);
    }];
    
    UISwitch *s = [UISwitch new];
    [view addSubview:s];
    [s mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lblA);
        make.right.equalTo(@0);
    }];
    _AASwitch = s;
    
    UIView *cView = [UIView new];
    
    UIImageView *cImgV = [UIImageView new];
    cImgV.image = [UIImage imageNamed:@"下拉三角"];
    [cView addSubview:cImgV];
    [cImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.right.equalTo(@-5);
        make.width.height.equalTo(@15);
    }];
    
    UILabel *cLbl = [MINUtils createLabelWithText:@"10s" size:14];
    cLbl.textAlignment = NSTextAlignmentCenter;
    [cView addSubview:cLbl];
    [cLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(cImgV.mas_left);
    }];
    
    [view addSubview:cView];
    [cView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblA.mas_right).mas_offset(5);
        make.right.equalTo(s.mas_left).mas_offset(-5);
        make.centerY.equalTo(lblA);
    }];
    cView.layer.borderWidth = 1;
    cView.layer.borderColor = UIColor.grayColor.CGColor;
    
    UILabel *lblB = [MINUtils createLabelWithText:Localized(@"运动时的时间间隔") size:14];
    [view addSubview:lblB];
    [lblB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblA.mas_bottom).mas_offset(40);
        make.left.equalTo(@10);
        make.bottom.equalTo(@-40);
    }];
    
    
    UISwitch *sb = [UISwitch new];
    [view addSubview:sb];
    [sb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lblB);
        make.right.equalTo(@0);
    }];
    _ABSwitch = sb;
    
    UIView *cBView = [UIView new];
    
    UIImageView *cBImgV = [UIImageView new];
    cBImgV.image = [UIImage imageNamed:@"下拉三角"];
    [cBView addSubview:cBImgV];
    [cBImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.right.equalTo(@-5);
        make.width.height.equalTo(@15);
    }];
    
    UILabel *cBLbl = [MINUtils createLabelWithText:@"10s" size:14];
    cBLbl.textAlignment = NSTextAlignmentCenter;
    [cBView addSubview:cBLbl];
    [cBLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(cBImgV.mas_left);
    }];
    
    [view addSubview:cBView];
    [cBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblB.mas_right).mas_offset(5);
        make.right.equalTo(sb.mas_left).mas_offset(-5);
        make.centerY.equalTo(lblB);
    }];
    cBView.layer.borderWidth = 1;
    cBView.layer.borderColor = UIColor.grayColor.CGColor;
    
    self.contentAView = view;
    
    self.AALbl = cLbl;
    self.ABLbl = cBLbl;
    kWeakSelf(self);
    [cView bk_whenTapped:^{
        weakself.currentEditLbl = cLbl;
        [weakself showPickView];
    }];
    [cBView bk_whenTapped:^{
        weakself.currentEditLbl = cBLbl;
        [weakself showPickView];
    }];
    [s addTarget:self action:@selector(switchValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [sb addTarget:self action:@selector(switchValueDidChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)setupBView {
    UIView *view = [UIView new];
    UILabel *lblA = [MINUtils createLabelWithText:Localized(@"静止时的时间间隔") size:14];
    [view addSubview:lblA];
    [lblA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@10);
    }];
    
    
    UISwitch *s = [UISwitch new];
    [view addSubview:s];
    [s mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lblA);
        make.right.equalTo(@0);
    }];
    _BASwitch = s;
    
    UIView *cView = [UIView new];
    
    UIImageView *cImgV = [UIImageView new];
    cImgV.image = [UIImage imageNamed:@"下拉三角"];
    [cView addSubview:cImgV];
    [cImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.right.equalTo(@-5);
        make.width.height.equalTo(@15);
    }];
    
    UILabel *cLbl = [MINUtils createLabelWithText:@"10s" size:14];
    cLbl.textAlignment = NSTextAlignmentCenter;
    [cView addSubview:cLbl];
    [cLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(cImgV.mas_left);
    }];
    
    [view addSubview:cView];
    [cView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblA.mas_right).mas_offset(5);
        make.right.equalTo(s.mas_left).mas_offset(-5);
        make.centerY.equalTo(lblA);
    }];
    cView.layer.borderWidth = 1;
    cView.layer.borderColor = UIColor.grayColor.CGColor;
    
    UILabel *lblB = [MINUtils createLabelWithText:Localized(@"运动时的距离间隔") size:14];
    [view addSubview:lblB];
    [lblB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblA.mas_bottom).mas_offset(40);
        make.left.equalTo(@10);
        make.bottom.equalTo(@-40);
    }];
    
    
    UISwitch *sb = [UISwitch new];
    [view addSubview:sb];
    [sb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lblB);
        make.right.equalTo(@0);
    }];
    _BBSwitch = sb;
    
    UILabel *uniLbl = [MINUtils createLabelWithText:Localized(@"米") size:14];
    uniLbl.textAlignment = NSTextAlignmentCenter;
    [view addSubview:uniLbl];
    [uniLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sb);
        make.right.equalTo(sb.mas_left);
        make.width.equalTo(@20);
    }];
    
    UITextField *cBView = [UITextField new];
    cBView.textAlignment = NSTextAlignmentCenter;
    cBView.text = @"200";
    cBView.font = [UIFont systemFontOfSize:14];
    cBView.textColor = kCellTextColor;
    self.bTF = cBView;
    
    [view addSubview:cBView];
    [cBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblB.mas_right).mas_offset(5);
        make.right.equalTo(uniLbl.mas_left).mas_offset(-5);
        make.centerY.equalTo(lblB);
        make.height.equalTo(cView);
    }];
    cBView.layer.borderWidth = 1;
    cBView.layer.borderColor = UIColor.grayColor.CGColor;
    
    self.contentBView = view;
    
    self.BALbl = cLbl;
    kWeakSelf(self);
    [cView bk_whenTapped:^{
        weakself.currentEditLbl = cLbl;
        [weakself showPickView];
    }];
    
    [s addTarget:self action:@selector(switchValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [sb addTarget:self action:@selector(switchValueDidChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)addClick {
    self.modeLbl.userInteractionEnabled = YES;
    kWeakSelf(self);
    [self.modeLbl bk_whenTapped:^{
        [weakself showChooseModel];
    }];
}

- (void)switchValueDidChange:(UISwitch *)s {
    if (s == _AASwitch) {
        [self setAA:s.on ? 30 : 0 uni:s.on ? 1 : 0];
    }
    if (s == _ABSwitch) {
        [self setAB:s.on ? 30 : 0 uni:0];
    }
    if (s == _BASwitch) {
        [self setBA:s.on ? 30 : 0 uni:s.on ? 1 : 0];
    }
    if (s == _BBSwitch) {
        self.bTF.text = s.on ? @"200" : @"0";
    }
}

- (void)showChooseModel {
    kWeakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:Localized(@"定时汇报") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakself.contentAView.hidden = NO;
        weakself.contentBView.hidden = YES;
        weakself.modeLbl.text = Localized(@"定时汇报");
        weakself.AASwitch.on = YES;
        weakself.ABSwitch.on = YES;
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:Localized(@"定时和定距汇报") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        weakself.contentAView.hidden = YES;
        weakself.contentBView.hidden = NO;
        weakself.modeLbl.text = Localized(@"定时和定距汇报");
        weakself.BASwitch.on = YES;
        weakself.BBSwitch.on = YES;
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showPickView {
    MINPickerView *pickerView = [[MINPickerView alloc] init];
    pickerView.titleLabel.text = @"";
    pickerView.dataArr = [self getDataWithUnit:0];
    pickerView.delegate = self;
    [UIApplication.sharedApplication.keyWindow addSubview: pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    [pickerView showView];
}
- (void)minPickerView:(MINPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"%s", __FUNCTION__);
    if (component == 1) {
        [pickerView updateData:[self getDataWithUnit:row]];
    }
}

- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic {
    int numIndex = [dic[@"0"] intValue];
    int uniIndex = [dic[@"1"] intValue];
    NSString *num = self.currentData[0][numIndex];
    
    if (self.currentEditLbl == _AALbl) {
        [self setAA:num.intValue uni:uniIndex];
    }
    if (self.currentEditLbl == _ABLbl) {
        [self setAB:num.intValue uni:uniIndex];
    }
    if (self.currentEditLbl == _BALbl) {
        [self setBA:num.intValue uni:uniIndex];
    }
    
}
- (void)minPickerViewdidSelectCancelBtn:(MINPickerView *)pickerView {
    NSLog(@"%s", __FUNCTION__);
}

- (NSArray *)getDataWithUnit:(int)unitIdx {
    NSArray *secData= @[@"s", @"min", @"h", @"d"];
    NSMutableArray *firData = [NSMutableArray new];
    if (unitIdx == 0) {
        for (int i = 10; i < 60; i++) {
            [firData addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    if (unitIdx == 1) {
        for (int i = 1; i < 60; i++) {
            [firData addObject:[NSString stringWithFormat:@"%02d", i]];
        }
    }
    if (unitIdx == 2) {
        for (int i = 1; i < 24; i++) {
            [firData addObject:[NSString stringWithFormat:@"%02d", i]];
        }
    }
    if (unitIdx == 3) {
        for (int i = 1; i <= 30; i++) {
            [firData addObject:[NSString stringWithFormat:@"%02d", i]];
        }
    }
    
    self.currentData = @[
        firData,
        secData
    ];
    return self.currentData;
}

- (void)setLocationModel:(MultiLocationModel *)locationModel {
    _locationModel = locationModel;
    if (_locationModel.reportWay == 2) {
        self.contentAView.hidden = YES;
        self.contentBView.hidden = NO;
        self.modeLbl.text = Localized(@"定时和定距汇报");
        
        _BASwitch.on = !kStringIsEmpty(_locationModel.timeRest) && _locationModel.timeRest.intValue != 0;;
        kWeakSelf(self);
        [self getInfo:_locationModel.timeRest.intValue blk:^(int num, int uniIndex) {
            [weakself setBA:num uni:uniIndex];
        }];
        _BBSwitch.on = !kStringIsEmpty(_locationModel.disQs);
        _bTF.text = kStringIsEmpty(_locationModel.disQs) ? @"0" : _locationModel.disQs;
    } else {
        self.contentAView.hidden = NO;
        self.contentBView.hidden = YES;
        self.modeLbl.text = Localized(@"定时汇报");
        
        _AASwitch.on = !kStringIsEmpty(_locationModel.timeRest) && _locationModel.timeRest.intValue != 0;
        kWeakSelf(self);
        [self getInfo:_locationModel.timeRest.intValue blk:^(int num, int uniIndex) {
            [weakself setAA:num uni:uniIndex];
        }];
        _ABSwitch.on = !kStringIsEmpty(_locationModel.timeQs) && _locationModel.timeQs.intValue != 0;;
        [self getInfo:_locationModel.timeQs.intValue blk:^(int num, int uniIndex) {
            [weakself setAB:num uni:uniIndex];
        }];
    }
    
    
}

- (void)getInfo:(int)sec blk:(void(^)(int num, int uniIndex))blk {
    int num, uidx;
    if (sec >= (60 * 60 * 24)) {
        uidx = 3;
        num = sec / (60 * 60 * 24);
        blk(num, uidx);
        return;
    }
    if (sec >= (60 * 60)) {
        uidx = 2;
        num = sec / (60 * 60);
        blk(num, uidx);
        return;
    }
    if (sec >= (60)) {
        uidx = 1;
        num = sec / (60 );
        blk(num, uidx);
        return;
    }
    uidx = 0;
    num = sec;
    blk(num, uidx);
}

- (NSNumber *)getSpeed {
    if (self.contentBView.hidden == NO && _BBSwitch.isOn) {
        return @([self.bTF.text intValue]);
    }
    return @0;
}
- (NSNumber *)getReportWay {
    if (self.contentAView.hidden) {
        return @2;
    }
    return @0;
}
- (NSString *)getTimeQSUnit {
    if (self.contentAView.hidden == NO && _ABSwitch.isOn) {
        return @"s";
    }
    return nil;
}
- (NSNumber *)getTimeQS {
    if (self.contentAView.hidden == NO && _ABSwitch.isOn) {
        return @(_numberAB);
    }
    return @0;
}
- (NSString *)getTimeRestUnit {
    if (self.contentAView.hidden == NO && _AASwitch.isOn) {
        return @"s";
    }
    if (self.contentBView.hidden == NO && _BASwitch.isOn) {
        return @"s";
    }
    return nil;
}
- (NSNumber *)getTimeRest {
    if (self.contentAView.hidden == NO && _AASwitch.isOn) {
        return @(_numberAA);
    }
    if (self.contentBView.hidden == NO && _BASwitch.isOn) {
        return @(_numberBA);
    }
    return @0;
}
- (NSNumber *)getTime:(int)number :(int)unitIdx {
    switch (unitIdx) {
        case 0:
            return @(number);
        case 1:
            return @(number * 60);
        case 2:
            return @(number * 60 * 60);
        case 3:
            return @(number * 60 * 60 * 24);
        default:
            return @(number);
    }
}

- (void)setAA:(int)num uni:(int)uniIndex {
    self.AALbl.text = [NSString stringWithFormat:@"%d%@", num, self.unitData[uniIndex]];
    self.numberAA = [self getTime:num :uniIndex].integerValue;
}
- (void)setAB:(int)num uni:(int)uniIndex {
    self.ABLbl.text = [NSString stringWithFormat:@"%d%@", num, self.unitData[uniIndex]];
    self.numberAB = [self getTime:num :uniIndex].integerValue;
}
- (void)setBA:(int)num uni:(int)uniIndex {
    self.BALbl.text = [NSString stringWithFormat:@"%d%@", num, self.unitData[uniIndex]];
    self.numberBA = [self getTime:num :uniIndex].integerValue;
}
@end
