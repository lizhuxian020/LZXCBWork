//
//  CBEditWatchInfoTableViewCell.m
//  Watch
//
//  Created by coban on 2019/9/4.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBEditWatchInfoTableViewCell.h"

@implementation CBEditWatchInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
//    self.imageArr = @[@"爸爸", @"妈妈", @"姐姐", @"爷爷", @"奶奶", @"哥哥", @"外公", @"外婆", @"老师", @"自定义", @"校讯通"];
//    [self titleLb];
    self.backgroundColor = UIColor.whiteColor;
    self.headImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"姐姐"]];
    self.headImageView.layer.cornerRadius = 25 * frameSizeRate;
    self.headImageView.layer.borderColor = KWtLineColor.CGColor;
    self.headImageView.layer.borderWidth = 0.5;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview: self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(50 * frameSizeRate, 50 * frameSizeRate));
    }];
    
//    UIView *infoView = [[UIView alloc] init];
//    [self addSubview: infoView];
//    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.headImageView.mas_right).with.offset(12.5 * KFitWidthRate);
//        make.top.mas_equalTo(self.mas_bottom).offset(20);
//        make.right.equalTo(self).with.offset(-35 * KFitWidthRate);
//        make.height.mas_equalTo(50 * KFitWidthRate);
//    }];
    
    self.nameLabel = [CBWtMINUtils createLabelWithText: @"哥哥" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
    [self addSubview: self.nameLabel];
    [self.nameLabel setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).with.offset(12.5*frameSizeRate);
        //make.height.equalTo(infoView).dividedBy(2);
        make.top.mas_equalTo(self.headImageView.mas_top).offset(0);
        //make.width.mas_greaterThanOrEqualTo(30 * KFitWidthRate);
    }];
    self.phoneLabel = [CBWtMINUtils createLabelWithText: @"138 8888 8888" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWt137Color];
    [self addSubview: self.phoneLabel];
    [self.phoneLabel setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).with.offset(12.5*frameSizeRate);
//        make.height.equalTo(infoView).dividedBy(2);
//        make.width.mas_greaterThanOrEqualTo(140 * KFitWidthRate);
        make.bottom.mas_equalTo(self.headImageView.mas_bottom).offset(0);
    }];
    self.selectBtn = [CBWtMINUtils createBtnWithNormalImage: [UIImage imageNamed: @"选项-未选中"] selectedImage: [UIImage imageNamed: @"选项-选中"]];
    [self addSubview: self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.right.equalTo(self);
        make.right.equalTo(self).with.offset(-15*frameSizeRate);
        make.centerY.mas_equalTo(self.headImageView);
        make.width.mas_equalTo(90 * KFitWidthRate);
    }];
    self.selectBtn.userInteractionEnabled = NO;
//    [self.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = KWtBackColor;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headImageView.mas_bottom).offset(15);
        make.height.mas_equalTo(15);
    }];
    
}
//- (UILabel *)titleLb {
//    if (!_titleLb) {
//
//        UIView *grayView = [UIView new];
//        grayView.backgroundColor = KWtBackColor;
//        [self addSubview:grayView];
//        [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self);
//            make.top.equalTo(self);
//            make.right.equalTo(self);
//            make.height.mas_equalTo(10);
//        }];
//
//        _titleLb = [CBWtMINUtils createLabelWithText: @"手表管理员" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
//        [self addSubview:_titleLb];
//        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
//            make.top.equalTo(grayView.mas_bottom).offset(10);
//            make.right.equalTo(self);
//            make.height.mas_equalTo(20);
//        }];
//
//        UIView *lineView = [UIView new];
//        lineView.backgroundColor = KWtBackColor;
//        [self addSubview:lineView];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self);
//            make.top.equalTo(_titleLb.mas_bottom).offset(10);
//            make.right.equalTo(self);
//            make.height.mas_equalTo(1);
//        }];
//    }
//    return _titleLb;
//}
//- (void)setModel:(AddressBookModel *)model {
//    _model = model;
//    if (model) {
//        self.selectBtn.selected = model.isAutoConnect;
//        [self.headImageView sd_setImageWithURL: [NSURL URLWithString: model.head] placeholderImage: [UIImage imageNamed: self.imageArr[model.type]]];
//        self.phoneLabel.text = model.phone;
//        self.nameLabel.text = model.relation;
//        if (model.flag == YES) {
//            _titleLb.text = @"管理员";
//        } else {
//            _titleLb.text = @"联系人";
//        }
//    }
//}
//- (void)selectClick:(UIButton *)sender {
//    _model.isAutoConnect = !_model.isAutoConnect;
//    if (self.clickBlock) {
//        self.clickBlock();
//    }
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
