//
//  CBPetHomeBindView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/4/20.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetHomeBindView: CBPetBaseView {
    
    var bindWatchBlock:(() -> Void)?
    private lazy var bindImageView:UIImageView = {
        let imgView = UIImageView.init()
        return imgView
    }()

    private lazy var bindBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "绑定设备".localizedStr, titleColor: KPetAppColor, font: UIFont.init(name: CBPingFang_SC_Bold, size: 18*KFitHeightRate)!, imageName: "pet_bindDevice")
        btn.addTarget(self, action: #selector(btnClickAction), for: .touchUpInside)
        return btn
    }()
    private lazy var statusBgmView:UIView = {
        let bgmV = UIView(backgroundColor: UIColor.white, cornerRadius: 17*KFitHeightRate, shadowColor: KPetC8C8C8Color, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 0), shadowRadius: 8)
        return bgmV
    }()
    private lazy var closeBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(imageName: "pet_closeIcon")
        btn.addTarget(self, action: #selector(btnClickAction), for: .touchUpInside)
        return btn
    }()
    private lazy var statusViewBindBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "绑定".localizedStr, titleColor: UIColor.white, font: UIFont.init(name: CBPingFangSC_Regular, size: 10*KFitHeightRate)!, backgroundColor: KPetAppColor, cornerRadius: 2)
        btn.addTarget(self, action: #selector(btnClickAction), for: .touchUpInside)
        return btn
    }()
    private lazy var statusLb:UILabel = {
        let lb = UILabel(text: "检测该账号未绑定任何智能设备，部分功能无法使用".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 10*KFitHeightRate)!, textAlignment: .left)
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
    }
    private func setupView() {
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.bindBtn)
        self.bindBtn.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.equalTo(100)
        }
        self.bindBtn.layoutBtn(status: .CBVerticalCenterImageAndTitle, space: 5*KFitHeightRate)
        
        self.addSubview(self.statusBgmView)
        self.statusBgmView.snp_makeConstraints { (make) in
            make.top.equalTo(NavigationBarHeigt)
            make.left.right.equalTo(0)
            make.height.equalTo(34*KFitHeightRate)
        }
        
        self.statusBgmView.addSubview(self.closeBtn)
        self.closeBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.statusBgmView.snp_centerY)
            make.left.equalTo(self.statusBgmView.snp_left).offset(20*KFitWidthRate)
        }
        self.statusBgmView.addSubview(self.statusViewBindBtn)
        self.statusViewBindBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.statusBgmView.snp_centerY)
            make.right.equalTo(self.statusBgmView.snp_right).offset(-20*KFitWidthRate)
            make.size.equalTo(CGSize(width: 40*KFitWidthRate, height: 18*KFitHeightRate))
        }
        
        self.statusBgmView.addSubview(self.statusLb)
        self.statusLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.statusBgmView.snp_centerY)
            make.left.equalTo(self.closeBtn.snp_right).offset(10*KFitWidthRate)
            make.right.equalTo(self.statusViewBindBtn.snp_left).offset(-10*KFitWidthRate)
        }

    }
    @objc private func btnClickAction(sender:CBPetBaseButton) {
        switch sender {
        case self.closeBtn:
            UIView.animate(withDuration: 0.3, animations: {
                self.statusBgmView.isUserInteractionEnabled = false
                self.statusBgmView.alpha = 0
            })
            guard (self.viewModel as! CBPetHomeViewModel).bindDeviceBlock == nil else {
                (self.viewModel as! CBPetHomeViewModel).bindDeviceBlock!(CBPetHomeViewModelClickType.clickTypeClose)
                return
            }
            break
        case self.statusViewBindBtn:
            guard (self.viewModel as! CBPetHomeViewModel).bindDeviceBlock == nil else {
                (self.viewModel as! CBPetHomeViewModel).bindDeviceBlock!(CBPetHomeViewModelClickType.clickTypeBind)
                return
            }
            break
        case self.bindBtn:
            guard (self.viewModel as! CBPetHomeViewModel).bindDeviceBlock == nil else {
                (self.viewModel as! CBPetHomeViewModel).bindDeviceBlock!(CBPetHomeViewModelClickType.clickTypeBind)
                return
            }
            break
        default:
            break
        }
    }
    func updateBindViewData(status:String) {
        if self.viewModel is CBPetHomeViewModel {
            /* 账号旗下无智能设备*/
            self.statusLb.text = status
            self.statusBgmView.isUserInteractionEnabled = true
            self.statusBgmView.alpha = 1
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
