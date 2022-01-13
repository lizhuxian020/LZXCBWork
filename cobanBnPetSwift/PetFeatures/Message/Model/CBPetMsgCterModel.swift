//
//  CBPetMsgCterModel.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/4.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import HandyJSON

//class CBPetMsgCterModel: NSObject {
//}
struct CBPetMsgCterModel:HandyJSON {
    ///消息主页、系统消息
    var iconImage:String?
    var title:String = "宠物定位".localizedStr
    var text:String = ""
    var time:String?
    var badge:String?
    
    var add_time:String?
    var countMessage:String? ///消息类型 3：低电告警 5：绑定申请6.听一听动态 8:围栏动态}
    var fence_alarm_type:String?///1,出围栏 2进围栏
    var imei:String?
    var message_type:String?
    var index:Int = 0
    var isShow:Bool = false
    mutating func setCountMessage(newCountMessage:String) {
        //self.countMessage = newCountMessage
        /* handyJSON拓展方法，将本身转为dic ，改变model属性*/
//        var temp:[String:Any] = toJSON()!
//        temp.updateValue("12", forKey: "55")
    }
    
    ///系统消息
    var account:String?
    var addTime:String?
    var friendHead:String?
    var friendName:String?
    var id:String?
    //var imei:String?
    var isAuth:String?
    //var isRead:Int = 0
    var isRead:String?
    var messListIsCache:String?
    var messageContent:String?
    var messageType:String?
    var petName:String?
    var updateTime:String?
    
    ///听听记录
//    var account:String?
//    var addTime:String?
//    var id:String?
//    var imei:String?
//    var isRead:String?
    var voiceTime:String? /* 听听记录时长*/
    var listenFile:String?
    var petHead:String?
//    var petName:String?
//    var messageType:String?
//    var petHead:String?
//    var petName:String?
//    var updateTime:String?
    
    
    ///电量动态
    //var account:String?
    //var id:String?
    //var imei:String?
    //var isRead:String?
    //var messListIsCache:String?
    //var messageType:String?
    //var updateTime:String?
    
    
    ///定位记录
   //var add_time:String?
   //var id:String?
   //var imei:String?
   var lat:String?
   var lng:String?
   var orgin_lat:String?
   var orgin_lng:String?
}
/////围栏动态
struct CBPetMsgCterFenceDynamicModel:HandyJSON {
    var account:String?
    var addTime:String?
    var alarmLat:String?
    var alarmLng:String?
    var lng:String?
    var fenDate:String?
    var fenceAlarmType:String?
    var id:String?
    var imei:String?
    var isRead:String?
    var messListIsCache:String?
    var messageContent:String?
    var messageType:String?
    var petHead:String?
    var petName:String?
    var updateTime:String?
}

