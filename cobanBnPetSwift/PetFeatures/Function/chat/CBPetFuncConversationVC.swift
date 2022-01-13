//
//  CBPetFuncConversationVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/1.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetFuncConversationVC: CBPetBaseViewController {
    
    private var funcViewModel:CBPetFuncChatViewModel = {
        let vv = CBPetFuncChatViewModel.init()
        return vv
    }()
    private lazy var scrollView:UIScrollView = {
        let vv = UIScrollView(frame: UIScreen.main.bounds)
        vv.backgroundColor = KPetAppColor
        vv.showsVerticalScrollIndicator = false
        vv.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            vv.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return vv
    }()
    private lazy var cvstionView:CBPetFuncCvsationView = {
        let vv = CBPetFuncCvsationView.init()
        return vv
    }()
    private lazy var arrayDataSource:[CBPetFuncCvstionModel] = {
        let arr = Array<CBPetFuncCvstionModel>()
        return arr
    }()
    var petFriendMsgModel:CBPetFuncPetFriendsMsgModel?
    var friendId:String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        /* 移除发语音的popView*/
        self.cvstionView.footView.popRecordingView.removeFromSuperview()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* 聊天消息列表进入，用的是sender字段*/
        if let value = self.petFriendMsgModel?.sender {
            /* 若sender字段值 等于用户，则取accepter字段值*/
            if value == CBPetLoginModelTool.getUser()?.uid {
                self.friendId = self.petFriendMsgModel?.accepter
            } else {
                self.friendId = value
            }
        } else {
            /* 其他入口进入*/
            if let value = self.petFriendMsgModel?.id {
                self.friendId = value
            }
        }
        self.funcViewModel.petFriendMsgModel = petFriendMsgModel
        
        /* 创建获取语聊数据库 */
        CBPetChatFMDBManager.share.createTabSingleChat(friendId:self.friendId ?? "")
        
        setupView()
        getQNFileTokenRequestMethod()
        
        /* 推送通知*/
        NotificationCenter.default.addObserver(self, selector: #selector(noticeNofitication), name: NSNotification.Name.init(K_CBPetNoticeNotification), object: nil)
    }
    override func loadView() {
        super.loadView()
        /* 防止NavigationBar被键盘弹起时顶出屏幕外面 */
        self.view = self.scrollView
    }
    private func setupView() {
        /* view的 y 从 导航栏以下算起*/
        self.edgesForExtendedLayout = UIRectEdge.bottom
        
        initBarWith(title: self.petFriendMsgModel?.name ?? "Cherry".localizedStr, isBack: true)

        self.scrollView.addSubview(self.cvstionView)
        self.cvstionView.backgroundColor = KPetBgmColor
        self.cvstionView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NavigationBarHeigt)
        
        self.cvstionView.setupViewModel(viewModel: self.funcViewModel)
        self.funcViewModel.MJHeaderRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.getSingeChatRcdRequest()
        }
        self.funcViewModel.MJFooterRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.getSingeChatRcdRequest()
        }
        self.funcViewModel.petfriendCvstionChatBlock = { [weak self] (objc:Any, type:String,time:Int) in
            switch type {
            case "0":
                /* 发文本*/
                self?.singeChatSendMsgRequest(msgText: objc as! String, msgFile: "", time: 0)
                break
            case "1":
                /* 发语音*/
                self?.uploadVoiceToQiniuRequest(msgFile: objc as! String,time:time)
                break
            case "2":
                /* 播放语音*/
                CBPetChatPlayVoiceManager.share.playVoiceUrl(model: objc as! CBPetFuncCvstionModel)
                CBPetChatPlayVoiceManager.share.playTalkVoiceEndBlock = { (objc:Any) -> Void in
                    /* 播放语音结束，设置已读 */
                }
                break
            default:
                break
            }
        }
        self.registerNotification()
        getSingeChatRcdRequest()
    }
    //MARK:监听键盘通知
    func registerNotification(){
        // 监听键盘弹出通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification,object: nil)
        // 监听键盘隐藏通知
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(notification:)),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // 键盘显示
    @objc func keyboardWillShow(notification: Notification) {
        CBLog(message: "键盘将要出现")
    }
    // 键盘隐藏
    @objc func keyboardWillHide(notification: Notification) {
        CBLog(message: "键盘将要隐藏")
    }
    // 移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc private func noticeNofitication(notification: Notification) {
        let userInfo:Dictionary<String,Any> = notification.object as! Dictionary<String, Any>
        let noticeModel = (userInfo["notice"]) as! CBPetNoticeModel
        switch noticeModel.pushType {
        case "1":
            /* 好友聊天*/
            self.getSingeChatRcdRequest()
            break
        default:
            break
        }
    }
    //MARK: - 获取单聊聊天记录
    private func getSingeChatRcdRequest() {
        getLocalChatRcd()
        let homeInfo = CBPetHomeInfoTool.getHomeInfo()
        guard homeInfo.pet.device.imei?.isEmpty == false else {
            return
        }
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        paramters["friendUid"] = self.friendId
        CBPetNetworkingManager.share.getSingleChatRcdRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            self?.cvstionView.endRefresh()
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                self?.cvstionView.updateChatData(dataSource: self!.arrayDataSource)
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            var petFriendChatListObject = JSONDeserializer<CBPetFuncCvstionModel>.deserializeModelArrayFrom(array: ddJson.arrayObject)
            //self?.arrayDataSource = petFriendChatListObject as! [CBPetFuncCvstionModel]
            for index in 0..<(petFriendChatListObject as! [CBPetFuncCvstionModel]).count {
                let model = petFriendChatListObject?[index]
                petFriendChatListObject?[index]?.photo = self?.petFriendMsgModel?.photo
                /* 查询本地，若本地有则不添加*/
                let array = CBPetChatFMDBManager.share.querySingleChat(querySql: String.init(format: "select * from cbpet_t_SINGLECHAT_TABLE%@%@ WHERE ids = '%@'", CBPetLoginModelTool.getUser()?.uid ?? "",CBPetHomeInfoTool.getHomeInfo().pet.device.imei ?? "",model?.id ?? ""), friendId: self?.friendId ?? "")
                if array.count <= 0 {
                    self?.arrayDataSource.append(model ?? CBPetFuncCvstionModel())
                    /* 数据插入*/
                    let isInsert = CBPetChatFMDBManager.share.addSingleChat(model: model ?? CBPetFuncCvstionModel(), friendId: self?.friendId ?? "")
                    if isInsert == true {
                        CBLog(message: "插入成功")
                    } else {
                        CBLog(message: "插入失败")
                    }
                }
            }
            self?.cvstionView.updateChatData(dataSource: self!.arrayDataSource)
            self?.cvstionView.cleanInputMsg()
        }) { [weak self] (failureModel) in
            self?.cvstionView.endRefresh()
        }
    }
    private func getLocalChatRcd() {
        self.arrayDataSource.removeAll()
        let arr = CBPetChatFMDBManager.share.querySingleChat(querySql: "", friendId: self.friendId ?? "")
        self.arrayDataSource = arr
    }
    //MARK: - 上传语音文件到七牛云
    private func uploadVoiceToQiniuRequest(msgFile:String,time:Int) {
        guard msgFile.isEmpty == false else {
            return
        }
        if self.viewModel.qnyToken == nil || self.viewModel.qnyToken?.isEmpty == true {
            return
        }
        let voiceData = NSData(contentsOfFile: msgFile) ?? NSData()
        CBPetNetworkingManager.share.uploadVoiceToQNFileRequest(fileData: voiceData, token: self.viewModel.qnyToken!, successBlock: { [weak self] (successDic:Dictionary) in
            let key = successDic["key"] as! String
            let voiceUrl = "http://cdn.clw.gpstrackerxy.com/" + key
            self?.singeChatSendMsgRequest(msgText: "", msgFile: voiceUrl,time:time)
        }) { (failureDic:Dictionary) in
            MBProgressHUD.showMessage(Msg: "上传语音失败".localizedStr, Deleay: 1.5)
        }
    }
    //MARK: - 单聊发送聊天消息
    private func singeChatSendMsgRequest(msgText:String,msgFile:String,time:Int) {
        let homeInfo = CBPetHomeInfoTool.getHomeInfo()
        guard homeInfo.pet.device.imei?.isEmpty == false else {
            return
        }
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        paramters["friendUid"] = self.friendId
        
        if msgText.isEmpty == false {
            /// 编码
            //let encodedString = msgText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            paramters["messageText"] = msgText///"文本消息内容"
        }
        if msgFile.isEmpty == false {
            paramters["messageFile"] = msgFile///"二进制文件路径"
        }
        if time > 0 {
            paramters["voiceTime"] = "\(time)"
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.singleChatSendMsgRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            ///返回错误信息
            guard successModel.status == "0" else {
                self?.view.endEditing(true)
                self?.getSingeChatRcdRequest()
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            self?.view.endEditing(true)
            self?.getSingeChatRcdRequest()
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
