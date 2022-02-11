//
//  CBPetFuncChatViewModel.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/31.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

enum CBPetFuncChatUpdDataType:String {
    /* 搜索附近宠物*/
    case nearPet = "nearPet"
    /* 宠友申请列表*/
    case petFriendApply  = "petFriendApply"
    /* 宠友列表*/
    case petFriendList = "petFriendList"
    /* 宠友消息*/
    case petFriendMsgList = "petFriendMsgList"
    
    /* 设置惩罚时间*/
    case setPunishment = "133"
    /* 发起/结束惩罚*/
    case punishing = "137"
    /* 设置圆形围栏*/
    case setFence = "152"
}
enum CBPetFuncChatClickType:String {
    /* 附近宠友-查看资料*/
    case visitPetInfo = "visitPetInfo"
    /* 宠友列表-更多申请*/
    case moreApply = "moreApply"
    /* 宠友列表-宠友详情*/
    case petFriendDetailInfo  = "petFriendDetailInfo"
    /* 宠友消息-详情点击前往聊天*/
    case toCvstion = "toCvstion"
}
class CBPetFuncChatViewModel: CBPetBaseViewModel {

    //MARK: - 数据源刷新
    var updateDataFuncChatBlock:((_ type:CBPetFuncChatUpdDataType,_ objc:Any) -> Void)?
    var petFriendMsgModel:CBPetFuncPetFriendsMsgModel?
    
    /* 点击跳转*/
    var clickPushFuncChatBlock:((_ type:CBPetFuncChatClickType,_ objc:Any) -> Void)?
    
