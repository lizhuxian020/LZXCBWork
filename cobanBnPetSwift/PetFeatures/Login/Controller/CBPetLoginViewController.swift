//
//  CBPetLoginViewController.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/3/5.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON

class CBPetLoginViewController: CBPetBaseViewController {
    
    private lazy var loginViewModel:CBPetLoginViewModel = {
        let viewMd = CBPetLoginViewModel.init()
        return viewMd
    }()
    private lazy var loginRegisterMainView:CBPetLoginRegisterMainView = {
        let logView = CBPetLoginRegisterMainView.init()
        logView.backgroundColor = UIColor.white
        self.view.addSubview(logView)
        return logView
    }()
    private var tempBtn:CBPetBaseButton?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    deinit {
        //print("登录控制器CBPetLoginViewController---被释放了")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor().colorWithHexString(hexString: "#112233")
        setupView()
        self.loginRegisterMainView.setupViewModel(viewModel: self.loginViewModel)
        if self.loginRegisterMainView.viewModel is CBPetLoginViewModel {
            let mainViewModel = self.loginRegisterMainView.viewModel as! CBPetLoginViewModel
            mainViewModel.forgetBlock = { [weak self] () -> Void in
                CBLog(message: "忘记密码vc:\(CBPetForgetPwdViewController.self)")
                self?.forgetPwdClick()
            }
            
            mainViewModel.getVerificationCodeBlock = { [weak self] (sender:CBPetBaseButton,phone:String,areaCode:String) -> Void in
                //self?.startCountDownMethod(sender: sender)
                var newCode = areaCode
                if newCode.hasPrefix("+") {
                    newCode = newCode.subString(from: 1)
                }
                self?.getRegisterCodeRequest(sender: sender,email: phone,areaCode: newCode)
                self?.tempBtn = sender
            }
            self.counDownBlock = { [weak mainViewModel] (coutDown:Int,isFinished:Bool) -> Void in
                mainViewModel!.getVerificationCodeUpdateViewBlock!(coutDown,isFinished)
            }
            
            mainViewModel.registerBlock = { [weak self] (_ email:String,_ code:String,_ pwd:String,_ crCode:String) -> Void in
                CBLog(message: "注册vc:\(333)")
                self?.registerRequest(email: email, code: code, pwd: pwd, crCode: crCode)
            }
            
            mainViewModel.loginBlock = { [weak self] (phone:String,pwd:String) -> Void in
                CBLog(message: "登录vc:\(CBPetHomeViewController.self)")
                self?.loginClick(phone: phone, pwd: pwd)
            }
        }
        
        self.loginViewModel.getVerificationImage()
    }
    private func setupView() {
        self.view.backgroundColor = KPetBgmColor
        initBarWith(title: "", isBack: false)
        self.loginRegisterMainView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    //MARK: - 忘记密码
    private func forgetPwdClick() {
        let forgetVC = CBPetForgetPwdViewController.init()
        forgetVC.forgetPwdViewModel.updPwdType = CBPetSetPwdType.forget
        self.navigationController?.pushViewController(forgetVC, animated: true)
    }
    //MARK: - 登录
    private func loginClick(phone:String,pwd:String) {
        //MBProgressHUD.showHUDIcon(View: view, Animated: true)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.loginWith(Account: phone, Pwd: CBPetUtils.md5(Str: pwd), successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            /* 返回错误信息*/
            guard successModel.status == "0" else {
                switch successModel.status {
                case "102":
                    MBProgressHUD.showMessage(Msg: "密码错误".localizedStr, Deleay: 2.0)
                    break
                case "101":
                    MBProgressHUD.showMessage(Msg: "用户名不存在".localizedStr, Deleay: 2.0)
                    break
                default:
                    MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                    break
                }
                return;
            }
            MBProgressHUD.showMessage(Msg: "登录成功".localizedStr, Deleay: 2.0)
            let json = JSON.init(successModel.data as Any)
            if let value = CBPetLoginModel.deserialize(from: json.dictionary) {
                self?.addUMAlias(model:value)
                CBPetLoginModelTool.saveUser(value)
            }
            self?.jumpToHomePage()
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
        }
    }
    private func jumpToHomePage() {
        let switchModel = CBPetSwitchSystemTool.getSwitchModel()
        switch switchModel.title {
        case "巴诺宠物".localizedStr:
            let notificationName = NSNotification.Name.init(K_SwitchPetRootViewController)
            NotificationCenter.default.post(name: notificationName, object: nil)
            break
        case "巴诺手表".localizedStr:
            let notificationName = NSNotification.Name.init(K_SwitchWtRootViewController)
            NotificationCenter.default.post(name: notificationName, object: nil)
            break
        case "巴诺车联网".localizedStr:
            let notificationName = NSNotification.Name.init(K_SwitchCarNetRootViewController)
            NotificationCenter.default.post(name: notificationName, object: nil)
            break
        default:
            /* 前往切换系统页面*/
            let switchVC = CBPetSwitchSystemVC.init()
            switchVC.isSwitchSystem = false
            self.navigationController?.pushViewController(switchVC, animated: true)
            break
        }
    }
    //MARK: - 获取注册邮箱验证码
    private func getRegisterCodeRequest(sender:CBPetBaseButton,email:String,areaCode:String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if AppDelegate.isShowGoogle() {
            CBPetNetworkingManager.share.getEmailCode(Email: email, Type: "1") { [weak self] (successModel) in
                if let value = self?.view {
                    MBProgressHUD.hide(for: value, animated: true)
                }
                /* 返回错误信息*/
                guard successModel.status == "0" else {
                    MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                    return;
                }
                MBProgressHUD.showMessage(Msg: "发送成功".localizedStr, Deleay: 1.5)
                self!.startCountDownMethod(sender: sender)
            } failureBlock: { [weak self] (failureModel) in
                if let value = self?.view {
                    MBProgressHUD.hide(for: value, animated: true)
                }
            }
            return
        }
        CBPetNetworkingManager.share.getVerificationCode(Phone: email, Type: "1", areaCode: areaCode) { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            /* 返回错误信息*/
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
            MBProgressHUD.showMessage(Msg: "发送成功".localizedStr, Deleay: 1.5)
            self!.startCountDownMethod(sender: sender)
        } failureBlock: {  [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
        }

    }
    //MARK: - 注册
    private func registerRequest(email:String,code:String,pwd:String,crCode:String) {
        var paramters:Dictionary<String, Any>?
        if AppDelegate.isShowGoogle() {
            paramters = ["email":email,"pwd":CBPetUtils.md5(Str: pwd),"code":code]//"terminal_type":"0"
        } else {
            var newCode = crCode
            if newCode.hasPrefix("+") {
                newCode = newCode.subString(from: 1)
            }
            paramters = ["phone":email,"pwd":CBPetUtils.md5(Str: pwd),"code":code,"crCode":newCode]//"terminal_type":"0"
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.registerRequest(paramters: paramters!, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            /* 返回错误信息*/
            guard successModel.status == "0" else {
                switch successModel.status {
                case "109":
                    MBProgressHUD.showMessage(Msg: "此账号已被注册".localizedStr, Deleay: 2.0)
                    break
                case "103","104":
                    MBProgressHUD.showMessage(Msg: "验证码错误".localizedStr, Deleay: 2.0)
                    break
                default:
                    MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                }
                return
            }
            MBProgressHUD.showMessage(Msg: "注册成功".localizedStr, Deleay: 1.5)
            self?.endCountDownMethod(sender: self?.tempBtn ?? CBPetBaseButton.init())
            guard self?.loginViewModel.registerUpdateViewBlock == nil else {
                self?.loginViewModel.registerUpdateViewBlock!(email)
                return
            }
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
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
