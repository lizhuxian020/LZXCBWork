//
//  CBPetSwitchSystemTabCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/7/13.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetSwitchSystemTabCell: CBPetBaseTableViewCell {
    
    private lazy var bgmView:UIView = {
        let vv = UIView.init()
        return vv
    }()
    private lazy var iconImgeView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "pet_psnal_defaultAvatar")
        return imageView
    }()
    private lazy var nameLb:UILabel = {
        let lb = UILabel(text: "".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var statusBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(imageName: "pet_switch_unselect")
        btn.setImage(UIImage(named: "pet_switch_select"), for: .selected)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bgmView.setViewShadow(backgroundColor: UIColor.white, cornerRadius: 16*KFitHeightRate, shadowColor: KPetC8C8C8Color, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 4), shadowRadius: 8)
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
    
        self.addSubview(self.bgmView)
        self.bgmView.addSubview(self.iconImgeView)
        self.bgmView.addSubview(self.nameLb)
        self.bgmView.addSubview(self.statusBtn)
        
        self.bgmView.snp_makeConstraints { (make) in
            make.top.equalTo(12*KFitHeightRate)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH-40*KFitWidthRate, height: 108*KFitHeightRate))
            make.bottom.equalTo(-12*KFitHeightRate)
        }
        self.iconImgeView.snp_makeConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 60*KFitHeightRate, height: 60*KFitHeightRate))
        }

        self.nameLb.snp_makeConstraints { (make) in
            make.left.equalTo(self.iconImgeView.snp_right).offset(18*KFitWidthRate)
            make.centerY.equalTo(self)
        }
        
        let image = UIImage(named: "pet_switch_unselect")!
        self.statusBtn.snp_makeConstraints { (make) in
            make.right.equalTo(-20*KFitWidthRate)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: image.size.width, height: image.size.height))
        }
    }
    
    var switchSystemModel = CBPetSwitchSystemModel() {
        didSet {
            self.iconImgeView.image = UIImage(named: self.switchSystemModel.iconImage ?? "")
            self.nameLb.text = self.switchSystemModel.title
            self.statusBtn.isSelected = self.switchSystemModel.status
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
