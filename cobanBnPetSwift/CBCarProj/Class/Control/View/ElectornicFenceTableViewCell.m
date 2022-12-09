//
//  ElectornicFenceTableViewCell.m
//  Telematics
//
//  Created by lym on 2017/12/11.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "ElectornicFenceTableViewCell.h"

@interface ElectornicFenceTableViewCell ()

@property (nonatomic, strong) UIImageView *inImgView;

@property (nonatomic, strong) UIImageView *outImgView;

@property (nonatomic, strong) UIImageView *overImgView;

@end

@implementation ElectornicFenceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = UIColor.whiteColor;
    
    UIView *lastView = nil;
    for (int i = 0; i < 5; i++) {
        
        UIView *view = [UIView new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
            } else {
                make.left.equalTo(@0);
            }
            if (i == 0) {
                make.width.equalTo(self.contentView).multipliedBy(0.3);
            }
            if (i == 1 || i == 3 || i == 4) {
                make.width.equalTo(lastView);
            }
        }];
        if (i == 0) {
            [self addFenceName:view];
        }
        if (i == 1) {
            [self addDeviceLbl:view];
        }
        if (i == 2) {
            UIImageView *img = nil;
            [self addChooseView:view targetView:&img showArr:NO];
            self.inImgView = img;
        }
        if (i == 3) {
            UIImageView *img = nil;
            [self addChooseView:view targetView:&img showArr:NO];
            self.outImgView = img;
        }
        if (i == 4) {
            UIImageView *img = nil;
            [self addChooseView:view targetView:&img showArr:YES];
            self.overImgView = img;
        }
        lastView = view;
    }
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
    }];
    
//    _fenceNameLabel = [self createLabelWithText: @"超级围栏A"];
//    [self.contentView addSubview: _fenceNameLabel];
//    [_fenceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).with.offset(0);
//        make.top.bottom.equalTo(self.contentView);
//        make.width.mas_equalTo(90 * KFitWidthRate);
//    }];
//    UIImage *image = [UIImage imageNamed: @"多边形-1"];
//    _fenceTypeImageBtn = [[UIButton alloc] init];
//    [_fenceTypeImageBtn setImage: image forState: UIControlStateNormal];
//    _fenceTypeImageBtn.enabled = NO;
//    [self.contentView addSubview: _fenceTypeImageBtn];
//    [_fenceTypeImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_fenceNameLabel.mas_right);
//        make.top.bottom.equalTo(self.contentView);
//        make.width.mas_equalTo(65 * KFitWidthRate);
//    }];
//    _speedLabel = [self createLabelWithText: @"100KM/h"];
//    [self.contentView addSubview: _speedLabel];
//    [_speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_fenceTypeImageBtn.mas_right);
//        make.top.bottom.equalTo(self.contentView);
//        make.width.mas_equalTo(65 * KFitWidthRate);
//    }];
//    _alarmTypeLabel = [self createLabelWithText: @"入围栏报警"];
//    [self.contentView addSubview: _alarmTypeLabel];
//    [_alarmTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_speedLabel.mas_right);
//        make.top.bottom.equalTo(self.contentView);
//        make.width.mas_equalTo(125 * KFitWidthRate);
//    }];
//    UIImage *detailImage = [UIImage imageNamed: @"右边"];
//    UIImageView *detailImageView = [[UIImageView alloc] initWithImage: detailImage];
//    [self.contentView addSubview: detailImageView];
//    [detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
//        make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
//        make.size.mas_equalTo(CGSizeMake(detailImage.size.width * KFitHeightRate, detailImage.size.height * KFitHeightRate));
//    }];
}

- (void)addFenceName:(UIView *)view {
    UIImage *image = [UIImage imageNamed: @"多边形-1"];
    _fenceTypeImageBtn = [[UIButton alloc] init];
    [_fenceTypeImageBtn setImage: image forState: UIControlStateNormal];
    _fenceTypeImageBtn.enabled = NO;
    [view addSubview:_fenceTypeImageBtn];
    [_fenceTypeImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@15);
        make.bottom.equalTo(@-15);
    }];
    [_fenceTypeImageBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_fenceTypeImageBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    _fenceNameLabel = [self createLabelWithText: @"超级围栏A"];
    [view addSubview:_fenceNameLabel];
    [_fenceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fenceTypeImageBtn.mas_right);
        make.right.equalTo(@0);
        make.centerY.equalTo(@0);
    }];
}

- (void)addDeviceLbl:(UIView *)view {
    _deviceLbl = [self createLabelWithText:@"关联设备"];
    [view addSubview:_deviceLbl];
    _deviceLbl.numberOfLines = 0;
    [_deviceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

- (void)addChooseView:(UIView *)view targetView:(UIView **)targetView showArr:(BOOL)showArr {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"未选中1"]];
    [view addSubview:imgView];
    *targetView = imgView;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0);
    }];
    
    UIImageView *arr = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"查看"]];
    [view addSubview:arr];
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.equalTo(@0);
    }];
    arr.hidden = !showArr;
}

- (void)setIsIn:(BOOL)isIn {
    _isIn = isIn;
    self.inImgView.image = [UIImage imageNamed:isIn ? @"已选中1" : @"未选中1"];
}

- (void)setIsOut:(BOOL)isOut {
    _isOut = isOut;
    self.outImgView.image = [UIImage imageNamed:isOut ? @"已选中1" : @"未选中1"];
}

- (void)setIsOver:(BOOL)isOver {
    _isOver = isOver;
    self.overImgView.image = [UIImage imageNamed:isOver ? @"已选中1" : @"未选中1"];
}

- (UILabel *)createLabelWithText:(NSString *)text
{
    UILabel *label = [MINUtils createLabelWithText: text size:12 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: k137Color];
    return label;
}

- (void)addBottomLineView
{
    UIView *lineView = [MINUtils createLineView];
    [self.contentView addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.contentView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(self.contentView).with.offset(-12.5 * KFitWidthRate);
    }];
}

@end
