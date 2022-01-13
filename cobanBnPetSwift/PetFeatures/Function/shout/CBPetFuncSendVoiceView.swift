//
//  CBPetFuncSendVoiceView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/2.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncSendVoiceView: CBPetBaseView {

    private lazy var voiceImageView:UIImageView = {
        let imgView = UIImageView.init()
        let voiceImage_white = UIImage.init(named: "pet_function_voice_white")!
        let voiceImage_press = UIImage.init(named: "pet_function_voice_pres")!
        imgView.image = voiceImage_white
        imgView.animationImages = [voiceImage_press,voiceImage_white]
        imgView.animationDuration = 1.0
        imgView.animationRepeatCount = 0
        return imgView
    }()
    public lazy var titleLb:UILabel = {
        let lb = UILabel(text: "0:00", textColor: UIColor.white, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    public lazy var notelb:UILabel = {
        let lb = UILabel(text: "手指上滑，取消发送".localizedStr, textColor: UIColor.white, font: UIFont.init(name: CBPingFangSC_Regular, size: 10*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        self.addSubview(self.voiceImageView)
        let voiceImage_white = UIImage.init(named: "pet_function_voice_white")!
        self.voiceImageView.snp_makeConstraints { (make) in
            make.top.equalTo(20*KFitHeightRate)
            make.centerX.equalTo(self.snp_centerX)
            make.size.equalTo(CGSize(width: voiceImage_white.size.width, height: voiceImage_white.size.height))
        }
        self.voiceImageView.startAnimating()
        
        self.addSubview(self.titleLb)
        self.titleLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.voiceImageView.snp_bottom).offset(6*KFitHeightRate)
            make.centerX.equalTo(self.snp_centerX)
        }
        
        self.addSubview(self.notelb)
        self.notelb.snp_makeConstraints { (make) in
            make.bottom.equalTo(-20*KFitHeightRate)
            make.centerX.equalTo(self.snp_centerX)
        }
    }
    func normalSendVoiceUI() {
        self.voiceImageView.startAnimating()
        self.notelb.text = "手指上滑，取消发送".localizedStr
        self.notelb.textColor = UIColor.white
    }
    func cancelSendVoiceUI() {
        self.voiceImageView.stopAnimating()
        self.voiceImageView.image = UIImage(named: "pet_function_shouting_cancel")
        self.notelb.text = "松开手指，取消发送".localizedStr
        self.notelb.textColor = UIColor.init().colorWithHexString(hexString: "#F8563B")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
