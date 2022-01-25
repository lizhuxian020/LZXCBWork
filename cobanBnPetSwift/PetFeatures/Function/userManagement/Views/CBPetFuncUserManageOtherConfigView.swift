//
//  CBPetFuncUserManageOtherConfigView.swift
//  cobanBnPetSwift
//
//  Created by lee on 2022/1/24.
//  Copyright © 2022 coban. All rights reserved.
//

import Foundation
import UIKit

class CBPetFuncUserManageOtherConfigView : CBPetBaseView {
    
    var configModel : CBPetHomeParamtersModel? {
        didSet {
            self.didSetConfigModel()
        }
    }
    
    private var lossTitleLbl : UILabel = {
        let v = UILabel(text: "挂失".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .left)
        return v;
    }()
    private var lossSwitch : UISwitch = {
        let v = UISwitch.init()
        v.addTarget(self, action: #selector(clickLossSwitch(sender:)), for: .valueChanged)
        return  v
    }()
    private var lossSubTitleLbl : UILabel = {
        let v = UILabel(text: "挂失后，只要设备开机就自动发送位置给APP，请耐心等候。".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 10*KFitHeightRate)!,textAlignment: .left)
        v.numberOfLines = 0
        return v;
    }()
    
    private var timezoneTitleLbl : UILabel = {
        let v = UILabel(text: "设置时区".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .left)
        return v;
    }()
    private var timezoneValueLbl : UILabel = {
        let v = UILabel(text: "", textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!,textAlignment: .left)
        v.numberOfLines = 0
        return v;
    }()
    private var timezoneArrowView : UIImageView = {
       let v = UIImageView.init()
        v.image = UIImage.init(named: "pet_psnal_rightArrow")
        return v
    }()
    
    private var timeReportTitleLbl : UILabel = {
        let v = UILabel(text: "定时报告".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .left)
        return v;
    }()
    private var timeReportSwitch : UISwitch = {
        let v = UISwitch.init()
        v.addTarget(self, action: #selector(clickTimeReportSwitch(sender:)), for: .valueChanged)
        return  v
    }()
    private var timeReportSubTitleLbl : UILabel = {
        let v = UILabel(text: "定时报告,设备将会每天指定时间上报位置,最多可设置三个时间。注意:开启后设备将超低功耗运行无法通讯,只有到达指定时间才唤醒并工作三分钟".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 10*KFitHeightRate)!,textAlignment: .left)
        v.numberOfLines = 0
        return v;
    }()
    private var timeReportArrowView : UIImageView = {
        let v = UIImageView.init()
         v.image = UIImage.init(named: "pet_psnal_rightArrow")
         return v
     }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        self.backgroundColor = .white
        
        let lossContainer = UIView.init()
        self.addSubview(lossContainer)
        lossContainer.snp_makeConstraints { make in
            make.top.left.right.equalTo(0)
        }
        
        lossContainer.addSubview(lossTitleLbl)
        lossTitleLbl.snp_makeConstraints { make in
            make.top.left.equalTo(0)
        }
        lossContainer.addSubview(lossSwitch)
        lossSwitch.snp_makeConstraints { make in
            make.top.right.equalTo(0)
        }
        lossContainer.addSubview(lossSubTitleLbl)
        lossSubTitleLbl.snp_makeConstraints { make in
            make.top.equalTo(self.lossTitleLbl.snp_bottom).offset(10*KFitHeightRate)
            make.left.equalTo(0)
            make.bottom.equalTo(-10*KFitHeightRate)
            make.right.equalTo(lossSwitch.snp_left).offset(-5*KFitWidthRate)
        }
        let s = UIView.init()
        s.backgroundColor = KPetLineColor
        lossContainer.addSubview(s)
        s.snp_makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.bottom.equalTo(0)
        }
        
        let timezoneContainer = UIView.init()
        self.addSubview(timezoneContainer)
        timezoneContainer.snp_makeConstraints { make in
            make.top.equalTo(lossContainer.snp_bottom)
            make.left.right.equalTo(0)
        }
        
        timezoneContainer.addSubview(timezoneTitleLbl)
        timezoneTitleLbl.snp_makeConstraints { make in
            make.top.equalTo(10*KFitHeightRate)
            make.left.equalTo(0)
            make.bottom.equalTo(-10*KFitHeightRate)
        }
        timezoneContainer.addSubview(timezoneArrowView)
        timezoneArrowView.snp_makeConstraints { make in
            make.centerY.equalTo(timezoneContainer)
            make.right.equalTo(0)
        }
        timezoneContainer.addSubview(timezoneValueLbl)
        timezoneValueLbl.snp_makeConstraints { make in
            make.centerY.equalTo(timezoneContainer)
            make.right.equalTo(timezoneArrowView.snp_left).offset(-5*KFitWidthRate)
        }
        let s1 = UIView.init()
        s1.backgroundColor = KPetLineColor
        timezoneContainer.addSubview(s1)
        s1.snp_makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.bottom.equalTo(0)
        }
        
        let timeReportContainer = UIView.init()
        self.addSubview(timeReportContainer)
        timeReportContainer.snp_makeConstraints { make in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
            make.top.equalTo(timezoneContainer.snp_bottom)
        }
        
        timeReportContainer.addSubview(timeReportTitleLbl)
        timeReportTitleLbl.snp_makeConstraints { make in
            make.top.equalTo(10*KFitHeightRate)
            make.left.equalTo(0)
        }
        timeReportContainer.addSubview(timeReportArrowView)
        timeReportArrowView.snp_makeConstraints { make in
            make.centerY.equalTo(timeReportContainer)
            make.right.equalTo(0)
        }
        timeReportContainer.addSubview(timeReportSwitch)
        timeReportSwitch.snp_makeConstraints { make in
            make.top.equalTo(10*KFitHeightRate)
            make.right.equalTo(timeReportArrowView.snp_left).offset(-5*KFitWidthRate)
        }
        
        timeReportContainer.addSubview(timeReportSubTitleLbl)
        timeReportSubTitleLbl.snp_makeConstraints { make in
            make.left.equalTo(0)
            make.bottom.equalTo(-10*KFitHeightRate)
            make.top.equalTo(self.timeReportSwitch.snp_bottom).offset(5*KFitHeightRate)
            make.right.equalTo(self.timeReportArrowView.snp_left).offset(-5*KFitHeightRate)
        }
        
        timezoneContainer.tapBlk = {[weak self] in
            if let viewModel = self?.viewModel as? CBPetUserManageViewModel,
               let blk = viewModel.didClickTimezone{
                blk()
            }
        }
        
        timeReportContainer.tapBlk = {[weak self] in
            if let viewModel = self?.viewModel as? CBPetUserManageViewModel,
               let blk = viewModel.didClickTimeReport{
                blk()
            }
        }
    }
    
    private func didSetConfigModel() {
        guard self.configModel != nil else {
            return
        }
        self.lossSwitch.isOn = self.configModel?.callPosiAction == "1"
        self.timezoneValueLbl.text = self.configModel?.timeZone
        self.timeReportSwitch.isOn = self.configModel?.timingSwitch == "1"
    }
    
    @objc private func clickLossSwitch(sender : UISwitch) {
        if let viewModel = self.viewModel as? CBPetUserManageViewModel,
           let blk = viewModel.didClickLossSwitch{
            blk(sender.isOn)
        }
    }
    
    @objc private func clickTimeReportSwitch(sender : UISwitch) {
        if let viewModel = self.viewModel as? CBPetUserManageViewModel,
           let blk = viewModel.didClickTimeReportSwitch{
            blk(sender.isOn)
        }
    }
}
