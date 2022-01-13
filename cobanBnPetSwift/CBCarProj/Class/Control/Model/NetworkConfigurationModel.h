//
//  NetworkConfigurationModel.h
//  Telematics
//
//  Created by lym on 2017/12/25.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkConfigurationModel : NSObject
@property (nonatomic, copy) NSString *addrIp; // 请求服务器ip
@property (nonatomic, copy) NSString *addrName; // 请求服务器域名
@property (nonatomic, copy) NSString *addrTcp; // 请求服务器TCP端口
@property (nonatomic, copy) NSString *addrUdp; // 请求服务器UDP端口
@property (nonatomic, copy) NSString *linkApn; // 接入APN
@property (nonatomic, copy) NSString *linkPwd; // 接入密码
@property (nonatomic, copy) NSString *linkUser; // 接入用户名
@property (nonatomic, copy) NSString *masterIp; // 主服务器ip
@property (nonatomic, copy) NSString *masterName; // 主服务器域名
@property (nonatomic, copy) NSString *masterTcp; // 主服务器TCP端口
@property (nonatomic, copy) NSString *masterUdp; // 主服务器udp端口号
@property (nonatomic, copy) NSString *slaveIp; // 备份服务器ip
@property (nonatomic, copy) NSString *slaveName; // 备份域名
@end
