//
//  DeviceTableViewCell.m
//  Telematics
//
//  Created by lym on 2017/10/28.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "DeviceTableViewCell.h"

@implementation DeviceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kBackColor;
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = kCellBackColor;
        [self.contentView addSubview: _backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).with.offset(12.5 * KFitHeightRate);
            make.right.equalTo(self).with.offset(-12.5 * KFitHeightRate);
        }];
        UIImage *image =  [UIImage imageNamed:@"车"];
        _deviceImageView = [[UIImageView alloc] initWithImage: image];
        [_backView addSubview: _deviceImageView];
        [_deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView);
            make.centerX.equalTo(_backView.mas_left).with.offset(20 * KFitWidthRate);
            make.height.mas_equalTo(image.size.height * KFitHeightRate);
            make.width.mas_equalTo(image.size.width * KFitWidthRate);
        }];
        _deviceCodeLabel = [MINUtils createLabelWithText: @"粤A 23456" size: 13 * KFitHeightRate  alignment: NSTextAlignmentLeft textColor: kRGB(137 , 137, 137) ];
        [_backView addSubview: _deviceCodeLabel];
        [_deviceCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView);
            make.left.equalTo(_backView).with.offset(45 * KFitWidthRate);
            make.height.mas_equalTo(15 * KFitHeightRate);
            make.width.mas_equalTo(85 * KFitWidthRate);
        }];
        
        //@"设备号: 62521"
        _contentLabel = [MINUtils createLabelWithText: @"" size: 13 * KFitHeightRate  alignment: NSTextAlignmentLeft textColor: kRGB(137 , 137, 137) ];
        [_backView addSubview: _contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView);
            make.left.equalTo(_deviceCodeLabel.mas_right);
            make.height.mas_equalTo(15 * KFitHeightRate);
            make.width.mas_equalTo(110 * KFitWidthRate);
        }];
        UIImage *rightImage = [UIImage imageNamed:@"左边-三角"];
        _rightBtnImageView = [[UIImageView alloc] initWithImage: rightImage];
        [_backView addSubview: _rightBtnImageView];
        [_rightBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView);
            make.right.equalTo(_backView).with.offset(-10 * KFitWidthRate);
            make.height.mas_equalTo(rightImage.size.height * KFitHeightRate);
            make.width.mas_equalTo(rightImage.size.width * KFitHeightRate);
        }];
        _deleteBtn = [MINUtils createNoBorderBtnWithTitle: @"删除" titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: kRGB(252, 30 , 28)];
        [_deleteBtn addTarget: self action: @selector(deviceDeleteBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [_backView addSubview: _deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_backView);
            make.left.equalTo(_backView.mas_right);
            make.width.mas_equalTo(80 * KFitWidthRate);
        }];
        _deleteBtn.hidden = YES;
    }
    return self;
}

- (void)showDeleteBtn
{
    if (self.deleteBtn != nil) {
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration: 0.3 animations:^{
            [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.deleteBtn.superview.mas_right).with.offset(-80 * KFitWidthRate);
            }];
            self.deleteBtn.hidden = NO;
            [self.superview layoutIfNeeded];
        }];
        self.isEdit = YES;
    }
}

- (void)hideDeleteBtn
{
    if (self.deleteBtn != nil) {
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration: 0.3 animations:^{
            [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.deleteBtn.superview.mas_right);
            }];
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.deleteBtn.hidden = YES;
        }];
        self.isEdit = NO;
    }
}

- (void)addLeftSwipeGesture
{
    UISwipeGestureRecognizer *leftSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(leftSwipeGR:)];
    [leftSwipeGR setDirection: UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer: leftSwipeGR];
}

- (void)leftSwipeGR:(UISwipeGestureRecognizer *)lsGR
{
    [self showDeleteBtn];
}

- (void)deviceDeleteBtnClick
{
    if (self.deleteBtnClick) {
        self.deleteBtnClick( self.indexPath);
    }
}

- (void)setImageType:(DeviceImageType)imageType deviceCodeText:(NSString *)deviceText statusType:(DeviceStatusType)statusType
{
    if (self.deviceCodeLabel != nil || self.contentLabel != nil || self.rightBtnImageView != nil || self.deviceImageView != nil) {
        UIImage *image = nil;
        if (imageType == DeviceImageTypeCar) {
            image = [UIImage imageNamed: @"小车"];
        }else if(imageType == DeviceImageTypeDogOrCat) {
            image = [UIImage imageNamed: @"宠物"];
        }else {
            image = [UIImage imageNamed: @"人物"];
        }
        [self.deviceImageView setImage: image];
        [self.deviceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(image.size.height * KFitHeightRate);
            make.width.mas_equalTo(image.size.width * KFitWidthRate);
        }];
        self.deviceCodeLabel.text = deviceText;
        if (statusType == DeviceStatusTypeAtSpeed) {
            self.contentLabel.text = @"行驶中";
            self.contentLabel.textColor = kRGB(1, 149, 255);
        }else if(statusType == DeviceStatusTypeStayPut)
        {
            self.contentLabel.text = @"静止, 1分钟";
            self.contentLabel.textColor = kRGB(255, 156, 0);
        }else {
            self.contentLabel.text = @"未启用";
            self.contentLabel.textColor = kRGB(137, 137, 137);
        }
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.rightBtnImageView.hidden = YES;
    }
}

