//
//  CBPetNetworking.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/3/11.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import HandyJSON

class CBPetNetworking: NSObject {
    
    ///单例
    static let shareInsantce:CBPetNetworking = {
        let manager = CBPetNetworking.init()
        return manager
    }()
    
    class func requestWith(method:Alamofire.HTTPMethod,
                        url:String,paramters:[String:Any],
                        token:String,
                        successBlock: @escaping(CBBaseNetworkModel) -> Void,
                        failureBlock:@escaping(CBBaseNetworkModel) -> Void) {
        self.requestRealWith(method: method, url: url, paramters: paramters, token: token, successBlock: successBlock, failureBlock: failureBlock)
    }
    private class func requestRealWith(method:Alamofire.HTTPMethod,
                           url:String,paramters:[String:Any],
                           token:String,
                           successBlock: @escaping(CBBaseNetworkModel) -> Void,
                           failureBlock:@escaping(CBBaseNetworkModel) -> Void) {
        var dicHeader:HTTPHeaders = self.configHeaders()
        let user = CBPetLoginModelTool.getUser()
        if user?.token?.isEmpty == false {
            dicHeader["token"] = user!.token!
        }
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        CBLog(message: "请求header:\(dicHeader ) 请求参数:\(paramters)  请求链接:\(url)")
        manager.request(url, method: method,
                        parameters: paramters,
                        encoding: URLEncoding.default, /// 表单 queryString  default
                        headers: dicHeader )
            .responseJSON { (response) in // 将响应结果序列化为Json
                /* 检查网络*/
                CBPetNetworking.checkNetworkStatus()
                guard response.result.isSuccess else {
                    // 失败
                    CBLog(message: "请求失败\(response)")
                    let errorResult = CBBaseNetworkModel()
                    failureBlock(errorResult)
                    MBProgressHUD.showMessage(Msg: "请求超时".localizedStr, Deleay: 1.5)
                    return
                }
                let jsonValue = response.result.value
                let json = JSON.init(jsonValue as Any)
                /// JSONDeserializer<CBBaseNetworkModel>.deserializeFrom(dict: json.dictionaryValue)
                var result = CBBaseNetworkModel.deserialize(from: json.dictionaryValue)
                if result == nil {
                    result = CBBaseNetworkModel()
                }
                CBLog(message: "请求成功\(response.result.value ?? "")")
                /* 响应信息*/
                result?.response = response.response
                successBlock(result!)
        }
    }
    private class func configHeaders() -> HTTPHeaders {
        let headers:HTTPHeaders = Dictionary() //["":""]//["Content-type":"application/json;charset=utf-8",
                                         //"Accept":"application/json"]
        return headers
        //"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html",@"application/x-www-form-urlencoded",@"image/jpeg",@"image/png",@"application/octet-stream"
    }
    private class func checkNetworkStatus() {
        CBPetNetworkingReachability.share.checkNetReachAble { (reable:Bool) in  ///[weak self]
            if reable {
                /* 有网络通知*/
                let notificationName = NSNotification.Name.init(K_CBPetNetErrorNotification)
                NotificationCenter.default.post(name: notificationName, object: ["isShow":false])
            } else {
                /* 无网络提示通知*/
                let notificationName = NSNotification.Name.init(K_CBPetNetErrorNotification)
                NotificationCenter.default.post(name: notificationName, object: ["isShow":true])
                MBProgressHUD.showMessage(Msg: "无网络连接", Deleay: 1.5)
            }
        }
    }
}
