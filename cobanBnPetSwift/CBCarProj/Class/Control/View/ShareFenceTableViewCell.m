//
//  ShareFenceTableViewCell.m
//  Telematics
//
//  Created by lym on 2018/3/14.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "ShareFenceTableViewCell.h"

@implementation ShareFenceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kBackColor;
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = kCellBackColor;
        [self addSubview: _backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).with.offset(12.5 * KFitHeightRate);
            make.right.equalTo(self).with.offset(-12.5 * KFitHeightRate);
        }];
        _selectBtn = [MINUtils createBtnWithNormalImage: [UIImage imageNamed: @"单选-没选中"] selectedImage: [UIImage imageNamed: @"单选-选中"]];
        _selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_backView addSubview: _selectBtn];
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_backView);
            make.width.mas_equalTo(70 * KFitWidthRate);
        }];
        UIView *hiddenBtnView = [[UIView alloc] init]; // 禁止响应btn点击事件
        [_backView addSubview: hiddenBtnView];
        [hiddenBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(_backView);
        }];
        _deviceLabel = [MINUtils createLabelWithText: @"粤A 23422" size: 13 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: k137Color];
        [_backView addSubview: _deviceLabel];
        [_deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_backView);
            make.left.equalTo(_selectBtn.mas_right).with.offset(12.5 * KFitWidthRate);
            make.right.equalTo(_backView).with.offset(-12.5 * KFitWidthRate);
        }];
    }
    return self;
}
- (void)setDeviceInfoModel:(CBHomeLeftMenuDeviceInfoModel *)deviceInfoModel {
    _deviceInfoModel = deviceInfoModel;
    if (deviceInfoModel) {
        self.deviceLabel.text = deviceInfoModel.name;
        self.selectBtn.selected = deviceInfoModel.isCheck;
    }
}
@end
