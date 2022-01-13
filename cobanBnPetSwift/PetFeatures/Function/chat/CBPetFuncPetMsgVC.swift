//
//  CBPetFuncPetMsgVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/8/19.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncPetMsgVC: CBPetBaseViewController {

    private lazy var funcViewModel:CBPetFuncChatViewModel = {
        let vv = CBPetFuncChatViewModel.init()
        return vv
    }()
    private lazy var petmessageView:CBPetFuncPetPushMsgView = {
        let vv = CBPetFuncPetPushMsgView.init(frame: CGRect(x: SCREEN_WIDTH*2, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return vv
    }()
    private lazy var arrayDataSourceMsg:[Any] = {
        let arr = Array<Any>()
        return arr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //self.edgesForExtendedLayout = UIRectEdge.bottom
        self.setupView()
        getDataRequest()
    }
    private func setupView() {
        initBarWith(title: "宠友消息".localizedStr, isBack: true)
    
        self.view.addSubview(self.petmessageView)
        self.petmessageView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        self.petmessageView.setupViewModel(viewModel: self.funcViewModel)
        self.funcViewModel.MJHeaderRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.funcViewModel.getPetfriendsMsgListRequest()
        }
        self.funcViewModel.MJFooterRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.funcViewModel.getPetfriendsMsgListRequest()
        }
    }
    //MARK: - 获取数据request
    private func getDataRequest() {
        /* 获取我的宠友消息列表*/
        self.funcViewModel.getPetfriendsMsgListRequest()
        self.funcViewModel.updateDataFuncChatBlock = { [weak self] (_ type:CBPetFuncChatUpdDataType,_ objc:Any) -> Void in
            switch type {
                case .petFriendMsgList:
                /* 宠友消息列表*/
                self?.arrayDataSourceMsg = objc as! [CBPetFuncPetFriendsMsgModel]
                self?.petFriendsMsgEndfresh()
                break
            default:
                break
            }
        }
        self.funcViewModel.petFriendsMsgListUpdUIBlock = { [weak self] (isEnd:Bool,dataSource:[Any]) -> Void in
            if isEnd == true {
                self?.petmessageView.endRefresh(dataSource: dataSource as! [CBPetFuncPetFriendsMsgModel])
            } else {
                if dataSource.count <= 0 {
                    self?.petmessageView.beginRefresh()
                }
            }
        }
        self.funcViewModel.clickPushFuncChatBlock = { [weak self] (_ type:CBPetFuncChatClickType,_ objc:Any) -> Void in
            switch type {
            case .toCvstion:
                /* 宠友消息详情点击*/
                self?.chatCvstionClick(model: objc as! CBPetFuncPetFriendsMsgModel)
                break
            case .visitPetInfo:
                break
            case .moreApply:
                break
            case .petFriendDetailInfo:
                break
            }
        }
    }
    //MARK: - 获取宠友消息列表
    private func petFriendsMsgEndfresh() {
        guard self.funcViewModel.petFriendsMsgListUpdUIBlock == nil else {
            self.funcViewModel.petFriendsMsgListUpdUIBlock!(true, self.arrayDataSourceMsg)
            return
        }
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
