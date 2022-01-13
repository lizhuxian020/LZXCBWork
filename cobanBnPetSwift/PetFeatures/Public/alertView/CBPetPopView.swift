//
//  CBPetPopView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/8.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

enum CBPetPopViewType:Int {
    case popAlert           //警告弹窗处理
    case popSheet           //下方可选片式弹窗
}
class CBPetPopView: CBPetBaseView {
    
    /// 点击完成按钮的回调
    private var clickComfirmBtnBlock:(() -> Void)?
    /// 点击取消的回调
    private var clickCancelBtnBlock:(() -> Void)?
    ///单例
    static let share:CBPetPopView = {
        let view = CBPetPopView.init()
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
    /// 关闭按钮
    private lazy var closeBtn:UIButton = {
        //let btn = CBPetBaseButton(type: UIButton.ButtonType.custom)//CBPetBaseButton(title: "取消", titleColor: KPetLineColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        let btn = CBPetBaseButton(imageName: "pet_notice_closeIcon")
        btn.addTarget(self, action: #selector(closeClick), for: UIControl.Event.touchUpInside)
        return  btn
    }()
    ///标题
    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "", textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    ///副标题
    private lazy var subtitleLb:UILabel = {
        let lb = UILabel(text: "", textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    private lazy var inputTF:UITextField = {
        let tf = UITextField.init()//UILabel(text: "", textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, textAlignment: .center)
        tf.isHidden = true
        return tf
    }()
    private lazy var line_horizonl:UIView = {
        let line = CBPetUtilsCreate.createLineView()
        line.backgroundColor = KPetLineColor
        return line
    }()
    private lazy var line_vertical:UIView = {
        let line = CBPetUtilsCreate.createLineView()
        line.backgroundColor = KPetLineColor
        return line
    }()
    /// 取消按钮
    private lazy var cancelBtn:UIButton = {
        let btn = CBPetBaseButton(title: "取消", titleColor: KPetLineColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        btn.addTarget(self, action: #selector(clickCancelBtn), for: UIControl.Event.touchUpInside)
        return  btn
    }()
    /// 完成按钮
    private lazy var comfirmBtn:UIButton = {
        let btn = CBPetBaseButton(title: "确定", titleColor: KPetLineColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        btn.addTarget(self, action: #selector(clickComfirmBtn), for: UIControl.Event.touchUpInside)
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
    //点击背景view 移除当前控件
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first  {
//            var point =  touch.location(in: self)
//            point = bgView.layer.convert(point, from: self.layer)
//            if !bgView.layer.contains(point){
//                self.removeView()
//            }
//        }
//    }
    /* 初始化弹框*/
    convenience init(title:String,subTitle:String,comfirmBtnText:String,cancelBtnText:String,style:CBPetPopViewType) {
        self.init()
        self.setupAlertView()
        self.titleLb.text = title
        self.subtitleLb.text = subTitle
        self.comfirmBtn.setTitle(comfirmBtnText, for: .normal)
        self.cancelBtn.setTitle(cancelBtnText, for: .normal)
    }
    /// 无标题显示弹框,前提初始化时候带标题
    public func showAlert(completeBtnBlock:@escaping() -> Void,cancelBtnBlock:@escaping() -> Void) {
        UIApplication.shared.keyWindow!.subviews.forEach { (vv) in
           if vv is CBPetPopView {
               return
           }
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
    /// 带标题显示弹框
    public func showAlert(title:String,
                          subTitle:String,
                          comfirmBtnText:String,
                          cancelBtnText:String,
                          comfirmColor:UIColor,
                          cancelColor:UIColor,
                          completeBtnBlock:@escaping() -> Void,cancelBtnBlock:@escaping() -> Void) {
        UIApplication.shared.keyWindow!.subviews.forEach { (vv) in
           if vv is CBPetPopView {
               return
           }
        }
        self.setupAlertView()
        self.titleLb.text = title
        self.subtitleLb.text = subTitle
        self.comfirmBtn.setTitle(comfirmBtnText, for: .normal)
        self.comfirmBtn.setTitle(comfirmBtnText, for: .highlighted)
        self.cancelBtn.setTitle(cancelBtnText, for: .normal)
        self.cancelBtn.setTitle(cancelBtnText, for: .highlighted)
        self.comfirmBtn.setTitleColor(comfirmColor, for: .normal)
        self.comfirmBtn.setTitleColor(comfirmColor, for: .highlighted)
        self.cancelBtn.setTitleColor(cancelColor, for: .normal)
        self.cancelBtn.setTitleColor(cancelColor, for: .highlighted)
        self.subtitleLb.setRowSpace(rowSpace: 5*KFitHeightRate)
        self.subtitleLb.textAlignment = .center
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
    
    public func setTitleColor(titleColor:UIColor) {
        self.titleLb.textColor = titleColor
    }
    public func setSubTitleColor(subtitleColor:UIColor) {
        self.subtitleLb.textColor = subtitleColor
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
        let image = UIImage(named: "pet_notice_closeIcon")!
        self.addSubview(self.closeBtn)
        self.closeBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self.bgView.snp_right).offset(0)
            make.bottom.equalTo(self.bgView.snp_top).offset(-12*KFitHeightRate)
            make.size.equalTo(CGSize(width: image.size.width, height: image.size.height))
        }
    }
    private func setupAlertView() {
        self.bgView.addSubview(self.titleLb)
        self.titleLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.bgView.snp_top).offset(25*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(45*KFitWidthRate)
            make.right.equalTo(self.bgView.snp_right).offset(-45*KFitHeightRate)
        }
        self.bgView.addSubview(self.subtitleLb)
        self.subtitleLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleLb.snp_bottom).offset(12*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(45*KFitWidthRate)
            make.right.equalTo(self.bgView.snp_right).offset(-45*KFitHeightRate)
        }
        self.bgView.addSubview(self.inputTF)
        self.inputTF.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleLb.snp_bottom).offset(12*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(45*KFitWidthRate)
            make.right.equalTo(self.bgView.snp_right).offset(-45*KFitHeightRate)
            make.height.equalTo(30)
        }
        self.bgView.addSubview(self.line_horizonl)
        self.line_horizonl.snp_makeConstraints { (make) in
            make.top.equalTo(self.subtitleLb.snp_bottom).offset(30*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(0)
            make.right.equalTo(self.bgView.snp_right).offset(0)
            make.height.equalTo(0.8*KFitHeightRate)
        }
        self.bgView.addSubview(self.line_vertical)
        self.line_vertical.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.bgView)
            make.top.equalTo(self.line_horizonl.snp_bottom).offset(0)
            make.size.equalTo(CGSize(width: 0.8*KFitWidthRate, height: 44*KFitHeightRate))
            make.bottom.equalTo(self.bgView.snp_bottom).offset(0)
        }
        self.bgView.addSubview(self.cancelBtn)
        self.bgView.addSubview(self.comfirmBtn)
        self.cancelBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.line_vertical.snp_top)
            make.left.equalTo(self.bgView.snp_left).offset(0)
            make.right.equalTo(self.snp_centerX).offset(0)
            make.bottom.equalTo(self.bgView.snp_bottom).offset(0)
        }
        self.comfirmBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.line_vertical.snp_top)
            make.left.equalTo(self.snp_centerX).offset(0)
            make.right.equalTo(self.bgView.snp_right).offset(0)
            make.bottom.equalTo(self.bgView.snp_bottom).offset(0)
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
extension CBPetPopView {
    @objc private func clickComfirmBtn() {
        clickComfirmBtnBlock?()
        self.removeView()
    }
    @objc private func clickCancelBtn() {
        clickCancelBtnBlock?()
        self.removeView()
    }
    @objc private func closeClick() {
        self.removeView()
    }
}
