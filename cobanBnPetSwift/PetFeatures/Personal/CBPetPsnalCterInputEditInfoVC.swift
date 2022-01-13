//
//  CBPetPsnalCterInputEditInfoVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/20.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetPsnalCterInputEditInfoVC: CBPetBaseViewController {

    public var isEditPetInfo:Bool?
    
    public lazy var psnalCterViewModel:CBPetPsnalCterViewModel = {
        let viewModel = CBPetPsnalCterViewModel()
        return viewModel
    }()
    public lazy var petInfoModel:CBPetPsnalCterPetPet = {
        let viewModel = CBPetPsnalCterPetPet()
        return viewModel
    }()
    
    public var editReturnBlock:(() -> Void)?
    
    private lazy var inputPhoneView:CBPetTFInputView = {
        let inputView = CBPetTFInputView.init()
        inputView.setInputView(title: "".localizedStr, placeholdStr: "请输入手机号码".localizedStr)
        self.view.addSubview(inputView)
        return inputView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* view的 y 从 导航栏以下算起*/
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.setupView()
        if self.isEditPetInfo == true {
            setupPetTitleValue()
        } else {
            setupPsnalTitleValue()
        }
    }
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        initBarRight(title: "确定".localizedStr, action: #selector(commfirmClick))
        self.rightBtn.setTitleColor(KPetAppColor, for: .normal)
        self.rightBtn.setTitleColor(KPetAppColor, for: .highlighted)
        self.rightBtn.titleLabel?.font = UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)
        
        self.view.addSubview(self.inputPhoneView)
        self.inputPhoneView.snp_makeConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo((-20*KFitWidthRate))
            make.height.equalTo(53*KFitHeightRate)
            make.top.equalTo(self.view.snp_top).offset(0*KFitHeightRate)
        }
        self.inputPhoneView.textTF.clearButtonMode = .whileEditing
    }
    private func setupPetTitleValue() {
        initBarWith(title: self.petInfoModel.title ?? "", isBack: true)
        switch self.petInfoModel.title {
            case "昵称".localizedStr:
                self.inputPhoneView.textTF.addChangeTextTarget()
                self.inputPhoneView.textTF.maxTextNumber = 10
                self.inputPhoneView.textTF.placeholder = "请输入宠物昵称（10个字以内）".localizedStr
                self.inputPhoneView.textTF.text = self.petInfoModel.name
                break
            case "品种".localizedStr:
                self.inputPhoneView.textTF.placeholder = "请输入宠物品种".localizedStr
                self.inputPhoneView.textTF.text = self.petInfoModel.variety
                break
            case "毛色".localizedStr:
                self.inputPhoneView.textTF.placeholder = "请输入宠物毛色".localizedStr
                self.inputPhoneView.textTF.text = self.petInfoModel.color
                break
            case "宠龄".localizedStr:
                self.inputPhoneView.textTF.placeholder = "请输入宠龄".localizedStr
                self.inputPhoneView.textTF.text = self.petInfoModel.age
                break
            default:
                break
        }
    }
    private func setupPsnalTitleValue() {
        initBarWith(title: self.psnalCterViewModel.psnalInfoModel!.title!, isBack: true)
        let userInfo = CBPetUserInfoModelTool.getUserInfo()
        switch self.psnalCterViewModel.psnalInfoModel!.title {
            case "名字".localizedStr:
                self.inputPhoneView.textTF.addChangeTextTarget()
                self.inputPhoneView.textTF.maxTextNumber = 10
                self.inputPhoneView.textTF.placeholder = "请输入名字（10个字以内）".localizedStr
                self.inputPhoneView.textTF.text = userInfo.name
                break
            case "邮箱".localizedStr:
                self.inputPhoneView.textTF.placeholder = "请输入邮箱".localizedStr
                self.inputPhoneView.textTF.text = userInfo.email
                break
            case "WhatsApp".localizedStr:
                self.inputPhoneView.textTF.placeholder = "请输入WhatsApp".localizedStr
                self.inputPhoneView.textTF.text = userInfo.whatsapp
                break
            default:
                break
        }
    }
    //MARK: - 确认修改
    @objc private func commfirmClick() {
        guard self.inputIsEmpty(text: self.inputPhoneView.textTF.text ?? "") == true else {
            return
        } 
        var paramters:Dictionary<String,Any> = Dictionary()
        if self.isEditPetInfo == true {
            let userInfo = CBPetLoginModelTool.getUser()
            paramters["userId"] = userInfo?.uid ?? ""
            paramters["id"] = self.petInfoModel.id ?? ""
            switch self.petInfoModel.title {
                case "昵称".localizedStr:
                    paramters["name"] = self.inputPhoneView.textTF.text
                    break
                case "品种".localizedStr:
                    paramters["variety"] = self.inputPhoneView.textTF.text
                    break
                case "毛色".localizedStr:
                    paramters["color"] = self.inputPhoneView.textTF.text
                    break
                case "宠龄".localizedStr:
                    paramters["age"] = self.inputPhoneView.textTF.text
                    break
                default:
                    break
            }
            updatePetInfoReuqest(paramters: paramters)
        } else {
            if let value = CBPetLoginModelTool.getUser()?.uid {
                paramters["id"] = value.valueStr
            }
            switch self.psnalCterViewModel.psnalInfoModel!.title {
                case "名字".localizedStr:
                    paramters["name"] = self.inputPhoneView.textTF.text
                    break
                case "邮箱".localizedStr:
                    paramters["email"] = self.inputPhoneView.textTF.text
                    break
                case "WhatsApp".localizedStr:
                    paramters["whatsapp"] = self.inputPhoneView.textTF.text
                    break
                default:
                    break
            }
            updateUserInfoReuqest(paramters: paramters)
        }
    }
    private func inputIsEmpty(text:String) -> Bool {
        if self.isEditPetInfo == true {
            switch self.petInfoModel.title {
                case "昵称".localizedStr:
                    guard text.isEmpty == false else {
                        MBProgressHUD.showMessage(Msg: "请输入宠物昵称（10个字以内）".localizedStr, Deleay: 1.5)
                        return false
                    }
                    return true
                case "品种".localizedStr:
                    guard text.isEmpty == false else {
                        MBProgressHUD.showMessage(Msg: "请输入宠物品种".localizedStr, Deleay: 1.5)
                        return false
                    }
                    return true
                case "毛色".localizedStr:
                    guard text.isEmpty == false else {
                        MBProgressHUD.showMessage(Msg: "请输入宠物毛色".localizedStr, Deleay: 1.5)
                        return false
                    }
                    return true
                case "宠龄".localizedStr:
                    guard text.isEmpty == false else {
                        MBProgressHUD.showMessage(Msg: "请输入宠龄".localizedStr, Deleay: 1.5)
                        return false
                    }
                    return true
                default:
                    return false
            }
        } else {
            switch self.psnalCterViewModel.psnalInfoModel!.title {
                case "名字".localizedStr:
                    guard text.isEmpty == false else {
                        MBProgressHUD.showMessage(Msg: "请输入名字（10个字以内）".localizedStr, Deleay: 1.5)
                        return false
                    }
                    return true
                default:
                    return false
            }
        }
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
            switch self?.psnalCterViewModel.psnalInfoModel?.title {
                case "名字".localizedStr:
                    userInfo.name = paramters["name"] as? String
                    break
                case "邮箱".localizedStr:
                    userInfo.email = paramters["email"] as? String
                    break
                case "WhatsApp".localizedStr:
                    userInfo.whatsapp = paramters["whatsapp"] as? String
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
    //MARK: - 修改宠物资料
    private func updatePetInfoReuqest(paramters:Dictionary<String, Any>) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.updatePetsInfoRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
            guard self?.editReturnBlock == nil else {
                self?.editReturnBlock!()
                self?.navigationController?.popViewController(animated: true)
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
