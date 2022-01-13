//
//  CBPetMsgCterTabCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/4.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetMsgCterTabCell: CBPetBaseTableViewCell {

    private lazy var iconImgeView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "pet_psnal_defaultAvatar")
        return imageView
    }()
    private lazy var badgeLb:UILabel = {
        let lb = UILabel(text: "99".localizedStr, textColor: UIColor.white, font: UIFont(name: CBPingFangSC_Regular, size: 10*KFitHeightRate)!,textAlignment: .center)
        lb.backgroundColor = UIColor.init().colorWithHexString(hexString: "#F8563B")
        return lb
    }()
    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "系统消息".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC_Bold, size: 14*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var textLb:UILabel = {
        let lb = UILabel(text: "133-2343-3432".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!,textAlignment: .left)
        lb.numberOfLines = 1
        return lb
    }()
    private lazy var timeLb:UILabel = {
        let lb = UILabel(text: "2020/5/4".localizedStr, textColor: KPet999999Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!,textAlignment: .right)
        return lb
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
        
        self.badgeLb.layer.masksToBounds = true
        self.badgeLb.layer.cornerRadius = 6*KFitHeightRate
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        self.bottomLineView.isHidden = false
    
        self.contentView.addSubview(self.iconImgeView)
        self.contentView.addSubview(self.badgeLb)
        self.contentView.addSubview(self.titleLb)
        self.contentView.addSubview(self.textLb)
        self.contentView.addSubview(self.timeLb)
        
        self.iconImgeView.snp_makeConstraints { (make) in
            make.top.equalTo(15*KFitHeightRate)
            make.bottom.equalTo(-15*KFitHeightRate)
            make.left.equalTo(20*KFitWidthRate)
            make.size.equalTo(CGSize(width: 44*KFitHeightRate, height: 44*KFitHeightRate))
        }

        self.badgeLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.iconImgeView.snp_top)
            make.right.equalTo(self.iconImgeView.snp_right)
            make.height.equalTo(12*KFitHeightRate)
            make.width.equalTo(12*KFitWidthRate)
        }
        self.titleLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.iconImgeView.snp_top)
            make.left.equalTo(self.iconImgeView.snp_right).offset(17*KFitWidthRate)
        }
        self.textLb.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.iconImgeView.snp_bottom)
            make.left.equalTo(self.iconImgeView.snp_right).offset(17*KFitWidthRate)
            make.right.equalTo(-40*KFitWidthRate)
        }
        self.timeLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.titleLb)
            make.right.equalTo(-20*KFitWidthRate)
        }
    }
    
    var msgCterModel = CBPetMsgCterModel() {
        didSet {
            self.bottomLineView.isHidden = false
            self.iconImgeView.image = UIImage(named: self.msgCterModel.iconImage ?? "")
            self.titleLb.text = self.msgCterModel.title
            self.textLb.text = self.msgCterModel.text
            self.timeLb.text = ""
            if let value = self.msgCterModel.add_time {
                if self.msgCterModel.title == "系统消息".localizedStr {
                    self.timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: value.valueStr, formateStr: "yyyy-MM-dd HH:mm:ss")
                } else {
                    if let valueTimeZone = CBPetHomeParamtersModel.getHomeParamters().timeZone {
                        self.timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: value.valueStr, formateStr: "yyyy-MM-dd HH:mm:ss",timeZone: Int(valueTimeZone) ?? 0)
                    }
                }
            }
            
            self.badgeLb.isHidden = false
            self.badgeLb.text = self.msgCterModel.countMessage
            var badgeWidth = "".getWidthText(text: self.msgCterModel.countMessage ?? "", font: UIFont(name: CBPingFangSC_Regular, size: 10*KFitHeightRate)!, height: 12*KFitHeightRate)
            if CGFloat(badgeWidth) < (12*KFitHeightRate) {
                badgeWidth = 12*KFitHeightRate
            } else {
                badgeWidth = badgeWidth + 8*KFitHeightRate
            }
            if Int(self.msgCterModel.countMessage ?? "0")! > 99 {
                self.badgeLb.text = "99+"
            } else if Int(self.msgCterModel.countMessage ?? "0")! <= 0 {
                self.badgeLb.isHidden = true
            }
            self.badgeLb.snp_updateConstraints { (make) in
                make.top.equalTo(self.iconImgeView.snp_top)
                make.right.equalTo(self.iconImgeView.snp_right)
                make.height.equalTo(12*KFitHeightRate)
                make.width.equalTo(badgeWidth)
            }
            if self.msgCterModel.title == "定位记录".localizedStr {
                self.bottomLineView.isHidden = true
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
