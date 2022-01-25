//
//  CBPetMsgCterViewController.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/4.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetMsgCterViewController: CBPetBaseViewController {

    private lazy var msgCterViewModel:CBPetMsgCterViewModel = {
        let viewModel = CBPetMsgCterViewModel()
        return viewModel
    }()
    private lazy var msgCenterView:CBPetMsgCterView = {
        let view = CBPetMsgCterView.init()
        return view
    }()
    public var noticeModel:CBPetNoticeModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.msgCenterView.beginRefresh()
        getMessageListInfoReuqest()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        //self.msgCenterView.beginRefresh()
//        getMessageListInfoReuqest()
        
        /* 推送通知*/
        NotificationCenter.default.addObserver(self, selector: #selector(noticeNofitication), name: NSNotification.Name.init(K_CBPetNoticeNotification), object: nil)
    }
    @objc private func noticeNofitication(notification: Notification) {
        let userInfo:Dictionary<String,Any> = notification.object as! Dictionary<String, Any>
        self.noticeModel = (userInfo["notice"]) as? CBPetNoticeModel
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        initBarWith(title: "消息中心".localizedStr, isBack: true)
        initBarRight(title: "标为已读".localizedStr, action: #selector(markReadedClick))
        self.rightBtn.setTitleColor(KPetAppColor, for: .normal)
        self.rightBtn.setTitleColor(KPetAppColor, for: .highlighted)
        self.rightBtn.titleLabel?.font = UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)
        
        self.view.addSubview(self.msgCenterView)
        self.msgCenterView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        self.msgCenterView.setupViewModel(viewModel: self.msgCterViewModel)
        self.msgCterViewModel.pushBlock = { [weak self] (objc:Any) in
            self?.msgDetailAction(objc: objc)
        }
        self.msgCterViewModel.MJHeaderRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.getMessageListInfoReuqest()
        }
        self.msgCterViewModel.MJFooterRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.getMessageListInfoReuqest()
        }
    }
    //MARK: - 获取消息中心列表
    private func getMessageListInfoReuqest() {
        var imeiStr = CBPetHomeInfoTool.getHomeInfo().pet.device.imei
        if let value = self.noticeModel?.imei {
            imeiStr = value
        }
        let paramters:Dictionary<String,Any> = ["imei":imeiStr ?? "","uid":CBPetLoginModelTool.getUser()?.uid ?? ""]
        CBPetNetworkingManager.share.getMessageListInfoRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            self?.msgCenterView.endRefresh()
            //返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let messageListModelObject = JSONDeserializer<CBPetMsgCterModel>.deserializeModelArrayFrom(array: ddJson.arrayObject)
            guard self?.msgCterViewModel.getNewestMessageUpdateUIBlock == nil else {
                if let value = messageListModelObject {
                    self?.msgCterViewModel.getNewestMessageUpdateUIBlock!(value as! [CBPetMsgCterModel] )
                } else {
                    self?.msgCterViewModel.getNewestMessageUpdateUIBlock!([CBPetMsgCterModel]())
                }
                return
            }
        }) { [weak self] (failureModel) in
            self?.msgCenterView.endRefresh()
        }
    }
    //MARK: - 标记已读
    @objc private func markReadedClick() {
        CBPetPopView.share.showAlert(title: "", subTitle: "确定将所有消息标为已读".localizedStr, comfirmBtnText: "确定".localizedStr, cancelBtnText: "取消".localizedStr, comfirmColor: KPetAppColor, cancelColor: KPet999999Color, completeBtnBlock: { [weak self] in
            self?.updateMsgIsReadRequest()
        }) { () in
            //
        }
        CBPetPopView.share.setTitleColor(titleColor: KPet666666Color)
    }
    //MARK: - 标记已读
    private func updateMsgIsReadRequest() {
        var paramters:Dictionary<String,Any> = ["imei":""]
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters.updateValue(value.valueStr, forKey: "imei")
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.updateAllMsgIsReadRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            //返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            self?.msgCenterView.beginRefresh()
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
        }
    }
    //MARK: - 消息详情
    private func msgDetailAction(objc:Any) {
        let model = (objc as! CBPetMsgCterModel)
        switch model.message_type {
            case "5":
                let systemVC = CBPetMsgCterSystemMsgVC.init()
                self.navigationController?.pushViewController(systemVC, animated: true)
                break
            case "7":
                let fenceVC = CBPetMsgCterFenceDynmicVC.init()
                fenceVC.noticeModel = self.noticeModel
                self.navigationController?.pushViewController(fenceVC, animated: true)
                break
            case "6":
                let listenVC = CBPetMsgCterListenRcdVC.init()
                listenVC.noticeModel = self.noticeModel
                self.navigationController?.pushViewController(listenVC, animated: true)
                break
            case "3":
                let powerVC = CBPetMsgCterPowerDynmicVC.init()
                powerVC.noticeModel = self.noticeModel
                self.navigationController?.pushViewController(powerVC, animated: true)
                break
            case "2020":
                let locationVC = CBPetMsgCterLoctionRcdVC.init()
                locationVC.msgModel = model
                locationVC.noticeModel = self.noticeModel
                self.navigationController?.pushViewController(locationVC, animated: true)
                break
            case "9":
                let locationVC = CBPetMsgCterLoctionRcdVC.init()
                locationVC.msgModel = model
                locationVC.noticeModel = self.noticeModel
                self.navigationController?.pushViewController(locationVC, animated: true)
                break
            default:
                break
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
