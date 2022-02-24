//
//  AppDelegate.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/2/26.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate, UITabBarControllerDelegate {

    var window: UIWindow?
    ///单例
    @objc public static let shareInstance:AppDelegate = {
        let appDelegate = AppDelegate.init()
        return appDelegate
    }()
    /* 全局变量是否展示google地图*/
    @objc open var IsShowGoogleMap:Bool = true
    @objc open var isShowPlayBackView:Bool = false
    /* 车联网状态栏*/
    @objc open var customizedStatusBar:UIView?
    /* 角标*/
    var badgeNumber:NSInteger = 0
    
    class public func isShowGoogle() -> Bool {
        let userLanguage:[String] = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        var IsShowGoogleMap = true
        if userLanguage.first?.hasPrefix("zh") == true {
            IsShowGoogleMap = false
        }
        return IsShowGoogleMap
    }
    
    /* 在oc中这样写单例才能被调用 */
//    @objc open func shareInstanceFunc() -> AppDelegate {
//        return AppDelegate.shareInstance
//    }
    private lazy var petHomeVC:CBPetHomeViewController = {
        let vv = CBPetHomeViewController()
        return vv
    }()
    private lazy var wtHomeVC:CBWtHomeViewController = {
        let vv = CBWtHomeViewController()
        return vv
    }()
    private lazy var carHomeVC:MainTabBarViewController = {
        let vv = MainTabBarViewController()
        vv.delegate = self
        return vv
    }()
    private lazy var petNav:CBPetBaseNavigationViewController = {
        let nav = CBPetBaseNavigationViewController.init(rootViewController: self.petHomeVC)
        return nav
    }()
    private lazy var wtNav:CBWtBaseNavigationController = {
        let nav = CBWtBaseNavigationController.init(rootViewController: self.wtHomeVC)
        return nav
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let loginVC = CBPetLoginViewController.init()
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        /* 判断系统语言展示百度地图或者谷歌地图*/
        IsShowGoogleMap = AppDelegate.isShowGoogle()
        
        monitorNotification()
        initConfiguration(launchOptions: launchOptions)
        
        let userInfoModel = CBPetLoginModelTool.getUser()
        guard userInfoModel?.token == nil else {
            // 已登陆状态
            let switchModel = CBPetSwitchSystemTool.getSwitchModel()
            switch switchModel.title {
            case "巴诺宠物".localizedStr:
                self.switchPetMainViewController()
                break
            case "巴诺手表".localizedStr:
                self.switchWtMainViewController()
                break
            case "巴诺车联网".localizedStr:
                self.switchCarNetMainViewController()
                break
            default:
                self.switchSystemViewController()
                break
            }
            return true
        }
        // 跳转到登陆页面
        let nav = CBPetBaseNavigationViewController.init(rootViewController: loginVC)
        self.window?.rootViewController = nav
        return true
    }
    func initConfiguration(launchOptions:[UIApplication.LaunchOptionsKey: Any]?) {
        /* 百度*/
        let baiduManager = BMKMapManager.init()
        /// "ez3XELufZYgRK5XGP70XSOGYkxjYZDdt" 宠物的
        /// "iubOgPuj5aLUwQF2mrRmFrXUXnbZM970" 物联网的
        let result = baiduManager.start("iubOgPuj5aLUwQF2mrRmFrXUXnbZM970", generalDelegate: nil)
//        let result = baiduManager.start("4AOKqVE1Ac5DtA8aD2IqkbtActwwSz8s", generalDelegate: nil)
        
        if result {
            CBLog(message: "百度地图引擎启动成功")
        }
        /* google*/ ///AIzaSyCD__IsJ98qr7XHUnAuxUhGH5sh4jwIF3s
        GMSServices.provideAPIKey("AIzaSyCSKYnvdJJIW8DJTuvQUKtY7Ov9P5hHw3A")
        
        /* 友盟推送*/
//        AppKey
//        5f03c649570df3394b000063
//        App Master Secret
//        agdzp1azkfjfrrw3uilafwqayjf158ss
        if self.badgeNumber > 0 {
            self.badgeNumber = 0
        }
        UMConfigure.setLogEnabled(true)
        UMConfigure.initWithAppkey("5f03c649570df3394b000063", channel: "")
        // push组件基本功能配置 openDebugMode
        let entity = UMessageRegisterEntity.init()
        //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
        entity.types = Int(UMessageAuthorizationOptions.badge.rawValue|UMessageAuthorizationOptions.sound.rawValue|UMessageAuthorizationOptions.alert.rawValue)
        /* 选择为none,为的是自定义弹窗 */
        if #available(iOS 10.0, *) {
             //如果要在iOS10显示交互式的通知，必须注意实现以下代码
            let action1 = UNNotificationAction.init(identifier: "action1_identifier", title: "打开应用", options: .foreground)
            let action2 = UNNotificationAction.init(identifier: "action2_identifier", title: "忽略", options: .foreground)
            //UNNotificationCategoryOptionNone
            //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
            //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
            let category1 = UNNotificationCategory.init(identifier: "category1", actions: [action1, action2], intentIdentifiers: [], options: .customDismissAction) //customDismissAction
            let categories = NSSet.init(objects: category1)
            entity.categories = (categories as! Set<AnyHashable>)
            UNUserNotificationCenter.current().delegate = self
            UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (granted, error) in
                if granted {
                    CBLog(message: "友盟====:\("注册成功 允许推送")")
                } else {
                    CBLog(message: "友盟====:\("注册失败 不允许推送")")
                }
            }
        } else {
            //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
            // Fallback on earlier versions
            let action1 = UIMutableUserNotificationAction.init()
            action1.identifier = "action1_identifier"
            action1.title = "打开应用"
            action1.activationMode = .foreground
            let action2 = UIMutableUserNotificationAction.init()
            action2.identifier = "action2_identifier"
            action2.title = "忽略"
            action2.activationMode = .background //当点击的时候不启动程序，在后台处理
            action2.isAuthenticationRequired = true //需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
            action2.isDestructive = true
            let actionCategory1 = UIMutableUserNotificationCategory.init()
            actionCategory1.identifier = "category1" // 这组动作的唯一标示
            actionCategory1.setActions([action1, action2], for: .default)
            let categories = NSSet.init(objects: actionCategory1)
            entity.categories = (categories as! Set<AnyHashable>)
        }
        //-- 注册本地推送
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self;
            center.requestAuthorization(options: (UNAuthorizationOptions(rawValue: UNAuthorizationOptions.RawValue(UInt8(UNAuthorizationOptions.badge.rawValue) | UInt8(UNAuthorizationOptions.alert.rawValue) | UInt8(UNAuthorizationOptions.sound.rawValue)))), completionHandler: { (granted, error) in
                
                if error != nil {
                    print("成功了")
                }
            })
            // 请求授权时异步进行的，这里需要在主线程进行通知的注册
            DispatchQueue.main.async {
                //UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            let settings = UIUserNotificationSettings.init(types: (UIUserNotificationType(rawValue: UIUserNotificationType.RawValue(UInt8(UIUserNotificationType.alert.rawValue) | UInt8(UIUserNotificationType.badge.rawValue) | UInt8(UIUserNotificationType.sound.rawValue)))), categories: nil)
            //UIApplication.shared.registerUserNotificationSettings(settings)
            // 请求授权时异步进行的，这里需要在主线程进行通知的注册
            DispatchQueue.main.async {
                //UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    // 注册通知，获取deviceToken
    func registerForRemoteNotifications() {
        // 请求授权时异步进行的，这里需要在主线程进行通知的注册
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    // MARK: -- 通知监听
    func monitorNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(switchPetMainViewController), name: NSNotification.Name.init(K_SwitchPetRootViewController), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(switchWtMainViewController), name: NSNotification.Name.init(K_SwitchWtRootViewController), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(switchCarNetMainViewController), name: NSNotification.Name.init(K_SwitchCarNetRootViewController), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(switchToLoginView), name: NSNotification.Name.init(K_SwitchLoginViewController), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: -- 进入宠物主页面
    @objc func switchPetMainViewController() {
        if self.window?.rootViewController is CBWtBaseNavigationController {
            self.window?.rootViewController?.removeFromParent()
        }
        self.window?.rootViewController = self.petNav
        self.customizedStatusBar?.backgroundColor = UIColor.clear
    }
    // MARK: -- 进入手表主页面
    @objc func switchWtMainViewController() {
        if self.window?.rootViewController is CBPetBaseNavigationViewController {
            self.window?.rootViewController?.removeFromParent()
        }
        self.window?.rootViewController = self.wtNav
        self.customizedStatusBar?.backgroundColor = UIColor.clear
    }
    // MARK: -- 进入车联网主页面
    @objc func switchCarNetMainViewController() {
        self.window?.rootViewController = self.carHomeVC
        self.customizedStatusBar?.backgroundColor = UIColor.black
    }
    // MARK: -- 切换到登录页面
    @objc func switchToLoginView() {
        let loginVC = CBPetLoginViewController.init()
        let nav = CBPetBaseNavigationViewController.init(rootViewController: loginVC)
        self.window?.rootViewController = nav
        self.customizedStatusBar?.backgroundColor = UIColor.clear
    }
    // MARK: -- 进入选择系统主页面
    @objc func switchSystemViewController() {
        let switchVC = CBPetSwitchSystemVC.init()
        switchVC.isSwitchSystem = false
        let nav = CBPetBaseNavigationViewController.init(rootViewController: switchVC)
        self.window?.rootViewController = nav
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        /// 进入后台
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        /// 激活，进入前台
//        self.createLocalNotification(userInfo: [
//            "body": [
//                "title": "body_title",
//                "body": "body_body",
//                "watchAlarmType": "watchAlarmType",
//                "productType": "2",
//                "phone": "123123213",
//                "pushType": "2",
//                "imei": "864364050000061",
//                "applicaName": "applicaName",
//                "applicaMessId":"applicaMessId",
//            ]
//        ])
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // 从userDefault中获取到的，返回的是一个数组,表示在当前APP下使用过的。["zh-Hans-CN","en"]
        IsShowGoogleMap = AppDelegate.isShowGoogle()
        /* 设置别名*/
        if let model = CBPetLoginModelTool.getUser(),let value = model.uid {
            UMessage.addAlias(value, type: "bnclw_user_id") { (response, error) in
                CBLog(message: "设置别名成功")
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    ///iOS10以下使用这两个方法接收通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        UMessage.setAutoAlert(false)
        if #available(iOS 10.0, *) {
            UMessage.didReceiveRemoteNotification(userInfo)
        }
        //....TODO
        //过滤掉Push的撤销功能，因为PushSDK内部已经调用的completionHandler(UIBackgroundFetchResultNewData)，
        //防止两次调用completionHandler引起崩溃
        if userInfo["aps.recall"] != nil {
            completionHandler(UIBackgroundFetchResult.newData)
        }
        CBLog(message: "静默推送..")
        /* 使用了静默推送方式下获取 自定义弹框推送内容 */
        self.createLocalNotification(userInfo: userInfo as NSDictionary)
    }
    ///iOS10新增：处理前台收到通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            UMessage.setAutoAlert(false)
            //应用处于前台时的远程推送接受
            //必须加这句代码
            UMessage.didReceiveRemoteNotification(userInfo)
        } else {
            //应用处于前台时的本地推送接受
        }
        if notification.request.identifier == "CBPetNoticeLocationNotificationID" {
            completionHandler(UNNotificationPresentationOptions(rawValue:UNNotificationPresentationOptions.sound.rawValue | UNNotificationPresentationOptions.badge.rawValue | UNNotificationPresentationOptions.alert.rawValue))
        }
    }
    ///iOS10新增：处理后台点击通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            //应用处于后台时的远程推送接受
            //必须加这句代码
            UMessage.didReceiveRemoteNotification(userInfo)
        } else {
            //应用处于前台时的本地推送接受
        }
        completionHandler()
        
        /* 点击通知栏 跳转 */
        let state = UIApplication.shared.applicationState
        if state == .active {
            /* 前台*/
        } else if state == .background {
            /* 后台*/
        }
        self.clickNotificationAction(userInfo: response.notification.request.content.userInfo as NSDictionary)
        self.badgeNumber -= 1
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var deviceId = String()
        if #available(iOS 13.0, *) {
            let bytes = [UInt8](deviceToken)
            for item in bytes {
                deviceId += String(format:"%02x", item&0x000000FF)
            }
            CBLog(message: "deviceTokeniOS 13 ：\(deviceId)")
        } else {
            let device11 = NSData(data: deviceToken)
            let device_Token22 = device11.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
            CBLog(message: "deviceToken11====:\(device_Token22)")
            
            let device33 = deviceToken.map{(String(format: "%02x", $0))}.joined()
            CBLog(message: "deviceToken33====:\(device33)")
            ///但是，有大神做过测试，下面这种方式最快
            let device44 = deviceToken.reduce("",{$0 + String(format:"%02x",$1)})
            CBLog(message: "deviceToken44====:\(device44)")
        }
        //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
        //传入的devicetoken是系统回调didRegisterForRemoteNotificationsWithDeviceToken的入参，切记
        //UMessage.registerDeviceToken(deviceToken)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        CBLog(message: "error:\(error)")
    }
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if self.isShowPlayBackView == true {
            let notificationName = NSNotification.Name.init("kHidePlayBackView")
            NotificationCenter.default.post(name: notificationName, object: nil)
            return false
        }
        return true
    }
}
// 把要打印的日志写在和AppDelegate同一个等级的方法中,即不从属于AppDelegate这个类，这样在真个项目中才能使用这个打印日志,因为这就是程序的入口,
//这里的T表示不指定message参数类型
func CBLog<T>(message: T, fileName: String = #file, funcName: String = #function, lineNum : Int = #line) {
    #if DEBUG
        /**
         * 此处还要在项目的build settings中搜索swift flags,找到 Other Swift Flags 找到Debug
         * 添加 -D DEBUG,即可。
         */
         // 1.对文件进行处理
        let file = (fileName as NSString).lastPathComponent
        // 2.打印内容
        print("宠物[\(file)][\(funcName)](\(lineNum))\(message)")
        
    #endif
}
extension AppDelegate {
    func createLocalNotification(userInfo:NSDictionary) {
        var alertTitle = ""
        var alertSubTitle = ""
        var alertBody = ""
        let ddJsonBodyInfo = JSON.init(userInfo["body"] as Any)
        let noticeModelObjc = CBPetNoticeModel.deserialize(from: CBPetUtils.getDictionaryFromJSONString(jsonString: ddJsonBodyInfo.stringValue))
//        let dicc : Dictionary = userInfo["body"] as! Dictionary<String, Any>
//        let noticeModelObjc = CBPetNoticeModel.deserialize(from: dicc)
        CBLog(message: "推送过来的内容:\(userInfo)")
        CBLog(message: userInfo)
        /* 手表*/
        if noticeModelObjc?.productType == "1" {
            /* 消息列表*/
            if noticeModelObjc?.pushType == "0" {
                alertTitle = self.returnTitle(type: noticeModelObjc?.watchAlarmType ?? "")
                alertBody = self.returnBody(type: noticeModelObjc?.watchAlarmType ?? "", phone: noticeModelObjc?.phone ?? "")
                NotificationCenter.default.post(name: NSNotification.Name.init(KCBWtMessageNotification), object: nil)
            } else if noticeModelObjc?.pushType == "1" {
                /* 家庭群聊*/
                alertTitle = "语聊"
                alertBody = "新语音消息"
                NotificationCenter.default.post(name: NSNotification.Name.init(KCBWtGroupChatNotification), object: nil)
            } else if noticeModelObjc?.pushType == "2" {
                /* 单聊*/
                alertTitle = "语聊"
                alertBody = "新语音消息"
                NotificationCenter.default.post(name: NSNotification.Name.init(KCBWtSingleChatNotification), object: nil)
            }
        } else {
            switch noticeModelObjc?.pushType {
            case "1":
                /* 好友聊天*/
                alertTitle = "收到一条宠友消息".localizedStr//"收到一条语音".localizedStr
                alertSubTitle = ""
                alertBody = ""
                break
            case "2":
                /* 绑定申请*/
                alertTitle = "收到一条绑定消息".localizedStr
                alertSubTitle = ""
                alertBody = ""
                break
            case "3":
                /* 宠友添加申请*/
                alertTitle = "收到一条宠友添加消息".localizedStr
                alertSubTitle = ""
                alertBody = ""
                break
            case "4":
                /* 设备报警*/
                if noticeModelObjc?.warmType == "3" {
                    alertTitle = "收到一条低电报警消息".localizedStr
                } else {
                    alertTitle = "收到一条围栏报警消息".localizedStr
                }
                alertSubTitle = ""
                alertBody = ""
                break
            case "5":
                /* 听一听*/
                alertTitle = "收到一条听听消息".localizedStr
                alertSubTitle = ""
                alertBody = ""
                break
            default:
                break
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(K_CBPetNoticeNotification), object: ["notice":noticeModelObjc])
        //gu
        let ss:String = UserDefaults.standard.object(forKey: "appPush") as? String ?? ""
        if ss == "0" {
            return
        }
        /* 当消息开关关闭的时候，消息通知不弹窗，但推送还是继续*/
        let userInfoModelObject = CBPetUserInfoModelTool.getUserInfo()
        if userInfoModelObject.appPush_local == "0" {
            return
        }
        
        self.badgeNumber += 1
        if #available(iOS 10.0, *) {
             // 创建通知内容
            let content = UNMutableNotificationContent()
            content.title = alertTitle
            content.subtitle = alertSubTitle
            content.body = alertBody
            content.sound = .default
            content.userInfo = userInfo as! [AnyHashable : Any]
            content.badge = self.badgeNumber as NSNumber

            //设置通知触发器
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
            //设置请求标识符
            let requestIdentifier = "CBPetNoticeLocationNotificationID"///NSString.init(format: "%lf", NSDate().timeIntervalSince1970)//"com.hangge.testNotification"
            //设置一个通知请求
            let request = UNNotificationRequest(identifier: requestIdentifier as String,
                                                content: content, trigger: trigger)
            //将通知请求添加到发送中心
            UNUserNotificationCenter.current().add(request) { error in
                if error == nil {
                    print("Time Interval Notification scheduled: \(requestIdentifier)")
                }
            }
        } else {
            // 1.创建通知
            let localNotification = UILocalNotification()//.init()
            // 2.设置通知的必选参数
            localNotification.alertTitle = alertTitle
            // 设置通知显示的内容
            localNotification.alertBody = alertBody
            // 设置通知的发送时间,单位秒
            localNotification.fireDate = Date(timeIntervalSinceNow: 10)//Date.init(timeIntervalSinceReferenceDate: 10)
            //解锁滑动时的事件
            localNotification.alertAction = "别磨蹭了"
            //++ self.badgeNumber;
            //收到通知时App icon的角标
            localNotification.applicationIconBadgeNumber = Int(truncating: self.badgeNumber as NSNumber)
            localNotification.userInfo = ["id":"1","name":"CBPetNoticeLocationNotificationID","notice":noticeModelObjc as Any]
            //推送是带的声音提醒，设置默认的字段为UILocalNotificationDefaultSoundName
            localNotification.soundName = UILocalNotificationDefaultSoundName
            // 3.发送通知(🐽 : 根据项目需要使用)
            // 方式一: 根据通知的发送时间(fireDate)发送通知
            //UIApplication.shared.scheduleLocalNotification(localNotification)
            // 方式二: 立即发送通知
            UIApplication.shared.presentLocalNotificationNow(localNotification)
        }
        //UMessage.didReceiveRemoteNotification(userInfo)
    }
    func clickNotificationAction(userInfo:NSDictionary) {
        let ddJsonBodyInfo = JSON.init(userInfo["body"] as Any)
        let noticeModelObjc = CBPetNoticeModel.deserialize(from: CBPetUtils.getDictionaryFromJSONString(jsonString: ddJsonBodyInfo.stringValue))
        switch noticeModelObjc?.pushType {
        case "1":
            if UIViewController.getCurrentVC() is CBPetFuncPetMsgVC {
                return
            }
            if CBPetHomeInfoTool.getHomeInfo().pet.device.imei != noticeModelObjc?.imei {
                /// 非当前选中设备 推送消息
                let petMsgVC = CBPetFuncPetMsgVC.init()
                UIViewController.getCurrentVC()?.navigationController?.pushViewController(petMsgVC, animated: true)
            } else {
                if UIViewController.getCurrentVC() is CBPetFunctionChatVC {
                    return
                }
                /* 好友聊天*/
                let chatVC = CBPetFunctionChatVC.init()
                chatVC.defaultIndex = 2
                UIViewController.getCurrentVC()?.navigationController?.pushViewController(chatVC, animated: true)
            }
            break
        case "2":
            /* 绑定申请*/
            break
        case "3":
            /* 宠友添加申请*/
            break
        case "4":
            /* 设备报警*/
            break
        case "5":
            /* 听一听*/
            break
        default:
            break
        }
    }
    
