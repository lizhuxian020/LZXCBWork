//
//  _CBXiuMianChooseView.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/30.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface _CBXiuMianChooseView : UIView

@property (nonatomic, assign) NSInteger currentIndex;

- (instancetype)initWithData:(NSArray *)data :(NSArray *)idArr;

@end

NS_ASSUME_NONNULL_END
