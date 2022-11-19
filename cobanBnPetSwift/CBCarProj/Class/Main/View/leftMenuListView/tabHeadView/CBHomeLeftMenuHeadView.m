//
//  CBHomeLeftMenuHeadView.m
//  Telematics
//
//  Created by coban on 2019/7/18.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBHomeLeftMenuHeadView.h"
#import "MainViewConfig.h"

@interface CBHomeLeftMenuHeadView ()
/** 卡片view */
@property (nonatomic, strong) UIView *cardView;
/** 标题 */
@property (nonatomic,strong) UILabel *sectionTitleLabel;
/** 箭头 */
@property (nonatomic,strong) UIButton *btnArrow;
/** head btn */
@property (nonatomic,strong) UIButton *btnHead;
@end
@implementation CBHomeLeftMenuHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
    
        [self setupView];
    }
    return self;
}
- (void)setupView {
    //self.backgroundColor = [UIColor whiteColor];
    [self cardView];
    [self sectionTitleLabel];
    [self btnArrow];
}
#pragma mark -- getting && setting
- (UIView *)cardView {
    if (!_cardView) {
        _cardView = [UIView new];
        _cardView.backgroundColor = [UIColor whiteColor];
        _cardView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
        _cardView.layer.shadowOffset = CGSizeMake(0,5);
        _cardView.layer.shadowRadius = 10;
        _cardView.layer.shadowOpacity = 1;
        _cardView.layer.cornerRadius = 5*KFitHeightRate;
        
        _cardView.layer.borderWidth = 1.0f;
        _cardView.layer.borderColor = kRGB(210, 210, 210).CGColor;
        
        [self addSubview:_cardView];
        [_cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(HomeLeftMenu_Padding);
            make.right.mas_equalTo(-HomeLeftMenu_Padding);
            make.top.mas_equalTo(HomeLeftMenu_Padding);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _cardView;
}
- (UILabel *)sectionTitleLabel {
    if (!_sectionTitleLabel) {
        
        _sectionTitleLabel = [MINUtils createLabelWithText:@"博派 (30)" size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor:kRGB(96, 96, 96)];
        [self.cardView addSubview: _sectionTitleLabel];
        [_sectionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cardView.mas_left).offset(13*KFitWidthRate);
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
            make.top.right.left.bottom.equalTo(self.cardView);
        }];
        [self.cardView bringSubviewToFront:_btnHead];
    }
    return _btnArrow;
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
        if (deviceGoupModel.noGroup) {
            _sectionTitleLabel.text = [NSString stringWithFormat:@"%@(%ld)",Localized(@"默认分组") ,deviceGoupModel.noGroup.count];
        } else {
            _sectionTitleLabel.text = [NSString stringWithFormat:@"%@(%ld)",deviceGoupModel.groupName?:@"",deviceGoupModel.device.count];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
