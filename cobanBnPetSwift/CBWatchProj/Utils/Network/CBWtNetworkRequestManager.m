//
//  CBWtNetworkRequestManager.m
//  Telematics
//
//  Created by coban on 2019/7/17.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBWtNetworkRequestManager.h"
#import "NSString+LBExtension.h"
#import "QiniuSDK.h"
#import "AudioConverter.h"

@implementation CBWtNetworkRequestManager

/** 获取验证码  */
const NSString *CBGetPhoneCode                    = @"/userController/phoneCode";
/** 登录  */
const NSString *CBLogin                           = @"/userController/login";//@"/userController/loginTest";//@"/userController/login";
/** 退出登录  */
const NSString *CBLogout                           = @"/userController/logout";
/** 获取首页数据  */
const NSString *CBgetHomePageData                 = @"/watch/home/getHomeInfo";
/** 更新手表位置  */
const NSString *CBgetUpdateWatchPosition          = @"/watch/home/updWatchPosition";
/** 获取学校和家庭的坐标定位   */
const NSString *CBgetSchoolAndHomePosition         = @"/watch/home/getHomeAndSchool";
/** 校验手边编号   */
const NSString *CBCheckWatchSno                   = @"/watch/persion/watchVerification";
/** 绑定手表   */
const NSString *CBBindWatch                        = @"/watch/persion/bindWatch";
/** 获取我的消息列表  */
const NSString *CBGetMessageList                   = @"/watch/persion/getMyMessageList";
/** 处理消息  */
const NSString *CBDealMessage                      = @"/watch/persion/dealApplyMessage";
/** 消息标记为已读  */
const NSString *CBReadMessage                      = @"/watch/persion/isReadMessage";
/** 获取聊天列表  */
const NSString *CBGetChatList                       = @"/watch/microchat/getChatLogList";
/** 获取家庭群聊聊天记录  */
const NSString *CBGetChatLogList                   = @"/watch/home/getChatLog";
/** 获取单聊聊天记录  */
const NSString *CBGetSingleChatLogList              = @"/watch/home/getChatLogForFriends";
/** 获取我的好友  */
const NSString *CBGetMyFriendList                   = @"/watch/friend/getFriendsList";
/** 删除好友  */
const NSString *CBDeleteMyFriend                    = @"/watch/friend/delFriend";
/** 删除好友  */
const NSString *CBGetQininToken                    = @"/systemController/getUploadToken";
/** 发送语音  */
const NSString *CBSendVoice                         = @"/watch/home/sendVoice";
/** 更新聊天记录状态  */
const NSString *CBUpdateChatStatus                   = @"/watch/home/updateChatReadStat";
/** 获取语聊成员  */
const NSString *CBGetTalkMember                     = @"/watch/home/getChatMembers";
/** 清空聊天记录  */
const NSString *CBClearChatLog                     = @"/watch/home/clearChatLog";
/** 获取消息通知开关状态  */
const NSString *CBGetMessageNotification            = @"/watch/persion/getMsgStatus";
/** 获取消息通知开关状态  */
const NSString *CBGetUpdateMessageNotification        = @"/watch/persion/updMsgStatus";



+ (instancetype)sharedInstance {
    static id obj = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        obj = [[self alloc] init];
    });
    return  obj;
}

/** 获取验证码  */
- (void)getPhoneCodeParamters:(NSMutableDictionary *)paramters
                      success:(CBWtSuccessBlock)success
                      failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBGetPhoneCode];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypePost path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 登录  */
- (void)loginParamters:(NSMutableDictionary *)paramters
               success:(CBWtSuccessBlock)success
               failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBLogin];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypePost path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 退出登录  */
- (void)logoutSuccess:(CBWtSuccessBlock)success
              failure:(CBWtFailureBlock)failure {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@",CBLogout];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypePost path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 获取首页数据  */
- (void)getHomePageInfoSuccess:(CBWtSuccessBlock)success
                       failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBgetHomePageData];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypeGet path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 更新手表位置  */
- (void)updateWatchPositionParmters:(NSMutableDictionary *)paramters
                            success:(CBWtSuccessBlock)success
                           failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBgetUpdateWatchPosition];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypePost path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 获取学校和家庭的坐标定位  */
- (void)getSchoolAndHomePositionParamters:(NSMutableDictionary *)paramters
                                  success:(CBWtSuccessBlock)success
                                  failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBgetSchoolAndHomePosition];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypeGet path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 校验手表  */
- (void)checkWatchSnoParamters:(NSMutableDictionary *)paramters
                       success:(CBWtSuccessBlock)success
                       failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBCheckWatchSno];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypeGet path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 绑定手表  */
- (void)bindWatchParamters:(NSMutableDictionary *)paramters
                   success:(CBWtSuccessBlock)success
                   failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBBindWatch];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypePost path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 获取我的消息列表  */
- (void)getMessageListParamters:(NSMutableDictionary *)paramters
                        success:(CBWtSuccessBlock)success
                        failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBGetMessageList];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypeGet path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 处理消息  */
- (void)dealMessageParamters:(NSMutableDictionary *)paramters
                     success:(CBWtSuccessBlock)success
                     failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBDealMessage];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypePost path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 消息标记为已读  */
- (void)readMessageParamters:(NSMutableDictionary *)paramters
                     success:(CBWtSuccessBlock)success
                     failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBReadMessage];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypePost path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 获取聊天列表  */
- (void)getChatListParamters:(NSMutableDictionary *)paramters
                        success:(CBWtSuccessBlock)success
                        failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBGetChatList];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypeGet path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 获取家庭群聊聊天记录  */
