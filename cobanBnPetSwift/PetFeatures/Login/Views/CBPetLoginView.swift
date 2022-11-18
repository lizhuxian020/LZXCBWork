//
//  CBPetLoginView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/18.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetLoginView: CBPetBaseView {
    
    private func isGoogle() -> Bool {
        return AppDelegate.isShowGoogle()
    }
    
    private lazy var bgmView:UIView = {
        let bgmView = UIView.init()
        bgmView.backgroundColor = UIColor.clear
        self.addSubview(bgmView)
        return bgmView
    }()
    private lazy var titleLbl:UILabel = {
        let lbl = UILabel(text: "欢迎登录".localizedStr, textColor: UIColor.white, font: kLoginTitleFont)
        self.bgmView.addSubview(lbl)
        return lbl
    }()
    private lazy var appNameLbl:UILabel = {
        let lbl = UILabel(text: "巴诺物联网".localizedStr, textColor: KPetAppColor, font: kLoginAppNameFont)
        self.bgmView.addSubview(lbl)
        return lbl
    }()
//    public lazy var inputPhoneView:CBPetTFInputView = {
//        let inputView = CBPetTFInputView.init()
//        if isGoogle() {
//            inputView.setInputView(title: "邮箱".localizedStr, placeholdStr: "请输入邮箱".localizedStr)
//        } else {
//            inputView.setInputView(title: "手机号码".localizedStr, placeholdStr: "请输入手机号码".localizedStr)
//        }
//        inputView.textTF.addChangeTextTarget()
//        inputView.textTF.maxTextNumber = 50
//        self.bgmView.addSubview(inputView)
//        return inputView
//    }()
//    private lazy var areaCodeBTF:UITextField = {
//        let tf = UITextField(text: "+86", textColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, placeholder: "请输入国家码".localizedStr)
//        tf.textAlignment = .right
//        tf.keyboardType = .numberPad
//        self.bgmView.addSubview(tf)
//        tf.isHidden = isGoogle()
//        return tf
//    }()
//    private lazy var inputPwdView:CBPetTFInputView = {
//        let inputView = CBPetTFInputView.init()
//        inputView.setInputView(title: "密码".localizedStr, placeholdStr: "请输入登录密码".localizedStr)
//        inputView.textTF.maxTextNumber = 25
//        //inputView.textTF.maxTextNumber = 3
//        inputView.textTF.addChangeTextTarget()
//        self.bgmView.addSubview(inputView)
//        return inputView
//    }()
//    private lazy var showPwdBtn:CBPetBaseButton = {
//        let btn = CBPetBaseButton(title: "", titleColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, imageName: "pet_login_showPwd")
//        btn.setImage(UIImage.init(named: "pet_login_hidePwd"), for: .selected)
//        self.inputPwdView.addSubview(btn)
//        btn.adjustsImageWhenHighlighted = false
//        return btn
//    }()
    lazy var phoneEmailView:CBPetLoginInputView = {
        let v = CBPetLoginInputView.init(isPwd: false, rightText: nil,clickBlk: nil)
        if isGoogle() {
            v.setInputView(placeholder: "请输入邮箱".localizedStr)
        } else {
            v.setInputView(placeholder: "请输入手机号码".localizedStr)
        }
        v.textTF.keyboardType = .emailAddress;
        self.bgmView.addSubview(v)
        return v
    }()
    lazy var pwdView:CBPetLoginInputView = {
        let v = CBPetLoginInputView.init(isPwd: true, rightText: "忘记密码".localizedStr) {
            [weak self] in
            self?.forgetPwdClick()
        }
        v.setInputView(placeholder: "请输入登录密码".localizedStr)
        self.bgmView.addSubview(v)
        return v
    }()
//    private lazy var smsView:CBPetInputClaerView = {
//        let v = CBPetInputClaerView.init(rightText: "获取验证码".localizedStr) {
//            [weak self] in
//            print("clickSMS")
//            self?.smsView.startCountDown()
//        }
//        v.setInputView(placeholder: "请输入验证码".localizedStr)
//        self.bgmView.addSubview(v)
//        return v
//    }()
//    private lazy var pwdBtnView:CBPetInputClaerView = {
//        let v = CBPetInputClaerView.init(isPwd: true)
//        v.setInputView(placeholder: "请输入登录密码".localizedStr)
//        self.bgmView.addSubview(v)
//        return v
//    }()
//    private lazy var forgetPwdBtn:UIButton = {
//        let btn = UIButton(title: "忘记密码?".localizedStr, titleColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!)
//        self.bgmView.addSubview(btn)
//        btn.adjustsImageWhenHighlighted = false
//        return btn
//    }()
    private lazy var loginBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "登录".localizedStr, titleColor: UIColor.white, font: kLoginBtnFont)
        btn.setShadow(backgroundColor: KPetAppColor, cornerRadius: 20*KFitHeightRate, shadowColor: KPetAppColor, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 0), shadowRadius: 8)
        self.bgmView.addSubview(btn)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    private lazy var registerBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "注册".localizedStr, titleColor: UIColor.black, font: kLoginBtnFont)
        btn.setShadow(backgroundColor: UIColor.white, cornerRadius: 20*KFitHeightRate, shadowColor: KPetAppColor, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 0), shadowRadius: 8)
        self.bgmView.addSubview(btn)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