    var myPetData: CBPetFuncNearPetModel?
    /* 附近宠友数据*/
    var nearPetsDataSource:[CBPetFuncNearPetModel]?
    /* 宠友申请列表数据*/
    var petfriendsApplyDataSource:[CBPetFuncPetFriendsModel]?
    /* 宠友列表数据*/
    var petfriendsListDataSource:[CBPetFuncPetFriendsModel]?
    /* 宠友消息列表数据*/
    var petfriendsMsgListDataSource:[CBPetFuncPetFriendsMsgModel]?
    
    
    /* 更新附近宠友数据*/
    var petFriendsUpdNearPetsUIBlock:(() -> Void)?
    /* 更新宠友列表数据*/
    var petFriendsListUpdUIBlock:((_ isEnd:Bool,_ dataSource:[Any]) -> Void)?
    /* 更新宠友申请列表数据*/
    var petFriendsApplyListUpdUIBlock:((_ isEnd:Bool,_ dataSource:[Any]) -> Void)?
    /* 处理添加好友请求  同意，拒绝申请，删除宠友操作 */
    var petFriendsDealWithFriendApplyBlock:((_ state:String,_ model:CBPetFuncPetFriendsModel) -> Void)?
    
    
    /* 更新宠友消息列表数据*/
    var petFriendsMsgListUpdUIBlock:((_ isEnd:Bool,_ dataSource:[Any]) -> Void)?
    /* 更新宠友聊天列表数据*/
    var petFriendsChatListUpdUIBlock:((_ isEnd:Bool,_ dataSource:[Any]) -> Void)?
    
    
    /* 聊天底部菜单操作，发文字、语音、播放*/
    var petfriendCvstionChatBlock:((_ objc:Any,_ type:String,_ time:Int) -> Void)?
}
extension CBPetFuncChatViewModel {
    private func request_commonUpdBlock(type:CBPetFuncChatUpdDataType,objc:Any) {
        guard self.updateDataFuncChatBlock == nil else {
            self.updateDataFuncChatBlock!(type,objc)
            return
        }
    }
    //MARK: - 搜索附近宠物
    func searchNearbyPetsRequest() {
        self.nearPetsDataSource?.removeAll()
        let paramters:Dictionary<String,Any> = ["id":CBPetHomeInfoTool.getHomeInfo().pet.id ?? "","rad":"100000"] ///rad":"搜索半径，单位米"
        CBPetNetworkingManager.share.searchNearbyPetsRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                self?.request_commonUpdBlock(type: CBPetFuncChatUpdDataType.nearPet, objc: self?.nearPetsDataSource ?? [CBPetFuncNearPetModel]())
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let nearPetObject = JSONDeserializer<CBPetFuncNearPetModel>.deserializeModelArrayFrom(array: ddJson.arrayObject)
            self?.nearPetsDataSource = nearPetObject as? [CBPetFuncNearPetModel]
            self?.request_commonUpdBlock(type: CBPetFuncChatUpdDataType.nearPet, objc: self?.nearPetsDataSource ?? [CBPetFuncNearPetModel]())
        }) { [weak self] (failureModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            self?.request_commonUpdBlock(type: CBPetFuncChatUpdDataType.nearPet, objc: self?.nearPetsDataSource ?? [CBPetFuncNearPetModel]())
        }
    }
    //MARK: - 获取宠友申请列表
    func getPetfriendsApplyListRequest() {
        self.petfriendsApplyDataSource?.removeAll()
        let paramters:Dictionary<String,Any> = ["uid":CBPetLoginModelTool.getUser()?.uid ?? "","messageType":"4"]
        CBPetNetworkingManager.share.getMsgByMsgTypeRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            //返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                self?.request_commonUpdBlock(type: CBPetFuncChatUpdDataType.petFriendApply, objc: self?.petfriendsApplyDataSource ?? [CBPetFuncPetFriendsModel]())
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let petFriendApplyListObject = JSONDeserializer<CBPetFuncPetFriendsModel>.deserializeModelArrayFrom(array: ddJson.arrayObject)
            self?.petfriendsApplyDataSource = petFriendApplyListObject as? [CBPetFuncPetFriendsModel]
            self?.request_commonUpdBlock(type: CBPetFuncChatUpdDataType.petFriendApply, objc: self?.petfriendsApplyDataSource ?? [CBPetFuncPetFriendsModel]())
        }) { [weak self] (failureModel) in
            self?.request_commonUpdBlock(type: CBPetFuncChatUpdDataType.petFriendApply, objc: self?.petfriendsApplyDataSource ?? [CBPetFuncPetFriendsModel]())
        }
    }
    //MARK: - 获取我的宠友列表
    func getPetfriendsListRequest() {
        self.petfriendsListDataSource?.removeAll()
        guard CBPetLoginModelTool.getUser()?.uid != nil else {
            return
        }
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        CBPetNetworkingManager.share.getMyPetFriendsListRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                self?.request_commonUpdBlock(type: CBPetFuncChatUpdDataType.petFriendList, objc: self?.petfriendsListDataSource ?? [CBPetFuncPetFriendsModel]())
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let petFriendListObject = JSONDeserializer<CBPetFuncPetFriendsModel>.deserializeModelArrayFrom(array: ddJson.arrayObject)
            self?.petfriendsListDataSource = petFriendListObject as? [CBPetFuncPetFriendsModel]
            self?.request_commonUpdBlock(type: CBPetFuncChatUpdDataType.petFriendList, objc: self?.petfriendsListDataSource ?? [CBPetFuncPetFriendsModel]())
        }) { [weak self] (failureModel) in
            self?.request_commonUpdBlock(type: CBPetFuncChatUpdDataType.petFriendList, objc: self?.petfriendsListDataSource ?? [CBPetFuncPetFriendsModel]())
        }
    }
    //MARK: - 获取宠友消息列表
    func getPetfriendsMsgListRequest() {
        self.petfriendsMsgListDataSource?.removeAll()
        guard CBPetLoginModelTool.getUser()?.uid != nil else {
            return
        }
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        CBPetNetworkingManager.share.getPetFriendsMessageRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                self?.request_commonUpdBlock(type: CBPetFuncChatUpdDataType.petFriendMsgList, objc: self?.petfriendsMsgListDataSource ?? [CBPetFuncPetFriendsMsgModel]())
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let petFriendMsgObject = JSONDeserializer<CBPetFuncPetFriendsMsgModel>.deserializeModelArrayFrom(array: ddJson.arrayObject)
            self?.petfriendsMsgListDataSource = petFriendMsgObject as? [CBPetFuncPetFriendsMsgModel]
            self?.request_commonUpdBlock(type: CBPetFuncChatUpdDataType.petFriendMsgList, objc: self?.petfriendsMsgListDataSource ?? [CBPetFuncPetFriendsMsgModel]())
        }) { [weak self] (failureModel) in
            self?.request_commonUpdBlock(type: CBPetFuncChatUpdDataType.petFriendMsgList, objc: self?.petfriendsMsgListDataSource ?? [CBPetFuncPetFriendsMsgModel]())
        }
    }
    //MARK: - 处理添加好友求情,
    public func dealWithAddfriendApplyRequest(state:String,model:CBPetFuncPetFriendsModel) {
        guard state.isEmpty == false else {
            return
        }
        /*messageId 消息Id state 0:通过，1：等待授权，2：拒绝 */
        let paramters:Dictionary<String,Any> = ["messageId":model.id ?? "","state":state]
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.dealWithAddPetownerFriendRequest(paramters: paramters, successBlock: { (successModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            ///返回错误信息
            guard successModel.status == "0" else {
                /* 发送删除宠友、处理宠友申请消息通知*/
                NotificationCenter.default.post(name: NSNotification.Name.init(K_CBPetDeletePetFriendNotification), object: nil)
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            /* 发送删除宠友、处理宠友申请消息通知*/
            NotificationCenter.default.post(name: NSNotification.Name.init(K_CBPetDeletePetFriendNotification), object: nil)
        }) { (failureModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
        }
    }
    //MARK: - 删除宠友
    public func deleteFriendRequest(friendId:String,uid:String) {
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        let paramters:Dictionary<String,Any> = ["friendUid":friendId,"uid":uid]
        CBPetNetworkingManager.share.deletePetownerFriendRequest(paramters: paramters, successBlock: { (successModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            /* 发送删除宠友、处理宠友申请(同意，拒绝，删除)消息通知*/
            NotificationCenter.default.post(name: NSNotification.Name.init(K_CBPetDeletePetFriendNotification), object: nil)
        }) { (failureModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
        }
    }
    //MARK: - 删除宠友申请
    public func deleteFriendApplyMsgRequest(ids:String) {
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        let paramters:Dictionary<String,Any> = ["ids":ids]
        CBPetNetworkingManager.share.getDeleteMessageByIdsRequest(paramters: paramters, successBlock: { (successModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            /* 发送删除宠友、处理宠友申请(同意，拒绝，删除)消息通知*/
            NotificationCenter.default.post(name: NSNotification.Name.init(K_CBPetDeletePetFriendNotification), object: nil)
        }) { (failureModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
        }
    }
}
