//
//  CBTalkCollectionViewCell.h
//  Watch
//
//  Created by coban on 2019/9/6.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBTalkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBTalkCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) CBTalkMemberModel *talkModel;
@end

NS_ASSUME_NONNULL_END
