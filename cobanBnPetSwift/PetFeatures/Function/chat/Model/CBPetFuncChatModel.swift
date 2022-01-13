//
//  CBPetFuncChatModel.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/1.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import HandyJSON

//class CBPetFuncChatModel: NSObject {
//}
/* 附近狗友 model*/
struct CBPetFuncNearPetModel:HandyJSON {
    var add_time:String?
    var age:String?
    var color:String?
    var device:CBPetFuncNearPetDeviceModel = CBPetFuncNearPetDeviceModel()
    var distance:String?
    var epidemicImage:String?
    var epidemicRecord:String?
    var epidemic_status:String?
    var hight:String?
    var id:String?
    var admin_Id:String?
    var isPublish:String?
    var lat_y:String?
    var lng_x:String?
    var name:String?
    var photo:String?
    var sex:String?
    var update_time:String?
    var variety:String?
    /* 与本人关系*/
    var isAuth:String?
}
struct CBPetFuncNearPetDeviceModel:HandyJSON {
    var create_time:String?
    var imei:String?
    var location:CBPetFuncNearPetDeviceLocationModel = CBPetFuncNearPetDeviceLocationModel()
    var online: String?
}
struct CBPetFuncNearPetDeviceLocationModel:HandyJSON {
    var add_time:String?
    var baterry:String?
    var id:String?
    var imei:String?
    var lat:String?
    var lng:String?
    var orgin_lat:String?
    var orgin_lng:String?
    var postTime:String?
    var speed:String?
    var status:String?
    var warn:String?
}
/* 微聊 model*/
struct CBPetFuncCvstionModel:HandyJSON {
    var mgsStr:String?
    var isVoice:Bool = false
    var isMyself:Bool = false
    
    var accepter:String?
    var add_time:String?
    var chatType:String?
    var id:String?
    var isPush:String?
    var isRead:String?
    var message_file:String?
    var message_text:String?
    /* sendd_my_self发送者是谁： 0：收到的别人消息1：自己发出去的消息]*/
    var sendd_my_self:String?
    var sender:String?
    
    
    var photo:String?
    var voiceTime:String?
}
/* 微聊宠友 model*/
struct CBPetFuncPetFriendsModel:HandyJSON {
    var account:String?
    var age:String?
    var create_time:String?
    var email:String?
    var admin_Id:String?
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
    
    var friendHead:String?
    var friendName:String?
    var friendId:String?
    var friendMsgId:String?
    //var id:String?
    var uid:String?
    var isAuth:String?
    var isRead:String?
    var messListIsCache:String?
    var messageContent:String?
    var messageType:String?
    var updateTime:String?
}
/* 微聊消息 model*/
struct CBPetFuncPetFriendsMsgModel:HandyJSON {
    var accepter:String?
    var add_time:String?
    var id:String?
    var message_file:String?
    var name:String?
    var phone:String?
    var photo:String?
    var sender:String?
    var unReadCount:String?
    var message_text:String?
}

