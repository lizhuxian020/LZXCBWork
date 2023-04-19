//
//  CBPetHomeInfoModel.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/3/27.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

struct CBPetHomeInfoModel:HandyJSON,Codable {
    var devUser:CBHomeInfoDevUserModel = CBHomeInfoDevUserModel.init()
    var msgUnReadCount:String?
    var fence:CBHomeInfoPetFenceModel = CBHomeInfoPetFenceModel.init()
    var pet:CBHomeInfoPetModel = CBHomeInfoPetModel.init()
}
/* 首页宠物model*/
struct CBHomeInfoDevUserModel:HandyJSON,Codable {
    var add_time:String?
    var admin_id:String?
    var id:String?
    var imei:String?
    var isAdmin:String?
    var isAuth:String?
    var isDefault:String?
    var phone:String?
    var user:CBHomeInfoUserModel = CBHomeInfoUserModel.init()
}
struct CBHomeInfoUserModel:HandyJSON,Codable {
    var account:String?
    var age:String?
    var create_time:String?
    var email:String?
    var id:String?
    var isPublishEmail:String?
    var isPublishWeixin:String?
    var isPublishWhatsapp:String?
    var name:String?
    var password:String?
    var phone:String?
    var photo:String?
    var sex:String?
    var update_time:String?
    var weixin:String?
    var whatsapp:String?
}
struct CBHomeInfoPetModel:HandyJSON,Codable {
    var add_time:String?
    var age:String?
    var color:String?
    var device:CBHomeInfoPetDeviceModel = CBHomeInfoPetDeviceModel.init()
    var epidemic_status:String?
    var epidemicRecord:String?
    var epidemicImage:String?
    var hight:String?
    var id:String?
    var name:String?
    var photo:String?
    var sex:String?
    var update_time:String?
    var variety:String?
    var isPublish:String?
}
struct CBHomeInfoPetDeviceModel:HandyJSON,Codable {
    var create_time:String?
    var imei:String?
    var location:CBHomeInfoPetLocationModel = CBHomeInfoPetLocationModel.init()
    /// 0 离线，1在线，2报警
    var online:String?
    var register_time:String?
    /// 0 nb网络 1 2g网络
    var simCardType:String?
    var timeZone:String?
    var update_time:String?
    var version:String?
    var flag = ""
}
struct CBHomeInfoPetLocationModel:HandyJSON,Codable {
    var add_time:String?
    var id:String?
    var baterry:String?
    var speed:String?
    var status:String?
    var warn:String?
    var imei:String?
    var lat:String?
    var lng:String?
    var orgin_lat:String?
    var orgin_lng:String?
    var postTime:String?
    var flag = ""
}
struct CBHomeInfoPetFenceModel:HandyJSON,Codable {
    var create_time:String?
    var data:String?
    var dno:String?
    var id:String?
    var name:String?
    var shape:String?
    var sn:String?
    var user_id:String?
    var warmType:String?
}
/* 录音文件model*/
struct CBPetHomeRcdListModel:HandyJSON,Codable {
    var add_time:String?
    var file_name:String?
    var file_path:String?
    var id:String?
    var imei:String?
    var type:String?
    var voiceId:String?
}
/* 参数设置model*/
struct CBPetHomeParamtersModel:HandyJSON,Codable {
    /* 挂失开启*/
    var callPosiAction:String?
    /* 惩罚时长*/
    var eshcok_interval:String?
    var fenceSwitch:String?
    var fileRecord:CBPetHomeParamtersRcdModel = CBPetHomeParamtersRcdModel.init()
    var imei:String?
    /* 听听时长*/
    var listenTime:String?
    /* */
    var monitor_file_id:String?
    var timeZone:String?
    var updateTime:String?
    var timingReport = [CBPetTimingReportModel]()
    var timingSwitch:String?
    
