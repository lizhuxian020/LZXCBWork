//
//  CBPetCtrlPanelPopSwitchCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/6.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetCtrlPanelPopSwitchCell: CBPetBaseTableViewCell {

    private lazy var ctrlPanelSiwtch:UISwitch = {
        let noticSwi = UISwitch.init()
        noticSwi.isOn = false
        return noticSwi
    }()
    private lazy var titleBtn:CBPetBaseButton = {
//        let lb = UILabel(text: "电子围栏开启".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .left)
//        return lb
        let btn = CBPetBaseButton(title: "电子围栏开启".localizedStr, titleColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        return btn
    }()
    private lazy var textLb:UILabel = {
        let lb = UILabel(text: "电子围栏，当宠物出围栏时app能收到报警并提示主人。注意：开启此功能后会打开设备的GPS，耗电量会增加。".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 10*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        super.setupViewModel(viewModel: viewModel)
        self.viewModel = viewModel
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        self.bottomLineView.isHidden = false
        
        self.contentView.addSubview(self.ctrlPanelSiwtch)
        self.contentView.addSubview(self.titleBtn)
        self.contentView.addSubview(self.textLb)
        
        self.bottomLineView.snp_remakeConstraints { (make) in
            make.left.equalTo(25*KFitWidthRate)
            make.right.equalTo(-25*KFitWidthRate)
            make.bottom.equalTo(0)
            make.height.equalTo(1*KFitHeightRate)
        }
        self.ctrlPanelSiwtch.snp_makeConstraints { (make) in
            make.top.equalTo(25*KFitHeightRate)
            make.right.equalTo(-25*KFitWidthRate)
        }
        self.ctrlPanelSiwtch.addTarget(self, action: #selector(noticeSwitchClick), for: .valueChanged)
        
        self.titleBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.ctrlPanelSiwtch)
            make.left.equalTo(25*KFitWidthRate)
        }
        self.titleBtn.addTarget(self, action: #selector(titleClick), for: .touchUpInside)
        self.textLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.ctrlPanelSiwtch.snp_bottom).offset(12*KFitHeightRate)
            make.bottom.equalTo(-20*KFitHeightRate)
            make.left.equalTo(25*KFitWidthRate)
            make.right.equalTo(-25*KFitWidthRate)
        }
    }
    var ctrlPnaneSwitchModel:CBPetCtrlPanelModel = CBPetCtrlPanelModel() {
        didSet {
            self.titleBtn.setTitle(self.ctrlPnaneSwitchModel.title, for: .normal)
            self.textLb.text = self.ctrlPnaneSwitchModel.text
            if self.ctrlPnaneSwitchModel.title == "定时报告".localizedStr {
                self.bottomLineView.isHidden = true
            } else {
                self.bottomLineView.isHidden = false
            }
            switch ctrlPnaneSwitchModel.title {
            case "电子围栏开启".localizedStr:
                self.ctrlPanelSiwtch.isOn = ctrlPnaneSwitchModel.fenceSwitch == "1" ? true : false
                break
            case "挂失开启".localizedStr:
                self.ctrlPanelSiwtch.isOn = ctrlPnaneSwitchModel.callPosiAction == "1" ? true : false
                break
            case "定时报告".localizedStr:
                self.ctrlPanelSiwtch.isOn = ctrlPnaneSwitchModel.timingSwitch == "1" ? true : false
                break
            default:
                break
            }
        }
    }
    @objc private func noticeSwitchClick(sender:UISwitch) {
        if self.viewModel is CBPetHomeViewModel {
            let homeViewModel = self.viewModel as! CBPetHomeViewModel
            guard homeViewModel.ctrlPanelClickBlock == nil else {
                homeViewModel.ctrlPanelClickBlock!(self.ctrlPnaneSwitchModel.title as Any,true,sender.isOn)
                return
            }
        }
    }
    @objc private func titleClick() {
        if self.viewModel is CBPetHomeViewModel {
            let homeViewModel = self.viewModel as! CBPetHomeViewModel
            guard homeViewModel.ctrlPanelClickBlock == nil else {
                homeViewModel.ctrlPanelClickBlock!(self.ctrlPnaneSwitchModel.title as Any,false,false)
                return
            }
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
