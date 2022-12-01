//
//  CBCarAlertInputView.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/27.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBCarAlertView.h"
#import "CBAlertSelectableView.h"
#import "MINPickerView.h"
@implementation CBCarAlertView

+ (CBBasePopView *)viewWithPlaceholder:(NSString *)placeHolder
                                 title:(NSString *)title
                               confrim:(void(^)(NSString *contentStr))confirmBlk {
    UIView *c = [UIView new];
    
    UIView *inputV = [UIView new];
    UITextField *tf = [UITextField new];
    tf.placeholder = placeHolder;
    [inputV addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(@0);
        make.top.bottom.equalTo(@0);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@30);
    }];
    inputV.layer.cornerRadius = 15;
    [inputV.layer setMasksToBounds:YES];
    inputV.layer.borderColor = UIColor.blackColor.CGColor;
    inputV.layer.borderWidth = 1;
    
    [c addSubview:inputV];
    [inputV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.bottom.right.equalTo(@-10);
    }];
    c.backgroundColor = UIColor.whiteColor;
    
    __weak UITextField *wtf = tf;
    CBAlertBaseView *alertView = [[CBAlertBaseView alloc] initWithContentView:c title:title];
    
    CBBasePopView *popView = [[CBBasePopView alloc] initWithContentView:alertView];
    __weak CBBasePopView *wpopView = popView;
    [alertView setDidClickConfirm:^{
        confirmBlk(wtf.text);
        [wpopView dismiss];
    }];
    [alertView setDidClickCancel:^{
        [wpopView dismiss];
    }];
    return popView;
}

+ (CBBasePopView *)viewWithAlertTips:(NSString *)tips
                               title:(NSString *)title
                             confrim:(void(^)(NSString *contentStr))confirmBlk {
    UIView *c = [UIView new];
    c.backgroundColor = UIColor.whiteColor;
    UILabel *lbl = [MINUtils createLabelWithText:tips size:14 alignment:NSTextAlignmentCenter textColor:kCellTextColor];
    [c addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@15);
        make.bottom.equalTo(@-15);
    }];
    
    CBAlertBaseView *alertView = [[CBAlertBaseView alloc] initWithContentView:c title:title];
    
    CBBasePopView *popView = [[CBBasePopView alloc] initWithContentView:alertView];
    __weak CBBasePopView *wpopView = popView;
    [alertView setDidClickConfirm:^{
        [wpopView dismiss];
    }];
    [alertView setDidClickCancel:^{
        [wpopView dismiss];
    }];
    return popView;
}

+ (CBBasePopView *)viewWithChooseData:(NSArray<NSString *> *)dataArr
                        selectedIndex:(NSInteger)index
                                title:(NSString *)title
                         didClickData:(void(^)(NSString *contentStr, NSInteger index))didClickData
                              confrim:(void(^)(NSString *contentStr, NSInteger index))confirmBlk {
    CBAlertSelectableView *c = [[CBAlertSelectableView alloc] initWithData:dataArr];
    c.currentIndex = index;
    CBAlertBaseView *alertView = [[CBAlertBaseView alloc] initWithContentView:c title:title];
    
    CBBasePopView *popView = [[CBBasePopView alloc] initWithContentView:alertView];
    __weak CBBasePopView *wpopView = popView;
    __weak CBAlertSelectableView *wc = c;
    [alertView setDidClickConfirm:^{
        confirmBlk(dataArr[wc.currentIndex], 0);
        [wpopView dismiss];
    }];
    [alertView setDidClickCancel:^{
        [wpopView dismiss];
    }];
    return popView;
}

+ (CBBasePopView *)viewWithCSBJTitle:(NSString *)title
                            initText:(NSString *)text
                                open:(BOOL)open
                             confrim:(void(^)(NSString *contentStr))confirmBlk {
    
    UIView *v = [UIView new];
    v.backgroundColor = UIColor.whiteColor;
    UITextField *tf = [UITextField new];
    tf.textAlignment = NSTextAlignmentCenter;
    tf.text = text;
    
    [v addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(v.mas_centerX).mas_offset(-5);
        make.top.equalTo(@15);
        make.bottom.equalTo(@-15);
    }];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    
    UISwitch *s = [UISwitch new];
    s.on = open;
    [v addSubview:s];
    [s mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tf);
        make.left.equalTo(v.mas_centerX).mas_offset(5);
    }];
    
    CBAlertBaseView *alertView = [[CBAlertBaseView alloc] initWithContentView:v title:title];
    
    CBBasePopView *popView = [[CBBasePopView alloc] initWithContentView:alertView];
    __weak CBBasePopView *wpopView = popView;
    [alertView setDidClickConfirm:^{
        [wpopView dismiss];
    }];
    [alertView setDidClickCancel:^{
        [wpopView dismiss];
    }];
    return popView;
}

+ (CBBasePopView *)viewWithSQSZTitle:(NSString *)title
                            initText:(NSString *)text
                             confrim:(void(^)(NSString *contentStr))confirmBlk {
    
    NSArray *arrayData = @[
        @"-12",
        @"-11",
        @"-10",
        @"-9.5",
        @"-9",
        @"-8",
        @"-7",
        @"-6",
        @"-5",
        @"-4",
        @"-3",
        @"-2",
        @"-1",
        @"0",
        @"+1",
        @"+2",
        @"+3",
        @"+3.5",
        @"+4",
        @"+4.5",
        @"+5",
        @"+5.5",
        @"+5.75",
        @"+6",
        @"+7",
        @"+8",
        @"+8.75",
        @"+9",
        @"+9.5",
        @"+10",
        @"+10.5",
        @"+11",
        @"+12",
    ];
    
    NSString *targetText = @(text.intValue).description;
    if (targetText.intValue > 0) {
        targetText = [@"+" stringByAppendingString:targetText];
    }
    NSInteger index = [arrayData indexOfObject:targetText];
    
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor whiteColor];
    UIPickerView *pickView = [UIPickerView new];
    [v addSubview:pickView];
    [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
        make.height.equalTo(@200);
    }];
    MINPickerView *delegate = [MINPickerView new];
    delegate.dataArr = @[
        arrayData,
        @[Localized(@"时区")],
    ];
    pickView.delegate = delegate;
    pickView.dataSource = delegate;
    if (index != NSNotFound) {
        [pickView selectRow:index inComponent:0 animated:NO];
    }
    
    CBAlertBaseView *alertView = [[CBAlertBaseView alloc] initWithContentView:v title:title];
    
    CBBasePopView *popView = [[CBBasePopView alloc] initWithContentView:alertView];
    __weak CBBasePopView *wpopView = popView;
    [alertView setDidClickConfirm:^{
        delegate;
        NSInteger index = [pickView selectedRowInComponent:0];
        NSLog(@"---seleted: %@", arrayData[index]);
        [wpopView dismiss];
    }];
    [alertView setDidClickCancel:^{
        [wpopView dismiss];
    }];
    return popView;
}
@end
