//
//  _CBCarAlertMsgCell.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/24.
//  Copyright © 2022 coban. All rights reserved.
//

#import "_CBCarAlertMsgCell.h"

@interface _CBCarAlertMsgCell ()

@property (nonatomic, strong) UIView *myContentView;

@property (nonatomic, strong) UILabel *nameT;
@property (nonatomic, strong) UILabel *timeT;
@property (nonatomic, strong) UILabel *typeT;
@property (nonatomic, strong) UILabel *actionT;

@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *typeLbl;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIButton *stopBtn;
@end

@implementation _CBCarAlertMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.contentView.backgroundColor = UIColor.lightGrayColor;
    self.myContentView = [UIView new];
    self.myContentView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.myContentView];
    [self.myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.bottom.equalTo(@0);
    }];
    self.myContentView.layer.cornerRadius = 10;
    
    self.nameT = [MINUtils createLabelWithText:Localized(@"名称设备") size:14 alignment:NSTextAlignmentCenter textColor:kCellTextColor];
    [self.myContentView addSubview:self.nameT];
    [self.nameT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
    }];
    self.nameLbl = [MINUtils createLabelWithText:@"403A" size:14 alignment:NSTextAlignmentCenter textColor:kCellTextColor];
    [self.myContentView addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameT);
        make.right.equalTo(@-10);
    }];
    
    self.timeT = [MINUtils createLabelWithText:Localized(@"报警时间") size:14 alignment:NSTextAlignmentCenter textColor:kCellTextColor];
    [self.myContentView addSubview:self.timeT];
    [self.timeT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(self.nameT.mas_bottom).mas_offset(10);
    }];
    self.timeLbl = [MINUtils createLabelWithText:@"2022-11-11 11:11:11" size:14 alignment:NSTextAlignmentCenter textColor:kCellTextColor];
    [self.myContentView addSubview:self.timeLbl];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeT);
        make.right.equalTo(@-10);
    }];
    
    self.typeT = [MINUtils createLabelWithText:Localized(@"报警类型") size:14 alignment:NSTextAlignmentCenter textColor:kCellTextColor];
    [self.myContentView addSubview:self.typeT];
    [self.typeT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(self.timeT.mas_bottom).mas_offset(10);
    }];
    self.typeLbl = [MINUtils createLabelWithText:@"震动" size:14 alignment:NSTextAlignmentCenter textColor:kCellTextColor];
    [self.myContentView addSubview:self.typeLbl];
    [self.typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeT);
        make.right.equalTo(@-10);
    }];
    
    self.actionT = [MINUtils createLabelWithText:Localized(@"操作") size:14 alignment:NSTextAlignmentCenter textColor:kCellTextColor];
    [self.myContentView addSubview:self.actionT];
    [self.actionT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(self.typeT.mas_bottom).mas_offset(20);
        make.bottom.equalTo(@-20);
    }];
    
    self.stopBtn = [MINUtils createBtnWithRadius:10 title:Localized(@"停止报警")];
    [self.myContentView addSubview:self.stopBtn];
    [self.stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.actionT);
        make.right.equalTo(@-10);
        make.width.equalTo(@80);
    }];
    
    self.checkBtn = [MINUtils createBtnWithRadius:10 title:Localized(@"查看")];
    self.checkBtn.layer.borderColor = kBlueColor.CGColor;
    self.checkBtn.layer.borderWidth = 1;
    self.checkBtn.backgroundColor = UIColor.whiteColor;
    [self.checkBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
    [self.myContentView addSubview:self.checkBtn];
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.actionT);
        make.right.equalTo(self.stopBtn.mas_left).mas_offset(-10);
        make.width.equalTo(@80);
    }];
    
    kWeakSelf(self);
    [self.stopBtn bk_whenTapped:^{
        weakself.didClickStop();
    }];
    
    [self.checkBtn bk_whenTapped:^{
        weakself.didClickCheck();
    }];
}

- (void)setModel:(_CBCarAlertMsgModel *)model {
    _model = model;
    self.nameLbl.text = model.name;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*3600];
    [formatter setTimeZone:timeZone];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:model.warnTime.doubleValue/1000];
    self.timeLbl.text = [formatter stringFromDate:date];
    
    self.typeLbl.text = [self type:model.type];
    
}

- (NSString *)type:(NSString *)type {
    int typeI = type.intValue;
    switch (typeI) {
        case 12:
            return @"震动";
    }
    return @"";
}

@end
