//
//  ElectornicFenceTableViewCell.h
//  Telematics
//
//  Created by lym on 2017/12/11.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElectornicFenceTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *fenceNameLabel;
@property (nonatomic, strong) UIButton *fenceTypeImageBtn;
@property (nonatomic, strong) UILabel *deviceLbl;
@property (nonatomic, assign) BOOL isIn;
@property (nonatomic, assign) BOOL isOut;
@property (nonatomic, assign) BOOL isOver;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *alarmTypeLabel;

- (void)addBottomLineView;
@end
