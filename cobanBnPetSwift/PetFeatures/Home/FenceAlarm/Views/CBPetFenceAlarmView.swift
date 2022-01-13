//
//  CBPetFenceAlarmView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/7.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFenceAlarmView: CBPetBaseView {
    
    private lazy var shadowBgmView:UIView = {
        let bgmV = UIView(backgroundColor: UIColor.white, cornerRadius: 16*KFitHeightRate, shadowColor: KPetC8C8C8Color, shadowOpacity: 0.85, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8)
        return bgmV
    }()
    private lazy var bgmView:UIView = {
        let bgmV = UIView.init()
        bgmV.backgroundColor = UIColor.white
        return bgmV
    }()
    private lazy var addressLb:UILabel = {
        let lb = UILabel(text: "".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!)
        return lb
    }()
   private lazy var radiusLb:UILabel = {
       let lb = UILabel(text: "".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!)
       return lb
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
            make.left.top.right.bottom.equalTo(self)
        }
        self.addSubview(self.bgmView)
        self.bgmView.snp_makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
        
        self.addSubview(self.addressLb)
        self.addressLb.snp_makeConstraints { (make) in
            make.top.equalTo(20*KFitHeightRate)
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo(-20*KFitWidthRate)
        }
        
        let line = CBPetUtilsCreate.createLineView()
        line.backgroundColor = KPetLineColor
        self.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo(-20*KFitWidthRate)
            make.top.equalTo(self.addressLb.snp_bottom).offset(20*KFitHeightRate)
            make.height.equalTo(1)
        }
        
        self.addSubview(self.radiusLb)
        self.radiusLb.snp_makeConstraints { (make) in
            make.top.equalTo(line.snp_bottom).offset(20*KFitHeightRate)
            make.left.equalTo(20*KFitWidthRate)
        }
    }
    func updateAlarmViewData(address:String,radius:String) {
        self.addressLb.text = "".localizedStr + address
        self.radiusLb.text = String(format: "%@%@(m)", "围栏半径：".localizedStr,radius)
        
        let addressHeight = address.getHeightText(text: address, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!, width: SCREEN_WIDTH-40*KFitWidthRate)
        self.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 20*KFitHeightRate + addressHeight + 20*KFitHeightRate + 1 + 20*KFitHeightRate + self.radiusLb.font.lineHeight + 20*KFitHeightRate)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
