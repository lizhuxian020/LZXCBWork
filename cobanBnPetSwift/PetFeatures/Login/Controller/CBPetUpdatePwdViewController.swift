//
//  CBPetUpdatePwdViewController.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/7/22.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetUpdatePwdViewController: CBPetBaseViewController {

    private lazy var inputFirtPwdView:CBPetTFInputView = {
        let inputView = CBPetTFInputView.init()
        inputView.setInputView(title: "旧密码".localizedStr, placeholdStr: "请输入您的旧密码".localizedStr)
        self.view.addSubview(inputView)
        return inputView
    }()
    private lazy var showFirstPwdBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "", titleColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, imageName: "pet_login_showPwd")
        btn.setImage(UIImage.init(named: "pet_login_hidePwd"), for: .selected)
        self.inputFirtPwdView.addSubview(btn)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    private lazy var inputSecondPwdView:CBPetTFInputView = {
        let inputView = CBPetTFInputView.init()
        inputView.setInputView(title: "新密码".localizedStr, placeholdStr: "请输入您的新密码".localizedStr)
        self.view.addSubview(inputView)
        return inputView
    }()
    private lazy var showSecondPwdBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "", titleColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, imageName: "pet_login_showPwd")
        btn.setImage(UIImage.init(named: "pet_login_hidePwd"), for: .selected)
        self.inputSecondPwdView.addSubview(btn)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
    }
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        
        self.initBarWith(title: "修改密码".localizedStr, isBack: true)
        self.initBarRight(title: "确定".localizedStr, action: #selector(retsetPwdRequestClick))
        self.rightBtn.setTitleColor(KPetAppColor, for: .normal)
        self.rightBtn.setTitleColor(KPetAppColor, for: .highlighted)
        self.rightBtn.titleLabel?.font = UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)
        
        self.inputFirtPwdView.snp_makeConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo((-20*KFitWidthRate))
            make.height.equalTo(50*KFitHeightRate)
            make.top.equalTo(self.view.snp_top).offset(CGFloat(20*KFitHeightRate) + NavigationBarHeigt)
        }
        self.showFirstPwdBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self.inputFirtPwdView.snp_right).offset(0)
            make.centerY.equalTo(self.inputFirtPwdView.textTF.snp_centerY)
        }
        self.showFirstPwdBtn.addTarget(self, action: #selector(hideOrShowPwdClick), for: .touchUpInside)
        self.inputSecondPwdView.snp_makeConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo((-20*KFitWidthRate))
            make.height.equalTo(50*KFitHeightRate)
            make.top.equalTo(self.inputFirtPwdView.snp_bottom).offset(24*KFitHeightRate)
        }
        self.showSecondPwdBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self.inputSecondPwdView.snp_right).offset(0)
            make.centerY.equalTo(self.inputSecondPwdView.textTF.snp_centerY)
        }
        self.showSecondPwdBtn.addTarget(self, action: #selector(hideOrShowPwdClick), for: .touchUpInside)
    }
    //MARK: - 是否隐藏密码
    @objc private func hideOrShowPwdClick(sender:CBPetBaseButton) {
        if sender == self.showFirstPwdBtn {
            self.showFirstPwdBtn.isSelected = !self.showFirstPwdBtn.isSelected
            self.inputFirtPwdView.textTF.isSecureTextEntry = sender.isSelected
        } else if sender == self.showSecondPwdBtn {
            self.showSecondPwdBtn.isSelected = !self.showSecondPwdBtn.isSelected
            self.inputSecondPwdView.textTF.isSecureTextEntry = sender.isSelected
        }
    }
    //MARK: - 确定修改密码
    @objc private func retsetPwdRequestClick() {
        guard self.inputFirtPwdView.textTF.text!.isEmpty == false else {
            MBProgressHUD.showMessage(Msg: "请输入您的旧密码".localizedStr, Deleay: 1.5)
            return
        }
        guard self.inputSecondPwdView.textTF.text!.isEmpty == false else {
            MBProgressHUD.showMessage(Msg: "请输入您的新密码".localizedStr, Deleay: 1.5)
            return
        }
        self.updPwdRequest()
    }
    //MARK: - 修改密码request
    private func updPwdRequest() {
        let paramters:[String:String] = ["opwd":CBPetUtils.md5(Str: self.inputFirtPwdView.textTF.text!),"npwd":CBPetUtils.md5(Str: self.inputSecondPwdView.textTF.text!)]
        CBPetNetworkingManager.share.updPwdRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            /* 返回错误信息*/
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
            self?.logoutActionCleanUserData()
            MBProgressHUD.showMessage(Msg: "修改成功".localizedStr, Deleay: 1.5)
            self!.navigationController?.popViewController(animated: true)
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
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
