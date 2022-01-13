//
//  CBPetLoginRegisterMainView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/19.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetLoginRegisterMainView: CBPetBaseView {
    
    private lazy var imageViewBgm:UIImageView = {
        let bgmImgV = UIImageView()
        bgmImgV.image = UIImage.init(named: "pet_login_bgm")
        self.addSubview(bgmImgV)
        return bgmImgV
    }()
    private lazy var loginBtn:UIButton = {
        let btn = UIButton(title: "登录".localizedStr, titleColor: UIColor.white, font: UIFont.init(name: CBPingFang_SC_Bold, size: 24*KFitHeightRate)!, imageName: "pet_login_upArrow")
        self.addSubview(btn)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    private lazy var loginBtnClick:UIButton = {
        let btn = UIButton(title: "")
        self.addSubview(btn)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    private lazy var signUpBtn:UIButton = {
        let btn = UIButton(title: "注册".localizedStr, titleColor: UIColor.white, font: UIFont.init(name: CBPingFang_SC_Bold, size: 16*KFitHeightRate)!, imageName: "")
        self.addSubview(btn)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    private lazy var signUpBtnClick:UIButton = {
        let btn = UIButton(title: "")
        self.addSubview(btn)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    private lazy var loginView:CBPetLoginView = {
        let loginV = CBPetLoginView.init()
        loginV.backgroundColor = UIColor.white
        self.addSubview(loginV)
        return loginV
    }()
    private lazy var registerView:CBPetRegisterView = {
        let registerV = CBPetRegisterView.init()
        registerV.backgroundColor = UIColor.white
        registerV.isHidden = true
        self.addSubview(registerV)
        return registerV
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
        /* 判断传过来的viewModel类 是否 为 vc传过来的viewModel类*/
        if self.viewModel is CBPetLoginViewModel {
            self.loginView.setupViewModel(viewModel: self.viewModel)
            self.registerView.setupViewModel(viewModel: self.viewModel)
            ///注册成功后 切换至登录页面
            (self.viewModel as! CBPetLoginViewModel).registerUpdateViewBlock = { [weak self] (phone:String) -> Void in
                self?.switchClick(sender: self!.loginBtnClick)
                self?.loginView.inputPhoneView.textTF.text = phone
                /* 重置注册页面数据*/
                self?.registerView.inputPhoneView.textTF.text = ""
                self?.registerView.inputVerificationCodeView.textTF.text = ""
                self?.registerView.inputFirtPwdView.textTF.text = ""
                self?.registerView.inputSecondPwdView.textTF.text = ""
            }
        }
    }
    private func setupView() {
        self.imageViewBgm.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        }
        self.loginBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_top).offset(142*KFitHeightRate)
            make.right.equalTo(self.snp_centerX).offset(-45*KFitWidthRate)
            make.height.equalTo(50*KFitHeightRate)
        }
        self.loginBtn.layoutBtn(status: .CBVerticalCenterTitleAndImage, space: 4*KFitHeightRate)
        
        self.signUpBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.loginBtn.snp_centerY)
            make.left.equalTo(self.snp_centerX).offset(45*KFitWidthRate)
            make.height.equalTo(50*KFitHeightRate)
        }
        
        self.loginBtnClick.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_top).offset(142*KFitHeightRate)
            make.right.equalTo(self.snp_centerX).offset(-45*KFitWidthRate)
            make.size.equalTo(CGSize(width: 60*KFitWidthRate, height: 60*KFitHeightRate))
        }
        self.loginBtnClick.addTarget(self, action: #selector(switchClick), for: .touchUpInside)
        self.signUpBtnClick.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.loginBtn.snp_centerY)
            make.left.equalTo(self.snp_centerX).offset(45*KFitWidthRate)
            make.size.equalTo(CGSize(width: 60*KFitWidthRate, height: 60*KFitHeightRate))
        }
        self.signUpBtnClick.addTarget(self, action: #selector(switchClick), for: .touchUpInside)
        
        self.loginView.snp_makeConstraints { (make) in
            make.top.equalTo(self.loginBtn.snp_bottom).offset(-4*KFitHeightRate)
            make.left.right.bottom.equalTo(0)
        }
        self.registerView.snp_makeConstraints { (make) in
            make.top.equalTo(self.loginBtn.snp_bottom).offset(-4*KFitHeightRate)
            make.left.right.bottom.equalTo(0)
        }
    }
    
    @objc func switchClick(sender:UIButton) {
        if sender == self.loginBtnClick {
            self.loginBtn.setImage(UIImage.init(named: "pet_login_upArrow"), for: .normal)
            self.loginBtn.titleLabel?.font = UIFont.init(name: CBPingFang_SC_Bold, size: 24)
            self.loginBtn.snp_remakeConstraints { (make) in
                make.top.equalTo(self.snp_top).offset(142*KFitHeightRate)
                make.right.equalTo(self.snp_centerX).offset(-45*KFitWidthRate)
                make.height.equalTo(50*KFitHeightRate)
            }
            self.loginBtn.layoutBtn(status: .CBVerticalCenterTitleAndImage, space: 4*KFitHeightRate)
            
            self.signUpBtn.setImage(UIImage.init(), for: .normal)
            self.signUpBtn.titleLabel?.font = UIFont.init(name: CBPingFang_SC_Bold, size: 16)
            self.signUpBtn.snp_remakeConstraints { (make) in
                make.centerY.equalTo(self.loginBtn.snp_centerY)
                make.left.equalTo(self.snp_centerX).offset(45*KFitWidthRate)
                make.height.equalTo(50*KFitHeightRate)
            }
            
            self.loginView.isHidden = false
            self.registerView.isHidden = true
            
        } else if sender == self.signUpBtnClick {
            self.loginBtn.setImage(UIImage.init(), for: .normal)
            self.loginBtn.titleLabel?.font = UIFont.init(name: CBPingFang_SC_Bold, size: 16)
            self.loginBtn.snp_remakeConstraints { (make) in
                make.centerY.equalTo(self.signUpBtn.snp_centerY)
                make.right.equalTo(self.snp_centerX).offset(-45*KFitWidthRate)
                make.height.equalTo(50*KFitHeightRate)
            }
            self.signUpBtn.setImage(UIImage.init(named: "pet_login_upArrow"), for: .normal)
            self.signUpBtn.titleLabel?.font = UIFont.init(name: CBPingFang_SC_Bold, size: 24)
            self.signUpBtn.snp_remakeConstraints { (make) in
                make.top.equalTo(self.snp_top).offset(142*KFitHeightRate)
                make.left.equalTo(self.snp_centerX).offset(45*KFitWidthRate)
                make.height.equalTo(50*KFitHeightRate)
            }
            self.signUpBtn.layoutBtn(status: .CBVerticalCenterTitleAndImage, space: 4*KFitHeightRate)
            
            self.loginView.isHidden = true
            self.registerView.isHidden = false
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
