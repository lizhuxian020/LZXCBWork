//
//  CBPetChatPetMessageCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/30.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetChatPetMessageCell: CBPetBaseTableViewCell {

    private lazy var avatarImageView:UIImageView = {
        let imgV = UIImageView.init()
        imgV.layer.masksToBounds = true
        imgV.layer.cornerRadius = 6*KFitHeightRate
        imgV.backgroundColor = KPetAppColor
        return imgV
    }()
    private lazy var unReadCountLb:UILabel = {
        let lb = UILabel(text: "".localizedStr, textColor: UIColor.white, font: UIFont(name: CBPingFang_SC_Bold, size: 12*KFitHeightRate)!)
        lb.backgroundColor = UIColor.red
        lb.layer.masksToBounds = true
        lb.layer.cornerRadius = 8
        lb.textAlignment = .center
        return lb
    }()
    private lazy var nameLb:UILabel = {
        let lb = UILabel(text: "Cherry".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC_Bold, size: 14*KFitHeightRate)!)
        return lb
    }()
    private lazy var msgLb:UILabel = {
        let lb = UILabel(text: "有时间吗？一起去遛狗？".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFang_SC, size: 12*KFitHeightRate)!)
        return lb
    }()
    private lazy var timeLb:UILabel = {
        let lb = UILabel(text: "09:36".localizedStr, textColor: KPet999999Color, font: UIFont(name: CBPingFang_SC, size: 12*KFitHeightRate)!)
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
        
        self.contentView.addSubview(self.avatarImageView)
        self.avatarImageView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(20*KFitWidthRate)
            make.size.equalTo(CGSize(width: 44*KFitHeightRate, height: 44*KFitHeightRate))
            make.top.equalTo(17*KFitHeightRate)
            make.bottom.equalTo(-17*KFitHeightRate)
        }
        
        
        self.contentView.addSubview(self.unReadCountLb)
        self.unReadCountLb.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.avatarImageView.snp_right).offset(-2*KFitHeightRate)
            make.centerY.equalTo(self.avatarImageView.snp_top).offset(2*KFitWidthRate)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        self.contentView.addSubview(self.nameLb)
        self.nameLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.avatarImageView.snp_top).offset(0*KFitHeightRate)
            make.left.equalTo(self.avatarImageView.snp_right).offset(15*KFitWidthRate)
        }
        
        self.contentView.addSubview(self.msgLb)
        self.msgLb.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.avatarImageView.snp_bottom).offset(0*KFitHeightRate)
            make.left.equalTo(self.avatarImageView.snp_right).offset(15*KFitWidthRate)
        }
        
        self.contentView.addSubview(self.timeLb)
        self.timeLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.nameLb)
            make.right.equalTo(-20*KFitWidthRate)
        }
    }
    var petFriendMsgModel:CBPetFuncPetFriendsMsgModel = CBPetFuncPetFriendsMsgModel() {
        didSet {
            self.avatarImageView.sd_setImage(with: URL.init(string: petFriendMsgModel.photo ?? ""), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
            self.timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: petFriendMsgModel.add_time ?? "0", formateStr: "yyyy-MM-dd HH:mm:ss")
            self.nameLb.text = petFriendMsgModel.name
            /// 解码
            //self.petFriendMsgModel.message_text = self.petFriendMsgModel.message_text?.removingPercentEncoding
            if let value = petFriendMsgModel.message_text {
                self.msgLb.text = value
            } else {
                self.msgLb.text = "收到语音消息".localizedStr
            }
            self.unReadCountLb.text = petFriendMsgModel.unReadCount
            self.unReadCountLb.isHidden = (Int(petFriendMsgModel.unReadCount ?? "0") ?? 0) > 0 ? false : true
        }
    } ///010-51376750
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
