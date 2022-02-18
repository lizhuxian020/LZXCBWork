//
//  CBPetAvatarPaoView.swift
//  cobanBnPetSwift
//
//  Created by lee on 2022/1/22.
//  Copyright © 2022 coban. All rights reserved.
//

import Foundation
import UIKit

class CBPetAvatarPaoView : CBPetBaseView, BMKGeoCodeSearchDelegate {

    var petModel : CBPetPsnalCterPetModel? {
        didSet {
            self.didSetPetModel()
        }
    }
    var fenceModel : CBPetHomeParamtersModel? {
        didSet {
            self.didSetFenceModel()
        }
    }
    
    private var _fenceContainer : UIView?
    private var bgImgView : UIImageView = {
        let v = UIImageView.init()
        var img = UIImage.init(named: "pet_paoView_bg") ?? UIImage.init()
        let imgW = img.size.width
        let imgH = img.size.height
        v.image = img.resizableImage(withCapInsets: UIEdgeInsets.init(top: imgH*0.18, left: imgW*0.4, bottom: imgH*0.2, right: imgW*0.4), resizingMode: .stretch)
        return v
    }()
    
    private var contentView : UIView = UIView.init()
    
    private var locateImgView : UIImageView = {
        let v = UIImageView.init()
        v.image = UIImage.init(named: "pet_locate")
        return v
    }()
    
    private var locateLbl : UILabel = {
        let v = UILabel(text: "", textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!)
        v.numberOfLines = 0
        return v
    }()
    
    private var timeImgView : UIImageView = {
        let v = UIImageView.init()
        v.image = UIImage.init(named: "pet_locateTime")
        return v
    }()
    
    private var timeLbl : UILabel = {
        let v = UILabel(text: "", textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!)
        return v
    }()
    
    private var fenceLbl : UILabel = {
        let v = UILabel(text: "电子围栏".localizedStr, textColor: KPet333333Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, textAlignment: .left)
        v.isUserInteractionEnabled = true
        return v
    }()
    
    private var fenceSwitch : UISwitch = {
        let v = UISwitch.init()
        v.addTarget(self, action: #selector(didSwitch(sender:)), for: .valueChanged)
        return v
    }()
    
    private var statusLbl : UILabel = {
        let v = UILabel(text: "设备：已连接", textColor: KPetAppColor, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!)
        return v
    }()
    
    private var batteryImgView : UIImageView = {
        let v = UIImageView.init()
        return v
    }()
    
    private var batteryView : UIView = {
        let v = UIView.init()
        v.backgroundColor = KPetAppColor
        return v
    }()
    
    private var batteryLbl : UILabel = {
        let v = UILabel(text: "75%", textColor: KPetAppColor, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!,textAlignment: .right)
        return v
    }()
    
    private var searcher:BMKGeoCodeSearch = {
        let search = BMKGeoCodeSearch.init()
        return search
    }()
    
    private var geocoder : GMSGeocoder = GMSGeocoder.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
        self.searcher.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setLocateTxt(_ txt: String) {
        self.locateLbl.text = txt
    }
    
    private func setupUI() {
        self.snp_makeConstraints { make in
            make.width.equalTo(258)
        }
        self.backgroundColor = .clear
        
        self.addSubview(bgImgView)
        bgImgView.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        self.addSubview(contentView)
        contentView.snp_makeConstraints { make in
            make.top.equalTo(10*KFitHeightRate)
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo(-20*KFitWidthRate)
            make.bottom.equalTo(-15*KFitHeightRate)
        }
        
        contentView.addSubview(locateImgView)
        contentView.addSubview(locateLbl)
        
        locateLbl.snp_makeConstraints { make in
            make.top.right.equalTo(self.contentView)
            make.height.greaterThanOrEqualTo(50*KFitHeightRate)
        }
        locateImgView.snp_makeConstraints { make in
            make.centerY.equalTo(locateLbl)
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.locateLbl.snp_left).offset(-10*KFitWidthRate)
            make.width.height.equalTo(20*KFitWidthRate)
        }
        
        let s = UIView.init()
        s.backgroundColor = kLineColor
        contentView.addSubview(s)
        s.snp_makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalTo(self.locateLbl)
            make.left.right.equalTo(0)
        }
        
