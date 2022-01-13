//
//  CBPetScanInputVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/25.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON

class CBPetScanInputVC: CBPetBaseViewController {

    private lazy var inputDeviceNumberTf:UITextField = {
        let inputTf = UITextField(textColor: KPetTextColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, placeholder: "请输入设备绑定号".localizedStr, placeholderColor: KPetPlaceholdColor, placeholderFont: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        inputTf.keyboardType = UIKeyboardType.numberPad
        self.view.addSubview(inputTf)
        return inputTf
    }()
    var imeiStr:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
    }
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        self.initBarWith(title: "输入绑定号".localizedStr, isBack: true)
        
        let titleLb = UILabel(text: "绑定号是15位 数字的IMEI号，请滑动设备屏幕查看".localizedStr, textColor: KPetTextColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, textAlignment: .center)
        self.view.addSubview(titleLb)
        titleLb.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.equalTo(SCREEN_WIDTH-30*KFitWidthRate)
            make.top.equalTo(40*KFitHeightRate + CGFloat(NavigationBarHeigt))
        }
        
        let noteLb = UILabel(text: "绑定号".localizedStr, textColor: KPetTextColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        self.view.addSubview(noteLb)
        noteLb.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(20*KFitWidthRate)
            make.top.equalTo(titleLb.snp_bottom).offset(64*KFitHeightRate)
            make.height.equalTo(15*KFitHeightRate)
        }
        
        self.inputDeviceNumberTf.snp_makeConstraints { (make) in
            make.centerY.equalTo(noteLb.snp_centerY)
            make.left.equalTo(noteLb.snp_right).offset(30*KFitWidthRate)
            make.width.equalTo(SCREEN_WIDTH - 150*KFitWidthRate)
        }
        
        let line = CBPetUtilsCreate.createLineView()
        line.backgroundColor = KPetLineColor
        self.view.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.top.equalTo(noteLb.snp_bottom).offset(20*KFitHeightRate)
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo(-20*KFitWidthRate)
            make.height.equalTo(1)
        }
        
        let bindBtn = UIButton(title: "绑定".localizedStr, titleColor: UIColor.white, font: UIFont.init(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!)
        bindBtn.setShadow(backgroundColor: KPetAppColor,cornerRadius: 20*KFitHeightRate, shadowColor: KPetAppColor, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 0), shadowRadius: 8)
        self.view.addSubview(bindBtn)
        bindBtn.snp_makeConstraints { (make) in
            make.height.equalTo(40*KFitHeightRate)
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo(-20*KFitWidthRate)
            make.top.equalTo(line.snp_bottom).offset(40*KFitHeightRate)
        }
        bindBtn.addTarget(self, action: #selector(bindClick), for: .touchUpInside)
    }
    @objc private func bindClick() {
        guard self.inputDeviceNumberTf.text?.isEmpty == false else {
            MBProgressHUD.showMessage(Msg: "请输入设备绑定号".localizedStr, Deleay: 1.5)
            return
        }
        self.valudateIMEIRequest(scannedStr: self.inputDeviceNumberTf.text!)
    }
    //MARK: - 验证IMEI合法性
    private func valudateIMEIRequest(scannedStr:String) {
        guard scannedStr.isEmpty == false else {
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let paramters:Dictionary<String, Any> = ["imei":scannedStr]
        CBPetNetworkingManager.share.valudateIMEIRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
            let imeiJson = JSON.init(successModel.data as Any)
            guard imeiJson.dictionaryValue.count == 0 else {
                self?.bindDeviceByValudateIMEI(imeiStr: scannedStr)
                return
            }
            MBProgressHUD.showMessage(Msg: "设备绑定号码不存在".localizedStr, Deleay: 1.5)
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
        }
    }
    //MARK: - 绑定设备
    private func bindDeviceByValudateIMEI(imeiStr:String) {
        guard imeiStr.isEmpty == false else {
            return
        }
        var paramters:Dictionary<String, Any> = Dictionary()
        paramters["imei"] = imeiStr.valueStr
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["adminId"] = value.valueStr
        }
        ///绑定类型（0：普通绑定 1：管理员添加的方式直接绑定）
        paramters["bindType"] = "0"
        CBPetNetworkingManager.share.bindDeviceByValudateIMEIRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let scanModel = CBPetScanResultModel.deserialize(from: ddJson.dictionaryObject)
            /* 设备第一次被绑定，提示去编辑宠物寂寥*/
            if scanModel?.isAdmin == "1" {
                self?.bindSuccess(imeiStr:scanModel?.imei ?? "",petId:scanModel?.petId ?? "")
            } else if scanModel?.isAdmin == "0" {
                self?.navigationController?.popToRootViewController(animated: true)
            } else {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
        }
    }
    //MARK: - 绑定成功页面
    private func bindSuccess(imeiStr:String,petId:String) {
        let bindSuccessVC = CBPetBindSuccessVC.init()
        bindSuccessVC.imeiStr = imeiStr
        bindSuccessVC.petId = petId
        self.navigationController?.pushViewController(bindSuccessVC, animated: true)
        return
//        self.navigationController?.popViewController(animated: true)
//        if self.viewModel is CBPetHomeViewModel {
//            let model = self.viewModel as! CBPetHomeViewModel
//            guard model.bindDeviceUpdateDataBlock == nil else {
//                model.bindDeviceUpdateDataBlock!()
//                return
//            }
//        }
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
