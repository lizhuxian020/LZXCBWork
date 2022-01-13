//
//  ShareFenceTableViewCell.h
//  Telematics
//
//  Created by lym on 2018/3/14.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBHomeLeftMenuModel.h"

@interface ShareFenceTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) BOOL isCreate; // 边界线用的，如果cell已经被创建出来了，就不用画边框了，如果没有创建需要画边框
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UILabel *deviceLabel;

@property (nonatomic,strong) CBHomeLeftMenuDeviceInfoModel *deviceInfoModel;

@end
