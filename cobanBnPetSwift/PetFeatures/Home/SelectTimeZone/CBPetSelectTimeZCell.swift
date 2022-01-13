//
//  CBPetSelectTimeZCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/6.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetSelectTimeZCell: UICollectionViewCell {
    
    public lazy var textBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: " +12.5 ", titleColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, borderWidth: 0.5*KFitHeightRate, borderColor: KPetLineColor, cornerRadius: 4*KFitHeightRate)
        btn.titleLabel?.textAlignment = .center
        
        return btn
    }()
    var clickReturnBlock:((_ sender:CBPetBaseButton) ->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        self.backgroundColor = UIColor.white
        self.addSubview(self.textBtn)
        self.textBtn.snp_makeConstraints { (make) in
            make.top.equalTo(15*KFitHeightRate)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0*KFitHeightRate)
        }
        self.textBtn.addTarget(self, action: #selector(btnClickMethod), for: .touchUpInside)
    }
    @objc private func btnClickMethod(sender:CBPetBaseButton) {
        guard self.clickReturnBlock == nil else {
            self.clickReturnBlock!(sender)
            return
        }
    }
}
