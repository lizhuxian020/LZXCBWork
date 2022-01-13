//
//  CBPetChatPetfriendCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/30.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetChatPetfriendCell: CBPetBaseTableViewCell {

    private lazy var avatarImageView:UIImageView = {
        let imgV = UIImageView.init()
        imgV.layer.masksToBounds = true
        imgV.layer.cornerRadius = 4*KFitHeightRate
        //imgV.backgroundColor = KPetAppColor
        imgV.contentMode = .scaleAspectFit
        return imgV
    }()
    private lazy var nameLb:UILabel = {
        let lb = UILabel(text: "录音1".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!)
        return lb
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
    
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        self.bottomLineView.isHidden = false
        
        self.addSubview(self.avatarImageView)
        self.avatarImageView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(20*KFitWidthRate)
            make.size.equalTo(CGSize(width: 36*KFitHeightRate, height: 36*KFitHeightRate))
            make.top.equalTo(8*KFitHeightRate)
            make.bottom.equalTo(-8*KFitHeightRate)
        }
        
        self.addSubview(self.nameLb)
        self.nameLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.avatarImageView)
            make.left.equalTo(self.avatarImageView.snp_right).offset(12*KFitWidthRate)
        }
    }
    var petFriendModel:CBPetFuncPetFriendsModel = CBPetFuncPetFriendsModel() {
        didSet {
            self.avatarImageView.sd_setImage(with: URL.init(string: petFriendModel.photo ?? ""), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
            self.nameLb.text = petFriendModel.name
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
