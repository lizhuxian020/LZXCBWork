//
//  FormHeaderView.m
//  Telematics
//
//  Created by lym on 2017/11/15.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "FormHeaderView.h"

@interface FormHeaderView()
{
    UIView *backView;
}
@property (nonatomic, strong) UIButton *headBtn;

@property (nonatomic, strong) UIView *expandableView;
@end

@implementation FormHeaderView

- (instancetype)init
{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = kBackColor;
    backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
    [self addSubview: backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self);
//        make.top.left.equalTo(self).with.offset(12.5 * KFitHeightRate);
//        make.right.equalTo(self).with.offset(-12.5 * KFitHeightRate);
        make.edges.equalTo(@0);
    }];
    UIImage *titleImage = [UIImage imageNamed: @"速度报表"];
    _titleImageView = [[UIImageView alloc] initWithImage: titleImage];
    [backView addSubview: _titleImageView];
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView);
        make.left.equalTo(backView).with.offset(12.5 * KFitWidthRate);
        make.size.mas_equalTo(CGSizeMake(titleImage.size.width * KFitHeightRate, titleImage.size.height * KFitHeightRate));
    }];
    _titleLabel = [MINUtils createLabelWithText: @"速度报表" size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kCellTextColor];
    [backView addSubview: _titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleImageView.mas_right).with.offset(12.5 * KFitWidthRate);
        make.centerY.equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(250 * KFitWidthRate, 20 * KFitHeightRate));
    }];
    UIImage *arrowImage = [UIImage imageNamed: @"右边"];
    _arrowImageBtn = [[UIButton alloc] init];
    [_arrowImageBtn setImage: arrowImage forState: UIControlStateNormal];
    [_arrowImageBtn setImage: [UIImage imageNamed:@"下边"] forState: UIControlStateSelected];
    [backView addSubview: _arrowImageBtn];
    [_arrowImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView);
        make.right.equalTo(backView).with.offset(-12.5 * KFitHeightRate);
        make.size.mas_equalTo(CGSizeMake(16 * KFitHeightRate, 16 * KFitHeightRate));
    }];
    _headBtn = [[UIButton alloc] init];
    [_headBtn addTarget: self action: @selector(headBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [backView addSubview: _headBtn];
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(backView);
    }];
    
    self.expandableView = [UIView new];
    self.expandableView.backgroundColor =kRGB(236, 236, 236);
    [backView addSubview:self.expandableView];
    [self.expandableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    self.expandableView.hidden = YES;
    _exTitleLabel = [MINUtils createLabelWithText: @"速度报表" size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kCellTextColor];
    [self.expandableView addSubview: _exTitleLabel];
    [_exTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(12.5 * KFitWidthRate));
        make.centerY.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(250 * KFitWidthRate, 20 * KFitHeightRate));
    }];
    _exArrowImageBtn = [[UIButton alloc] init];
    [_exArrowImageBtn setImage: arrowImage forState: UIControlStateNormal];
    [_exArrowImageBtn setImage: [UIImage imageNamed:@"下边"] forState: UIControlStateSelected];
    [self.expandableView addSubview: _exArrowImageBtn];
    [_exArrowImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-12.5 * KFitHeightRate));
        make.size.mas_equalTo(CGSizeMake(16 * KFitHeightRate, 16 * KFitHeightRate));
    }];
    
    [backView bringSubviewToFront:_headBtn];
}

- (void)headBtnClick
{
    if (self.headerBtnClick) {
        self.headerBtnClick(self.section);
    }
}

- (void)setDownforwardImage
{
    [_arrowImageBtn setImage: [UIImage imageNamed:@"右边"] forState: UIControlStateNormal];
    [_arrowImageBtn setImage: [UIImage imageNamed:@"下边"] forState: UIControlStateSelected];
    [_exArrowImageBtn setImage: [UIImage imageNamed:@"右边"] forState: UIControlStateNormal];
    [_exArrowImageBtn setImage: [UIImage imageNamed:@"下边"] forState: UIControlStateSelected];
}

//// 暂时不用
//- (void)setCornerWithSection:(NSInteger)section
//{
//    // 设置阴影的边框
//    CGFloat cornerRadius = 5.f * KFitHeightRate;
//    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//    CGMutablePathRef pathRef = CGPathCreateMutable();
//    CGRect bounds = CGRectMake(0, 0, SCREEN_HEIGHT - 12.5 * KFitWidthRate - 12.5 * KFitWidthRate, 50 * KFitHeightRate);
//    if (section == 5 || section == 6 || section == 8) {
//        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds) - 1, CGRectGetMinY(bounds), CGRectGetMaxX(bounds) -1, CGRectGetMidY(bounds), cornerRadius);
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds) - 1, CGRectGetMaxY(bounds));
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//    }else {
//        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMidY(bounds));
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds)-1, CGRectGetMinY(bounds), CGRectGetMaxX(bounds)-1, CGRectGetMidY(bounds), cornerRadius);
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds)-1, CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMidY(bounds), cornerRadius);
//    }
//
//    layer.path = pathRef;
//    CFRelease(pathRef);
//    //        UIBezierPath *path = [UIBezierPath bezierPath];
//    //        [path moveToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds))];
//    //        [path addArc]
//    [backView.layer insertSublayer: layer atIndex: 0];
//    layer.strokeColor = kCellBackColor.CGColor;
//    layer.fillColor = kCellBackColor.CGColor;
//}

- (void)addBottomLineView
{
    UIView *lineView = [MINUtils createLineView];
    [backView addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.titleImageView.mas_right);
        make.right.equalTo(self.arrowImageBtn.mas_right);
    }];
}

- (void)showExpandableView {
    self.expandableView.hidden = NO;
}
- (void)hideExpandableView {
    self.expandableView.hidden = YES;
}
@end
