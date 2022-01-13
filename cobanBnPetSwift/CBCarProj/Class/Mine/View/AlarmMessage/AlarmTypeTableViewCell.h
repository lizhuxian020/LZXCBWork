//
//  AlarmTypeTableViewCell.h
//  Telematics
//
//  Created by lym on 2017/11/13.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmTypeTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *selectImageBtn;
@property (nonatomic, assign) BOOL isCreate; // 是否已经创建
- (void)addLineView;
@end
