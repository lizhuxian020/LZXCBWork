//
//  CBPetPsnalCterEditContactVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/20.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetPsnalCterEditContactVC: CBPetBaseViewController {

    public lazy var psnalCterViewModel:CBPetPsnalCterViewModel = {
        let viewModel = CBPetPsnalCterViewModel()
        return viewModel
    }()
    public var editReturnBlock:(() -> Void)?
    
    private lazy var inputNumView:CBPetTFInputView = {
        let inputView = CBPetTFInputView.init()
        inputView.setInputView(title: "".localizedStr, placeholdStr: "请输入手机号码".localizedStr)
        self.view.addSubview(inputView)
        return inputView
    }()
    private lazy var areaCodeBTF:UITextField = {
        let tf = UITextField(text: "", textColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, placeholder: "请输入国家码".localizedStr)
        tf.keyboardType = .numberPad
        tf.textAlignment = .right
        tf.addChangeTextTarget()
        tf.maxTextNumber = 9
        self.inputNumView.addSubview(tf)
        return tf
    }()
    private lazy var inputCodeView:CBPetTFInputView = {
        let inputView = CBPetTFInputView.init()
        inputView.setInputView(title: "".localizedStr, placeholdStr: "请输入验证码".localizedStr)
        self.view.addSubview(inputView)
        return inputView
    }()
    private lazy var getVerificationBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "获取验证码".localizedStr, titleColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        self.inputCodeView.addSubview(btn)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    private lazy var isPublishSiwtch:UISwitch = {
        let noticSwi = UISwitch.init()
        noticSwi.isOn = true
        //noticSwi.isHidden = true
        return noticSwi
    }()
    private lazy var noteLb:UILabel = {
        let lb = UILabel(text: "点击公开后，别人可在您的主页看到您的电话".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 10*KFitHeightRate)!, textAlignment: .left)
        return lb
    }()
    var paramters:Dictionary<String,Any> = Dictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* view的 y 从 导航栏以下算起*/
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.setupView()
        switch self.psnalCterViewModel.psnalInfoModel!.title {
            case "电话".localizedStr:
                //paramters["isPublishPhone"] = self.psnalCterViewModel.psnalInfoModel?.isPublish ?? "0"
                self.updateContactLayout()
                self.inputNumView.textTF.placeholder = "请输入电话号".localizedStr
                self.noteLb.text = "点击公开后，别人可在您的主页看到您的电话".localizedStr
                paramters["isPublishPhone"] = self.psnalCterViewModel.psnalInfoModel?.isPublishPhone ?? "0"
                break
            case "微信".localizedStr:
                self.updateContactLayout()
                self.inputNumView.textTF.placeholder = "请输入微信号".localizedStr
                self.noteLb.text = "点击公开后，别人可在您的主页看到您的微信".localizedStr
                paramters["isPublishWeixin"] = self.psnalCterViewModel.psnalInfoModel?.isPublish ?? "0"
                break
            case "邮箱".localizedStr:
                self.updateContactLayout()
                self.inputNumView.textTF.placeholder = "请输入邮箱".localizedStr
                self.noteLb.text = "点击公开后，别人可在您的主页看到您的邮箱".localizedStr
                paramters["isPublishEmail"] = self.psnalCterViewModel.psnalInfoModel?.isPublish ?? "0"
                break
            case "WhatsApp".localizedStr:
                self.updateContactLayout()
                self.inputNumView.textTF.placeholder = "请输入WhatsApp".localizedStr
                self.noteLb.text = "点击公开后，别人可在您的主页看到您的WhatsApp".localizedStr
                paramters["isPublishWhatsapp"] = self.psnalCterViewModel.psnalInfoModel?.isPublish ?? "0"
                break
            default:
                break
        }
        self.inputNumView.textTF.text = self.psnalCterViewModel.psnalInfoModel!.text
        self.isPublishSiwtch.isOn = self.psnalCterViewModel.psnalInfoModel?.isPublish == "0" ? false : self.psnalCterViewModel.psnalInfoModel?.isPublish == "1" ? true : false
    }
    private func updateContactLayout() {
        self.areaCodeBTF.isHidden = true
        self.inputCodeView.snp_updateConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo((-20*KFitWidthRate))
            make.height.equalTo(0*KFitHeightRate)
            make.top.equalTo(self.inputNumView.snp_bottom).offset(0*KFitHeightRate)
        }
        self.getVerificationBtn.isHidden = true
    }
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        initBarWith(title: self.psnalCterViewModel.psnalInfoModel!.title ?? "", isBack: true)
        initBarRight(title: "确定".localizedStr, action: #selector(commfirmClick))
        self.rightBtn.setTitleColor(KPetAppColor, for: .normal)
        self.rightBtn.setTitleColor(KPetAppColor, for: .highlighted)
        self.rightBtn.titleLabel?.font = UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)
        
        self.view.addSubview(self.inputNumView)
        self.inputNumView.snp_makeConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo((-20*KFitWidthRate))
            make.height.equalTo(53*KFitHeightRate)
            make.top.equalTo(self.view.snp_top).offset(0*KFitHeightRate)
        }
        self.inputNumView.textTF.clearButtonMode = .whileEditing
        
        self.areaCodeBTF.snp_makeConstraints { (make) in
            make.right.equalTo(self.inputNumView.snp_right).offset(0)
            make.centerY.equalTo(self.inputNumView.textTF.snp_centerY)
        }
        
        self.view.addSubview(self.inputCodeView)
        self.inputCodeView.snp_makeConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo((-20*KFitWidthRate))
            make.height.equalTo(53*KFitHeightRate)
            make.top.equalTo(self.inputNumView.snp_bottom).offset(0*KFitHeightRate)
        }
        
        self.getVerificationBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self.inputCodeView.snp_right).offset(0)
            make.centerY.equalTo(self.inputCodeView.textTF.snp_centerY)
        }
        self.getVerificationBtn.addTarget(self, action: #selector(getVerificationCodeClick), for: .touchUpInside)
        
        self.view.addSubview(self.isPublishSiwtch)
        self.isPublishSiwtch.snp_makeConstraints { (make) in
            make.right.equalTo((-20*KFitWidthRate))
            make.top.equalTo(self.inputCodeView.snp_bottom).offset(15*KFitHeightRate)
        }
        self.isPublishSiwtch.addTarget(self, action: #selector(noticeSwitchClick), for: .valueChanged)
        
        let remindLb = UILabel(text: "是否公开".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, textAlignment: .left)
        self.view.addSubview(remindLb)
        remindLb.snp_makeConstraints { (make) in
            make.left.equalTo((20*KFitWidthRate))
            make.centerY.equalTo(self.isPublishSiwtch)
        }
        
        let line = CBPetUtilsCreate.createLineView()
        line.backgroundColor = KPetLineColor
        self.view.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.top.equalTo(self.isPublishSiwtch.snp_bottom).offset(15*KFitHeightRate)
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo(-20*KFitWidthRate)
            make.height.equalTo(1*KFitHeightRate)
        }
        
        let noteImage = UIImage(named: "pet_psnal_note")!
        let noteImageView = UIImageView.init()
        noteImageView.image = noteImage
        self.view.addSubview(noteImageView)
        noteImageView.snp_makeConstraints { (make) in
            make.top.equalTo(line.snp_bottom).offset(13*KFitHeightRate)
            make.left.equalTo(20*KFitWidthRate)
            make.size.equalTo(CGSize(width: noteImage.size.width, height: noteImage.size.height))
        }
    
        self.view.addSubview(self.noteLb)
        self.noteLb.snp_makeConstraints { (make) in
            make.left.equalTo(noteImageView.snp_right).offset(5*KFitWidthRate)
            make.centerY.equalTo(noteImageView)
        }
    }
    @objc private func commfirmClick() {
        guard self.inputIsEmpty(text: self.inputNumView.textTF.text ?? "") == true else {
            return
        }
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["id"] = value.valueStr
        }
        switch self.psnalCterViewModel.psnalInfoModel!.title {
            case "电话".localizedStr:
                paramters["phone"] = self.inputNumView.textTF.text
                break
            case "微信".localizedStr:
                paramters["weixin"] = self.inputNumView.textTF.text
                break
            case "邮箱".localizedStr:
                paramters["email"] = self.inputNumView.textTF.text
                break
            case "WhatsApp".localizedStr:
                paramters["whatsapp"] = self.inputNumView.textTF.text
                break
            default:
                break
        }
        updateUserInfoReuqest(paramters: paramters)
    }
    private func inputIsEmpty(text:String) -> Bool {
        switch self.psnalCterViewModel.psnalInfoModel!.title {
            case "电话".localizedStr:
                guard text.isEmpty == false else {
                    MBProgressHUD.showMessage(Msg: "请输入手机号码".localizedStr, Deleay: 1.5)
                    return false
                }
                return true
            case "微信".localizedStr:
                guard text.isEmpty == false else {
                    MBProgressHUD.showMessage(Msg: "请输入微信号".localizedStr, Deleay: 1.5)
                    return false
                }
                return true
            case "邮箱".localizedStr:
                guard text.isEmpty == false else {
                    MBProgressHUD.showMessage(Msg: "请输入邮箱".localizedStr, Deleay: 1.5)
                    return false
                }
                return true
            case "WhatsApp".localizedStr:
                guard text.isEmpty == false else {
                    MBProgressHUD.showMessage(Msg: "请输入WhatsApp".localizedStr, Deleay: 1.5)
                    return false
                }
                return true
            default:
                return false
        }
    }
    @objc func noticeSwitchClick(sender:UISwitch) {
        switch self.psnalCterViewModel.psnalInfoModel!.title {
            case "电话".localizedStr:
                paramters["isPublishPhone"] = sender.isOn == true ? "1" : "0"
                break
            case "微信".localizedStr:
                paramters["isPublishWeixin"] = sender.isOn == true ? "1" : "0"
                break
            case "邮箱".localizedStr:
                paramters["isPublishEmail"] = sender.isOn == true ? "1" : "0"
                break
            case "WhatsApp".localizedStr:
                paramters["isPublishWhatsapp"] = sender.isOn == true ? "1" : "0"
                break
            default:
                break
        }
    }
    //MARK: - 获取验证码
    @objc private func getVerificationCodeClick() {
        guard self.inputNumView.textTF.text!.isEmpty == false else {
            MBProgressHUD.showMessage(Msg: "请输入手机号".localizedStr, Deleay: 1.5)
            return
        }
        guard self.areaCodeBTF.text!.isEmpty == false else {
            MBProgressHUD.showMessage(Msg: "请输入国家码".localizedStr, Deleay: 1.5)
            return
        }
//        if self.viewModel is CBPetLoginViewModel {
//            let model = self.viewModel as! CBPetLoginViewModel
//            guard model.getVerificationCodeBlock == nil else {
//                model.getVerificationCodeBlock!(self.getVerificationBtn,self.inputNumView.textTF.text!, self.areaCodeBTF.text!)
//                model.getVerificationCodeUpdateViewBlock = { [weak self] (coutDown:Int,isFinished:Bool) -> Void in
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
//                return
//            }
//        }
    }
    //MARK: - 修改用户信息
    private func updateUserInfoReuqest(paramters:Dictionary<String, Any>) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.updateUserInfoRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
            var userInfo = CBPetUserInfoModelTool.getUserInfo()
            switch self?.psnalCterViewModel.psnalInfoModel!.title {
                case "电话".localizedStr:
                    userInfo.phone = paramters["phone"] as? String
                    userInfo.isPublishPhone = paramters["isPublishPhone"] as? String
                    break
                case "微信".localizedStr:
                    userInfo.weixin = paramters["weixin"] as? String
                    userInfo.isPublishWeixin = paramters["isPublishWeixin"] as? String
                    break
                case "邮箱".localizedStr:
                    userInfo.email = paramters["email"] as? String
                    userInfo.isPublishEmail = paramters["isPublishEmail"] as? String
                    break
                case "WhatsApp".localizedStr:
                    userInfo.whatsapp = paramters["whatsapp"] as? String
                    userInfo.isPublishWhatsapp = paramters["isPublishWhatsapp"] as? String
                    break
                default:
                    break
            }
            CBPetUserInfoModelTool.saveUserInfo(userInfoModel: userInfo)
            self?.navigationController?.popViewController(animated: true)
            guard self?.editReturnBlock == nil else {
                self?.editReturnBlock!()
                return
            }
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
