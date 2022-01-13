//
//  CBPetNetworkingManager.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/3/13.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

// MARK: - 登录
private let petLoginApi = "/userController/login"
// MARK: - 注册获取验证码
private let petGetVerificationCodeApi = "/userController/getPhoneCode"
// MARK: - 注册获取邮箱验证码
private let petGetEmailCodeApi = "/userController/sendEmailCode"
// MARK: - 重置密码
private let petResetPwdApi = "/userController/resetPwd"
// MARK: - 修改密码
private let petUpdPwdApi = "/userController/uptPwd"
// MARK: - 注册
private let petRegisterApi = "/userController/userRegister"
// MARK: - 退出登录
private let petSignOutApi = "/userController/logout"
// MARK: - 获取图形验证码
private let petGetVerificationImageApi = "/systemController/captcha"


// MARK: - 获取设备首页信息
private let petGetHomeInfoDataApi = "/petapi/devUserApi/getPetsHomeInfo"
// MARK: - 验证IMEIf合法性
private let petValudateIMEIApi = "/petapi/imeiApi/findImeiExist"
// MARK: - 通过 IMEI 绑定设备
private let petBindDeviceByValudateIMEIApi = "/petapi/devUserApi/bindPetDev"
// MARK: - 解绑设备
private let petUnBindDeviceApi = "/petapi/devUserApi/unBindPetDev"
// MARK: - 获取宠物列表
private let petGetAllDeviceApi = "/petapi/devUserApi/getAlllDevice"
// MARK: - 处理绑定消息请求
private let petdealWithApplicationApi = "/petapi/devUserApi/processBind"
// MARK: - 切换设备
private let petswitchDeviceApi = "/petapi/devUserApi/switchDevice"
// MARK: - 获取设备管理员列表
private let petgetDeviceManagerListApi = "/petapi/devUserApi/getManagers"


// MARK: - 获取消息中心列表
private let petgetMessageListInfoApi = "/petapi/messageApi/getMessageCenterListInfo"
// MARK: - 更新所有消息为已读
private let petUpdateAllMsgIsReadApi = "/petapi/messageApi/updateAllMessagesIsread"
// MARK: - 更新消息为已读（报警消息和绑定消息）
private let petUpdateMsgIsReadApi = "/petapi/messageApi/updateMessageByIds"
// MARK: - 根据消息类型获取消息中内容
private let petgetMsgByMsgTypeApi = "/petapi/messageApi/getMessageByMessType"
// MARK: - 删除消息（报警消息和绑定消息）
private let petdeleteMessageByIdsApi = "/petapi/messageApi/deleteMessageByIds"
// MARK: - 获取定位记录列表
private let petgetLocationRcdListInfoApi = "/petapi/locationHisApi/getlocationHis"




// MARK: - 获取七牛云上传凭证
private let petGetGetQNFileTokenApi = "/petapi/petSystemApi/getUploadToken"


// MARK: - 修改用户信息
private let petUpdateUserInfoApi = "/petapi/userApi/updateUserInfo"
// MARK: - 根据用户id获取用户信息
private let petFindUserInfoByUserIdApi = "/petapi/userApi/findUserById"
// MARK: - 根据用户id获取用户信息
private let petGetUserInfoByUserIdApi = "/petapi/userApi/getUserById"
// MARK: - 根据用户手机号获取用户信息
private let petFindUserInfoByPhoneApi = "/petapi/userApi/getUserByPhone"


// MARK: - 通过设备编号获取宠物信息
private let petGetPetInfoByIMEIApi = "/petapi/petApi/getPetsInfoByImei"
// MARK: - 更新宠物信息
private let petUpdatePetInfoApi = "/petapi/petApi/updateMyPetInfo"
// MARK: - 获取宠友列表
private let petGetMyPetFriendsListApi = "/petapi/friendApi/getPetFriendsList"
// MARK: - 搜索附近宠物
private let petGetNearbyPetsApi = "/petapi/petApi/searchNearPets"
// MARK: - 宠物主人之间添加好友
private let petAddPetownerFriendApi = "/petapi/friendApi/addFriends"
// MARK: - 删除宠友
private let petDeletePetownerFriendApi = "/petapi/friendApi/delPetfriend"
// MARK: - 处理宠物主人之间添加好友请求
private let petDealWithAddPetownerFriendApi = "/petapi/friendApi/friendsProcessApplication"
// MARK: - 获取宠友消息列表
private let petGetPetFriendsMessageApi = "/petapi/chatApi/chatFriendMessageList"
// MARK: - 获取单聊聊天记录
private let petGetSingleChatRcdApi = "/petapi/chatApi/chatSingleVoiceRecord"
// MARK: - 单聊发送聊天文件
private let petSingleChatSendMsgApi = "/petapi/chatApi/chatSingleVoiceSending"
// MARK: - 指令相关
/* 宠物指令下发 格式：{"cmd":152,"type":"data","body":{"fence":"113.52,22.869,30","warmType":1,"id":1}} */
private let petCommandApi = "/petapi/cmd/commandIssue"
/* 根据设备编号获取设备设置的参数 */
private let petGetParamtersByIMEIApi = "/petapi/SettingApi/getDevSetByImei"
/* 获取已设置的录音文件 */
private let petGetRecordingListApi = "/petapi/SettingApi/getVoiceRecordByImei"
/* 选择回家默认录音 */
private let petSelectDefaultGoHomwRcdRequestApi = "/petapi/SettingApi/updSetting"






