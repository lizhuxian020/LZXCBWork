//
//  CBAccountPopTableViewCell.m
//  Telematics
//
//  Created by coban on 2019/12/26.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBAccountPopTableViewCell.h"

@interface CBAccountPopTableViewCell ()
/** 勾选btn */
@property (nonatomic,strong) UIButton *pickBtn;
@property (nonatomic, strong) UIImageView *deviceImageView;
@property (nonatomic, strong) UILabel *deviceNameLabel;
@property (nonatomic, strong) UILabel *deviceStatusLabel;
@property (nonatomic, strong) UIImageView *rightBtnImageView;
@property (nonatomic, strong) UIImageView *warmedImageView;//报警-设备列表
@end
@implementation CBAccountPopTableViewCell

+ (instancetype)cellCopyTableView:(UITableView *)tableView {
    static NSString *cellID = @"CBAccountPopTableViewCell";
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
    
    [self pickBtn];
    [self deviceImageView];
    [self deviceNameLabel];
    [self deviceStatusLabel];
    [self rightBtnImageView];
    [self warmedImageView];
    kWeakSelf(self);
    [self.contentView bk_whenTapped:^{
        [weakself cellSelectClick];
    }];
}
#pragma mark -- getting && setting methods
- (UIButton *)pickBtn {
    if (!_pickBtn) {
        UIImage *selectImg = [UIImage imageNamed:@"单选-没选中"];
        //UIImage *selectedImg = [UIImage imageNamed:@"单选-选中"];
        _pickBtn = [[UIButton alloc] init];
        [_pickBtn setImage: [UIImage imageNamed:@"单选-没选中"] forState: UIControlStateNormal];
        [_pickBtn setImage: [UIImage imageNamed:@"单选-选中"] forState: UIControlStateSelected];
//        [_pickBtn addTarget:self action:@selector(cellSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        [_pickBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:20];
        [self addSubview:_pickBtn];
        [_pickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(13*KFitWidthRate*2);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(selectImg.size.height);
            make.width.mas_equalTo(selectImg.size.width);
        }];
        _pickBtn.userInteractionEnabled = NO;
    }
    return _pickBtn;
}
- (UIImageView *)deviceImageView {
    if (!_deviceImageView) {
        UIImage *image =  [UIImage imageNamed:@"小车-定位-正常"];
        _deviceImageView = [[UIImageView alloc]init];
        _deviceImageView.contentMode = UIViewContentModeScaleAspectFill;
        //_deviceImageView = [[UIImageView alloc] initWithImage: image];
        [self addSubview: _deviceImageView];
        [_deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.pickBtn.mas_right).with.offset(20 * KFitWidthRate);
            make.height.mas_equalTo(image.size.height);
            make.width.mas_equalTo(image.size.width);
        }];
    }
    return _deviceImageView;
}
- (UILabel *)deviceNameLabel {
    if (!_deviceNameLabel) {
        _deviceNameLabel = [MINUtils createLabelWithText: @"粤A 23456" size: 13 * KFitHeightRate  alignment: NSTextAlignmentLeft textColor: kRGB(137 , 137, 137) ];
        [self addSubview: _deviceNameLabel];
        [_deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).with.offset(-9 * KFitHeightRate);
            make.left.equalTo(self.deviceImageView.mas_right).with.offset(15 * KFitWidthRate);
            make.height.mas_equalTo(15 * KFitHeightRate);
            make.width.mas_equalTo(85 * KFitWidthRate);
        }];
    }
    return _deviceNameLabel;
}
- (UILabel *)deviceStatusLabel {
    if (!_deviceStatusLabel) {
        _deviceStatusLabel = [MINUtils createLabelWithText: @"设备号: 62521" size: 13 * KFitHeightRate  alignment: NSTextAlignmentLeft textColor: kRGB(137 , 137, 137) ];
        [self addSubview: _deviceStatusLabel];
        [_deviceStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).with.offset(9 * KFitHeightRate);
            make.left.equalTo(self.deviceImageView.mas_right).with.offset(15 * KFitWidthRate);
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
            make.height.mas_equalTo(rightImage.size.height);
            make.width.mas_equalTo(rightImage.size.width);
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
            make.right.mas_equalTo(self.rightBtnImageView.mas_left).offset(-15*KFitWidthRate);
            make.height.mas_equalTo(rightImage.size.height);
            make.width.mas_equalTo(rightImage.size.width);
        }];
        _warmedImageView.hidden = YES;
    }
    return _warmedImageView;
}
- (void)cellSelectClick {
    self.deviceInfoModel.isCheck = !self.deviceInfoModel.isCheck;
    self.pickBtn.selected = self.deviceInfoModel.isCheck;
    if (self.cellClickBlock) {
        self.cellClickBlock(@"");
    }
}
- (void)setDeviceInfoModel:(CBHomeLeftMenuDeviceInfoModel *)deviceInfoModel {
    _deviceInfoModel = deviceInfoModel;
    if (deviceInfoModel) {
        UIImage *image = nil;
        self.warmedImageView.hidden = YES;
        if ([deviceInfoModel.warmed isEqualToString:@"1"]) {
            // 1 报警
            self.warmedImageView.hidden = NO;
        }
        image = [CBCommonTools returnDeveceListImageStr:deviceInfoModel.icon isOnline:deviceInfoModel.online isWarmed:deviceInfoModel.warmed ];
        self.deviceImageView.image = image;
        [self.deviceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.pickBtn.mas_right).with.offset(20 * KFitWidthRate);
            make.height.mas_equalTo(image.size.height);
            make.width.mas_equalTo(image.size.width);
        }];
        
        _deviceNameLabel.text = deviceInfoModel.name?:@"";
        if ([deviceInfoModel.devStatus isEqualToString:@"0"]) {
            self.deviceStatusLabel.text = Localized(@"未使用");
            self.deviceStatusLabel.textColor = [UIColor redColor];
        } else if ([deviceInfoModel.devStatus isEqualToString:@"1"]) {
            self.deviceStatusLabel.text = Localized(@"行驶中");
            self.deviceStatusLabel.textColor = kRGB(26, 151, 251);
        } else if ([deviceInfoModel.devStatus isEqualToString:@"2"]) {
            self.deviceStatusLabel.text = Localized(@"静止");
            self.deviceStatusLabel.textColor = [UIColor redColor];
        } else {
            self.deviceStatusLabel.text = Localized(@"未使用");
        }
        self.pickBtn.selected = deviceInfoModel.isCheck;
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
