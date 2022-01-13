//
//  CBPetFunctionChatVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/27.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetFunctionChatVC: CBPetBaseViewController {

    private lazy var funcViewModel:CBPetFuncChatViewModel = {
        let vv = CBPetFuncChatViewModel.init()
        return vv
    }()
    private lazy var petsMainView:CBPetFuncChatMainView = {
        let vv = CBPetFuncChatMainView.init()
        return vv
    }()
    override func noNetworkNotification(notifi: Notification) {
        super.noNetworkNotification(notifi: notifi)
        self.view.bringSubviewToFront(self.noNetworkView)
        self.noNetworkView.isHidden = !(self.networkResult ?? true)
        self.noNetworkView.reloadBlock = { [weak self] () -> Void in
            CBLog(message: "重新加载")
            self?.funcViewModel.searchNearbyPetsRequest()
            self?.funcViewModel.getPetfriendsApplyListRequest()
            self?.funcViewModel.getPetfriendsListRequest()
            self?.funcViewModel.getPetfriendsMsgListRequest()
        }
    }
    private lazy var arrayDataSource:[Any] = {
        let arr = [[],[]]
        return arr
    }()
    private lazy var arrayDataSourceMsg:[Any] = {
        let arr = Array<Any>()
        return arr
    }()
    var defaultIndex:Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* 获取我的宠友消息列表*/
        self.funcViewModel.getPetfriendsMsgListRequest()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* view的 y 从 导航栏以下算起*/
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.setupView()
        getDataRequest()
        updateDataSource()
        NotificationCenter.default.addObserver(self, selector: #selector(updatePetFriendData), name: NSNotification.Name.init(K_CBPetDeletePetFriendNotification), object: nil)
        
        /* 推送通知*/
        NotificationCenter.default.addObserver(self, selector: #selector(noticeNofitication), name: NSNotification.Name.init(K_CBPetNoticeNotification), object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute:{
            ///延时操作才能加载出来，相当于网络请求
            self.petsMainView.updateIndex(index: self.defaultIndex)
        })
    }
    @objc private func updatePetFriendData () {
        self.funcViewModel.getPetfriendsApplyListRequest()
        self.funcViewModel.getPetfriendsListRequest()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc private func noticeNofitication(notification: Notification) {
        let userInfo:Dictionary<String,Any> = notification.object as! Dictionary<String, Any>
        let noticeModel = (userInfo["notice"]) as! CBPetNoticeModel
        switch noticeModel.pushType {
        case "1":
            /* 好友聊天*/
            /* 刷新消息列表*/
            self.funcViewModel.getPetfriendsMsgListRequest()
            break        
        default:
            break
        }
    }
    private func setupView() {
        initBarWith(title: "微聊".localizedStr, isBack: true)
    
        self.view.addSubview(self.petsMainView)
        self.petsMainView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        self.petsMainView.setupViewModel(viewModel: self.funcViewModel)
        self.funcViewModel.MJHeaderRefreshReloadDataBlock = { [weak self] (tag:Int) in
            if tag == 2020 {
                self?.funcViewModel.getPetfriendsApplyListRequest()
                self?.funcViewModel.getPetfriendsListRequest()
            } else {
                self?.funcViewModel.getPetfriendsMsgListRequest()
            }
        }
        self.funcViewModel.MJFooterRefreshReloadDataBlock = { [weak self] (tag:Int) in
            if tag == 2020 {
                self?.funcViewModel.getPetfriendsApplyListRequest()
                self?.funcViewModel.getPetfriendsListRequest()
            } else {
                self?.funcViewModel.getPetfriendsMsgListRequest()
            }
        }
    }
    //MARK: - 获取数据request
    @objc private func getDataRequest() {
        /* 搜索附近宠物*/
        self.funcViewModel.searchNearbyPetsRequest()
        /* 获取宠友申请列表*/
        self.funcViewModel.getPetfriendsApplyListRequest()
        /* 获取我的宠友列表*/
        self.funcViewModel.getPetfriendsListRequest()
        /* 获取我的宠友消息列表*/
        self.funcViewModel.getPetfriendsMsgListRequest()
    }
    // MARK: - 数据源刷新
    private func updateDataSource() {
        self.funcViewModel.updateDataFuncChatBlock = { [weak self] (_ type:CBPetFuncChatUpdDataType,_ objc:Any) -> Void in
            switch type {
            case .nearPet:
                /* 附近宠友*/
                guard self?.funcViewModel.petFriendsUpdNearPetsUIBlock == nil else {
                    self?.funcViewModel.petFriendsUpdNearPetsUIBlock!()
                    return
                }
                break
            case .petFriendApply:
                /* 宠友申请列表*/
                self?.arrayDataSource[0] = objc as! [CBPetFuncPetFriendsModel]
                self?.petFriendsApplyEndfresh()
                break
            case .petFriendList:
                /* 宠友列表*/
                self?.arrayDataSource[1] = objc as! [CBPetFuncPetFriendsModel]
                self?.petFriendsListEndfresh()
                break
            case .petFriendMsgList:
                /* 宠友消息列表*/
                self?.arrayDataSourceMsg = objc as! [CBPetFuncPetFriendsMsgModel]
                self?.petFriendsMsgEndfresh()
                break
            default:
                //
                break
            }
        }
        /* 同意，拒绝申请操作*/
        self.funcViewModel.petFriendsDealWithFriendApplyBlock = { [weak self] (_ state:String,_ model:CBPetFuncPetFriendsModel) -> Void in
            switch state {
            case "2":
                /* 拒绝或等待授权*/
                self?.funcViewModel.dealWithAddfriendApplyRequest(state: state, model: model)
                break
            case "0":
                /* 同意*/
                self?.funcViewModel.dealWithAddfriendApplyRequest(state: state, model: model)
                break
            default:
                break
            }
        }
        self.funcViewModel.clickPushFuncChatBlock = { [weak self] (_ type:CBPetFuncChatClickType,_ objc:Any) -> Void in
            switch type {
            case .visitPetInfo:
                 /* 查看附近宠友资料*/
                if objc is CBPetFuncNearPetModel {
                    let nearPetsInfo = objc as! CBPetFuncNearPetModel
                    
                    var petFriendModel = CBPetFuncPetFriendsModel.init()
                    petFriendModel.admin_Id = nearPetsInfo.admin_Id
                    
                    let petfriendInfoVC = CBPetPersonalPageVC.init()
                    petfriendInfoVC.viewModel.isComfromPsnalCter = false
                    petfriendInfoVC.petFriendModel = petFriendModel
            
                    self?.navigationController?.pushViewController(petfriendInfoVC, animated: true)
                }
                break
            case .moreApply:
                /* 更多申请点击*/
                self?.moreApplyClick()
                break
            case .petFriendDetailInfo:
                /* 宠友列表详情点击*/
                self?.toPetfriendInfoClick(model: objc as! CBPetFuncPetFriendsModel)
                break
            case .toCvstion:
                /* 宠友消息详情点击*/
                self?.chatCvstionClick(model: objc as! CBPetFuncPetFriendsMsgModel)
                break
            }
        }
    }
    //MARK: - 获取宠友申请列表
    private func petFriendsApplyEndfresh() {
        guard self.funcViewModel.petFriendsApplyListUpdUIBlock == nil else {
            self.funcViewModel.petFriendsApplyListUpdUIBlock!(true, self.arrayDataSource)
            return
        }
    }
    //MARK: - 获取我的宠友列表
    private func petFriendsListEndfresh() {
        guard self.funcViewModel.petFriendsListUpdUIBlock == nil else {
            self.funcViewModel.petFriendsListUpdUIBlock!(true, self.arrayDataSource)
            return
        }
    }
    //MARK: - 获取宠友消息列表
    private func petFriendsMsgEndfresh() {
        guard self.funcViewModel.petFriendsMsgListUpdUIBlock == nil else {
            self.funcViewModel.petFriendsMsgListUpdUIBlock!(true, self.arrayDataSourceMsg)
            return
        }
    }
    //MARK: - 宠友个人主页
    private func toPetfriendInfoClick(model:CBPetFuncPetFriendsModel) {
        let petfriendInfoVC = CBPetPersonalPageVC.init()
        petfriendInfoVC.viewModel.isComfromPsnalCter = false
        petfriendInfoVC.petFriendModel = model
        self.navigationController?.pushViewController(petfriendInfoVC, animated: true)
    }
    //MARK: - 更多申请
    private func moreApplyClick() {
        let moreApplyVC = CBPetFuncChatMoreApplyVC.init()
        self.navigationController?.pushViewController(moreApplyVC, animated: true)
    }
    //MARK: - 聊天对话
    private func chatCvstionClick(model:CBPetFuncPetFriendsMsgModel) {
        let cvstionVC = CBPetFuncConversationVC.init()
        cvstionVC.petFriendMsgModel = model
        self.navigationController?.pushViewController(cvstionVC, animated: true)
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
