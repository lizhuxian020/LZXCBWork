//
//  CBPetFuncUserManageHeadView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/30.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncUserManageHeadView: CBPetBaseView {

    private lazy var avatarImageView:UIImageView = {
        let imgV = UIImageView.init()
        imgV.layer.masksToBounds = true
        imgV.layer.cornerRadius = 26*KFitHeightRate
        imgV.backgroundColor = KPetAppColor
        return imgV
    }()
    private lazy var nameLb:UILabel = {
        let lb = UILabel(text: "C念念".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC_Bold, size: 14*KFitHeightRate)!)
        return lb
    }()
    private lazy var deviceNumbLb:UILabel = {
        let lb = UILabel(text: String(format: "%@%@", "设备IMEI：".localizedStr,"23131313232").localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFang_SC, size: 12*KFitHeightRate)!)
        return lb
    }()
    private lazy var closeBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(imageName: "pet_func_record_selected")
        return btn
    }()
   
    lazy var rigntArrowBtn:CBPetBaseButton = {
        let arrow = CBPetBaseButton(imageName: "pet_psnal_rightArrow")
        arrow.isUserInteractionEnabled = false
        return arrow
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        self.addSubview(self.avatarImageView)
        self.avatarImageView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(20*KFitWidthRate)
            make.size.equalTo(CGSize(width: 52*KFitHeightRate, height: 52*KFitHeightRate))
        }
        
        self.addSubview(self.nameLb)
        self.nameLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.avatarImageView.snp_top).offset(0*KFitHeightRate)
            make.left.equalTo(self.avatarImageView.snp_right).offset(15*KFitWidthRate)
        }
        
        self.addSubview(self.deviceNumbLb)
        self.deviceNumbLb.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.avatarImageView.snp_bottom).offset(0*KFitHeightRate)
            make.left.equalTo(self.avatarImageView.snp_right).offset(15*KFitWidthRate)
        }
        
        let imgRight = UIImage.init(named: "pet_psnal_rightArrow")
        self.addSubview(self.rigntArrowBtn)
        self.rigntArrowBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-30*KFitWidthRate)
            make.size.equalTo(CGSize.init(width: (imgRight?.size.width)!, height: (imgRight?.size.height)!))
        }

        
        avatarImageView.sd_setImage(with: URL.init(string: CBPetHomeInfoTool.getHomeInfo().pet.photo ?? ""), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
        nameLb.text = CBPetHomeInfoTool.getHomeInfo().pet.name
        deviceNumbLb.text = String(format: "%@%@", "设备".localizedStr + "IMEI:",CBPetHomeInfoTool.getHomeInfo().devUser.imei ?? "")
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
