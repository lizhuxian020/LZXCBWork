//
//  CBWtNetworkRequestManager.h
//  Telematics
//
//  Created by coban on 2019/7/17.
//  Copyright © 2019 coban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBWtNetworkingServers.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^requestReuslt)(id objc);

@interface CBWtNetworkRequestManager : NSObject

+ (instancetype)sharedInstance;

/** 获取验证码  */
- (void)getPhoneCodeParamters:(NSMutableDictionary *)paramters
                      success:(CBWtSuccessBlock)success
                      failure:(CBWtFailureBlock)failure;
/** 登录  */
- (void)loginParamters:(NSMutableDictionary *)paramters
                      success:(CBWtSuccessBlock)success
                      failure:(CBWtFailureBlock)failure;
/** 退出登录  */
- (void)logoutSuccess:(CBWtSuccessBlock)success
               failure:(CBWtFailureBlock)failure;
/** 获取首页数据  */
- (void)getHomePageInfoSuccess:(CBWtSuccessBlock)success
                       failure:(CBWtFailureBlock)failure;
/** 更新手表位置  */
- (void)updateWatchPositionParmters:(NSMutableDictionary *)paramters
                            success:(CBWtSuccessBlock)success
                           failure:(CBWtFailureBlock)failure;
/** 获取学校和家庭的坐标定位  */
- (void)getSchoolAndHomePositionParamters:(NSMutableDictionary *)paramters
                                  success:(CBWtSuccessBlock)success
                                  failure:(CBWtFailureBlock)failure;
/** 校验手表  */
- (void)checkWatchSnoParamters:(NSMutableDictionary *)paramters
                       success:(CBWtSuccessBlock)success
                       failure:(CBWtFailureBlock)failure;

/** 绑定手表  */
- (void)bindWatchParamters:(NSMutableDictionary *)paramters
                                  success:(CBWtSuccessBlock)success
                                  failure:(CBWtFailureBlock)failure;
/** 获取我的消息列表  */
- (void)getMessageListParamters:(NSMutableDictionary *)paramters
                   success:(CBWtSuccessBlock)success
                   failure:(CBWtFailureBlock)failure;
/** 处理消息  */
- (void)dealMessageParamters:(NSMutableDictionary *)paramters
                        success:(CBWtSuccessBlock)success
                        failure:(CBWtFailureBlock)failure;
/** 消息标记为已读  */
- (void)readMessageParamters:(NSMutableDictionary *)paramters
                     success:(CBWtSuccessBlock)success
                     failure:(CBWtFailureBlock)failure;
/** 获取聊天列表  */
- (void)getChatListParamters:(NSMutableDictionary *)paramters
                     success:(CBWtSuccessBlock)success
                     failure:(CBWtFailureBlock)failure;
/** 获取家庭群聊聊天记录  */
- (void)getChatLogListParamters:(NSMutableDictionary *)paramters
                        success:(CBWtSuccessBlock)success
                        failure:(CBWtFailureBlock)failure;
/** 获取单聊聊天记录  */
- (void)getSingleChatLogListParamters:(NSMutableDictionary *)paramters
                        success:(CBWtSuccessBlock)success
                        failure:(CBWtFailureBlock)failure;
/** 获取聊天音频  */
- (void)downloadChatAudioWithUrl:(NSString *)url
                         success:(CBWtVoiceFinishBlock)success
                         failure:(CBWtVoiceFailed)failure;

/** 获取我的好友  */
- (void)getMyFriendListParamters:(NSMutableDictionary *)paramters
                        success:(CBWtSuccessBlock)success
                        failure:(CBWtFailureBlock)failure;
/** 删除好友  */
- (void)deleteMyFriendParamters:(NSMutableDictionary *)paramters
                         success:(CBWtSuccessBlock)success
                         failure:(CBWtFailureBlock)failure;
/** 获取七牛云上传token  */
- (void)getQNFileTokenSuccess:(CBWtSuccessBlock)success
                      failure:(CBWtFailureBlock)failure;

/** 上传图片到七牛云  */
- (void)uploadImageToQNFilePath:(UIImage *)filePath
                          token:(NSString *)token
                        success:(requestReuslt)success
                        failure:(CBWtFailureBlock)failure;
/** 上传语音到七牛云  */
- (void)uploadVoiceToQNFileData:(NSData *)data
                          token:(NSString *)token
                        success:(requestReuslt)success
                        failure:(CBWtFailureBlock)failure;
/** 发送语音  */
- (void)sendVoiceReqeustParamters:(NSMutableDictionary *)paramters
                          success:(CBWtSuccessBlock)success
                          failure:(CBWtFailureBlock)failure;
/** 更新聊天记录状态  */
- (void)updateChatStatusReqeustParamters:(NSMutableDictionary *)paramters
                          success:(CBWtSuccessBlock)success
                          failure:(CBWtFailureBlock)failure;
/** 获取语聊成员  */
- (void)getTalkMemberParamters:(NSMutableDictionary *)paramters
                          success:(CBWtSuccessBlock)success
                          failure:(CBWtFailureBlock)failure;
/** 清空聊天记录  */
- (void)clearChatLogParamters:(NSMutableDictionary *)paramters
                       success:(CBWtSuccessBlock)success
                       failure:(CBWtFailureBlock)failure;
/** 获取消息通知开关状态  */
- (void)getMessageNotificationSuccess:(CBWtSuccessBlock)success
                              failure:(CBWtFailureBlock)failure;
/** 修改消息通知开关状态  */
- (void)updateMessageNotificationStatusParamters:(NSMutableDictionary *)paramters
                                         success:(CBWtSuccessBlock)success
                                         failure:(CBWtFailureBlock)failure;
@end

NS_ASSUME_NONNULL_END
