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
        self.iconViewArr = [NSMutableArray new];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kBackColor;
        self.backView = [UIView new];
        _nameLabel = [MINUtils createLabelWithText: @"设备管理"];
        [self.backView addSubview: _nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
            make.left.equalTo(self.backView).with.offset(12.5 * KFitHeightRate);
            make.bottom.equalTo(@-15);
        }];
        
        UIImageView *arrView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"查看"]];
        [self.backView addSubview:arrView];
        [arrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backView).with.offset(-12.5 * KFitWidthRate);
            make.centerY.equalTo(@0);
            make.width.height.equalTo(@10);
        }];

        UIView *line = [MINUtils createLineView];
        [self.backView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.height.equalTo(@1);
            make.left.equalTo(_nameLabel);
            make.right.equalTo(arrView);
        }];

        UITextField *tf = [UITextField new];
        [self.backView addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrView.mas_left).mas_offset(-15);
            make.centerY.equalTo(@0);
            make.top.bottom.equalTo(@0);
            make.left.equalTo(_nameLabel.mas_right);
        }];
        tf.textAlignment = NSTextAlignmentRight;
        tf.placeholder = @"请输入";
        self.textField = tf;
        [_nameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        _selectLabel = [MINUtils createLabelWithText: @"选择车辆颜色" size: 12 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: kRGB(137, 137, 137)];
        _selectLabel.layer.borderWidth = 0.5;
        _selectLabel.layer.borderColor = kRGB(210, 210, 210).CGColor;
        _selectLabel.layer.cornerRadius = 2.5 * KFitWidthRate;
        [self.backView addSubview: _selectLabel];
        [_selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrView.mas_left).mas_offset(-12.5 * KFitWidthRate);
            make.centerY.equalTo(self.backView);
            make.width.mas_equalTo(168 * KFitWidthRate);
            make.height.mas_equalTo(30 * KFitHeightRate);
        }];
        UIImage *arrowImage = [UIImage imageNamed: @"下拉三角"];
        _arrowImageView = [[UIImageView alloc] initWithImage: arrowImage];
        [self.backView addSubview: _arrowImageView];
        [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backView);
            make.right.equalTo(_selectLabel).with.offset(- 12.5 * KFitWidthRate);
            make.height.mas_equalTo(arrowImage.size.height * KFitWidthRate);
            make.width.mas_equalTo(arrowImage.size.width * KFitWidthRate);
        }];
        
        _iconSelectView = [UIView new];
        _iconSelectView.backgroundColor = kBackColor;

        UILabel *iconTitleLbl = [MINUtils createLabelWithText: Localized(@"图标")];
        [_iconSelectView addSubview:iconTitleLbl];
        [iconTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(@(12.5 * KFitHeightRate));
        }];
        
        UIView *iconContainer = [UIView new];
        [_iconSelectView addSubview:iconContainer];
        [iconContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconTitleLbl.mas_bottom).mas_offset(10);
            make.left.equalTo(iconTitleLbl);
            make.right.equalTo(@(-12.5 * KFitHeightRate));
            make.bottom.equalTo(@0);
        }];
        
        
        UIView *lastView = nil;
        int col = 7;
        kWeakSelf(self);
        for(int i = 0; i < self.carIcon.count; i++) {
            UIView *iconC = [UIView new];
            [self.iconViewArr addObject:iconC];
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.carIcon[i]]];
            [iconC addSubview:iconView];
            [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(iconView.mas_height);
                make.centerY.centerX.equalTo(@0);
                make.top.equalTo(@5);
                make.bottom.equalTo(@-5);
            }];
            
            [iconContainer addSubview:iconC];
            [iconC mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i % col == 0) {
                    if (lastView) {
                        make.top.equalTo(lastView.mas_bottom).mas_offset(5);
                    } else {
                        make.top.equalTo(@0);
                    }
                } else {
                    make.top.equalTo(lastView);
                }
                if (i % col == 0) {
                    make.left.equalTo(@0);
                } else {
                    make.left.equalTo(lastView.mas_right).mas_offset(5);
                }
                if (lastView) {
                    make.width.equalTo(lastView);
                }
                if ((i+1) % col == 0) {
                    make.right.equalTo(@0);
                }
            }];
            lastView = iconC;
            [iconC bk_whenTapped:^{
                weakself.iconIndex = i;
            }];
        }
        [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
        }];
        
        self.backView.userInteractionEnabled = NO;
    }
    return self;
}