    //MARK: - 归档路径
    static private var path:String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return (path as NSString).appendingPathComponent("CBPetHomeParamtersInfo.plist")
    }
    //MARK: - 存档
    static func saveHomeParamters(homeInfoModel:CBPetHomeParamtersModel) {
        let encodeer = JSONEncoder()
        if let data = try? encodeer.encode(homeInfoModel) {
            NSKeyedArchiver.archiveRootObject(data, toFile: path)
            let isSuccess = NSKeyedArchiver.archiveRootObject(data, toFile: path)
            if isSuccess {
                CBLog(message: "首页信息存档成功")
            } else {
                CBLog(message: "首页信息存档失败")
            }
        }
    }
    //MARK: - 获取首页信息
    static func getHomeParamters() -> CBPetHomeParamtersModel {
        let homeInfoData = NSKeyedUnarchiver.unarchiveObject(withFile: path)
        let decoder = JSONDecoder()
        if let data = homeInfoData as? Data {
            let homeInfoModel = (try? decoder.decode(CBPetHomeParamtersModel.self, from: data)) ?? CBPetHomeParamtersModel.init()
            return homeInfoModel
        }
        return CBPetHomeParamtersModel()
    }
}
struct CBPetHomeParamtersRcdModel:HandyJSON,Codable {
    var add_time:String?
    var file_name:String?
    var file_path:String?
    var id:String?
    var imei:String?
    var type:String?
    var voiceId:String?
}
/* 添加设备model*/
struct CBPetScanResultModel:HandyJSON,Codable {
    var isAdmin:String?
    var imei:String?
    var petId:String?
    var file_name:String?
}
struct CBPetHomeInfoTool {
    //MARK: - 归档路径
    static private var path:String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return (path as NSString).appendingPathComponent("CBPetHomeInfo.plist")
    }
    //MARK: - 存档
    static func saveHomeInfo(homeInfoModel:CBPetHomeInfoModel) {
        let encodeer = JSONEncoder()
        if let data = try? encodeer.encode(homeInfoModel) {
            NSKeyedArchiver.archiveRootObject(data, toFile: path)
            let isSuccess = NSKeyedArchiver.archiveRootObject(data, toFile: path)
            if isSuccess {
                CBLog(message: "首页信息存档成功")
            } else {
                CBLog(message: "首页信息存档失败")
            }
        }
    }
    //MARK: - 获取首页信息
    static func getHomeInfo() -> CBPetHomeInfoModel {
        let homeInfoData = NSKeyedUnarchiver.unarchiveObject(withFile: path)
        let decoder = JSONDecoder()
        if let data = homeInfoData as? Data {
            let homeInfoModel = try? decoder.decode(CBPetHomeInfoModel.self, from: data)
            return homeInfoModel!
        }
        return CBPetHomeInfoModel()
    }
    //MARK: - 删档
    static func removeHomeInfo() {
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
                CBLog(message: "首页信息删档成功")
            } catch {
                CBLog(message: "首页信息删档失败")
            }
        } else {
            CBLog(message: "没有文档路径,首页信息删除失败")
        }
    }
}
struct CBPetCtrlPanelModel {
    var title:String?
    var text:String?
    
    var fenceSwitch:String?
    var callPosiAction:String?
    var fileRecord:CBPetHomeParamtersRcdModel = CBPetHomeParamtersRcdModel.init()
    var timeZone:String?
    var timingSwitch:String?
}
struct CBPetValudateIMEIModel:HandyJSON {
    var create_time:String?
    var cus_name:String?
    var expire_day:String?
    var id:String?
    var imei:String?
    var status:String?
}
/* 通知model*/
struct CBPetNoticeModel:HandyJSON,Codable {
    var title:String?
    //var body:CBPetNoticeInfoModel = CBPetNoticeInfoModel.init()
    var body:String? 
    
    var watchAlarmType:String? /* 手表报警类型*/
    var productType:String? /* 1:为手表推送 其他为宠物推送*/
    var phone:String?
    /* 1、好友聊天，2、绑定申请，3、宠友添加申请，4、设备报警，5、听一听消息*/
    var pushType:String?
    var imei:String?
    
    /* 宠物a*/
    var friendName:String?
    
    /* 绑定申请*/
    var applicaPhone:String?
    var applicaMessId:String?
    var applicaName:String?
    
    /* 宠友添加申请*/
    var friendPet:String?
    var friendPhoto:String?
    var friendId:String?
    var friendMsgId:String?
    
    /* 设备报警（围栏报警、低电报警）*/
    var warmType:String?
    var lat:String?
    var lng:String?
    var petName:String?
    var petPhoto:String?
    
    var warms:String?
    
    /* 听一听消息*/
    //    var petName:String?
    //    var petPhoto:String?
}
struct CBPetNoticeInfoModel:HandyJSON,Codable {
    
    /* 1、好友聊天，2、绑定申请，3、宠友添加申请，4、设备报警，5、听一听消息*/
    var pushType:String?
    
    /* 宠物a*/
    var friendName:String?
    
    /* 绑定申请*/
    var applicaPhone:String?
    
    /* 宠友添加申请*/
    var friendPet:String?
    
    /* 设备报警（围栏报警）*/
    var warmType:String?
    var lat:String?
    var lng:String?
    var petName:String?
    var petPhoto:String?
    
    /* 听一听消息*/
//    var petName:String?
//    var petPhoto:String?
}
struct CBPetTimingReportModel:HandyJSON,Codable {
    var timingHour = 0
    var timingMinute = 0
    var index = 0
}
