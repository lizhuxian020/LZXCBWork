//
//  CBPetLoginView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/18.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetLoginView: CBPetBaseView {
    private lazy var bgmView:UIView = {
        let bgmView = UIView.init()
        bgmView.backgroundColor = UIColor.white
        self.addSubview(bgmView)
        return bgmView
    }()
    public lazy var inputPhoneView:CBPetTFInputView = {
        let inputView = CBPetTFInputView.init()
        inputView.setInputView(title: "账号".localizedStr, placeholdStr: "请输入账号".localizedStr)
        inputView.textTF.addChangeTextTarget()
        inputView.textTF.maxTextNumber = 50
        self.bgmView.addSubview(inputView)
        return inputView
    }()
    private lazy var areaCodeBTF:UITextField = {
        let tf = UITextField(text: "", textColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, placeholder: "请输入国家码".localizedStr)
        tf.textAlignment = .right
        tf.keyboardType = .numberPad
        self.bgmView.addSubview(tf)
        return tf
    }()
    private lazy var inputPwdView:CBPetTFInputView = {
        let inputView = CBPetTFInputView.init()
        inputView.setInputView(title: "密码".localizedStr, placeholdStr: "请输入登录密码".localizedStr)
        inputView.textTF.maxTextNumber = 25
        //inputView.textTF.maxTextNumber = 3
        inputView.textTF.addChangeTextTarget()
        self.bgmView.addSubview(inputView)
        return inputView
    }()
    private lazy var showPwdBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "", titleColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, imageName: "pet_login_showPwd")
        btn.setImage(UIImage.init(named: "pet_login_hidePwd"), for: .selected)
        self.inputPwdView.addSubview(btn)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    private lazy var forgetPwdBtn:UIButton = {
        let btn = UIButton(title: "忘记密码?".localizedStr, titleColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!)
        self.bgmView.addSubview(btn)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    private lazy var loginBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "登录".localizedStr, titleColor: UIColor.white, font: UIFont.init(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!)
        btn.setShadow(backgroundColor: KPetAppColor, cornerRadius: 20*KFitHeightRate, shadowColor: KPetAppColor, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 0), shadowRadius: 8)
        self.bgmView.addSubview(btn)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    private lazy var verificationCodeLgoinBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "验证码登录".localizedStr, titleColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!, borderWidth: 0.5, borderColor: KPetAppColor, cornerRadius: 20*KFitHeightRate)
        btn.setTitle("登录密码登录".localizedStr, for: .selected)
        self.bgmView.addSubview(btn)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    private func setupView() {
        self.bgmView.snp_makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.bottom.equalTo(0)
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        self.inputPhoneView.snp_makeConstraints { (make) in
            make.left.equalTo(40*KFitWidthRate)
            make.right.equalTo((-40*KFitWidthRate))
            make.height.equalTo(50*KFitHeightRate)
            make.top.equalTo(self.bgmView.snp_top).offset(60*KFitHeightRate)
        }
        if CBPetLoginModelTool.getUser()?.email?.isValidateEmail() == true {
            self.inputPhoneView.textTF.text = CBPetLoginModelTool.getUser()?.email
        } else {
            self.inputPhoneView.textTF.text = ""
        }
        self.inputPwdView.snp_makeConstraints { (make) in
            make.left.equalTo(40*KFitWidthRate)
            make.right.equalTo((-40*KFitWidthRate))
            make.height.equalTo(50*KFitHeightRate)
            make.top.equalTo(self.inputPhoneView.snp_bottom).offset(24*KFitHeightRate)
        }
        self.showPwdBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self.inputPwdView.snp_right).offset(0)
            make.centerY.equalTo(self.inputPwdView.textTF.snp_centerY)
        }
        self.showPwdBtn.addTarget(self, action: #selector(hideOrShowPwdClick), for: .touchUpInside)
        self.forgetPwdBtn.snp_makeConstraints { (make) in
            make.left.equalTo(40*KFitWidthRate)
            make.height.equalTo(15*KFitHeightRate)
            make.top.equalTo(self.inputPwdView.snp_bottom).offset(12*KFitHeightRate)
        }
        self.forgetPwdBtn.addTarget(self, action: #selector(forgetPwdClick), for: .touchUpInside)
        self.loginBtn.snp_makeConstraints { (make) in
            make.left.equalTo(40*KFitWidthRate)
            make.right.equalTo((-40*KFitWidthRate))
            make.height.equalTo(40*KFitHeightRate)
            make.top.equalTo(self.forgetPwdBtn.snp_bottom).offset(44*KFitHeightRate)
        }
        
        self.loginBtn.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
//        self.verificationCodeLgoinBtn.snp_makeConstraints { (make) in
//            make.left.equalTo(40*KFitWidthRate)
//            make.right.equalTo((-40*KFitWidthRate))
//            make.height.equalTo(40*KFitHeightRate)
//            make.top.equalTo(self.loginBtn.snp_bottom).offset(24*KFitHeightRate)
//        }
//        self.verificationCodeLgoinBtn.addTarget(self, action: #selector(pwdOrVerificationLoginClick), for: .touchUpInside)
    }
    //MARK: - 忘记密码
    @objc func forgetPwdClick() {
        guard (self.viewModel as! CBPetLoginViewModel).forgetBlock == nil else {
            (self.viewModel as! CBPetLoginViewModel).forgetBlock!()
            return
        }
    }
    //MARK: - 是否隐藏密码
    @objc private func hideOrShowPwdClick(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        self.inputPwdView.textTF.isSecureTextEntry = sender.isSelected
    }
    //MARK: - 验证码、密码登录切换
    @objc private func pwdOrVerificationLoginClick(sender:CBPetBaseButton) {
        sender.isSelected = !sender.isSelected
        guard sender.isSelected else {
            // 密码登录界面
            self.inputPwdView.titleLb.text = "登录密码".localizedStr
            self.inputPwdView.textTF.placeholder = "请输入登录密码".localizedStr
            self.showPwdBtn.setImage(UIImage.init(named: "pet_login_showPwd"), for: .normal)
            self.showPwdBtn.setImage(UIImage.init(named: "pet_login_hidePwd"), for: .selected)
            self.showPwdBtn.setTitle("", for: .normal)
            return
        }
        // 验证码界面
        self.inputPwdView.titleLb.text = "手机验证码".localizedStr
        self.inputPwdView.textTF.placeholder = "请输入手机验证码".localizedStr
        self.showPwdBtn.setImage(UIImage.init(), for: .normal)
        self.showPwdBtn.setImage(UIImage.init(), for: .selected)
        self.showPwdBtn.setTitle("获取验证码".localizedStr, for: .normal)
    }
    //MARK: - 登录
    @objc private func loginClick(sender:CBPetBaseButton) {
        guard self.inputPhoneView.textTF.text!.isEmpty == false else {
            MBProgressHUD.showMessage(Msg: "请输入账号".localizedStr, Deleay: 1.5)
            return
        }
        guard self.inputPwdView.textTF.text!.isEmpty == false else {
            MBProgressHUD.showMessage(Msg: "请输入登录密码".localizedStr, Deleay: 1.5)
            return
        }
        guard (self.viewModel as! CBPetLoginViewModel).loginBlock == nil else {
            (self.viewModel as! CBPetLoginViewModel).loginBlock!(self.inputPhoneView.textTF.text!,self.inputPwdView.textTF.text!)
            return
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
