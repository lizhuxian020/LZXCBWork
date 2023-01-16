//
//  CBJiaShiXingWeiCell.h
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/16.
//  Copyright © 2023 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBJiaShiXingWeiModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBJiaShiXingWeiCell : UITableViewCell
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) CBJiaShiXingWeiModel *model;

@end

NS_ASSUME_NONNULL_END
