//
//  AutoReceiveTableViewCell.m
//  Watch
//
//  Created by lym on 2018/2/27.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "AutoReceiveTableViewCell.h"
#import "AddressBookModel.h"

@interface AutoReceiveTableViewCell ()
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,copy) NSArray *imageArr;
@end

@implementation AutoReceiveTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = UIColor.whiteColor;
    self.imageArr = @[@"爸爸", @"妈妈", @"姐姐", @"爷爷", @"奶奶", @"哥哥", @"外公", @"外婆", @"老师", @"自定义", @"校讯通"];
    [self titleLb];
    
    self.headImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"姐姐"]];
    self.headImageView.layer.cornerRadius = 25 * KFitWidthRate;
    self.headImageView.layer.borderColor = KWtLineColor.CGColor;
    self.headImageView.layer.borderWidth = 0.5;
    self.headImageView.layer.masksToBounds = YES;
    [self addSubview: self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLb.mas_bottom).offset(20);
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(50 * frameSizeRate, 50 * frameSizeRate));
    }];
    UIView *infoView = [[UIView alloc] init];
    [self addSubview: infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).with.offset(12.5 * KFitWidthRate);
        make.top.mas_equalTo(self.titleLb.mas_bottom).offset(20);
        make.right.equalTo(self).with.offset(-35 * KFitWidthRate);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    self.nameLabel = [CBWtMINUtils createLabelWithText: @"哥哥" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
    [infoView addSubview: self.nameLabel];
    [self.nameLabel setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(infoView);
        make.height.equalTo(infoView).dividedBy(2);
        make.width.mas_greaterThanOrEqualTo(30 * KFitWidthRate);
    }];
    self.phoneLabel = [CBWtMINUtils createLabelWithText: @"138 8888 8888" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWt137Color];
    [infoView addSubview: self.phoneLabel];
    [self.phoneLabel setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(infoView);
        make.height.equalTo(infoView).dividedBy(2);
        make.width.mas_greaterThanOrEqualTo(140 * KFitWidthRate);
    }];
    self.selectBtn = [CBWtMINUtils createBtnWithNormalImage: [UIImage imageNamed: @"选项-未选中"] selectedImage: [UIImage imageNamed: @"选项-选中"]];
    [self addSubview: self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.mas_equalTo(infoView);
        make.width.mas_equalTo(90 * KFitWidthRate);
    }];
    [self.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        
        UIView *grayView = [UIView new];
        grayView.backgroundColor = KWtBackColor;
        [self addSubview:grayView];
        [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(10);
        }];
        
        _titleLb = [CBWtMINUtils createLabelWithText: @"手表管理员" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
        [self addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
            make.top.equalTo(grayView.mas_bottom).offset(10);
            make.right.equalTo(self);
            make.height.mas_equalTo(20);
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = KWtBackColor;
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(_titleLb.mas_bottom).offset(10);
            make.right.equalTo(self);
            make.height.mas_equalTo(1);
        }];
    }
    return _titleLb;
}
- (void)setModel:(AddressBookModel *)model {
    _model = model;
    if (model) {
        self.selectBtn.selected = model.isAutoConnect;
        [self.headImageView sd_setImageWithURL: [NSURL URLWithString: model.head] placeholderImage: [UIImage imageNamed: self.imageArr[model.type]]];
        self.phoneLabel.text = model.phone;
        self.nameLabel.text = model.relation;
        if (model.flag == YES) {
            _titleLb.text = Localized(@"管理员");
        } else {
            if ([model.family isEqualToString:@"1"]) {
                _titleLb.text = Localized(@"家庭成员");
            } else {
                _titleLb.text = Localized(@"联系人");
            }
        }
    }
}
- (void)selectClick:(UIButton *)sender {
    _model.isAutoConnect = !_model.isAutoConnect;
    if (self.clickBlock) {
        self.clickBlock();
    }
}
@end
