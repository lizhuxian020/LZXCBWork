//
//  NotificationCenterTableViewCell.h
//  Watch
//
//  Created by lym on 2018/3/7.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageModel;

typedef NS_ENUM(NSInteger, MINNotifationType)
{
    MINNotifationTypeLocationChange,
    MINNotifationTypeSettingChange,
    MINNotifationTypeGuard,
    MINNotifationTypeWarning,
    MINNotifationTypeApplying,
    MINNotifationTypeApplyed
};

@interface NotificationCenterTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *notiTypeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *refuseBtn;
@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, strong) UILabel *applyStatueLabel;
@property (nonatomic, copy) void (^refuseBtnClickBlock)(void);
@property (nonatomic, copy) void (^agreeBtnClickBlock)(void);

@property (nonatomic, strong) MessageModel *messageModel;

//- (void)setNotiType:(MINNotifationType)type isRead:(BOOL)isRead;
//- (void)setApplyStatus:(int)status;
@end