- (void)showTextView {
    self.textField.hidden = NO;
    self.selectLabel.hidden = YES;
    self.arrowImageView.hidden = YES;
    self.iconSelectView.hidden = YES;
    [self.backView removeFromSuperview];
    [self.iconSelectView removeFromSuperview];
    
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}
- (void)showSelectView {
    self.textField.hidden = YES;
    self.selectLabel.hidden = NO;
    self.arrowImageView.hidden = NO;
    self.iconSelectView.hidden = YES;
    [self.backView removeFromSuperview];
    [self.iconSelectView removeFromSuperview];
    
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}
- (void)showIcon:(NSInteger)selectedIndex {
    self.iconIndex = selectedIndex;
    self.textField.hidden = YES;
    self.selectLabel.hidden = YES;
    self.arrowImageView.hidden = YES;
    self.iconSelectView.hidden = NO;
    [self.backView removeFromSuperview];
    [self.iconSelectView removeFromSuperview];
    
    [self.contentView addSubview:self.iconSelectView];
    [self.iconSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

- (void)setIconIndex:(NSInteger)iconIndex {
    _iconIndex = iconIndex;
    
    for (int i = 0; i < self.iconViewArr.count; i++) {
        UIView *iconV = self.iconViewArr[i];
        iconV.layer.borderColor = kAppMainColor.CGColor;
        iconV.layer.cornerRadius = 3;
        if (i == iconIndex) {
            iconV.layer.borderWidth = 1;
        } else {
            iconV.layer.borderWidth = 0;
        }
    }
    _didSelectedIconIndex(_iconIndex);
}

//- (NSArray *)carColor {
//    return @[Localized(@"蓝色"), Localized(@"黄色"), Localized(@"黑色"), Localized(@"白色"), Localized(@"其他")];
//}
- (NSArray *)carIcon {
    return @[
        Localized(@"定位-默认"),
        Localized(@"人-默认"),
        Localized(@"宠物-默认"),
        Localized(@"自行车-默认"),
        Localized(@"摩托车-默认"),
        Localized(@"小车-默认"),
        Localized(@"货车-默认"),
        Localized(@"行李箱-默认"),
        Localized(@"船-默认"),
        Localized(@"电动车-默认"),
        Localized(@"公交车-默认")
    ];
}
//- (void)setEditDeviceModel:(MyDeviceModel *)editDeviceModel {
//
//    if (editDeviceModel) {
//        self.textField.hidden = NO;
//        self.selectLabel.hidden = YES;
//        self.arrowImageView.hidden = YES;
//        _nameLabel.text = editDeviceModel.leftTitle;
//        //@[Localized( @"设备IMEI号"),Localized(@"设备电话号码"),Localized(@"车牌颜色"),Localized(@"车辆VIN"),Localized(@"设备名称"),Localized(@"车牌号码"),Localized(@"定位图标"),Localized(@"所属分组"),Localized(@"设备协议类型"),Localized(@"设备版本号"),Localized(@"经销商ID"),Localized(@"注册日期"),Localized(@"有效期")]
//
//        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"设备IMEI号")]) {
//            self.textField.text = editDeviceModel.dno;
//        }
//        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"设备电话号码")]) {
//            self.textField.text = editDeviceModel.devPhone;
//        }
//        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"车辆VIN")]) {
//            self.textField.text = editDeviceModel.vin;
//        }
//        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"设备名称")]) {
//            self.textField.text = editDeviceModel.name;
//        }
//        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"车牌号码")]) {
//            self.textField.text = editDeviceModel.carNum;
//        }
//        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"所属分组")]) {
//            self.textField.text = editDeviceModel.groupNameStr;
//        }
//        //_editLabel.text = [NSString stringWithFormat: @"%d",self.editDeviceModel.protocol];
//        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"设备协议类型")]) {
//            self.textField.text = editDeviceModel.protocol;//[NSString stringWithFormat: @"%d",self.editDeviceModel.protocol];
//        }
//        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"设备版本号")]) {
//            self.textField.text = editDeviceModel.version;
//        }
//        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"经销商ID")]) {
//            self.textField.text = editDeviceModel.uid;
//        }
//        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"注册日期")]) {
//            self.textField.text = [MINUtils getTimeFromTimestamp:editDeviceModel.registerTime?:@"" formatter:@"yyyy-MM-dd HH:mm:ss"];//editDeviceModel.registerTime;
//        }
//        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"有效期")]) {
//            self.textField.text = [MINUtils getTimeFromTimestamp:editDeviceModel.expireTime?:@"" formatter:@"yyyy-MM-dd HH:mm:ss"];//editDeviceModel.expireTime;
//        }
//        if ([editDeviceModel.leftTitle isEqualToString:Localized(@"车辆颜色")]) {
//            self.textField.hidden = YES;
//            self.selectLabel.hidden = NO;
//            self.arrowImageView.hidden = NO;
//            if ([self carColor].count > editDeviceModel.color) {
//                self.selectLabel.text = [self carColor][editDeviceModel.color];
//            } else {
//                self.selectLabel.text = [self carColor][0];
//            }
//        } else if ([editDeviceModel.leftTitle isEqualToString:Localized(@"定位图标")]) {
//            self.textField.hidden = YES;
//            self.selectLabel.hidden = NO;
//            self.arrowImageView.hidden = NO;
//            if ([self carIcon].count > editDeviceModel.icon) {
//                self.selectLabel.text = [self carIcon][editDeviceModel.icon];
//            } else {
//                self.selectLabel.text = [self carIcon][0];
//            }
//        }
//    }
//}
@end
