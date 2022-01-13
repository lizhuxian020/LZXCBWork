//
//  CBPetNearPetPopView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/7/3.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetNearPetPopView: CBPetBaseView,UIGestureRecognizerDelegate {

    /// 点击完成按钮的回调
    private var clickComfirmBtnBlock:(() -> Void)?
    /// 点击取消的回调
    private var clickCancelBtnBlock:(() -> Void)?
    ///单例
    static let share:CBPetNearPetPopView = {
        let view = CBPetNearPetPopView.init()
        return view
    }()
    ///背景view
    private lazy var bgView:CBPetBaseView = {
        let bgmV = CBPetBaseView()
        bgmV.layer.cornerRadius = 16*KFitHeightRate
        bgmV.layer.masksToBounds = true
        bgmV.backgroundColor = UIColor.white
        return bgmV
    }()
    ///自己宠物头像
    private lazy var selfAvatarImageView:UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "pet_psnal_defaultAvatar"))
        imgV.layer.masksToBounds = true
        imgV.layer.cornerRadius = 36*KFitHeightRate
        return imgV
    }()
    ///自己宠物头像
    private lazy var selfNameLb:UILabel = {
        let lb = UILabel(text: "", textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    ///附近宠物头像
    private lazy var nearAvatarImageView:UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "pet_psnal_defaultAvatar"))
        imgV.layer.masksToBounds = true
        imgV.layer.cornerRadius = 12*KFitHeightRate
        return imgV
    }()
    ///附近宠物头像
    private lazy var nearNameLb:UILabel = {
        let lb = UILabel(text: "", textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    ///连接imageView
    private lazy var relateImageView:UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "pet_func_relate"))
        return imgV
    }()
    ///查看资料btn
    private lazy var visitPetInfoBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "查看资料".localizedStr, titleColor: UIColor.white, font: UIFont(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!, backgroundColor: KPetAppColor, cornerRadius: 20*KFitHeightRate)
        btn.addTarget(self, action: #selector(clickComfirmBtn), for: UIControl.Event.touchUpInside)
        return btn
    }()
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
//    //点击背景view 移除当前控件
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first  {
//            var point =  touch.location(in: self)
//            point = bgView.layer.convert(point, from: self.layer)
//            if !bgView.layer.contains(point){
//                self.removeView()
//            }
//        }
//    }
    /// 无标题显示弹框,前提初始化时候带标题
    public func showAlert(completeBtnBlock:(() -> Void)?,cancelBtnBlock:(() -> Void)?) {
        UIApplication.shared.keyWindow!.subviews.forEach { (vv) in
           if vv is CBPetNearPetPopView {
               return
           }
        }
        self.setupAlertView()
        UIApplication.shared.keyWindow!.addSubview(self)
        self.clickComfirmBtnBlock = completeBtnBlock
        self.clickCancelBtnBlock = cancelBtnBlock
        self.alpha = 0
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
           self.alpha = 1
           self.isUserInteractionEnabled = true
        }
    }
    //MARK: - 设置view
    private func setupBgmView() {
        self.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.85)
        self.frame = UIScreen.main.bounds
        /// 马上刷新界面  ///self.layoutIfNeeded()        ///强制刷新布局 ///setNeedsLayout
        self.addSubview(self.bgView)
        self.bgView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(SCREEN_WIDTH-106*KFitWidthRate)
        }
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureMethod))
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = false;
        tapGestureRecognizer.delegate = self;
        //将触摸事件添加到当前view
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc private func tapGestureMethod(tap:UITapGestureRecognizer) {
        self.removeView()
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        /* 判断该区域是否包含某个指定的区域 */
        if self.bgView.frame.contains(gestureRecognizer.location(in: self)) {
            return false
        }
        return true
    }
    private func setupAlertView() {
        self.bgView.addSubview(self.selfAvatarImageView)
        self.selfAvatarImageView.snp_makeConstraints { (make) in
            make.top.equalTo(self.bgView.snp_top).offset(32*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(25*KFitWidthRate)
            make.size.equalTo(CGSize(width: 72*KFitHeightRate, height: 72*KFitHeightRate))
        }
        self.bgView.addSubview(self.selfNameLb)
        self.selfNameLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.selfAvatarImageView.snp_bottom).offset(12*KFitHeightRate)
            make.centerX.equalTo(self.selfAvatarImageView)
        }
        self.bgView.addSubview(self.nearAvatarImageView)
        self.nearAvatarImageView.snp_makeConstraints { (make) in
            make.top.equalTo(self.bgView.snp_top).offset(32*KFitHeightRate)
            make.right.equalTo(self.bgView.snp_right).offset(-25*KFitWidthRate)
            make.size.equalTo(CGSize(width: 72*KFitHeightRate, height: 72*KFitHeightRate))
        }
        self.bgView.addSubview(self.nearNameLb)
        self.nearNameLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.nearAvatarImageView.snp_bottom).offset(12*KFitHeightRate)
            make.centerX.equalTo(self.nearAvatarImageView)
        }
        self.bgView.addSubview(self.relateImageView)
        let relateImg = UIImage(named: "pet_func_relate")!
        self.relateImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.bgView)
            make.top.equalTo(self.bgView.snp_top).offset(56*KFitHeightRate)
            make.size.equalTo(CGSize(width: relateImg.size.width, height: relateImg.size.height))
        }
        self.bgView.addSubview(self.visitPetInfoBtn)
        self.visitPetInfoBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.nearNameLb.snp_bottom).offset(33*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(25*KFitWidthRate)
            make.right.equalTo(self.bgView.snp_right).offset(-25*KFitWidthRate)
            make.bottom.equalTo(self.bgView.snp_bottom).offset(-20*KFitHeightRate)
            make.height.equalTo(40*KFitHeightRate)
        }
    }
    //MARK: - 移除弹框(内部移除)
    /// 移除弹框(内部移除)
    private func removeView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] (res) in
            /// 关闭时恢复约束
            self?.bgView.snp_remakeConstraints { (make) in
                make.center.equalTo(self!)
                make.width.equalTo(SCREEN_WIDTH-106*KFitWidthRate)
            }
            self?.removeFromSuperview()
        }
    }
    func updateNearPetsData(model:CBPetFuncNearPetModel) {
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.photo {
            self.selfAvatarImageView.sd_setImage(with: URL.init(string: value), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
        }
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.name {
            selfNameLb.text = value
        }
        self.nearAvatarImageView.sd_setImage(with: URL.init(string: model.photo ?? "pet_psnal_defaultAvatar"), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
        nearNameLb.text = model.name
    }
}
extension CBPetNearPetPopView {
    @objc private func clickComfirmBtn() {
        clickComfirmBtnBlock?()
        self.removeView()
    }
    @objc private func clickCancelBtn() {
        clickCancelBtnBlock?()
        self.removeView()
    }
}