//    private lazy var verificationCodeLgoinBtn:CBPetBaseButton = {
//        let btn = CBPetBaseButton(title: "验证码登录".localizedStr, titleColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!, borderWidth: 0.5, borderColor: KPetAppColor, cornerRadius: 20*KFitHeightRate)
//        btn.setTitle("登录密码登录".localizedStr, for: .selected)
//        self.bgmView.addSubview(btn)
//        btn.adjustsImageWhenHighlighted = false
//        return btn
//    }()
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
    private func setupView() {
        self.bgmView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        self.titleLbl.snp_makeConstraints { make in
            make.left.equalTo(kLoginContentHorizontalMargin)
            make.top.equalTo(self.bgmView.snp_top).offset(kLoginTitleMarginTop)
        }
        
        self.appNameLbl.snp_makeConstraints { make in
            make.left.equalTo(kLoginContentHorizontalMargin)
            make.top.equalTo(self.titleLbl.snp_bottom).offset(kLoginAppNameMarginTop)
        }
        
//        self.inputPhoneView.snp_makeConstraints { (make) in
//            make.left.equalTo(kLoginContentHorizontalMargin)
//            make.right.equalTo((-kLoginContentHorizontalMargin))
//            make.height.equalTo(50*KFitHeightRate)
//            make.top.equalTo(self.appNameLbl.snp_bottom).offset(kLoginInputAreaMarginTop)
//        }
//        self.areaCodeBTF.snp_makeConstraints { (make) in
//            make.right.equalTo(self.inputPhoneView.snp_right).offset(0)
//            make.centerY.equalTo(self.inputPhoneView.textTF.snp_centerY)
//        }
//        self.inputPwdView.snp_makeConstraints { (make) in
//            make.left.equalTo(kLoginContentHorizontalMargin)
//            make.right.equalTo((-kLoginContentHorizontalMargin))
//            make.height.equalTo(50*KFitHeightRate)
//            make.top.equalTo(self.inputPhoneView.snp_bottom).offset(kLoginInputSpaceBetween)
//        }
//        self.showPwdBtn.snp_makeConstraints { (make) in
//            make.right.equalTo(self.inputPwdView.snp_right).offset(0)
//            make.centerY.equalTo(self.inputPwdView.textTF.snp_centerY)
//        }
//        self.showPwdBtn.addTarget(self, action: #selector(hideOrShowPwdClick), for: .touchUpInside)
//        self.forgetPwdBtn.snp_makeConstraints { (make) in
//            make.left.equalTo(40*KFitWidthRate)
//            make.height.equalTo(15*KFitHeightRate)
//            make.top.equalTo(self.inputPwdView.snp_bottom).offset(12*KFitHeightRate)
//        }
//        self.forgetPwdBtn.addTarget(self, action: #selector(forgetPwdClick), for: .touchUpInside)
        
        
        self.phoneEmailView.snp_makeConstraints { make in
            make.left.equalTo(kLoginContentHorizontalMargin)
            make.right.equalTo((-kLoginContentHorizontalMargin))
            make.top.equalTo(self.appNameLbl.snp_bottom).offset(kLoginInputAreaMarginTop)
        }
        
        self.pwdView.snp_makeConstraints { make in
            make.left.equalTo(kLoginContentHorizontalMargin)
            make.right.equalTo((-kLoginContentHorizontalMargin))
            make.top.equalTo(self.phoneEmailView.snp_bottom).offset(kLoginInputSpaceBetween)
        }
        
//        self.smsView.snp_makeConstraints { make in
//            make.left.equalTo(kLoginContentHorizontalMargin)
//            make.right.equalTo((-kLoginContentHorizontalMargin))
//            make.top.equalTo(self.pwdView.snp_bottom).offset(kLoginInputSpaceBetween)
//        }
//
//        self.pwdBtnView.snp_makeConstraints { make in
//            make.left.equalTo(kLoginContentHorizontalMargin)
//            make.right.equalTo((-kLoginContentHorizontalMargin))
//            make.top.equalTo(self.smsView.snp_bottom).offset(kLoginInputSpaceBetween)
//        }
        
        self.loginBtn.snp_makeConstraints { (make) in
            make.left.equalTo(kLoginContentHorizontalMargin)
            make.right.equalTo((-kLoginContentHorizontalMargin))
            make.height.equalTo(40*KFitHeightRate)
            make.top.equalTo(self.pwdView.snp_bottom).offset(kLoginBtnAreaMarginTop)
        }
        
        self.loginBtn.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
        
        self.registerBtn.snp_makeConstraints { make in
            make.left.equalTo(kLoginContentHorizontalMargin)
            make.right.equalTo((-kLoginContentHorizontalMargin))
            make.height.equalTo(40*KFitHeightRate)
            make.top.equalTo(self.loginBtn.snp_bottom).offset(kLoginBtnSpaceBetween)
        }
        self.registerBtn.addTarget(self, action: #selector(registerClick), for: .touchUpInside)
//        self.verificationCodeLgoinBtn.snp_makeConstraints { (make) in
//            make.left.equalTo(40*KFitWidthRate)
//            make.right.equalTo((-40*KFitWidthRate))
//            make.height.equalTo(40*KFitHeightRate)
//            make.top.equalTo(self.loginBtn.snp_bottom).offset(24*KFitHeightRate)
//        }
//        self.verificationCodeLgoinBtn.addTarget(self, action: #selector(pwdOrVerificationLoginClick), for: .touchUpInside)
        
        if let user = CBPetLoginModelTool.getUser() {
            self.phoneEmailView.textTF.text =
            user.phone != nil && user.phone!.isValidatePhoneNumber() ? user.phone :
            user.email != nil && user.email!.isValidateEmail() ? user.email : ""
        }
    }
    //MARK: - 忘记密码
    @objc func forgetPwdClick() {
        guard (self.viewModel as! CBPetLoginViewModel).forgetBlock == nil else {
            (self.viewModel as! CBPetLoginViewModel).forgetBlock!()
            return
        }
    }
//    //MARK: - 是否隐藏密码
//    @objc private func hideOrShowPwdClick(sender:UIButton) {
//        sender.isSelected = !sender.isSelected
//        self.inputPwdView.textTF.isSecureTextEntry = sender.isSelected
//    }
//    //MARK: - 验证码、密码登录切换
//    @objc private func pwdOrVerificationLoginClick(sender:CBPetBaseButton) {
//        sender.isSelected = !sender.isSelected
//        guard sender.isSelected else {
//            // 密码登录界面
//            self.inputPwdView.titleLb.text = "登录密码".localizedStr
//            self.inputPwdView.textTF.placeholder = "请输入登录密码".localizedStr
//            self.showPwdBtn.setImage(UIImage.init(named: "pet_login_showPwd"), for: .normal)
//            self.showPwdBtn.setImage(UIImage.init(named: "pet_login_hidePwd"), for: .selected)
//            self.showPwdBtn.setTitle("", for: .normal)
//            return
//        }
//        // 验证码界面
//        self.inputPwdView.titleLb.text = "手机验证码".localizedStr
//        self.inputPwdView.textTF.placeholder = "请输入手机验证码".localizedStr
//        self.showPwdBtn.setImage(UIImage.init(), for: .normal)
//        self.showPwdBtn.setImage(UIImage.init(), for: .selected)
//        self.showPwdBtn.setTitle("获取验证码".localizedStr, for: .normal)
//    }
    //MARK: - 登录
    @objc private func loginClick(sender:CBPetBaseButton) {
        guard self.phoneEmailView.textTF.text!.isEmpty == false else {
            MBProgressHUD.showMessage(Msg: "请输入账号".localizedStr, Deleay: 1.5)
            return
        }
        guard self.pwdView.textTF.text!.isEmpty == false else {
            MBProgressHUD.showMessage(Msg: "请输入登录密码".localizedStr, Deleay: 1.5)
            return
        }
        guard (self.viewModel as! CBPetLoginViewModel).loginBlock == nil else {
            (self.viewModel as! CBPetLoginViewModel).loginBlock!(self.phoneEmailView.textTF.text!,self.pwdView.textTF.text!)
            return
        }
        
    }
    
    //MARK: - 注册页面
    @objc private func registerClick(sender:CBPetBaseButton) {
        guard let viewModel = self.viewModel as? CBPetLoginViewModel,
              let registerBlock = viewModel.showResgiterBlock else {
                  return;
              }
        registerBlock();
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
