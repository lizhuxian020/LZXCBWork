//
//  CBPetBaseViewController.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/2/27.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetBaseViewController: UIViewController,UIGestureRecognizerDelegate {
    
    public lazy var viewModel:CBPetBaseViewModel = {
        let viewModel = CBPetBaseViewModel()
        return viewModel
    }()
    lazy var tableView:UITableView = {
        let tableV = UITableView()
        tableV.backgroundColor = KPetBgmColor
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none;
        return tableV
    }()
//    lazy var noDataView:CBPetNoDataView = {
//        let dataView = CBPetNoDataView();
//        self.view.addSubview(dataView)
//        dataView.isHidden = true
//        dataView.snp_makeConstraints({ (make) in
//            make.centerX.equalTo(self.view.snp_centerX)
//            make.centerY.equalTo(self.view.snp_centerY).offset(-20)
//        })
//        return dataView
//    }()
    var networkResult:Bool?
    lazy var noNetworkView:CBPetNoNetworkView = {
        let noNetworkView = CBPetNoNetworkView()
        self.view.addSubview(noNetworkView)
        noNetworkView.isHidden = true
        noNetworkView.snp_makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        })
        return noNetworkView
    }()
    public lazy var backBtn:CBPetBaseButton = {
        let leftBtn = CBPetBaseButton.init(frame: CGRect.init(x: 0, y: 0, width: 27*KFitHeightRate, height: 24*KFitHeightRate))
        return leftBtn
    }()
    //MARK: - 导航栏左右按钮
    public lazy var leftBtn:CBPetBaseButton = {
        let leftBtn = CBPetBaseButton.init(frame: CGRect.init(x: 0, y: 0, width: 27*KFitHeightRate, height: 24*KFitHeightRate))
        return leftBtn
    }()
    public lazy var rightBtn:CBPetBaseButton = {
        let rightBtn = CBPetBaseButton.init(frame: CGRect.init(x: 0, y: 0, width: 27*KFitHeightRate, height: 24*KFitHeightRate))
        return rightBtn
    }()
    //MARK: - 定时器相关
    var count:Int?
    var enabled:Bool?
    var timer:Timer?
    var counDownBlock:((_ cout:Int,_ isFinished:Bool) -> Void)?
    
    //public var qnyToken:String?
    
    deinit {
        var className = NSString.self()
        className = String(describing: self.classForCoder) as NSString
        // vc 销毁
        CBLog(message: "===控制器==\(className)==被释放了===")
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil

        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationAttributesMethod()
        
        /* 设置系统侧滑手势*/
        if self.navigationController != nil {        
            if (self.navigationController?.responds(to: #selector(getter: self.navigationController?.interactivePopGestureRecognizer)))! {
                self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            }
        }
        
        AppDelegate.shareInstance.customizedStatusBar?.backgroundColor = UIColor.clear
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
        self.timer = nil
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupNavigationAttributesMethod()
    }
    //MARK: - 设置导航栏背景色是否透明
    public func setupNavigationAttributesMethod() {
        let className = self.getClassName()
        /*  需要设置导航栏透明的控制器 */
        if className.isEqual(to: "CBPetPersonalPageVC")
            || className.isEqual(to: "CBPetLoginViewController") {
        //|| className.isEqual(to: "CBPetPersonalCenterVC") {
            /*设置导航栏背景图片为一个空的image，这样就透明了*/
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            /* 去掉透明后导航栏下边的黑边*/
            self.navigationController?.navigationBar.shadowImage = UIImage()
        } else {
            /* 如果不想让其他页面的导航栏变为透明 需要置nil*/
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        }
        //MARK: - 设置导航栏背景色,状态栏
        /* 登录、首页、扫描设备二维码、输入绑定号、绑定成功、微聊、个人主页、虚拟围栏、围栏警告  导航栏背景色为黑色*/
        if className.isEqual(to: "CBPetLoginViewController")
            || className.isEqual(to: "CBPetHomeViewController")
            || className.isEqual(to: "CBPetScanToBindDeviceVC")
            || className.isEqual(to: "CBPetScanInputVC")
            || className.isEqual(to: "CBPetBindSuccessVC")
            || className.isEqual(to: "CBPetFunctionChatVC")
            || className.isEqual(to: "CBPetPersonalPageVC")
            || className.isEqual(to: "CBPetSetFenceViewController")
            || className.isEqual(to: "CBPetForgetPwdViewController")
            || className.isEqual(to: "CBPetFenceAlarmViewController") {
            /* 状态栏 black黑底白字 default白底黑字*/
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.navigationBar.barTintColor = KPetNavigationBarColor
            self.navigationController!.navigationBar.tintColor = UIColor.white
            let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.init(name: CBPingFang_SC_Bold, size: 16*KFitHeightRate) as Any]
            self.navigationController?.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
        } else {
            /* 状态栏 black黑底白字 default白底黑字*/
            self.navigationController?.navigationBar.barStyle = .default
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.tintColor = UIColor.white
            let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: KPetTextColor,NSAttributedString.Key.font : UIFont.init(name: CBPingFang_SC_Bold, size: 16*KFitHeightRate) as Any]
            self.navigationController?.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
        }
    }
    //MARK: - 返回按钮的icon
    private func returnBackImageName() -> String {
        let className = self.getClassName()
        /* 首页、扫描设备二维码、输入绑定号、绑定成功、微聊、个人主页、虚拟围栏、围栏警告  导航栏返回按钮为白色*/
        if className.isEqual(to: "CBPetHomeViewController")
            || className.isEqual(to: "CBPetScanToBindDeviceVC")
            || className.isEqual(to: "CBPetScanInputVC")
            || className.isEqual(to: "CBPetBindSuccessVC")
            || className.isEqual(to: "CBPetFunctionChatVC")
            || className.isEqual(to: "CBPetPersonalPageVC")
            || className.isEqual(to: "CBPetSetFenceViewController")
            || className.isEqual(to: "CBPetFenceAlarmViewController") {
            return "pet_leftArrow_white"
        } else {
            return "pet_leftArrow_black"
        }
    }
    private func getClassName() -> NSString {
        var className = NSString.self()
        className = String(describing: self.classForCoder) as NSString
        return className as NSString
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
          // Do any additional setup after loading the view.
        
        self.view.backgroundColor = KPetBgmColor
        /* 去掉透明后导航栏下边的黑边*/
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.setupNavigationAttributesMethod()
        
        NotificationCenter.default.addObserver(self, selector: #selector(noNetworkNotification), name: NSNotification.Name.init(K_CBPetNetErrorNotification), object: nil)
        
        AppDelegate.shareInstance.customizedStatusBar?.backgroundColor = UIColor.clear
    }
    /* 无网络弹框*/
    @objc public func noNetworkNotification(notifi:Notification) {
        let resultDic:[String:Any] = notifi.object as! [String : Any]
        networkResult = (resultDic["isShow"] as! Bool)
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return ((self.navigationController?.viewControllers.count ?? 0) > 1)
    }
    /* 允许接收多个手势 */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        /* false 避免侧滑返回的时候 当前页面滚动*/
        return false//((self.navigationController?.viewControllers.count ?? 0) > 1)
    }
    //MARK: - 设置标题，左右侧标题等
    func initBarWith(title:String,isBack:Bool) {
        self.title = title
        if isBack {
            let backImage:UIImage = UIImage.init(named: self.returnBackImageName()) ?? UIImage() //30 44
            backImage.withRenderingMode(.alwaysOriginal)
            self.backBtn = CBPetBaseButton.init(frame: CGRect.init(x: 0, y: 0, width: backImage.size.width+30, height: backImage.size.height))
            self.backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
            let imageVV = UIImageView(image: backImage)
            imageVV.isUserInteractionEnabled = false
            self.backBtn.addSubview(imageVV)
            imageVV.frame = CGRect(x: 0, y: self.backBtn.frame.midY, width: backImage.size.width, height: backImage.size.height)
            
            let barItem = UIBarButtonItem.init(customView: self.backBtn)
            let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            self.navigationItem.leftBarButtonItems = [barItem,spaceItem]
        } else {
            self.navigationItem.hidesBackButton = true
        }
    }
    @objc func backBtnClick() {
        self.navigationController?.popViewController(animated: true)
    }
    func initBarRight(imageName:String,action:Selector) {
        self.rightBtn.addTarget(self, action: action, for: .touchUpInside)
        self.rightBtn.setImage(UIImage.init(named: imageName), for: .normal)
        self.rightBtn.setImage(UIImage.init(named: imageName), for: .highlighted)
        let barItem = UIBarButtonItem.init(customView: rightBtn)
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -5*KFitWidthRate
        self.navigationItem.rightBarButtonItems = [spaceItem,barItem]
    }
    func initBarRight(title:String,action:Selector) {
        let btn = CBPetBaseButton.init(frame: CGRect(x: 0, y: 0, width: 50*KFitWidthRate, height: 30*KFitHeightRate))
        if title.count > 4 {
            btn.frame = CGRect(x: 0, y: 0, width: 100*KFitWidthRate, height: 30*KFitHeightRate)
        }
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.setTitle(title, for: .normal)
        btn.setTitle(title, for: .highlighted)
        self.rightBtn = btn
        let barItem = UIBarButtonItem.init(customView: btn)
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -5*KFitWidthRate
        self.navigationItem.rightBarButtonItems = [spaceItem,barItem]
    }
    func initBarLeft(title:String,action:Selector) {
        let btn = CBPetBaseButton.init(frame: CGRect(x: 0, y: 0, width: 50*KFitWidthRate, height: 30*KFitHeightRate))
        if title.count > 4 {
            btn.frame = CGRect(x: 0, y: 0, width: 100*KFitWidthRate, height: 30*KFitHeightRate)
        }
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.setTitle(title, for: .normal)
        btn.setTitle(title, for: .highlighted)
        self.leftBtn = btn
        let barItem = UIBarButtonItem.init(customView: btn)
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -5*KFitWidthRate
        self.navigationItem.leftBarButtonItems = [spaceItem,barItem]
    }
    func initBarLeft(imageName:String,action:Selector) {
        self.leftBtn.addTarget(self, action: action, for: .touchUpInside)
        self.leftBtn.setImage(UIImage.init(named: imageName), for: .normal)
        self.leftBtn.setImage(UIImage.init(named: imageName), for: .highlighted)
        let barItem = UIBarButtonItem.init(customView: leftBtn)
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -5*KFitWidthRate
        self.navigationItem.leftBarButtonItems = [spaceItem,barItem]
    }
    // MARK: - 退出登录
    public func logoutction() {
        let alertVC = UIAlertController.init(title: nil, message: "是否退出登录".localizedStr, preferredStyle: .alert)
        let alertActionSConfirm = UIAlertAction.init(title: "确定".localizedStr, style: .default) { (handler) in
            self.logoutRequestAction()
        }
        let alertActionCancel = UIAlertAction.init(title: "取消".localizedStr, style: .default) { (handler) in
        }
        alertVC.addAction(alertActionSConfirm)
        alertVC.addAction(alertActionCancel)
        UIViewController.getCurrentVC()?.present(alertVC, animated: true, completion: nil)
    }
    private func logoutRequestAction() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.logoutRequest(successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                self?.logoutActionCleanUserData()
                return;
            }
            self?.logoutActionCleanUserData()
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            self?.logoutActionCleanUserData()
        }
    }
    public func logoutActionCleanUserData() {
        let user = CBPetLoginModelTool.getUser()
        user?.token = nil
        if (user != nil) {
            CBPetLoginModelTool.saveUser(user!)
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(K_SwitchLoginViewController), object: nil)
        //MARK: - 移除别名
        if let value = CBPetLoginModelTool.getUser()?.uid {
            UMessage.removeAlias(value.valueStr, type: "bnclw_user_id") { (response, error) in
                //
                CBLog(message: "移除别名成功")
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    //MARK: - 设置别名
    func addUMAlias(model:CBPetLoginModel?) {
        if let value = model?.uid {
            UMessage.addAlias(value, type: "bnclw_user_id") { (response, error) in
                //
                CBLog(message: "设置别名成功")
            }
        }
    }
    //MARK: - 获取七牛上传凭证token
    public func getQNFileTokenRequestMethod() {
        self.viewModel.getQNFileTokenRequestMethod()
    }
    //MARK: - 定时器
    public func startCountDownMethod(sender:UIButton) {
        CBLog(message: "开始倒计时")
        countDown(timeount: 60)
        if self.enabled! {
            sender.isEnabled = true
        } else {
            sender.isEnabled = false
        }
    }
    ///验证码倒计时
    private func countDown(timeount:Int) {
        self.count = timeount
        self.enabled = false
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    ///定时器方法
    @objc private func timerFired() {
        if self.count != 1 && self.count! > 0 {
            self.count! -= 1
            self.enabled = false
            ///block回调改变btn状态
            guard self.counDownBlock == nil else {
                self.counDownBlock!(self.count!,false)
                return
            }
        } else {
            self.enabled = true
            self.timer?.invalidate()
            self.timer = nil
            
            guard self.counDownBlock == nil else {
                self.counDownBlock!(self.count!,true)
                return
            }
        }
    }
    //MARK: - 定时器
    public func endCountDownMethod(sender:UIButton) {
        CBLog(message: " 结束倒计时")
        self.enabled = true
        self.timer?.invalidate()
        self.timer = nil
        guard self.counDownBlock == nil else {
            self.counDownBlock!(self.count!,true)
            return
        }
        if self.enabled! {
            sender.isEnabled = true
        } else {
            sender.isEnabled = false
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
