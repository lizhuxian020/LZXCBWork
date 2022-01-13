//
//  CBShareFenceHeadView.m
//  Telematics
//
//  Created by coban on 2019/7/26.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBShareFenceHeadView.h"

@interface CBShareFenceHeadView ()
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *arrowImageBtn;
@property (nonatomic, strong) UIButton *headerBtn;
@end
@implementation CBShareFenceHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    // 创建圆角顶部背景view
    self.backgroundColor = kBackColor;
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = kRGB(243, 244, 245);
    backView.layer.cornerRadius = 5 * KFitHeightRate;
    [self addSubview: backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.top.left.equalTo(self).with.offset(12.5 * KFitHeightRate);
        make.right.equalTo(self).with.offset(-12.5 * KFitHeightRate);
    }];
    // 设置阴影的边框
    CGFloat cornerRadius = 5.f * KFitHeightRate;
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGRect bounds = CGRectMake(0, 0, SCREEN_HEIGHT - 25 * KFitWidthRate, 50 * KFitHeightRate);
    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds) - 1, CGRectGetMinY(bounds), CGRectGetMaxX(bounds)- 1, CGRectGetMidY(bounds), cornerRadius);
    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds)- 1, CGRectGetMaxY(bounds));
    CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
    layer.path = pathRef;
    CFRelease(pathRef);
    //        UIBezierPath *path = [UIBezierPath bezierPath];
    //        [path moveToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds))];
    //        [path addArc]
    [backView.layer insertSublayer: layer atIndex: 0];
    layer.strokeColor = kRGB(210, 210, 210).CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    // 设置backView的阴影
    //        backView.layer.shadowColor = [UIColor grayColor].CGColor;
    //        backView.layer.shadowRadius = 3 * KFitHeightRate;
    //        backView.layer.shadowOpacity = 1;
    //        backView.layer.shadowOffset  = CGSizeMake(0, 3);// 阴影的范围
    //        UIBezierPath *path = [UIBezierPath bezierPath];
    //        [path moveToPoint: CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds))];
    //        [path addLineToPoint: CGPointMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds))];
    //        [path moveToPoint: CGPointMake(CGRectGetMaxX(bounds), CGRectGetMinY(bounds))];
    //        [path addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))];
    //        backView.layer.shadowPath = path.CGPath;
    _selectBtn = [MINUtils createBtnWithNormalImage: [UIImage imageNamed: @"单选-没选中"] selectedImage: [UIImage imageNamed: @"单选-选中"]];
    [_selectBtn addTarget: self action: @selector(deviceSelectBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [backView addSubview: _selectBtn];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(backView);
        make.width.mas_equalTo(50 * KFitWidthRate);
    }];
    _titleLabel = [MINUtils createLabelWithText:@"博派 (30)" size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor:kRGB(96, 96, 96)];
    [backView addSubview: _titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBtn.mas_right).with.offset(0 * KFitWidthRate);
        make.centerY.equalTo(backView);
        make.height.mas_offset(20 * KFitHeightRate);
        make.width.mas_offset(250 * KFitWidthRate);
    }];
    _arrowImageBtn = [[UIButton alloc] init];
    UIImage *arrowImage = [UIImage imageNamed:@"右边"];
    UIImage *arrowImageDown = [UIImage imageNamed:@"下边"];
    [_arrowImageBtn setImage: [UIImage imageNamed:@"右边"] forState: UIControlStateNormal];
    [_arrowImageBtn setImage: [UIImage imageNamed:@"下边"] forState: UIControlStateSelected];
    [backView addSubview: _arrowImageBtn];
    [_arrowImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.right.mas_equalTo(backView).with.offset(- 13 * KFitWidthRate);
        //            make.centerY.equalTo(backView);
        //            make.height.mas_equalTo(arrowImage.size.height);
        //            make.width.mas_equalTo(arrowImage.size.width);
        make.right.mas_equalTo(backView.mas_right).offset(- 13 * KFitWidthRate);
        make.centerY.equalTo(backView.mas_centerY);
        make.height.mas_equalTo(arrowImage.size.height);
        make.width.mas_equalTo(arrowImageDown.size.width);
    }];
    _headerBtn = [[UIButton alloc] init];
    //_headerBtn.backgroundColor = [UIColor redColor];
    [_headerBtn addTarget: self action: @selector(deviceHeaderBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [backView addSubview: _headerBtn];
    [_headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(backView);
        make.left.equalTo(self.selectBtn.mas_right);
    }];
}
- (void)deviceHeaderBtnClick {
    if (self.headerBtnClick) {
        self.headerBtnClick(@"");
    }
}
- (void)deviceSelectBtnClick {
    if (self.deveiceGroup.noGroup) {
        if (self.deveiceGroup.noGroup.count <= 0) {
            return;
        }
    } else {
        if (self.deveiceGroup.device.count <= 0) {
            return;
        }
    }
    self.deveiceGroup.isCheck = !self.deveiceGroup.isCheck;
    if (self.selectBtnClick) {
        self.selectBtnClick(@"", self.selectBtn.selected);
    }
}
- (void)setDeveiceGroup:(CBHomeLeftMenuDeviceGroupModel *)deveiceGroup {
    _deveiceGroup = deveiceGroup;
    if (deveiceGroup) {
        if (deveiceGroup.noGroup) {
            self.titleLabel.text = [NSString stringWithFormat:@"%@(%ld)",Localized(@"默认分组") ,deveiceGroup.noGroup.count];
        } else {
            self.titleLabel.text = [NSString stringWithFormat:@"%@(%ld)",deveiceGroup.groupName?:@"",deveiceGroup.device.count];
        }
        self.selectBtn.selected = deveiceGroup.isCheck;
        self.arrowImageBtn.selected = deveiceGroup.isShow;
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