- (void)getChatLogListParamters:(NSMutableDictionary *)paramters
                        success:(CBWtSuccessBlock)success
                        failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBGetChatLogList];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypeGet path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 获取单聊聊天记录  */
- (void)getSingleChatLogListParamters:(NSMutableDictionary *)paramters
                              success:(CBWtSuccessBlock)success
                              failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBGetSingleChatLogList];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypeGet path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 获取聊天音频  */
- (void)downloadChatAudioWithUrl:(NSString *)url
                         success:(CBWtVoiceFinishBlock)success
                         failure:(CBWtVoiceFailed)failure {
    NSString *file_path = [NSString stringWithFormat:@"%@/tmp/temporaryDownAudio.wav", NSHomeDirectory()];//[directoryPath stringByAppendingPathComponent:fileName];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSURL *URL = [NSURL URLWithString:url];
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //下载Task操作
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //NSLog(@"=====%@",targetPath)
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"=====%@",filePath);
        //success(filePath);
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        NSString *armFilePath = [filePath path];// 将NSURL转成NSString
        // arm --> wav
        int result = [AudioConverter amrToWav:armFilePath wavSavePath:file_path];
        if (result) {    //amrToWavFrom:armFilePath to:file_path]) {
            success(file_path);
        } else {
            //failure();
            success(file_path);
        }
    }];
    [downloadTask resume];
}
/** 获取我的好友  */
- (void)getMyFriendListParamters:(NSMutableDictionary *)paramters
                         success:(CBWtSuccessBlock)success
                         failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBGetMyFriendList];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypeGet path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 删除好友  */
- (void)deleteMyFriendParamters:(NSMutableDictionary *)paramters
                        success:(CBWtSuccessBlock)success
                        failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBDeleteMyFriend];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypePost path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 获取七牛云上传token  */
- (void)getQNFileTokenSuccess:(CBWtSuccessBlock)success
                      failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBGetQininToken];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypeGet path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 上传图片到七牛云  */
- (void)uploadImageToQNFilePath:(UIImage *)filePath
                          token:(NSString *)token
                        success:(requestReuslt)success
                        failure:(CBWtFailureBlock)failure {
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"上传进度 %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    
    NSData *data;
//    if (UIImagePNGRepresentation(filePath) == nil){
//        data = UIImageJPEGRepresentation(filePath, 1);
//    } else {
//        data = UIImagePNGRepresentation(filePath);
//    }
    data = UIImageJPEGRepresentation(filePath, 1);
    
    [upManager putData:data key:[CBWtNetworkRequestManager qnImageFilePatName] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        !success?:success(resp);
    } option:uploadOption];
}
+ (NSString *)qnImageFilePatName {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *nowe = [formatter stringFromDate:[NSDate date]];
    NSString *number = [CBWtNetworkRequestManager generateTradeNO];
    //当前时间
    NSInteger interval = (NSInteger)[[NSDate date]timeIntervalSince1970];
    NSString *name = [NSString stringWithFormat:@"Picture/%@/%ld%@.jpg",nowe,interval,number];
    NSLog(@"name__%@",name);
    return name;
}
+ (NSString *)generateTradeNO {
    static int kNumber = 8;
    NSString *sourceStr = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    NSLog(@"%@",resultStr);
    return resultStr;
}
/** 上传语音到七牛云  */
- (void)uploadVoiceToQNFileData:(NSData *)data
                          token:(NSString *)token
                        success:(requestReuslt)success
                        failure:(CBWtFailureBlock)failure {
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"上传进度 %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [upManager putData:data key:[CBWtNetworkRequestManager qnVoiceFilePatName] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        !success?:success(resp);
    } option:uploadOption];
}
+ (NSString *)qnVoiceFilePatName {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *nowe = [formatter stringFromDate:[NSDate date]];
    NSString *number = [CBWtNetworkRequestManager generateTradeNO];
    //当前时间
    NSInteger interval = (NSInteger)[[NSDate date]timeIntervalSince1970];
    NSString *name = [NSString stringWithFormat:@"Voice/%@/%ld%@.amr",nowe,interval,number];
    NSLog(@"name__%@",name);
    return name;
}
/** 发送语音  */
- (void)sendVoiceReqeustParamters:(NSMutableDictionary *)paramters
                          success:(CBWtSuccessBlock)success
                          failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBSendVoice];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypePost path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 更新聊天记录状态  */
- (void)updateChatStatusReqeustParamters:(NSMutableDictionary *)paramters
                                 success:(CBWtSuccessBlock)success
                                 failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBUpdateChatStatus];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypePost path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 获取语聊成员  */
- (void)getTalkMemberParamters:(NSMutableDictionary *)paramters
                       success:(CBWtSuccessBlock)success
                       failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBGetTalkMember];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypeGet path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 清空聊天记录  */
- (void)clearChatLogParamters:(NSMutableDictionary *)paramters
                      success:(CBWtSuccessBlock)success
                      failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBClearChatLog];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypePost path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 获取消息通知开关状态  */
- (void)getMessageNotificationSuccess:(CBWtSuccessBlock)success
                              failure:(CBWtFailureBlock)failure {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@",CBGetMessageNotification];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypeGet path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/** 修改消息通知开关状态  */
- (void)updateMessageNotificationStatusParamters:(NSMutableDictionary *)paramters
                                         success:(CBWtSuccessBlock)success
                                         failure:(CBWtFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@",CBGetUpdateMessageNotification];
    [CBWtNetworkingServers networkRequestType:CBWtNetworkRequestTypePost path:url param:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        !success?:success(baseModel);
    } failure:^(NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
@end
