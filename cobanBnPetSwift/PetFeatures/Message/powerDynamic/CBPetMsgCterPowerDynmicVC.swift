//
//  CBPetMsgCterPowerDynmicVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/4.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetMsgCterPowerDynmicVC: CBPetBaseViewController {

    private lazy var msgCterViewModel:CBPetMsgCterViewModel = {
        let viewModel = CBPetMsgCterViewModel()
        return viewModel
    }()
    private lazy var powerDynmicView:CBPetMsgCterPwerDynmicView = {
        let view = CBPetMsgCterPwerDynmicView.init()
        return view
    }()
    public var noticeModel:CBPetNoticeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* 推送通知*/
        NotificationCenter.default.addObserver(self, selector: #selector(noticeNofitication), name: NSNotification.Name.init(K_CBPetNoticeNotification), object: nil)
        
        setupView()
        self.powerDynmicView.beginRefresh()
    }
    @objc private func noticeNofitication(notification: Notification) {
        let userInfo:Dictionary<String,Any> = notification.object as! Dictionary<String, Any>
        self.noticeModel = (userInfo["notice"]) as? CBPetNoticeModel
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func setupView() {
        self.view.backgroundColor = KPetBgmColor
        initBarWith(title: "电量动态".localizedStr, isBack: true)
        
        self.view.addSubview(self.powerDynmicView)
        self.powerDynmicView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(-TabPaddingBARHEIGHT)
        }
        self.powerDynmicView.setupViewModel(viewModel: self.msgCterViewModel)
        self.msgCterViewModel.MJHeaderRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.getPowerDynamicDataRequest()
        }
        self.msgCterViewModel.MJFooterRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.getPowerDynamicDataRequest()
        }
    }
    //MARK: - 获取电量动态数据
    private func getPowerDynamicDataRequest() {
        var imeiStr = CBPetHomeInfoTool.getHomeInfo().pet.device.imei
        if let value = self.noticeModel?.imei {
            imeiStr = value
        }
        let paramters:Dictionary<String,Any> = ["imei":imeiStr ?? "","messageType":"3"]
        ///MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.getMsgByMsgTypeRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            self?.powerDynmicView.endRefresh()
            //返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let powerDynamicModelObject = JSONDeserializer<CBPetMsgCterModel>.deserializeModelArrayFrom(array: ddJson.arrayObject)
            guard self?.msgCterViewModel.powerDynamicUpdateUIBlock == nil else {
                self?.msgCterViewModel.powerDynamicUpdateUIBlock!(powerDynamicModelObject! as! [CBPetMsgCterModel])
                return
            }
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            self?.powerDynmicView.endRefresh()
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
