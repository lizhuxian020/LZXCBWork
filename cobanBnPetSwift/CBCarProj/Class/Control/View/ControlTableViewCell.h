//
//  ControlTableViewCell.h
//  Telematics
//
//  Created by lym on 2017/11/27.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBTerminalSwitchModel.h"
#import "_CBWIFIModel.h"
@class MINSwitchView;
@class CBControlModel;
@class MINControlListDataModel;
@class ConfigurationParameterModel;

@interface ControlTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *controlImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *switchDetailLabel;
@property (nonatomic, strong) UIImageView *detailImageView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^switchStateChangeBlock)(NSIndexPath *indexPath, BOOL isON);
@property (nonatomic, copy) NSString *detailStr;

- (void)showDetailViewWithIndexPath:(NSIndexPath *)indexPath titleStr:(NSString *)titleStr;

/** 设置图片和控件展示 */
@property (nonatomic, strong) CBControlModel *controlModel;
@property (nonatomic, strong) MINControlListDataModel *controlListModel;
@property (nonatomic, strong) ConfigurationParameterModel *configurationModel;
@property (nonatomic, strong) CBTerminalSwitchModel *switchModel;
@property (nonatomic, strong) _CBWIFIModel *wifiModel;
@end


/**
 cell模型
 */
@interface CBControlModel : NSObject
@property (nonatomic, copy) NSString *leftImageStr;
@property (nonatomic, copy) NSString *titleStr;
@end
