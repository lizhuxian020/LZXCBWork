//
//  CBBasePopView.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/23.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBBasePopView : UIView

@property (nonatomic, strong) UIView *contentView;

- (instancetype)initWithContentView:(UIView *)content;

- (void)pop;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
