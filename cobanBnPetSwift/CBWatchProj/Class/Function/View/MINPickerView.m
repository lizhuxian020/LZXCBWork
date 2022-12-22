//
//  MINPickerView.m
//  Telematics
//
//  Created by lym on 2017/11/1.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MINPickerView.h"

@interface MINPickerView() <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIView *contentView; // 显示pickerView和titleView的地方
    UIView *titleView; // 显示title和cancel、confirm的地方
    UIView *backView; // 背景
}
@property (nonatomic, strong) NSMutableDictionary *selectDic;
@end

@implementation MINPickerView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
        [self addAction];
        self.selectDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)showView
{
    if (contentView != nil) {
        [contentView.superview layoutIfNeeded];
        [UIView animateWithDuration: 0.3 animations:^{
            [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(backView.mas_bottom).with.offset(-265 * KFitHeightRate);
            }];
            [contentView.superview layoutIfNeeded];
        }];
    }
}

- (void)hideView
{
    if (contentView != nil) {
        [contentView.superview layoutIfNeeded];
        [UIView animateWithDuration: 0.3 animations:^{
            [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(backView.mas_bottom);
            }];
            [contentView.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - Btn Action
- (void)addAction
{
    [self.cancelBtn addTarget: self action: @selector(cancelBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.confirmBtn addTarget: self action: @selector(confirmBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)cancelBtnClick
{
    if ([self.delegate respondsToSelector: @selector(minPickerViewdidSelectCancelBtn:)]) {
        [self.delegate minPickerViewdidSelectCancelBtn: self];
    }
    [self hideView];
}

- (void)confirmBtnClick
{
    if (_didClickConfirm) {
        _didClickConfirm(_pickerView);
    } else {
        [self.delegate minPickerView: self didSelectWithDic: self.selectDic];
    }
    [self hideView];
}

#pragma mark - createUI
- (void)createUI
{
    [self createBackViewAndContentView];
    [self createTitleView];
    [self createPickerView];
}

- (void)createPickerView
{
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [contentView addSubview: _pickerView];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
//        make.bottom.equalTo(contentView).with.offset(-TabPaddingBARHEIGHT);
        make.bottom.equalTo(contentView).with.offset(-0);
        make.top.equalTo(titleView.mas_bottom);
    }];
}

- (void)createTitleView
{
    titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor whiteColor];;
    [contentView addSubview: titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(contentView);
        make.height.mas_equalTo(40 * KFitHeightRate);
    }];
    _cancelBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"取消") titleColor: kAppMainColor fontSize: 18 * KFitWidthRate];
    [titleView addSubview: _cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(titleView);
        //make.width.mas_equalTo(50 * KFitWidthRate);
        make.left.mas_equalTo(15*KFitHeightRate);
    }];
//    _titleLabel = [CBWtMINUtils createLabelWithText:Localized(@"标题") size: 15 * KFitHeightRate alignment: NSTextAlignmentCenter textColor: kAppMainColor];
//    [titleView addSubview: _titleLabel];
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(titleView);
//        make.width.mas_equalTo(200 * KFitWidthRate);
//        make.centerX.equalTo(titleView);
//    }];
    _confirmBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"确定") titleColor: kAppMainColor fontSize: 18 * KFitWidthRate];
    [titleView addSubview: _confirmBtn];
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(titleView);
        make.right.mas_equalTo(-15*KFitHeightRate);
        //make.width.mas_equalTo(50 * KFitWidthRate);
    }];
}

- (void)createBackViewAndContentView
{
    backView = [[UIView alloc] init];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.3];
    [self addSubview: backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
//        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    contentView = [[UIView alloc] init];
    contentView.backgroundColor = KWtBackColor;
    [backView addSubview: contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(backView.mas_bottom);
        make.height.mas_equalTo(265 * KFitHeightRate);
    }];
}
#pragma mark - pickerView delegate & datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.dataArr == nil) {
        return 0;
    }
    return self.dataArr.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.dataArr == nil) {
        return 0;
    }
    NSArray *titleArr = self.dataArr[component];
    return titleArr.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *pickView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 50*KFitWidthRate)];
    //pickView.backgroundColor = UIColor.blueColor;
    if (self.isPicturePickerView == YES) {
        UIImage *image = [UIImage imageNamed: self.dataArr[component][row]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
        [pickView addSubview: imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(pickView);
            make.size.mas_equalTo(image.size);
        }];
    }else {
        UILabel *label = [CBWtMINUtils createLabelWithText: self.dataArr[component][row] size:24*KFitWidthRate alignment: NSTextAlignmentCenter textColor: [UIColor blackColor]];
        //label.backgroundColor = UIColor.redColor;
        [pickView addSubview: label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(pickView);
        }];
//        UIView *topLine = [[UIView alloc]init];
//        topLine.backgroundColor = UIColor.blueColor;
//        [pickView addSubview:topLine];
//        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(label.mas_top).offset(2);
//            make.centerX.mas_equalTo(label.mas_centerX);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4 - 10, 1));
//        }];
//        UIView *bottomLine = [[UIView alloc]init];
//        bottomLine.backgroundColor = UIColor.blueColor;
//        [pickView addSubview:bottomLine];
//        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(label.mas_bottom).offset(-2);
//            make.centerX.mas_equalTo(label.mas_centerX);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4 - 10, 1));
//        }];
    }
    return pickView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.selectDic setObject: [NSNumber numberWithInteger: row] forKey: [NSString stringWithFormat:@"%ld", (long)component]];
    if ([self.delegate respondsToSelector: @selector(minPickerView:didSelectRow:inComponent:)]) {
        [self.delegate minPickerView:self didSelectRow:row inComponent:component];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50*KFitWidthRate;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return SCREEN_WIDTH/4;
}
#pragma mark - get & set
- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = [dataArr copy];
    if (_dataArr != nil && _selectDic != nil) {
        for ( int i = 0; i < _dataArr.count;  i++) {
            [_selectDic setObject: @0 forKey: [NSString stringWithFormat:@"%d", i]];
        }
    }
}

- (void)updateData:(NSArray *)data {
    _dataArr = [data copy];
    [self.pickerView reloadComponent:0];
}

@end
