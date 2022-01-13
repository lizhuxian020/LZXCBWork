//
//  CBPetFuncLocatePopView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/29.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncLocatePopView: CBPetBaseView,BMKGeoCodeSearchDelegate {

    private lazy var shadowBgmView:UIView = {
        let bgmV = UIView(backgroundColor: UIColor.white, cornerRadius: 16*KFitHeightRate, shadowColor: KPetC8C8C8Color, shadowOpacity: 0.85, shadowOffset: CGSize(width: 4, height: 0), shadowRadius: 8)
        return bgmV
    }()
    private lazy var bgmView:UIView = {
        let bgmV = UIView.init()
        bgmV.backgroundColor = UIColor.white
        return bgmV
    }()
    private lazy var locateImageView:UIImageView = {
        let locateImg = UIImage(named: "pet_locate")!
        let locateImageView = UIImageView.init()
        locateImageView.image = locateImg
        return locateImageView
    }()
    private lazy var addressLb:UILabel = {
        let lb = UILabel(text: "".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!)
        return lb
    }()
    private lazy var timeLb:UILabel = {
        let lb = UILabel(text: "".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!)
        return lb
    }()
    private lazy var searcher:BMKGeoCodeSearch = {
        let search = BMKGeoCodeSearch.init()
        return search
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskPath = UIBezierPath.init(roundedRect: self.bgmView.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue), cornerRadii: CGSize(width: 16*KFitHeightRate, height: 16*KFitHeightRate))
        let maskLayer = CAShapeLayer.init()
        /* 设置大小*/
        maskLayer.frame = self.bgmView.bounds
        /* 设置图形样子*/
        maskLayer.path = maskPath.cgPath
        self.bgmView.layer.mask = maskLayer
    }
    private func setupView() {
        self.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.00)

        self.addSubview(self.shadowBgmView)
        self.shadowBgmView.snp_makeConstraints { (make) in
            make.top.equalTo(12*KFitHeightRate)
            make.left.equalTo(0)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: 100*KFitHeightRate))
        }
        self.addSubview(self.bgmView)
        self.bgmView.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: 112*KFitHeightRate))
        }
        
        let locateImg = UIImage(named: "pet_locate")!
        let timeImg = UIImage(named: "pet_locateTime")!
        //let locateImageView = UIImageView.init()
        //locateImageView.image = locateImg
        self.bgmView.addSubview(locateImageView)
        locateImageView.snp_makeConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.centerY.equalTo(self.bgmView.snp_centerY).offset(-56*KFitHeightRate/2)
            make.size.equalTo(CGSize(width: locateImg.size.width,height: locateImg.size.height))
        }
        let timeImageView = UIImageView.init()
        timeImageView.image = timeImg
        self.bgmView.addSubview(timeImageView)
        timeImageView.snp_makeConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.centerY.equalTo(self.bgmView.snp_centerY).offset(56*KFitHeightRate/2)
            make.size.equalTo(CGSize(width: timeImg.size.width,height: timeImg.size.height))
        }
        
        let line = CBPetUtilsCreate.createLineView()
        line.backgroundColor = KPetLineColor
        self.bgmView.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo(-20*KFitWidthRate)
            make.centerY.equalTo(self.bgmView)
            make.height.equalTo(1)
        }
        
        self.bgmView.addSubview(self.addressLb)
        self.addressLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(locateImageView)
            make.left.equalTo(locateImageView.snp_right).offset(10*KFitWidthRate)
            make.right.equalTo(-20*KFitWidthRate)
        }
        self.bgmView.addSubview(self.timeLb)
        self.timeLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(timeImageView)
            make.left.equalTo(locateImageView.snp_right).offset(10*KFitWidthRate)
            make.right.equalTo(-20*KFitWidthRate)
        }
    }
    public func popView() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    @objc public func dissmiss() {
        self.removeFromSuperview()
    }
    func updateSingleLocateData(model:CBPetHomeInfoModel) {
        //pet_locate_LBS
        if model.pet.device.location.flag == "0" {
            ///gps
            locateImageView.image = UIImage(named: "pet_locate")!
        } else if model.pet.device.location.flag == "1" {
            ///LBS
            locateImageView.image = UIImage(named: "pet_locate_LBS")!
        }
        
        /* 需转为当前时区*/
        if let value = model.pet.device.location.postTime {
            if let valueTimeZone = CBPetHomeParamtersModel.getHomeParamters().timeZone {
                timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: value.valueStr, formateStr: "yyyy-MM-dd HH:mm:ss",timeZone: Int(valueTimeZone) ?? 0)
            } else {
                timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: value.valueStr, formateStr: "yyyy-MM-dd HH:mm:ss")
            }
            //timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: value.valueStr, formateStr: "yyyy-MM-dd HH:mm:ss",timeZone: 8)//CBPetUtils.convertTimestampToDateStr(timestamp: value.valueStr, formateStr: "yyyy-MM-dd HH:mm:ss")
        } else {
            timeLb.text = ""
        }
        guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
            // 显示百度地图
            let reverseGeoCodeOpetion = BMKReverseGeoCodeSearchOption.init()
            reverseGeoCodeOpetion.location = CLLocationCoordinate2DMake(Double(model.pet.device.location.lat ?? "0")!, Double(model.pet.device.location.lng ?? "0")!)
            self.searcher.delegate = self
            let flag = self.searcher.reverseGeoCode(reverseGeoCodeOpetion)
            if flag == true {
                CBLog(message: "反geo检索发送成功")
            } else {
                CBLog(message: "反geo检索发送失败")
            }
            return
        }
        let geocoder = GMSGeocoder.init()
        geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2DMake(Double(model.pet.device.location.lat ?? "0")!, Double(model.pet.device.location.lng ?? "0")!)) { (reverseGeocodeResponse, error) in
            if reverseGeocodeResponse?.results()?.count ?? 0 > 0 {
                let address = reverseGeocodeResponse?.results()?[0]
                let addressStr = "\(address?.country ?? "")" + "\(address?.administrativeArea ?? "")" + "\(address?.locality ?? "")" + "\(address?.subLocality ?? "")" + "\(address?.thoroughfare ?? "")"
                self.addressLb.text = addressStr
            } else {
                self.addressLb.text = "未知".localizedStr
            }
        }
    }
    // MARK: - BMKGeoCodeSearchDelegate
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeSearchResult!, errorCode error: BMKSearchErrorCode) {
        switch error { ///69 - 52 = 17
        case BMK_SEARCH_NO_ERROR:
            addressLb.text = result.address
            break
        default:
            addressLb.text = ""
            CBLog(message: "未找地理位置")
            break
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
