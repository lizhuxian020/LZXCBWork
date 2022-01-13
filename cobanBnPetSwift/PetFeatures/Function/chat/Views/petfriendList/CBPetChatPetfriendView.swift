//
//  CBPetChatPetfriendView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/30.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetChatPetfriendView: CBPetBaseView,UITableViewDelegate,UITableViewDataSource {

    private lazy var petFriendTableView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = UIColor.white
        tableV.separatorStyle = .none
        tableV.estimatedRowHeight = 45*KFitHeightRate
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(CBPetChatPetfriendCell.self, forCellReuseIdentifier: "CBPetChatPetfriendCell")
        tableV.register(CBPetChatPetfriendApplyCell.self, forCellReuseIdentifier: "CBPetChatPetfriendApplyCell")
        tableV.register(CBPetChatPetfriendHdView.self, forHeaderFooterViewReuseIdentifier: "CBPetChatPetfriendHdView")
        tableV.mj_header = MJRefreshStateHeader()
        tableV.mj_header.setRefreshingTarget(self, refreshingAction: #selector(pullHeaderRefreshData))
        tableV.mj_footer = MJRefreshBackNormalFooter()//MJRefreshAutoStateFooter()
        tableV.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(pullFooterRefreshData))
        return tableV
    }()
    private lazy var arrayDataSource:[CBPetFuncPetFriendsModel] = {
        let arr = Array<CBPetFuncPetFriendsModel>()
        return arr
    }()
    private lazy var arrayDataSourceApply:[CBPetFuncPetFriendsModel] = {
        let arr = Array<CBPetFuncPetFriendsModel>()
        return arr
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationMethodTableViewScrollEable), name: NSNotification.Name(rawValue: K_CBPetFuncChatTableViewEnableFalse), object: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func noNoDataNotification(notifi:Notification) {
        super.noNoDataNotification(notifi: notifi)
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        self.petFriendTableView.reloadData()
    }
    private func setupView() {
        self.addSubview(self.petFriendTableView)
        self.petFriendTableView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(52*KFitHeightRate)
            make.height.equalTo(SCREEN_HEIGHT - CGFloat(NavigationBarHeigt) - 52*KFitHeightRate)
        }
        self.petFriendTableView.addSubview(self.noDataObjcView)
        self.noDataObjcView.snp_makeConstraints({ (make) in
            make.top.bottom.equalTo(self.petFriendTableView)
            make.center.equalTo(self.petFriendTableView)
            make.width.equalTo(SCREEN_WIDTH)
        })
        self.noDataObjcView.isHidden = !(self.noDataResult ?? true)
    }
    @objc private func notificationMethodTableViewScrollEable(notifi:Notification) {
        let resultDic:[String:Any] = notifi.object as! [String : Any]
        let result = resultDic["scrollEable"]
        if (result as! Bool) == true {
            self.petFriendTableView.isScrollEnabled = true
        } else {
            self.petFriendTableView.isScrollEnabled = false
        }
    }
    @objc private func pullHeaderRefreshData() {
        let vvModel = self.viewModel as! CBPetFuncChatViewModel
        guard vvModel.MJHeaderRefreshReloadDataBlock == nil else {
            vvModel.MJHeaderRefreshReloadDataBlock!(2020)
            return
        }
    }
    @objc private func pullFooterRefreshData() {
        let vvModel = self.viewModel as! CBPetFuncChatViewModel
        guard vvModel.MJFooterRefreshReloadDataBlock == nil else {
            vvModel.MJFooterRefreshReloadDataBlock!(2020)
            return
        }
    }
    func beginRefresh() {
        self.petFriendTableView.mj_header.beginRefreshing()
    }
    func endRefresh(dataSourceApply:[CBPetFuncPetFriendsModel],dataSource:[CBPetFuncPetFriendsModel]) {
        if dataSourceApply.count <= 0 && dataSource.count <= 0 {
//            /* 无数据通知*/
//            let notificationName = NSNotification.Name.init(K_CBPetNoDataNotification)
//            NotificationCenter.default.post(name: notificationName, object: ["isShow":true])
            
            self.noDataObjcView.isHidden = false
        } else {
//            /* 有数据通知*/
//            let notificationName = NSNotification.Name.init(K_CBPetNoDataNotification)
//            NotificationCenter.default.post(name: notificationName, object: ["isShow":false])
            
            self.noDataObjcView.isHidden = true
        }
        self.arrayDataSourceApply = dataSourceApply.reversed()
        self.arrayDataSource = dataSource
        self.petFriendTableView.reloadData()
        
        self.petFriendTableView.mj_header.endRefreshing()
        self.petFriendTableView.mj_footer.endRefreshingWithNoMoreData()
        self.petFriendTableView.mj_footer.isHidden = true
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return self.arrayDataSourceApply.count > 3 ? 3 : self.arrayDataSourceApply.count
            default:
                return self.arrayDataSource.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let applyCell = tableView.dequeueReusableCell(withIdentifier: "CBPetChatPetfriendApplyCell") as! CBPetChatPetfriendApplyCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetChatPetfriendCell") as! CBPetChatPetfriendCell
        switch indexPath.section {
        case 0:
            if self.arrayDataSourceApply.count > indexPath.row {
                applyCell.petFriendModel = self.arrayDataSourceApply[indexPath.row]
                applyCell.agreeCloseBlock = { [weak self] (state:String) -> Void in
                    if self?.viewModel is CBPetFuncChatViewModel {
                        let vvModel = self?.viewModel as! CBPetFuncChatViewModel
                        vvModel.petFriendsDealWithFriendApplyBlock!(state, (self?.arrayDataSourceApply[indexPath.row])!)
                    }
                }
            }
            return applyCell
        default:
            if self.arrayDataSource.count > indexPath.row {
                cell.petFriendModel = self.arrayDataSource[indexPath.row]
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel is CBPetFuncChatViewModel {
            guard (self.viewModel as! CBPetFuncChatViewModel).clickPushFuncChatBlock == nil else {
                switch indexPath.section {
                case 0:
                    (self.viewModel as! CBPetFuncChatViewModel).clickPushFuncChatBlock!(CBPetFuncChatClickType.petFriendDetailInfo,self.arrayDataSourceApply[indexPath.row])
                    return
                default:
                    (self.viewModel as! CBPetFuncChatViewModel).clickPushFuncChatBlock!(CBPetFuncChatClickType.petFriendDetailInfo,self.arrayDataSource[indexPath.row])
                    return
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CBPetChatPetfriendHdView") as! CBPetChatPetfriendHdView
        headView.setupViewModel(viewModel: self.viewModel)
        switch section {
            case 0:
                headView.leftTitleValue = "申请添加您为宠友".localizedStr
                headView.rightTitleValue = "更多申请".localizedStr
                break
            default:
                headView.leftTitleValue = "我的宠友".localizedStr
                headView.rightTitleValue = "".localizedStr
                break
            }
        return headView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
            case 0:
                return self.arrayDataSourceApply.count == 0 ? 0 : 40*KFitHeightRate
            default:
                return self.arrayDataSource.count == 0 ? 0 : 40*KFitHeightRate
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            switch indexPath.section {
            case 0:
                if self.arrayDataSourceApply.count > indexPath.row {
                    /* 删除宠友申请*/
                    if self.viewModel is CBPetFuncChatViewModel {
                        let vvModel = self.viewModel as! CBPetFuncChatViewModel
                        vvModel.deleteFriendApplyMsgRequest(ids: self.arrayDataSourceApply[indexPath.row].id ?? "")
                    }
                }
                break
            default:
                if self.arrayDataSource.count > indexPath.row {
                    /* 好友列表*/
                    var titleStr = ""
                    if let value = self.arrayDataSource[indexPath.row].name {
                        titleStr = String.init(format: "将宠友%@删除\n同时删除与该宠友的聊天记录", "''\(value)''")
                    }
                    CBLog(message: "左滑删除")
                    CBPetPopView.share.showAlert(title: "", subTitle: titleStr, comfirmBtnText: "删除".localizedStr,cancelBtnText: "取消".localizedStr, comfirmColor: KPetAppColor, cancelColor: KPet999999Color, completeBtnBlock: { [weak self] () -> Void in
                        /* 删除宠友*/
                        if self?.viewModel is CBPetFuncChatViewModel {
                            let vvModel = self?.viewModel as! CBPetFuncChatViewModel
                            vvModel.deleteFriendRequest(friendId: self?.arrayDataSource[indexPath.row].id ?? "", uid: CBPetLoginModelTool.getUser()?.uid ?? "")
                        }
                    }) { () in
                        //
                    }
                }
                break
            }
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除".localizedStr
    }
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: K_CBPetFuncChatScrollEnable), object: ["scrollEable":false])
    }
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: K_CBPetFuncChatScrollEnable), object: ["scrollEable":true])
    }
    deinit {
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    //func
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
