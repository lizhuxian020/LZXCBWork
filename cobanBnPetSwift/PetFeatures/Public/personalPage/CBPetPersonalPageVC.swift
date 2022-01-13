//
//  CBPetPersonalPageVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/2.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetPersonalPageVC: CBPetBaseViewController {


    /* 个人中心viewModel*/
    public lazy var psnalCterViewModel:CBPetPsnalCterViewModel = {
        let viewModel = CBPetPsnalCterViewModel()
        return viewModel
    }()
    /* 微聊viewModel*/
    public lazy var funcViewModel:CBPetFuncChatViewModel = {
        let vv = CBPetFuncChatViewModel.init()
        return vv
    }()
    private lazy var personlPageView:CBPetPersonalPageView = {
        let vv = CBPetPersonalPageView.init()
        return vv
    }()
    var petFriendModel:CBPetFuncPetFriendsModel?
    
    var petListModelObject:CBPetPsnalCterPetAllModel?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllDeviceRequest()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupView()
    }
    private func setupView() {
        
        initBarWith(title: "", isBack: true)
        if self.viewModel.isComfromPsnalCter {
            initBarRight(title: "隐私设置".localizedStr, action: #selector(toPrivacySetting))
            self.rightBtn.setTitleColor(KPetAppColor, for: .normal)
            self.rightBtn.setTitleColor(KPetAppColor, for: .highlighted)
            self.rightBtn.titleLabel?.font = UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)
        }
        
        self.personlPageView.backgroundColor = UIColor.white
        self.view.addSubview(self.personlPageView)
        self.personlPageView.snp_makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }

        /* 从微聊过来，查看个人信息，宠物信息*/
        /* 从个人中心过来，可编辑个人信息，宠物信息*/
        self.personlPageView.petFriendModel = self.petFriendModel
        self.personlPageView.setupViewModel(viewModel: self.viewModel)
        if self.viewModel.isComfromPsnalCter {
            ///编辑宠物资料
            self.viewModel.psnalPageEditPetInfoBlock = { [weak self] (objc:Any) -> Void in
                if objc is CBPetPsnalCterPetModel {
                    if (objc as! CBPetPsnalCterPetModel).title == "添加".localizedStr {
                        /* 添加宠物*/
                        self!.scanAddPet()
                    } else {
                        /* 编辑宠物资料*/
                        self?.editPetInfoClick(model:objc)
                    }
                }
            }
            ///编辑个人资料
            self.viewModel.psnalPageEditUserInfoBlock = { [weak self] (objc:Any) -> Void in
                self?.editUserInfoClick()
            }
        } else {
            ///查看宠物资料
            self.viewModel.psnalPageVisitPetInfoBlock = { [weak self] (objc:Any) -> Void in
                self?.visistPetInfoClick(model:objc)
            }
            ///加好友，删除，发消息
            self.viewModel.psnalPageActionBlock = { [weak self] (tag:Int) -> Void in
                switch tag {
                case 2020:
                    CBLog(message: "加TA宠友 加TA宠友 加TA宠友")
                    self?.addPetFriendRequest()
                    break
                case 2021:
                    CBLog(message: "删除")
                    self?.deleteClick()
                    break
                case 2022:
                    CBLog(message: "发消息")
                    self?.sendMsgClick()
                    break
                case 2023:
                    CBLog(message: "拒绝")
                    self?.refusePetFriendApply()
                case 2024:
                    CBLog(message: "同意宠友")
                    self?.acceptPetFriendApply()
                default:
                    break
                }
            }
        }
    }
    //MARK: - 获取用户的宠物列表
    private func getAllDeviceRequest() {
        var paramters:Dictionary<String,Any> = Dictionary()
        /* 当前用户的宠物列表*/
        if self.viewModel.isComfromPsnalCter == true {
            guard CBPetLoginModelTool.getUser()?.uid != nil else {
                return
            }
            if let value = CBPetLoginModelTool.getUser()?.uid {
                paramters["uid"] = NSNumber.init(value: Int(value.valueStr) ?? 0)
            }
        } else {
            /* 附近的宠友传admin_Id */
            paramters["uid"] = self.petFriendModel?.admin_Id
            /* 其他宠友的宠物列表*/
            if let value = self.petFriendModel?.friendId {
                /* 申请好友*/
                paramters["uid"] = NSNumber.init(value: Int(value.valueStr) ?? 0)
            } else {
                /* 好友*/
                if let value = self.petFriendModel?.id {
                    paramters["uid"] = NSNumber.init(value: Int(value.valueStr) ?? 0)
                }
            }
            if let value = CBPetLoginModelTool.getUser()?.uid {
                paramters["friendUid"] = NSNumber.init(value: Int(value.valueStr) ?? 0)
                if self.petFriendModel?.admin_Id == CBPetLoginModelTool.getUser()?.uid {
                /* 附近的宠物为自己*/
                    paramters["friendUid"] = ""
                }
            }
        }
        
        CBPetNetworkingManager.share.getAllDeviceRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            MBProgressHUD.hide(for: self?.view ?? UIView.init(), animated: true)
            /* 返回错误信息*/
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                self?.updatePetListMethod(model: CBPetPsnalCterPetAllModel())
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            self?.petListModelObject = JSONDeserializer<CBPetPsnalCterPetAllModel>.deserializeFrom(dict: ddJson.dictionaryObject)
            if let value = self?.petListModelObject {
                self?.updatePetListMethod(model: value)
            }
            /* 当前用户的用户信息*/
            if self?.viewModel.isComfromPsnalCter == true {
                let userInfoModelObject = CBPetUserInfoModelTool.getUserInfo()
                guard self?.viewModel.psnalPageUpdateUserInfoBlock == nil else {
                    self?.viewModel.psnalPageUpdateUserInfoBlock!(userInfoModelObject)
                    return
                }
            } else if self?.petListModelObject?.allPet.count ?? 0 > 0 {
            /* 其他的用户是信息*/
                let petUserInfoModel = self?.petListModelObject?.allPet[0]
                guard self?.viewModel.psnalPageUpdateUserInfoBlock == nil else {
                    if let value = petUserInfoModel?.user {
                        self?.viewModel.psnalPageUpdateUserInfoBlock!(value)
                    }
                    return
                }
            }
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            self?.updatePetListMethod(model: CBPetPsnalCterPetAllModel())
        }
    }
    private func updatePetListMethod(model:CBPetPsnalCterPetAllModel)  { ///(modelArr:[CBPetPsnalCterPetModel])
        guard self.viewModel.psnalPageUpdatePetListBlock == nil else {
            self.viewModel.psnalPageUpdatePetListBlock!(model)
            return
        }
    }
    private func updateUserInfoMethod(model:CBPetUserInfoModel)  {
        guard self.viewModel.psnalPageUpdateUserInfoBlock == nil else {
            self.viewModel.psnalPageUpdateUserInfoBlock!(model)
            return
        }
    }
    //MARK: - 添加宠友
    private func addPetFriendRequest() {
        var paramters:Dictionary<String,Any> = Dictionary()
        /* 附近的宠友传admin_Id */
        paramters["friendUid"] = self.petFriendModel?.admin_Id
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = NSNumber.init(value: Int(value.valueStr) ?? 0)
        }
        /* 其他宠友的宠物列表*/
        if let value = self.petFriendModel?.friendId {
            /* 申请好友*/
            if let value = CBPetLoginModelTool.getUser()?.uid {
                paramters["uid"] = NSNumber.init(value: Int(value.valueStr) ?? 0)
            }
            switch self.petFriendModel?.isAuth {
            case "0":
                /* 已同意*/
                paramters["friendUid"] = value//""
                break
            case "1":
                /* 等待处理 */
                paramters["friendUid"] = value
                break
            case "2":
                /* 已拒绝 */
                paramters["friendUid"] = value
                break
            default:
                /* 非好友*/
                paramters["friendUid"] = value
                break
            }
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.addPetownerFriendRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            /* 返回错误信息*/
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
            MBProgressHUD.showMessage(Msg: "请求成功".localizedStr, Deleay: 1.5)
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
        }
    }
    //MARK: - 拒绝宠友申请
    private func refusePetFriendApply() {
        self.dealWithPetFriendApply(state: "2")
    }
    //MARK: - 同意宠友申请
    private func acceptPetFriendApply() {
        self.dealWithPetFriendApply(state: "0")
    }
    private func dealWithPetFriendApply(state:String) {
        /*messageId 消息Id state 0:通过，1：等待授权，2：拒绝 */
        let paramters:Dictionary<String,Any> = ["messageId":self.petFriendModel?.friendMsgId ?? "","state":state]
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.dealWithAddPetownerFriendRequest(paramters: paramters, successBlock: { (successModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            ///返回错误信息
            guard successModel.status == "0" else {
                /* 发送删除宠友、处理宠友申请消息通知*/
                //NotificationCenter.default.post(name: NSNotification.Name.init(K_CBPetDeletePetFriendNotification), object: nil)
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            /* 发送删除宠友、处理宠友申请消息通知*/
            NotificationCenter.default.post(name: NSNotification.Name.init(K_CBPetDeletePetFriendNotification), object: nil)
            self.navigationController?.popViewController(animated: true)
            //self.getAllDeviceRequest()
            
        }) { (failureModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
        }
    }
        
    //MARK: - 编辑宠物资料
    private func editPetInfoClick(model:Any) {
        let petInfoModel = model as! CBPetPsnalCterPetModel
        let petInfoVC = CBPetPsnalCterEditPetInfoVC.init()
        petInfoVC.psnalCterViewModel.petInfoModel = petInfoModel
        self.psnalCterViewModel.psnalCterEditPetInfoUpdUIBlock = { [weak self] (_ objc:Any) -> Void in
            /* 编辑宠物资料后回调刷新数据*/
            CBLog(message: "编辑宠物资料后回调刷新数据")
        }
        self.navigationController?.pushViewController(petInfoVC, animated: true)
    }
    //MARK: - 扫码添加宠物
    private func scanAddPet() {
        if CBPetUtils.checkCameraPermission(resultBlock: { [weak self] (isAllow) in
            if isAllow == true {
                CBLog(message: "用户点击了允许相机授权")
                self?.toBindVC()
            } else {
                CBLog(message: "用户点击了不允许相机授权")
            }
        }) == true {
            self.toBindVC()
        }
//        scanBindVC.viewModel = self.homeViewModel
//        self.homeViewModel.bindDeviceUpdateDataBlock = { [weak self] () -> Void in
//            /* 绑定设备后 回调刷新首页*/
//            CBLog(message: "绑定设备后 回调刷新首页 绑定设备后 回调刷新首页 绑定设备后 回调刷新首页")
//            self?.getHomeInfoRequest()
//        }
        
    }
    private func toBindVC() {
        let scanBindVC = CBPetScanToBindDeviceVC.init()
        self.navigationController?.pushViewController(scanBindVC, animated: true)
    }
    //MARK: - 编辑个人信息
    private func editUserInfoClick() {
        let vc = CBPetPsnalCterEditUserInfoVC.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - 前往隐私设置
    @objc private func toPrivacySetting() {
        let vc = CBPetPsnalPrivacySettingVC.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - 查看宠物资料
    private func visistPetInfoClick(model:Any) {
        let petInfoModel = model as! CBPetPsnalCterPetModel
        let vc = CBPetFuncChatPetInfoVC.init()
        vc.psnalCterViewModel.petInfoModel = petInfoModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - 删除
    private func deleteClick() {
        /* 好友列表*/
        var titleStr = ""
        if self.petListModelObject?.allPet.count ?? 0 > 0 {
        /* 其他的用户是信息*/
            let petUserInfoModel = self.petListModelObject?.allPet[0]
            if let value = petUserInfoModel?.user.name {
                titleStr = String.init(format: "将宠友%@删除\n同时删除与该宠友的聊天记录", "''\(value)''")
            }
        }
        CBPetPopView.share.showAlert(title: "", subTitle: titleStr, comfirmBtnText: "删除".localizedStr,cancelBtnText: "取消".localizedStr, comfirmColor: KPetAppColor, cancelColor: KPet999999Color, completeBtnBlock: { [weak self] () -> Void in
            self?.deleteClickRequest()
        }) { () in
            //
        }
    }
    private func deleteClickRequest() {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        /* 附近的宠友传admin_Id */
        if let value = self.petFriendModel?.admin_Id {
            paramters["friendUid"] = value.valueStr
        }
        /* 其他宠友的宠物列表*/
        if let value = self.petFriendModel?.friendId {
            /* 申请好友*/
            switch self.petFriendModel?.isAuth {
            case "0":
                /* 已同意*/
                paramters["friendUid"] = value
                break
            case "1":
                /* 等待处理 */
                break
            case "2":
                /* 已拒绝 */
                break
            default:
                /* 非好友*/
                break
            }
        } else {
           /* 好友*/
            if let value = self.petFriendModel?.id {
                paramters["friendUid"] = value.valueStr
            }
        }
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.deletePetownerFriendRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            /* 发送删除宠友、处理宠友申请消息通知*/
            NotificationCenter.default.post(name: NSNotification.Name.init(K_CBPetDeletePetFriendNotification), object: nil)
            self?.navigationController?.popViewController(animated: true)
        }) { [weak self] (failureModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
        }
    }
    //MARK: - 发送消息
    private func sendMsgClick() {
        let cvstionVC = CBPetFuncConversationVC.init()
        var petFriendMsgModel = CBPetFuncPetFriendsMsgModel()
        if let value = self.petFriendModel?.friendId {
            /* 申请好友*/
            petFriendMsgModel.id = value.valueStr
        } else {
            if let value = self.petFriendModel?.admin_Id {
                /* 附近的宠友传admin_Id*/
                petFriendMsgModel.id = value.valueStr
            } else {
                /* 好友*/
                if let value = self.petFriendModel?.id {
                    petFriendMsgModel.id = value.valueStr
                }
            }
        }
        let petUserInfoModel = self.petListModelObject?.allPet[0]
        if let value = petUserInfoModel?.user {
            petFriendMsgModel.name = value.name
            petFriendMsgModel.photo = value.photo
        }
        cvstionVC.petFriendMsgModel = petFriendMsgModel
        self.navigationController?.pushViewController(cvstionVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
