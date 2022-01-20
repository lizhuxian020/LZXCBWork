//
//  CBPetHomeViewController.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/3/24.
//  Copyright © 2020 coban. All rights reserved.
//
//        /* 1到2的随机数*/
//        let arc4randomNum = arc4random_uniform(2) + 1
//        CBLog(message: "随机数:\(arc4randomNum)")

import UIKit
import SwiftyJSON
import UserNotifications

class CBPetHomeViewController: CBPetHomeMapVC, CBPetWakeUpPopViewDelegate {
    
    private var switchPetAlertView : CBPetSwitchPetAlertView = CBPetSwitchPetAlertView.init()
    
    /* 绑定手表view*/
    private lazy var bindDeviceView:CBPetHomeBindView = {
        let bindV = CBPetHomeBindView.init()
        bindV.isHidden = true
        return bindV
    }()
    /* 绑定手表申请已提交view*/
    private lazy var bindDeviceResultView:CBPetHomeBdDeviceResultV = {
        let bind = CBPetHomeBdDeviceResultV.init()
        bind.isHidden = true
        return bind
    }()
    private lazy var centerAvtarView:CBPetHomeAvatarView = {
        let avtatarView = CBPetHomeAvatarView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 50*KFitHeightRate))
        avtatarView.isUserInteractionEnabled = true
        return avtatarView
    }()
    private lazy var switchPetPopView:CBPetSwitchPetPopView = {
        let popV = CBPetSwitchPetPopView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return popV
    }()
    private lazy var avatarMarkView:CBPetAvatarMarkView = {
        let markView = CBPetAvatarMarkView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return markView
    }()
    private lazy var fencMarkView:CBPetFenceMarkView = {
        let markView = CBPetFenceMarkView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return markView
    }()
    private lazy var functionPopView:CBPetFunctionPopView = {
        let popV = CBPetFunctionPopView.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT - 200*KFitHeightRate - CGFloat(TabPaddingBARHEIGHT), width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        popV.isHidden = true
        return popV
    }()
    private lazy var toolPopView:CBPetToolPopView = {
        let popV = CBPetToolPopView.init()
        return popV
    }()
    private lazy var toolAssistanceView:CBPetToolAssistanceView = {
        let popV = CBPetToolAssistanceView.init()
        return popV
    }()
    private lazy var shoutPopView:CBPetFunctionShoutView = {
        let popV = CBPetFunctionShoutView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return popV
    }()
    private lazy var listenPopView:CBPetFunctionListenView = {
        let popV = CBPetFunctionListenView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return popV
    }()
    private lazy var goHomePopView:CBPetFuncGohomeView = {
        let popV = CBPetFuncGohomeView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return popV
    }()
    private lazy var punishmentPopView:CBPetFuncPubnishmentView = {
        let popV = CBPetFuncPubnishmentView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return popV
    }()
    private lazy var locatePopView:CBPetFuncLocatePopView = {
        let popV = CBPetFuncLocatePopView.init(frame: CGRect(x: 0, y: CGFloat(NavigationBarHeigt), width: SCREEN_WIDTH, height: 112*KFitHeightRate))
        return popV
    }()
    private lazy var inputPopView:CBPetWakeUpPopView = {
        let popV = CBPetWakeUpPopView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        popV.delegate = self
        return popV
    }()
    
    /* 定时器20s刷新数据*/
    private var timerRefreshData:Timer?
    /* 控制面板popView*/
    private lazy var ctrlPanelPopView:CBPetCtrlPanelPopView = {
        let popV = CBPetCtrlPanelPopView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return popV
    }()
    /* 控制面板加载一次*/
    private var isAllowShowPanel:Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 开始/继续定时器
        self.resumeTimer()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.locatePopView.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 暂停定时器
        self.paseTimer()
        self.locatePopView.isHidden = true
        //self.locatePopView.dissmiss()
        
        CBPetCtrlPanelView.share.removeView()
        CBPetTopSwitchBtnView.share.removeView()
        CBPetBottomSwitchBtnView.share.removeView()
    }
    deinit {
        // vc 销毁
        //print("首页CBPetHomeViewController---被释放了")
        self.timerRefreshData?.invalidate()
        self.timerRefreshData = nil
        NotificationCenter.default.removeObserver(self)
    }
    override func noNetworkNotification(notifi: Notification) {
        super.noNetworkNotification(notifi: notifi)
        self.view.bringSubviewToFront(self.noNetworkView)
        self.noNetworkView.isHidden = !(self.networkResult ?? true)
        self.noNetworkView.reloadBlock = { [weak self] () -> Void in
            CBLog(message: "重新加载")
            self!.bindDeviceView.isHidden = true
            self!.getHomeInfoRequest()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initBarWith(title: "", isBack: false)
        setupView()
        /* 推送通知*/
        NotificationCenter.default.addObserver(self, selector: #selector(noticeNofitication), name: NSNotification.Name.init(K_CBPetNoticeNotification), object: nil)
        
        /* 获取七牛token*/
        self.homeViewModel.getQNFileTokenRequestMethod()
        updateDataSource()
    }
    @objc private func noticeNofitication(notification: Notification) {
        let userInfo:Dictionary<String,Any> = notification.object as! Dictionary<String, Any>
        let noticeModel = (userInfo["notice"]) as! CBPetNoticeModel
        switch noticeModel.pushType {
        case "1":
            /* 好友聊天*/
            break
        case "2":
            /* 绑定申请*/
            let subTitle = String(format: "%@ \"%@\" %@ \"%@\"", "用户".localizedStr,noticeModel.applicaName ?? "","正在申请绑定设备宠物".localizedStr,(CBPetHomeInfoTool.getHomeInfo().pet.name ?? "念念"))
            CBPetPopView.share.showAlert(title: "申请绑定设备提醒".localizedStr, subTitle: subTitle, comfirmBtnText: "同意".localizedStr, cancelBtnText: "拒绝".localizedStr, comfirmColor: KPetAppColor, cancelColor: KPet999999Color, completeBtnBlock: { [weak self] () -> Void in
                if UIViewController.getCurrentVC() is CBPetMsgCterSystemMsgVC {
                    return
                }
                /* 处理绑定申请*/
                self?.dealWithBindApplyRequest(state: "0", messageId: noticeModel.applicaMessId ?? "")
            }, cancelBtnBlock: { [weak self] () -> Void in
                self?.dealWithBindApplyRequest(state: "2", messageId: noticeModel.applicaMessId ?? "")
            })
            break
        case "3":
            /* 宠友添加申请*/
            CBPetNoticePopView.share.showAlert(type: CBPetNoticePopType.user,noticeModel:noticeModel,completeBtnBlock: {
                if UIViewController.getCurrentVC() is CBPetPersonalPageVC {
                    return
                }
                /* 查看资料*/
                let psnalPageVC = CBPetPersonalPageVC.init()
                psnalPageVC.viewModel.isComfromNoticePush = true
                
                var petFriendModel = CBPetFuncPetFriendsModel.init()
                petFriendModel.friendId = noticeModel.friendId
                petFriendModel.friendMsgId = noticeModel.friendMsgId

                psnalPageVC.petFriendModel = petFriendModel
                
                UIViewController.getCurrentVC()?.navigationController?.pushViewController(psnalPageVC, animated: true)
            }) {}
            break
        case "4":
            compareNoticeIMEI(model: noticeModel)
            /* 设备报警 warmType = 1 出2入 3低电 */
            if noticeModel.warmType == "3" {
                CBPetNoticePopView.share.showAlert(type: CBPetNoticePopType.lowPowerAlarm,noticeModel:noticeModel,completeBtnBlock: {
                    if UIViewController.getCurrentVC() is CBPetMsgCterPowerDynmicVC {
                        return
                    }
                    let powerVC = CBPetMsgCterPowerDynmicVC.init()
                    UIViewController.getCurrentVC()?.navigationController?.pushViewController(powerVC, animated: true)
                }) {}
            } else {
                CBPetFenceAlarmPopView.share.showAlert(noticeModel:noticeModel,completeBtnBlock: {
                    if UIViewController.getCurrentVC() is CBPetFenceAlarmViewController {
                        return
                    }
                    /* 围栏警告*/
                    let fenceAlarmVC = CBPetFenceAlarmViewController.init()
                    
                    var fenceModel = CBPetMsgCterFenceDynamicModel.init()
                    fenceModel.petHead = noticeModel.petPhoto
                    fenceModel.petName = noticeModel.petName
                    fenceModel.fenceAlarmType = noticeModel.warmType
                    fenceModel.alarmLat = noticeModel.lat
                    fenceModel.alarmLng = noticeModel.lng
                    fenceModel.fenDate = CBPetHomeInfoTool.getHomeInfo().fence.data
                    
                    fenceAlarmVC.fenceAlarmModel = fenceModel
                    
                    UIViewController.getCurrentVC()?.navigationController?.pushViewController(fenceAlarmVC, animated: true)
                }) {}
            }
            break
        case "5":
            compareNoticeIMEI(model: noticeModel)
            /* 听一听*/
            CBPetNoticePopView.share.showAlert(type: CBPetNoticePopType.device,noticeModel:noticeModel,completeBtnBlock: {
                if UIViewController.getCurrentVC() is CBPetMsgCterListenRcdVC {
                    return
                }
                /* 听听*/
                let listenVC = CBPetMsgCterListenRcdVC.init()
                listenVC.noticeModel = noticeModel
                UIViewController.getCurrentVC()?.navigationController?.pushViewController(listenVC, animated: true)
            }) {}
        break
        default:
            break
        }
    }
    private func compareNoticeIMEI(model:CBPetNoticeModel) {
        if CBPetHomeInfoTool.getHomeInfo().pet.device.imei != model.imei {
            if UIViewController.getCurrentVC() is CBPetMsgCterViewController {
                return
            }
            let msgCterVC = CBPetMsgCterViewController.init()
            msgCterVC.noticeModel = model
            UIViewController.getCurrentVC()?.navigationController?.pushViewController(msgCterVC, animated: true)
        } else {
            return
        }
    }
    //MARK: - 处理绑定申请消息
    private func dealWithBindApplyRequest(state:String,messageId:String) {
        /* 0 同意 2 拒绝*/
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
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
        }
    }
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        initBarWith(title: "首页".localizedStr, isBack: false)
//        initBarLeft(imageName: "pet_personal center", action: #selector(jumpToPersonal))
        initBarLeft(imageName: "pet_home_left_deive_list", action: #selector(showSwitchPet))
        initBarRight(imageName: "pet_home_right_setting", action: #selector(jumpToMultiVC))

//        self.centerAvtarView.translatesAutoresizingMaskIntoConstraints = false
//        self.navigationItem.titleView = self.centerAvtarView
//        self.centerAvtarView.setupViewModel(viewModel: self.homeViewModel)
//        (self.homeViewModel as CBPetHomeViewModel).avtarTitleViewSwitchDeviceBlock = { [weak self] () -> Void in
//            CBLog(message: " 点击切换手表 点击切换手表 点击切换手表 ")
//            //lzxTODO:复原
//            self?.switchDeviceClick()
////            self?.resumeTimer();
//        }
        
        self.view.addSubview(self.bindDeviceResultView)
        self.bindDeviceResultView.snp_makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        })
        self.bindDeviceResultView.setupViewModel(viewModel: self.homeViewModel)

        self.view.addSubview(self.bindDeviceView)
        self.bindDeviceView.snp_makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        })
        self.bindDeviceView.setupViewModel(viewModel: self.homeViewModel)
        
        /* 未绑定设备 状态*/
        self.homeViewModel.bindDeviceBlock = { [weak self] (type) -> Void in
            switch type {
            case .clickTypeBind:
                /* 跳转绑定手表页面*/
                self!.toBindDeviceClick()
                break
            case .clickTypeLoginOut:
                /* 退出登录*/
                self?.logoutction()
                break
            case .clickTypeClose:
                break
            }
        }
        
        self.view.addSubview(self.toolPopView)
        self.toolPopView.snp_makeConstraints { make in
            make.left.right.bottom.equalTo(0)
        }
        
