//
//  CBPetPsnalPrivacySettingVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/3.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetPsnalPrivacySettingVC: CBPetBaseViewController {

    private lazy var privacyView:CBPetPsnalCterPrivcSettingView = {
        let view = CBPetPsnalCterPrivcSettingView.init()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        getAllDeviceRequest()
    }
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        initBarWith(title: "个人主页展示模块设置".localizedStr, isBack: true)
        self.view.addSubview(self.privacyView)
        self.privacyView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    //MARK: - 获取用户的宠物列表
    private func getAllDeviceRequest() {
        var paramters:Dictionary<String,Any> = Dictionary()
        /* 当前用户的宠物列表*/
        guard CBPetLoginModelTool.getUser()?.uid != nil else {
            return
        }
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = NSNumber.init(value: Int(value.valueStr) ?? 0)
        }
        CBPetNetworkingManager.share.getAllDeviceRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            MBProgressHUD.hide(for: self?.view ?? UIView.init(), animated: true)
            /* 返回错误信息*/
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                self?.privacyView.updatePrivacyData(dataSource: [CBPetUserInfoModel]())
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let petListModelObject = JSONDeserializer<CBPetPsnalCterPetAllModel>.deserializeFrom(dict: ddJson.dictionaryObject)
            if let value = petListModelObject?.allPet {
                self?.privacyView.updatePrivacyData(dataSource: value)
            }
            
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            self?.privacyView.updatePrivacyData(dataSource: [CBPetUserInfoModel]())
        }
    }
    //MARK: - 隐私设置
    private func setPrivacyRequest() {
        
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
