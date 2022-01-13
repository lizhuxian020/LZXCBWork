//
//  CBPetUserManageModel.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/16.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import HandyJSON

//class CBPetUserManageModel: NSObject {
//}
/* 宠物用户管理模型*/
struct CBPetUserManageModel:HandyJSON,Codable {
    var add_time:String?
    var admin_id:String?
    var id:String?
    var imei:String?
    var isAdmin:String?
    var isAuth:String?
    var isDefault:String?
    var phone:String?
    var pet:CBPetUserManagePet = CBPetUserManagePet.init()
    var user:CBPetUserManagePetUser = CBPetUserManagePetUser.init()
//    var title:String?
//    var icon:String?
}
struct CBPetUserManagePet:HandyJSON,Codable {
    var add_time:String?
    var device:CBPetUserManagePetDevice = CBPetUserManagePetDevice.init()
    var epidemic_status:String?
    var id:String?
    var name:String?
    var photo:String?
    
    var age:String?
    var color:String?
    var epidemicImage:String?
    var epidemicRecord:String?
    //var epidemic_status:String?
    var hight:String?
    //var id:String?
    //var name:String?
    //var photo:String?
    var sex:String?
    var update_time:String?
    var variety:String?
}
struct CBPetUserManagePetDevice:HandyJSON,Codable {
    var create_time:String?
    var imei:String?
    var location:CBPetUserManagePetDeviceLocation = CBPetUserManagePetDeviceLocation.init()
}
struct CBPetUserManagePetDeviceLocation:HandyJSON,Codable {
    var add_time:String?
    var id:String?
    var imei:String?
    var lat:String?
    var lng:String?
    var orgin_lat:String?
    var orgin_lng:String?
}

struct CBPetUserManagePetUser:HandyJSON,Codable {
    var account:String?
    var create_time:String?
    var id:String?
    var password:String?
    var phone:String?
    var address:String?
    var age:String?
    var appPush:String?
    //var create_time:String?
    //var id:String?
    var name:String?
    //var phone:String?
    var photo:String?
    var sex:String?
    var update_time:String?
    var weixin:String?
    var whatsapp:String?
}