- (void)setImageType:(DeviceImageType)imageType deviceCodeText:(NSString *)deviceText contentLabelText:(NSString *)contentText
{
    if (self.deviceCodeLabel != nil || self.contentLabel != nil || self.rightBtnImageView != nil || self.deviceImageView != nil) {
        UIImage *image = nil;
        if (imageType == DeviceImageTypeCar) {
            image = [UIImage imageNamed: @"小车"];
        }else if(imageType == DeviceImageTypeDogOrCat) {
            image = [UIImage imageNamed: @"宠物"];
        }else {
            image = [UIImage imageNamed: @"人物"];
        }
        [self.deviceImageView setImage: image];
        [self.deviceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(image.size.height * KFitHeightRate);
            make.width.mas_equalTo(image.size.width * KFitWidthRate);
        }];
        self.deviceCodeLabel.text = deviceText;
        self.contentLabel.text = contentText;
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.rightBtnImageView.hidden = YES;
    }
}

- (void)setDeviceInfoModel:(MyDeviceModel *)deviceInfoModel {
    _deviceInfoModel = deviceInfoModel;
    if (deviceInfoModel) {
        UIImage *image = nil;
        switch (deviceInfoModel.icon) {
            case 0:
            {
                image = [UIImage imageNamed: @"定位图"];
                self.deviceImageView.image = [UIImage imageNamed:@"定位图"];
            }
                break;
             case 1:
            {
                image = [UIImage imageNamed: @"人物"];
                self.deviceImageView.image = [UIImage imageNamed:@"人物"];

            }
                break;
            case 2:
            {
                image = [UIImage imageNamed: @"宠物"];
                self.deviceImageView.image = [UIImage imageNamed:@"宠物"];

            }
                break;
            case 3:
            {
                image = [UIImage imageNamed: @"单车"];
                self.deviceImageView.image = [UIImage imageNamed:@"单车"];

            }
                break;
            case 4:
            {
                image = [UIImage imageNamed: @"摩托车"];
                self.deviceImageView.image = [UIImage imageNamed:@"摩托车"];
            }
                break;
            case 5:
            {
                image = [UIImage imageNamed: @"小车"];
                self.deviceImageView.image = [UIImage imageNamed:@"小车"];
            }
                break;
            case 6:
            {
                image = [UIImage imageNamed: @"货车"];
                self.deviceImageView.image = [UIImage imageNamed:@"货车"];
            }
                break;
            case 7:
            {
                image = [UIImage imageNamed: @"行李箱"];
                self.deviceImageView.image = [UIImage imageNamed:@"行李箱"];
            }
                break;
            default:
                break;
        }
        [self.deviceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self);
//            make.centerX.equalTo(self.mas_left).with.offset(20 * KFitWidthRate);
            make.height.mas_equalTo(image.size.height * KFitHeightRate);
            make.width.mas_equalTo(image.size.width * KFitWidthRate);
        }];
        
        self.deviceCodeLabel.text = deviceInfoModel.name?:@"";
        
