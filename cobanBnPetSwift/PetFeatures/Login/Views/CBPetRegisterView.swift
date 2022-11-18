//
//  CBPetRegisterView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/19.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetRegisterView: CBPetBaseView {
    
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
    lazy var phoneEmailView:CBPetLoginInputView = {
        let v = CBPetLoginInputView.init(isPwd: false, rightText: nil,clickBlk: nil)
        if isGoogle() {
            v.setInputView(placeholder: "请输入邮箱".localizedStr)
        } else {
            v.setInputView(placeholder: "请输入手机号码".localizedStr)
        }
        self.bgmView.addSubview(v)
        return v
    }()
    private lazy var smsView:CBPetLoginInputView = {
        let v = CBPetLoginInputView.init(isPwd: false, rightText: "获取验证码".localizedStr) {
            [weak self] in
            self?.getVerificationCodeClick()
//            self?.smsView.startCountDown()
        }
        v.setInputView(placeholder: "请输入验证码".localizedStr)
        self.bgmView.addSubview(v)
        return v
    }()
    lazy var firPwdView:CBPetLoginInputView = {
        let v = CBPetLoginInputView.init(isPwd: true, rightText: nil, clickBlk: nil)
        v.setInputView(placeholder: "请输入6-12位字符密码".localizedStr)
        self.bgmView.addSubview(v)
        return v
    }()
    lazy var secPwdView:CBPetLoginInputView = {
        let v = CBPetLoginInputView.init(isPwd: true, rightText: nil, clickBlk: nil)
        v.setInputView(placeholder: "请再次输入新密码".localizedStr)
        self.bgmView.addSubview(v)
        return v
    }()
