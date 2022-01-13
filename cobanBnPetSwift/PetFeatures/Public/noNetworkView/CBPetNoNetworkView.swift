//
//  CBPetNoNetworkView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/17.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetNoNetworkView: CBPetBaseView {

    ///单例
    static let share:CBPetNoNetworkView = {
        let view = CBPetNoNetworkView.init()
        return view
    }()
    ///背景view
    private lazy var bgView:CBPetBaseView = {
        let bgmV = CBPetBaseView()
        bgmV.backgroundColor = UIColor.white
        return bgmV
    }()
    private lazy var networkImageView:UIImageView = {
        let bgmV = UIImageView()
        bgmV.backgroundColor = UIColor.white
        return bgmV
    }()
    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "网络异常，再试试".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, textAlignment: .center)
        lb.backgroundColor = UIColor.white
        return lb
    }()
    private lazy var reloadBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "重新加载", titleColor: UIColor.white, font: UIFont(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!, backgroundColor: KPetAppColor, cornerRadius: 20*KFitHeightRate)
        btn.setShadow(backgroundColor: KPetAppColor, cornerRadius: 20*KFitHeightRate, shadowColor: KPetAppColor, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 5), shadowRadius: 8)
        return btn
    }()
    var reloadBlock:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupBgmView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    //MARK: - 设置view
    private func setupBgmView() {
        self.backgroundColor = UIColor.white//UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.85)
        //self.frame = UIScreen.main.bounds
        /// 马上刷新界面  ///self.layoutIfNeeded()        ///强制刷新布局 ///setNeedsLayout
        self.addSubview(self.bgView)
        self.bgView.snp_makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
        setupNetworkView()
    }
    private func setupNetworkView() {
        let networkImage = UIImage(named: "pet_noNetwork_icon")!
        self.bgView.addSubview(self.networkImageView)
        self.bgView.addSubview(self.titleLb)
        self.bgView.addSubview(self.reloadBtn)
        self.networkImageView.image = networkImage
        self.networkImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.bgView)
            make.top.equalTo(self.bgView.snp_top).offset(120*KFitHeightRate+NavigationBarHeigt)
            make.size.equalTo(CGSize(width: networkImage.size.width, height: networkImage.size.height))
        }
        self.titleLb.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.bgView)
            make.top.equalTo(self.networkImageView.snp_bottom).offset(25*KFitHeightRate)
        }
        self.reloadBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.bgView)
            make.top.equalTo(self.titleLb.snp_bottom).offset(32*KFitHeightRate)
            make.size.equalTo(CGSize(width: 120*KFitWidthRate, height: 40*KFitHeightRate))
        }
        self.reloadBtn.addTarget(self, action: #selector(reloadAction), for: .touchUpInside)
    }
    @objc private func reloadAction() {
        CBLog(message: "重新加载")
        guard self.reloadBlock == nil else {
            self.reloadBlock!()
            return
        }
    }
}
