//
//  CBPetHomeAvatarView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/26.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetHomeAvatarView: CBPetBaseView {
    
    private lazy var avatarImgView:UIImageView = {
        let avtarImgV = UIImageView.init()
        avtarImgV.image = UIImage.init(named: "pet_home_switchDevice")
        avtarImgV.isUserInteractionEnabled = true
        avtarImgV.backgroundColor = UIColor.white
        avtarImgV.layer.masksToBounds = false;
        avtarImgV.layer.cornerRadius = 20*KFitHeightRate/2;
        avtarImgV.contentMode = .scaleAspectFill
        avtarImgV.isHidden = true
        return avtarImgV
    }()
    private lazy var deviceNameLb:UILabel = {//念念123念念123念念
        let nameLb = UILabel(text: "".localizedStr, textColor: UIColor.white, font: UIFont.init(name: CBPingFang_SC_Bold, size: 16*KFitHeightRate)!)
        return nameLb
    }()
    private lazy var switchBtn:CBPetBaseButton = {
        let swtichIBtn = CBPetBaseButton.init()
        let image = UIImage.init(named: "pet_home_switchDevice")
        swtichIBtn.setImage(image, for: .normal)
        swtichIBtn.setImage(image, for: .highlighted)
        swtichIBtn.isUserInteractionEnabled = false
        swtichIBtn.isHidden = true
        return swtichIBtn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /* iOS11后导航栏的自定义titleView点击手势或者按钮失效 */
    /* 1、重写intrinsicContentSize*/
    /* 2、在viewController中设置titleView前设置translatesAutoresizingMaskIntoConstraints*/
    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: SCREEN_WIDTH, height: 50*KFitWidthRate)
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        if self.viewModel is CBPetHomeViewModel {
            let model = self.viewModel as! CBPetHomeViewModel
            model.avatarTitleViewUpdateUIBlock = { [weak self] (_ isShowHomeTitle:Bool,_ title:String,_ avatarImage:UIImage) -> Void in
                if isShowHomeTitle {
                    self?.deviceNameLb.text = "首页".localizedStr
                    self?.avatarImgView.isHidden = true
                    self?.switchBtn.isHidden = true
                } else {
                    self?.deviceNameLb.text = title
                    self?.avatarImgView.isHidden = false
                    self?.avatarImgView.image = avatarImage
                    self?.switchBtn.isHidden = false
                }
            }
        }
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.deviceNameLb)
        self.deviceNameLb.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        self.addSubview(self.avatarImgView)
        self.avatarImgView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.deviceNameLb.snp_centerY)
            make.right.equalTo(self.deviceNameLb.snp_left).offset(-5*KFitWidthRate)
            make.size.equalTo(CGSize(width: 20*KFitHeightRate, height: 20*KFitHeightRate))
        }
        
        let img = UIImage.init(named: "pet_home_switchDevice")!
        self.addSubview(self.switchBtn)
        self.switchBtn.addTarget(self, action: #selector(switchClick), for: .touchUpInside)
        self.switchBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.deviceNameLb.snp_centerY)
            make.left.equalTo(self.deviceNameLb.snp_right).offset(5*KFitWidthRate)
            make.size.equalTo(CGSize(width: img.size.width, height: img.size.height))
        }
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapWwitchClick))
        self.addGestureRecognizer(tapGesture)
    }
    @objc private func tapWwitchClick() {
        guard (self.viewModel as! CBPetHomeViewModel).avtarTitleViewSwitchDeviceBlock == nil else {
            (self.viewModel as! CBPetHomeViewModel).avtarTitleViewSwitchDeviceBlock!()
            return
        }
    }
    @objc private func switchClick() {
//        guard (self.viewModel as! CBPetHomeViewModel).avtarTitleViewSwitchDeviceBlock == nil else {
//            (self.viewModel as! CBPetHomeViewModel).avtarTitleViewSwitchDeviceBlock!()
//            return
//        }
    }
}
