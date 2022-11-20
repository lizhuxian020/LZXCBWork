//
//  DeviceHeaderView.m
//  Telematics
//
//  Created by lym on 2017/11/6.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "DeviceHeaderView.h"

@implementation DeviceHeaderView

- (instancetype)init
{
    if (self = [super init]) {
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
//            make.edges.equalTo(@0);
        }];
        backView.layer.borderWidth = 1;
        backView.layer.borderColor = kRGB(210, 210, 210).CGColor;
        backView.layer.cornerRadius = 5.f * KFitHeightRate;
        
        
//        // 设置阴影的边框
//        CGFloat cornerRadius = 5.f * KFitHeightRate;
//        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//        CGMutablePathRef pathRef = CGPathCreateMutable();
//        CGRect bounds = CGRectMake(0, 0, SCREEN_HEIGHT - 25 * KFitWidthRate, 50 * KFitHeightRate);
//        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds) - 1, CGRectGetMinY(bounds), CGRectGetMaxX(bounds)- 1, CGRectGetMidY(bounds), cornerRadius);
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds)- 1, CGRectGetMaxY(bounds));
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//        layer.path = pathRef;
//        CFRelease(pathRef);
        
        
        //        UIBezierPath *path = [UIBezierPath bezierPath];
        //        [path moveToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds))];
        //        [path addArc]
        
        
//        [backView.layer insertSublayer: layer atIndex: 0];
//        layer.strokeColor = kRGB(210, 210, 210).CGColor;
//        layer.fillColor = [UIColor clearColor].CGColor;
        
        
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
        
        _titleLabel = [MINUtils createLabelWithText:@"博派 (30)" size: 15 * KFitHeightRate alignment: NSTextAlignmentLeft textColor:kRGB(96, 96, 96)];
        [backView addSubview: _titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).with.offset(13 * KFitWidthRate);
            make.centerY.equalTo(backView);
//            make.height.mas_offset(20 * KFitHeightRate);
//            make.width.mas_offset(250 * KFitWidthRate);
        }];
        _arrowImageBtn = [[UIButton alloc] init];
        UIImage *arrowImage = [UIImage imageNamed:@"上边"];
        UIImage *arrowImageRight = [UIImage imageNamed:@"右边"];
        [_arrowImageBtn setImage: [UIImage imageNamed:@"右边"] forState: UIControlStateNormal];
        [_arrowImageBtn setImage: [UIImage imageNamed:@"下边"] forState: UIControlStateSelected];
        [backView addSubview: _arrowImageBtn];
        [_arrowImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(backView).with.offset(- 13 * KFitWidthRate);
            make.centerY.equalTo(backView);
            make.height.mas_equalTo(arrowImageRight.size.height);
            make.width.mas_equalTo(arrowImage.size.width);
        }];
        _headerBtn = [[UIButton alloc] init];
        [_headerBtn addTarget: self action: @selector(deviceHeaderBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [backView addSubview: _headerBtn];
        [_headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.bottom.equalTo(backView);
        }];
        _deleteBtn = [MINUtils createNoBorderBtnWithTitle: @"删除" titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: kRGB(252, 30 , 28)];
        [_deleteBtn addTarget: self action: @selector(deviceDeleteBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [backView addSubview: _deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(backView);
            make.left.equalTo(backView.mas_right);
            make.width.mas_equalTo(80 * KFitWidthRate);
        }];
        _deleteBtn.hidden = YES;
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(longPressGRClick:)];
        longPressGR.minimumPressDuration = 0.6f;
        [self addGestureRecognizer: longPressGR];
    }
    return self;
}

- (void)longPressGRClick:(UILongPressGestureRecognizer *)lpGR
{
    if(lpGR.state == UIGestureRecognizerStateBegan){
        if (self.headerLongPressGesture) {
            self.headerLongPressGesture(self.section, self);
        }
    }
}

- (void)deviceHeaderBtnClick
{
    if (self.deleteBtn != nil && self.deleteBtn.hidden == NO) {
        [self hideDeleteBtn];
    }else {
        if (self.headerBtnClick) {
            self.headerBtnClick(self.section);
        }
    }
}

- (void)showDeleteBtn
{
    if (self.deleteBtn != nil) {
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration: 0.3 animations:^{
            [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.deleteBtn.superview.mas_right).with.offset(-80 * KFitWidthRate);
            }];
            self.deleteBtn.hidden = NO;
            [self.superview layoutIfNeeded];
        }];
    }
}

- (void)hideDeleteBtn
{
    if (self.deleteBtn != nil) {
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration: 0.3 animations:^{
            [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.deleteBtn.superview.mas_right);
            }];
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.deleteBtn.hidden = YES;
        }];
    }
}

- (void)deviceDeleteBtnClick
{
    if (self.deleteBtnClick) {
        self.deleteBtnClick(self.section);
    }
}

- (void)addLeftGesture
{
    UISwipeGestureRecognizer *leftSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(leftSwipeGR:)];
    [leftSwipeGR setDirection: UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer: leftSwipeGR];
}

- (void)leftSwipeGR:(UISwipeGestureRecognizer *)lsGR
{
    if (self.leftSwipeClick) {
        self.leftSwipeClick(self);
    }
    [self showDeleteBtn];
}


@end
