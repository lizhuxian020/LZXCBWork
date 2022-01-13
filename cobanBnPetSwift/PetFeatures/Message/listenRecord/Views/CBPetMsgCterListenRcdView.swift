//
//  CBPetMsgCterListenRcdView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/4.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetMsgCterListenRcdView: CBPetBaseView,UITableViewDelegate, UITableViewDataSource {

    private lazy var msgCterListenTabView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = KPetBgmColor
        tableV.separatorStyle = .none
        tableV.estimatedRowHeight = 76*KFitHeightRate
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(CPetMsgCterListenRcdCell.self, forCellReuseIdentifier: "CPetMsgCterListenRcdCell")
        tableV.mj_header = MJRefreshStateHeader()
        tableV.mj_header.setRefreshingTarget(self, refreshingAction: #selector(pullHeaderRefreshData))
//        tableV.mj_footer = MJRefreshBackNormalFooter()
//        tableV.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(pullFooterRefreshData))
        return tableV
    }()
    private lazy var arrayDataSource:[CBPetMsgCterModel] = {
        var arr = [CBPetMsgCterModel]()
        return arr
    }()
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        if self.viewModel is CBPetMsgCterViewModel {
            let vvModel = self.viewModel as! CBPetMsgCterViewModel
            let homeInfo = CBPetHomeInfoTool.getHomeInfo()
            vvModel.listenRcdUpdateUIBlock = { [weak self] (dataSource:[CBPetMsgCterModel]) -> Void in
                self?.arrayDataSource = dataSource.reversed()
                for index in 0..<(self?.arrayDataSource.count)! {
                    let model = self?.arrayDataSource[index]
                    self?.arrayDataSource[index].title = model?.petName ?? ""
                    self?.arrayDataSource[index].text = "用户\(String.init(format: " \"%@\" ", model?.friendName ?? ""))正在向您申请绑定设备宠物 \"\(homeInfo.pet.device.imei ?? "")\""
                    self?.arrayDataSource[index].index = index
                }
                self?.msgCterListenTabView.reloadData()
                if let value = self?.arrayDataSource.count {
                    if value <= 0 {
                        /* 无数据通知*/
                        let notificationName = NSNotification.Name.init(K_CBPetNoDataNotification)
                        NotificationCenter.default.post(name: notificationName, object: ["isShow":true])
                    } else {
                        /* 有数据通知*/
                        let notificationName = NSNotification.Name.init(K_CBPetNoDataNotification)
                        NotificationCenter.default.post(name: notificationName, object: ["isShow":false])
                    }
                }
                //self?.scrollToBottom()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //scrollToBottom()
    }
    override func noNoDataNotification(notifi:Notification) {
        super.noNoDataNotification(notifi: notifi)
        self.msgCterListenTabView.addSubview(self.noDataObjcView)
        self.noDataObjcView.snp_makeConstraints({ (make) in
            make.top.bottom.equalTo(self.msgCterListenTabView)
            make.center.equalTo(self.msgCterListenTabView)
            make.width.equalTo(SCREEN_WIDTH)
        })
        self.noDataObjcView.isHidden = !(self.noDataResult ?? true)
    }
//    private func scrollToBottom() {
//        /* 滚动至底部*/
//        let section = self.msgCterListenTabView.numberOfSections
//        if section < 1 { return }
//        let row = self.msgCterListenTabView.numberOfRows(inSection: section - 1)
//        if row < 1 { return }
//        let indexPath = IndexPath(row: row - 1, section: section - 1)
//        self.msgCterListenTabView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.none, animated: false)
//    }
    private func setupView() {
        self.backgroundColor = KPetBgmColor
        
        self.addSubview(self.msgCterListenTabView)
        self.msgCterListenTabView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
    }
    @objc private func pullHeaderRefreshData() {
        let vvModel = self.viewModel as! CBPetMsgCterViewModel
        guard vvModel.MJHeaderRefreshReloadDataBlock == nil else {
            vvModel.MJHeaderRefreshReloadDataBlock!(2020)
            return
        }
    }
    @objc private func pullFooterRefreshData() {
        let vvModel = self.viewModel as! CBPetMsgCterViewModel
        guard vvModel.MJFooterRefreshReloadDataBlock == nil else {
            vvModel.MJFooterRefreshReloadDataBlock!(2020)
            return
        }
    }
    func beginRefresh() {
        self.msgCterListenTabView.mj_header.beginRefreshing()
    }
    func endRefresh() {
        self.msgCterListenTabView.mj_header.endRefreshing()
    }
    func updateListenData(dataSource:[CBPetMsgCterModel]) {
        self.arrayDataSource = dataSource
        self.msgCterListenTabView.reloadData()
        //self.scrollToBottom()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CPetMsgCterListenRcdCell") as! CPetMsgCterListenRcdCell
        if self.arrayDataSource.count > indexPath.row {
            let model = self.arrayDataSource[indexPath.row]
            cell.msgCterListenModel = model
        }
        cell.setupViewModel(viewModel: self.viewModel)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if self.arrayDataSource.count > indexPath.row {
//            let model = self.arrayDataSource[indexPath.row]
//            if self.viewModel is CBPetMsgCterViewModel {
//                let vvModel = self.viewModel as! CBPetMsgCterViewModel
//                guard vvModel.listenRcdPlayUIBlock == nil else {
//                    vvModel.listenRcdPlayUIBlock!(model)
//                    return
//                }
//            }
//        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
