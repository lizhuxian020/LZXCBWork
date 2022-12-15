//
//  _CBCommandRecordCell.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/3.
//  Copyright © 2022 coban. All rights reserved.
//

#import "_CBCommandRecordCell.h"

@interface _CBCommandRecordCell ()

@property (nonatomic, strong) UIView *myContentView;

@property (nonatomic, strong) UILabel *nameLbl;

@property (nonatomic, strong) UILabel *statusLbl;

@property (nonatomic, strong) UILabel *timeLbl;

@end

@implementation _CBCommandRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.contentView.backgroundColor = kGreyColor;
    
    self.myContentView = [UIView new];
    self.myContentView.backgroundColor = UIColor.whiteColor;
    self.myContentView.layer.cornerRadius = 10;
    [self.contentView addSubview:self.myContentView];
    [self.myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.right.equalTo(@-10);
        make.bottom.equalTo(@0);
    }];
    
    UILabel *nameLbl = [MINUtils createLabelWithText:Localized(@"指令") size:14 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
    UILabel *statusLbl = [MINUtils createLabelWithText:Localized(@"状态") size:14 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
    UILabel *timeLbl = [MINUtils createLabelWithText:Localized(@"时间") size:14 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
    
    [self.myContentView addSubview:nameLbl];
    [self.myContentView addSubview:statusLbl];
    [self.myContentView addSubview:timeLbl];
    
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
    }];
    [statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(nameLbl.mas_bottom).mas_offset(10);
    }];
    [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(statusLbl.mas_bottom).mas_offset(10);
        make.bottom.equalTo(@-10);
    }];
    
    _nameLbl = [MINUtils createLabelWithText:Localized(@"指令") size:14 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
    _statusLbl = [MINUtils createLabelWithText:Localized(@"状态") size:14 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
    _timeLbl = [MINUtils createLabelWithText:Localized(@"时间") size:14 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
    
    [self.myContentView addSubview:_nameLbl];
    [self.myContentView addSubview:_statusLbl];
    [self.myContentView addSubview:_timeLbl];
    
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLbl);
        make.right.equalTo(@-10);
    }];
    [_statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(statusLbl);
        make.right.equalTo(@-10);
    }];
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLbl);
        make.right.equalTo(@-10);
    }];
}

- (void)setModel:(_CBCommandRecord *)model {
    _model = model;
    
    _nameLbl.text = model.cmdName;
    _statusLbl.text = model.statusName;
    _timeLbl.text = [CBWtMINUtils getTimeFromTimestamp: _model.createTime formatter: @"yyyy-MM-dd HH:mm:ss"];
    
}
@end
