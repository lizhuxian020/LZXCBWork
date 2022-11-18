//
//  CBPetLoginViewModel.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/21.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

enum CBPetSetPwdType:String {
    case forget    =  "forget"   //忘记密码
    case modify     = "modify"     //修改
}
class CBPetLoginViewModel: CBPetBaseViewModel {
    
    var updPwdType:CBPetSetPwdType?
    
    var loginBlock:((_ phone:String,_ pwd:String) -> Void)?
    var forgetBlock:(() -> Void)?
    
    var showLoginBlock:(() -> Void)? //跳到登录页
    var showResgiterBlock:(() -> Void)? //跳到注册页
    
    var getVerificationCodeBlock:((_ sender:CBPetLoginInputView,_ phone:String,_ areaCode:String) -> Void)?
//    var getVerificationCodeUpdateViewBlock:((_ coutDown:Int,_ isFinished:Bool) -> Void)?
    
    var registerBlock:((_ email:String,_ code:String,_ pwd:String,_ crCode:String) -> Void)?
    var registerUpdateViewBlock:((_ phone:String) -> Void)?
    
    var clickBlock:((_ clickTag:Int) -> Void)?
    
    /* 获取图形验证码 */
    var petVerificateImageBlock:((_ objc:CBPetVerifyGraphicsModel) -> Void)?
    var graphicsModel:CBPetVerifyGraphicsModel?
    var isValid:Bool?
}
extension CBPetLoginViewModel {
    func getVerificationImage() {
        let paramters:Dictionary<String,Any> = Dictionary()
        CBPetNetworkingManager.share.getVerificationImageRequest(paramters: paramters,successBlock: { [weak self] (successModel) in
            ///返回错误信息
            guard successModel.status == "0" else {
                guard self?.petVerificateImageBlock == nil else {
                    self?.petVerificateImageBlock!(CBPetVerifyGraphicsModel.init())
                    return
                }
                return;
            }
            let json = JSON.init(successModel.data as Any)
            self?.graphicsModel = CBPetVerifyGraphicsModel.deserialize(from: json.dictionaryObject) ?? CBPetVerifyGraphicsModel.init()
            
            self?.isValid = true
            if #available(iOS 10.0, *) {
                Timer.scheduledTimer(withTimeInterval: TimeInterval(60), repeats: true) { [weak self] (timer:Timer) -> Void in
                    self?.isValid = false
                }
            } else {
                // Fallback on earlier versions
            }
            guard self?.petVerificateImageBlock == nil else {
                self?.petVerificateImageBlock!(self?.graphicsModel ?? CBPetVerifyGraphicsModel.init())
                return
            }
        }, failureBlock: { [weak self] (failureModel) in
            guard self?.petVerificateImageBlock == nil else {
                self?.petVerificateImageBlock!(CBPetVerifyGraphicsModel.init())
                return
            }
        })
    }
}
