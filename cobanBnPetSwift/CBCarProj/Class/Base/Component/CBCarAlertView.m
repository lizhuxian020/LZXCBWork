//
//  CBCarAlertInputView.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/27.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBCarAlertView.h"
#import "CBAlertSelectableView.h"

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
@end
