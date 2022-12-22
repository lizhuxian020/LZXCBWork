//
//  CBHomeLeftMenuTableViewCell.m
//  Telematics
//
//  Created by coban on 2019/7/18.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBHomeLeftMenuTableViewCell.h"
#import "MainViewConfig.h"

@interface CBHomeLeftMenuTableViewCell ()
@property (nonatomic, strong) UIImageView *deviceImageView;
@property (nonatomic, strong) UILabel *deviceNameLabel;
@property (nonatomic, strong) UILabel *deviceStatusLabel;
@property (nonatomic, strong) UIImageView *rightBtnImageView;
@property (nonatomic, strong) UIImageView *warmedImageView;//报警-设备列表
@end
@implementation CBHomeLeftMenuTableViewCell

+ (instancetype)cellCopyTableView:(UITableView *)tableView {
    static NSString *cellID = @"CBHomeLeftMenuTableViewCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    [self deviceImageView];
    [self deviceNameLabel];
    [self deviceStatusLabel];
    [self rightBtnImageView];
    [self warmedImageView];
}
#pragma mark -- getting && setting methods
- (UIImageView *)deviceImageView {
    if (!_deviceImageView) {
        UIImage *image =  [UIImage imageNamed:@"小车-定位-正常"];
        _deviceImageView = [[UIImageView alloc]init];
        _deviceImageView.contentMode = UIViewContentModeScaleAspectFill;
        //_deviceImageView = [[UIImageView alloc] initWithImage: image];
        [self addSubview: _deviceImageView];
        [_deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self.mas_left).with.offset(20 * KFitWidthRate);
            make.height.mas_equalTo(image.size.height * KFitHeightRate);
            make.width.mas_equalTo(image.size.width * KFitWidthRate);
            //make.size.mas_equalTo(CGSizeMake(20*KFitWidthRate, 20*KFitHeightRate));
        }];
    }
    return _deviceImageView;
}
- (UILabel *)deviceNameLabel {
    if (!_deviceNameLabel) {
        _deviceNameLabel = [MINUtils createLabelWithText: @"粤A 23456" size:HomeLeftMenu_ContentFontSize  alignment: NSTextAlignmentLeft textColor: kRGB(137 , 137, 137) ];
        [self addSubview: _deviceNameLabel];
        [_deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).with.offset(-9 * KFitHeightRate);
            make.left.equalTo(self).with.offset(45 * KFitWidthRate);
            make.height.mas_equalTo(15 * KFitHeightRate);
            make.width.mas_equalTo(85 * KFitWidthRate);
        }];
    }
    return _deviceNameLabel;
}
- (UILabel *)deviceStatusLabel {
    if (!_deviceStatusLabel) {
        _deviceStatusLabel = [MINUtils createLabelWithText: @"设备号: 62521" size:HomeLeftMenu_ContentFontSize  alignment: NSTextAlignmentLeft textColor: kRGB(137 , 137, 137) ];
        [self addSubview: _deviceStatusLabel];
        [_deviceStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).with.offset(9 * KFitHeightRate);
            make.left.equalTo(self).with.offset(45 * KFitWidthRate);
            make.height.mas_equalTo(15 * KFitHeightRate);
            make.width.mas_equalTo(110 * KFitWidthRate);
        }];
    }
    return _deviceStatusLabel;
}
- (UIImageView *)rightBtnImageView {
    if (!_rightBtnImageView) {
        UIImage *rightImage = [UIImage imageNamed:@"查看"];
        _rightBtnImageView = [[UIImageView alloc] initWithImage: rightImage];
        [self addSubview: _rightBtnImageView];
        [_rightBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(-10 * KFitWidthRate);
        }];
    }
    return _rightBtnImageView;
}
- (UIImageView *)warmedImageView {
    if (!_warmedImageView) {
        UIImage *rightImage = [UIImage imageNamed:@"报警-设备列表"];
        _warmedImageView = [[UIImageView alloc] initWithImage: rightImage];
        [self addSubview: _warmedImageView];
        [_warmedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            //make.right.equalTo(self).with.offset(-10 * KFitWidthRate);
            make.right.mas_equalTo(self.rightBtnImageView.mas_left).offset(-15*KFitWidthRate);
            make.height.mas_equalTo(rightImage.size.height * KFitHeightRate);
            make.width.mas_equalTo(rightImage.size.width * KFitHeightRate);
        }];
        _warmedImageView.hidden = YES;
    }
    return _warmedImageView;
}
- (void)setDeviceInfoModel:(CBHomeLeftMenuDeviceInfoModel *)deviceInfoModel {
    
    _deviceInfoModel = deviceInfoModel;
    self.warmedImageView.hidden = YES;
    if (!deviceInfoModel) {
        return;
    }
    
    UIImage *image = nil;
    NSDictionary *dic = @{
        @"iconStr": deviceInfoModel.icon ?: @"",
        @"onlineStr": deviceInfoModel.online ?: @"",
        @"warmedStr": deviceInfoModel.warmed ?: @"",
        @"devStatus": deviceInfoModel.devStatus ?: @"",
    };
    if ([deviceInfoModel.warmed isEqualToString:@"1"]) {
        self.warmedImageView.hidden = NO;
    }
//    if ([deviceInfoModel.online isEqualToString:@"1"]) {
        image = [CBCommonTools returnDeveceListImageWithDic:dic];
        self.deviceImageView.image = image;
        [self.deviceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self.mas_left).with.offset(20 * KFitWidthRate);
            make.height.mas_equalTo(image.size.height * KFitHeightRate);
            make.width.mas_equalTo(image.size.width * KFitWidthRate);
        }];
//    }
    _deviceNameLabel.text = deviceInfoModel.name?:@"";
    if ([deviceInfoModel.online isEqualToString:@"0"]) {
        self.deviceStatusLabel.text = Localized(@"离线");
        self.deviceStatusLabel.textColor = kRGB(137 , 137, 137);
    } else {
        self.deviceStatusLabel.text = Localized(@"静止");
        self.deviceStatusLabel.textColor = kRGB(137 , 137, 137);
    }
//    if ([deviceInfoModel.devStatus isEqualToString:@"0"]) {
//        self.deviceStatusLabel.text = Localized(@"未使用");
//        self.deviceStatusLabel.textColor = [UIColor redColor];
//    } else if (![deviceInfoModel.online isEqualToString:@"1"]) {
//        self.deviceStatusLabel.text = Localized(@"离线");
//        self.deviceStatusLabel.textColor = kRGB(137 , 137, 137);
//    } else if ([deviceInfoModel.devStatus isEqualToString:@"1"]) {
//        self.deviceStatusLabel.text = Localized(@"行驶中");
//        self.deviceStatusLabel.textColor = kRGB(26, 151, 251);
//    } else if ([deviceInfoModel.devStatus isEqualToString:@"2"]) {
//        self.deviceStatusLabel.text = Localized(@"静止");
//        self.deviceStatusLabel.textColor = [UIColor redColor];
//    } else {
//        self.deviceStatusLabel.text = Localized(@"未使用");
//    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
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
