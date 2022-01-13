//
//  CBPetNoRecordingView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/28.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetNoRecordingView: CBPetBaseView {

    private lazy var noteLb:UILabel = {
        let lb = UILabel(text: "暂无录音选择，".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    private lazy var addRecordingBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "请点击添加录音".localizedStr, titleColor: KPetAppColor, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!)
        return btn
    }()
    private lazy var addRecordingPopView:CBPetAddRecordingPopView = {
        let popV = CBPetAddRecordingPopView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return popV
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        self.backgroundColor = UIColor.white
        
        let note_str = "暂无录音选择，".localizedStr
        let addRecording_str = "请点击添加录音".localizedStr
        let note_width = note_str.getWidthText(text: note_str, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!, height: 15*KFitHeightRate)
        let btn_width = addRecording_str.getWidthText(text: addRecording_str, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!, height: 15*KFitHeightRate)
        let padding = (SCREEN_WIDTH - note_width - btn_width)/2
        self.addSubview(self.noteLb)
        self.noteLb.snp_makeConstraints { (make) in
            make.top.equalTo(CGFloat(NavigationBarHeigt) + 60*KFitHeightRate)
            make.left.equalTo(padding)
        }
        
        self.addSubview(self.addRecordingBtn)
        self.addRecordingBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.noteLb)
            make.left.equalTo(self.noteLb.snp_right).offset(0)
        }
        self.addRecordingBtn.addTarget(self, action: #selector(addReordingClick), for: .touchUpInside)
    }
    
    @objc private func addReordingClick() {
        self.addRecordingPopView.popView()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