//        self.view.addSubview(self.functionPopView)
//        self.view.bringSubviewToFront(self.functionPopView)
        self.toolPopView.setupViewModel(viewModel: self.homeViewModel)
        self.toolAssistanceView.setupViewModel(viewModel: self.homeViewModel)
        (self.homeViewModel as CBPetHomeViewModel).functionViewBlock = { [weak self] (isShow:Bool,title:String) -> Void in
            CBLog(message: "功能view。。。。")
            if self == nil {
                return
            }
            if isShow && title == "" {
                self?.toolPopView.snp_remakeConstraints({ make in
                    make.left.right.equalTo(0)
                    make.top.equalTo(self!.view.snp_bottom).offset(-G_ToolPopView_TopHeight)
                })
                UIView.animate(withDuration: 0.25, animations: {
                    self!.view.layoutIfNeeded()
                })
            } else if isShow == false && title == "" {
                self?.toolPopView.snp_remakeConstraints({ make in
                    make.left.right.bottom.equalTo(0)
                })
                UIView.animate(withDuration: 0.25, animations: {
                    self!.view.layoutIfNeeded()
                })
            } else {
                self?.functionClickJump(title: title)
            }
        }
    }
    
    @objc private func showSwitchPet() {
        self.switchPetAlertView.selectBlock = { [weak self] (petModel:CBPetPsnalCterPetModel) in
            if petModel.title == "添加".localizedStr {
                /* 添加宠物*/
                self!.toBindDeviceClick()
            } else {
                self?.cleanMap()
                /* 选中某个宠物设备并切换*/
                self?.homeViewModel.switchDeviceRequest(imeiStr: petModel.pet.device.imei ?? "")
            }
        }
        self.switchPetAlertView.showContent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.drawCtrlPanel()
//        CBPetFenceAlarmPopView.share.showAlert(completeBtnBlock: { [weak self] in
//            //
//        }) {
//            //
//        }
    }
    private func drawCtrlPanel() {
        // [1,9)的随机数
        // arc4random_uniform(UInt32(9) + 1) {
        let progressFloat = CBPetUtils.randomBetween(firstNum: 0.0, secondNum: 1.0)
        CBLog(message: "随机百分比:\(progressFloat)")
        /* 回调圆的比例 值为0-1 */
        guard CBPetCtrlPanelView.share.drawProgressBlocks == nil else {
            CBPetCtrlPanelView.share.drawProgressBlocks!(CGFloat(progressFloat)) //0.88
            return
        }
    }
    //MARK: - 定时器暂停、开始、继续
    /* 暂停*/
    private func paseTimer() {
        guard self.timerRefreshData == nil else {
            self.timerRefreshData?.fireDate = NSDate.distantFuture
            return
        }
    }
    /* 开始*/
    private func startTimer() {
        //lzxTODO: 删除注释
//        if self.timerRefreshData == nil {
//            self.timerRefreshData = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(getHomeInfoRequest), userInfo: nil, repeats: true)
//            RunLoop.main.add(self.timerRefreshData!, forMode: .common)
//        }
        self.getHomeInfoRequest()
    }
    /* 继续*/
    private func resumeTimer() {
        //lzxTODO: 删掉return
        self.startTimer()
        return;
        guard self.timerRefreshData != nil else {
            self.startTimer()
            return
        }
        self.timerRefreshData?.fireDate = NSDate.init() as Date
    }
    //MARK: - 获取首页数据request
    @objc private func getHomeInfoRequest() {
        self.isAllowShowPanel = true
        /* 获取首页数据*/
        self.homeViewModel.getHomeInfoRequest()
        /* 获取用户信息*/
        self.homeViewModel.getUserInfoRequest()
        /* 获取各项参数*/
        self.homeViewModel.getDeviceParamtersRequest()
        /* 设置别名*/
        if let value = CBPetLoginModelTool.getUser() {
            self.addUMAlias(model:value)
        }
    }
    // MARK: - 数据源刷新
    private func updateDataSource() {
        self.homeViewModel.updateDataBlock = { [weak self] (type:CBPetHomeUpdDataType,objc:Any) -> Void in
            if UIViewController.getCurrentVC() is CBPetHomeViewController {
                CBPetTopSwitchBtnView.share.showCtrlPanel {
                }
                CBPetBottomSwitchBtnView.share.showCtrlPanel {
                }
            }
            switch type {
            case .homeInfo:
                CBLog(message: "获取首页信息信息信息信息信息")
                /* 首页数据源刷新*/
                if objc is CBBaseNetworkModel {
                    self?.pickerViewByStatus(successModel: objc as! CBBaseNetworkModel)
                    self?.locatePopView.updateSingleLocateData(model:self?.homeViewModel.homeInfoModel ?? CBPetHomeInfoModel.init())
                    self?.functionPopView.updateFunctionDataSource()
                    self?.toolPopView.updateContent()
                    self?.toolAssistanceView.updateContent()
                }
                break
            case .paramters:
                /* 设备各项参数刷新*/
                self?.ctrlPanelPopView.updateParamters(model: self?.homeViewModel.paramtersObject ?? CBPetHomeParamtersModel())
                break
            case .lsiten:
                let str = objc as! String
                if str == "听听回调".localizedStr {
                    /* 获取各项参数*/
                    self?.homeViewModel.getDeviceParamtersRequest()
                }
                break
            case .setPunishment:
                let str = objc as! String
                if str == "设置惩罚时长".localizedStr {
                    /* 获取各项参数*/
                    self?.homeViewModel.getDeviceParamtersRequest()
                }
                break
            case .singleLocate:
                let str = objc as! String
                if str == "单次定位".localizedStr {
                    /* 获取首页信息*/
                    self?.homeViewModel.getHomeInfoRequest()
                }
                break
            case .setFence:
                let str = objc as! String
                if str == "电子围栏开启".localizedStr {
                    /* 获取各项参数*/
                    self?.homeViewModel.getDeviceParamtersRequest()
                }
                break
            case .callPosition:
                let str = objc as! String
                if str == "挂失开启".localizedStr {
                    /* 获取各项参数*/
                    self?.homeViewModel.getDeviceParamtersRequest()
                }
                break
            }
        }
    }
    // MARK: - 更新视图view
    private func pickerViewByStatus (successModel:CBBaseNetworkModel) {
        if successModel.status == "0" {
            /// 接受状态,有绑定的宠物
            self.updateData()
            self.initBarWith(title: "首页".localizedStr, isBack: false)
//            self.rightBtn.removeTarget(self, action: #selector(switchDeviceClick), for: .touchUpInside)
//            if let value = self.homeViewModel.homeInfoModel?.msgUnReadCount {
//                if value == "1" {
//                    initBarRight(imageName: "pet_messageCenter_red",action: #selector(jumpToMessageCenter))
//                } else if value == "0" {
//                    initBarRight(imageName: "pet_messageCenter",action: #selector(jumpToMessageCenter))
//                } else {
//                    initBarRight(imageName: "pet_messageCenter",action: #selector(jumpToMessageCenter))
//                }
//            } else {
//                initBarRight(imageName: "pet_messageCenter",action: #selector(jumpToMessageCenter))
//            }
            self.view.backgroundColor = .white
            self.functionPopView.isHidden = false
            
            self.bindDeviceResultView.isHidden = true
            self.bindDeviceView.isHidden = true
            
            if self.isAllowShowPanel == true {
                let progressFloat = CGFloat(0.3)//CBPetUtils.randomBetween(firstNum: 0.0, secondNum: 1.0)
                if UIViewController.getCurrentVC() is CBPetHomeViewController {
                    CBPetCtrlPanelView.share.showCtrlPanel(topColor: UIColor.init().colorWithHexString(hexString: "#F8563B"), bottomColor: UIColor.init().colorWithHexString(hexString: "#F8563B", alpha: 0.1),progressfloat:progressFloat) { [weak self] (isShow:Bool) in
                        if isShow {
                            self?.ctrlPanelPopView.popView()
                            self?.ctrlPanelPopView.setupViewModel(viewModel: self!.homeViewModel)
                            self!.addCtrlPanelPopViewClickMethod()
                            CBPetCtrlPanelView.share.bringToFront()
                            self?.homeViewModel.getDeviceParamtersRequest()
                        } else {
                            self?.ctrlPanelPopView.dissmiss()
                        }
                    }
                    /* 回调圆的比例 值为0-1 */
                    if let value = self.homeViewModel.homeInfoModel?.pet.device.location.baterry {
                        let valueNum = Float(value.valueStr) ?? 0
                        if CBPetCtrlPanelView.share.drawProgressBlocks != nil {
                            CBPetCtrlPanelView.share.drawProgressBlocks!(CGFloat(valueNum/100))
                        }
                    }
                }
            }
            self.isAllowShowPanel = false
            
        } else {
            self.locatePopView.isHidden = true
            CBPetCtrlPanelView.share.removeView()
            switch successModel.rescode {
            case "0031":
                ///待处理,绑定请求已发送
                self.initBarWith(title: "首页".localizedStr, isBack: false)
                self.rightBtn.removeTarget(self, action: #selector(jumpToMessageCenter), for: .touchUpInside)
                initBarRight(imageName: "pet_home_switchDevice",action: #selector(switchDeviceClick))
                self.view.backgroundColor = .white
                self.functionPopView.isHidden = true
                if self.homeViewModel.avatarTitleViewUpdateUIBlock != nil {
                    self.homeViewModel.avatarTitleViewUpdateUIBlock!(true,self.homeViewModel.homeInfoModel?.pet.name ?? "未知".localizedStr, UIImage())
                }
                
                self.bindDeviceResultView.isHidden = false
                self.bindDeviceResultView.titleLb.text = "绑定申请已发送，请等待管理员确认".localizedStr
                self.bindDeviceView.isHidden = true
                break
            case "0032":
                ///未发绑定请求
                self.initBarWith(title: "首页".localizedStr, isBack: false)
                self.rightBtn.removeTarget(self, action: #selector(switchDeviceClick), for: .touchUpInside)
                initBarRight(imageName: "pet_messageCenter",action: #selector(jumpToMessageCenter))
                self.view.backgroundColor = .white
                self.functionPopView.isHidden = true
                if self.homeViewModel.avatarTitleViewUpdateUIBlock != nil {
                    self.homeViewModel.avatarTitleViewUpdateUIBlock!(true,self.homeViewModel.homeInfoModel?.pet.name ?? "未知".localizedStr, UIImage())
                }
                
                self.bindDeviceResultView.isHidden = true
                self.bindDeviceView.isHidden = false
                self.bindDeviceView.updateBindViewData(status: "检测该账号未绑定任何智能设备，部分功能无法使用".localizedStr)
                break
            case "0033":
                ///拒绝绑定请求,UI和待处理,绑定请求已发送 相同    ///和未发绑定请求 相同
                self.initBarWith(title: "首页".localizedStr, isBack: false)
                self.rightBtn.removeTarget(self, action: #selector(jumpToMessageCenter), for: .touchUpInside)
                initBarRight(imageName: "pet_home_switchDevice",action: #selector(switchDeviceClick))
                self.view.backgroundColor = .white
                self.functionPopView.isHidden = true
                if self.homeViewModel.avatarTitleViewUpdateUIBlock != nil {
                    self.homeViewModel.avatarTitleViewUpdateUIBlock!(true,self.homeViewModel.homeInfoModel?.pet.name ?? "未知".localizedStr, UIImage())
                }
                self.bindDeviceResultView.isHidden = false
                self.bindDeviceResultView.titleLb.text = "管理员拒绝了你的申请".localizedStr
                self.bindDeviceView.isHidden = true
                break
            default:
                break
            }
        }
        self.baiduView.isHidden = AppDelegate.shareInstance.IsShowGoogleMap
        self.googleView.isHidden = !AppDelegate.shareInstance.IsShowGoogleMap
    }
    // MARK: - 更新头像和地图数据
    private func updateData() { 
        let data = NSData.init(contentsOf: NSURL.init(string: (self.homeViewModel.homeInfoModel?.pet.photo ?? ""))! as URL)
        let originalImage = UIImage.init(data: (data as Data? ?? Data.init()))
        var thuImage = UIImage.imageByScalingAndCroppingForSourceImage(sourceImage: originalImage ?? UIImage.init(), targetSize: CGSize(width: 92, height: 92))
        thuImage = thuImage.imageConvertRoundCorner(radius: thuImage.size.height, borderWidth: 1.5, borderColor: UIColor.white)
        self.avtarImg = thuImage
        if self.homeViewModel.avatarTitleViewUpdateUIBlock != nil {
            self.homeViewModel.avatarTitleViewUpdateUIBlock!(false,self.homeViewModel.homeInfoModel?.pet.name ?? "未知".localizedStr, self.avtarImg ?? UIImage())
        }

        cleanMap()
        /* 围栏开启的时候，显示*/
        if self.homeViewModel.paramtersObject?.fenceSwitch == "1" {
            self.addMapFenceMarker()
            self.addMapCircle()
        }
        self.addMapMarker()
    }
    private func cleanMap() {
        self.baiduMapView.removeOverlays(self.baiduMapView.overlays)
        self.baiduMapView.removeAnnotations(self.baiduMapView.annotations)
        self.googleMapView.clear()
    }
    // MARK: - 跳转多重控制器
    @objc private func jumpToMultiVC() {
        let psnalVC = CBPetPersonalCenterVC()
        let userManagementVC = CBPetFuncUserManagementVC.init()
        let msgCterVC = CBPetMsgCterViewController.init()
        let configData = ["我的".localizedStr: psnalVC, "设置".localizedStr: userManagementVC, "消息".localizedStr: msgCterVC];
        let multiVC = CBPetMultiVC.init(configData: configData, titles: ["我的".localizedStr, "设置".localizedStr, "消息".localizedStr])
        multiVC.addChild(psnalVC)
        multiVC.addChild(userManagementVC)
        multiVC.addChild(msgCterVC)
        self.navigationController?.pushViewController(multiVC, animated: true)
    }
    // MARK: - 跳转到个人中心
    @objc private func jumpToPersonal(sender:UIButton) {
        let psnalVC = CBPetPersonalCenterVC()
        self.navigationController?.pushViewController(psnalVC, animated: true)
    }
    // MARK: - 切换设备click
    @objc private func switchDeviceClick() {
        CBPetSwitchPetPopView.share.showPopView { [weak self] (petModel:CBPetPsnalCterPetModel) in
            if petModel.title == "添加".localizedStr {
                /* 添加宠物*/
                self!.toBindDeviceClick()
            } else {
                self?.cleanMap()
                /* 选中某个宠物设备并切换*/
                self?.homeViewModel.switchDeviceRequest(imeiStr: petModel.pet.device.imei ?? "")
            }
        }
    }
    // MARK: - 消息中心click
    @objc private func jumpToMessageCenter() {
        let msgCterVC = CBPetMsgCterViewController.init()
        self.navigationController?.pushViewController(msgCterVC, animated: true)
    }
    private func setSliderData(simCardType:String,listenTime:String) {
        if simCardType == "0" {
            if Int(listenTime) ?? 0 > 15 {
                self.listenPopView.sliderView.setSlideDataSource(dataSourse: ["5","10","15","20","25","30"],hideTargetIndex: [])
            } else {
                self.listenPopView.sliderView.setSlideDataSource(dataSourse: ["5","7","9","11","13","15"],hideTargetIndex: [])
            }
        } else if simCardType == "1" {
            if Int(listenTime) ?? 0 > 15 {
                self.listenPopView.sliderView.setSlideDataSource(dataSourse: ["5","10","15","20","25","30"],hideTargetIndex: [])
            } else {
                self.listenPopView.sliderView.setSlideDataSource(dataSourse: ["5","7","9","11","13","15"],hideTargetIndex: [])
            }
        } else {
            if Int(listenTime) ?? 0 > 15 {
                self.listenPopView.sliderView.setSlideDataSource(dataSourse: ["5","10","15","20","25","30"],hideTargetIndex: [])
            } else {
                self.listenPopView.sliderView.setSlideDataSource(dataSourse: ["5","7","9","11","13","15"],hideTargetIndex: [])
            }
        }
    }
    // MARK: - 功能菜单点击跳转
    private func functionClickJump (title:String) {
        switch title {
        case "互动".localizedStr:
            self.toolAssistanceView.show(frame: self.toolPopView.getInteractionIconFrame())
            break
        case "喊话".localizedStr:
            if CBPetUtils.checkMicrophonePermission(resultBlock: { [weak self] (isAllow) in
                if isAllow == true {
                    /* 询问时点击了允许，然后下一步*/
                    self?.shoutPopView.popView()
                }
            }) == true {
                self.shoutPopView.popView()
            }
            self.shoutPopView.finishRcordBlock = { [weak self] (filePath:String) -> Void in
                /* 喊话语音 */
                self?.homeViewModel.shoutUploadVoiceToQiniuRequest(msgFile: filePath)
            }
            break
        case "听听".localizedStr:
            ///self.listenPopView.sliderView.setSlideDataSource(dataSourse: ["5","7","9","11","13","15"],hideTargetIndex: [])
            guard let simCardType = self.homeViewModel.homeInfoModel?.pet.device.simCardType else {return}
            self.listenPopView.popView()
            guard let paramters = self.homeViewModel.paramtersObject else {
                var model = CBPetHomeParamtersModel()
                model.listenTime = "0"
                setSliderData(simCardType: simCardType, listenTime: model.listenTime ?? "0")
                self.listenPopView.updateListenData(model: model)
                self.listenPopView.setListenBlock = { [weak self] (timeStr:String) -> Void in
                    /* 设置听听语音时长 */
                    self?.homeViewModel.setListenTimeCommandRequest(timeStr: timeStr)
                }
                return
            }
            setSliderData(simCardType: simCardType, listenTime: paramters.listenTime ?? "0")
            self.listenPopView.updateListenData(model:paramters)
            self.listenPopView.setListenBlock = { [weak self] (timeStr:String) -> Void in
                /* 设置听听语音时长 */
                self?.homeViewModel.setListenTimeCommandRequest(timeStr: timeStr)
            }
            break
        case "回家".localizedStr:
            guard self.homeViewModel.paramtersObject?.fileRecord.voiceId == nil else {
                /* 设置了回家录音，直接发回家指令*/
                self.homeViewModel.sendGoHomeCommandRequest(voiceId: self.homeViewModel.paramtersObject?.fileRecord.voiceId ?? "")
                return
            }
            /* 未设置，前往设置 */
            self.goHomePopView.setupViewModel(viewModel: self.homeViewModel)
            self.goHomePopView.popView()
            (self.homeViewModel as CBPetHomeViewModel).toRecordBlock = { [weak self] () -> Void in
                if CBPetUtils.checkMicrophonePermission(resultBlock: { [weak self] (isAllow) in
                    if isAllow == true {
                        /* 询问时点击了允许，然后下一步*/
                        self?.toSetReordingClick()
                    }
                }) == true {
                    self?.toSetReordingClick()
                }
            }
            break
        case "惩罚".localizedStr:
            if self.homeViewModel.isPunish == false {
                MBProgressHUD.showMessage(Msg: "三分钟后再试".localizedStr, Deleay: 1.5)
                break
            }
            self.punishmentPopView.popView()
            self.punishmentPopView.updatePunishmentData(model: self.homeViewModel.paramtersObject ?? CBPetHomeParamtersModel())
            self.punishmentPopView.punishmentBlock = { [weak self] (type,objc) -> Void in
                if type == "0" {
                    /* 设置惩罚时间*/
                    self?.homeViewModel.setPunishmentTimeCommandRequest(time: "\(objc)")
                } else if type == "1" {
                    /* 发起惩罚*/
                    self?.homeViewModel.initiatePunishmentCommandRequest(electric_pet: 1)
                } else if type == "2" {
                    /* 声音告警*/
                    if Int(self?.homeViewModel.homeInfoModel?.pet.device.location.baterry ?? "0") ?? 0 < 20 {
                        MBProgressHUD.showMessage(Msg: "电量低于20%,禁止惩罚".localizedStr, Deleay: 1.5)
                        return
                    }
                    self?.homeViewModel.initiatePunishmentCommandRequest(electric_pet: 0)
                }
            }
            break
        case "定位".localizedStr:
            self.locatePopView.popView()
            self.homeViewModel.singleLocateCommandRequest()
            break
        case "微聊".localizedStr:
            self.toolAssistanceView.hide()
            let chatVC = CBPetFunctionChatVC.init()
            self.navigationController?.pushViewController(chatVC, animated: true)
            break
        case "用户管理".localizedStr:
            let userManagementVC = CBPetFuncUserManagementVC.init()
            self.navigationController?.pushViewController(userManagementVC, animated: true)
            break
        case "唤醒".localizedStr:
            self.inputPopView.updateTitle("电话唤醒".localizedStr, placehold: "输入电话号码".localizedStr, isDigital: true)
            self.inputPopView.popView()
            let phone = UserDefaults.standard.object(forKey: KCBPetWakeUpLocalPhone)
            self.inputPopView.inputTF.text = phone as? String
            break
        default:
            break
        }
    }
    //MARK: - 前往录音
    private func toSetReordingClick() {
        let selectRecordVC = CBPetSelectRecordingVC.init()
        self.navigationController?.pushViewController(selectRecordVC, animated: true)
    }
    //MARK: - 前往扫码绑定设备
    private func toBindDeviceClick() {
        if CBPetUtils.checkCameraPermission(resultBlock: { [weak self] (isAllow) in
            if isAllow == true {
                CBLog(message: "用户点击了允许相机授权")
                self?.bindAction()
            } else {
                CBLog(message: "用户点击了不允许相机授权")
            }
        }) == true {
            CBLog(message: "绑定设备 绑定设备 绑定设备 绑定设备 绑定设备")
            self.bindAction()
        }
    }
    private func bindAction() {
        let scanBindVC = CBPetScanToBindDeviceVC.init()
        scanBindVC.viewModel = self.homeViewModel
        self.homeViewModel.bindDeviceUpdateDataBlock = { [weak self] () -> Void in
            /* 绑定设备后 回调刷新首页*/
            CBLog(message: "绑定设备后 回调刷新首页 绑定设备后 回调刷新首页 绑定设备后 回调刷新首页")
            self?.getHomeInfoRequest()
        }
        self.navigationController?.pushViewController(scanBindVC, animated: true)
    }
    //MARK: -- 控制面板事件
    private func addCtrlPanelPopViewClickMethod() {
        self.homeViewModel.ctrlPanelClickBlock = { [weak self] (_ objc:Any,_ isSwitch:Bool,_ status:Bool) in
            if isSwitch == true {
                self?.ctrlPanelActionSwitch(objc:objc,status: status)
            } else {
                self?.ctrlPanelAction(objc: objc)
            }
        }
    }
    private func ctrlPanelAction(objc:Any) {
        let valueStr = objc as! String
        switch valueStr {
        case "电子围栏开启".localizedStr:
            let fenceVC = CBPetSetFenceViewController.init()
            fenceVC.homeViewModel = self.homeViewModel
            self.navigationController?.pushViewController(fenceVC, animated: true)
            CBPetCtrlPanelView.share.dismissCtrlViewClick()
            break
        case "设置回家语音".localizedStr:
            let setRcdVC = CBPetSelectRecordingVC.init()
            setRcdVC.homeViewModel = self.homeViewModel
            self.navigationController?.pushViewController(setRcdVC, animated: true)
            CBPetCtrlPanelView.share.dismissCtrlViewClick()
            break
        case "设置时区".localizedStr:
            let selectTimeZVC = CBPetSelectTimeZViewController.init()
            selectTimeZVC.homeViewModel = self.homeViewModel
            self.navigationController?.pushViewController(selectTimeZVC, animated: true)
            CBPetCtrlPanelView.share.dismissCtrlViewClick()
            break
        case "定时报告".localizedStr:
            let timeReportVC = CBPetSetTimeReportViewController.init()
            self.navigationController?.pushViewController(timeReportVC, animated: true)
            CBPetCtrlPanelView.share.dismissCtrlViewClick()
            break
        default:
            break
        }
    }
    private func ctrlPanelActionSwitch(objc:Any,status:Bool) {
        let valueStr = objc as! String
        switch valueStr {
        case "电子围栏开启".localizedStr:
            if self.homeViewModel.homeInfoModel?.fence.id == nil {
                /* 无围栏*/
                let fenceVC = CBPetSetFenceViewController.init()
                fenceVC.homeViewModel = self.homeViewModel
                self.navigationController?.pushViewController(fenceVC, animated: true)
                CBPetCtrlPanelView.share.dismissCtrlViewClick()
            } else {
                /* 有围栏，设置围栏开关*/
                self.homeViewModel.setFenceStatusCommandRequest(status: status == true ? "1" : "0")
            }
            break
        case "挂失开启".localizedStr:
            self.homeViewModel.setCallPosiActionStatusCommandRequest(status: status == true ? "1" : "0")
            break
        case "定时报告".localizedStr:
            self.homeViewModel.setTimeReportStatusCommandRequest(status: status == true ? "1" : "0")
            break
        default:
            break
        }
    }
    //MARK: -- CBPetWakeUpPopViewDelegate
    func updateTextFieldValue(_ inputStr: String, returnTitle title: String) {
        if self.homeViewModel.homeInfoModel?.pet.device.online == "1" {
            MBProgressHUD.showMessage(Msg: "设备已在线,无须唤醒".localizedStr, Deleay: 1.5)
            return
        }
        if inputStr.count > 0 {
            UserDefaults.standard.setValue(inputStr, forKey: KCBPetWakeUpLocalPhone)
        }
        let phone = "telprompt://" + inputStr
        UIApplication.shared.openURL(NSURL.init(string: phone)! as URL)
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
extension CBPetHomeViewController {

    func getModelArr(dataString:String) -> [CBPetCoordinateObject] {
        let dataArr = dataString.components(separatedBy: ",")
        var modelArr = Array<CBPetCoordinateObject>()
        for index in 0..<dataArr.count {
            var model = CBPetCoordinateObject.init()
            if index + 2 < dataArr.count {
                var coordinate = CLLocationCoordinate2DMake(Double(dataArr[index+1])!,Double(dataArr[index])!)
                if 0 > Double(dataArr[index+1])! || Double(dataArr[index+1])!  > 90 {
                    /* 若纬经 变成了经纬，则调换位置*/
                    coordinate.latitude = Double(dataArr[index])!
                    coordinate.longitude = Double(dataArr[index+1])!
                }
                model.coordinate = coordinate
                model.radius = Float(dataArr[index+2])
                modelArr.append(model)
            }
        }
        return modelArr
    }
    private func addMapMarker() {
        guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
            let normalAnnotation = CBPetNormalAnnotation.init()
            normalAnnotation.coordinate = CLLocationCoordinate2DMake(Double(self.homeViewModel.homeInfoModel?.pet.device.location.lat ?? "0")!, Double(self.homeViewModel.homeInfoModel?.pet.device.location.lng ?? "0")!)
            normalAnnotation.title = nil
            self.baiduMapView.addAnnotation(normalAnnotation)
            self.baiduMapView.setCenter(CLLocationCoordinate2DMake(Double(self.homeViewModel.homeInfoModel?.pet.device.location.lat ?? "0")!, Double(self.homeViewModel.homeInfoModel?.pet.device.location.lng ?? "0")!) , animated: true)
            return
        }
        let marker = GMSMarker.init()
        marker.position = CLLocationCoordinate2DMake(Double(self.homeViewModel.homeInfoModel?.pet.device.location.lat ?? "0")!, Double(self.homeViewModel.homeInfoModel?.pet.device.location.lng ?? "0")!)
        marker.iconView = self.avatarMarkView
        marker.map = self.googleMapView
        self.avatarMarkView.updateIconImage(iconImage: self.avtarImg ?? UIImage.init(named: "pet_mapAvatar_default")!)
        self.avatarMarkView.updateHomeInfoModel(homeModel: self.homeViewModel.homeInfoModel ?? CBPetHomeInfoModel())
        self.googleMapView.camera = GMSCameraPosition.camera(withLatitude: Double(self.homeViewModel.homeInfoModel?.pet.device.location.lat ?? "0")!, longitude: Double(self.homeViewModel.homeInfoModel?.pet.device.location.lng ?? "0")!, zoom: 15)
    }
    private func addMapFenceMarker() {
        self.polygonCoordinate = self.getModelArr(dataString: self.homeViewModel.homeInfoModel?.fence.data ?? "")
        if self.polygonCoordinate.count > 0 {
            let coordinateModel = self.polygonCoordinate[0]
            let coord = CLLocationCoordinate2DMake(Double(coordinateModel.coordinate?.latitude ?? 0), Double(coordinateModel.coordinate?.longitude ?? 0))
            guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
                let fenceAnnotation = CBPetFenceAnnotation.init()
                fenceAnnotation.coordinate = coord
                fenceAnnotation.title = nil
                self.baiduMapView.addAnnotation(fenceAnnotation)
                return
            }
        
            let marker = GMSMarker.init()
            marker.position = coord
            marker.iconView = self.fencMarkView
            marker.map = self.googleMapView
        }
    }
    /* 置换法，上升：低买高卖 下跌：高卖低买  当天内完成操作*/
    /* 半仓滚动做T：每次低仓位买入相同仓位，然后高点T出 或者 高点T出后再买回相同仓位*/
    /* 三层底仓滚动：*/
    private func addMapCircle() {
        if self.polygonCoordinate.count > 0 {
            let coordinateModel = self.polygonCoordinate[0]
            let coord = CLLocationCoordinate2DMake(Double(coordinateModel.coordinate?.latitude ?? 0), Double(coordinateModel.coordinate?.longitude ?? 0))
            let radius = CLLocationDistance(coordinateModel.radius ?? 0)
            guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
                let circle = BMKCircle.init(center: coord, radius: radius)
                self.baiduMapView.add(circle)
                self.addBaiduMapFitCircleFence(model: coordinateModel, radius: Double(coordinateModel.radius ?? 0))
                return
            }
           
            let circle = GMSCircle(position: coord, radius: radius)
            circle.fillColor = UIColor.init().colorWithHexString(hexString: "#2DDFAF", alpha: 0.1)
            circle.strokeColor = KPetAppColor
            
            //circle.map = self.googleMapView
            if 0 < coord.latitude && coord.latitude  <= 90 {
                circle.map = self.googleMapView
            }
        
            var bounds = GMSCoordinateBounds.init()
            bounds = bounds.includingCoordinate(coord)
            self.googleMapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30))//30.0
            let zoomLevel = GMSCameraPosition.zoom(at: coord, forMeters: radius, perPoints: 50)//50.0
            self.googleMapView.animate(toZoom: zoomLevel)
        }
    }
    private func addBaiduMapFitCircleFence(model:CBPetCoordinateObject,radius:Double) {
        // 一个点的长度是0.870096
        let circlePoint = BMKMapPointForCoordinate(model.coordinate ?? CLLocationCoordinate2DMake(Double(0), Double(0)))
        let pointRadius = radius/0.6
        let fitRect = BMKMapRectMake(circlePoint.x - pointRadius, circlePoint.y - pointRadius, pointRadius*2, pointRadius*2)
        self.baiduMapView.setVisibleMapRect(fitRect, animated: true)
    }
}
struct CBPetCoordinateObject {
    var coordinate:CLLocationCoordinate2D?
    var radius:Float?
}
