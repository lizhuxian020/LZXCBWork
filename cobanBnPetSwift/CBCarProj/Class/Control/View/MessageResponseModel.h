//
//  MessageResponseModel.h
//  Telematics
//
//  Created by lym on 2017/12/25.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageResponseModel : NSObject
@property (nonatomic, copy) NSString *smsCount;     // sms消息应答重传次数
@property (nonatomic, copy) NSString *smsOuttime;   // sms消息应答超时时间
@property (nonatomic, copy) NSString *heartbeat;    // 心跳发送间隔
@property (nonatomic, copy) NSString *tcpCount;     // tcp消息应答重传次数
@property (nonatomic, copy) NSString *tcpOuttime;   // tcp消息应答超时时间
@property (nonatomic, copy) NSString *udpCount;     // udp消息应答重传次数
@property (nonatomic, copy) NSString *udpOuttime;   // udp消息应答超时时间
@end
