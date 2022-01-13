//
//  CBTalkCollectionView.h
//  Watch
//
//  Created by coban on 2019/9/6.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBTalkModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CBTalkCollectionViewDelegate <NSObject>

- (void)collectionClick:(NSInteger)index clickModel:(CBTalkMemberModel *)model;

@end

@interface CBTalkCollectionView : UICollectionView
@property (nonatomic,weak) id<CBTalkCollectionViewDelegate>clickDelegate;
- (void)updateTalkMemberDataArray:(NSMutableArray *)array;
@end

NS_ASSUME_NONNULL_END
