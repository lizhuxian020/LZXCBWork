//
//  CBCarPaopaoView.h
//  Telematics
//
//  Created by coban on 2020/5/22.
//  Copyright © 2020 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBCarPaoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    /* 触屏，bgm以外的view关闭*/
    CBCarPaopaoViewClickTypeTap = 100,
    /* 回放*/
    CBCarPaopaoViewClickTypePlayBack = 101,
    /* 处理报警*/
    CBCarPaopaoViewClickTypeDeleteWarm = 102,
    /* 关闭*/
    CBCarPaopaoViewClickTypeClose = 103,
    /* 导航*/
    CBCarPaopaoViewClickTypeNavigationClick = 104,
    /* 跟踪*/
    CBCarPaopaoViewClickTypeTrack = 105,
    /* 跟踪*/
    CBCarPaopaoViewClickTypeTitle = 106,
} CBCarPaopaoViewClickType;


@interface CBCarPaopaoView : UIView

@property (nonatomic,copy) void (^clickBlock)(CBCarPaopaoViewClickType type, id obj);
@property (nonatomic, copy) void (^didClickMove)(NSString *moveStr);
@property (nonatomic,strong) DeviceDetailModel *deviceInfoModel;
@property (nonatomic, strong) CBCarPaoModel *paoModel;
@property (nonatomic, copy) NSString *dno;
/* 弹出框时，YES地图中心点不动 NO设置中心点*/
@property (nonatomic, assign) BOOL isAlertPaopaoView;

- (void)setAlertStyleIsWarmed:(BOOL)isWarmed;
- (void)popView;//弹出视图
- (void)dismiss;//隐藏视图

@end

NS_ASSUME_NONNULL_END
