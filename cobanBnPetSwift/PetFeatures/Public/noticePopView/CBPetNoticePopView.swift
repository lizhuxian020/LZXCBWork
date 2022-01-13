//
//  CBPetNoticePopView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/7/8.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

enum CBPetNoticePopType:String {
    /* 设备通知*/
    case device = "device"
    /* 用户通知*/
    case user  = "user"
    /* 低电报警*/
    case lowPowerAlarm  = "lowPowerAlarm"
}
class CBPetNoticePopView: CBPetBaseView {

    /// 点击完成按钮的回调
    private var clickComfirmBtnBlock:(() -> Void)?
    /// 点击取消的回调
    private var clickCancelBtnBlock:(() -> Void)?
    ///单例
    static let share:CBPetNoticePopView = {
        let view = CBPetNoticePopView.init()
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
    ///标题
    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "", textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC_Bold, size: 16*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    ///副标题
    private lazy var subtitleLb:UILabel = {
        let lb = UILabel(text: "", textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    ///人物头像view
    private lazy var psAvatarImgView:UIImageView = {
        let imgV = UIImageView()
        imgV.layer.cornerRadius = 12*KFitHeightRate
        imgV.layer.masksToBounds = true
        imgV.backgroundColor = UIColor.white
        imgV.isHidden = true
        return imgV
    }()
    ///宠物头像view
    private lazy var petAvatarImgView:UIImageView = {
        let imgV = UIImageView()
        imgV.layer.cornerRadius = 36*KFitHeightRate
        imgV.layer.masksToBounds = true
        imgV.backgroundColor = UIColor.white
        imgV.isHidden = true
        return imgV
    }()

    public var avtarImg:UIImage?// UIImage.init(named: "默认宝贝头像")
    /// 完成按钮
    private lazy var comfirmBtn:UIButton = {
        let btn = CBPetBaseButton(title: "查看详情".localizedStr, titleColor: UIColor.white, font: UIFont(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!, backgroundColor: KPetAppColor, cornerRadius: 20*KFitHeightRate)
        btn.addTarget(self, action: #selector(clickComfirmBtn), for: UIControl.Event.touchUpInside)
        return  btn
    }()
    /// 取消按钮
    private lazy var cancelBtn:UIButton = {
        let btn = CBPetBaseButton(title: "稍后处理".localizedStr, titleColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        btn.underline()
        btn.addTarget(self, action: #selector(clickCancelBtn), for: UIControl.Event.touchUpInside)
        return  btn
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
        /// 防止y超过屏幕
        if self.bgView.frame.size.height >= (SCREEN_HEIGHT - NavigationBarHeigt - TabBARHEIGHT - TabPaddingBARHEIGHT) {
            self.bgView.snp_remakeConstraints { (make) in
                make.center.equalTo(self)
                make.width.equalTo(SCREEN_WIDTH-106*KFitWidthRate)
                make.height.equalTo((SCREEN_HEIGHT - NavigationBarHeigt - TabBARHEIGHT - TabPaddingBARHEIGHT))
            }
        }
    }
    /// 无标题显示弹框,前提初始化时候带标题
    public func showAlert(type:CBPetNoticePopType,noticeModel:CBPetNoticeModel,completeBtnBlock:@escaping() -> Void,cancelBtnBlock:@escaping() -> Void) {
        UIApplication.shared.keyWindow!.subviews.forEach { (vv) in
           if vv is CBPetNoticePopView {
               return
           }
        }
        self.setupAlertView()
        switch type {
        case .device:
            self.titleLb.text = "设备通知".localizedStr
            self.petAvatarImgView.isHidden = false
            self.psAvatarImgView.isHidden = true
            self.comfirmBtn.setTitle("立即听听".localizedStr, for: .normal)
            self.comfirmBtn.setTitle("立即听听".localizedStr, for: .highlighted)
            self.subtitleLb.text = "您的宠物".localizedStr + " \"\(noticeModel.petName ?? "")\" " + "发来一段语音".localizedStr
            self.petAvatarImgView.sd_setImage(with: URL.init(string: noticeModel.petPhoto ?? "pet_psnal_petDefaultAvatar"), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
            break
        case .user:
            self.titleLb.text = "用户通知".localizedStr
            self.petAvatarImgView.isHidden = true
            self.psAvatarImgView.isHidden = false
            self.comfirmBtn.setTitle("查看资料".localizedStr, for: .normal)
            self.comfirmBtn.setTitle("查看资料".localizedStr, for: .highlighted)
            self.titleLb.text = noticeModel.friendPet
            self.subtitleLb.text = "\"\(noticeModel.friendPet ?? "")\" " + "发来好友申请".localizedStr
            //if noticeModel.friendPhoto?.valueStr.count
            self.psAvatarImgView.sd_setImage(with: URL.init(string: noticeModel.friendPhoto?.valueStr ?? "pet_psnal_defaultAvatar"), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
            break
        case .lowPowerAlarm:
            self.titleLb.text = "低电报警".localizedStr
            self.petAvatarImgView.isHidden = true
            self.psAvatarImgView.isHidden = false
            self.comfirmBtn.setTitle("查看".localizedStr, for: .normal)
            self.comfirmBtn.setTitle("查看".localizedStr, for: .highlighted)
            self.subtitleLb.text = "宠物".localizedStr + " \"\(noticeModel.petName ?? "")\" " + "电量过低".localizedStr
            self.psAvatarImgView.sd_setImage(with: URL.init(string: noticeModel.petPhoto?.valueStr ?? "pet_psnal_defaultAvatar"), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
            break
        }
        
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
    }
    private func setupAlertView() {
        self.bgView.addSubview(self.titleLb)
        self.titleLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.bgView.snp_top).offset(25*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(15*KFitWidthRate)
            make.right.equalTo(self.bgView.snp_right).offset(-15*KFitHeightRate)
        }
        self.bgView.addSubview(self.subtitleLb)
        self.subtitleLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleLb.snp_bottom).offset(20*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(20*KFitWidthRate)
            make.right.equalTo(self.bgView.snp_right).offset(-20*KFitHeightRate)
        }
        self.bgView.addSubview(self.psAvatarImgView)
        self.psAvatarImgView.snp_makeConstraints { (make) in
            make.top.equalTo(self.subtitleLb.snp_bottom).offset(25*KFitHeightRate)
            make.center.equalTo(self.bgView)
            make.size.equalTo(CGSize(width: 72*KFitHeightRate, height: 72*KFitHeightRate))
        }
        self.bgView.addSubview(self.petAvatarImgView)
        self.petAvatarImgView.snp_makeConstraints { (make) in
            make.top.equalTo(self.subtitleLb.snp_bottom).offset(25*KFitHeightRate)
            make.center.equalTo(self.bgView)
            make.size.equalTo(CGSize(width: 72*KFitHeightRate, height: 72*KFitHeightRate))
        }
        
        self.bgView.addSubview(self.comfirmBtn)
        self.comfirmBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.psAvatarImgView.snp_bottom).offset(20*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(25*KFitWidthRate)
            make.right.equalTo(self.bgView.snp_right).offset(-25*KFitWidthRate)
            make.height.equalTo(40*KFitHeightRate)
        }
        self.bgView.addSubview(self.cancelBtn)
        self.cancelBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.comfirmBtn.snp_bottom).offset(10*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(25*KFitWidthRate)
            make.right.equalTo(self.bgView.snp_right).offset(-25*KFitWidthRate)
            make.height.equalTo(20*KFitHeightRate)
            make.bottom.equalTo(self.bgView.snp_bottom).offset(-23*KFitHeightRate)
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
}
extension CBPetNoticePopView {
    @objc private func clickComfirmBtn() {
        clickComfirmBtnBlock?()
        self.removeView()
    }
    @objc private func clickCancelBtn() {
        clickCancelBtnBlock?()
        self.removeView()
    }
}
