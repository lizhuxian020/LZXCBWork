//
//  DeviceDetailTableViewCell.m
//  Telematics
//
//  Created by lym on 2017/11/8.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "DeviceDetailTableViewCell.h"

@implementation DeviceDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kBackColor;
        UIView *backView = [MINUtils createViewWithRadius:5 * KFitHeightRate];
        [self addSubview: backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).with.offset(12.5 * KFitHeightRate);
            make.right.equalTo(self).with.offset(-12.5 * KFitHeightRate);
            make.bottom.equalTo(self);//.with.offset(-2.5 * KFitHeightRate);
        }];
        _nameLabel = [MINUtils createLabelWithText: @"设备管理"];
        [backView addSubview: _nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView);
            make.left.equalTo(backView).with.offset(12.5 * KFitHeightRate);
            make.size.mas_equalTo(CGSizeMake(200 * KFitWidthRate, 20 * KFitHeightRate));
        }];
        _editLabel = [MINUtils createLabelWithText: @"25642997946" size: 12 * KFitHeightRate alignment: NSTextAlignmentRight textColor: kRGB(137, 137, 137)];
        [backView addSubview: _editLabel];
        [_editLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView).with.offset(-12.5 * KFitWidthRate);
            make.centerY.equalTo(backView);
            make.width.mas_equalTo(180 * KFitWidthRate);
            make.height.mas_equalTo(20 * KFitHeightRate);
        }];
        _selectLabel = [MINUtils createLabelWithText: @"选择车辆颜色" size: 12 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: kRGB(137, 137, 137)];
        _selectLabel.layer.borderWidth = 0.5;
        _selectLabel.layer.borderColor = kRGB(210, 210, 210).CGColor;
        _selectLabel.layer.cornerRadius = 2.5 * KFitWidthRate;
        [backView addSubview: _selectLabel];
        [_selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView).with.offset(-12.5 * KFitWidthRate);
            make.centerY.equalTo(backView);
            make.width.mas_equalTo(168 * KFitWidthRate);
            make.height.mas_equalTo(30 * KFitHeightRate);
        }];
        UIImage *arrowImage = [UIImage imageNamed: @"下拉三角"];
        _arrowImageView = [[UIImageView alloc] initWithImage: arrowImage];
        [backView addSubview: _arrowImageView];
        [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView);
            make.right.equalTo(_selectLabel).with.offset(- 12.5 * KFitWidthRate);
            make.height.mas_equalTo(arrowImage.size.height * KFitWidthRate);
            make.width.mas_equalTo(arrowImage.size.width * KFitWidthRate);
        }];
    }
    return self;
}

- (void)setEditLabelText:(NSString *)text
{
    self.editLabel.text = text;
    self.editLabel.hidden = NO;
    self.selectLabel.hidden = YES;
    self.arrowImageView.hidden = YES;
}

- (void)setSelectLabelText:(NSString *)text
{
    self.selectLabel.text = text;
    self.selectLabel.hidden = NO;
    self.editLabel.hidden = YES;
    self.arrowImageView.hidden = NO;
}
- (NSArray *)carColor {
    return @[Localized(@"蓝色"), Localized(@"黄色"), Localized(@"黑色"), Localized(@"白色"), Localized(@"其他")];
}
- (NSArray *)carIcon {
    return @[Localized(@"定位图"), Localized(@"人物"), Localized(@"宠物"), Localized(@"单车"), Localized(@"摩托车"), Localized(@"小车"), Localized(@"货车"), Localized(@"行李箱")];
}
- (void)setEditDeviceModel:(MyDeviceModel *)editDeviceModel {
    _editDeviceModel = editDeviceModel;
    if (editDeviceModel) {
        self.editLabel.hidden = NO;
        self.selectLabel.hidden = YES;
        self.arrowImageView.hidden = YES;
        _nameLabel.text = editDeviceModel.leftTitle;
        //@[Localized( @"设备IMEI号"),Localized(@"设备电话号码"),Localized(@"车牌颜色"),Localized(@"车辆VIN"),Localized(@"设备名称"),Localized(@"车牌号码"),Localized(@"定位图标"),Localized(@"所属分组"),Localized(@"设备协议类型"),Localized(@"设备版本号"),Localized(@"经销商ID"),Localized(@"注册日期"),Localized(@"有效期")]
        
        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"设备IMEI号")]) {
            _editLabel.text = editDeviceModel.dno;
        }
        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"设备电话号码")]) {
            _editLabel.text = editDeviceModel.devPhone;
        }
        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"车辆VIN")]) {
            _editLabel.text = editDeviceModel.vin;
        }
        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"设备名称")]) {
            _editLabel.text = editDeviceModel.name;
        }
        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"车牌号码")]) {
            _editLabel.text = editDeviceModel.carNum;
        }
        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"所属分组")]) {
            _editLabel.text = editDeviceModel.groupNameStr;
        }
        //_editLabel.text = [NSString stringWithFormat: @"%d",self.editDeviceModel.protocol];
        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"设备协议类型")]) {
            _editLabel.text = editDeviceModel.protocol;//[NSString stringWithFormat: @"%d",self.editDeviceModel.protocol];
        }
        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"设备版本号")]) {
            _editLabel.text = editDeviceModel.version;
        }
        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"经销商ID")]) {
            _editLabel.text = editDeviceModel.uid;
        }
        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"注册日期")]) {
            _editLabel.text = [MINUtils getTimeFromTimestamp:editDeviceModel.registerTime?:@"" formatter:@"yyyy-MM-dd HH:mm:ss"];//editDeviceModel.registerTime;
        }
        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"有效期")]) {
            _editLabel.text = [MINUtils getTimeFromTimestamp:editDeviceModel.expireTime?:@"" formatter:@"yyyy-MM-dd HH:mm:ss"];//editDeviceModel.expireTime;
        }
        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"车辆颜色")]) {
            _editLabel.hidden = YES;
            self.selectLabel.hidden = NO;
            self.arrowImageView.hidden = NO;
            if ([self carColor].count > editDeviceModel.color) {
                self.selectLabel.text = [self carColor][editDeviceModel.color];
            } else {
                self.selectLabel.text = [self carColor][0];
            }
        } else if ([editDeviceModel.leftTitle isEqualToString:Localized(@"定位图标")]) {
            _editLabel.hidden = YES;
            self.selectLabel.hidden = NO;
            self.arrowImageView.hidden = NO;
            if ([self carIcon].count > editDeviceModel.icon) {
                self.selectLabel.text = [self carIcon][editDeviceModel.icon];
            } else {
                self.selectLabel.text = [self carIcon][0];
            }
        }
    }
}
@end
