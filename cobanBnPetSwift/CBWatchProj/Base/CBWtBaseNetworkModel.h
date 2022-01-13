//
//  CBWtBaseNetworkModel.h
//  Telematics
//
//  Created by coban on 2019/7/17.
//  Copyright © 2019 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    CBWtNetworkingStatus0 = 0,//成功
    CBWtNetworkingStatus1 = 1,//成功
    CBWtNetworkingStatus2 = 2,//成功
    CBWtNetworkingStatus100 = 100,//参数错误
    CBWtNetworkingStatus101 = 101,//用户不存在
    CBWtNetworkingStatus102 = 102,//密码不正确
    CBWtNetworkingStatus103 = 103,//验证码不正确
    CBWtNetworkingStatus104 = 104,//码过期
    CBWtNetworkingStatus105 = 105,//无权限(需登录)
    CBWtNetworkingStatus106 = 106,//token过期
    CBWtNetworkingStatus107 = 107,//token不存在
    
    CBWtNetworkingStatus201 = 201,//券已过期
    CBWtNetworkingStatus202 = 202,//优惠券领取失败
    CBWtNetworkingStatus203 = 203,//不可重复领取
    CBWtNetworkingStatus204 = 204,//不可重复领取
    CBWtNetworkingStatus205 = 205,//不可重复领取
    
    CBWtNetworkingStatus501 = 501,//押金不足
    CBWtNetworkingStatus502 = 502,//余额不足
    CBWtNetworkingStatus503 = 503,//暂无设备可用
    CBWtNetworkingStatus504 = 504,//暂无可用仓位
    CBWtNetworkingStatus505 = 505, // 支付金额有误
    
    CBWtNetworkingStatus600 = 600,//未知逻辑错误
    CBWtNetworkingStatus601 = 601, // 请求数据有误(空指针异常)
    CBWtNetworkingStatus602 = 602,//设备离线
    
    /** 自定义  */
    CBWtNetworkingStatusFail = 3,//请求失败
} CBWtNetworkingStatus;
@interface CBWtBaseNetworkModel : NSObject
/** 返回请求数据  */
@property (nonatomic, strong) id data;
/** 返回提示信息  */
@property (nonatomic, copy) NSString *resmsg;
/** 0--成功  */
@property (nonatomic, assign) CBWtNetworkingStatus status;
/** 返回条数  */
@property (nonatomic, copy) NSString *total;
@end

// 获取七牛云上传token
@interface CBBaseQNYFileInfoModel : NSObject
/**   */
@property (nonatomic, copy) NSString *domain;
/**   */
@property (nonatomic, copy)NSString * key;
/**   */
@property (nonatomic, copy)NSString * token;
@end

NS_ASSUME_NONNULL_END
