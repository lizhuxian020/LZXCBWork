//
//  CBPetPsnalPrivcTableViewCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/3.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetPsnalPrivcTableViewCell: CBPetBaseTableViewCell {

    
   
    private lazy var leftLb:UILabel = {
        let lb = UILabel(text: "头像".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var privacySiwtch:UISwitch = {
        let noticSwi = UISwitch.init()
        noticSwi.isOn = true
        return noticSwi
    }()
    var updateBlock:(() -> Void)?
    private var paramters:Dictionary<String,Any> = Dictionary()
    
    var type:String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        super.setupViewModel(viewModel: viewModel)
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        self.bottomLineView.isHidden = false
        
       
        self.contentView.addSubview(self.leftLb)
        self.contentView.addSubview(privacySiwtch)
        
        self.privacySiwtch.addTarget(self, action: #selector(noticeSwitchClick), for: .valueChanged)
        self.privacySiwtch.snp_makeConstraints { (make) in
            // UISwitch (开关大小无法设置）
            make.top.equalTo(20*KFitHeightRate)
            make.bottom.equalTo(-20*KFitHeightRate)
            make.right.equalTo(-20*KFitWidthRate)
        }
        
        self.leftLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.privacySiwtch)
            make.left.equalTo(20*KFitWidthRate)
        }
        
    }
    var privacyPetModel:CBPetPsnalCterPetModel = CBPetPsnalCterPetModel() {
        didSet {
            self.leftLb.text = privacyPetModel.pet.name ?? "未知".localizedStr
            self.bottomLineView.isHidden = true
            self.topLineView.isHidden = true
            self.privacySiwtch.isOn = privacyPetModel.pet.isPublish == "0" ? false : privacyPetModel.pet.isPublish == "1" ? true : false
            switch self.privacyPetModel.index {
            case self.privacyPetModel.cout-4:
                self.updateLayout_pet()
                break
            default:
                self.updateLayout_pet_common()
                break
            }
        }
    }
    var privacyUserInfoModel:CBPetUserInfoModel = CBPetUserInfoModel() {
        didSet {
            self.leftLb.text = privacyUserInfoModel.title
            self.bottomLineView.isHidden = true
            self.topLineView.isHidden = true
            
            switch self.privacyUserInfoModel.index {
            case self.privacyUserInfoModel.cout-1:
                self.updateLayout_common()
                self.privacySiwtch.isOn = privacyUserInfoModel.isPublishWhatsapp == "0" ? false : privacyUserInfoModel.isPublishWhatsapp == "1" ? true : false
                break
            case self.privacyUserInfoModel.cout-2:
                self.updateLayout_common()
                self.privacySiwtch.isOn = privacyUserInfoModel.isPublishEmail == "0" ? false : privacyUserInfoModel.isPublishEmail == "1" ? true : false
                break
            case self.privacyUserInfoModel.cout-3:
                self.updateLayout_common()
                self.privacySiwtch.isOn = privacyUserInfoModel.isPublishWeixin == "0" ? false : privacyUserInfoModel.isPublishWeixin == "1" ? true : false
                break
            case self.privacyUserInfoModel.cout-4:
                self.topLineView.isHidden = false
                self.updateLayout_common()
                self.privacySiwtch.isOn = privacyUserInfoModel.isPublishPhone == "0" ? false : privacyUserInfoModel.isPublishPhone == "1" ? true : false
                break
            default:
                self.updateLayout_pet()
                break
            }
        }
    }
    private func updateLayout_common() {
        self.bottomLineView.isHidden = false
        self.privacySiwtch.snp_updateConstraints { (make) in
            make.top.equalTo(20*KFitHeightRate)
            make.bottom.equalTo(-20*KFitHeightRate)
            make.right.equalTo(-20*KFitWidthRate)
        }
    }
    private func updateLayout_pet_common() {
        self.privacySiwtch.snp_updateConstraints { (make) in
            make.top.equalTo(15*KFitHeightRate)
            make.bottom.equalTo(-15*KFitHeightRate)
            make.right.equalTo(-20*KFitWidthRate)
        }
    }
    private func updateLayout_pet() {
        self.privacySiwtch.snp_updateConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(-20*KFitHeightRate)
            make.right.equalTo(-20*KFitWidthRate)
        }
    }
    @objc func noticeSwitchClick(sender:UISwitch) {
        if self.type == "1" {
            if let value = CBPetLoginModelTool.getUser()?.uid {
                paramters["id"] = value.valueStr
            }
            switch self.privacyUserInfoModel.title {
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
            updateUserInfoReuqest(paramters: paramters)
        }
        if self.type == "2" {
            var paramtersPet:Dictionary<String,Any> = Dictionary()
            paramtersPet["isPublish"] = self.privacySiwtch.isOn == true ? "1" : "0"
            paramtersPet["id"] = self.privacyPetModel.pet.id
            if let value = CBPetLoginModelTool.getUser()?.uid {
                paramtersPet["userId"] = value.valueStr
            }
            updatePetsInfoReuqest(paramters: paramtersPet)
        }
    }
    //MARK: - 修改用户信息隐私权限
    private func updateUserInfoReuqest(paramters:Dictionary<String, Any>) {
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.updateUserInfoRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                guard self?.updateBlock == nil else {
                    self?.updateBlock!()
                    return
                }
                return;
            }
            var userInfo = CBPetUserInfoModelTool.getUserInfo()
            switch self?.privacyUserInfoModel.title {
                case "电话".localizedStr:
                    userInfo.isPublishPhone = paramters["isPublishPhone"] as? String
                    break
                case "微信".localizedStr:
                    userInfo.isPublishWeixin = paramters["isPublishWeixin"] as? String
                    break
                case "邮箱".localizedStr:
                    userInfo.isPublishEmail = paramters["isPublishEmail"] as? String
                    break
                case "WhatsApp".localizedStr:
                    userInfo.isPublishWhatsapp = paramters["isPublishWhatsapp"] as? String
                    break
                default:
                    break
            }
            CBPetUserInfoModelTool.saveUserInfo(userInfoModel: userInfo)
            guard self?.updateBlock == nil else {
                self?.updateBlock!()
                return
            }
        }) { (failureModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
        }
    }
    //MARK: - 修改宠物信息
    private func updatePetsInfoReuqest(paramters:Dictionary<String,Any>) {
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.updatePetsInfoRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
//                guard self?.updateBlock == nil else {
//                    self?.updateBlock!()
//                    return
//                }
                return;
            }
//            guard self?.updateBlock == nil else {
//                self?.updateBlock!()
//                return
//            }
        }) { (failureModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