    func returnTitle(type:String) -> String {
        switch type {
        case "0":
            return "监护人申请".localizedStr
        case "1":
            return "电量低".localizedStr
        case "2":
            return "拆除报警".localizedStr
        case "3":
            return "进/出区域".localizedStr
        case "4":
            return "迟到".localizedStr
        case "5":
            return "逗留".localizedStr
        case "6":
            return "未按时到家".localizedStr
        case "7":
            return "到校".localizedStr
        case "8":
            return "离校".localizedStr
        case "9":
            return "到家".localizedStr
        case "10":
            return "离家".localizedStr
        default:
            return ""
        }
    }
    func returnBody(type:String,phone:String) -> String {
        switch type {
        case "0":
            return phone + "申请成为监护人,是否同意?".localizedStr
        case "1":
            return "手机电量已低于20%,请及时连接USB充电".localizedStr
        case "2":
            return "拆除报警".localizedStr
        case "3":
            return "进/出区域".localizedStr
        case "4":
            return "上学时间到了,宝贝还未到达学校".localizedStr
        case "5":
            return "已放学超过30分钟了,宝贝还在学校逗留".localizedStr
        case "6":
            return "最晚回家时间到了，宝贝还未回家".localizedStr
        case "7":
            return "宝贝已经到达学校".localizedStr
        case "8":
            return "离开学校区域".localizedStr
        case "9":
            return "到达家庭区域".localizedStr
        case "10":
            return "离开家庭区域".localizedStr
        default:
            return ""
        }
    }
}

