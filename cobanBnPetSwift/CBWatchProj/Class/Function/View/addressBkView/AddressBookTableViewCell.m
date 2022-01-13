//
//  AddressBookTableViewCell.m
//  Watch
//
//  Created by lym on 2018/2/7.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "AddressBookTableViewCell.h"
#import "AddressBookModel.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

@interface AddressBookTableViewCell ()
@property (nonatomic,strong) NSMutableArray *imageArr;

@property (nonatomic, strong) UILabel *mineLabel;

@end
@implementation AddressBookTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.managerLabel.layer.cornerRadius = self.managerLabel.frame.size.height/2;
    self.managerLabel.layer.borderWidth = 0.5;
    
    self.mineLabel.layer.cornerRadius = self.mineLabel.frame.size.height/2;
    self.mineLabel.layer.borderWidth = 0.5;
}
- (void)createUI
{
    self.backgroundColor = UIColor.whiteColor;
    self.headImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"姐姐"]];
    self.headImageView.layer.cornerRadius = 25 * KFitWidthRate;
    self.headImageView.layer.borderColor = KWtLineColor.CGColor;
    self.headImageView.layer.borderWidth = 0.5;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview: self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(50 * KFitWidthRate, 50 * KFitWidthRate));
    }];

    self.nameLabel = [CBWtMINUtils createLabelWithText: @"哥哥" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
    [self addSubview: self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).offset(12.5*frameSizeRate);
        make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
        make.height.mas_equalTo(20*frameSizeRate);
    }];
    
    
    self.managerLabel = [CBWtMINUtils createLabelWithText: @"哥哥" size: 13 * KFitWidthRate alignment: NSTextAlignmentCenter textColor: KWtRGB(254, 209, 85)];
    [self addSubview: self.managerLabel];
    self.managerLabel.layer.cornerRadius = 12*frameSizeRate;
    self.managerLabel.layer.borderWidth = 0.5;
    self.managerLabel.layer.borderColor = KWtRGB(254, 209, 85).CGColor;
    [self.managerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
        make.left.equalTo(self.nameLabel.mas_right).with.offset(12.5 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(0*frameSizeRate, 20*frameSizeRate));
        //make.height.mas_equalTo(20*frameSizeRate);
    }];
    
    self.mineLabel = [CBWtMINUtils createLabelWithText: @"哥哥" size: 13 * KFitWidthRate alignment: NSTextAlignmentCenter textColor: KWtRGB(254, 209, 85)];
    [self addSubview: self.mineLabel];
    self.mineLabel.layer.cornerRadius = 11.5*frameSizeRate;
    self.mineLabel.layer.borderWidth = 0.5;
    self.mineLabel.layer.borderColor = KWtRGB(254, 209, 85).CGColor;
    [self.mineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
        make.left.equalTo(self.managerLabel.mas_right).with.offset(12.5 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(0*frameSizeRate, 20*frameSizeRate));
        //make.height.mas_equalTo(20*frameSizeRate);
    }];
    
    self.relationTypeImageView =  [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"家人-图标"]];
    self.relationTypeImageView.contentMode = UIViewContentModeCenter;
    [self addSubview: self.relationTypeImageView];
    [self.relationTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
        make.left.equalTo(self.mineLabel.mas_right).with.offset(12.5 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(20 * KFitWidthRate, 20 * KFitWidthRate));
    }];
    
    
    self.phoneLabel = [CBWtMINUtils createLabelWithText: @"138 8888 8888" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWt137Color];
    [self addSubview: self.phoneLabel];
    [self.phoneLabel setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).offset(12.5*frameSizeRate);
        make.bottom.mas_equalTo(self.headImageView.mas_bottom).offset(0);
    }];
    UIImageView *rightDetailImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"arrow-右边"]];
    rightDetailImageView.contentMode = UIViewContentModeCenter;
    [self addSubview: rightDetailImageView];
    [rightDetailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(20 * KFitWidthRate, 20*frameSizeRate));
    }];
    UIView *lineView = [CBWtMINUtils createLineView];
    [self addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
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
        if (addressModel.type < 11) {
            [_headImageView sd_setImageWithURL: [NSURL URLWithString:addressModel.head] placeholderImage:[UIImage imageNamed:self.imageArr[addressModel.type]]];
        } else {
            [_headImageView sd_setImageWithURL: [NSURL URLWithString:addressModel.head] placeholderImage:[UIImage imageNamed: @"默认宝贝头像"]];
        }
        _nameLabel.text = kStringIsEmpty(addressModel.relation)?@"未命名":addressModel.relation;//addressModel.relation;
        if (addressModel.flag == YES) { // 表示是管理员
            _managerLabel.text = Localized(@"管理员");
            if ([addressModel.phone isEqualToString:[CBPetLoginModelTool getUser].phone]) {
                _mineLabel.text = Localized(@"我");
                [self.managerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
                    make.left.equalTo(self.nameLabel.mas_right).with.offset(12.5 * KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(60*frameSizeRate, 20*frameSizeRate));
                }];
                [self.mineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
                    make.left.equalTo(self.managerLabel.mas_right).with.offset(12.5 * KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(30*frameSizeRate, 20*frameSizeRate));
                }];
                [self.relationTypeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
                    make.left.equalTo(self.mineLabel.mas_right).with.offset(12.5 * KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(20 * KFitWidthRate, 20 * KFitWidthRate));
                }];
            } else {
                _mineLabel.text = @"";
                [self.managerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
                    make.left.equalTo(self.nameLabel.mas_right).with.offset(12.5 * KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(60*frameSizeRate, 20*frameSizeRate));
                }];
                [self.mineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
                    make.left.equalTo(self.managerLabel.mas_right).with.offset(0*KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(0*frameSizeRate, 20*frameSizeRate));
                }];
                [self.relationTypeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
                    make.left.equalTo(self.mineLabel.mas_right).with.offset(12.5 * KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(20 * KFitWidthRate, 20 * KFitWidthRate));
                }];
            }
        } else {
            if ([addressModel.phone isEqualToString:[CBPetLoginModelTool getUser].phone]) {
                _managerLabel.text = Localized(@"我");
                [self.managerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
                    make.left.equalTo(self.nameLabel.mas_right).with.offset(12.5 * KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(30*frameSizeRate, 20*frameSizeRate));
                }];
                [self.mineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
                    make.left.equalTo(self.managerLabel.mas_right).with.offset(0*KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(0*frameSizeRate, 20*frameSizeRate));
                }];
                [self.relationTypeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
                    make.left.equalTo(self.mineLabel.mas_right).with.offset(12.5 * KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(20 * KFitWidthRate, 20 * KFitWidthRate));
                }];
            } else if ([addressModel.family isEqualToString:@"2"]) { // family = 2 好友
                _managerLabel.text = Localized(@"好友");
                [self.managerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
                    make.left.equalTo(self.nameLabel.mas_right).with.offset(12.5*KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(60*frameSizeRate, 20*frameSizeRate));
                }];
                [self.mineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
                    make.left.equalTo(self.managerLabel.mas_right).with.offset(0*KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(0*frameSizeRate, 20*frameSizeRate));
                }];
                [self.relationTypeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
                    make.left.equalTo(self.mineLabel.mas_right).with.offset(12.5 * KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(0 * KFitWidthRate, 0 * KFitWidthRate));
                }];
            } else {
                _managerLabel.text = @"";
                [self.managerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
                    make.left.equalTo(self.nameLabel.mas_right).with.offset(0*KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(00*frameSizeRate, 20*frameSizeRate));
                }];
                [self.mineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
                    make.left.equalTo(self.managerLabel.mas_right).with.offset(0*KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(0*frameSizeRate, 20*frameSizeRate));
                }];
                [self.relationTypeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
                    make.left.equalTo(self.mineLabel.mas_right).with.offset(12.5 * KFitWidthRate);
                    make.size.mas_equalTo(CGSizeMake(20 * KFitWidthRate, 20 * KFitWidthRate));
                }];
            }
            _mineLabel.text = @"";
        }
        _phoneLabel.text = addressModel.phone?:Localized(@"未知号码");
        if ([addressModel.family isEqualToString:@"1"]) {
            [_relationTypeImageView setImage: [UIImage imageNamed: @"家人-图标"]];
        } else if ([addressModel.family isEqualToString:@"2"]) {
            // 校讯通
            [_relationTypeImageView setImage: [UIImage imageNamed:@""]];
        } else {
            [_relationTypeImageView setImage: [UIImage imageNamed: @"校讯通-图标"]];
        }
    }
}

@end
