//
//  CBBindMemberCollectionView.h
//  cobanBnWatch
//
//  Created by coban on 2019/12/6.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CBBindMemberCollectionViewDelegate <NSObject>

- (void)collectionClick:(NSInteger)index clickModel:(AddressBookModel *)model;

@end
@interface CBBindMemberCollectionView : UICollectionView
@property (nonatomic,weak) id<CBBindMemberCollectionViewDelegate>clickDelegate;
- (void)updaterDataArray:(NSMutableArray *)array;
@end

NS_ASSUME_NONNULL_END
