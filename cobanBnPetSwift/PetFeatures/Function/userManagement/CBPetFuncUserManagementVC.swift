//
//  CBPetFuncUserManagementVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/27.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetFuncUserManagementVC: CBPetBaseViewController {
    
    public var homeViewModel : CBPetHomeViewModel?
    
    private lazy var userManageViewModel:CBPetUserManageViewModel = {
        let vv = CBPetUserManageViewModel.init()
        return vv
    }()
    
    private lazy var manageView:CBPetFuncUserManageView = {
        let vv = CBPetFuncUserManageView.init()
        return vv
    }()
    override func noNetworkNotification(notifi: Notification) {
        super.noNetworkNotification(notifi: notifi)
        self.view.bringSubviewToFront(self.noNetworkView)
        self.noNetworkView.isHidden = !(self.networkResult ?? true)
        self.noNetworkView.reloadBlock = { [weak self] () -> Void in
            CBLog(message: "重新加载")
            self!.getPetManagerListRequest()
            self?.getDeviceParamtersRequest()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPetManagerListRequest()
        self.getDeviceParamtersRequest()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* view的 y 从 导航栏以下算起*/
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.setupView()
        
    }
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        initBarWith(title: "用户管理设备".localizedStr, isBack: true)
        self.view.addSubview(self.manageView)
        self.manageView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        self.manageView.setupViewModel(viewModel: self.userManageViewModel)
        self.setupVM()
        self.userManageViewModel.MJHeaderRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.getPetManagerListRequest()
            self?.getDeviceParamtersRequest()
        }
        self.userManageViewModel.MJFooterRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.getPetManagerListRequest()
            self?.getDeviceParamtersRequest()
        }
        /*  解绑 */
        self.userManageViewModel.userManageDeleteUserManageBlock = { [weak self] (model:CBPetUserManageModel) in
            self?.unBindDeviceRqeust(model: model)
        }
        self.userManageViewModel.pushBlock = { [weak self] (objc:Any) in
            
            var petInfoModel = CBPetPsnalCterPetModel.init()
            petInfoModel.imei = CBPetHomeInfoTool.getHomeInfo().devUser.imei ?? ""
            
            let petInfoVC = CBPetPsnalCterEditPetInfoVC.init()
            petInfoVC.psnalCterViewModel.petInfoModel = petInfoModel
            
            self?.navigationController?.pushViewController(petInfoVC, animated: true)
        }
    }
    private func setupVM() {
        self.userManageViewModel.didClickTimezone = {[weak self] in
            let selectTimeZVC = CBPetSelectTimeZViewController.init()
            selectTimeZVC.homeViewModel = (self?.homeViewModel)!
            self?.navigationController?.pushViewController(selectTimeZVC, animated: true)
        }
        self.userManageViewModel.didClickLossSwitch = {[weak self] (isOn : Bool)->Void in
            self?.homeViewModel?.setCallPosiActionStatusCommandRequest(status: isOn ? "1" : "0", {[weak self] in
                self?.getDeviceParamtersRequest()
            })
        }
        self.userManageViewModel.didClickTimeReportSwitch = {[weak self] (isOn : Bool)->Void in
            self?.homeViewModel?.setTimeReportStatusCommandRequest(status: isOn ? "1" : "0") {[weak self] in
                self?.getDeviceParamtersRequest()
            }
        }
        self.userManageViewModel.didClickTimeReport = {[weak self] in
            let timeReportVC = CBPetSetTimeReportViewController.init()
            self?.navigationController?.pushViewController(timeReportVC, animated: true)
        }
    }
    @objc private func addUserManageClick() {
        let addVC = CBPetFuncAddUserManageVC.init()
        addVC.updateBlock = { [weak self] () -> Void in
            self?.getPetManagerListRequest()
        }
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    //MARK: - 获取宠物设备管理员列表
    private func getPetManagerListRequest() {
        let imeiStr = CBPetHomeInfoTool.getHomeInfo().pet.device.imei
        let paramters:Dictionary<String,Any> = ["imei":imeiStr ?? ""]
        CBPetNetworkingManager.share.getDeviceManagerListRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            self?.manageView.endRefresh()
            //返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let messageListModelObject = JSONDeserializer<CBPetUserManageModel>.deserializeModelArrayFrom(array: ddJson.arrayObject)
            guard self?.userManageViewModel.userManageUpdateListDataBlock == nil else {
                self?.userManageViewModel.userManageUpdateListDataBlock!(messageListModelObject! as! [CBPetUserManageModel])
                return
            }
        }) { [weak self] (failureModel) in
            self?.manageView.endRefresh()
        }
    }
    
    //MARK: - 根据设备编号获取设备设置的参数request
    private func getDeviceParamtersRequest() {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        CBPetNetworkingManager.share.getParamtersByIMEIRequest(paramters: paramters,successBlock: { [weak self] (successModel) in
            let ddJson = JSON.init(successModel.data as Any)
            let paramtersModel = CBPetHomeParamtersModel.deserialize(from: ddJson.dictionaryObject)
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
            if let blk = self?.userManageViewModel.userMangerUpdateParamModelBlock,
                paramtersModel != nil {
               blk(paramtersModel!)
            }
        }, failureBlock: { (failureModel) in
        })
    }
    //MARK: - 解绑
    private func unBindDeviceRqeust(model:CBPetUserManageModel) {
        var paramters:Dictionary<String,Any> = ["imei":"","userId":""]
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters.updateValue(value.valueStr, forKey: "imei")
        }
        if let value = model.user.id {
            paramters.updateValue(value.valueStr, forKey: "userId")
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.unbindDeviceRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
            self?.getPetManagerListRequest()
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
        }
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
