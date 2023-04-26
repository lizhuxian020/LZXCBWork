//
//  _CBCarAlertMsgCell.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/24.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "_CBCarAlertMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface _CBCarAlertMsgCell : UITableViewCell
@property (nonatomic, strong, readonly) UIImageView *imgView;
@property (nonatomic, strong) _CBCarAlertMsgModel *model;

@property (nonatomic, copy) void (^didClickCheck)(void);
@property (nonatomic, copy) void (^didClickStop)(void);

+ (NSString *)type:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
