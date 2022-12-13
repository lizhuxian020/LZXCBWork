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

@interface __AlertDelegate : NSObject<UITextFieldDelegate>

@property (nonatomic, assign) BOOL isDigital;

@end

@implementation __AlertDelegate

#pragma mark -- UITextField 代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.isDigital) {
        BOOL isDigital = [string isOnlyNumber];
        return isDigital;
    }
    return YES;
}

@end

@implementation CBCarAlertView

+ (CBBasePopView *)viewWithMultiInput:(NSArray<NSString *> *)placeHolderArr
                                title:(NSString *)title
                    confirmCanDismiss:(nullable BOOL(^)(NSArray<NSString *> *contentStr))confirmCanDismiss
                              confrim:(void(^)(NSArray<NSString *> *contentStr))confirmBlk {
    return [self viewWithMultiInput:placeHolderArr title:title isDigital:NO confirmCanDismiss:confirmCanDismiss confrim:confirmBlk];
}

+ (CBBasePopView *)viewWithMultiInput:(NSArray<NSString *> *)placeHolderArr
                                title:(NSString *)title
                            isDigital:(BOOL)isDigital
                    confirmCanDismiss:(nullable BOOL(^)(NSArray<NSString *> *contentStr))confirmCanDismiss
                              confrim:(void(^)(NSArray<NSString *> *contentStr))confirmBlk {
    return [self viewWithMultiInput:placeHolderArr title:title isDigital:isDigital maxLength:6 confirmCanDismiss:confirmCanDismiss confrim:confirmBlk];
}

+ (CBBasePopView *)viewWithMultiInput:(NSArray<NSString *> *)placeHolderArr
                                title:(NSString *)title
                            isDigital:(BOOL)isDigital
                            maxLength:(int)maxLength
                    confirmCanDismiss:(nullable BOOL(^)(NSArray<NSString *> *contentStr))confirmCanDismiss
                              confrim:(void(^)(NSArray<NSString *> *contentStr))confirmBlk {
    UIView *c = [UIView new];
    
    NSMutableArray *tfArr = [NSMutableArray array];
    UIView *lastView = nil;
    
    __AlertDelegate *delegate = [__AlertDelegate new];
    delegate.isDigital = isDigital;
    
    for (NSString *placeHolder in placeHolderArr) {
        UIView *inputV = [UIView new];
        UITextField *tf = [UITextField new];
        if (isDigital) {
            tf.keyboardType = UIKeyboardTypeNumberPad;
            [tf limitTextFieldTextLength:maxLength];
        }
        tf.delegate = delegate;
        
        [tfArr addObject:tf];
        tf.placeholder = placeHolder;
        [inputV addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.height.equalTo(@60);
        }];
        inputV.layer.cornerRadius = 15;
        [inputV.layer setMasksToBounds:YES];
        inputV.layer.borderColor = KCarLineColor.CGColor;
        inputV.layer.borderWidth = 1;
        
        [c addSubview:inputV];
        [inputV mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).mas_offset(10);
            } else {
                make.top.equalTo(@10);
            }
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
        }];
        
        lastView = inputV;
    }
    
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-10);
    }];
    
    
    c.backgroundColor = UIColor.whiteColor;
    
    CBAlertBaseView *alertView = [[CBAlertBaseView alloc] initWithContentView:c title:title];
    
    CBBasePopView *popView = [[CBBasePopView alloc] initWithContentView:alertView];
    __weak CBBasePopView *wpopView = popView;
    [alertView setDidClickConfirm:^{
        delegate;//不能去掉=.=
        NSArray<NSString *> *resultArr = [tfArr valueForKey:@"text"];
        if (!confirmCanDismiss) {
            for (NSString *text in resultArr) {
                if (text.length == 0) {
                    [MINUtils showProgressHudToView:UIApplication.sharedApplication.keyWindow withText:Localized(@"参数不能为空")];
                    return;
                }
            }
        }
        if (confirmCanDismiss && !confirmCanDismiss([tfArr valueForKey:@"text"])) {
            return;
        }
        [wpopView dismiss];
        confirmBlk([tfArr valueForKey:@"text"]);
    }];
    [alertView setDidClickCancel:^{
        [wpopView dismiss];
    }];
    return popView;
}

+ (CBBasePopView *)viewWithPlaceholder:(NSString *)placeHolder
                                 title:(NSString *)title
                               confrim:(void(^)(NSString *contentStr))confirmBlk {
    return [self viewWithMultiInput:@[placeHolder] title:title confirmCanDismiss:nil confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
        confirmBlk(contentStr.firstObject);
    }];
}

+ (CBBasePopView *)viewWithAlertTips:(NSString *)tips
                               title:(NSString *)title
                             confrim:(void(^)(NSString *contentStr))confirmBlk {
    UIView *c = [UIView new];
    c.backgroundColor = UIColor.whiteColor;
    UILabel *lbl = [MINUtils createLabelWithText:tips size:17 alignment:NSTextAlignmentCenter textColor:kCellTextColor];
    lbl.numberOfLines = 0;
    [c addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@20);
        make.bottom.equalTo(@-20);
    }];
    
    CBAlertBaseView *alertView = [[CBAlertBaseView alloc] initWithContentView:c title:title];
    
    CBBasePopView *popView = [[CBBasePopView alloc] initWithContentView:alertView];
    __weak CBBasePopView *wpopView = popView;
    [alertView setDidClickConfirm:^{
        [wpopView dismiss];
        if (confirmBlk) {
            confirmBlk(@"");
        }
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
