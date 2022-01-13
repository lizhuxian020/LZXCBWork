//
//  CBPetBaseViewModel.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/21.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetBaseViewModel: NSObject {
    //MARK: - 数据模型
    /* 七牛token*/
    public var qnyToken:String?
    
    /* 点击跳转block*/
    var pushBlock:((_ objc:Any) -> Void)?
    
    /* 是否从个人中心 ***** push个人主页 */
    var isComfromPsnalCter:Bool = false
    
    /* 接收到通知 ***** 查看资料push个人主页 */
    var isComfromNoticePush:Bool = false
    
    /* 刷新宠物资料block */
    var psnalPageUpdatePetListBlock:((_ objc:Any) -> Void)?
    /* 刷新个人资料block */
    var psnalPageUpdateUserInfoBlock:((_ objc:Any) -> Void)?
    /* 编辑宠物资料block */
    var psnalPageEditPetInfoBlock:((_ objc:Any) -> Void)?
    /* 编辑个人资料block */
    var psnalPageEditUserInfoBlock:((_ objc:Any) -> Void)?
    /* 查看宠物资料block */
    var psnalPageVisitPetInfoBlock:((_ objc:Any) -> Void)?
    /* 个人资料btnblock */
    var psnalPageActionBlock:((_ tag:Int) -> Void)?
    
    
    /* mjrefresh block*/
    var MJHeaderRefreshReloadDataBlock:((_ tag:Int) -> Void)?
    var MJFooterRefreshReloadDataBlock:((_ tag:Int) -> Void)?
}
extension CBPetBaseViewModel {
    //MARK: - 获取七牛上传凭证token
    public func getQNFileTokenRequestMethod() {
        CBPetNetworkingManager.share.getQNFileTokenRequest(paramters: ["":""], successBlock: { [weak self] (successModel) in
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            let ddJson = JSON.init(successModel.data as Any).stringValue
            guard ddJson.isEmpty == true else {
                self?.qnyToken = ddJson
                return
            }
            MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "获取上传照片凭证失败".localizedStr, Deleay: 1.5)
        }) { (failureModel) in
        }
    }
}
