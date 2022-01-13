//
//  CBPetFuncInputView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/27.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncInputView: CBPetBaseView {

    private lazy var noteLeftLb:UILabel = {
        let lb = UILabel(text: "设置语音时长".localizedStr, textColor: KPet333333Color, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        return lb
    }()
    private lazy var middleLineView:UIView = {
        let lineV = CBPetUtilsCreate.createLineView()
        lineV.backgroundColor = KPetTextColor
        return lineV
    }()
    private lazy var noteRightLb:UILabel = {
        let lb = UILabel(text: "秒".localizedStr, textColor: KPet333333Color, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        return lb
    }()
    public lazy var inputTF:UITextField = {
        let tf = UITextField(text: "5", textColor: KPetAppColor, font: UIFont.init(name: CBPingFang_SC_Bold, size: 14*KFitHeightRate)!)
        tf.textAlignment = .center
        tf.isEnabled = false
        // 这句话一定要放在后面，否则会导致设置placeholder字体大小无效
        // 字体大小
//        tf.attributedPlaceholder = NSAttributedString.init(string:"5".localizedStr, attributes: [NSAttributedString.Key.font:UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!])
//        //字体颜色
//        tf.attributedPlaceholder = NSAttributedString.init(string:"5".localizedStr, attributes: [
//                    NSAttributedString.Key.foregroundColor:KPetPlaceholdColor])
        return tf
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
        let noteLeftStr = "设置语音时长".localizedStr
        let noteRightStr = "秒".localizedStr
        let note_leftWidth = noteLeftStr.getWidthText(text: noteLeftStr, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, height: 13*KFitHeightRate)
        let note_rightWidth = noteRightStr.getWidthText(text: noteRightStr, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, height: 13*KFitHeightRate)
        let padding_left_right = (270*KFitWidthRate - note_leftWidth - note_rightWidth - 44*KFitWidthRate - 8*2*KFitWidthRate)/2
        
        self.addSubview(self.noteLeftLb)
        self.noteLeftLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(padding_left_right)
            make.width.equalTo(note_leftWidth)
        }
        
        self.addSubview(self.middleLineView)
        self.middleLineView.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.noteLeftLb.snp_bottom).offset(1)
            make.left.equalTo(self.noteLeftLb.snp_right).offset(8*KFitWidthRate)
            make.size.equalTo(CGSize(width: 44*KFitWidthRate, height: 1))
        }

        self.addSubview(self.noteRightLb)
        self.noteRightLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-padding_left_right)
            make.width.equalTo(note_rightWidth)
        }

        self.addSubview(self.inputTF)
        self.inputTF.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self.noteLeftLb.snp_right).offset(8*KFitWidthRate)
            make.right.equalTo(self.noteRightLb.snp_left).offset(-8*KFitWidthRate)
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
