//
//  CBBindMembCollectionViewCell.m
//  cobanBnWatch
//
//  Created by coban on 2019/12/6.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBBindMembCollectionViewCell.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

@interface CBBindMembCollectionViewCell ()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *nameLB;
@property (nonatomic,strong) UILabel *managerLabel;
@property (nonatomic,strong) UILabel *mineLabel;
@property (nonatomic,strong) NSMutableArray *imageArr;
@end

@implementation CBBindMembCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    [self iconImageView];
    [self nameLB];
    [self managerLabel];
    [self mineLabel];
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.image = [UIImage imageNamed:@"LOGO1"];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 50*frameSizeRate/1;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(100*frameSizeRate, 100*frameSizeRate));
        }];
    }
    return _iconImageView;
}
- (UILabel *)nameLB {
    if (!_nameLB) {
        _nameLB = [UILabel new];
        _nameLB.text = @"";
        _nameLB.textColor = [UIColor colorWithHexString:@"#282828"];
        _nameLB.font = [UIFont fontWithName:CBPingFang_SC size:18];
        _nameLB.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLB];
        [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
            //make.centerX.mas_equalTo(self.mas_centerX);
            make.right.equalTo(self.iconImageView.mas_centerX).offset(-2);
            make.height.mas_equalTo(25*frameSizeRate);
        }];
        //_nameLB.backgroundColor = UIColor.yellowColor;
    }
    return _nameLB;
}
- (UILabel *)managerLabel {
    if (!_managerLabel) {
        _managerLabel = [UILabel new];
        _managerLabel.text = @"";
        _managerLabel.textColor = KWtRGB(254, 209, 85);
        _managerLabel.font = [UIFont fontWithName:CBPingFang_SC size:14];
        _managerLabel.textAlignment = NSTextAlignmentCenter;
        _managerLabel.layer.cornerRadius = 11.5*frameSizeRate;
        _managerLabel.layer.borderWidth = 0.5;
        _managerLabel.layer.borderColor = KWtRGB(254, 209, 85).CGColor;
        [self addSubview:_managerLabel];
        [_managerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
            //make.centerX.mas_equalTo(self.mas_centerX);
            make.left.equalTo(self.iconImageView.mas_centerX).offset(2);
            make.size.mas_equalTo(CGSizeMake(60*frameSizeRate, 25*frameSizeRate));
        }];
        //_managerLabel.backgroundColor = UIColor.redColor;
    }
    return _managerLabel;
}
- (UILabel *)mineLabel {
    if (!_mineLabel) {
        _mineLabel = [UILabel new];
        _mineLabel.text = @"";
        _mineLabel.textColor = KWtRGB(254, 209, 85);
        _mineLabel.font = [UIFont fontWithName:CBPingFang_SC size:14];
        _mineLabel.textAlignment = NSTextAlignmentCenter;
        _mineLabel.layer.cornerRadius = 11.5*frameSizeRate;
        _mineLabel.layer.borderWidth = 0.5;
        _mineLabel.layer.borderColor = KWtRGB(254, 209, 85).CGColor;
        [self addSubview:_mineLabel];
        [_mineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
            //make.centerX.mas_equalTo(self.mas_centerX);
            make.left.equalTo(self.iconImageView.mas_centerX).offset(2);
            make.size.mas_equalTo(CGSizeMake(60*frameSizeRate, 25*frameSizeRate));
        }];
        //_mineLabel.backgroundColor = UIColor.redColor;
    }
    return _mineLabel;
}

- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray arrayWithObjects:@"爸爸", @"妈妈", @"姐姐", @"爷爷", @"奶奶", @"哥哥", @"外公", @"外婆", @"老师", @"自定义", @"校讯通", nil];
    }
    return _imageArr;
}
- (void)setAddressModel:(AddressBookModel *)addressModel {
    _addressModel = addressModel;
    if (addressModel) {
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:addressModel.head] placeholderImage:[UIImage imageNamed:self.imageArr[self.addressModel.type]] options:SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageRefreshCached];
        _nameLB.text = addressModel.relation;
        if (addressModel.flag == YES) { // 表示是管理员
            _managerLabel.text = Localized(@"管理员");
            _mineLabel.text = @"";
            if ([addressModel.phone isEqualToString:[CBPetLoginModelTool getUser].phone]) {
                _mineLabel.text = Localized(@"我");
                [_nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
                    make.right.equalTo(self.managerLabel.mas_left).offset(-2);
                    make.height.mas_equalTo(25*frameSizeRate);
                }];
                [_managerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
                    make.centerX.mas_equalTo(self.mas_centerX);
                    make.size.mas_equalTo(CGSizeMake(60*frameSizeRate, 25*frameSizeRate));
                }];
                [_mineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
                    make.left.equalTo(self.managerLabel.mas_right).offset(2);
                    make.size.mas_equalTo(CGSizeMake(30*frameSizeRate, 25*frameSizeRate));
                }];
            } else {
                [_nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
                    make.right.equalTo(self.iconImageView.mas_centerX).offset(-2);
                    make.height.mas_equalTo(25*frameSizeRate);
                }];
                [_managerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
                    make.left.equalTo(self.iconImageView.mas_centerX).offset(2);
                    make.size.mas_equalTo(CGSizeMake(60*frameSizeRate, 25*frameSizeRate));
                }];
                [_mineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
                    make.left.equalTo(self.iconImageView.mas_centerX).offset(2);
                    make.size.mas_equalTo(CGSizeMake(0*frameSizeRate, 25*frameSizeRate));
                }];
            }
        } else if (addressModel.isBindAction) {
            _nameLB.text = Localized(@"邀请家庭成员");
            _iconImageView.image = [UIImage imageNamed:@"chat_add"];
            [_nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
                make.centerX.mas_equalTo(self.mas_centerX);
                make.height.mas_equalTo(25*frameSizeRate);
            }];
            [_managerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
                make.left.equalTo(self.iconImageView.mas_centerX).offset(2);
                make.size.mas_equalTo(CGSizeMake(0*frameSizeRate, 25*frameSizeRate));
            }];
            [_mineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
                make.left.equalTo(self.iconImageView.mas_centerX).offset(2);
                make.size.mas_equalTo(CGSizeMake(0*frameSizeRate, 25*frameSizeRate));
            }];
        } else {
            _managerLabel.text = @"";
            _mineLabel.text = @"";
            if ([addressModel.phone isEqualToString:[CBPetLoginModelTool getUser].phone]) {
                _mineLabel.text = Localized(@"我");
                [_nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
                    make.right.equalTo(self.iconImageView.mas_centerX).offset(-2);
                    make.height.mas_equalTo(25*frameSizeRate);
                }];
                [_managerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
                    make.centerX.mas_equalTo(self.mas_centerX);
                    make.size.mas_equalTo(CGSizeMake(0*frameSizeRate, 25*frameSizeRate));
                }];
                [_mineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
                    make.left.equalTo(self.iconImageView.mas_centerX).offset(2);
                    make.size.mas_equalTo(CGSizeMake(30*frameSizeRate, 25*frameSizeRate));
                }];
            } else {
                [_nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
                    make.centerX.mas_equalTo(self.mas_centerX);
                    make.height.mas_equalTo(25*frameSizeRate);
                }];
                [_managerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
                    make.left.equalTo(self.iconImageView.mas_centerX).offset(2);
                    make.size.mas_equalTo(CGSizeMake(0*frameSizeRate, 25*frameSizeRate));
                }];
                [_mineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
                    make.left.equalTo(self.iconImageView.mas_centerX).offset(2);
                    make.size.mas_equalTo(CGSizeMake(0*frameSizeRate, 25*frameSizeRate));
                }];
            }
        }
    }
}
@end