//        UIImage *image = nil;
//        if (deviceInfoModel.online == 1) {
//            // 1 在线
//            if (deviceInfoModel.warmed == 1) {
//                // 1 报警
//                if (deviceInfoModel.icon == 0) {
//                    image = [UIImage imageNamed: @"定位图-报警"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"定位图-报警"];
//                } else if (deviceInfoModel.icon == 1) {
//                    image = [UIImage imageNamed: @"人物-报警"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"人物-报警"];
//                } else if (deviceInfoModel.icon == 2) {
//                    image = [UIImage imageNamed: @"宠物-报警"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"宠物-报警"];
//                } else if (deviceInfoModel.icon == 3) {
//                    image = [UIImage imageNamed: @"单车-报警"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"单车-报警"];
//                } else if (deviceInfoModel.icon == 4) {
//                    image = [UIImage imageNamed: @"摩托车-报警"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"摩托车-报警"];
//                } else if (deviceInfoModel.icon == 5) {
//                    image = [UIImage imageNamed: @"小车-报警"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"小车-报警"];
//                } else if (deviceInfoModel.icon == 6) {
//                    image = [UIImage imageNamed: @"货车-报警"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"货车-报警"];
//                } else if (deviceInfoModel.icon == 7) {
//                    image = [UIImage imageNamed: @"行李箱-报警"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"行李箱-报警"];
//                }
//                [self.deviceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.centerY.equalTo(self);
//                    make.centerX.equalTo(self.mas_left).with.offset(20 * KFitWidthRate);
//                    make.height.mas_equalTo(image.size.height * KFitHeightRate);
//                    make.width.mas_equalTo(image.size.width * KFitWidthRate);
//                }];
//            } else {
//                // 0或nil 未报警
//                if (deviceInfoModel.icon == 0) {
//                    image = [UIImage imageNamed: @"定位图"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"定位图"];
//                } else if (deviceInfoModel.icon == 1) {
//                    image = [UIImage imageNamed: @"人物"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"人物"];
//                } else if (deviceInfoModel.icon == 2) {
//                    image = [UIImage imageNamed: @"宠物"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"宠物"];
//                } else if (deviceInfoModel.icon == 3) {
//                    image = [UIImage imageNamed: @"单车"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"单车"];
//                } else if (deviceInfoModel.icon == 4) {
//                    image = [UIImage imageNamed: @"摩托车"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"摩托车"];
//                } else if (deviceInfoModel.icon == 5) {
//                    image = [UIImage imageNamed: @"小车"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"小车"];
//                } else if (deviceInfoModel.icon == 6) {
//                    image = [UIImage imageNamed: @"货车"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"货车"];
//                } else if (deviceInfoModel.icon == 7) {
//                    image = [UIImage imageNamed: @"行李箱"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"行李箱"];
//                }
//                [self.deviceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.centerY.equalTo(self);
//                    make.centerX.equalTo(self.mas_left).with.offset(20 * KFitWidthRate);
//                    make.height.mas_equalTo(image.size.height * KFitHeightRate);
//                    make.width.mas_equalTo(image.size.width * KFitWidthRate);
//                }];
//            }
//        } else {
//            // 0 离线
//            if (deviceInfoModel.warmed == 1) {
//                // 1 报警
//                if (deviceInfoModel.icon == 0) {
//                    image = [UIImage imageNamed: @"定位图-报警"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"定位图-报警"];
//                } else if (deviceInfoModel.icon == 1) {
//                    image = [UIImage imageNamed: @"人物-报警"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"人物-报警"];
//                } else if (deviceInfoModel.icon == 2) {
//                    image = [UIImage imageNamed: @"宠物-报警"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"宠物-报警"];
//                } else if (deviceInfoModel.icon == 3) {
//                    image = [UIImage imageNamed: @"单车-报警"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"单车-报警"];
//                } else if (deviceInfoModel.icon == 4) {
//                    image = [UIImage imageNamed: @"摩托车-报警"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"摩托车-报警"];
//                } else if (deviceInfoModel.icon == 5) {
//                    image = [UIImage imageNamed: @"小车-报警"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"小车-报警"];
//                } else if (deviceInfoModel.icon == 6) {
//                    image = [UIImage imageNamed: @"货车-报警"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"货车-报警"];
//                } else if (deviceInfoModel.icon == 7) {
//                    image = [UIImage imageNamed: @"行李箱-报警"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"行李箱-报警"];
//                }
//                [self.deviceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.centerY.equalTo(self);
//                    make.centerX.equalTo(self.mas_left).with.offset(20 * KFitWidthRate);
//                    make.height.mas_equalTo(image.size.height * KFitHeightRate);
//                    make.width.mas_equalTo(image.size.width * KFitWidthRate);
//                }];
//            } else {
//                if (deviceInfoModel.icon == 0) {
//                    image = [UIImage imageNamed: @"定位图-离线"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"定位图-离线"];
//                } else if (deviceInfoModel.icon == 1) {
//                    image = [UIImage imageNamed: @"人物-离线"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"人物-离线"];
//                } else if (deviceInfoModel.icon == 2) {
//                    image = [UIImage imageNamed: @"宠物-离线"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"宠物-离线"];
//                } else if (deviceInfoModel.icon == 3) {
//                    image = [UIImage imageNamed: @"单车-离线"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"单车-离线"];
//                } else if (deviceInfoModel.icon == 4) {
//                    image = [UIImage imageNamed: @"摩托车-离线"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"摩托车-离线"];
//                } else if (deviceInfoModel.icon == 5) {
//                    image = [UIImage imageNamed: @"小车-离线"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"小车-离线"];
//                } else if (deviceInfoModel.icon == 6) {
//                    image = [UIImage imageNamed: @"货车-离线"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"货车-离线"];
//                } else if (deviceInfoModel.icon == 7) {
//                    image = [UIImage imageNamed: @"行李箱-离线"];
//                    self.deviceImageView.image = [UIImage imageNamed:@"行李箱-离线"];
//                }
//                [self.deviceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.centerY.equalTo(self);
//                    make.centerX.equalTo(self.mas_left).with.offset(20 * KFitWidthRate);
//                    make.height.mas_equalTo(image.size.height * KFitHeightRate);
//                    make.width.mas_equalTo(image.size.width * KFitWidthRate);
//                }];
//
//            }
//        }
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
