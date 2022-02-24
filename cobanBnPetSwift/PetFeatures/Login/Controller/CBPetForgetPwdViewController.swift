//
//  CBPetForgetPwdViewController.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/3/18.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetForgetPwdViewController: CBPetBaseViewController {
    
    private func isGoogle() -> Bool {
        return AppDelegate.isShowGoogle()
    }

    public lazy var forgetPwdViewModel:CBPetLoginViewModel = {
        let viewMd = CBPetLoginViewModel.init()
        return viewMd
    }()
    private lazy var inputPhoneView:CBPetTFInputView = {
        let inputView = CBPetTFInputView.init()
        if isGoogle() {
            inputView.setInputView(title: "邮箱".localizedStr, placeholdStr: "请输入邮箱".localizedStr)
        } else {
            inputView.setInputView(title: "手机号码".localizedStr, placeholdStr: "请输入手机号码".localizedStr)
        }
        inputView.textTF.addChangeTextTarget()
        inputView.textTF.maxTextNumber = 50
        self.view.addSubview(inputView)
        return inputView
    }()
    private lazy var areaCodeBTF:UITextField = {
        let tf = UITextField(text: "+86", textColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, placeholder: "请输入国家码".localizedStr)
        tf.keyboardType = .numberPad
        tf.textAlignment = .right
        tf.addChangeTextTarget()
        tf.maxTextNumber = 9
        self.view.addSubview(tf)
        tf.isHidden = isGoogle()
        return tf
    }()

    private lazy var inputVerificationCodeView:CBPetTFInputView = {
        let inputView = CBPetTFInputView.init()
        inputView.setInputView(title: "验证码".localizedStr, placeholdStr: "请输入验证码".localizedStr)
        //inputView.textTF.keyboardType = .numberPad
        inputView.textTF.addChangeTextTarget()
        inputView.textTF.maxTextNumber = 9
        self.view.addSubview(inputView)
        return inputView
    }()
    private lazy var getVerificationBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "获取验证码".localizedStr, titleColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        self.inputVerificationCodeView.addSubview(btn)
        return btn
    }()
    private lazy var inputFirtPwdView:CBPetTFInputView = {
        let inputView = CBPetTFInputView.init()
        inputView.setInputView(title: "新密码".localizedStr, placeholdStr: "请输入6-12位字符密码".localizedStr)
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
        inputView.setInputView(title: "新密码".localizedStr, placeholdStr: "请再次输入新密码".localizedStr)
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
    lazy var comfirmBtn:UIButton = {
        let btn = UIButton(title: "确定".localizedStr, titleColor: UIColor.white, font: UIFont(name: CBPingFangSC_Regular, size: 15*KFitHeightRate)!, backgroundColor: kBlueColor, cornerRadius: 5)
        self.view.addSubview(btn)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        
        self.forgetPwdViewModel.getVerificationImage()
        self.forgetPwdViewModel.petVerificateImageBlock = { [weak self] (objc:CBPetVerifyGraphicsModel) -> Void in
            let imageStr = objc.image?.replacingOccurrences(of: "data:image/png;base64,", with: "")
            let graphicsImage = CBPetUtils.getStrFromImage(imageStr ?? "")
            //self?.verifyImageView.image = graphicsImage
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        
        switch self.forgetPwdViewModel.updPwdType {
        case .forget:
            self.initBarWith(title: "忘记密码".localizedStr, isBack: true)
            break
        case .modify:
            //self.initBarWith(title: "修改密码".localizedStr, isBack: true)
            break
        default:
            break
        }
        self.initBarRight(title: "确定".localizedStr, action: #selector(retsetPwdRequestClick))
        self.rightBtn.setTitleColor(KPetAppColor, for: .normal)
        self.rightBtn.setTitleColor(KPetAppColor, for: .highlighted)
        self.rightBtn.titleLabel?.font = UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)
        
        self.inputPhoneView.snp_makeConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo((-20*KFitWidthRate))
            make.height.equalTo(50*KFitHeightRate)
            make.top.equalTo(self.view.snp_top).offset(CGFloat(20*KFitHeightRate) + NavigationBarHeigt)
        }
        self.areaCodeBTF.snp_makeConstraints { (make) in
            make.right.equalTo(self.inputPhoneView.snp_right).offset(0)
            make.centerY.equalTo(self.inputPhoneView.textTF.snp_centerY)
        }
        
        self.inputVerificationCodeView.snp_makeConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo((-20*KFitWidthRate))
            make.height.equalTo(50*KFitHeightRate)
            make.top.equalTo(self.inputPhoneView.snp_bottom).offset(24*KFitHeightRate)
        }
        self.getVerificationBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self.inputVerificationCodeView.snp_right).offset(0)
            make.centerY.equalTo(self.inputVerificationCodeView.textTF.snp_centerY)
        }
        self.getVerificationBtn.addTarget(self, action: #selector(getVerificationCodeClick), for: .touchUpInside)
        self.counDownBlock = { [weak self] (coutDown:Int,isFinished:Bool) -> Void in
            if isFinished == true {
                self!.getVerificationBtn.setTitle("获取验证码".localizedStr, for: .normal)
                /* 放开按钮点击权限，可以再次点击*/
                self!.getVerificationBtn.isEnabled = true
                self!.getVerificationBtn.setTitleColor(KPetAppColor, for: .normal)
                self!.getVerificationBtn.setTitleColor(KPetAppColor, for: .highlighted)
                self!.getVerificationBtn.layer.borderColor = KPetAppColor.cgColor
            } else {
                self!.getVerificationBtn.setTitle("\("Retry in".localizedStr)\(coutDown)s\("后重试".localizedStr)", for: .normal)
                self!.getVerificationBtn.setTitleColor(RGB(r: 196, g: 196, b: 196), for: .normal)
                self!.getVerificationBtn.layer.borderColor = RGB(r: 196, g: 196, b: 196).cgColor
            }
        }
        self.inputFirtPwdView.snp_makeConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo((-20*KFitWidthRate))
            make.height.equalTo(50*KFitHeightRate)
            make.top.equalTo(self.inputVerificationCodeView.snp_bottom).offset(24*KFitHeightRate)
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
    @objc private func fingerTap(gestureRecognizer:UITapGestureRecognizer) {
        self.forgetPwdViewModel.getVerificationImage()
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
    //MARK: - 忘记密码获取验证码
    @objc private func getVerificationCodeClick(sender:UIButton) {
        if isGoogle() {
            if self.inputPhoneView.textTF.text?.isValidateEmail() == false {
                MBProgressHUD.showMessage(Msg: "请输入邮箱".localizedStr, Deleay: 1.5)
                return
            }
        } else {
            if self.inputPhoneView.textTF.text?.isValidatePhoneNumber() == false {
                MBProgressHUD.showMessage(Msg: "请输入手机号码".localizedStr, Deleay: 1.5)
                return
            }
        }
//        guard self.inputPhoneView.textTF.text!.isEmpty == false else {
//            MBProgressHUD.showMessage(Msg: "请输入手机号/邮箱".localizedStr, Deleay: 1.5)
//            return
//        }
        //self.startCountDownMethod(sender: self.getVerificationBtn)
        //return
//        if self.inputPhoneView.textTF.text?.isValidateEmail() == true {
        if isGoogle() {
            CBPetNetworkingManager.share.getEmailCode(Email: self.inputPhoneView.textTF.text!, Type: "2") { [weak self] (successModel) in
                if let value = self?.view {
                    MBProgressHUD.hide(for: value, animated: true)
                }
                /* 返回错误信息*/
                guard successModel.status == "0" else {
                    MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                    return;
                }
                MBProgressHUD.showMessage(Msg: "发送成功".localizedStr, Deleay: 1.5)
                self!.startCountDownMethod(sender: self!.getVerificationBtn)
            } failureBlock: { [weak self] (failureModel) in
                if let value = self?.view {
                    MBProgressHUD.hide(for: value, animated: true)
                }
            }
        } else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            var areaCode = self.areaCodeBTF.text!;
            if areaCode.hasPrefix("+") {
                areaCode = areaCode.subString(from: 1)
            }
            CBPetNetworkingManager.share.getVerificationCode(Phone: self.inputPhoneView.textTF.text!, Type: "2",areaCode: areaCode, successBlock: { [weak self] (successModel) in
                if let value = self?.view {
                    MBProgressHUD.hide(for: value, animated: true)
                }
                /* 返回错误信息*/
                guard successModel.status == "0" else {
                    MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                    return;
                }
                MBProgressHUD.showMessage(Msg: "发送成功".localizedStr, Deleay: 1.5)
                self!.startCountDownMethod(sender: self!.getVerificationBtn)
            }) { [weak self] (failureModel) in
                if let value = self?.view {
                    MBProgressHUD.hide(for: value, animated: true)
                }
            }
        }
    }
    //MARK: - 确定重置密码
    @objc private func retsetPwdRequestClick() {
        guard self.inputPhoneView.textTF.text!.isEmpty == false else {
            if isGoogle() {
                MBProgressHUD.showMessage(Msg: "请输入邮箱".localizedStr, Deleay: 1.5)
            } else {
                MBProgressHUD.showMessage(Msg: "请输入手机号码".localizedStr, Deleay: 1.5)
            }
            return
        }
        guard self.inputVerificationCodeView.textTF.text!.count > 0 else {
            MBProgressHUD.showMessage(Msg: "请输入验证码".localizedStr, Deleay: 1.5)
            return
        }
        guard self.inputFirtPwdView.textTF.text!.isEmpty == false else {
            MBProgressHUD.showMessage(Msg: "请输入6-12位字符密码".localizedStr, Deleay: 1.5)
            return
        }
        guard self.inputFirtPwdView.textTF.text!.isValidateAlphaNumberPwd() == true else {
            MBProgressHUD.showMessage(Msg: "请输入6-12位字符密码".localizedStr, Deleay: 1.5)
            return
        }
        guard self.inputSecondPwdView.textTF.text!.isEmpty == false else {
            MBProgressHUD.showMessage(Msg: "请再次输入新密码".localizedStr, Deleay: 1.5)
            return
        }
        guard (self.inputSecondPwdView.textTF.text! == self.inputFirtPwdView.textTF.text!) == true else {
            MBProgressHUD.showMessage(Msg: "两次输入的密码不同".localizedStr, Deleay: 1.5)
            return
        }
        guard self.inputSecondPwdView.textTF.text!.isValidateAlphaNumberPwd() == true else {
            MBProgressHUD.showMessage(Msg: "请输入6-12位字符密码".localizedStr, Deleay: 1.5)
            return
        }
        switch self.forgetPwdViewModel.updPwdType {
        case .forget:
            self.retsetPwdRequest()
            break
        case .modify:
            //self.updPwdRequest()
            break
        default:
            break
        }
    }
    //MARK: - 重置密码request
    private func retsetPwdRequest() {
        var newCode = self.areaCodeBTF.text!
        if newCode.hasPrefix("+") {
            newCode = newCode.subString(from: 1)
        }
        let paramters:[String:String] = ["account":self.inputPhoneView.textTF.text!,"pwd":CBPetUtils.md5(Str: self.inputFirtPwdView.textTF.text!),"code":self.inputVerificationCodeView.textTF.text!,"crCode":isGoogle() ? "" : newCode]
        CBPetNetworkingManager.share.resetPwdRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            /* 返回错误信息*/
            guard successModel.status == "0" else {
                switch successModel.status {
                case "103","104":
                    MBProgressHUD.showMessage(Msg: "验证码错误".localizedStr, Deleay: 2.0)
                    break
                default:
                    MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                }
                return
            }
            MBProgressHUD.showMessage(Msg: "重置成功".localizedStr, Deleay: 1.5)
            self!.navigationController?.popViewController(animated: true)
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
        }
    }
//    //MARK: - 修改密码request
//    private func updPwdRequest() {
//        let paramters:[String:String] = ["npwd":CBPetUtils.md5(Str: self.inputFirtPwdView.textTF.text!),"opwd":CBPetUtils.md5(Str: self.inputSecondPwdView.textTF.text!)]
//        CBPetNetworkingManager.share.updPwdRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
//            if let value = self?.view {
//                MBProgressHUD.hide(for: value, animated: true)
//            }
//            /* 返回错误信息*/
//            guard successModel.status == "0" else {
//                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
//                return;
//            }
//            MBProgressHUD.showMessage(Msg: "修改成功", Deleay: 1.5)
//            self!.navigationController?.popViewController(animated: true)
//        }) { [weak self] (failureModel) in
//            if let value = self?.view {
//                MBProgressHUD.hide(for: value, animated: true)
//            }
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
