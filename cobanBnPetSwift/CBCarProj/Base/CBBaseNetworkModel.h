//
//  CBBaseNetworkModel.h
//  Telematics
//
//  Created by coban on 2019/7/17.
//  Copyright © 2019 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    CBNetworkingStatus0 = 0,//成功
    CBNetworkingStatus100 = 100,//参数错误
    CBNetworkingStatus101 = 101,//用户不存在
    CBNetworkingStatus102 = 102,//密码不正确
    CBNetworkingStatus103 = 103,//验证码不正确
    CBNetworkingStatus104 = 104,//码过期
    CBNetworkingStatus105 = 105,//无权限(需登录)
    CBNetworkingStatus106 = 106,//token过期
    CBNetworkingStatus107 = 107,//token不存在
    
    CBNetworkingStatus201 = 201,//券已过期
    CBNetworkingStatus202 = 202,//优惠券领取失败
    CBNetworkingStatus203 = 203,//不可重复领取
    
    CBNetworkingStatus501 = 501,//押金不足
    CBNetworkingStatus502 = 502,//余额不足
    CBNetworkingStatus503 = 503,//暂无设备可用
    CBNetworkingStatus504 = 504,//暂无可用仓位
    CBNetworkingStatus505 = 505, // 支付金额有误
    
    CBNetworkingStatus600 = 600,//未知逻辑错误
    CBNetworkingStatus601 = 601, // 请求数据有误(空指针异常)
    CBNetworkingStatus602 = 602,//设备离线
    
    /** 自定义  */
    CBNetworkingStatusFail = 3,//请求失败
} CBNetworkingStatus;
@interface CBBaseNetworkModel : NSObject
/** 返回请求数据  */
@property (nonatomic, strong) id data;
/** 返回提示信息  */
@property (nonatomic, copy) NSString *resmsg;
/** 0--成功  */
@property (nonatomic, assign) CBNetworkingStatus status;
/** 返回条数  */
@property (nonatomic, copy) NSString *total;
@end

NS_ASSUME_NONNULL_END
