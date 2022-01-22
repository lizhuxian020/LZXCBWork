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
    
    var annotationModel : CBPetNormalAnnotation? {
        didSet {
            self.didGetAnnotation()
        }
    }
    
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
        let v = UILabel.init()
        v.font = UIFont(name: CBPingFangSC_Regular, size: 10*KFitHeightRate)!
        return v
    }()
    
    private var timeImgView : UIImageView = {
        let v = UIImageView.init()
        v.image = UIImage.init(named: "pet_locateTime")
        return v
    }()
    
    private var timeLbl : UILabel = {
        let v = UILabel.init()
        v.font = UIFont(name: CBPingFangSC_Regular, size: 10*KFitHeightRate)!
        return v
    }()
    
    private var fencyLbl : UILabel = {
        let v = UILabel.init()
        v.text = "电子围栏"
        return v
    }()
    
    private var fencySwitch : UISwitch = {
        let v = UISwitch.init()
        return v
    }()
    
    private var statusLbl : UILabel = {
        let v = UILabel(text: "设备状态：已连接", textColor: KPetAppColor, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!)
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
        self.backgroundColor = .green
        
        self.addSubview(bgImgView)
        bgImgView.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        self.addSubview(contentView)
        contentView.snp_makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-15)
        }
        
        contentView.addSubview(locateImgView)
        contentView.addSubview(locateLbl)
        
        locateLbl.snp_makeConstraints { make in
            make.top.right.equalTo(self.contentView)
            make.height.equalTo(50)
        }
        locateImgView.snp_makeConstraints { make in
            make.centerY.equalTo(locateLbl)
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.locateLbl.snp_left).offset(-10)
            make.width.height.equalTo(20)
        }
        
        contentView.addSubview(timeLbl)
        contentView.addSubview(timeImgView)
        timeLbl.snp_makeConstraints { make in
            make.top.equalTo(self.locateLbl.snp_bottom)
            make.right.equalTo(self.contentView)
            make.height.equalTo(50)
        }
        timeImgView.snp_makeConstraints { make in
            make.centerY.equalTo(self.timeLbl)
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.timeLbl.snp_left).offset(-10)
            make.width.height.equalTo(20)
        }
        
        let fencyContainer = UIView.init()
        contentView.addSubview(fencyContainer)
        fencyContainer.snp_makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(self.timeLbl.snp_bottom)
        }
        
        fencyContainer.addSubview(fencyLbl)
        fencyLbl.snp_makeConstraints { make in
            make.centerY.equalTo(fencyContainer)
            make.left.equalTo(fencyContainer)
        }
        fencyContainer.addSubview(fencySwitch)
        fencySwitch.snp_makeConstraints { make in
            make.centerY.equalTo(fencyLbl)
            make.right.equalTo(fencyContainer)
        }
        
        let batteryContainer = UIView.init()
        contentView.addSubview(batteryContainer)
        batteryContainer.snp_makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.bottom.equalTo(self.contentView)
            make.top.equalTo(fencyContainer.snp_bottom)
        }
        
        batteryContainer.addSubview(statusLbl)
        statusLbl.snp_makeConstraints { make in
            make.centerY.equalTo(batteryContainer)
            make.left.equalTo(batteryContainer)
        }
        batteryContainer.addSubview(batteryLbl)
        batteryLbl.snp_makeConstraints { make in
            make.right.equalTo(batteryContainer)
            make.centerY.equalTo(statusLbl)
        }
        let powerImage = UIImage(named: "pet_home_power")!
        batteryImgView.image = powerImage
        batteryContainer.addSubview(batteryImgView)
        batteryImgView.snp_makeConstraints { make in
            make.centerY.equalTo(self.batteryLbl)
            make.right.equalTo(self.batteryLbl.snp_left).offset(-5*KFitWidthRate)
            make.size.equalTo(CGSize(width: powerImage.size.width, height: powerImage.size.height))
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
    }
    
    private func didGetAnnotation() {
        guard annotationModel != nil else {
            return
        }
        self.startSearher()
        self.timeLbl.text = annotationModel!.getTimeStr(formatStr: "yyyy-MM-dd HH:mm:ss")
        self._setupBattery()
        self._setupStatus()
        
    }
    
    private func _setupBattery() {
        let battery = annotationModel!.getBattery()
        if battery.isEmpty == false {
            self.batteryImgView.isHidden = false
            self.batteryLbl.text = annotationModel!.getBattery() + "%"
            let percentNum = Float(annotationModel!.getBattery()) ?? 0
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
        let online = annotationModel!.getOnline()
        var statusTxt : String?
        switch online {
        case "0":
            statusTxt = "设备状态：".localizedStr + getSimCardTypeStr() + "未连接".localizedStr
            break
        case "1":
            statusTxt = "设备状态：".localizedStr + getSimCardTypeStr() + "已连接".localizedStr
            break
        default:
            statusTxt = "设备状态：无".localizedStr
        }
        self.statusLbl.text = statusTxt
    }
    
    func getSimCardTypeStr() -> String {
        guard annotationModel != nil else {
            return ""
        }
        let simCardType = annotationModel!.getSimCardType()
        if simCardType == "0" {
            return "NB"
        } else if simCardType == "1" {
            return "2g"
        } else {
            return ""
        }
    }
    
    private func startSearher() {
        let reverseGeoCodeOpetion = BMKReverseGeoCodeSearchOption.init()
        reverseGeoCodeOpetion.location = annotationModel!.getCoordinate2D()
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
            self.locateLbl.text = ""
            CBLog(message: "未找地理位置")
            break
        }
    }
}
