//
//  CBPetMsgCterLoctionRcdVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/4.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetMsgCterLoctionRcdVC: CBPetBaseViewController {

    private lazy var msgCterViewModel:CBPetMsgCterViewModel = {
        let viewModel = CBPetMsgCterViewModel()
        return viewModel
    }()
    private lazy var locationView:CBPetMsgCterLoctionRcdView = {
        let view = CBPetMsgCterLoctionRcdView.init()
        return view
    }()
    public var noticeModel:CBPetNoticeModel?
    public var msgModel:CBPetMsgCterModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* 推送通知*/
        NotificationCenter.default.addObserver(self, selector: #selector(noticeNofitication), name: NSNotification.Name.init(K_CBPetNoticeNotification), object: nil)
        
        setupView()
        self.locationView.beginRefresh()
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
        if msgModel?.message_type == "9" {
            initBarWith(title: "唤醒记录".localizedStr, isBack: true)
        } else {
            initBarWith(title: "定位记录".localizedStr, isBack: true)
        }
        
        self.view.addSubview(self.locationView)
        self.locationView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(-TabPaddingBARHEIGHT)
        }
        self.locationView.msgModel = msgModel
        self.locationView.setupViewModel(viewModel: self.msgCterViewModel)
        self.msgCterViewModel.MJHeaderRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.getLocationRcdRequest()
        }
        self.msgCterViewModel.MJFooterRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.getLocationRcdRequest()
        }
    }
    //MARK: - 获取定位记录列表
    private func getLocationRcdRequest() {
        var imeiStr = CBPetHomeInfoTool.getHomeInfo().pet.device.imei
        if let value = self.noticeModel?.imei {
            imeiStr = value
        }
        var paramters:Dictionary<String,Any> = ["imei":imeiStr ?? ""]
        if msgModel?.message_type == "9" {
            paramters["locationType"] = "1"
        }
        ///MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.getLocationRcdListRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            self?.locationView.endRefresh()
            //返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let messageListModelObject = JSONDeserializer<CBPetMsgCterModel>.deserializeModelArrayFrom(array: ddJson.arrayObject)
            guard self?.msgCterViewModel.getLocateRcdListUpdateUIBlock == nil else {
//                if let value = messageListModelObject {
//                    self?.msgCterViewModel.getLocateRcdListUpdateUIBlock!(value as! [CBPetMsgCterModel])
//                }
                self?.msgCterViewModel.getLocateRcdListUpdateUIBlock!((messageListModelObject ?? [CBPetMsgCterModel]()) as! [CBPetMsgCterModel])
                return
            }
            
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            self?.locationView.endRefresh()
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
