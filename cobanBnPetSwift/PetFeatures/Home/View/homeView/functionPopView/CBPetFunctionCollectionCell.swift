//
//  CBPetFunctionCollectionCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/26.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFunctionCollectionCell: UICollectionViewCell {
    public lazy var iconImgeView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20*KFitHeightRate
        imageView.image = UIImage.init(named: "pet_switchPet_addPet")
        return imageView
    }()
    public lazy var textLb:UILabel = {
        let lb = UILabel(text: "新增".localizedStr, textColor: KPet333333Color, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.iconImgeView)
        self.iconImgeView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(0*KFitHeightRate)
            make.size.equalTo(CGSize(width: 40*KFitHeightRate, height: 40*KFitHeightRate))
        }
        self.addSubview(self.textLb)
        self.textLb.snp_makeConstraints { (make) in
            make.bottom.equalTo(-10*KFitHeightRate)
            make.centerX.equalTo(self)
        }
    }
}
