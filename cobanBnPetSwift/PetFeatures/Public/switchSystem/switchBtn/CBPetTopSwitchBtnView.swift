//
//  CBPetTopSwitchBtnView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/7/23.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetTopSwitchBtnView: CBPetBaseView {

    ///单例
    @objc public static let share:CBPetTopSwitchBtnView = {
        let view = CBPetTopSwitchBtnView.init()
        return view
    }()
    private lazy var ctrPanelBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(type: UIButton.ButtonType.custom)//CBPetBaseButton(imageName: "pet_home_controlPanelIcon")
        btn.layer.cornerRadius = ctrlPanelWidth/2
        btn.adjustsImageWhenHighlighted = false
        btn.adjustsImageWhenDisabled = false
        return btn
    }()
    /// 点击按钮的回调
    public var switchBlock:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupView() {
        self.addSubview(self.ctrPanelBtn)
        self.ctrPanelBtn.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: ctrlPanelWidth, height: ctrlPanelWidth))
        }
        self.ctrPanelBtn.addTarget(self, action: #selector(switchClick), for: .touchUpInside)
    }
    //MARK: - 展示
    @objc public func showCtrlPanel(resultBlock:@escaping() -> Void) {
        UIApplication.shared.keyWindow?.subviews.forEach({ (vv) in
            if vv is CBPetTopSwitchBtnView {
                return
            }
        })
        self.frame = CGRect(x: SCREEN_WIDTH-20*KFitWidthRate-ctrlPanelWidth, y: NavigationBarHeigt+12.5*KFitHeightRate+40*KFitHeightRate+15*KFitHeightRate+50*KFitHeightRate, width: ctrlPanelWidth, height: ctrlPanelWidth)
        UIApplication.shared.keyWindow?.addSubview(self)
        self.switchBlock = resultBlock
        
        self.alpha = 1//0
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
           self.alpha = 1
           self.isUserInteractionEnabled = true
        }
        
        
        let sswitchModel = CBPetSwitchSystemTool.getSwitchModel()
        switch sswitchModel.title {
        case "巴诺宠物".localizedStr:
            self.ctrPanelBtn.setImage(UIImage(named: "pet_switch_watch_btn"), for: .normal)
            self.ctrPanelBtn.setImage(UIImage(named: "pet_switch_watch_btn"), for: .selected)
            break
        case "巴诺手表".localizedStr:
           self.ctrPanelBtn.setImage(UIImage(named: "pet_switch_pet_btn"), for: .normal)
           self.ctrPanelBtn.setImage(UIImage(named: "pet_switch_pet_btn"), for: .selected)
            break
        case "巴诺车联网".localizedStr:
            self.ctrPanelBtn.setImage(UIImage(named: "pet_switch_pet_btn"), for: .normal)
            self.ctrPanelBtn.setImage(UIImage(named: "pet_switch_pet_btn"), for: .selected)
            break
        default:
            self.ctrPanelBtn.setImage(UIImage(named: "pet_switch_watch_btn"), for: .normal)
            self.ctrPanelBtn.setImage(UIImage(named: "pet_switch_watch_btn"), for: .selected)
            break
        }
        
        self.bringToFront()
    }
    //MARK: - 关闭本视图
    @objc public func removeView() {
        self.removeFromSuperview()
    }
    //MARK: - 视图置顶
    private func bringToFront() {
        UIApplication.shared.keyWindow?.bringSubviewToFront(self)
    }
}
extension CBPetTopSwitchBtnView {
    @objc private func switchClick() {
        var sswitchModel = CBPetSwitchSystemTool.getSwitchModel()
        switch sswitchModel.title {
        case "巴诺宠物".localizedStr:
            /* 切换至手表*/
            let notificationName = NSNotification.Name.init(K_SwitchWtRootViewController)
            sswitchModel.title = "巴诺手表".localizedStr
            CBPetSwitchSystemTool.saveSwitchModel(switchModel: sswitchModel)
            NotificationCenter.default.post(name: notificationName, object: nil)
            break
        case "巴诺手表".localizedStr:
            /* 切换至宠物*/
            let notificationName = NSNotification.Name.init(K_SwitchPetRootViewController)
            sswitchModel.title = "巴诺宠物".localizedStr
            CBPetSwitchSystemTool.saveSwitchModel(switchModel: sswitchModel)
            NotificationCenter.default.post(name: notificationName, object: nil)
            break
        case "巴诺车联网".localizedStr:
            /* 切换至宠物*/
            let notificationName = NSNotification.Name.init(K_SwitchPetRootViewController)
            sswitchModel.title = "巴诺宠物".localizedStr
            CBPetSwitchSystemTool.saveSwitchModel(switchModel: sswitchModel)
            NotificationCenter.default.post(name: notificationName, object: nil)
            break
        default:
            /* 切换至手表*/
            let notificationName = NSNotification.Name.init(K_SwitchWtRootViewController)
            sswitchModel.title = "巴诺手表".localizedStr
            CBPetSwitchSystemTool.saveSwitchModel(switchModel: sswitchModel)
            NotificationCenter.default.post(name: notificationName, object: nil)
            break
        }
    }
}
