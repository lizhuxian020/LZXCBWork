//
//  CBPetFuncChatMoreApplyVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/31.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetFuncChatMoreApplyVC: CBPetBaseViewController {

    private lazy var funcViewModel:CBPetFuncChatViewModel = {
        let vv = CBPetFuncChatViewModel.init()
        return vv
    }()
    private lazy var moreApplyView:CBPetFuncChatMoreApplyView = {
        let vv = CBPetFuncChatMoreApplyView.init()
        return vv
    }()
    private lazy var arrayDataSource:[Any] = {
        let arr = Array<Any>()
        return arr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* view的 y 从 导航栏以下算起*/
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.setupView()
        self.moreApplyView.beginRefresh()
        NotificationCenter.default.addObserver(self, selector: #selector(updatePetFriendData), name: NSNotification.Name.init(K_CBPetDeletePetFriendNotification), object: nil)
    }
    @objc private func updatePetFriendData () {
        self.funcViewModel.getPetfriendsApplyListRequest()
        self.funcViewModel.getPetfriendsListRequest()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func setupView() {
        initBarWith(title: "更多申请".localizedStr, isBack: true)
        self.moreApplyView.backgroundColor = UIColor.gray
        self.view.addSubview(self.moreApplyView)
        self.moreApplyView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        self.moreApplyView.setupViewModel(viewModel: self.funcViewModel)
        self.funcViewModel.updateDataFuncChatBlock = { [weak self] (_ type:CBPetFuncChatUpdDataType,_ objc:Any) -> Void in
            switch type {
            case .petFriendApply:
                /* 宠友申请列表*/
                self?.moreApplyView.endRefresh()
                self?.arrayDataSource = objc as! [CBPetFuncPetFriendsModel]
                guard self?.funcViewModel.petFriendsApplyListUpdUIBlock == nil else {
                    self!.funcViewModel.petFriendsApplyListUpdUIBlock!(true, self!.arrayDataSource)
                    return
                }
                break
            default:
                //
                break
            }
        }
        self.funcViewModel.clickPushFuncChatBlock = { [weak self] (_ type:CBPetFuncChatClickType,_ objc:Any) -> Void in
            switch type {
            case .petFriendDetailInfo:
                /* 宠友列表详情点击*/
                self!.toPetfriendInfoClick(model:objc as! CBPetFuncPetFriendsModel)
                break
            default:
                break
            }
        }
        self.funcViewModel.MJHeaderRefreshReloadDataBlock = { [weak self] (tag:Int) in
            /* 获取宠友申请列表*/
            self?.funcViewModel.getPetfriendsApplyListRequest()
        }
        self.funcViewModel.MJFooterRefreshReloadDataBlock = { [weak self] (tag:Int) in
            /* 获取宠友申请列表*/
            self?.funcViewModel.getPetfriendsApplyListRequest()
        }
        /* 同意，拒绝申请*/
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
    }
    //MARK: - 宠友详情
    private func toPetfriendInfoClick(model:CBPetFuncPetFriendsModel) {
        let petfriendInfoVC = CBPetPersonalPageVC.init()
        petfriendInfoVC.viewModel.isComfromPsnalCter = false
        petfriendInfoVC.petFriendModel = model
        self.navigationController?.pushViewController(petfriendInfoVC, animated: true)
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
