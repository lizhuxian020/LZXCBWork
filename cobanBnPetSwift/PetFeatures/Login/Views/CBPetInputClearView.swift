//
//  CBPetInputClearView.swift
//  cobanBnPetSwift
//
//  Created by zzer on 2022/11/17.
//  Copyright © 2022 coban. All rights reserved.
//

import UIKit

class CBPetInputClaerView: UIView {
    
    func setInputView(placeholder: String) {
        self.textTF.placeholder = placeholder
    }
    
    func startCountDown() {
        self.textBtn.isEnabled = false
        self.invalidTimer()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    var timer: Timer?
    var count: Int = 10
    
    lazy var contentView: UIView = {
        let v = UIView.init()
        v.backgroundColor = UIColor.white
        self.addSubview(v)
        return v
    }()
    
    lazy var textTF:UITextField = {
        let tf = UITextField(textColor: KPetTextColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, placeholder: "", placeholderColor: KPetPlaceholdColor, placeholderFont: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        self.contentView.addSubview(tf)
        return tf
    }()
    
    var showClear: Bool = true
    lazy var clearBtn: UIButton = {
        let btn = UIButton.init(imageName: "×")
        self.contentView.addSubview(btn)
        btn.addTarget(self, action: #selector(clickClearBtn), for: .touchUpInside)
        return btn
    }()
    
    var textBtnBlk: (()->Void)?
    var isSms: Bool = false
    lazy var textBtn: UIButton = {
        let btn = UIButton.init(title: "", titleColor: KPetAppColor, font: CBFont(12)!)
        self.contentView.addSubview(btn)
        btn.addTarget(self, action: #selector(clickTextBtn), for: .touchUpInside)
        btn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return btn
    }()
    
    //组件高度
    let contentHeight = 50*KFitHeightRate
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
    }
    
    
    convenience init(rightText: String?, clickBlk: (() -> Void)?) {
        self.init()
        self.textBtnBlk = clickBlk
        self.setUpRightView(rightText: rightText)
        self.setUpTF()
    }
    
    convenience init(isSms: Bool) {
        self.init()
        self.setupSMS()
    }
    
    private func setupContentView() {
        
        self.contentView.snp_makeConstraints { make in
            make.edges.equalTo(0)
            make.height.equalTo(contentHeight)
        }
        self.contentView.layer.cornerRadius = contentHeight/2
        
    }
    
    private func setUpTF() {
        
        self.textTF.snp_makeConstraints { make in
            make.top.bottom.equalTo(0)
            make.left.equalTo(10*KFitWidthRate)
            make.right.equalTo(
                self.showClear ? self.clearBtn.snp_left : self.textBtn.snp_left
            ).offset(-5*KFitWidthRate)
        }
    }
    
    private func setUpRightView(rightText: String?) {
        
        if let text = rightText {
            self.showClear = false
            self.textBtn.setTitle(text, for: .normal)
            self.textBtn.snp_makeConstraints { make in
                make.right.equalTo(-10*KFitWidthRate)
                make.centerY.equalTo(self.contentView)
            }
        } else {
            self.setupClearBtn()
        }
    }
    
    private func setupClearBtn() {
        self.clearBtn.backgroundColor = UIColor.white
        self.clearBtn.snp_makeConstraints { make in
            make.right.equalTo(-10*KFitWidthRate)
            make.centerY.equalTo(self.contentView)
            make.width.height.equalTo(contentHeight*2/3)
        }
    }
    
    private func setupSMS() {
        self.isSms = true;
        self.showClear = false
        self.textBtn.setTitle("获取验证码".localizedStr, for: .normal)
        self.textBtn.snp_makeConstraints { make in
            make.right.equalTo(-10*KFitWidthRate)
            make.centerY.equalTo(self.contentView)
        }
    }
    
    private func invalidTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc private func timerFired() {
        if self.count != 1 && self.count > 0 {
            self.textBtn.isEnabled = false
            self.count -= 1
            let text: String = "\("Retry in".localizedStr)\(self.count)s\("后重试".localizedStr)"
            self.textBtn.setTitleColor(RGB(r: 196, g: 196, b: 196), for: .normal)
            self.textBtn.setTitle(text, for: .normal)
        } else {
            self.textBtn.isEnabled = true
            self.invalidTimer()
            self.count = 10
            self.textBtn.setTitleColor(KPetAppColor, for: .normal)
            self.textBtn.setTitle("获取验证码".localizedStr, for: .normal)
        }
    }
    
    @objc private func clickClearBtn() {
        self.textTF.text = ""
    }
    
    @objc private func clickTextBtn() {
        self.textBtnBlk?()
    }
}
