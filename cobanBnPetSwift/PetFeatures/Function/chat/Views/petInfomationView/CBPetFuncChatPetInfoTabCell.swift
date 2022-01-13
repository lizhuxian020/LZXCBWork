//
//  CBPetFuncChatPetInfoTabCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/2.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncChatPetInfoTabCell: CBPetBaseTableViewCell {

    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "头像".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var textLb:UILabel = {
        let lb = UILabel(text: "133-2343-3432".localizedStr, textColor: KPet999999Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .right)
        return lb
    }()
    private lazy var avtarImgeView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 26*KFitHeightRate
        imageView.image = UIImage.init(named: "pet_psnal_petDefaultAvatar")
        return imageView
    }()
    private lazy var photoImgeView:UIImageView = {
        let imageView = UIImageView.init()
        //imageView.backgroundColor = KPetAppColor
        imageView.contentMode = .scaleAspectFit
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
    
        self.addSubview(self.titleLb)
        self.addSubview(self.textLb)
        self.addSubview(self.avtarImgeView)
        self.addSubview(self.photoImgeView)
        
        self.titleLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(20*KFitWidthRate)
            make.width.equalTo(30*KFitWidthRate)
        }
    
        self.textLb.snp_makeConstraints { (make) in
            make.top.equalTo(20*KFitHeightRate)
            make.right.equalTo(-20*KFitWidthRate)
            make.left.equalTo(self.titleLb.snp_right).offset(40*KFitWidthRate)
        }
        
        self.avtarImgeView.snp_makeConstraints { (make) in
            make.top.equalTo(15*KFitHeightRate)
            make.right.equalTo(-20*KFitWidthRate)
            make.size.equalTo(CGSize(width: 52*KFitHeightRate, height: 52*KFitHeightRate))
        }
        
        self.photoImgeView.snp_makeConstraints { (make) in
            make.top.equalTo(self.textLb.snp_bottom).offset(10*KFitHeightRate)
            make.right.equalTo(-20*KFitWidthRate)
            make.size.equalTo(CGSize(width: 80*KFitWidthRate, height: 60*KFitHeightRate))
            make.bottom.equalTo(-20*KFitHeightRate)
        }
    }
    
    var petInfoModel = CBPetPsnalCterPetPet() {
        didSet {
            self.titleLb.text = petInfoModel.title
            self.textLb.text = petInfoModel.text
            
            let titleWidth:CGFloat = petInfoModel.title?.getWidthText(text: petInfoModel.title!, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, height: 13*KFitHeightRate) ?? 0.0
            self.titleLb.snp_updateConstraints { (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(20*KFitWidthRate)
                make.width.equalTo(titleWidth)
            }
            self.textLb.textAlignment = .right
            
            if petInfoModel.title == "头像".localizedStr {
                self.textLb.text = ""
                self.avtarImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(15*KFitHeightRate)
                    make.right.equalTo(-20*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 52*KFitHeightRate, height: 52*KFitHeightRate))
                }
                //总的 15 + 52 + 15 已有 20 + lbelTexHeight(0) + 10
                self.photoImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(self.textLb.snp_bottom).offset(10*KFitHeightRate)
                    make.right.equalTo(-20*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0*KFitWidthRate, height: 0*KFitHeightRate))
                    make.bottom.equalTo((20+10)*KFitHeightRate - (52+15+15)*KFitHeightRate)
                }
                self.avtarImgeView.sd_setImage(with: URL.init(string: petInfoModel.text ?? ""), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
            } else if petInfoModel.title == "防疫记录".localizedStr {
                self.textLb.textAlignment = .left
                self.bottomLineView.isHidden = true
                self.avtarImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(15*KFitHeightRate)
                    make.right.equalTo(-20*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0*KFitHeightRate, height: 0*KFitHeightRate))
                }
                self.photoImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(self.textLb.snp_bottom).offset(10*KFitHeightRate)
                    make.right.equalTo(-20*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 80*KFitWidthRate, height: 60*KFitHeightRate))
                    make.bottom.equalTo(-20*KFitHeightRate)
                }
                self.photoImgeView.sd_setImage(with: URL.init(string: petInfoModel.epidemicImage ?? ""), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
            } else {
                self.avtarImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(15*KFitHeightRate)
                    make.right.equalTo(-20*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0*KFitHeightRate, height: 0*KFitHeightRate))
                }
                self.photoImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(self.textLb.snp_bottom).offset(10*KFitHeightRate)
                    make.right.equalTo(-20*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0*KFitWidthRate, height: 0*KFitHeightRate))
                    make.bottom.equalTo(-10*KFitHeightRate)
                }
                if petInfoModel.title == "性别".localizedStr {
                    switch petInfoModel.sex {
                        case "0":
                            self.textLb.text = "MM"
                            break
                        case "1":
                            self.textLb.text = "GG"
                            break
                        case "2":
                            self.textLb.text = "绝育 MM"
                            break
                        case "3":
                            self.textLb.text = "绝育 GG"
                            break
                        default:
                            break
                    }
                }
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
