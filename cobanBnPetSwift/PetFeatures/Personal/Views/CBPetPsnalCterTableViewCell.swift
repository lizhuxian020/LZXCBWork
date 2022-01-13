//
//  CBPetPsnalCterTableViewCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/3.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetPsnalCterTableViewCell: CBPetBaseTableViewCell {

    private lazy var settingIconImgeView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "pet_psnal_settingIcon")
        return imageView
    }()
    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "APP设置".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC_Bold, size: 16*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var leftLb:UILabel = {
        let lb = UILabel(text: "头像".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var rightLb:UILabel = {
        let lb = UILabel(text: "头像".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var noticeSiwtch:UISwitch = {
        let noticSwi = UISwitch.init()
        noticSwi.isOn = true
        noticSwi.isHidden = true
        return noticSwi
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
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        self.bottomLineView.isHidden = false
        
        self.contentView.addSubview(self.settingIconImgeView)
        self.contentView.addSubview(self.titleLb)
        self.contentView.addSubview(self.leftLb)
        self.contentView.addSubview(self.rightLb)
        self.contentView.addSubview(noticeSiwtch)
        
        let settingIcon = UIImage.init(named: "pet_psnal_settingIcon")!
        self.settingIconImgeView.snp_makeConstraints { (make) in
            make.top.equalTo(20*KFitHeightRate)
            make.left.equalTo(30*KFitWidthRate)
            make.size.equalTo(CGSize(width: settingIcon.size.width, height: settingIcon.size.height))
        }
        self.titleLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.settingIconImgeView)
            make.left.equalTo(self.settingIconImgeView.snp_right).offset(10*KFitWidthRate)
            make.height.equalTo(16*KFitHeightRate)
        }
        self.leftLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.settingIconImgeView.snp_bottom).offset(20*KFitHeightRate)
            make.bottom.equalTo(-20*KFitHeightRate)
            make.left.equalTo(30*KFitWidthRate)
        }
        let imgRight = UIImage.init(named: "pet_psnal_rightArrow")
        self.rigntArrowBtn.snp_remakeConstraints { (make) in
            make.centerY.equalTo(self.leftLb)
            make.right.equalTo(-30*KFitWidthRate)
            make.size.equalTo(CGSize.init(width: (imgRight?.size.width)!, height: (imgRight?.size.height)!))
        }
        self.rigntArrowBtn.isUserInteractionEnabled = false
        
        self.rightLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.leftLb)
            make.right.equalTo(self.rigntArrowBtn.snp_left).offset(-10*KFitWidthRate)
        }
    
        self.noticeSiwtch.addTarget(self, action: #selector(noticeSwitchClick), for: .valueChanged)
        self.noticeSiwtch.snp_makeConstraints { (make) in
            // UISwitch (开关大小无法设置）
            make.centerY.equalTo(self.leftLb)
            make.right.equalTo(-30*KFitWidthRate)
        }
    }
    var psnalModel:CBPetPsnalCterModel = CBPetPsnalCterModel() {
        didSet {
            self.leftLb.text = psnalModel.title
            self.rightLb.text = psnalModel.text
            self.noticeSiwtch.isHidden = true
            self.rigntArrowBtn.isHidden = false
            
            if psnalModel.title == "系统切换".localizedStr {
                let settingIcon = UIImage.init(named: "pet_psnal_settingIcon")!
                self.settingIconImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(20*KFitHeightRate)
                    make.left.equalTo(30*KFitWidthRate)
                    make.size.equalTo(CGSize(width: settingIcon.size.width, height: settingIcon.size.height))
                }
                self.titleLb.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self.settingIconImgeView)
                    make.left.equalTo(self.settingIconImgeView.snp_right).offset(10*KFitWidthRate)
                    make.height.equalTo(30*KFitHeightRate)
                }
            } else if psnalModel.title == "信息通知".localizedStr {
                self.noticeSiwtch.isHidden = false
                self.rigntArrowBtn.isHidden = true
                //self.noticeSiwtch.isOn = self.psnalModel.isOn == "1" ? true : false
                switch self.psnalModel.isOn {
                case "0":
                    self.noticeSiwtch.isOn = false
                    break
                case "1":
                    self.noticeSiwtch.isOn = true
                    break
                default:
                    self.noticeSiwtch.isOn = true
                    break
                }
                
                self.settingIconImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(0*KFitHeightRate)
                    make.left.equalTo(30*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0, height: 0))
                }
                self.titleLb.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self.settingIconImgeView)
                    make.left.equalTo(self.settingIconImgeView.snp_right).offset(10*KFitWidthRate)
                    make.height.equalTo(0*KFitHeightRate)
                }
            } else {
                self.settingIconImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(0*KFitHeightRate)
                    make.left.equalTo(30*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0, height: 0))
                }
                self.titleLb.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self.settingIconImgeView)
                    make.left.equalTo(self.settingIconImgeView.snp_right).offset(10*KFitWidthRate)
                    make.height.equalTo(0*KFitHeightRate)
                }
            }
            
            
        }
    }
    @objc func noticeSwitchClick(sender:UISwitch) {
        if self.viewModel is CBPetPsnalCterViewModel {
            let vvModel = self.viewModel as! CBPetPsnalCterViewModel
            if vvModel.psnlCterClickBlock != nil {
                if sender.isOn {
                    vvModel.psnlCterClickBlock!(CBPetPsnalCterClickType.switchNotice,"1")
                } else {
                    vvModel.psnlCterClickBlock!(CBPetPsnalCterClickType.switchNotice,"0")
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
