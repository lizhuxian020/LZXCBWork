//
//  CBPetFuncUserManagerCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/30.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncUserManagerCell: CBPetBaseTableViewCell {

    private lazy var avatarImageView:UIImageView = {
        let imgV = UIImageView.init()
        imgV.layer.masksToBounds = true
        imgV.layer.cornerRadius = 6*KFitHeightRate
        imgV.backgroundColor = KPetAppColor
        return imgV
    }()
    private lazy var nameLb:UILabel = {
        let lb = UILabel(text: "Cherry".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC_Bold, size: 14*KFitHeightRate)!)
        return lb
    }()
    private lazy var markLb:UILabel = {
        let lb = UILabel(text: "Cherry".localizedStr, textColor: UIColor.white, font: UIFont(name: CBPingFang_SC_Bold, size: 10*KFitHeightRate)!,textAlignment: .center)
        lb.backgroundColor = UIColor.init().colorWithHexString(hexString: "#F8BC3C")
        lb.layer.masksToBounds = true
        lb.layer.cornerRadius = 4*KFitHeightRate
        return lb
    }()
    private lazy var mineLb:UILabel = {
        let lb = UILabel(text: "Cherry".localizedStr, textColor: UIColor.white, font: UIFont(name: CBPingFang_SC_Bold, size: 10*KFitHeightRate)!,textAlignment: .center)
        lb.backgroundColor = UIColor.init().colorWithHexString(hexString: "#F8BC3C")
        lb.layer.masksToBounds = true
        lb.layer.cornerRadius = 4*KFitHeightRate
        return lb
    }()
    private lazy var phoneLb:UILabel = {
        let lb = UILabel(text: "13654219541".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFang_SC, size: 12*KFitHeightRate)!)
        return lb
    }()
    private lazy var closeBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(imageName: "pet_closeIcon")
        btn.isHidden = true
        return btn
    }()
    var setTitleStr:String = String.init() {
        didSet {
            self.nameLb.text = self.setTitleStr
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        self.bottomLineView.isHidden = false
        
        self.addSubview(self.avatarImageView)
        self.avatarImageView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(20*KFitWidthRate)
            make.size.equalTo(CGSize(width: 44*KFitHeightRate, height: 44*KFitHeightRate))
        }
        
        self.addSubview(self.nameLb)
        self.nameLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.avatarImageView.snp_top).offset(0*KFitHeightRate)
            make.left.equalTo(self.avatarImageView.snp_right).offset(15*KFitWidthRate)
        }
        self.addSubview(self.markLb)
        self.markLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.nameLb)
            make.left.equalTo(self.nameLb.snp_right).offset(8*KFitWidthRate)
            make.size.equalTo(CGSize(width: 40*KFitWidthRate, height: 15*KFitHeightRate))
        }
        self.addSubview(self.mineLb)
        self.mineLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.nameLb)
            make.left.equalTo(self.markLb.snp_right).offset(8*KFitWidthRate)
            make.size.equalTo(CGSize(width: 20*KFitWidthRate, height: 15*KFitHeightRate))
        }
        
        self.addSubview(self.phoneLb)
        self.phoneLb.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.avatarImageView.snp_bottom).offset(0*KFitHeightRate)
            make.left.equalTo(self.avatarImageView.snp_right).offset(15*KFitWidthRate)
        }
        
        self.contentView.addSubview(self.closeBtn)
        let checkImage = UIImage.init(named: "pet_closeIcon")!
        self.closeBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-20*KFitWidthRate)
            make.size.equalTo(CGSize(width: checkImage.size.width, height: checkImage.size.height))
        }
        self.closeBtn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
    }
    var userManageModel = CBPetUserManageModel() {
        didSet {
            avatarImageView.sd_setImage(with: URL.init(string: userManageModel.user.photo ?? ""), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
            nameLb.text = userManageModel.user.name ?? ""
            markLb.text = "管理员".localizedStr
            mineLb.text = "我".localizedStr
            phoneLb.text = userManageModel.user.phone ?? ""
            //if CBPetHomeInfoTool.getHomeInfo().devUser.isAdmin == "1" && CBPetHomeInfoTool.getHomeInfo().devUser.user.id == userManageModel.user.id {
            if userManageModel.isAdmin == "1" && CBPetHomeInfoTool.getHomeInfo().devUser.user.id == userManageModel.user.id {
            /* 是管理员，且是当前用户*/
                markLb.isHidden = false
                mineLb.isHidden = false
                self.markLb.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self.nameLb)
                    make.left.equalTo(self.nameLb.snp_right).offset(8*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 40*KFitWidthRate, height: 15*KFitHeightRate))
                }
                self.mineLb.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self.nameLb)
                    make.left.equalTo(self.markLb.snp_right).offset(8*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 20*KFitWidthRate, height: 15*KFitHeightRate))
                }
            } else if userManageModel.isAdmin == "1" {
            //else if CBPetHomeInfoTool.getHomeInfo().devUser.isAdmin == "1" && userManageModel.isAdmin == "1" {
            /* 管理员*/
                markLb.isHidden = false
                mineLb.isHidden = true
                self.markLb.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self.nameLb)
                    make.left.equalTo(self.nameLb.snp_right).offset(8*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 40*KFitWidthRate, height: 15*KFitHeightRate))
                }
                self.mineLb.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self.nameLb)
                    make.left.equalTo(self.markLb.snp_right).offset(8*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0*KFitWidthRate, height: 15*KFitHeightRate))
                }
            } else if CBPetLoginModelTool.getUser()?.uid == userManageModel.user.id {
            /* 当前登录账号,是当前用户*/
                markLb.isHidden = true
                mineLb.isHidden = false
                self.markLb.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self.nameLb)
                    make.left.equalTo(self.nameLb.snp_right).offset(0*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0*KFitWidthRate, height: 15*KFitHeightRate))
                }
                self.mineLb.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self.nameLb)
                    make.left.equalTo(self.markLb.snp_right).offset(8*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 20*KFitWidthRate, height: 15*KFitHeightRate))
                }
            } else {
            /* 与当前登录账号无关,普通用户*/
                markLb.isHidden = true
                mineLb.isHidden = true
                self.markLb.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self.nameLb)
                    make.left.equalTo(self.nameLb.snp_right).offset(8*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 40*KFitWidthRate, height: 15*KFitHeightRate))
                }
                self.mineLb.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self.nameLb)
                    make.left.equalTo(self.markLb.snp_right).offset(8*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 20*KFitWidthRate, height: 15*KFitHeightRate))
                }
            }
            if CBPetHomeInfoTool.getHomeInfo().devUser.isAdmin == "1" {
                /* 当前用户管理员 是管理员可操作*/
                self.closeBtn.isHidden = false
            } else {
                self.closeBtn.isHidden = true
            }
        }
    }
    @objc private func closeClick() {
        
        if self.viewModel is CBPetUserManageViewModel {
            let vvModel = self.viewModel as! CBPetUserManageViewModel
            guard vvModel.userManageDeleteUserManageBlock == nil else {
                vvModel.userManageDeleteUserManageBlock!(self.userManageModel)
                return
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
