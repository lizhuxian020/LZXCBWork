


//
//  CBPetFuncPetPushMsgView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/8/20.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncPetPushMsgView: CBPetBaseView,UITableViewDelegate, UITableViewDataSource {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private lazy var petMessageTableView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = UIColor.white
        tableV.separatorStyle = .none
        tableV.estimatedRowHeight = 61*KFitHeightRate
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(CBPetChatPetMessageCell.self, forCellReuseIdentifier: "CBPetChatPetMessageCell")
        tableV.mj_header = MJRefreshStateHeader()
        tableV.mj_header.setRefreshingTarget(self, refreshingAction: #selector(pullHeaderRefreshData))
        tableV.mj_footer = MJRefreshBackNormalFooter()
        tableV.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(pullFooterRefreshData))
        return tableV
    }()
    private lazy var arrayDataSource:[CBPetFuncPetFriendsMsgModel] = {
        let arr = Array<CBPetFuncPetFriendsMsgModel>()
        return arr
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func noNoDataNotification(notifi:Notification) {
        super.noNoDataNotification(notifi: notifi)
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        self.petMessageTableView.reloadData()
    }
    private func setupView() {
        self.addSubview(self.petMessageTableView)
        self.petMessageTableView.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.bottom.equalTo(-TabPaddingBARHEIGHT)
        }
        self.petMessageTableView.addSubview(self.noDataObjcView)
        self.noDataObjcView.snp_makeConstraints({ (make) in
            make.center.equalTo(self.petMessageTableView)
            make.width.equalTo(SCREEN_WIDTH)
            make.top.bottom.equalTo(self.petMessageTableView)
        })
        self.noDataObjcView.isHidden = true//!(self.noDataResult ?? true)
    }
    @objc private func pullHeaderRefreshData() {
        let vvModel = self.viewModel as! CBPetFuncChatViewModel
        guard vvModel.MJHeaderRefreshReloadDataBlock == nil else {
            vvModel.MJHeaderRefreshReloadDataBlock!(2021)
            return
        }
    }
    @objc private func pullFooterRefreshData() {
        let vvModel = self.viewModel as! CBPetFuncChatViewModel
        guard vvModel.MJFooterRefreshReloadDataBlock == nil else {
            vvModel.MJFooterRefreshReloadDataBlock!(2021)
            return
        }
    }
    func beginRefresh() {
        self.petMessageTableView.mj_header.beginRefreshing()
    }
    func endRefresh(dataSource:[CBPetFuncPetFriendsMsgModel]) {
        if dataSource.count <= 0 {
            self.noDataObjcView.isHidden = false
        } else {
            self.noDataObjcView.isHidden = true
        }
        self.arrayDataSource = dataSource
        self.petMessageTableView.reloadData()
        self.petMessageTableView.mj_header.endRefreshing()
        self.petMessageTableView.mj_footer.endRefreshingWithNoMoreData()
        self.petMessageTableView.mj_footer.isHidden = true
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetChatPetMessageCell") as! CBPetChatPetMessageCell
        if self.arrayDataSource.count > indexPath.row {
            cell.petFriendMsgModel = self.arrayDataSource[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel is CBPetFuncChatViewModel {
            guard (self.viewModel as! CBPetFuncChatViewModel).clickPushFuncChatBlock == nil else {
                (self.viewModel as! CBPetFuncChatViewModel).clickPushFuncChatBlock!(CBPetFuncChatClickType.toCvstion,self.arrayDataSource[indexPath.row])
                return
            }
        }
    }
}
