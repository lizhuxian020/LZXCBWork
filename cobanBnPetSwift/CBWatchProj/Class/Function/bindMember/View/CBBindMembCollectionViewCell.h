//
//  CBBindMembCollectionViewCell.h
//  cobanBnWatch
//
//  Created by coban on 2019/12/6.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBBindMembCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) AddressBookModel *addressModel;
@end

NS_ASSUME_NONNULL_END