enum SmsCodeType {
    case regiseter
    case forgetPwd
}

class CBPetNetworkingManager: NSObject {
    
    ///单例
    static let share:CBPetNetworkingManager = {
        let manager = CBPetNetworkingManager.init()
        return manager
    }()
    var codeType = SmsCodeType.regiseter
    
//    struct result {
//        var success:Bool = false
//        var msg:String?
//        var res_data:[String:Any]?
//        var res_code:String?
//    }
//    class func handleResponse(JSON json:JSON) -> result {
//        return result(success: true, msg: json["msg"].string, res_data: json["data"].dictionary, res_code: json["code"].string)
//    }
    
    /* 登录 18702777364 123456*/
    func loginWith(Account account:String,
                         Pwd pwd:String,
                         successBlock:@escaping(CBBaseNetworkModel) -> Void,
                         failureBlock:@escaping(CBBaseNetworkModel) -> Void) {
        let paramters:[String:Any] = ["account":account,"pwd":pwd]
////            do {
////                // 18702777364 123456 1364362
////                let json = try JSON(data:response.data!)
////                let jj = try JSON(data: response.data!)
////                let hh = response.json?["resmsg"]//JSON.init(response.json!)
////                let kk = response.json?["status"]
////                let ll = response.json?["totalrow"]
////                //if JSON.null != json {
////                if json != JSON.null {
////                    let result = CBPetNetworkingManager.handleResponse(JSON:json)
////
////                    handler(result)
////                }
////            } catch {}
        CBPetNetworking.requestWith(method: .post, url: HOST + PORT_login + Rounting + petLoginApi, paramters: paramters, token: "", successBlock: { (successModel) in
            
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 注册获取验证码*/
    func getVerificationCode(Phone phone:String,
                             Type type:String,
                             areaCode:String,
                                   successBlock:@escaping(CBBaseNetworkModel) -> Void,
                                   failureBlock:@escaping(CBBaseNetworkModel) -> Void) {
        let paramters:[String:Any] = ["phone":phone,"usedTo":type,"crCode":areaCode]
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT_login + Rounting + petGetVerificationCodeApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 获取邮箱验证码*/
    func getEmailCode(Email email:String,
                             Type type:String,
                                    successBlock:@escaping(CBBaseNetworkModel) -> Void,
                                   failureBlock:@escaping(CBBaseNetworkModel) -> Void) {
        let paramters:[String:Any] = ["email":email,"usedTo":type]
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT_login + Rounting + petGetEmailCodeApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 重置密码*/
    func resetPwdRequest(paramters:Dictionary<String, Any>,
                    successBlock:@escaping(CBBaseNetworkModel) -> Void,
                    failureBlock:@escaping(CBBaseNetworkModel) -> Void) {
        CBPetNetworking.requestWith(method: .post, url: HOST + PORT_login + Rounting + petResetPwdApi, paramters: paramters, token: "", successBlock: { (successModel) in
               successBlock(successModel)
           }) { (failureModel) in
               failureBlock(failureModel)
        }
    }
    /* 修改密码*/
    func updPwdRequest(paramters:Dictionary<String, Any>,
                    successBlock:@escaping(CBBaseNetworkModel) -> Void,
                    failureBlock:@escaping(CBBaseNetworkModel) -> Void) {
        CBPetNetworking.requestWith(method: .post, url: HOST + PORT_login + Rounting + petUpdPwdApi, paramters: paramters, token: "", successBlock: { (successModel) in
               successBlock(successModel)
           }) { (failureModel) in
               failureBlock(failureModel)
        }
    }
    /* 注册*/
    func registerRequest(paramters:[String:Any],
                         successBlock:@escaping(CBBaseNetworkModel) -> Void,
                        failureBlock:@escaping(CBBaseNetworkModel) -> Void) {
        CBPetNetworking.requestWith(method: .post, url: HOST + PORT_login + Rounting + petRegisterApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 退出登录*/
    func logoutRequest(successBlock:@escaping(CBBaseNetworkModel) -> (),
                              failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        let paramters:[String:Any] = ["":""]
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT_login + Rounting + petSignOutApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 获取图形验证码*/
    func getVerificationImageRequest(paramters:Dictionary<String,Any>,
                                     successBlock:@escaping(CBBaseNetworkModel) -> (),
                                     failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        let paramters:[String:Any] = ["":""]
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT_login + Rounting + petGetVerificationImageApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 获取首页信息*/
    func getHomeInfoDataRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petGetHomeInfoDataApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 验证 IMEI 合法性*/
    func valudateIMEIRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petValudateIMEIApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 通过 IMEI 绑定设备*/
    func bindDeviceByValudateIMEIRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .post, url: HOST + PORT + Rounting + petBindDeviceByValudateIMEIApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 解绑设备*/
    func unbindDeviceRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petUnBindDeviceApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 获取当前用户的宠物列表*/
    func getAllDeviceRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petGetAllDeviceApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 处理绑定消息请求*/
    func dealWithApplicationRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petdealWithApplicationApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 切换设备*/
    func switchDeviceRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petswitchDeviceApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 获取设备管理员列表*/
    func getDeviceManagerListRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petgetDeviceManagerListApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    
    /* 获取消息中心列表*/
    func getMessageListInfoRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petgetMessageListInfoApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 更新所有消息为已读*/
    func updateAllMsgIsReadRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petUpdateAllMsgIsReadApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 更新消息为已读*/
    func updateMsgIsReadByIdsRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petUpdateMsgIsReadApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 根据消息类型获取消息内容{消息类型1：出围栏告警2：入围栏告警 3：低电告警
     4:好友申请（用在获取好友列表uid必填 imei不用填）5：绑定申请6.听一听动态7:围栏动态}*/
    func getMsgByMsgTypeRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petgetMsgByMsgTypeApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 删除消息（报警消息和绑定消息）*/
    func getDeleteMessageByIdsRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petdeleteMessageByIdsApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 获取定位记录列表*/
    func getLocationRcdListRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petgetLocationRcdListInfoApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 获取七牛云上传凭证 */
    func getQNFileTokenRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petGetGetQNFileTokenApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 上传图片到七牛云 */
    func uploadImageToQNFileRequest(imageFilePath:UIImage,
                                            token:String,
                                            successBlock:@escaping(Dictionary<AnyHashable, Any>) -> (),
                                            failureBlock:@escaping(Dictionary<AnyHashable, Any>) -> ()) {
        let upManager = QNUploadManager.init()
        let uploadOption = QNUploadOption.init(mime: nil, progressHandler: { (key, percent) in
            CBLog(message: "上传进度:\(percent)")
        }, params: nil, checkCrc: false, cancellationSignal: nil)
        let data:Data = imageFilePath.jpegData(compressionQuality: 1.0)!
        upManager?.put(data, key: qnImageFilePatName(), token: token, complete: { (info, key, resp) in
            guard resp == nil else {
                successBlock(resp ?? ["":""])
                return
            }
            failureBlock(["":""])
        }, option: uploadOption)
    }
    private func qnImageFilePatName() -> String {
        let formatter = DateFormatter.init()
        formatter.date(from: "yyyyMMdd")
        let number = generateTradeNO()
        let interval = Date().timeStamp//NSInteger(Date().timeIntervalSince1970)
        let name = String.init(format: "Picture/%ld%@.jpg",interval,number)//number
        return name
    }
    private func generateTradeNO() -> String {
        let kNumber = 8
        let sourceStr = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let resultStr = NSMutableString.init()
        srand48(Int(time(nil)))    //种子以时间来生成，若种子固定，则生成随机数也是固定的
        for _ in 0..<kNumber {
            //let index = arc4random_uniform(UInt32(sourceStr.count))
            let index = Int(drand48()) % sourceStr.count
            let oneStr = sourceStr.subString(fromIndex: Int(index), endIndex: 1)
            resultStr.append(oneStr)
        }
        CBLog(message: "上传照片随机数\(resultStr)")
        return resultStr as String
    }
    /* 上传语音到七牛云 */
    func uploadVoiceToQNFileRequest(fileData:NSData,
                                            token:String,
                                            successBlock:@escaping(Dictionary<AnyHashable, Any>) -> (),
                                            failureBlock:@escaping(Dictionary<AnyHashable, Any>) -> ()) {
        let upManager = QNUploadManager.init()
        let uploadOption = QNUploadOption.init(mime: nil, progressHandler: { (key, percent) in
            CBLog(message: "上传进度:\(percent)")
        }, params: nil, checkCrc: false, cancellationSignal: nil)
        let data:Data = fileData as Data
        upManager?.put(data, key: qnVoiceFilePatName(), token: token, complete: { (info, key, resp) in
            guard resp == nil else {
                successBlock(resp ?? ["":""])
                return
            }
            failureBlock(["":""])
        }, option: uploadOption)
    }
    private func qnVoiceFilePatName() -> String {
        let formatter = DateFormatter.init()
        formatter.date(from: "yyyyMMdd")
        let number = generateTradeNO()
        let interval = Date().timeStamp//NSInteger(Date().timeIntervalSince1970)
        let name = String.init(format: "Voice/%ld%@.amr",interval,number)//number
        return name
    }
    /* 修改用户信息*/
    func updateUserInfoRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petUpdateUserInfoApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 根据用户id获取用户信息*/
    func findUserInfoByUserIdRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petFindUserInfoByUserIdApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 根据用户id获取用户信息 拼接后面 */
    func getUserInfoByUserIdRequest(userId:String,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        let paramters = ["":""]
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petGetUserInfoByUserIdApi + "/" + userId, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 根据用户手机号获取用户信息*/
    func findUserInfoByPhoneRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petFindUserInfoByPhoneApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 通过设备编号获取宠物信息*/
    func getPetInfoByIMEIRequest(paramters:Dictionary<String,Any>,
                                 successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petGetPetInfoByIMEIApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 更新宠物信息*/
    func updatePetsInfoRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .post, url: HOST + PORT + Rounting + petUpdatePetInfoApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 宠友列表*/
    func getMyPetFriendsListRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .post, url: HOST + PORT + Rounting + petGetMyPetFriendsListApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 搜索附近宠物*/
    func searchNearbyPetsRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petGetNearbyPetsApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 宠物主人之间添加好友*/
    func addPetownerFriendRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .post, url: HOST + PORT + Rounting + petAddPetownerFriendApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 删除宠友*/
    func deletePetownerFriendRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .post, url: HOST + PORT + Rounting + petDeletePetownerFriendApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 处理宠物主人之间添加好友请求*/
    func dealWithAddPetownerFriendRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .post, url: HOST + PORT + Rounting + petDealWithAddPetownerFriendApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 获取宠友消息列表*/
    func getPetFriendsMessageRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petGetPetFriendsMessageApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 获取单聊聊天记录*/
    func getSingleChatRcdRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petGetSingleChatRcdApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 单聊发送聊天消息*/
    func singleChatSendMsgRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .post, url: HOST + PORT + Rounting + petSingleChatSendMsgApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 下载音频文件并转为wav*/
    func downloadChatAudio(url:String,
                           successBlock:@escaping(_ filePath:String) -> (),
                           failureBlock:@escaping(_ filePath:String) -> ()) {
        let file_path = String.init(format: "%@/tmp/CBPetTemporaryDownAudio.wav", NSHomeDirectory())
        let destination:DownloadRequest.DownloadFileDestination = { (url, response) in
            let cachesPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
            let path = (cachesPath! as NSString).appendingPathComponent(response.suggestedFilename!)
            return (NSURL.init(fileURLWithPath: path) as URL,[.removePreviousFile,.createIntermediateDirectories])
        }
        let URL = NSURL.init(string: url)
        let request:URLRequest = URLRequest.init(url: URL! as URL)
        Alamofire.download(request, to: destination).downloadProgress { (progress) in
            CBLog(message: "Download Progress: \(progress.fractionCompleted)")
        }.validate().responseData { (response) in
            ///response.result.value：响应数据Data
            if response.destinationURL != nil {
                let armFilePath = response.destinationURL!.path //// 将NSURL转成NSString
                // arm --> wav
                let result:Int = Int(AudioConverter.amr(toWav: armFilePath, wavSavePath: file_path))
                if result == 1 {
                    successBlock(file_path)
                } else {
                    successBlock("")
                }
            } else {
                successBlock("")
            }
        }
    }
    /* 指令相关*/
    func commandRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .post, url: HOST + PORT + Rounting + petCommandApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 根据设备编号获取设备设置的参数*/
    func getParamtersByIMEIRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .get, url: HOST + PORT + Rounting + petGetParamtersByIMEIApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 获取已设置的录音文件*/
    func getRecordingListRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .post, url: HOST + PORT + Rounting + petGetRecordingListApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
    /* 选择需要播放的录音*/
    func selectDefaultGoHomwRcdRequest(paramters:Dictionary<String,Any>,
                                successBlock:@escaping(CBBaseNetworkModel) -> (),
                                failureBlock:@escaping(CBBaseNetworkModel) -> ()) {
        CBPetNetworking.requestWith(method: .post, url: HOST + PORT + Rounting + petSelectDefaultGoHomwRcdRequestApi, paramters: paramters, token: "", successBlock: { (successModel) in
            successBlock(successModel)
        }) { (failureModel) in
            failureBlock(failureModel)
        }
    }
}
