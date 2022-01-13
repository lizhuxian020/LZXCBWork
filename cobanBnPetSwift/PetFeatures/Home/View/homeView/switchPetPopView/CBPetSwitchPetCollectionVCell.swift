//
//  CBPetSwitchPetCollectionVCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/26.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetSwitchPetCollectionVCell: UICollectionViewCell {
    private lazy var imgeView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 26*KFitHeightRate
        imageView.image = UIImage.init(named: "pet_switchPet_addPet")
        return imageView
    }()
    private lazy var textLb:UILabel = {
        let lb = UILabel(text: "新增".localizedStr, textColor: KPetTextColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, textAlignment: .center)
        lb.numberOfLines = 1
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
        
        self.addSubview(self.imgeView)
        self.imgeView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(20*KFitHeightRate)
            make.size.equalTo(CGSize(width: 52*KFitHeightRate, height: 52*KFitHeightRate))
        }
        self.addSubview(self.textLb)
        self.textLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.imgeView.snp_bottom).offset(10*KFitHeightRate)
            make.centerX.equalTo(self)
            make.left.right.equalTo(0)
        }
    }
    var psnalCterPetModel:CBPetPsnalCterPetModel = CBPetPsnalCterPetModel() {
        didSet {
            if self.psnalCterPetModel.title?.isEmpty == false {
                textLb.text = "添加"
                imgeView.image = UIImage.init(named: "pet_switchPet_addPet")
            } else {
                textLb.text = (self.psnalCterPetModel.pet.name != nil) ? self.psnalCterPetModel.pet.name : "未知"
                imgeView.sd_setImage(with: URL.init(string: self.psnalCterPetModel.pet.photo ?? ""), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
            }
        }
    }
}
