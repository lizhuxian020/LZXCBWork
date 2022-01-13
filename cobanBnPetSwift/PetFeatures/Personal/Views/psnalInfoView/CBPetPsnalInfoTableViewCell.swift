//
//  CBPetPsnalInfoTableViewCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/3.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetPsnalInfoTableViewCell: CBPetBaseTableViewCell {

    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "头像".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var lockImgeView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "pet_psnal_isLock")
        return imageView
    }()
    private lazy var textLb:UILabel = {
        let lb = UILabel(text: "133-2343-3432".localizedStr, textColor: KPet999999Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .right)
        lb.numberOfLines = 1
        return lb
    }()
    private lazy var avtarImgeView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5*KFitHeightRate
        imageView.image = UIImage.init(named: "pet_psnal_defaultAvatar")
        return imageView
    }()
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
        self.rigntArrowBtn.isHidden = false
    
        self.contentView.addSubview(self.titleLb)
        self.contentView.addSubview(self.lockImgeView)
        self.contentView.addSubview(self.textLb)
        self.contentView.addSubview(self.avtarImgeView)
        
        let imgRight = UIImage.init(named: "pet_psnal_rightArrow")
        self.rigntArrowBtn.snp_remakeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-30*KFitWidthRate)
            make.size.equalTo(CGSize.init(width: (imgRight?.size.width)!, height: (imgRight?.size.height)!))
        }
        
        self.avtarImgeView.snp_makeConstraints { (make) in
            make.top.equalTo(15*KFitHeightRate)
            make.bottom.equalTo(-15*KFitHeightRate)
            make.right.equalTo(self.rigntArrowBtn.snp_left).offset(-12*KFitWidthRate)
            make.size.equalTo(CGSize(width: 52*KFitHeightRate, height: 52*KFitHeightRate))
        }

        self.textLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self.rigntArrowBtn.snp_left).offset(-12*KFitWidthRate)
            make.left.equalTo(self.titleLb.snp_right).offset(15*KFitWidthRate)
        }
        
        self.titleLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.avtarImgeView)
            make.left.equalTo(20*KFitWidthRate)
            make.width.equalTo(20)
            make.right.equalTo(self.textLb.snp_left).offset(-15*KFitWidthRate)
        }
        let lockImage = UIImage(named: "pet_psnal_isLock")!
        self.lockImgeView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.titleLb.snp_centerY)
            make.left.equalTo(self.titleLb.snp_right).offset(8*KFitWidthRate)
            make.size.equalTo(CGSize(width: lockImage.size.width, height: lockImage.size.height))
        }
        
    }
    
    var psnalInfoModel = CBPetUserInfoModel() {
        didSet {
            self.titleLb.text = psnalInfoModel.title
            self.bottomLineView.isHidden = false
            self.lockImgeView.isHidden = true
            
            let title_width = psnalInfoModel.title?.getWidthText(text: psnalInfoModel.title ?? "", font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, height: 20)
            self.titleLb.snp_updateConstraints { (make) in
                make.centerY.equalTo(self.avtarImgeView)
                make.left.equalTo(20*KFitWidthRate)
                make.width.equalTo(title_width ?? 0)
                make.right.equalTo(self.textLb.snp_left).offset(-15*KFitWidthRate)
            }
            /* update 头像UIImageView*/
            if psnalInfoModel.title == "头像".localizedStr {
                self.textLb.text = ""
                self.avtarImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(15*KFitHeightRate)
                    make.bottom.equalTo(-15*KFitHeightRate)
                    make.right.equalTo(self.rigntArrowBtn.snp_left).offset(-12*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 52*KFitHeightRate, height: 52*KFitHeightRate))
                }
                self.avtarImgeView.sd_setImage(with: URL.init(string: psnalInfoModel.text ?? ""), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
            } else {
                self.textLb.text = psnalInfoModel.text
                self.avtarImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(25*KFitHeightRate)
                    make.bottom.equalTo(-25*KFitHeightRate)
                    make.right.equalTo(self.rigntArrowBtn.snp_left).offset(-12*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0*KFitHeightRate, height: 0*KFitHeightRate))
                }
            }
            /* update 隐私设置icon UIImageView*/
            if psnalInfoModel.title == "电话".localizedStr
            || psnalInfoModel.title == "微信".localizedStr
            || psnalInfoModel.title == "邮箱".localizedStr
            || psnalInfoModel.title == "WhatsApp".localizedStr {
                self.lockImgeView.isHidden = psnalInfoModel.isPublish == "0" ? false : psnalInfoModel.isPublish == "1" ? true : false
            } else if psnalInfoModel.title == "性别".localizedStr {
                self.textLb.text = psnalInfoModel.text == "0" ? "男".localizedStr : psnalInfoModel.text == "1" ? "女".localizedStr : "未知".localizedStr
            }
            
            if psnalInfoModel.title == "WhatsApp".localizedStr {
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