//    public lazy var inputPhoneView:CBPetTFInputView = {
//        let inputView = CBPetTFInputView.init()
//        if isGoogle() {
//            inputView.setInputView(title: "邮箱".localizedStr, placeholdStr: "请输入邮箱".localizedStr)
//        } else {
//            inputView.setInputView(title: "手机号码".localizedStr, placeholdStr: "请输入手机号码".localizedStr)
//        }
//        //inputView.textTF.keyboardType = .numberPad
//        inputView.textTF.addChangeTextTarget()
//        inputView.textTF.maxTextNumber = 50
//        self.bgmView.addSubview(inputView)
//        return inputView
//    }()
//    private lazy var areaCodeBTF:UITextField = {
//        let tf = UITextField(text: "+86", textColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, placeholder: "请输入国家码".localizedStr)
//        tf.keyboardType = .numberPad
//        tf.textAlignment = .right
//        tf.addChangeTextTarget()
//        tf.maxTextNumber = 9
//        self.bgmView.addSubview(tf)
//        tf.isHidden = isGoogle()
//        return tf
//    }()
//    private lazy var inputImageView:CBPetTFInputView = {
//        let inputView = CBPetTFInputView.init()
//        inputView.setInputView(title: "图形验证码".localizedStr, placeholdStr: "请输入结果".localizedStr)
//        inputView.textTF.keyboardType = .numberPad
//        inputView.textTF.addChangeTextTarget()
//        inputView.textTF.maxTextNumber = 18
//        self.bgmView.addSubview(inputView)
//        return inputView
//    }()
//    private lazy var verifyImageView:UIImageView = {
//        let imageView = UIImageView.init()
//        imageView.isUserInteractionEnabled = true
//        self.bgmView.addSubview(imageView)
//        return imageView
//    }()
//    public lazy var inputVerificationCodeView:CBPetTFInputView = {
//        let inputView = CBPetTFInputView.init()
//        inputView.setInputView(title: "验证码".localizedStr, placeholdStr: "请输入验证码".localizedStr)
//        inputView.textTF.addChangeTextTarget()
//        inputView.textTF.maxTextNumber = 9
//        //inputView.textTF.keyboardType = .numberPad
//        self.bgmView.addSubview(inputView)
//        return inputView
//    }()
//    private lazy var getVerificationBtn:CBPetBaseButton = {
//        let btn = CBPetBaseButton(title: "获取验证码".localizedStr, titleColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
//        self.inputVerificationCodeView.addSubview(btn)
//        btn.adjustsImageWhenHighlighted = false
//        return btn
//    }()
//    private lazy var showFirstPwdBtn:CBPetBaseButton = {
//        let btn = CBPetBaseButton(title: "", titleColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, imageName: "pet_login_showPwd")
//        btn.setImage(UIImage.init(named: "pet_login_hidePwd"), for: .selected)
//        self.inputFirtPwdView.addSubview(btn)
//        btn.adjustsImageWhenHighlighted = false
//        return btn
//    }()
//    public lazy var inputFirtPwdView:CBPetTFInputView = {
//        let inputView = CBPetTFInputView.init()
//        inputView.setInputView(title: "新密码".localizedStr, placeholdStr: "请输入6-12位字符密码".localizedStr)
//        self.bgmView.addSubview(inputView)
//        return inputView
//    }()
//    private lazy var showSecondPwdBtn:CBPetBaseButton = {
//        let btn = CBPetBaseButton(title: "", titleColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, imageName: "pet_login_showPwd")
//        btn.setImage(UIImage.init(named: "pet_login_hidePwd"), for: .selected)
//        self.inputSecondPwdView.addSubview(btn)
//        btn.adjustsImageWhenHighlighted = false
//        return btn
//    }()
//    public lazy var inputSecondPwdView:CBPetTFInputView = {
//        let inputView = CBPetTFInputView.init()
//        inputView.setInputView(title: "新密码".localizedStr, placeholdStr: "请再次输入新密码".localizedStr)
//        self.bgmView.addSubview(inputView)
//        return inputView
//    }()
//    private lazy var inputNameView:CBPetTFInputView = {
//        let inputView = CBPetTFInputView.init()
//        inputView.setInputView(title: "姓名".localizedStr, placeholdStr: "请输入您的姓名".localizedStr)
//        self.bgmView.addSubview(inputView)
//        return inputView
//    }()
    private lazy var regiseterBtn:UIButton = {
        let btn = UIButton(title: "注册".localizedStr, titleColor: UIColor.white, font: kLoginBtnFont)
        btn.setShadow(backgroundColor: KPetAppColor, cornerRadius: 20*KFitHeightRate, shadowColor: KPetAppColor, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 0), shadowRadius: 8)
        self.bgmView.addSubview(btn)
        btn.adjustsImageWhenHighlighted = false
        return btn
        
    }()
    private lazy var pwdLoginBtn:UIButton = {
        let btn = UIButton(title: "密码登录".localizedStr, titleColor: UIColor.black, font: kLoginBtnFont)
        btn.setShadow(backgroundColor: UIColor.white, cornerRadius: 20*KFitHeightRate, shadowColor: KPetAppColor, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 0), shadowRadius: 8)
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
//    override func setupViewModel(viewModel: Any) {
//        self.viewModel = viewModel
//        if self.viewModel is CBPetLoginViewModel {
//            let vvModel = self.viewModel as! CBPetLoginViewModel
//            vvModel.petVerificateImageBlock = { [weak self] (objc:CBPetVerifyGraphicsModel) -> Void in
//                let imageStr = objc.image?.replacingOccurrences(of: "data:image/png;base64,", with: "")
//                let graphicsImage = CBPetUtils.getStrFromImage(imageStr ?? "")
//                //self?.verifyImageView.image = graphicsImage
//            }
//        }
//    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    }
//    @objc private func fingerTap(gestureRecognizer:UITapGestureRecognizer) {
//        if self.viewModel is CBPetLoginViewModel {
//            let vvModel = self.viewModel as! CBPetLoginViewModel
//            vvModel.getVerificationImage()
//        }
//    }
    private func setupView() {
        self.bgmView.snp_makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.bottom.equalTo(0)
        }
        self.titleLbl.snp_makeConstraints { make in
            make.left.equalTo(kLoginContentHorizontalMargin)
            make.top.equalTo(self.bgmView.snp_top).offset(kLoginTitleMarginTop)
        }
        
        self.appNameLbl.snp_makeConstraints { make in
            make.left.equalTo(kLoginContentHorizontalMargin)
            make.top.equalTo(self.titleLbl.snp_bottom).offset(kLoginAppNameMarginTop)
        }
        
        self.phoneEmailView.snp_makeConstraints { make in
            make.left.equalTo(kLoginContentHorizontalMargin)
            make.right.equalTo((-kLoginContentHorizontalMargin))
            make.top.equalTo(self.appNameLbl.snp_bottom).offset(kLoginInputAreaMarginTop)
        }
        
        self.smsView.snp_makeConstraints { make in
            make.left.equalTo(kLoginContentHorizontalMargin)
            make.right.equalTo((-kLoginContentHorizontalMargin))
            make.top.equalTo(self.phoneEmailView.snp_bottom).offset(kLoginInputSpaceBetween)
        }
        
        self.firPwdView.snp_makeConstraints { make in
            make.left.equalTo(kLoginContentHorizontalMargin)
            make.right.equalTo((-kLoginContentHorizontalMargin))
            make.top.equalTo(self.smsView.snp_bottom).offset(kLoginInputSpaceBetween)
        }
        
        self.secPwdView.snp_makeConstraints { make in
            make.left.equalTo(kLoginContentHorizontalMargin)
            make.right.equalTo((-kLoginContentHorizontalMargin))
            make.top.equalTo(self.firPwdView.snp_bottom).offset(kLoginInputSpaceBetween)
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
//        self.inputImageView.snp_makeConstraints { (make) in
//            make.left.equalTo(40*KFitWidthRate)
//            make.width.equalTo(SCREEN_WIDTH-80*KFitWidthRate)
//            //make.width.equalTo(SCREEN_WIDTH-80*KFitWidthRate-150*KFitWidthRate)
//            make.height.equalTo(50*KFitHeightRate)
//            make.top.equalTo(self.inputPhoneView.snp_bottom).offset(24*KFitHeightRate)
//        }
//        self.inputImageView.textTF.snp_updateConstraints { (make) in
//            make.left.equalTo(0)
//            make.right.equalTo(-150*KFitWidthRate)
//            make.top.equalTo(self.inputImageView.titleLb.snp_bottom).offset(0)
//            make.bottom.equalTo(0)
//        }
//
//        self.verifyImageView.snp_makeConstraints { (make) in
//            make.right.equalTo(self.inputPhoneView.snp_right).offset(0)
//            make.centerY.equalTo(self.inputImageView.snp_centerY)
//            make.size.equalTo(CGSize(width: 150*KFitWidthRate, height: 46*KFitHeightRate))
//        }
//        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(fingerTap))
//        self.verifyImageView.addGestureRecognizer(tapGesture)

//        self.inputVerificationCodeView.snp_makeConstraints { (make) in
//            make.left.equalTo(kLoginContentHorizontalMargin)
//            make.right.equalTo((-kLoginContentHorizontalMargin))
//            make.height.equalTo(50*KFitHeightRate)
//            make.top.equalTo(self.inputPhoneView.snp_bottom).offset(kLoginInputSpaceBetween)
//        }
//        self.getVerificationBtn.snp_makeConstraints { (make) in
//            make.right.equalTo(self.inputVerificationCodeView.snp_right).offset(0)
//            make.centerY.equalTo(self.inputVerificationCodeView.textTF.snp_centerY)
//        }
//        self.getVerificationBtn.addTarget(self, action: #selector(getVerificationCodeClick), for: .touchUpInside)
//        self.inputFirtPwdView.snp_makeConstraints { (make) in
//            make.left.equalTo(kLoginContentHorizontalMargin)
//            make.right.equalTo((-kLoginContentHorizontalMargin))
//            make.height.equalTo(50*KFitHeightRate)
//            make.top.equalTo(self.inputVerificationCodeView.snp_bottom).offset(kLoginInputSpaceBetween)
//        }
//        self.showFirstPwdBtn.snp_makeConstraints { (make) in
//            make.right.equalTo(self.inputFirtPwdView.snp_right).offset(0)
//            make.centerY.equalTo(self.inputFirtPwdView.textTF.snp_centerY)
//        }
//        self.showFirstPwdBtn.addTarget(self, action: #selector(hideOrShowPwdClick), for: .touchUpInside)
//
//        self.inputSecondPwdView.snp_makeConstraints { (make) in
//            make.left.equalTo(kLoginContentHorizontalMargin)
//            make.right.equalTo((-kLoginContentHorizontalMargin))
//            make.height.equalTo(50*KFitHeightRate)
//            make.top.equalTo(self.inputFirtPwdView.snp_bottom).offset(kLoginInputSpaceBetween)
//        }
//        self.showSecondPwdBtn.snp_makeConstraints { (make) in
//            make.right.equalTo(self.inputSecondPwdView.snp_right).offset(0)
//            make.centerY.equalTo(self.inputSecondPwdView.textTF.snp_centerY)
//        }
//        self.showSecondPwdBtn.addTarget(self, action: #selector(hideOrShowPwdClick), for: .touchUpInside)

//        self.inputNameView.snp_makeConstraints { (make) in
//            make.left.equalTo(40*KFitWidthRate)
//            make.width.equalTo(SCREEN_WIDTH-80*KFitWidthRate)
//            //make.height.equalTo(50*KFitHeightRate)
//            make.height.equalTo(0*KFitHeightRate)
//            make.top.equalTo(self.inputSecondPwdView.snp_bottom).offset(24*KFitHeightRate)
//        }
//        self.inputNameView.lineView.isHidden = true
        self.regiseterBtn.snp_makeConstraints { (make) in
            make.left.equalTo(kLoginContentHorizontalMargin)
            make.right.equalTo((-kLoginContentHorizontalMargin))
            make.height.equalTo(40*KFitHeightRate)
            make.top.equalTo(self.secPwdView.snp_bottom).offset(kLoginBtnAreaMarginTop)
//            make.bottom.equalTo(self.bgmView.snp_bottom).offset(-80*KFitHeightRate)
        }
        self.regiseterBtn.addTarget(self, action: #selector(regiseterClick), for: .touchUpInside)

        self.pwdLoginBtn.snp_makeConstraints { make in
            make.left.equalTo(kLoginContentHorizontalMargin)
            make.right.equalTo((-kLoginContentHorizontalMargin))
            make.height.equalTo(40*KFitHeightRate)
            make.top.equalTo(self.regiseterBtn.snp_bottom).offset(kLoginBtnSpaceBetween)
        }
        self.pwdLoginBtn.addTarget(self, action: #selector(pwdLoginClick), for: .touchUpInside)
    }
//    //MARK: - 是否隐藏密码
//    @objc private func hideOrShowPwdClick(sender:CBPetBaseButton) {
//        if sender == self.showFirstPwdBtn {
//            self.showFirstPwdBtn.isSelected = !self.showFirstPwdBtn.isSelected
//            self.inputFirtPwdView.textTF.isSecureTextEntry = sender.isSelected
//        } else if sender == self.showSecondPwdBtn {
//            self.showSecondPwdBtn.isSelected = !self.showSecondPwdBtn.isSelected
//            self.inputSecondPwdView.textTF.isSecureTextEntry = sender.isSelected
//        }
//    }
    //MARK: - 获取验证码
    @objc private func getVerificationCodeClick() {
        if isGoogle() {
            if self.phoneEmailView.textTF.text?.isValidateEmail() == false {
                MBProgressHUD.showMessage(Msg: "请输入邮箱".localizedStr, Deleay: 1.5)
                return
            }
        } else {
            if self.phoneEmailView.textTF.text?.isValidatePhoneNumber() == false {
                MBProgressHUD.showMessage(Msg: "请输入手机号码".localizedStr, Deleay: 1.5)
                return
            }
        }
        if self.viewModel is CBPetLoginViewModel {
            let vvModel = self.viewModel as! CBPetLoginViewModel
            guard vvModel.getVerificationCodeBlock == nil else {
                vvModel.getVerificationCodeBlock!(
                    self.smsView ,
                    self.phoneEmailView.textTF.text!,
                    ""//目前国内不填也能收到，其他用邮箱(isGoogle() ? "" : self.areaCodeBTF.text!)
                )//self.areaCodeBTF.text!
//                vvModel.getVerificationCodeUpdateViewBlock = { [weak self] (coutDown:Int,isFinished:Bool) -> Void in
//                    if isFinished == true {
//                        self!.getVerificationBtn.setTitle("获取验证码".localizedStr, for: .normal)
//                        /* 放开按钮点击权限，可以再次点击*/
//                        self!.getVerificationBtn.isEnabled = true
//                        self!.getVerificationBtn.setTitleColor(KPetAppColor, for: .normal)
//                        self!.getVerificationBtn.setTitleColor(KPetAppColor, for: .highlighted)
//                        self!.getVerificationBtn.layer.borderColor = KPetAppColor.cgColor
//                    } else {
//                        self!.getVerificationBtn.setTitle("\("Retry in".localizedStr)\(coutDown)s\("后重试".localizedStr)", for: .normal)
//                        self!.getVerificationBtn.setTitleColor(RGB(r: 196, g: 196, b: 196), for: .normal)
//                        self!.getVerificationBtn.layer.borderColor = RGB(r: 196, g: 196, b: 196).cgColor
//                    }
//                }
                return
            }
        }
    }
    //MARK: - 注册
    @objc private func regiseterClick() {
        guard self.phoneEmailView.textTF.text!.isEmpty == false else {
            if isGoogle() {
                MBProgressHUD.showMessage(Msg: "请输入邮箱".localizedStr, Deleay: 1.5)
            } else {
                MBProgressHUD.showMessage(Msg: "请输入手机号码".localizedStr, Deleay: 1.5)
            }
            return
        }
        guard self.smsView.textTF.text!.isEmpty == false else {
            MBProgressHUD.showMessage(Msg: "请输入验证码".localizedStr, Deleay: 1.5)
            return
        }
        guard self.firPwdView.textTF.text!.isEmpty == false else {
            MBProgressHUD.showMessage(Msg: "请输入6-12位字符密码".localizedStr, Deleay: 1.5)
            return
        }
        guard self.firPwdView.textTF.text!.isValidateAlphaNumberPwd() == true else {
            MBProgressHUD.showMessage(Msg: "请输入6-12位字符密码".localizedStr, Deleay: 1.5)
            return
        }
        guard self.secPwdView.textTF.text!.isEmpty == false else {
            MBProgressHUD.showMessage(Msg: "请再次输入新密码".localizedStr, Deleay: 1.5)
            return
        }
        guard (self.secPwdView.textTF.text! == self.firPwdView.textTF.text!) == true else {
            MBProgressHUD.showMessage(Msg: "两次输入的密码不同".localizedStr, Deleay: 1.5)
            return
        }
        guard self.secPwdView.textTF.text!.isValidateAlphaNumberPwd() == true else {
            MBProgressHUD.showMessage(Msg: "请输入6-12位字符密码".localizedStr, Deleay: 1.5)
            return
        }
        guard (self.viewModel as! CBPetLoginViewModel).registerBlock == nil else {
            (self.viewModel as! CBPetLoginViewModel).registerBlock!(self.phoneEmailView.textTF.text!,self.smsView.textTF.text!,self.firPwdView.textTF.text!,"")
            return
        }
    }
    //MARK: - 展示登录页
    @objc private func pwdLoginClick() {
        guard let viewModel = self.viewModel as? CBPetLoginViewModel,
              let showLoginBlk = viewModel.showLoginBlock else {return}
        showLoginBlk();
    }
//    /* 检查输入的图形验证码的有效性*/
//    private func verifyGraphic() {
//        if self.viewModel is CBPetLoginViewModel {
//            let vvModel = self.viewModel as! CBPetLoginViewModel
//            guard self.inputImageView.textTF.text!.count > 0 else {
//                MBProgressHUD.showMessage(Msg: "请输入图形验证码".localizedStr, Deleay: 1.5)
//                return
//            }
//
//            guard vvModel.graphicsModel?.numericalValue == self.inputImageView.textTF.text else {
//                MBProgressHUD.showMessage(Msg: "请输入正确的图形验证码".localizedStr, Deleay: 1.5)
//                return
//            }
//
//            guard vvModel.isValid == true else {
//                MBProgressHUD.showMessage(Msg: "图形验证码已过期".localizedStr, Deleay: 1.5)
//                return
//            }
//        }
//    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
