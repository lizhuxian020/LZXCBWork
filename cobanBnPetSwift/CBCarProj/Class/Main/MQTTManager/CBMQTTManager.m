//
//  CBMQTTManager.m
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/19.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBMQTTManager.h"
#import <MQTTClient/MQTTClient.h>



@implementation MQTTClientModel

@end

@interface CBMQTTManager ()<MQTTSessionDelegate>

@property (nonatomic, strong)MQTTSession *session;

@end

@implementation CBMQTTManager

+ (instancetype)shared {
    static CBMQTTManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = CBMQTTManager.new;
    });
    return manager;
}


- (void)createMQTTClient:(MQTTClientModel *)model {
    self.session = MQTTSession.new;
    // 订阅主题
     MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
     transport.host = model.host;
     transport.port = model.port; //端口号
     // 给 session 对象设置基本信息
    self.session.transport = transport;
     // 设置代理 回调信息
    self.session.delegate = self;
     // 设置用户名称
    self.session.userName = model.userName;
//     // 设置用户密码
    self.session.password = model.password;
    self.session.clientId = model.clientId;
     // 设置会话链接超时时间
//     [self.session connectAndWaitTimeout:3];
}

- (void)startConnecet {
    if (self.session.status != MQTTSessionStatusConnecting && self.session.status != MQTTSessionStatusConnected) {
        [self.session connect];
    }
}

- (void)disConnecet {
    [self unsubscribeAllTopic];
    [self.session disconnect];
}

- (void)subscribeAllTopic {
    if (!kArrayIsEmpty(self.topicArr)) {
        for (NSString *topic in self.topicArr) {
            [self.session subscribeToTopic:topic atLevel:MQTTQosLevelAtMostOnce];
        }
    }
}
 
- (void)unsubscribeAllTopic {
    if (!kArrayIsEmpty(self.topicArr)) {
        for (NSString *topic in self.topicArr) {
            [self.session unsubscribeTopic:topic];
        }
    }
}

- (void)changeTopic:(NSArray *)newTopic {
    [self unsubscribeAllTopic];
    self.topicArr = newTopic;
    [self subscribeAllTopic];
}

#pragma mark - MQTTSession Delegate
/**
 订阅主题回调
 */
- (void)connected:(MQTTSession *)session {
    
    // MQTT连接成功，进行订阅主题 设置主题 服务质量
    [self subscribeAllTopic];
    NSLog(@"---lzx: mqttConnectSuccess");
}
/**
 订阅主题失败
 */
- (void)connectionError:(MQTTSession *)session error:(NSError *)error {
    NSLog(@"---lzx: mqttError: %@", error);

}
/**
 连接状态回调
 */
- (void)handleEvent:(MQTTSession *)session event:(MQTTSessionEvent)eventCode error:(NSError *)error {
    
    NSDictionary *events = @{
                             @(MQTTSessionEventConnected): @"连接成功",
                             @(MQTTSessionEventConnectionRefused): @"连接被拒绝",
                             @(MQTTSessionEventConnectionClosed): @"连接关闭",
                             @(MQTTSessionEventConnectionError): @"连接错误",
                             @(MQTTSessionEventProtocolError): @"协议不被接受/协议错误",
                             @(MQTTSessionEventConnectionClosedByBroker): @"其余错误"
                             };
    NSLog(@"--lzx mtqq eventCode:%@",events[@(eventCode)]);
    self.eventCode = eventCode;
    if(eventCode == MQTTSessionEventConnected) {
        [self subscribeAllTopic];
    } else {
        [self startConnecet];
    }
}

/**
 收到消息
 */
- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"--lzx mqtt newMessage: %@", dic);
    if (self.receivedMessageBlock) {
        self.receivedMessageBlock(dic);
    }
    // 进行下一步操作
    
}

@end
