//
//  CBCarAlertInputView.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/27.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBCarAlertInputView : NSObject


+ (CBBasePopView *)viewWithPlaceholder:(NSString *)placeHolder
                                 title:(NSString *)title
                               confrim:(void(^)(NSString *contentStr))confirmBlk;

@end

NS_ASSUME_NONNULL_END
