//
//  CBPetSetFenceInputView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/6.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetSetFenceInputView: CBPetBaseView {

    private lazy var noteLeftLb:UILabel = {
        let lb = UILabel(text: "围栏半径:".localizedStr, textColor: KPet333333Color, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        return lb
    }()
    private lazy var middleLineView:UIView = {
        let lineV = CBPetUtilsCreate.createLineView()
        lineV.backgroundColor = KPetTextColor
        return lineV
    }()
    private lazy var noteRightLb:UILabel = {
        let lb = UILabel(text: "米（默认值100）".localizedStr, textColor: KPet333333Color, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        return lb
    }()
    public lazy var inputTF:UITextField = {
        let tf = UITextField(text: "100", textColor: KPetAppColor, font: UIFont.init(name: CBPingFang_SC_Bold, size: 14*KFitHeightRate)!)
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
        self.addSubview(self.noteLeftLb)
        self.noteLeftLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(20*KFitWidthRate)
        }
        
        self.addSubview(self.middleLineView)
        self.middleLineView.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.noteLeftLb.snp_bottom).offset(1)
            make.left.equalTo(self.noteLeftLb.snp_right).offset(8*KFitWidthRate)
            make.size.equalTo(CGSize(width: 80*KFitWidthRate, height: 1))
        }

        self.addSubview(self.noteRightLb)
        self.noteRightLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self.middleLineView.snp_right).offset(10*KFitWidthRate)
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
