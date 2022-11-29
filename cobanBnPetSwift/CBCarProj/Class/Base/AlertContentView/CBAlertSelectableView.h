//
//  CBAlertSelectableView.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/30.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBAlertSelectableView : UIView

@property (nonatomic, copy) void (^didSelected)(NSString *content, NSInteger index);
@property (nonatomic, assign) BOOL currentIndex;

- (instancetype)initWithData:(NSArray<NSString *> *)datas;

@end

NS_ASSUME_NONNULL_END
