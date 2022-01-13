//
//  CBPetMsgCterSystemMsgView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/4.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetMsgCterSystemMsgView: CBPetBaseView,UITableViewDelegate, UITableViewDataSource {

    
    private lazy var systemMsgTableView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = KPetBgmColor
        tableV.separatorStyle = .none
        tableV.estimatedRowHeight = 76*KFitHeightRate
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(CBPetMsgCterOperateTabCell.self, forCellReuseIdentifier: "CBPetMsgCterOperateTabCell")
        tableV.register(CBPetMsgCterShowMoreTabCell.self, forCellReuseIdentifier: "CBPetMsgCterShowMoreTabCell")
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
            vvModel.systemMsgUpdateUIBlock = { [weak self] (dataSource:[CBPetMsgCterModel]) -> Void in
                self!.arrayDataSource = dataSource.reversed()
                for index in 0..<(self?.arrayDataSource.count)! {
                    let model = self?.arrayDataSource[index]
                    self?.arrayDataSource[index].title = "申请绑定设备提醒".localizedStr
                    self?.arrayDataSource[index].text = "用户".localizedStr + " \"\(String.init(format: "%@", model?.friendName ?? ""))\" " + "正在申请绑定设备宠物".localizedStr + " \(model?.imei ?? "")"
                    self?.arrayDataSource[index].index = index
                }
                self?.systemMsgTableView.reloadData()
                if let value = self?.arrayDataSource.count {
                    if value <= 0 {
                        self?.backgroundColor = UIColor.white
                        /* 无数据通知*/
                        let notificationName = NSNotification.Name.init(K_CBPetNoDataNotification)
                        NotificationCenter.default.post(name: notificationName, object: ["isShow":true])
                    } else {
                        self?.backgroundColor = KPetBgmColor
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
        self.systemMsgTableView.addSubview(self.noDataObjcView)
        self.noDataObjcView.snp_makeConstraints({ (make) in
            make.top.bottom.equalTo(self.systemMsgTableView)
            make.center.equalTo(self.systemMsgTableView)
            make.width.equalTo(SCREEN_WIDTH)
        })
        self.noDataObjcView.isHidden = !(self.noDataResult ?? true)
    }
//    private func scrollToBottom() {
//        /* 滚动至底部*/
//        let section = self.systemMsgTableView.numberOfSections
//        if section < 1 { return }
//        let row = self.systemMsgTableView.numberOfRows(inSection: section - 1)
//        if row < 1 { return }
//        let indexPath = IndexPath(row: row - 1, section: section - 1)
//        self.systemMsgTableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.none, animated: true)
//    }
    private func setupView() {
        self.backgroundColor = KPetBgmColor
        
        self.addSubview(self.systemMsgTableView)
        self.systemMsgTableView.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.bottom.equalTo(-TabPaddingBARHEIGHT)
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
        self.systemMsgTableView.mj_header.beginRefreshing()
    }
    func endRefresh() {
        self.systemMsgTableView.mj_header.endRefreshing()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let operateCell = tableView.dequeueReusableCell(withIdentifier: "CBPetMsgCterOperateTabCell") as! CBPetMsgCterOperateTabCell
        let longPressGes_oper = UILongPressGestureRecognizer.init(target: self, action: #selector(longPress))
        longPressGes_oper.minimumPressDuration = 1.0
        operateCell.addGestureRecognizer(longPressGes_oper)
        if self.arrayDataSource.count > indexPath.row {
            let model = self.arrayDataSource[indexPath.row]
            operateCell.msgCterSystemOpModel = model
            operateCell.dealWithBlock = { [weak self] (state:String) -> Void in
                /* 0同意 2拒绝*/
                if self?.viewModel is CBPetMsgCterViewModel {
                    let vvModel = self?.viewModel as! CBPetMsgCterViewModel
                    guard vvModel.dealWithSystemMsgBlock == nil else {
                        vvModel.dealWithSystemMsgBlock!(state,self?.arrayDataSource[indexPath.row].id ?? "")
                        return
                    }
                }
            }
        }
        return operateCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    @objc private func longPress(ges:UILongPressGestureRecognizer) {
        switch ges.state {
        case .began:
            let point = ges.location(in: self.systemMsgTableView)
            let index = self.systemMsgTableView.indexPathForRow(at: point)
            CBLog(message:"长按第\(String(describing: index))行")
            var markIndex = 0
            CBPetPopSheetView.share.selectIndex = markIndex
            CBPetPopSheetView.share.isAllowSelect = false
            CBPetPopSheetView.share.showAlert(dataSource: ["删除".localizedStr,"取消".localizedStr], completeBtnBlock: { (title:String, index:Int) in
                markIndex = index
                CBPetPopSheetView.share.selectIndex = markIndex
            })
            break
        case .ended:
            CBPetPopSheetView.share.isAllowSelect = false
            break
        default:
            break
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
