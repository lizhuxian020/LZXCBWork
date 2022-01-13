//
//  CBPetAvatarMarkView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/7/30.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetAvatarMarkView: CBPetBaseView {
    
    public var defaultImageView:UIImageView = {
        let img = UIImage.init(named: "pet_mapAvatar_default")!
        let imgV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: img.size.width, height: img.size.height))
        imgV.isUserInteractionEnabled = false
        imgV.image = img
        return imgV
    }()
    private var avtarImgView:UIImageView = {
        let img = UIImage.init(named: "pet_mapAvatar_default")!
        let imgV = UIImageView.init()
        imgV.isUserInteractionEnabled = true;
        imgV.layer.masksToBounds = true;
        imgV.layer.cornerRadius = (img.size.width - 12)/2;
        imgV.contentMode = .scaleAspectFit;
        return imgV
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    private func setupView() {
        self.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.00)
        let img = UIImage.init(named: "pet_mapAvatar_default")!
        self.bounds = CGRect.init(x: 0, y: 0, width: img.size.width, height: img.size.height)
        self.addSubview(self.defaultImageView)
        self.defaultImageView.addSubview(self.avtarImgView)
        self.avtarImgView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.defaultImageView.snp_centerX)
            make.top.equalTo(self.defaultImageView.snp_top).offset(6)
            make.size.equalTo(CGSize.init(width: img.size.width-12, height: img.size.width-12))
        }
    }
    func updateIconImage(iconImage:UIImage) {
        self.avtarImgView.image = iconImage
    }
    func updateHomeInfoModel(homeModel:CBPetHomeInfoModel) {
        switch homeModel.pet.device.online {
        case "0":
            self.defaultImageView.image = UIImage(named: "pet_mapAvatar_default_offlineV2")!
            break
        case "1":
            self.defaultImageView.image = UIImage(named: "pet_mapAvatar_defaultV2")!
            break
        case "2":
            self.defaultImageView.image = UIImage(named: "pet_mapAvatar_default_alarmV2")!
            break
        default:
            break
        }
    }
    func updateNearPetsInfo(model:CBPetFuncNearPetModel) {
        self.avtarImgView.sd_setImage(with: URL.init(string: model.photo ?? ""), placeholderImage: UIImage(named: ""), options: [])
        self.defaultImageView.image = UIImage(named: "pet_mapAvatar_default")!
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            if value.valueStr == model.device.imei {
                self.defaultImageView.image = UIImage(named: "pet_mapAvatar_defaultV2")!
            } else {
                self.defaultImageView.image = UIImage(named: "pet_mapAvatar_nearby")!
            }
        }
    }
}