        contentView.addSubview(timeLbl)
        contentView.addSubview(timeImgView)
        timeLbl.snp_makeConstraints { make in
            make.top.equalTo(self.locateLbl.snp_bottom)
            make.right.equalTo(self.contentView)
            make.height.equalTo(50*KFitHeightRate)
        }
        timeImgView.snp_makeConstraints { make in
            make.centerY.equalTo(self.timeLbl)
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.timeLbl.snp_left).offset(-10*KFitWidthRate)
            make.width.height.equalTo(20*KFitHeightRate)
        }
        
        let s1 = UIView.init()
        s1.backgroundColor = kLineColor
        contentView.addSubview(s1)
        s1.snp_makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalTo(self.timeLbl)
            make.left.right.equalTo(0)
        }
        
        let fenceContainer = UIView.init()
        _fenceContainer = fenceContainer
        contentView.addSubview(fenceContainer)
        fenceContainer.snp_makeConstraints { make in
            make.height.equalTo(50*KFitHeightRate)
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(self.timeLbl.snp_bottom)
        }
        
        fenceContainer.addSubview(fenceLbl)
        fenceLbl.snp_makeConstraints { make in
            make.top.bottom.equalTo(fenceContainer)
            make.left.equalTo(fenceContainer)
        }
        fenceContainer.addSubview(fenceSwitch)
        fenceSwitch.snp_makeConstraints { make in
            make.centerY.equalTo(fenceLbl)
            make.right.equalTo(fenceContainer)
            make.left.equalTo(fenceLbl.snp_right)
        }
        
        let s2 = UIView.init()
        s2.backgroundColor = kLineColor
        contentView.addSubview(s2)
        s2.snp_makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalTo(fenceContainer)
            make.left.right.equalTo(0)
        }
        
        let batteryContainer = UIView.init()
        contentView.addSubview(batteryContainer)
        batteryContainer.snp_makeConstraints { make in
//            make.height.equalTo(50*KFitHeightRate)
            make.left.right.bottom.equalTo(self.contentView)
            make.top.equalTo(fenceContainer.snp_bottom)
        }
        
        batteryContainer.addSubview(statusLbl)
        statusLbl.snp_makeConstraints { make in
//            make.centerY.equalTo(batteryContainer)
            make.left.equalTo(batteryContainer)
            make.top.equalTo(batteryContainer).offset(10*KFitHeightRate)
        }
        
        batteryContainer.addSubview(batteryLbl)
        batteryLbl.snp_makeConstraints { make in
            make.centerY.equalTo(statusLbl)
            make.right.equalTo(batteryContainer)
            make.bottom.equalTo(batteryContainer).offset(-10*KFitHeightRate)
        }
        
        let powerImage = UIImage(named: "pet_home_power")!
        batteryImgView.image = powerImage
        batteryContainer.addSubview(batteryImgView)
        batteryImgView.snp_makeConstraints { make in
            make.centerY.equalTo(statusLbl)
            make.right.equalTo(batteryLbl.snp_left).offset(-5*KFitWidthRate)
        }
        
        batteryImgView.addSubview(batteryView)
        batteryView.snp_makeConstraints { make in
            make.centerY.equalTo(self.batteryImgView)
            make.height.equalTo(powerImage.size.height-4)
            make.left.equalTo(self.batteryImgView.snp_left).offset(2)
            make.width.equalTo((powerImage.size.width-2-4))
        }
        
        statusLbl.text = "NB已连接"
        batteryLbl.text = "100%"
        
        fenceLbl.tapBlk = {[weak self] in
            if self?.viewModel is CBPetHomeViewModel {
                let homeViewModel = self?.viewModel as! CBPetHomeViewModel
                guard homeViewModel.ctrlPanelClickBlock == nil else {
                    homeViewModel.ctrlPanelClickBlock!("电子围栏开启".localizedStr as Any,false,false)
                    return
                }
            }
        }
    }
    
    private func didSetPetModel() {
        guard self.petModel != nil else {
            return
        }
        self.startSearher()
        self.timeLbl.text = petModel!.getTimeStr(formatStr: "yyyy-MM-dd HH:mm:ss")
        self._setupBattery()
        self._setupStatus()
    }
    
    private func didSetFenceModel() {
        guard fenceModel != nil else {
            return
        }
        self.fenceSwitch.isOn = fenceModel!.fenceSwitch == "1"
    }
    
    private func _setupBattery() {
        let battery = petModel?.pet.device.location.baterry ?? ""
        if battery.isEmpty == false {
            self.batteryImgView.isHidden = false
            self.batteryLbl.text = battery + "%"
            let percentNum = Float(battery) ?? 0
            if percentNum <= 10 {
                self.batteryView.backgroundColor = UIColor.init().colorWithHexString(hexString: "#F8563B")
            } else if percentNum <= 20 && percentNum > 10 {
                self.batteryView.backgroundColor = UIColor.yellow
            } else {
                self.batteryView.backgroundColor = KPetAppColor
            }
            let powerImage = UIImage(named: "pet_home_power")!
            self.batteryView.snp_remakeConstraints { make in
                make.centerY.equalTo(self.batteryImgView)
                make.height.equalTo(powerImage.size.height-4)
                make.left.equalTo(self.batteryImgView.snp_left).offset(2)
                make.width.equalTo((powerImage.size.width-2-4)*CGFloat(percentNum)/100)
            }
        } else {
            self.batteryLbl.text = ""
            self.batteryImgView.isHidden = true
        }
    }
    
    private func _setupStatus() {
        let online = petModel?.pet.device.online ?? ""
        var statusTxt : String?
        switch online {
        case "0":
            statusTxt = "设备：".localizedStr + "未连接".localizedStr
            break
        case "1":
            statusTxt = "设备：".localizedStr + "已连接".localizedStr
            break
        default:
            statusTxt = "设备：无".localizedStr
        }
        self.statusLbl.text = statusTxt
    }
    
    func getSimCardTypeStr() -> String {
        guard petModel != nil else {
            return ""
        }
        let simCardType = petModel?.pet.device.simCardType ?? ""
        if simCardType == "0" {
            return "NB"
        } else if simCardType == "1" {
            return "2g"
        } else {
            return ""
        }
    }
    
    private func startSearher() {
        if AppDelegate.shareInstance.IsShowGoogleMap {
            self.locateLbl.text = petModel?.app_addressStr
            return
        }
        let reverseGeoCodeOpetion = BMKReverseGeoCodeSearchOption.init()
        reverseGeoCodeOpetion.location = petModel!.getCoordinate2D()
        let flag = self.searcher.reverseGeoCode(reverseGeoCodeOpetion)
        if flag == true {
            CBLog(message: "反geo检索发送成功")
        } else {
            CBLog(message: "反geo检索发送失败")
        }
    }
    
    // MARK: - BMKGeoCodeSearchDelegate
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeSearchResult!, errorCode error: BMKSearchErrorCode) {
        switch error { ///69 - 52 = 17
        case BMK_SEARCH_NO_ERROR:
            self.locateLbl.text = result.address
            break
        default:
            self.locateLbl.text = "未知".localizedStr
            CBLog(message: "未找地理位置")
            break
        }
    }
    
    @objc func didSwitch(sender: UISwitch) {
        
        let action = {[weak self] in
            if self?.viewModel is CBPetHomeViewModel {
                let homeViewModel = self?.viewModel as! CBPetHomeViewModel
                guard homeViewModel.ctrlPanelClickBlock == nil else {
                    homeViewModel.paoViewFenceSwitch = sender
                    homeViewModel.ctrlPanelClickBlock!("电子围栏开启".localizedStr as Any,true,sender.isOn)
                    return
                }
            }
        }
        
        if sender.isOn {
            let alertC = UIAlertController.init(title: "", message: "电子围栏，当宠物出围栏时app能收到报警并提示主人。注意：开启此功能后会打开设备的GPS，耗电量会增加。".localizedStr, preferredStyle: .alert)
            alertC.addAction(UIAlertAction.init(title: "取消".localizedStr, style: .cancel, handler: { alertAction in
                sender.setOn(false, animated: true)
            }))
            alertC.addAction(UIAlertAction.init(title: "确定".localizedStr, style: .default, handler: { alertAction in
                action()
            }))
            UIViewController.getCurrentVC()?.present(alertC, animated: true, completion: nil)
            return
        }
        action()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let pointInFence = _fenceContainer?.convert(point, from: self)
        let result = _fenceContainer?.bounds.contains(pointInFence!)
        return result!
    }
}
