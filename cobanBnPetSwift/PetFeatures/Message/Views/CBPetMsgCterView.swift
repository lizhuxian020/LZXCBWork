//
//  CBPetMsgCterView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/4.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetMsgCterView: CBPetBaseView,UITableViewDelegate, UITableViewDataSource {
    
    public var locateString: String?

    private lazy var msgTableView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = KPetBgmColor
        tableV.separatorStyle = .none
        tableV.estimatedRowHeight = 76*KFitHeightRate
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(CBPetMsgCterTabCell.self, forCellReuseIdentifier: "CBPetMsgCterTabCell")
        tableV.mj_header = MJRefreshStateHeader()
        tableV.mj_header.setRefreshingTarget(self, refreshingAction: #selector(pullHeaderRefreshData))
        return tableV
    }()
    private lazy var arrayDataSource:[CBPetMsgCterModel] = {
        let arr = [CBPetMsgCterModel]()
        return arr
    }()
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        if self.viewModel is CBPetMsgCterViewModel {
            let homeInfo = CBPetHomeInfoTool.getHomeInfo()
            let vvModel = self.viewModel as! CBPetMsgCterViewModel
            vvModel.getNewestMessageUpdateUIBlock = { [weak self] (dataSource:[CBPetMsgCterModel]) -> Void in
                for indexx in 0..<dataSource.count {
                    let msgCterModel = dataSource[indexx]
                    for index in 0..<self!.arrayDataSource.count {
                        let model = self!.arrayDataSource[index]
                        if msgCterModel.message_type == "5" && model.title == "系统消息".localizedStr {
                            self!.arrayDataSource[index].add_time = msgCterModel.add_time
                            self!.arrayDataSource[index].countMessage = msgCterModel.countMessage
                            self!.arrayDataSource[index].message_type = msgCterModel.message_type
                        } else if msgCterModel.message_type == "7" && model.title == "围栏动态".localizedStr {
                            if msgCterModel.fence_alarm_type == "1" {
                                self!.arrayDataSource[index].text = "您的宠物".localizedStr + " \"\(homeInfo.pet.name ?? "")\" " + "离开了安全区域".localizedStr
                            } else if msgCterModel.fence_alarm_type == "2" {
                                self!.arrayDataSource[index].text = "您的宠物".localizedStr + " \"\(homeInfo.pet.name ?? "")\" " + "进入了安全区域".localizedStr
                            }
                            self!.arrayDataSource[index].add_time = msgCterModel.add_time
                            self!.arrayDataSource[index].countMessage = msgCterModel.countMessage
                            self!.arrayDataSource[index].message_type = msgCterModel.message_type
                        } else if msgCterModel.message_type == "6" && model.title == "听听记录".localizedStr {
                            self!.arrayDataSource[index].text = "您的宠物".localizedStr + " \"\(homeInfo.pet.name ?? "")\" " + "给您发来了一段语音".localizedStr
                            self!.arrayDataSource[index].add_time = msgCterModel.add_time
                            self!.arrayDataSource[index].countMessage = msgCterModel.countMessage
                            self!.arrayDataSource[index].message_type = msgCterModel.message_type
                        } else if msgCterModel.message_type == "3" && model.title == "电量动态".localizedStr {
                            self!.arrayDataSource[index].text = "您的设备".localizedStr + " \"\(homeInfo.pet.device.imei ?? "")\" " + "电量快没电了，请尽快充电...".localizedStr
                            self!.arrayDataSource[index].add_time = msgCterModel.add_time
                            self!.arrayDataSource[index].countMessage = msgCterModel.countMessage
                            self!.arrayDataSource[index].message_type = msgCterModel.message_type
                        } else if model.title == "定位记录".localizedStr {
                            self!.arrayDataSource[index].add_time = msgCterModel.add_time
                            self!.arrayDataSource[index].text = ""
                            self!.arrayDataSource[index].message_type = "2020"
                        } else if model.title == "唤醒记录".localizedStr && msgCterModel.message_type == "9" {
                            self!.arrayDataSource[index].add_time = msgCterModel.add_time
                            self!.arrayDataSource[index].countMessage = msgCterModel.countMessage
                            self!.arrayDataSource[index].text = "\(self?.locateString)"
                            self!.arrayDataSource[index].message_type = msgCterModel.message_type
                        }
                    }
                }
                self?.msgTableView.reloadData()
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
    private func setupView() {
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.msgTableView)
        self.msgTableView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        let arrayIcon = ["pet_msg_systemMsg","pet_msg_fenceDynamics",
                         "pet_msg_listenRecord","pet_msg_powerDynamics","pet_msg_locationRecord","pet_msg_wakeup_record"]
        let arrayTitle = ["系统消息".localizedStr,"围栏动态".localizedStr,
                          "听听记录".localizedStr,"电量动态".localizedStr,
                          "定位记录".localizedStr,"唤醒记录".localizedStr]
        let arrayBadge = ["2","32","43","99","124","124"]
        for index in 0..<arrayTitle.count {
            var model = CBPetMsgCterModel()
            model.iconImage = arrayIcon[index]
            model.title = arrayTitle[index]
            model.badge = arrayBadge[index]
            
            self.arrayDataSource.append(model)
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
        self.msgTableView.mj_header.beginRefreshing()
    }
    func endRefresh() {
        self.msgTableView.mj_header.endRefreshing()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetMsgCterTabCell") as! CBPetMsgCterTabCell
        if self.arrayDataSource.count > indexPath.row {
            let model = self.arrayDataSource[indexPath.row]
            cell.msgCterModel = model
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel is CBPetMsgCterViewModel {
            let model = self.arrayDataSource[indexPath.row]
            (self.viewModel as! CBPetMsgCterViewModel).pushBlock!(model)
        }
    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return self.footerView
//    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return (32+44)*KFitHeightRate
//    }
//    @objc private func logOutClick() {
//        if self.viewModel is CBPetPsnalCterViewModel {
//            guard (self.viewModel as! CBPetPsnalCterViewModel).pushBlock == nil else {
//                (self.viewModel as! CBPetPsnalCterViewModel).pushBlock!("")
//                return
//            }
//        }
//    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
