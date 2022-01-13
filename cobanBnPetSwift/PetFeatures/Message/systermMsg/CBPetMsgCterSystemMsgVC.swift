//
//  CBPetMsgCterSystemMsgVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/4.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetMsgCterSystemMsgVC: CBPetBaseViewController {

    private lazy var msgCterViewModel:CBPetMsgCterViewModel = {
        let viewModel = CBPetMsgCterViewModel()
        return viewModel
    }()
    private lazy var systemMsgView:CBPetMsgCterSystemMsgView = {
        let view = CBPetMsgCterSystemMsgView.init()
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        self.systemMsgView.beginRefresh()
    }
    private func setupView() {
        self.view.backgroundColor = KPetBgmColor
        initBarWith(title: "系统消息".localizedStr, isBack: true)
        
        self.view.addSubview(self.systemMsgView)
        self.systemMsgView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(-0)
        }
        self.systemMsgView.setupViewModel(viewModel: self.msgCterViewModel)
        /* 上拉下拉*/
        self.msgCterViewModel.MJHeaderRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.getBindApplicationDataRequest()
        }
        self.msgCterViewModel.MJFooterRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.getBindApplicationDataRequest()
        }
        /* 处理系统消息，同意或拒绝*/
        self.msgCterViewModel.dealWithSystemMsgBlock = { [weak self] (state:String,messageId:String) in
            self?.dealWithBindApplyRequest(state: state, messageId: messageId)
        }
        
    }
    //MARK: - 获取绑定申请数据
    private func getBindApplicationDataRequest() {
        let imeiStr = CBPetHomeInfoTool.getHomeInfo().pet.device.imei
        let paramters:Dictionary<String,Any> = ["imei":imeiStr ?? "","messageType":"5","uid":CBPetLoginModelTool.getUser()?.uid ?? ""]
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.getMsgByMsgTypeRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            self?.systemMsgView.endRefresh()
            //返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let systemMsgModelObject = JSONDeserializer<CBPetMsgCterModel>.deserializeModelArrayFrom(array: ddJson.arrayObject)
            guard self?.msgCterViewModel.systemMsgUpdateUIBlock == nil else {
                self?.msgCterViewModel.systemMsgUpdateUIBlock!(systemMsgModelObject as? [CBPetMsgCterModel] ?? [CBPetMsgCterModel]())///[CBPetMsgCterModel]
                return
            }
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            self?.systemMsgView.endRefresh()
        }
    }
    //MARK: - 处理绑定申请消息
    private func dealWithBindApplyRequest(state:String,messageId:String) {
        let paramters:Dictionary<String,Any> = ["state":state,"messageId":messageId]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.dealWithApplicationRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            //返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            //let ddJson = JSON.init(successModel.data as Any)
            self?.getBindApplicationDataRequest()
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
        }
    }
    //MARK: - 删除消息（报警消息和绑定消息）
    private func deleteMessageRequest() {
        let paramters:Dictionary<String,Any> = ["":""]
        ///MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.getDeleteMessageByIdsRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            self?.systemMsgView.endRefresh()
            //返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            self?.getBindApplicationDataRequest()
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            self?.systemMsgView.endRefresh()
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
