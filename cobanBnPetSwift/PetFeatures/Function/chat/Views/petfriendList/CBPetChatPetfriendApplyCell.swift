//
//  CBPetChatPetfriendApplyCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/23.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetChatPetfriendApplyCell: CBPetBaseTableViewCell {

    private lazy var avatarImageView:UIImageView = {
        let imgV = UIImageView.init()
        imgV.layer.masksToBounds = true
        imgV.layer.cornerRadius = 4*KFitHeightRate
        imgV.backgroundColor = KPetAppColor
        imgV.contentMode = .scaleAspectFit
        return imgV
    }()
    private lazy var nameLb:UILabel = {
        let lb = UILabel(text: "录音1".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!)
        return lb
    }()
    private lazy var agreenBtn:UIButton = {
        let btn = UIButton()//CBPetBaseButton(title: "同意".localizedStr, titleColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, backgroundColor: KPetLineColor, cornerRadius: 12*KFitHeightRate)
        btn.setTitle("同意".localizedStr, for: .normal)
        btn.setTitle("同意".localizedStr, for: .highlighted)
        btn.setTitleColor(KPetTextColor, for: .normal)
        btn.setTitleColor(KPetTextColor, for: .highlighted)
        btn.titleLabel?.font = UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)
        btn.backgroundColor = KPetLineColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 12*KFitHeightRate
        return btn
    }()
    private lazy var closeBtn:UIButton = {
        let btn = UIButton()//CBPetBaseButton(imageName: "pet_closeIcon")
        btn.setImage(UIImage(named: "pet_closeIcon"), for: .normal)
        btn.setImage(UIImage(named: "pet_closeIcon"), for: .highlighted)
        return btn
    }()
    var agreeCloseBlock:((_ state:String) -> Void)?
    
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
            make.size.equalTo(CGSize(width: 36*KFitHeightRate, height: 36*KFitHeightRate))
            make.top.equalTo(8*KFitHeightRate)
            make.bottom.equalTo(-8*KFitHeightRate)
        }
        
        self.contentView.addSubview(self.nameLb)
        self.nameLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.avatarImageView)
            make.left.equalTo(self.avatarImageView.snp_right).offset(12*KFitWidthRate)
        }
        
        self.contentView.addSubview(self.closeBtn)
        let closeImage = UIImage.init(named: "pet_closeIcon")!
        self.closeBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-20*KFitWidthRate)
            make.size.equalTo(CGSize(width: closeImage.size.width, height: closeImage.size.height))
        }
        self.closeBtn.addTarget(self, action: #selector(agreeCloseAction), for: .touchUpInside)
        
        self.contentView.addSubview(self.agreenBtn)
        self.agreenBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self.closeBtn.snp_left).offset(-15*KFitWidthRate)
            make.size.equalTo(CGSize(width: 48*KFitWidthRate, height: 22*KFitHeightRate))
        }
        self.agreenBtn.addTarget(self, action: #selector(agreeCloseAction), for: .touchUpInside)
    }
    var petFriendModel:CBPetFuncPetFriendsModel = CBPetFuncPetFriendsModel() {
        didSet {
            self.avatarImageView.sd_setImage(with: URL.init(string: petFriendModel.friendHead ?? ""), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
            self.nameLb.text = petFriendModel.friendName
            switch petFriendModel.isAuth {
            case "0":
                /* 已同意*/
                self.agreenBtn.isEnabled = false
                self.setupAgreenBtn(title: "已同意".localizedStr)
                let titleWidth = "已同意".getWidthText(text: "已同意".localizedStr, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, height: 22*KFitHeightRate)
                self.agreenBtn.snp_remakeConstraints { (make) in
                    make.centerY.equalTo(self)
                    make.right.equalTo(-20*KFitWidthRate)
                    make.size.equalTo(CGSize(width: titleWidth + 20*KFitWidthRate, height: 22*KFitHeightRate))
                }
                self.closeBtn.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self)
                    make.right.equalTo(-20*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0, height: 0))
                }
                break
            case "1":
                /* 等待处理 */
                self.agreenBtn.isEnabled = true
                self.setupAgreenBtn(title: "同意".localizedStr)
                let titleWidth = "同意".getWidthText(text: "同意".localizedStr, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, height: 22*KFitHeightRate)
                self.agreenBtn.snp_remakeConstraints { (make) in
                    make.centerY.equalTo(self)
                    make.right.equalTo(self.closeBtn.snp_left).offset(-15*KFitWidthRate)
                    make.size.equalTo(CGSize(width: titleWidth + 20*KFitWidthRate, height: 22*KFitHeightRate))
                }
                let closeImage = UIImage.init(named: "pet_closeIcon")!
                self.closeBtn.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self)
                    make.right.equalTo(-20*KFitWidthRate)
                    make.size.equalTo(CGSize(width: closeImage.size.width, height: closeImage.size.height))
                }
                break
            case "2":
                /* 已拒绝 */
                self.agreenBtn.isEnabled = false
                self.setupAgreenBtn(title: "已拒绝".localizedStr)
                let titleWidth = "已拒绝".getWidthText(text: "已拒绝".localizedStr, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, height: 22*KFitHeightRate)
                self.agreenBtn.snp_remakeConstraints { (make) in
                    make.centerY.equalTo(self)
                    make.right.equalTo(-20*KFitWidthRate)
                    make.size.equalTo(CGSize(width: titleWidth + 20*KFitWidthRate, height: 22*KFitHeightRate))
                }
                
                self.closeBtn.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self)
                    make.right.equalTo(-20*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0, height: 0))
                }
                break
            default:
                break
            }
        }
    }
    private func setupAgreenBtn(title:String) {
        self.agreenBtn.setTitle(title, for: .normal)
        self.agreenBtn.setTitle(title, for: .highlighted)
    }
    @objc private func agreeCloseAction(sender:UIButton) {
        guard self.agreeCloseBlock == nil else {
            if sender == self.agreenBtn {
                self.agreeCloseBlock!("0")
            } else if sender == self.closeBtn {
                self.agreeCloseBlock!("2")
            }
            return
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
