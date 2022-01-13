//
//  CBPetFuncChatMoreApplyView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/31.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncChatMoreApplyView: CBPetBaseView, UITableViewDelegate, UITableViewDataSource {

    private lazy var moreApplyTableView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = UIColor.white
        tableV.separatorStyle = .none
        tableV.estimatedRowHeight = 45*KFitHeightRate
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(CBPetChatPetfriendApplyCell.self, forCellReuseIdentifier: "CBPetChatPetfriendApplyCell")
        tableV.register(CBPetChatPetfriendHdView.self, forHeaderFooterViewReuseIdentifier: "CBPetChatPetfriendHdView")
        tableV.mj_header = MJRefreshStateHeader()
        tableV.mj_header.setRefreshingTarget(self, refreshingAction: #selector(pullHeaderRefreshData))
//        tableV.mj_footer = MJRefreshBackNormalFooter()//MJRefreshAutoStateFooter()
//        tableV.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(pullFooterRefreshData))
        return tableV
    }()
    private lazy var arrayDataSource:[CBPetFuncPetFriendsModel] = {
        let arr = Array<CBPetFuncPetFriendsModel>()
        return arr
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        self.moreApplyTableView.reloadData()
        if self.viewModel is CBPetFuncChatViewModel {
            let vvModel = self.viewModel as! CBPetFuncChatViewModel
            vvModel.petFriendsApplyListUpdUIBlock = { [weak self] (isEnd:Bool,dataSource:[Any]) -> Void in
                self?.arrayDataSource = (dataSource as! [CBPetFuncPetFriendsModel]).reversed()
                self?.moreApplyTableView.reloadData()
            }
        }
    }
    private func setupView() {
        self.backgroundColor = UIColor.white
        self.addSubview(self.moreApplyTableView)
        self.moreApplyTableView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(0)
            make.height.equalTo(SCREEN_HEIGHT - CGFloat(NavigationBarHeigt))
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
        self.moreApplyTableView.mj_header.beginRefreshing()
    }
    func endRefresh() {
        self.moreApplyTableView.mj_header.endRefreshing()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetChatPetfriendApplyCell") as! CBPetChatPetfriendApplyCell
        if self.arrayDataSource.count > indexPath.row {
            cell.petFriendModel = self.arrayDataSource[indexPath.row]
            cell.agreeCloseBlock = { [weak self] (state:String) -> Void in
                if self?.viewModel is CBPetFuncChatViewModel {
                    let vvModel = self?.viewModel as! CBPetFuncChatViewModel
                    vvModel.petFriendsDealWithFriendApplyBlock!(state, (self?.arrayDataSource[indexPath.row])!)
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel is CBPetFuncChatViewModel {
            guard (self.viewModel as! CBPetFuncChatViewModel).clickPushFuncChatBlock == nil else {
                if self.arrayDataSource.count > indexPath.row {
                    (self.viewModel as! CBPetFuncChatViewModel).clickPushFuncChatBlock!(CBPetFuncChatClickType.petFriendDetailInfo,self.arrayDataSource[indexPath.row])
                }
                return
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CBPetChatPetfriendHdView") as! CBPetChatPetfriendHdView
        tableView.backgroundColor = UIColor.white
        headView.leftTitleValue = "申请添加您为宠友".localizedStr
        headView.rightTitleValue = "".localizedStr
        return headView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40*KFitHeightRate
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            if self.arrayDataSource.count > indexPath.row {
                if self.viewModel is CBPetFuncChatViewModel {
                    let vvModel = self.viewModel as! CBPetFuncChatViewModel
                    vvModel.deleteFriendApplyMsgRequest(ids: self.arrayDataSource[indexPath.row].id ?? "")
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除".localizedStr
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
