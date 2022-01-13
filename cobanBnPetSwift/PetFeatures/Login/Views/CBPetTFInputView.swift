//
//  CBPetTFInputView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/18.
//  Copyright © 2020 coban. All rights reserved.
//
//        for str in UIFont.familyNames {
//            //print("%@",str)
//            print("======:\(str)")
//        }

import UIKit

class CBPetTFInputView: CBPetBaseView {

    lazy var titleLb:UILabel = {
        let lb = UILabel(text: "", textColor: KPetTextColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!)
        self.addSubview(lb)
        return lb
    }()
    lazy var textTF:UITextField = {
        let tf = UITextField(textColor: KPetTextColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, placeholder: "", placeholderColor: KPetPlaceholdColor, placeholderFont: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        self.addSubview(tf)
        return tf
    }()
    lazy var lineView:UIView = {
        let lb = CBPetUtilsCreate.createLineView()
        lb.backgroundColor = KPetLineColor
        self.addSubview(lb)
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        self.backgroundColor = UIColor.white
        self.titleLb.snp_makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH,height: 20))
        }
        self.lineView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(1)
        }
        self.textTF.snp_makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(self.titleLb.snp_bottom).offset(0)
            make.bottom.equalTo(0)
        }
    }
    func setInputView(title:String,placeholdStr:String) {
        self.titleLb.text = title
        self.textTF.placeholder = placeholdStr
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
