//
//  CBPetPsnalCenterHeadTabCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/3.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetPsnalCenterHeadTabCell: CBPetBaseTableViewCell {

    private lazy var avtarImgeView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12*KFitHeightRate
        imageView.image = UIImage.init(named: "pet_psnal_defaultAvatar")
        return imageView
    }()
    private lazy var userNameLb:UILabel = {
        let lb = UILabel(text: "".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC_Bold, size: 18*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var arrowBtn:CBPetBaseButton = {
        let arrow = CBPetBaseButton()
        return arrow
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        super.setupViewModel(viewModel: viewModel)
        self.viewModel = viewModel
        if self.viewModel is CBPetPsnalCterViewModel {
            let vvModel = self.viewModel as! CBPetPsnalCterViewModel
            vvModel.psnlUpdateDataBlock = { [weak self] (type:CBPetPsnalCterUpdType,userInfoModelTemp:Any) -> Void in
                if type == .userInfo {
                    let userInfoModel = userInfoModelTemp as! CBPetUserInfoModel
                    self?.userNameLb.text = userInfoModel.name
                    self?.avtarImgeView.sd_setImage(with: URL.init(string: userInfoModel.photo ?? "pet_psnal_defaultAvatar"), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
                }
            }
        }
        self.updateUserInfo()
    }
    /* 从本地取*/
    private func updateUserInfo() {
        let userInfoModel = CBPetUserInfoModelTool.getUserInfo()
        self.userNameLb.text = userInfoModel.name
        self.avtarImgeView.sd_setImage(with: URL.init(string: userInfoModel.photo ?? ""), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        self.bottomLineView.isHidden = false
        self.rigntArrowBtn.isHidden = false
        //self.rigntArrowBtn.addTarget(self, action: #selector(toPsnalPage), for: .touchUpInside)
        
        self.contentView.addSubview(self.arrowBtn)
        self.arrowBtn.addTarget(self, action: #selector(toPsnalPage), for: .touchUpInside)
        self.arrowBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(-30*KFitWidthRate)
            make.size.equalTo(CGSize.init(width: 120, height: 100*KFitHeightRate))
        }
        
        self.contentView.addSubview(self.avtarImgeView)
        self.addSubview(self.userNameLb)
        
        self.avtarImgeView.snp_makeConstraints { (make) in
            make.top.equalTo(20*KFitHeightRate)
            make.bottom.equalTo(-20*KFitHeightRate)
            make.left.equalTo(30*KFitWidthRate)
            make.size.equalTo(CGSize(width: 72*KFitHeightRate, height: 72*KFitHeightRate))
        }
        self.userNameLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self.avtarImgeView.snp_right).offset(13*KFitWidthRate)
            make.right.equalTo(-40*KFitWidthRate)
        }
    }
    
    @objc private func toPsnalPage() {
        if self.viewModel is CBPetPsnalCterViewModel {
            guard (self.viewModel as! CBPetPsnalCterViewModel).psnlCterClickBlock == nil else {
                (self.viewModel as! CBPetPsnalCterViewModel).psnlCterClickBlock!(.psnaInfo,"")
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
