//
//  CBPetMsgCterLoctionRcdView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/4.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetMsgCterLoctionRcdView: CBPetBaseView,UITableViewDelegate, UITableViewDataSource {

    private lazy var locationRcdTabView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = KPetBgmColor
        tableV.separatorStyle = .none
        tableV.estimatedRowHeight = 76*KFitHeightRate
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(CBPetMsgCterLocationRcdCell.self, forCellReuseIdentifier: "CBPetMsgCterLocationRcdCell")
        tableV.mj_header = MJRefreshStateHeader()
        tableV.mj_header.setRefreshingTarget(self, refreshingAction: #selector(pullHeaderRefreshData))
//        tableV.mj_footer = MJRefreshBackNormalFooter()
//        tableV.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(pullFooterRefreshData))
        return tableV
    }()
    private lazy var dataSource:[CBPetMsgCterModel] = {
        var arr = [CBPetMsgCterModel]()
        return arr
    }()
    public var msgModel:CBPetMsgCterModel?
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        if self.viewModel is CBPetMsgCterViewModel {
            let vvModel = self.viewModel as! CBPetMsgCterViewModel
            vvModel.getLocateRcdListUpdateUIBlock = { [weak self] (dataSource:[CBPetMsgCterModel]) -> Void in
                self?.dataSource = dataSource.reversed()
                for index in 0..<(self?.dataSource.count)! {
                    self?.dataSource[index].index = index
                    if self?.msgModel?.message_type == "9" {
                        self?.dataSource[index].title = "唤醒通知".localizedStr
                    }
                    CBPetMsgCterGetAdreManger.share.getAddress(msgCterLocationRcdModel: (self?.dataSource[index])!,indexTemp:index) { [weak self] (address) in
                        
//                        CBLog(message: "查询到的位置:\(address ?? "")")
////                        self?.timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: self?.msgCterLocationRcdModel.add_time ?? "", formateStr: "yyyy-MM-dd HH:mm:ss")
////                        self?.titleLb.text = self?.msgCterLocationRcdModel.title
////                        self?.textLb.text = address
////                        self?.updateTextLayout(textStr: address)
////                        self?.showBtn_text.isSelected = self?.msgCterLocationRcdModel.isShow ?? false
////                        self?.showBtn_image.isSelected = self?.msgCterLocationRcdModel.isShow ?? false
//
//                        self?.dataSource[index].text = address
                
                    }
                }
//                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute:{
//                    self?.locationRcdTabView.reloadData()
//                })
                self?.locationRcdTabView.reloadData()
                if let value = self?.dataSource.count {
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
        self.locationRcdTabView.addSubview(self.noDataObjcView)
        self.noDataObjcView.snp_makeConstraints({ (make) in
            make.top.bottom.equalTo(self.locationRcdTabView)
            make.center.equalTo(self.locationRcdTabView)
            make.width.equalTo(SCREEN_WIDTH)
        })
        self.noDataObjcView.isHidden = !(self.noDataResult ?? true)
    }
//    private func scrollToBottom() {
//        /* 滚动至底部*/
//        let section = self.locationRcdTabView.numberOfSections
//        if section < 1 { return }
//        let row = self.locationRcdTabView.numberOfRows(inSection: section - 1)
//        if row < 1 { return }
//        let indexPath = IndexPath(row: row - 1, section: section - 1)
//        self.locationRcdTabView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.none, animated: false)
//    }
    private func setupView() {
        self.backgroundColor = KPetBgmColor
        
        self.addSubview(self.locationRcdTabView)
        self.locationRcdTabView.snp_makeConstraints { (make) in
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
        self.locationRcdTabView.mj_header.beginRefreshing()
    }
    func endRefresh() {
        self.locationRcdTabView.mj_header.endRefreshing()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetMsgCterLocationRcdCell") as! CBPetMsgCterLocationRcdCell
        if self.dataSource.count > indexPath.row {
            let model = self.dataSource[indexPath.row]
            cell.msgModel = msgModel
            cell.msgCterLocationRcdModel = model
        }
        cell.setupViewModel(viewModel: self.viewModel)
        if cell.viewModel is CBPetMsgCterViewModel {
            (cell.viewModel as! CBPetMsgCterViewModel).showMoreClickBlock = { [weak self] (backModel:CBPetMsgCterModel) -> Void in
                /// 值传递替换是某数据库刷新tableView
                self?.dataSource[backModel.index] = backModel
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute:{
                    self?.locationRcdTabView.reloadData()
                })
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
