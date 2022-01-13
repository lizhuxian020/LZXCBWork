//
//  CBAccountPopHeadView.m
//  Telematics
//
//  Created by coban on 2019/12/26.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBAccountPopHeadView.h"

@interface CBAccountPopHeadView ()
/** 卡片view */
@property (nonatomic, strong) UIView *cardView;
/** 勾选btn */
@property (nonatomic,strong) UIButton *pickBtn;
/** 标题 */
@property (nonatomic,strong) UILabel *sectionTitleLabel;
/** 箭头 */
@property (nonatomic,strong) UIButton *btnArrow;
/** head btn */
@property (nonatomic,strong) UIButton *btnHead;
@end
@implementation CBAccountPopHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
}
- (void)setupView {
    self.backgroundColor = [UIColor redColor];
    [self cardView];
    [self pickBtn];
    [self sectionTitleLabel];
    [self btnArrow];
}
#pragma mark -- getting && setting
- (UIView *)cardView {
    if (!_cardView) {
        _cardView = [UIView new];
        _cardView.backgroundColor = kBackColor;//[UIColor whiteColor];
//        _cardView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
//        _cardView.layer.shadowOffset = CGSizeMake(0,5);
//        _cardView.layer.shadowRadius = 10;
//        _cardView.layer.shadowOpacity = 1;
//        _cardView.layer.cornerRadius = 5*KFitHeightRate;
        
//        _cardView.layer.borderWidth = 1.0f;
//        _cardView.layer.borderColor = kRGB(210, 210, 210).CGColor;
        
        [self addSubview:_cardView];
        [_cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0*KFitWidthRate);
            make.right.mas_equalTo(-0*KFitWidthRate);
            //make.top.mas_equalTo(13*KFitHeightRate);
            make.top.mas_equalTo(8*KFitHeightRate);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _cardView;
}
- (UIButton *)pickBtn {
    if (!_pickBtn) {
        UIImage *selectImg = [UIImage imageNamed:@"单选-没选中"];
        //UIImage *selectedImg = [UIImage imageNamed:@"单选-选中"];
        _pickBtn = [[UIButton alloc] init];
        [_pickBtn setImage: [UIImage imageNamed:@"单选-没选中"] forState: UIControlStateNormal];
        [_pickBtn setImage: [UIImage imageNamed:@"单选-选中"] forState: UIControlStateSelected];
        [_pickBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:20];
        [_pickBtn addTarget:self action:@selector(headBtnCheckClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.cardView addSubview:_pickBtn];
        [_pickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.cardView.mas_left).offset(13 * KFitWidthRate);
            make.centerY.equalTo(self.cardView.mas_centerY);
            make.height.mas_equalTo(selectImg.size.height);
            make.width.mas_equalTo(selectImg.size.width);
        }];
    }
    return _pickBtn;
}
- (UILabel *)sectionTitleLabel {
    if (!_sectionTitleLabel) {
        
        _sectionTitleLabel = [MINUtils createLabelWithText:@"博派 (30)" size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor:kRGB(96, 96, 96)];
        [self.cardView addSubview: _sectionTitleLabel];
        [_sectionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pickBtn.mas_right).offset(13*KFitWidthRate);
            make.centerY.equalTo(self.cardView.mas_centerY);
            make.height.mas_offset(20 * KFitHeightRate);
            make.width.mas_offset(250 * KFitWidthRate);
        }];
    }
    return _sectionTitleLabel;
}
- (UIButton *)btnArrow {
    if (!_btnArrow) {
        
        UIImage *arrowImage = [UIImage imageNamed:@"右边"];
        UIImage *arrowImageDown = [UIImage imageNamed:@"下边"];
        _btnArrow = [[UIButton alloc] init];
        [_btnArrow setImage: [UIImage imageNamed:@"右边"] forState: UIControlStateNormal];
        [_btnArrow setImage: [UIImage imageNamed:@"下边"] forState: UIControlStateSelected];
        [self.cardView addSubview: _btnArrow];
        [_btnArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.cardView.mas_right).offset(- 13 * KFitWidthRate);
            make.centerY.equalTo(self.cardView.mas_centerY);
            make.height.mas_equalTo(arrowImage.size.height);
            make.width.mas_equalTo(arrowImageDown.size.width);
        }];
        
        _btnHead = [[UIButton alloc] init];
        [_btnHead addTarget: self action: @selector(headerBtnClick:) forControlEvents: UIControlEventTouchUpInside];
        [self.cardView addSubview: _btnHead];
        [_btnHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.cardView);
            make.left.equalTo(self.pickBtn.mas_right).offset(13*KFitWidthRate);
        }];
        [self.cardView bringSubviewToFront:_btnHead];
    }
    return _btnArrow;
}
- (void)headBtnCheckClick:(UIButton *)sender {
    self.deviceGoupModel.isCheck = !self.deviceGoupModel.isCheck;
    self.pickBtn.selected = self.deviceGoupModel.isCheck;
    if (self.headClickBlock) {
        self.headClickBlock(@"");
    }
}
- (void)headerBtnClick:(UIButton *)sender {
    self.deviceGoupModel.isShow = !self.deviceGoupModel.isShow;
    self.btnArrow.selected = self.deviceGoupModel.isShow;
    if (self.headClickBlock) {
        self.headClickBlock(@"");
    }
}
- (void)setDeviceGoupModel:(CBHomeLeftMenuDeviceGroupModel *)deviceGoupModel {
    _deviceGoupModel = deviceGoupModel;
    if (deviceGoupModel) {
        self.btnArrow.selected = deviceGoupModel.isShow;
        self.pickBtn.selected = deviceGoupModel.isCheck;
        if (deviceGoupModel.noGroup) {
            _sectionTitleLabel.text = [NSString stringWithFormat:@"%@(%ld)",Localized(@"默认分组") ,deviceGoupModel.noGroup.count];
        } else {
            _sectionTitleLabel.text = [NSString stringWithFormat:@"%@(%ld)",deviceGoupModel.groupName?:@"",deviceGoupModel.device.count];
        }
    }
}
@end
