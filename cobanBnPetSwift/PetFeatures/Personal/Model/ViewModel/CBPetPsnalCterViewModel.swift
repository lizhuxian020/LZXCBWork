//
//  CBPetPsnalCterViewModel.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/3.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

enum CBPetPsnalCterClickType:String {
    case psnaInfo    =  "psnaInfo"             //个人主页
    case editPet     =  "editPet"              //编辑宠物
    case switchSystem     =  "switchSystem"    //切换系统
    case switchNotice     =  "switchNotice"    //信息通知
    case modifyPwd        =  "modifyPwd"       //修改密码
    case cleanCache       =  "cleanCache"       //清除缓存
    case aboutUs          =  "aboutUs"          //关于我们
    case logout           =  "logout"          //退出登陆
}
enum CBPetPsnalCterUpdType:String {
    case petList    =  "petList"             //个人主页
    case userInfo   =  "userInfo"            //编辑宠物
}
class CBPetPsnalCterViewModel: CBPetBaseViewModel {
    
    //MARK: - 数据源刷新
    var psnlUpdateDataBlock:((_ type:CBPetPsnalCterUpdType,_ objc:Any) -> Void)?
    
    
    //MARK: - 点击事件
    /* 个人中心点击*/
    var psnlCterClickBlock:((_ type:CBPetPsnalCterClickType,_ objc:Any) -> Void)?
    
    
    var psnalInfoModel:CBPetUserInfoModel?
    var petInfoModel:CBPetPsnalCterPetModel?
    
    
    /* 编辑宠物资料 回调刷新 宠物资料列表 block */
    var psnalCterEditPetInfoUpdUIBlock:((_ objc:Any) -> Void)?
    
    
    /* input编辑资料 block*/
    var psnalCterInputEditInfoBlock:((_ objc:CBPetUserInfoModel) -> Void)?
}
//extension CBPetPsnalCterViewModel {
//    //MARK: - 修改用户信息request
//    func updateUserInfoRequest(appPush:String) {
//        var paramters:Dictionary<String,Any> = Dictionary()
//        if let value = CBPetLoginModelTool.getUser()?.uid {
//            paramters = ["uid":value.valueStr]
//        }
//        paramters["appPush"] = appPush
////        MBProgressHUD.showAdded(to: self.view, animated: true)
//        CBPetNetworkingManager.share.updateUserInfoRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
////            if let value = self?.view {
////                MBProgressHUD.hide(for: value, animated: true)
////            }
//            ///返回错误信息
//            guard successModel.status == "0" else {
//                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
//                return;
//            }
//            var userInfo = CBPetUserInfoModelTool.getUserInfo()
//            userInfo.appPush = appPush
//            CBPetUserInfoModelTool.saveUserInfo(userInfoModel: userInfo)
//        }) { [weak self] (failureModel) in
////            if let value = self?.view {
////                MBProgressHUD.hide(for: value, animated: true)
////            }
//        }
//    }
//}
