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
        let lb = UILabel(text: "新增".localizedStr, textColor: KPetTextColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!, textAlignment: .left)
        lb.numberOfLines = 1
        return lb
    }()
    private var checkImgView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "pet_func_record_selected")
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        
        self.backgroundColor = UIColor.clear
        
        self.addSubview(self.imgeView)
        self.imgeView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 52*KFitHeightRate, height: 52*KFitHeightRate))
        }
        
        self.addSubview(self.checkImgView)
        self.checkImgView.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 12*KFitHeightRate, height: 12*KFitHeightRate))
            make.right.equalTo(-5*KFitWidthRate)
        }
        self.addSubview(self.textLb)
        self.textLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(5*KFitWidthRate)
            make.right.equalTo(self.checkImgView.snp_left).offset(-5*KFitWidthRate)
        }
    }
    var psnalCterPetModel:CBPetPsnalCterPetModel = CBPetPsnalCterPetModel() {
        didSet {
            if self.psnalCterPetModel.title?.isEmpty == false {
                textLb.isHidden = true
                checkImgView.isHidden = textLb.isHidden
                imgeView.isHidden = !textLb.isHidden
                imgeView.image = UIImage.init(named: "pet_switchPet_addPet")
            } else {
                textLb.isHidden = false
                checkImgView.isHidden = !self.psnalCterPetModel.isHomeSelectedPet
                imgeView.isHidden = !textLb.isHidden
                textLb.text = (self.psnalCterPetModel.pet.name != nil) ? self.psnalCterPetModel.pet.name : "未知"
//                imgeView.sd_setImage(with: URL.init(string: self.psnalCterPetModel.pet.photo ?? ""), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
            }
        }
    }
}
