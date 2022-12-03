//
//  _CBCommandRecordCell.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/3.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "_CBCommandRecord.h"
NS_ASSUME_NONNULL_BEGIN

@interface _CBCommandRecordCell : UITableViewCell

@property (nonatomic, strong) _CBCommandRecord *model;

@end

NS_ASSUME_NONNULL_END
