//
//  CBPetPersonalCenterVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/3.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON


class CBPetPersonalCenterVC: CBPetBaseViewController {

    private lazy var psnalCterViewModel:CBPetPsnalCterViewModel = {
        let viewModel = CBPetPsnalCterViewModel()
        return viewModel
    }()
    private lazy var personalCenterView:CBPetPersonalCenterView = {
        let view = CBPetPersonalCenterView.init()//init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllDeviceRequest()
        /* 获取用户信息*/
        getUserInfoRequest()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
    }
    private func setupView() {
        
        self.view.backgroundColor = UIColor.red
        initBarWith(title: "".localizedStr, isBack: true)
        self.view.addSubview(self.personalCenterView)
        self.personalCenterView.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        self.personalCenterView.setupViewModel(viewModel: self.psnalCterViewModel)
        self.psnalCterViewModel.psnlCterClickBlock = { [weak self] (type:CBPetPsnalCterClickType,objc:Any) -> Void in
            switch type {
            case .psnaInfo:
                self?.toPsnalPageClick()
                break
            case .editPet:
                if objc is CBPetPsnalCterPetModel {
                    if (objc as! CBPetPsnalCterPetModel).title == "添加".localizedStr {
                        /* 添加宠物*/
                        self!.scanAddPet()
                    } else {
                        /* 编辑宠物资料*/
                        self?.toEditPetInfoClick(model:objc)
                    }
                }
                break
            case .switchSystem:
                self?.switchSystem()
                break
            case .switchNotice:
                self?.switchNotice(appPush: objc as! String)
                break
            case .modifyPwd:
                self?.modifyPwd()
                break
            case .cleanCache:
                self?.cleanCache()
                break
            case .aboutUs:
                self?.aboutUs()
                break
            case .logout:
                self?.logoutction()
                break
            }
        }
        
    }
    //MARK: - 获取当前用户的宠物列表
    private func getAllDeviceRequest() {
        var paramters:Dictionary<String,Any> = ["uid":""]
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters.updateValue(NSNumber.init(value: Int(value.valueStr) ?? 0), forKey: "uid")
        }
        CBPetNetworkingManager.share.getAllDeviceRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            MBProgressHUD.hide(for: self?.view ?? UIView.init(), animated: true)
            /* 返回错误信息*/
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let petListModelObject = JSONDeserializer<CBPetPsnalCterPetAllModel>.deserializeFrom(dict: ddJson.dictionaryObject)
            guard self?.psnalCterViewModel.psnlUpdateDataBlock == nil else {
                if let value = petListModelObject?.allPet {
                    self?.psnalCterViewModel.psnlUpdateDataBlock!(.petList,value)
                }
                return
            }
        }) { (failureModel) in
        }
    }
    //MARK: - 获取用户信息
    private func getUserInfoRequest() {
        let userInfoModelObject = CBPetUserInfoModelTool.getUserInfo() 
        if self.psnalCterViewModel.psnlUpdateDataBlock != nil {
            self.psnalCterViewModel.psnlUpdateDataBlock!(.userInfo,userInfoModelObject)
        }
        self.personalCenterView.updateUserInfo()
    }
    //MARK: - 个人主页
    private func toPsnalPageClick() {
        let psnalPageVC = CBPetPersonalPageVC.init()
        psnalPageVC.viewModel.isComfromPsnalCter = true
        self.navigationController?.pushViewController(psnalPageVC, animated: true)
    }
    //MARK: - 编辑宠物资料
    private func toEditPetInfoClick(model:Any) {
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
            CBLog(message: "绑定设备 绑定设备 绑定设备 绑定设备 绑定设备")
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
    //MARK: - 系统切换
    private func switchSystem() {
        let switchSystem = CBPetSwitchSystemVC.init()
        switchSystem.isSwitchSystem = true
        self.navigationController?.pushViewController(switchSystem, animated: true)
    }
    //MARK: - 信息通知
    private func switchNotice(appPush:String) {

        UserDefaults.standard.set(appPush, forKey: "appPush")
        
//        var userInfoModel = CBPetUserInfoModelTool.getUserInfo()
//        userInfoModel.appPush_local = appPush
//        CBPetUserInfoModelTool.saveUserInfo(userInfoModel: userInfoModel)
        
        //self.personalCenterView.updateUserInfo()
        
//        var paramters:Dictionary<String,Any> = Dictionary()
//        if let value = CBPetLoginModelTool.getUser()?.uid {
//            paramters = ["uid":value.valueStr]
//        }
//        paramters["appPush"] = NSNumber.init(value: Int(appPush) ?? 2020)//appPush
//        CBPetNetworkingManager.share.updateUserInfoRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
//            ///返回错误信息
//            guard successModel.status == "0" else {
//                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
//                //self?.personalCenterView.updateUserInfo()
//                return;
//            }
//            //self?.personalCenterView.updateUserInfo()
//        }) { (failureModel) in in
//
//        }
    }
    //MARK: - 修改密码
    private func modifyPwd() {
        let updPwdVC = CBPetUpdatePwdViewController.init()
        self.navigationController?.pushViewController(updPwdVC, animated: true)
    }
    //MARK: - 清除缓存
    private func cleanCache() {
        CBPetUtils.clearCache()
        MBProgressHUD.showMessage(Msg: "清除成功".localizedStr, Deleay: 1.5)
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute:{
            ///延时操作才能加载出来，相当于网络请求
            self.personalCenterView.updateUserInfo()
        })
    }
    //MARK: - 关于我们
    private func aboutUs() {
        let aboutUs = CBPetAboutUsViewController.init()
        self.navigationController?.pushViewController(aboutUs, animated: true)
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
