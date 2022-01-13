//
//  DeviceTableViewCell.h
//  Telematics
//
//  Created by lym on 2017/10/28.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDeviceModel.h"

@interface DeviceTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *deviceCodeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *deviceImageView;
@property (nonatomic, strong) UIImageView *rightBtnImageView;
@property (nonatomic, assign) BOOL isCreate; // 边界线用的，如果cell已经被创建出来了，就不用画边框了，如果没有创建需要画边框
@property (nonatomic, assign) BOOL isEdit; // 删除按钮是否显示
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, copy) void (^deleteBtnClick)(NSIndexPath *indexPath);

@property (nonatomic, strong) MyDeviceModel *deviceInfoModel;

- (void)setImageType:(DeviceImageType)imageType deviceCodeText:(NSString *)deviceText contentLabelText:(NSString *)contentText;
- (void)setImageType:(DeviceImageType)imageType deviceCodeText:(NSString *)deviceText statusType:(DeviceStatusType)statusType;
- (void)addLeftSwipeGesture;
- (void)hideDeleteBtn;
@end
