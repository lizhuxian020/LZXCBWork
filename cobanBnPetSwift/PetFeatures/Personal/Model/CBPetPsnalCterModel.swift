//
//  CBPetPsnalCterModel.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/3.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
//import SwiftyJSON
import HandyJSON

struct CBPetPsnalCterModel {
    var title:String?
    var text:String?
    var isOn:String?
}
struct CBPetPsnalCterPricySettingModel {
    var title:String?
    var text:String?
    var cout:Int = 0
    var index:Int = 0
    var isOn:String?
}
/* 宠物模型*/
struct CBPetPsnalCterPetAllModel:HandyJSON,Codable {
    var allPet:[CBPetPsnalCterPetModel] = [CBPetPsnalCterPetModel]()
    var is_friend:String?
    
    var title:String?
    var icon:String?
    var text:String?
    var isOn:String?
    var cout:Int = 0
    var index:Int = 0
}
struct CBPetPsnalCterPetModel:HandyJSON,Codable {
    var add_time:String?
    var admin_id:String?
    var id:String?
    var imei:String?
    var petId:String?
    var isAdmin:String?
    var isAuth:String?
    var isDefault:String?
    var phone:String?
    var pet:CBPetPsnalCterPetPet = CBPetPsnalCterPetPet.init()
    var user:CBPetUserInfoModel = CBPetUserInfoModel.init()
    
    var title:String?
    var icon:String?
    var text:String?
    var isOn:String?
    var cout:Int = 0
    var index:Int = 0
}
struct CBPetPsnalCterPetPet:HandyJSON,Codable {
    var add_time:String?
    var device:CBPetPsnalCterPetPetDevice = CBPetPsnalCterPetPetDevice.init()
    var epidemic_status:String?
    var epidemicImage:String?
    var epidemicRecord:String?
    var id:String?
    var name:String?
    var photo:String?
    var variety:String?
    var age:String?
    var sex:String?
    var color:String?
    var isPublish:String?
    
    var title:String?
    var text:String?
}
struct CBPetPsnalCterPetPetDevice:HandyJSON,Codable {
    var create_time:String?
    var imei:String?
    var location:CBPetPsnalCterPetPetDeviceLocation = CBPetPsnalCterPetPetDeviceLocation.init()
}
struct CBPetPsnalCterPetPetDeviceLocation:HandyJSON,Codable {
    var add_time:String?
    var id:String?
    var imei:String?
    var lat:String?
    var lng:String?
    var orgin_lat:String?
    var orgin_lng:String?
}


///个人信息模型
struct CBPetUserInfoModel:HandyJSON,Codable {
    var account:String?
    var age:String?
    var create_time:String?
    var id:String?
    var name:String?
    var password:String?
    var phone:String?
    var photo:String?
    var appPush:String?
    var appPush_local:String?
    var sex:String?
    var update_time:String?
    var weixin:String?
    var email:String?
    var whatsapp:String?
    var isPublishEmail:String? ///邮箱是否公开：0：默认不公开，1：公开
    var isPublishPhone:String? ///手机号是否公开：0：默认不公开，1：公开
    var isPublishWeixin:String? ///微信是否公开：0：默认不公开，1：公开
    var isPublishWhatsapp:String?  ///whatsapp是否公开：0：默认不公开，1：公开
    
    var title:String?
    var text:String?
    var isPublish:String?
    var isOn:String?
    var cout:Int = 0
    var index:Int = 0
}
struct CBPetUserInfoModelTool {
    //MARK: - 归档路径
    static private var psnalInfoPath:String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return (path as NSString).appendingPathComponent("CBPetPsnalInfo.plist")
    }
    
    private static var _userInfo : CBPetUserInfoModel?
    //MARK: - 存档
    static func saveUserInfo(userInfoModel:CBPetUserInfoModel) {
        _userInfo = userInfoModel
        let encodeer = JSONEncoder()
        if let data = try? encodeer.encode(userInfoModel) {
            //UserDefaults.standard.set(data, forKey: path)
            NSKeyedArchiver.archiveRootObject(data, toFile: psnalInfoPath)
            let isSuccess = NSKeyedArchiver.archiveRootObject(data, toFile: psnalInfoPath)
            if isSuccess {
                CBLog(message: "用户信息存档成功")
            } else {
                CBLog(message: "用户信息存档失败")
            }
        }
    }
    
    //MARK: - 获取用户信息
    static func getUserInfo() -> CBPetUserInfoModel {
        if let info = _userInfo {
            return info
        }
        let homeInfoData = NSKeyedUnarchiver.unarchiveObject(withFile: psnalInfoPath)
        let decoder = JSONDecoder()
        if let data = homeInfoData as? Data {
            let homeInfoModel = try? decoder.decode(CBPetUserInfoModel.self, from: data)
            _userInfo = homeInfoModel
        }
        _userInfo = CBPetUserInfoModel()
        return _userInfo!
    }
    //MARK: - 删档
    static func removeUserInfo() {
        if FileManager.default.fileExists(atPath: psnalInfoPath) {
            do {
                try FileManager.default.removeItem(atPath: psnalInfoPath)
                CBLog(message: "用户信息删档成功")
            } catch {
                CBLog(message: "用户信息删档失败")
            }
        } else {
            CBLog(message: "没有文档路径,用户信息删除失败")
        }
    }
}

