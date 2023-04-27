//
//  CBCarAlertInputView.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/27.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBCarAlertView : NSObject


+ (CBBasePopView *)viewWithMultiInput:(NSArray<NSString *> *)placeHolderArr
                                title:(NSString *)title
                    confirmCanDismiss:(nullable BOOL(^)(NSArray<NSString *> *contentStr))confirmCanDismiss
                              confrim:(void(^)(NSArray<NSString *> *contentStr))confirmBlk;

+ (CBBasePopView *)viewWithMultiInput:(NSArray<NSString *> *)placeHolderArr
                                title:(NSString *)title
                            isDigital:(BOOL)isDigital
                    confirmCanDismiss:(nullable BOOL(^)(NSArray<NSString *> *contentStr))confirmCanDismiss
                              confrim:(void(^)(NSArray<NSString *> *contentStr))confirmBlk;

+ (CBBasePopView *)viewWithMultiInput:(NSArray<NSString *> *)placeHolderArr
                                title:(NSString *)title
                            isDigital:(BOOL)isDigital
                            maxLength:(int)maxLength
                    confirmCanDismiss:(nullable BOOL(^)(NSArray<NSString *> *contentStr))confirmCanDismiss
                              confrim:(void(^)(NSArray<NSString *> *contentStr))confirmBlk;

+ (CBBasePopView *)viewWithMultiInput:(NSArray<NSString *> *)placeHolderArr
                                title:(NSString *)title
                         isDigitalBlk:(BOOL(^)(int index))isDigitalBLK
                         maxLengthBlk:(int(^)(int index))maxLengthBlk
                          securityBLk:(BOOL(^)(int index))securityBLK
                    confirmCanDismiss:(nullable BOOL(^)(NSArray<NSString *> *contentStr))confirmCanDismiss
                              confrim:(void(^)(NSArray<NSString *> *contentStr, CBBasePopView *popView))confirmBlk;

+ (CBBasePopView *)viewWithAlertTips:(NSString *)tips
                               title:(NSString *)title
                             confrim:(void(^)(NSString *contentStr))confirmBlk;

+ (CBBasePopView *)viewWithAlertTips:(NSString *)tips
                               title:(NSString *)title
                              cancel:(void(^)(void))cancelBlk
                             confrim:(void(^)(NSString *contentStr))confirmBlk;

+ (CBBasePopView *)viewWithChooseData:(NSArray<NSString *> *)dataArr
                        selectedIndex:(NSInteger)index
                                title:(NSString *)title
                         didClickData:(void(^)(NSString *contentStr, NSInteger index))didClickData
                              confrim:(void(^)(NSString *contentStr, NSInteger index))confirmBlk;

+ (CBBasePopView *)viewWithScrollableChooseData:(NSArray<NSString *> *)dataArr
                                selectedIndex:(NSInteger)index
                                        title:(NSString *)title
                                 didClickData:(void(^)(NSString *contentStr, NSInteger index))didClickData
                                      confrim:(void(^)(NSString *contentStr, NSInteger index))confirmBlk;

/// 超速报警的设置弹框
+ (CBBasePopView *)viewWithCSBJTitle:(NSString *)title
                            initText:(NSString *)text
                                open:(BOOL)open
                             confrim:(void(^)(NSString *contentStr, BOOL isOpen))confirmBlk;
/// 时区设置的弹框
+ (CBBasePopView *)viewWithSQSZTitle:(NSString *)title
                            initText:(NSString *)text
                             confrim:(void(^)(NSString *contentStr))confirmBlk;

/// 子账户弹框
+ (CBBasePopView *)viewWithSubAccountAuthConfig:(UIView *)contentView
                                        confrim:(void(^)(NSString *contentStr))confirmBlk;

/// 只有图片没有按钮
/// - Parameter img: img description
+ (CBBasePopView *)viewWithImage:(UIImage *)img;

/// 一张图片, 带保存按钮和忽略按钮
/// - Parameter img: img description
+ (CBBasePopView *)viewWithImageURL:(NSString *)img title:(NSString *)title confrim:(void(^)(void))confirmBlk;

@end

NS_ASSUME_NONNULL_END
