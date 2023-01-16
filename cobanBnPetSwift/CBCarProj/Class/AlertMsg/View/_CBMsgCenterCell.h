//
//  _CBMsgCenterCell.h
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/16.
//  Copyright © 2023 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "_CBMsgCenterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface _CBMsgCenterCell : UITableViewCell

@property (nonatomic, strong) _CBMsgCenterModel *model;

@property (nonatomic, copy) void (^didClickCheck)(void);

@end

NS_ASSUME_NONNULL_END
