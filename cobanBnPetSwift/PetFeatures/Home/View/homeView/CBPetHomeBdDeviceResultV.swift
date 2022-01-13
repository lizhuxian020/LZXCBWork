//
//  CBPetHomeBdDeviceResultV.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/4/16.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetHomeBdDeviceResultV: CBPetBaseView {

    lazy var bindImgView:UIImageView = {
        let imgView = UIImageView.init()
        return imgView
    }()
    lazy var titleLb:UILabel = {
        let lb = UILabel(text: "绑定申请已发送，请等待管理员确认".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, textAlignment: .center)
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
        self.backgroundColor = KPetBgmColor
        self.addSubview(self.bindImgView)
        let image = UIImage.init(named: "pet_bindDeviceWaitApply")!
        let width:CGFloat = image.size.width
        let height:CGFloat = image.size.height
        self.bindImgView.image = UIImage.init(named: "pet_bindDeviceWaitApply")
        self.bindImgView.snp_makeConstraints { (make) in
            make.top.equalTo(NavigationBarHeigt + CGFloat(100*KFitHeightRate))
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize.init(width: width, height: height))
        }
        
        self.addSubview(self.titleLb)
        self.titleLb.snp_makeConstraints { (make) in
            make.left.equalTo(12.5*KFitWidthRate)
            make.top.equalTo(self.bindImgView.snp_bottom).offset(35*KFitHeightRate)
            make.right.equalTo(-12.5*KFitWidthRate)
            make.height.equalTo(40*KFitHeightRate)
        }
        
        let bindBtn = UIButton(title: "重新绑定".localizedStr, titleColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!)
        self.addSubview(bindBtn)
        bindBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleLb.snp_bottom).offset(10*KFitHeightRate)
            make.right.equalTo(self.snp_centerX).offset(-30*KFitWidthRate)
            make.height.equalTo(40*KFitHeightRate)
        }
        bindBtn.addTarget(self, action: #selector(rebindClick), for: .touchUpInside)
 
        let logoutBtn = UIButton(title: "退出登录".localizedStr, titleColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!)
        self.addSubview(logoutBtn)
        logoutBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleLb.snp_bottom).offset(10*KFitHeightRate)
            make.left.equalTo(self.snp_centerX).offset(30*KFitWidthRate)
            make.height.equalTo(40*KFitHeightRate)
        }
        logoutBtn.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
    }
    // MARK 重新绑定
    @objc private func rebindClick() {
        guard (self.viewModel as! CBPetHomeViewModel).bindDeviceBlock == nil else
        {
            (self.viewModel as! CBPetHomeViewModel).bindDeviceBlock!(CBPetHomeViewModelClickType.clickTypeBind)
            return
        }
    }
    // MARK 退出登录
    @objc private func logoutAction() {
        
        guard (self.viewModel as! CBPetHomeViewModel).bindDeviceBlock == nil else
        {
            (self.viewModel as! CBPetHomeViewModel).bindDeviceBlock!(CBPetHomeViewModelClickType.clickTypeLoginOut)
            return
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
