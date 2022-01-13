//
//  CBPetFuncPubnishmentView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/27.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncPubnishmentView: CBPetBaseView {

    private lazy var bgmView:UIView = {
        let bgmV = UIView.init()
        bgmV.backgroundColor = UIColor.white
        return bgmV
    }()
    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "请设置您的惩罚时长".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    private lazy var cancelBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "取消".localizedStr, titleColor: KPetAppColor, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!)
        return btn
    }()
    private lazy var audioAlarmBtn:UIButton = {
        let btn = UIButton(title: "声音告警".localizedStr, titleColor: UIColor.white, font: UIFont(name: CBPingFang_SC, size: 16*KFitHeightRate)!, backgroundColor: KPetAppColor)
        return btn
    }()
    private lazy var punishmentBtn:UIButton = {
        let btn = UIButton(title: "发起惩罚".localizedStr, titleColor: UIColor.white, font: UIFont(name: CBPingFang_SC, size: 16*KFitHeightRate)!, backgroundColor: KPetAppColor)
        return btn
    }()
    private lazy var btnArray:[UIButton] = {
        var arr = [UIButton]()
        return arr
    }()
    private var paramtersModel:CBPetHomeParamtersModel?
    var punishmentBlock:((_ type:String, _ objc:Any) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskPath = UIBezierPath.init(roundedRect: self.bgmView.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue), cornerRadii: CGSize(width: 16*KFitHeightRate, height: 16*KFitHeightRate))
        let maskLayer = CAShapeLayer.init()
        /* 设置大小*/
        maskLayer.frame = self.bgmView.bounds
        /* 设置图形样子*/
        maskLayer.path = maskPath.cgPath
        self.bgmView.layer.mask = maskLayer
    }
    private func setupView() {
        self.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.85)

        self.addSubview(self.bgmView)
        self.bgmView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(-60*KFitHeightRate)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: 180*KFitHeightRate))
        }
        
        self.bgmView.addSubview(self.titleLb)
        self.titleLb.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.bgmView)
            make.top.equalTo(12*KFitHeightRate)
        }
        
        self.bgmView.addSubview(self.cancelBtn)
        self.cancelBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.titleLb)
            make.left.equalTo(20*KFitWidthRate)
        }
        self.cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        self.addSubview(self.audioAlarmBtn)
        self.audioAlarmBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.height.equalTo(50*KFitHeightRate)
            make.width.equalTo(SCREEN_WIDTH/2-2)
            make.bottom.equalTo(0)
        }
        self.audioAlarmBtn.addTarget(self, action: #selector(audioAlarmAction), for: .touchUpInside)
        
        let sepView = UIView.init()
        sepView.backgroundColor = UIColor.white
        self.addSubview(sepView)
        sepView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.height.equalTo(50*KFitHeightRate)
            make.width.equalTo(4)
            make.bottom.equalTo(0)
        }
        
        self.addSubview(self.punishmentBtn)
        self.punishmentBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self)
            make.width.equalTo(SCREEN_WIDTH/2-2)
            make.height.equalTo(50*KFitHeightRate)
            make.bottom.equalTo(0)
        }
        self.punishmentBtn.addTarget(self, action: #selector(punishmentAction), for: .touchUpInside)
        
        let arrayTitle = ["1s","2s","3s"]
        for index in 0...2 {
            let btn = UIButton(title: arrayTitle[index], titleColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
            btn.setTitleColor(KPetAppColor, for: .selected)
            self.bgmView.addSubview(btn)
            btn.snp_makeConstraints { (make) in
                make.left.right.equalTo(0)
                make.height.equalTo(50*KFitHeightRate)
                make.top.equalTo(30*KFitHeightRate + 50*KFitHeightRate*CGFloat(index))
            }
            btn.addTarget(self, action: #selector(selectTimesAction), for: .touchUpInside)
            self.btnArray.append(btn)
            
            if index < 2 {
                let line = CBPetUtilsCreate.createLineView()
                line.backgroundColor = KPetLineColor
                self.bgmView.addSubview(line)
                line.snp_makeConstraints { (make) in
                    make.left.right.equalTo(0)
                    make.height.equalTo(1*KFitHeightRate)
                    make.top.equalTo(80*KFitHeightRate + 50*KFitHeightRate*CGFloat(index))
                }
            }
        }
    }
    public func popView() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    @objc private func dissmiss() {
        self.removeFromSuperview()
    }
    @objc private func selectTimesAction(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        for (index,btn) in self.btnArray.enumerated() {
            if sender.isSelected && sender == btn {
                btn.isSelected = true
                if self.punishmentBlock != nil {
                    self.punishmentBlock!("0",index+1)
                }
            } else {
                btn.isSelected = false
            }
        }
    }
    @objc private func cancelAction() {
        for btn:UIButton in self.btnArray {
            btn.isSelected = false
        }
        self.dissmiss()
    }
    @objc private func punishmentAction() {
        for (index,btn) in self.btnArray.enumerated() {
            if btn.isSelected == true {
                if self.punishmentBlock != nil {
                    self.punishmentBlock!("1",index+1)
                }
            }
        }
        self.dissmiss()
    }
    @objc private func audioAlarmAction() {
        for (index,btn) in self.btnArray.enumerated() {
            if btn.isSelected == true {
                if self.punishmentBlock != nil {
                    self.punishmentBlock!("2",index+1)
                }
            }
        }
        self.dissmiss()
    }
    func updatePunishmentData(model:CBPetHomeParamtersModel) {
        self.paramtersModel = model
        switch model.eshcok_interval {
        case "1":
            self.updateBtnArray(index: 0)
            break
        case "2":
            self.updateBtnArray(index: 1)
            break
        case "3":
            self.updateBtnArray(index: 2)
            break
        default:
            break
        }
    }
    private func updateBtnArray(index:Int) {
        for btn:UIButton in self.btnArray {
            if btn == self.btnArray[index] {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
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
