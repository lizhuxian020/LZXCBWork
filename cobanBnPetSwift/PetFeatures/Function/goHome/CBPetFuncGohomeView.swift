//
//  CBPetFuncGohomeView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/27.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncGohomeView: CBPetBaseView {

    private lazy var bgmView:UIView = {
        let bgmV = UIView.init()
        bgmV.backgroundColor = UIColor.white
        bgmV.layer.masksToBounds = true
        bgmV.layer.cornerRadius = 16*KFitHeightRate
        return bgmV
    }()
    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "您暂未设置回家录音指令，".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC, size: 12*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    private lazy var toRecordBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "请前往录音 ...".localizedStr, titleColor: KPetAppColor, font: UIFont(name: CBPingFang_SC, size: 12*KFitHeightRate)!)
        return btn
    }()
    private lazy var comfirmBtn:UIButton = {
        let btn = UIButton(title: "我知道了".localizedStr, titleColor: KPetAppColor, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!)
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    private func setupView() {
        self.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.85)
        
        self.addSubview(self.bgmView)
        self.bgmView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 270*KFitWidthRate, height: 140*KFitHeightRate))
        }
        
        self.addSubview(self.titleLb)
        self.titleLb.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.bgmView.snp_centerX)
            make.top.equalTo(self.bgmView.snp_top).offset(32*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(10*KFitWidthRate)
            make.right.equalTo(self.bgmView.snp_right).offset(-10*KFitWidthRate)
        }
        
        self.addSubview(self.toRecordBtn)
        self.toRecordBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.bgmView.snp_centerX)
            make.top.equalTo(self.titleLb.snp_bottom).offset(10*KFitHeightRate)
        }
        self.toRecordBtn.addTarget(self, action: #selector(toRecordClick), for: .touchUpInside)
        
        let lineView = CBPetUtilsCreate.createLineView()
        lineView.backgroundColor = KPetLineColor
        self.addSubview(lineView)
        lineView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.bgmView)
            make.height.equalTo(1)
            make.bottom.equalTo(self.bgmView.snp_bottom).offset(-44*KFitHeightRate)
        }
        
        self.addSubview(self.comfirmBtn)
        self.comfirmBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.bgmView.snp_centerX)
            make.bottom.equalTo(self.bgmView.snp_bottom).offset(0)
            make.size.equalTo(CGSize(width: 270*KFitWidthRate, height: 44*KFitHeightRate))
        }
        self.comfirmBtn.addTarget(self, action: #selector(comfirmClick), for: .touchUpInside)
    }
    public func popView() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    @objc private func dissmiss() {
        self.removeFromSuperview()
    }
    @objc private func toRecordClick() {
        guard (self.viewModel as! CBPetHomeViewModel).toRecordBlock == nil else {
            (self.viewModel as! CBPetHomeViewModel).toRecordBlock!()
            self.dissmiss()
            return
        }
    }
    @objc private func comfirmClick() {
        self.dissmiss()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
