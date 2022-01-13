//
//  CBPetMsgCterListenRcdVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/4.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetMsgCterListenRcdVC: CBPetBaseViewController {

    private lazy var msgCterViewModel:CBPetMsgCterViewModel = {
        let viewModel = CBPetMsgCterViewModel()
        return viewModel
    }()
    private lazy var msgCterListenRcdView:CBPetMsgCterListenRcdView = {
        let view = CBPetMsgCterListenRcdView.init()
        return view
    }()
    public var noticeModel:CBPetNoticeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* view的 y 从 导航栏以下算起*/
        //self.edgesForExtendedLayout = UIRectEdge.bottom
        
        /* 推送通知*/
        NotificationCenter.default.addObserver(self, selector: #selector(noticeNofitication), name: NSNotification.Name.init(K_CBPetNoticeNotification), object: nil)
        
        setupView()
        self.msgCterListenRcdView.beginRefresh()
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
        initBarWith(title: "听听记录".localizedStr, isBack: true)
        
        self.view.addSubview(self.msgCterListenRcdView)
        self.msgCterListenRcdView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(-TabPaddingBARHEIGHT)
        }
        self.msgCterListenRcdView.setupViewModel(viewModel: self.msgCterViewModel)
        self.msgCterViewModel.MJHeaderRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.getListenMsgDataRequest()
        }
        self.msgCterViewModel.MJFooterRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.getListenMsgDataRequest()
        }
        self.msgCterViewModel.listenRcdPlayUIBlock = { [weak self] (model:CBPetMsgCterModel) in
            /* 播放语音*/
            CBPetChatPlayVoiceManager.share.playVoiceUrl(model: model)
//            CBPetChatPlayVoiceManager.share.playTalkVoiceEndBlock = { (objc:Any) -> Void in
//                /* 播放语音结束，设置已读 */
//                //self?.cvstionView.updateChatData(dataSource: self!.arrayDataSource)
//            }
            self?.setListenMsgDataRequest(msgId: model.id ?? "")
        }
    }
    //MARK: - 获取听一听消息数据
    private func getListenMsgDataRequest() {
        var imeiStr = CBPetHomeInfoTool.getHomeInfo().pet.device.imei
        if let value = self.noticeModel?.imei {
            imeiStr = value
        }
        let paramters:Dictionary<String,Any> = ["imei":imeiStr ?? "","messageType":"6"]
        ///MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.getMsgByMsgTypeRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            self?.msgCterListenRcdView.endRefresh()
            //返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let listenModelObject = JSONDeserializer<CBPetMsgCterModel>.deserializeModelArrayFrom(array: ddJson.arrayObject)
            guard self?.msgCterViewModel.listenRcdUpdateUIBlock == nil else {
                self?.msgCterViewModel.listenRcdUpdateUIBlock!(listenModelObject! as! [CBPetMsgCterModel])
                return
            }
            //self?.msgCterListenRcdView.updateListenData(dataSource: listenModelObject! as! [CBPetMsgCterModel])
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            self?.msgCterListenRcdView.endRefresh()
        }
    }
    //MARK: - 设置听一听消息已读
    private func setListenMsgDataRequest(msgId:String) {
        let paramters:Dictionary<String,Any> = ["ids":msgId]
        ///MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.updateMsgIsReadByIdsRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
             //返回错误信息
             guard successModel.status == "0" else {
                 MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                 return;
             }
            self?.getListenMsgDataRequest()
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            self?.msgCterListenRcdView.endRefresh()
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
