//
//  CBMQTTManager.h
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/19.
//  Copyright © 2022 coban. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef  void(^ReceivedMessageBlock)(NSDictionary *   _Nonnull dataArr);

NS_ASSUME_NONNULL_BEGIN

@interface MQTTClientModel : NSObject
@property (nonatomic, strong) NSString *host ; /**< ip地址 **/
@property (nonatomic, assign) NSInteger port ; /**< 端口 **/
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *clientId;
@end

@interface CBMQTTManager : NSObject

@property (nonatomic, copy) NSString *currentUserId ; /** 当前用户id **/
@property (nonatomic, strong) NSArray *topicArr; //订阅主题
@property (nonatomic, copy)ReceivedMessageBlock receivedMessageBlock;
@property (nonatomic, assign)NSInteger eventCode;

+ (instancetype)shared;
- (void)createMQTTClient:(MQTTClientModel *)model;
- (void)startConnecet;//开始链接，要先设置topicArr
- (void)disConnecet; //断开连接
- (void)changeTopic:(NSArray *)newTopic; //更换订阅主题
- (void)checkAndChangeTopic;
@end

NS_ASSUME_NONNULL_END
