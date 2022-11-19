//
//  CBCBCarMineHeaderView.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/20.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBCBCarMineHeaderView : UIView

@property (nonatomic, copy) void (^didClickTitle)(int index);

@end

NS_ASSUME_NONNULL_END
