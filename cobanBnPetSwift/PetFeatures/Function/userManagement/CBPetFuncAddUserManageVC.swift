//
//  CBPetFuncAddUserManageVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/31.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetFuncAddUserManageVC: CBPetBaseViewController {

    private lazy var inputPhoneView:CBPetTFInputView = {
        let inputView = CBPetTFInputView.init()
        inputView.setInputView(title: "".localizedStr, placeholdStr: "请输入手机号码/邮箱".localizedStr)
//        inputView.textTF.keyboardType = .numberPad
        self.view.addSubview(inputView)
        return inputView
    }()
    private lazy var areaCodeBTF:UITextField = {
        let tf = UITextField(text: "+86", textColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, placeholder: "请输入国家码".localizedStr)
        tf.textAlignment = .right
        tf.keyboardType = .numberPad
        self.view.addSubview(tf)
        return tf
    }()
    var updateBlock:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /* view的 y 从 导航栏以下算起*/
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.setupView()
    }
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        initBarWith(title: "添加用户管理设备".localizedStr, isBack: true)
        initBarRight(title: "确定".localizedStr, action: #selector(commfirmClick))
        self.rightBtn.setTitleColor(KPetAppColor, for: .normal)
        self.rightBtn.setTitleColor(KPetAppColor, for: .highlighted)
        self.rightBtn.titleLabel?.font = UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)
        
        self.view.addSubview(self.inputPhoneView)
//        self.view.addSubview(self.areaCodeBTF)
        self.inputPhoneView.snp_makeConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo((-20*KFitWidthRate))
            make.height.equalTo(53*KFitHeightRate)
            make.top.equalTo(self.view.snp_top).offset(0*KFitHeightRate)
        }
//        self.areaCodeBTF.snp_makeConstraints { (make) in
//            make.right.equalTo(self.inputPhoneView.snp_right).offset(0)
//            make.centerY.equalTo(self.inputPhoneView.textTF.snp_centerY)
//        }
    }
    @objc private func commfirmClick() {
        guard self.inputPhoneView.textTF.text?.isEmpty == false else {
            MBProgressHUD.showMessage(Msg: "请输入手机号码/邮箱".localizedStr, Deleay: 1.5)
            return
        }
        self.findUserInfoByPhoeRequet()
    }
    //MARK: - 根据用户手机号码获取用户信息
    private func findUserInfoByPhoeRequet() {
        var paramters:Dictionary<String,Any> = Dictionary()
        paramters["phone"] = self.inputPhoneView.textTF.text
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.findUserInfoByPhoneRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            //返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let usreInfoModelObject = JSONDeserializer<CBPetUserInfoModel>.deserializeFrom(dict: ddJson.dictionaryObject)
            if let value = usreInfoModelObject {
                self?.bindDeviceRequet(adminId: value.id?.valueStr ?? "")
            } else {
                MBProgressHUD.showMessage(Msg: "该手机号码没有注册".localizedStr, Deleay: 1.5)
            }
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
        }
    }
    //MARK: - 绑定设备
    private func bindDeviceRequet(adminId:String) {
        var paramters:Dictionary<String, Any> = Dictionary()
        paramters["adminId"] = adminId
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        ///绑定类型（0：普通绑定 1：管理员添加的方式直接绑定）
        paramters["bindType"] = "1"
        CBPetNetworkingManager.share.bindDeviceByValudateIMEIRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            //返回错误信息
            guard successModel.status == "0" else {
                if successModel.rescode == "0030" {
                    MBProgressHUD.showMessage(Msg: "您已经绑定了这个设备".localizedStr, Deleay: 2.0)
                    return
                }
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            if self?.updateBlock != nil {
                self!.updateBlock!()
            }
            self?.navigationController?.popViewController(animated: true)
        }) { (failureModel) in
        }
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
