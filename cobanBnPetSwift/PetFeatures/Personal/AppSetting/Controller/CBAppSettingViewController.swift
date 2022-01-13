//
//  CBAppSettingViewController.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/4/7.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBAppSettingViewController: CBPetBaseViewController,UITableViewDelegate,UITableViewDataSource {

    private var arrayData = [Any]()
    
    private lazy var footView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
        view.backgroundColor = UIColor.red
        return view
    }()
    private lazy var signOutBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect(x: (SCREEN_WIDTH - 200)/2, y: SCREEN_HEIGHT - CGFloat(NavigationBarHeigt) - 40 - CGFloat(TabPaddingBARHEIGHT) - 60, width: 200, height: 40))
        btn.setTitle("退出登录", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        //btn.setTitleColor(kBlueColor, for: .normal)
        btn.backgroundColor = kBlueColor
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = kBlueColor.cgColor
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(signOutClick), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupView()
        initData()
    }
    
    private func setupView() {
        self.initBarWith(title: "APP设置".localizedStr, isBack: true)
        self.view.backgroundColor = KPetBgmColor
        
        self.tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), style: .plain)
        self.tableView.backgroundColor = KPetBgmColor
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        
        self.tableView.addSubview(self.signOutBtn)
    }
    private func initData() {
        //CBAppSettingModel
        let arrLeftTitle = ["消息通知","修改密码","清除缓存","关于我们"]
        let arrRightText = ["","","3M",""]
        for i in 0..<arrLeftTitle.count {
//            var model = CBAppSettingModel()
//            model.leftTitle = arrLeftTitle[i]
//            model.rightText = arrRightText[i]
//            arrayData.append(model)
        }
    }
    //MARK: -- 退出登录
    @objc private func signOutClick() {
        let alertControl = UIAlertController.init(title: nil, message: "是否退出登录".localizedStr, preferredStyle: .alert)
        let actionConfirm = UIAlertAction.init(title: "确定".localizedStr, style: .default) { (handler) in
            self.dismiss(animated: true, completion: nil)
            self.signOutRequest()
        }
        
        alertControl.addAction(actionConfirm)
        let actionCancel = UIAlertAction.init(title: "取消".localizedStr, style: .default) { (handler) in
        }
        alertControl.addAction(actionCancel)
        self.present(alertControl, animated: true, completion: nil)
    }
    private func signOutRequest() {
        MBProgressHUD.showHUDIcon(View: view, Animated: true)
        CBPetNetworkingManager.share.logoutRequest(successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            /* 返回错误信息*/
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
            self!.someActionAfterSignOut()
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
        }
    }
    private func someActionAfterSignOut() {
        let userModel = CBPetLoginModelTool.getUser()
        userModel?.token = nil
        CBPetLoginModelTool.saveUser(userModel!)
        // 跳转到登录页面
        //NotificationCenter.default.post(name: K_SwitchLoginViewController, object: nil)
        let notificationName = NSNotification.Name.init(K_SwitchLoginViewController)
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CBAppSettingTableViewCell.cellCopyTableView(tableView: tableView)
        if self.arrayData.count > indexPath.row {
//            let model:CBAppSettingModel = self.arrayData[indexPath.row] as! CBAppSettingModel
//            cell.appSettingModel = model
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
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
